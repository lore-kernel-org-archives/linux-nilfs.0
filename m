From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/9] nilfs2: add comparison function of two block mappings
Date: Mon, 16 May 2011 18:05:15 +0900
Message-ID: <1305536722-1311-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1305536722-1311-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305536722-1311-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This adds nilfs_bmap_compare() function and its helper routine
(nilfs_bmap_do_compare function).  The nilfs_bmap_compare function
enumerates changes on the data blocks that given two bmap objects
hold.  These functions are available to efficiently find out changes
on meta-data or user data between two checkpoints.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.c |  154 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/bmap.h |   15 +++++
 2 files changed, 169 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index aadbd0b..84c4866 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -422,6 +422,160 @@ int nilfs_bmap_test_and_clear_dirty(struct nilfs_bmap *bmap)
 	return ret;
 }
 
+static ssize_t nilfs_bmap_do_compare(struct nilfs_bmap *bmap1,
+				     struct nilfs_bmap *bmap2, __u64 start,
+				     struct nilfs_bmap_diff *diffs,
+				     size_t maxdiffs)
+{
+	__u64 key1, key2;
+	__u64 ptr1, ptr2;
+	void *ctx1, *ctx2;
+	ssize_t n = 0;
+	int next1 = false, next2 = false;
+	int done1 = false, done2 = false;
+	int ret;
+
+	key1 = start;
+	ret = bmap1->b_ops->bop_find(bmap1, &key1, &ptr1, &ctx1);
+	if (ret < 0) {
+		if (ret != -ENOENT) {
+			n = ret;
+			goto out;
+		}
+		done1 = true;
+		ctx1 = NULL; /* ensure ->bop_find_close(bmap1, ctx1) safe */
+	}
+
+	key2 = start;
+	ret = bmap2->b_ops->bop_find(bmap2, &key2, &ptr2, &ctx2);
+	if (ret < 0) {
+		if (ret != -ENOENT) {
+			n = ret;
+			goto out;
+		}
+		done2 = true;
+		ctx2 = NULL; /* ensure ->bop_find_close(bmap2, ctx2) safe */
+	}
+
+	while (1) {
+		if (done1) {
+			if (done2)
+				break;
+			
+			diffs[n].key = key2;
+			diffs[n].ptr1 = NILFS_BMAP_INVALID_PTR;
+			diffs[n].ptr2 = ptr2;
+			next2 = true;
+		} else if (done2) {
+			diffs[n].key = key1;
+			diffs[n].ptr1 = ptr1;
+			diffs[n].ptr2 = NILFS_BMAP_INVALID_PTR;
+			next1 = true;
+		} else if (key1 == key2) {
+			next1 = true;
+			next2 = true;
+
+			if (ptr1 == ptr2)
+				goto lookup_next;
+
+			diffs[n].key = key1;
+			diffs[n].ptr1 = ptr1;
+			diffs[n].ptr2 = ptr2;
+		} else if (key1 < key2) {
+			diffs[n].key = key1;
+			diffs[n].ptr1 = ptr1;
+			diffs[n].ptr2 = NILFS_BMAP_INVALID_PTR;
+			next1 = true;
+		} else /* key1 > key2 */ {
+			diffs[n].key = key2;
+			diffs[n].ptr1 = NILFS_BMAP_INVALID_PTR;
+			diffs[n].ptr2 = ptr2;
+			next2 = true;
+		}
+
+		n++;
+		if (n == maxdiffs)
+			break;
+
+	lookup_next:
+		if (next1) {
+			ret = bmap1->b_ops->bop_find_next(bmap1, &key1,
+							  &ptr1, ctx1);
+			if (ret < 0) {
+				if (ret != -ENOENT) {
+					n = ret;
+					break;
+				}
+				done1 = true;
+			}
+			next1 = false;
+		}
+		if (next2) {
+			ret = bmap2->b_ops->bop_find_next(bmap2, &key2,
+							  &ptr2, ctx2);
+			if (ret < 0) {
+				if (ret != -ENOENT) {
+					n = ret;
+					break;
+				}
+				done2 = true;
+			}
+			next2 = false;
+		}
+	}
+out:
+	bmap2->b_ops->bop_find_close(bmap2, ctx2);
+	bmap1->b_ops->bop_find_close(bmap1, ctx1);
+	return n;
+}
+
+/**
+ * nilfs_bmap_compare - compare two bmaps and find their differences
+ * @bmap1: source bmap
+ * @bmap2: target bmap
+ * @start: start key
+ * @diffs: pointer to an array of nilfs_bmap_diff structures
+ * @maxdiffs: number of nilfs_bmap_diff structures
+ *
+ * Description: nilfs_bmap_compare() compares two versions of bmap and
+ * stores their differences in nilfs_bmap_diff structures given by
+ * @diffs and @maxdiffs.
+ *
+ * Return Value: On success, number of items stored to @diffs are
+ * returned.  On error, one of the following negative error codes are
+ * returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+ssize_t nilfs_bmap_compare(struct nilfs_bmap *bmap1, struct nilfs_bmap *bmap2,
+			   __u64 start, struct nilfs_bmap_diff *diffs,
+			   size_t maxdiffs)
+{
+	ssize_t ret;
+
+	if (maxdiffs == 0)
+		return 0;
+
+	/*
+	 * hold semaphore with smaller address first to avoid possible
+	 * deadlock problem.
+	 */
+	if (bmap1 < bmap2) {
+		down_read(&bmap1->b_sem);
+		down_read(&bmap2->b_sem);
+	} else {
+		down_read(&bmap2->b_sem);
+		down_read(&bmap1->b_sem);
+	}
+
+	ret = nilfs_bmap_do_compare(bmap1, bmap2, start, diffs, maxdiffs);
+
+	up_read(&bmap1->b_sem);
+	up_read(&bmap2->b_sem);
+	return ret;
+}
 
 /*
  * Internal use only
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index cff22c2..2e57537 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -56,6 +56,18 @@ struct nilfs_bmap_stats {
 };
 
 /**
+ * struct nilfs_bmap_diff - array item to store bmap comparison result
+ * @key: key index
+ * @ptr: bmap pointer 1
+ * @ptr: bmap pointer 2
+ */
+struct nilfs_bmap_diff {
+	__u64 key;
+	__u64 ptr1;
+	__u64 ptr2;
+};
+
+/**
  * struct nilfs_bmap_operations - bmap operation table
  */
 struct nilfs_bmap_operations {
@@ -162,6 +174,9 @@ int nilfs_bmap_assign(struct nilfs_bmap *, struct buffer_head **,
 		      unsigned long, union nilfs_binfo *);
 int nilfs_bmap_lookup_at_level(struct nilfs_bmap *, __u64, int, __u64 *);
 int nilfs_bmap_mark(struct nilfs_bmap *, __u64, int);
+ssize_t nilfs_bmap_compare(struct nilfs_bmap *bmap1, struct nilfs_bmap *bmap2,
+			   __u64 start, struct nilfs_bmap_diff *diffs,
+			   size_t maxdiffs);
 
 void nilfs_bmap_init_gc(struct nilfs_bmap *);
 
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
