From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 7/7] nilfs2: free unused dat file blocks during garbage collection
Date: Sat, 19 Sep 2015 19:33:02 +0900
Message-ID: <1442658782-3147-8-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1442658782-3147-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=5ht7T7IgX1NErSFZ3JgtdrjSTvMJHZbqRh9cpYdxONU=;
        b=sxlUJtQyQXBH5h5xvggWkbvzApietCpbFYUfvufINY4pn3rkq8g3Lxbe89kxXTNYZA
         3TRZs1JOCACC0oIotWyWCpQscuE/3LhgTGcRo5p4UIdZp1HGzRafov5cTYhsNy7DEfTD
         8jkzz3GQAcLEF7LC2Bx9Y9KPlqSXHXI5BUxA8ptjdGKnSdFjDgBMIO88IIi8rbS3fvQt
         O8YnS4872nA8SlGmHlsUTITVNJxiyynZyX/9rTXge/jhH0dKcM9ulnkatG8pzcYoao5B
         0tTP/WGKPVptUaoEbwXEu6yv+CXBfD7H48eoZKQWcJNxnrL2XCOoI0t7nqOw3rMWto46
         OPtQ==
In-Reply-To: <1442658782-3147-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nilfs <linux-nilfs@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

As a nilfs2 volume ages, the amount of available disk space
decreases little by little due to bloat of DAT (disk address
translation) metadata file.  Even if we delete all files in a file
system and free their block addresses from the DAT file through a
garbage collection, empty DAT blocks are not freed.

This fixes the issue by extending the deallocator of block addresses
so that empty data blocks and empty bitmap blocks of DAT are deleted.

The following comparison shows the effect of this patch.  Each shows
disk amount information of a nilfs2 volume that we cleaned out by
deleting all files and running gc after having filled 90% of its
capacity.

Before:
Filesystem     1K-blocks     Used Available Use% Mounted on
/dev/sda1      500105212  3022844 472072192   1% /test

