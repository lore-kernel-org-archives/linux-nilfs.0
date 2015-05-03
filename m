From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v2 5/9] nilfs2: add SUFILE cache for changes to su_nlive_blks field
Date: Sun,  3 May 2015 12:05:18 +0200
Message-ID: <1430647522-14304-6-git-send-email-andreas.rohner@gmx.net>
References: <1430647522-14304-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430647522-14304-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This patch adds a cache for the SUFILE to efficiently store lots of
small changes to su_nlive_blks in memory and apply the accumulated
results later at segment construction. This improves performance of
these operations and reduces lock contention in the SUFILE.

The implementation uses a radix_tree to store cache nodes, which
contain a certain number of values. Every value corresponds to
exactly one SUFILE entry. If the cache is flushed the values are
subtracted from the su_nlive_blks field of the corresponding SUFILE
entry.

If the parameter only_mark of the function nilfs_sufile_flush_cache() is
set, then the blocks that would have been dirtied by the flush are
marked as dirty, but nothing is actually written to them. This mode is
useful during segment construction, when blocks need to be marked dirty
in advance.

New nodes are allocated on demand. The lookup of nodes is protected by
rcu_read_lock() and the modification of values is protected by a block
group lock. This should allow for concurrent updates to the cache.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/sufile.c | 369 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/sufile.h |   5 +
 2 files changed, 374 insertions(+)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 1cce358..80bbd87 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -26,6 +26,7 @@
 #include <linux/string.h>
 #include <linux/buffer_head.h>
 #include <linux/errno.h>
+#include <linux/radix-tree.h>
 #include <linux/nilfs2_fs.h>
 #include "mdt.h"
 #include "sufile.h"
@@ -42,6 +43,11 @@ struct nilfs_sufile_info {
 	unsigned long ncleansegs;/* number of clean segments */
 	__u64 allocmin;		/* lower limit of allocatable segment range */
 	__u64 allocmax;		/* upper limit of allocatable segment range */
+
+	struct blockgroup_lock nlive_blks_cache_bgl;
+	spinlock_t nlive_blks_cache_lock;
+	int nlive_blks_cache_dirty;
+	struct radix_tree_root nlive_blks_cache;
 };
 
 static inline struct nilfs_sufile_info *NILFS_SUI(struct inode *sufile)
