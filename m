From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/9] nilfs2: add ifile method to find and get modified inodes
Date: Mon, 16 May 2011 18:05:17 +0900
Message-ID: <1305536722-1311-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This adds a few routines to ifile, which are used to find out created,
deleted, or modifed inodes between two versions of ifile, and
enumerate the changes.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/ifile.c |  184 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/ifile.h |   20 ++++++
 2 files changed, 204 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index 684d763..8980149 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -155,6 +155,190 @@ int nilfs_ifile_get_inode_block(struct inode *ifile, ino_t ino,
 	return err;
 }
 
+static ssize_t
+nilfs_ifile_compare_block(struct inode *ifile1, struct inode *ifile2,
+			  ino_t start, const struct nilfs_bmap_diff *diff,
+			  struct nilfs_ifile_change *changes,
+			  size_t maxchanges)
+{
+	struct buffer_head *ibh1 = NULL, *ibh2 = NULL;
+	struct nilfs_inode *raw_inode1, *raw_inode2;
+	void *kaddr1, *kaddr2;
+	size_t isz = NILFS_MDT(ifile1)->mi_entry_size;
+	__u64 nr;
+	ino_t ino, end;
+	int t;
+	int ret;
+	ssize_t n = 0;
+
+	t = nilfs_palloc_block_type(ifile1, diff->key, &nr);
+	if (t != NILFS_PALLOC_ENTRY_BLOCK)
+		goto out;
+
+	ino = max_t(ino_t, nr, start);
+	end = nr + NILFS_MDT(ifile1)->mi_entries_per_block - 1;
+	if (ino > end)
+		goto out;
+
+	if (diff->ptr1 != NILFS_BMAP_INVALID_PTR) {
+		ret = nilfs_palloc_get_entry_block(ifile1, nr, 0, &ibh1);
+		if (ret < 0) {
+			WARN_ON(ret == -ENOENT); /* ifile is broken */
+			n = ret;
+			goto out;
+		}
+	}
+	if (diff->ptr2 != NILFS_BMAP_INVALID_PTR) {
+		ret = nilfs_palloc_get_entry_block(ifile2, nr, 0, &ibh2);
+		if (ret < 0) {
+			WARN_ON(ret == -ENOENT); /* ifile is broken */
+			n = ret;
+			brelse(ibh1); /* brelse(NULL) is ignored */
+			goto out;
+		}
+	}
+
+	if (!ibh1) {
+		if (!ibh2)
+			goto out_bh;
+
+		kaddr2 = kmap_atomic(ibh2->b_page, KM_USER0);
+		raw_inode2 = nilfs_palloc_block_get_entry(ifile2, ino, ibh2,
+							  kaddr2);
+		for ( ; ino <= end; ino++) {
+			if (le16_to_cpu(raw_inode2->i_links_count)) {
+				changes[n].ino = ino;
+				changes[n].bh1 = NULL;
+				get_bh(ibh2);
+				changes[n].bh2 = ibh2;
+				n++;
+				if (n == maxchanges)
+					break;
+			}
+			raw_inode2 = (void *)raw_inode2 + isz;
+		}
+		kunmap_atomic(kaddr2, KM_USER0);
+
+	} else if (!ibh2) {
+		kaddr1 = kmap_atomic(ibh1->b_page, KM_USER0);
+		raw_inode1 = nilfs_palloc_block_get_entry(ifile1, ino, ibh1,
+							  kaddr1);
+		for ( ; ino <= end; ino++) {
+			if (le16_to_cpu(raw_inode1->i_links_count)) {
+				changes[n].ino = ino;
+				get_bh(ibh1);
+				changes[n].bh1 = ibh1;
+				changes[n].bh2 = NULL;
+				n++;
+				if (n == maxchanges)
+					break;
+			}
+			raw_inode1 = (void *)raw_inode1 + isz;
+		}
+		kunmap_atomic(kaddr1, KM_USER0);
+	} else {
+		kaddr1 = kmap_atomic(ibh1->b_page, KM_USER0);
+		raw_inode1 = nilfs_palloc_block_get_entry(ifile1, ino, ibh1,
+							  kaddr1);
+		kaddr2 = kmap_atomic(ibh2->b_page, KM_USER1);
+		raw_inode2 = nilfs_palloc_block_get_entry(ifile2, ino, ibh2,
+							  kaddr2);
+		for (; ino <= end; ino++) {
+			if (raw_inode1->i_ctime_nsec !=
+			    raw_inode2->i_ctime_nsec ||
+			    raw_inode1->i_ctime != raw_inode2->i_ctime) {
+				changes[n].ino = ino;
+				if (le16_to_cpu(raw_inode1->i_links_count)) {
+					get_bh(ibh1);
+					changes[n].bh1 = ibh1;
+				} else {
+					changes[n].bh1 = NULL;
+				}
+				if (le16_to_cpu(raw_inode2->i_links_count)) {
+					get_bh(ibh2);
+					changes[n].bh2 = ibh2;
+				} else {
+					changes[n].bh2 = NULL;
+				}
+				n++;
+				if (n == maxchanges)
+					break;
+			}
+			raw_inode1 = (void *)raw_inode1 + isz;
+			raw_inode2 = (void *)raw_inode2 + isz;
+		}
+		kunmap_atomic(kaddr1, KM_USER0);
+		kunmap_atomic(kaddr2, KM_USER1);
+	}
+out_bh:
+	brelse(ibh1);
+	brelse(ibh2);
+out:
+	return n;
+}
+
+/**
+ * nilfs_ifile_compare - compare two ifiles and find modified inodes
+ * @ifile1: source ifile inode
+ * @ifile2: target ifile inode
+ * @start: start inode number
+ * @changes: buffer to store nilfs_ifile_change structures
+ * @maxchanges: maximum number of changes that can be stored in @changes
+ */
+ssize_t nilfs_ifile_compare(struct inode *ifile1, struct inode *ifile2,
+			    ino_t start, struct nilfs_ifile_change *changes,
+			    size_t maxchanges)
+{
+	struct nilfs_bmap_diff *diffs;
+	__u64 blkoff;
+	size_t maxdiffs;
+	ssize_t nc = 0, nd, n;
+	int i;
+
+	diffs = (struct nilfs_bmap_diff *)__get_free_pages(GFP_NOFS, 0);
+	if (unlikely(!diffs))
+		return -ENOMEM;
+
+	maxdiffs = PAGE_SIZE / sizeof(*diffs);
+
+	blkoff = nilfs_palloc_entry_blkoff(ifile1, start);
+
+	do {
+		nd = nilfs_bmap_compare(NILFS_I(ifile1)->i_bmap,
+					NILFS_I(ifile2)->i_bmap,
+					blkoff, diffs, maxdiffs);
+		if (nd < 0) {
+			nc = nd;
+			break;
+		}
+		if (nd == 0)
+			break;
+		for (i = 0; i < nd; i++) {
+			n = nilfs_ifile_compare_block(
+				ifile1, ifile2, start, &diffs[i],
+				&changes[nc], maxchanges - nc);
+			if (n < 0) {
+				nc = n;
+				goto failed;
+			}
+			nc += n;
+			if (nc == maxchanges)
+				goto out;
+		}
+		blkoff = diffs[i - 1].key + 1;
+	} while (nd == maxdiffs);
+out:
+	free_pages((unsigned long)diffs, 0);
+	return nc;
+
+failed:
+	for (i = 0; i < nc; i++) {
+		brelse(changes[i].bh1);
+		brelse(changes[i].bh2);
+	}
+	goto out;
+}
+
 /**
  * nilfs_ifile_read - read or get ifile inode
  * @sb: super block instance
diff --git a/fs/nilfs2/ifile.h b/fs/nilfs2/ifile.h
index 59b6f2b..fe63ae8 100644
--- a/fs/nilfs2/ifile.h
+++ b/fs/nilfs2/ifile.h
@@ -32,6 +32,22 @@
 #include "alloc.h"
 
 
+/**
+ * struct nilfs_ifile_change - array item to store ifile comparison result
+ * @ino: inode number
+ * @bh1: pointers to buffer heads having source of changed disk inode
+ * @bh2: pointers to buffer heads having target of changed disk inode
+ *
+ * For new inodes, ptr array becomes @bh1 == NULL and @bh2 != NULL.
+ * For deleted inodes, ptr array becomes @bh1 != NULL and @bh2 == NULL.
+ * For modifed inodes, both @bh1 and @bh2 point to a valid item.
+ */
+struct nilfs_ifile_change {
+	ino_t ino;
+	struct buffer_head *bh1;
+	struct buffer_head *bh2;
+};
+
 static inline struct nilfs_inode *
 nilfs_ifile_map_inode(struct inode *ifile, ino_t ino, struct buffer_head *ibh)
 {
@@ -49,6 +65,10 @@ int nilfs_ifile_create_inode(struct inode *, ino_t *, struct buffer_head **);
 int nilfs_ifile_delete_inode(struct inode *, ino_t);
 int nilfs_ifile_get_inode_block(struct inode *, ino_t, struct buffer_head **);
 
+ssize_t nilfs_ifile_compare(struct inode *ifile1, struct inode *ifile2,
+			    ino_t start, struct nilfs_ifile_change *buf,
+			    size_t maxchanges);
+
 int nilfs_ifile_read(struct super_block *sb, struct nilfs_root *root,
 		     size_t inode_size, struct nilfs_inode *raw_inode,
 		     struct inode **inodep);
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
