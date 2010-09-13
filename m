From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 21/23] nilfs2: get rid of mi_nilfs back pointer to nilfs object
Date: Tue, 14 Sep 2010 00:37:22 +0900
Message-ID: <1284392244-27100-22-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1284392244-27100-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This removes a back pointer to nilfs object from nilfs_mdt_info
structure that is attached to metadata files.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/mdt.c    |    9 +++------
 fs/nilfs2/mdt.h    |    8 ++------
 fs/nilfs2/sufile.c |    4 ++--
 fs/nilfs2/sufile.h |    2 +-
 4 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 44326cf..32695f3 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -78,7 +78,7 @@ static int nilfs_mdt_create_block(struct inode *inode, unsigned long block,
 						     struct buffer_head *,
 						     void *))
 {
-	struct the_nilfs *nilfs = NILFS_MDT(inode)->mi_nilfs;
+	struct the_nilfs *nilfs = NILFS_I_NILFS(inode);
 	struct super_block *sb = inode->i_sb;
 	struct nilfs_transaction_info ti;
 	struct buffer_head *bh;
@@ -167,9 +167,7 @@ nilfs_mdt_submit_block(struct inode *inode, unsigned long blkoff,
 		unlock_buffer(bh);
 		goto failed_bh;
 	}
-	bh->b_bdev = NILFS_MDT(inode)->mi_nilfs->ns_bdev;
-	bh->b_blocknr = (sector_t)blknum;
-	set_buffer_mapped(bh);
+	map_bh(bh, inode->i_sb, (sector_t)blknum);
 
 	bh->b_end_io = end_buffer_read_sync;
 	get_bh(bh);
@@ -412,7 +410,7 @@ nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 		return 0;
 
 	sb = inode->i_sb;
-	nilfs = NILFS_MDT(inode)->mi_nilfs;
+	nilfs = NILFS_SB(sb)->s_nilfs;
 
 	if (!sb) {
 		down_read(&nilfs->ns_writer_sem);
@@ -452,7 +450,6 @@ int nilfs_mdt_init(struct inode *inode, gfp_t gfp_mask, size_t objsz)
 	if (!mi)
 		return -ENOMEM;
 
-	mi->mi_nilfs = NILFS_I_NILFS(inode);
 	init_rwsem(&mi->mi_sem);
 	inode->i_private = mi;
 
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index 73ff7c0..76356d2 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -37,7 +37,6 @@ struct nilfs_shadow_map {
 
 /**
  * struct nilfs_mdt_info - on-memory private data of meta data files
- * @mi_nilfs: back pointer to the_nilfs struct
  * @mi_sem: reader/writer semaphore for meta data operations
  * @mi_bgl: per-blockgroup locking
  * @mi_entry_size: size of an entry
@@ -49,7 +48,6 @@ struct nilfs_shadow_map {
  * @mi_blocks_per_desc_block: number of blocks per descriptor block
  */
 struct nilfs_mdt_info {
-	struct the_nilfs       *mi_nilfs;
 	struct rw_semaphore	mi_sem;
 	struct blockgroup_lock *mi_bgl;
 	unsigned		mi_entry_size;
@@ -68,9 +66,7 @@ static inline struct nilfs_mdt_info *NILFS_MDT(const struct inode *inode)
 
 static inline struct the_nilfs *NILFS_I_NILFS(struct inode *inode)
 {
-	struct super_block *sb = inode->i_sb;
-
-	return sb ? NILFS_SB(sb)->s_nilfs : NILFS_MDT(inode)->mi_nilfs;
+	return NILFS_SB(inode->i_sb)->s_nilfs;
 }
 
 /* Default GFP flags using highmem */
@@ -117,7 +113,7 @@ static inline void nilfs_mdt_clear_dirty(struct inode *inode)
 
 static inline __u64 nilfs_mdt_cno(struct inode *inode)
 {
-	return NILFS_MDT(inode)->mi_nilfs->ns_cno;
+	return NILFS_I_NILFS(inode)->ns_cno;
 }
 
 #define nilfs_mdt_bgl_lock(inode, bg) \
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 599d9c2..1d6f488 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -505,7 +505,7 @@ int nilfs_sufile_get_stat(struct inode *sufile, struct nilfs_sustat *sustat)
 {
 	struct buffer_head *header_bh;
 	struct nilfs_sufile_header *header;
-	struct the_nilfs *nilfs = NILFS_MDT(sufile)->mi_nilfs;
+	struct the_nilfs *nilfs = NILFS_I_NILFS(sufile);
 	void *kaddr;
 	int ret;
 
@@ -583,7 +583,7 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
 	struct nilfs_segment_usage *su;
 	struct nilfs_suinfo *si = buf;
 	size_t susz = NILFS_MDT(sufile)->mi_entry_size;
-	struct the_nilfs *nilfs = NILFS_MDT(sufile)->mi_nilfs;
+	struct the_nilfs *nilfs = NILFS_I_NILFS(sufile);
 	void *kaddr;
 	unsigned long nsegs, segusages_per_block;
 	ssize_t n;
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index 203f610..a943fba 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -31,7 +31,7 @@
 
 static inline unsigned long nilfs_sufile_get_nsegments(struct inode *sufile)
 {
-	return NILFS_MDT(sufile)->mi_nilfs->ns_nsegments;
+	return NILFS_I_NILFS(sufile)->ns_nsegments;
 }
 
 unsigned long nilfs_sufile_get_ncleansegs(struct inode *sufile);
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