@@ -1194,6 +1200,362 @@ out_sem:
 }
 
 /**
+ * nilfs_sufile_alloc_cache_node - allocate and insert a new cache node
+ * @sufile: inode of segment usage file
+ * @group: group to allocate a node for
+ *
+ * Description: Allocates a new cache node and inserts it into the cache. If
+ * there is an error, nothing will be allocated. If there already exists
+ * a node for @group, no new node will be allocated.
+ *
+ * Return Value: On success, 0 is returned, on error, one of the following
+ * negative error codes is returned.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+static int nilfs_sufile_alloc_cache_node(struct inode *sufile,
+					 unsigned long group)
+{
+	struct nilfs_sufile_info *sui = NILFS_SUI(sufile);
+	struct nilfs_sufile_cache_node *node;
+	int ret;
+
+	node = kmem_cache_alloc(nilfs_sufile_node_cachep, GFP_NOFS);
+	if (!node)
+		return -ENOMEM;
+
+	ret = radix_tree_preload(GFP_NOFS);
+	if (ret)
+		goto free_node;
+
+	spin_lock(&sui->nlive_blks_cache_lock);
+	ret = radix_tree_insert(&sui->nlive_blks_cache, group, node);
+	spin_unlock(&sui->nlive_blks_cache_lock);
+
+	radix_tree_preload_end();
+
+	if (ret == -EEXIST) {
+		ret = 0;
+		goto free_node;
+	} else if (ret)
+		goto free_node;
+
+	return 0;
+free_node:
+	kmem_cache_free(nilfs_sufile_node_cachep, node);
+	return ret;
+}
+
+/**
+ * nilfs_sufile_dec_nlive_blks - decrements nlive_blks in the cache
+ * @sufile: inode of segment usage file
+ * @segnum: segnum for which nlive_blks will be decremented
+ *
+ * Description: Decrements the number of live blocks for @segnum in the cache.
+ * This function only affects the cache. If the cache is not flushed at a
+ * later time the changes are lost. It tries to lookup the group node to
+ * which the @segnum belongs in a lock free manner and uses a blockgroup lock
+ * to do the actual modification on the node.
+ *
+ * Return Value: On success, 0 is returned on error, one of the following
+ * negative error codes is returned.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_sufile_dec_nlive_blks(struct inode *sufile, __u64 segnum)
+{
+	struct nilfs_sufile_info *sui = NILFS_SUI(sufile);
+	struct nilfs_sufile_cache_node *node;
+	spinlock_t *lock;
+	unsigned long group;
+	int ret;
+
+	group = (unsigned long)(segnum >> NILFS_SUFILE_CACHE_NODE_SHIFT);
+
+try_again:
+	rcu_read_lock();
+	node = radix_tree_lookup(&sui->nlive_blks_cache, group);
+	if (!node) {
+		rcu_read_unlock();
+
+		ret = nilfs_sufile_alloc_cache_node(sufile, group);
+		if (ret)
+			return ret;
+
+		/*
+		 * It is important to acquire the rcu_read_lock() before using
+		 * the node pointer
+		 */
+		goto try_again;
+	}
+
+	lock = bgl_lock_ptr(&sui->nlive_blks_cache_bgl, (unsigned int)group);
+	spin_lock(lock);
+	node->values[segnum & ((1 << NILFS_SUFILE_CACHE_NODE_SHIFT) - 1)] += 1;
+	sui->nlive_blks_cache_dirty = 1;
+	spin_unlock(lock);
+	rcu_read_unlock();
+
+	return 0;
+}
+
+/**
+ * nilfs_sufile_flush_cache_node - flushes one cache node to the SUFILE
+ * @sufile: inode of segment usage file
+ * @node: cache node to flush
+ * @only_mark: do not write anything, but mark the blocks as dirty
+ * @pndirty_blks: pointer to return number of dirtied blocks
+ *
+ * Description: Flushes one cache node to the SUFILE and also clears the cache
+ * node at the same time. If @only_mark is 1, nothing is written to the
+ * SUFILE, but the blocks are still marked as dirty. This is useful to mark
+ * the blocks in one phase of the segment creation and write them in another.
+ *
+ * Return Value: On success, 0 is returned on error, one of the following
+ * negative error codes is returned.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ *
+ * %-EIO - I/O error
+ *
+ * %-EROFS - Read only filesystem (for create mode)
+ */
+static int nilfs_sufile_flush_cache_node(struct inode *sufile,
+					 struct nilfs_sufile_cache_node *node,
+					 int only_mark,
+					 unsigned long *pndirty_blks)
+{
+	struct nilfs_sufile_info *sui = NILFS_SUI(sufile);
+	struct buffer_head *su_bh;
+	struct nilfs_segment_usage *su;
+	spinlock_t *lock;
+	void *kaddr;
+	size_t n, i, j;
+	size_t susz = NILFS_MDT(sufile)->mi_entry_size;
+	__u64 segnum, seg_start, nsegs;
+	__u32 nlive_blocks, value;
+	unsigned long secs = get_seconds(), ndirty_blks = 0;
+	int ret, dirty;
+
+	nsegs = nilfs_sufile_get_nsegments(sufile);
+	seg_start = node->index << NILFS_SUFILE_CACHE_NODE_SHIFT;
+	lock = bgl_lock_ptr(&sui->nlive_blks_cache_bgl, node->index);
+
+	for (i = 0; i < NILFS_SUFILE_CACHE_NODE_COUNT;) {
+		segnum = seg_start + i;
+		if (segnum >= nsegs)
+			break;
+
+		n = nilfs_sufile_segment_usages_in_block(sufile, segnum,
+				seg_start + NILFS_SUFILE_CACHE_NODE_COUNT - 1);
+
+		ret = nilfs_sufile_get_segment_usage_block(sufile, segnum,
+							   0, &su_bh);
+		if (ret < 0) {
+			if (ret != -ENOENT)
+				return ret;
+			/* hole */
+			i += n;
+			continue;
+		}
+
+		if (only_mark && buffer_dirty(su_bh)) {
+			/* buffer already dirty */
+			put_bh(su_bh);
+			i += n;
+			continue;
+		}
+
+		spin_lock(lock);
+		kaddr = kmap_atomic(su_bh->b_page);
+
+		dirty = 0;
+		su = nilfs_sufile_block_get_segment_usage(sufile, segnum,
+							  su_bh, kaddr);
+		for (j = 0; j < n; ++j, ++i, su = (void *)su + susz) {
+			value = node->values[i];
+			if (!value)
+				continue;
+			if (!only_mark)
+				node->values[i] = 0;
+
+			WARN_ON(nilfs_segment_usage_error(su));
+
+			nlive_blocks = le32_to_cpu(su->su_nlive_blks);
+			if (!nlive_blocks)
+				continue;
+
+			dirty = 1;
+			if (only_mark) {
+				i += n - j;
+				break;
+			}
+
+			if (nlive_blocks <= value)
+				nlive_blocks = 0;
+			else
+				nlive_blocks -= value;
+
+			su->su_nlive_blks = cpu_to_le32(nlive_blocks);
+			su->su_nlive_lastmod = cpu_to_le64(secs);
+		}
+
+		kunmap_atomic(kaddr);
+		spin_unlock(lock);
+
+		if (dirty && !buffer_dirty(su_bh)) {
+			mark_buffer_dirty(su_bh);
+			nilfs_mdt_mark_dirty(sufile);
+			++ndirty_blks;
+		}
+
+		put_bh(su_bh);
+	}
+
+	*pndirty_blks += ndirty_blks;
+	return 0;
+}
+
+/**
+ * nilfs_sufile_flush_cache - flushes cache to the SUFILE
+ * @sufile: inode of segment usage file
+ * @only_mark: do not write anything, but mark the blocks as dirty
+ * @pndirty_blks: pointer to return number of dirtied blocks
+ *
+ * Description: Flushes the whole cache to the SUFILE and also clears it
+ * at the same time. If @only_mark is 1, nothing is written to the
+ * SUFILE, but the blocks are still marked as dirty. This is useful to mark
+ * the blocks in one phase of the segment creation and write them in another.
+ * If there are concurrent inserts into the cache, it cannot be guaranteed,
+ * that everything is flushed when the function returns.
+ *
+ * Return Value: On success, 0 is returned on error, one of the following
+ * negative error codes is returned.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ *
+ * %-EIO - I/O error
+ *
+ * %-EROFS - Read only filesystem (for create mode)
+ */
+int nilfs_sufile_flush_cache(struct inode *sufile, int only_mark,
+			     unsigned long *pndirty_blks)
+{
+	struct nilfs_sufile_info *sui = NILFS_SUI(sufile);
+	struct nilfs_sufile_cache_node *node;
+	LIST_HEAD(nodes);
+	struct radix_tree_iter iter;
+	void **slot;
+	unsigned long ndirty_blks = 0;
+	int ret = 0;
+
+	if (!sui->nlive_blks_cache_dirty)
+		goto out;
+
+	down_write(&NILFS_MDT(sufile)->mi_sem);
+
+	/* prevent concurrent inserts */
+	spin_lock(&sui->nlive_blks_cache_lock);
+	radix_tree_for_each_slot(slot, &sui->nlive_blks_cache, &iter, 0) {
+		node = radix_tree_deref_slot_protected(slot,
+				&sui->nlive_blks_cache_lock);
+		if (!node)
+			continue;
+		if (radix_tree_exception(node))
+			continue;
+
+		list_add(&node->list_head, &nodes);
+		node->index = iter.index;
+	}
+	if (!only_mark)
+		sui->nlive_blks_cache_dirty = 0;
+	spin_unlock(&sui->nlive_blks_cache_lock);
+
+	list_for_each_entry(node, &nodes, list_head) {
+		ret = nilfs_sufile_flush_cache_node(sufile, node, only_mark,
+						    &ndirty_blks);
+		if (ret)
+			goto out_sem;
+	}
+
+out_sem:
+	up_write(&NILFS_MDT(sufile)->mi_sem);
+out:
+	if (pndirty_blks)
+		*pndirty_blks = ndirty_blks;
+	return ret;
+}
+
+/**
+ * nilfs_sufile_cache_dirty - is the sufile cache dirty
+ * @sufile: inode of segment usage file
+ *
+ * Description: Returns whether the sufile cache is dirty. If this flag is
+ * true, the cache contains unflushed content.
+ *
+ * Return Value: If the cache is not dirty, 0 is returned, otherwise
+ * 1 is returned
+ */
+int nilfs_sufile_cache_dirty(struct inode *sufile)
+{
+	struct nilfs_sufile_info *sui = NILFS_SUI(sufile);
+
+	return sui->nlive_blks_cache_dirty;
+}
+
+/**
+ * nilfs_sufile_cache_node_release_rcu - rcu callback function to free nodes
+ * @head: rcu head
+ *
+ * Description: Rcu callback function to free nodes.
+ */
+static void nilfs_sufile_cache_node_release_rcu(struct rcu_head *head)
+{
+	struct nilfs_sufile_cache_node *node;
+
+	node = container_of(head, struct nilfs_sufile_cache_node, rcu_head);
+
+	kmem_cache_free(nilfs_sufile_node_cachep, node);
+}
+
+/**
+ * nilfs_sufile_shrink_cache - free all cache nodes
+ * @sufile: inode of segment usage file
+ *
+ * Description: Frees all cache nodes in the cache regardless of their
+ * content. The content will not be flushed and may be lost. This function
+ * is intended to free up memory after the cache was flushed by
+ * nilfs_sufile_flush_cache().
+ */
+void nilfs_sufile_shrink_cache(struct inode *sufile)
+{
+	struct nilfs_sufile_info *sui = NILFS_SUI(sufile);
+	struct nilfs_sufile_cache_node *node;
+	struct radix_tree_iter iter;
+	void **slot;
+
+	/* prevent flush form running at the same time */
+	down_read(&NILFS_MDT(sufile)->mi_sem);
+	/* prevent concurrent inserts */
+	spin_lock(&sui->nlive_blks_cache_lock);
+
+	radix_tree_for_each_slot(slot, &sui->nlive_blks_cache, &iter, 0) {
+		node = radix_tree_deref_slot_protected(slot,
+				&sui->nlive_blks_cache_lock);
+		if (!node)
+			continue;
+		if (radix_tree_exception(node))
+			continue;
+
+		radix_tree_delete(&sui->nlive_blks_cache, iter.index);
+		call_rcu(&node->rcu_head, nilfs_sufile_cache_node_release_rcu);
+	}
+
+	spin_unlock(&sui->nlive_blks_cache_lock);
+	up_read(&NILFS_MDT(sufile)->mi_sem);
+}
+
+/**
  * nilfs_sufile_read - read or get sufile inode
  * @sb: super block instance
  * @susize: size of a segment usage entry
@@ -1253,6 +1615,13 @@ int nilfs_sufile_read(struct super_block *sb, size_t susize,
 	sui->allocmax = nilfs_sufile_get_nsegments(sufile) - 1;
 	sui->allocmin = 0;
 
+	if (nilfs_feature_track_live_blks(sb->s_fs_info)) {
+		bgl_lock_init(&sui->nlive_blks_cache_bgl);
+		spin_lock_init(&sui->nlive_blks_cache_lock);
+		INIT_RADIX_TREE(&sui->nlive_blks_cache, GFP_ATOMIC);
+	}
+	sui->nlive_blks_cache_dirty = 0;
+
 	unlock_new_inode(sufile);
  out:
 	*inodep = sufile;
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index 520614f..662ab56 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -87,6 +87,11 @@ int nilfs_sufile_resize(struct inode *sufile, __u64 newnsegs);
 int nilfs_sufile_read(struct super_block *sb, size_t susize,
 		      struct nilfs_inode *raw_inode, struct inode **inodep);
 int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range);
+int nilfs_sufile_dec_nlive_blks(struct inode *sufile, __u64 segnum);
+void nilfs_sufile_shrink_cache(struct inode *sufile);
+int nilfs_sufile_flush_cache(struct inode *sufile, int only_mark,
+			     unsigned long *pndirty_blks);
+int nilfs_sufile_cache_dirty(struct inode *sufile);
 
 /**
  * nilfs_sufile_scrap - make a segment garbage
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