After:
Filesystem     1K-blocks     Used Available Use% Mounted on
/dev/sda1      500105212    16380 475078656   1% /test

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/alloc.c | 91 ++++++++++++++++++++++++++++++++++++++++++++-----------
 fs/nilfs2/alloc.h |  1 +
 2 files changed, 75 insertions(+), 17 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 225b797..b335a32 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -154,13 +154,17 @@ nilfs_palloc_group_desc_nfrees(const struct nilfs_palloc_group_desc *desc,
  * @lock: spin lock protecting @desc
  * @n: delta to be added
  */
-static void
+static u32
 nilfs_palloc_group_desc_add_entries(struct nilfs_palloc_group_desc *desc,
 				    spinlock_t *lock, u32 n)
 {
+	u32 nfree;
+
 	spin_lock(lock);
 	le32_add_cpu(&desc->pg_nfrees, n);
+	nfree = le32_to_cpu(desc->pg_nfrees);
 	spin_unlock(lock);
+	return nfree;
 }
 
 /**
@@ -735,12 +739,18 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 	unsigned char *bitmap;
 	void *desc_kaddr, *bitmap_kaddr;
 	unsigned long group, group_offset;
-	__u64 group_min_nr;
+	__u64 group_min_nr, last_nrs[8];
 	const unsigned long epg = nilfs_palloc_entries_per_group(inode);
+	const unsigned epb = NILFS_MDT(inode)->mi_entries_per_block;
+	unsigned entry_start, end, pos;
 	spinlock_t *lock;
-	int i, j, n, ret;
+	int i, j, k, ret;
+	u32 nfree;
 
 	for (i = 0; i < nitems; i = j) {
+		int change_group = false;
+		int nempties = 0, n = 0;
+
 		group = nilfs_palloc_group(inode, entry_nrs[i], &group_offset);
 		ret = nilfs_palloc_get_desc_block(inode, group, 0, &desc_bh);
 		if (ret < 0)
@@ -755,17 +765,13 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 		/* Get the first entry number of the group */
 		group_min_nr = (__u64)group * epg;
 
-		desc_kaddr = kmap(desc_bh->b_page);
-		desc = nilfs_palloc_block_get_group_desc(
-			inode, group, desc_bh, desc_kaddr);
 		bitmap_kaddr = kmap(bitmap_bh->b_page);
 		bitmap = bitmap_kaddr + bh_offset(bitmap_bh);
 		lock = nilfs_mdt_bgl_lock(inode, group);
-		for (j = i, n = 0;
-		     j < nitems && entry_nrs[j] >= group_min_nr &&
-			     entry_nrs[j] < group_min_nr + epg;
-		     j++) {
-			group_offset = entry_nrs[j] - group_min_nr;
+
+		j = i;
+		entry_start = rounddown(group_offset, epb);
+		do {
 			if (!nilfs_clear_bit_atomic(lock, group_offset,
 						    bitmap)) {
 				nilfs_warning(inode->i_sb, __func__,
@@ -775,18 +781,69 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 			} else {
 				n++;
 			}
-		}
-		nilfs_palloc_group_desc_add_entries(desc, lock, n);
+
+			j++;
+			if (j >= nitems || entry_nrs[j] < group_min_nr ||
+			    entry_nrs[j] >= group_min_nr + epg) {
+				change_group = true;
+			} else {
+				group_offset = entry_nrs[j] - group_min_nr;
+				if (group_offset >= entry_start &&
+				    group_offset < entry_start + epb) {
+					/* This entry is in the same block */
+					continue;
+				}
+			}
+
+			/* Test if the entry block is empty or not */
+			end = entry_start + epb;
+			pos = nilfs_find_next_bit(bitmap, end, entry_start);
+			if (pos >= end) {
+				last_nrs[nempties++] = entry_nrs[j - 1];
+				if (nempties >= ARRAY_SIZE(last_nrs))
+					break;
+			}
+
+			if (change_group)
+				break;
+
+			/* Go on to the next entry block */
+			entry_start = rounddown(group_offset, epb);
+		} while (true);
 
 		kunmap(bitmap_bh->b_page);
-		kunmap(desc_bh->b_page);
+		mark_buffer_dirty(bitmap_bh);
+		brelse(bitmap_bh);
 
+		for (k = 0; k < nempties; k++) {
+			ret = nilfs_palloc_delete_entry_block(inode,
+							      last_nrs[k]);
+			if (ret && ret != -ENOENT) {
+				nilfs_warning(inode->i_sb, __func__,
+					      "failed to delete block of entry %llu: ino=%lu, err=%d\n",
+					      (unsigned long long)last_nrs[k],
+					      (unsigned long)inode->i_ino, ret);
+			}
+		}
+
+		desc_kaddr = kmap_atomic(desc_bh->b_page);
+		desc = nilfs_palloc_block_get_group_desc(
+			inode, group, desc_bh, desc_kaddr);
+		nfree = nilfs_palloc_group_desc_add_entries(desc, lock, n);
+		kunmap_atomic(desc_kaddr);
 		mark_buffer_dirty(desc_bh);
-		mark_buffer_dirty(bitmap_bh);
 		nilfs_mdt_mark_dirty(inode);
-
-		brelse(bitmap_bh);
 		brelse(desc_bh);
+
+		if (nfree == nilfs_palloc_entries_per_group(inode)) {
+			ret = nilfs_palloc_delete_bitmap_block(inode, group);
+			if (ret && ret != -ENOENT) {
+				nilfs_warning(inode->i_sb, __func__,
+					      "failed to delete bitmap block of group %lu: ino=%lu, err=%d\n",
+					      group,
+					      (unsigned long)inode->i_ino, ret);
+			}
+		}
 	}
 	return 0;
 }
diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index 4bd6451..6e6f49a 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -77,6 +77,7 @@ int nilfs_palloc_freev(struct inode *, __u64 *, size_t);
 #define nilfs_set_bit_atomic		ext2_set_bit_atomic
 #define nilfs_clear_bit_atomic		ext2_clear_bit_atomic
 #define nilfs_find_next_zero_bit	find_next_zero_bit_le
+#define nilfs_find_next_bit		find_next_bit_le
 
 /**
  * struct nilfs_bh_assoc - block offset and buffer head association
-- 
1.8.3.1
