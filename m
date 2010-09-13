From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 22/23] nilfs2: get rid of back pointer to writable sb instance
Date: Tue, 14 Sep 2010 00:37:23 +0900
Message-ID: <1284392244-27100-23-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

Nilfs object holds a back pointer to a writable super block instance
in nilfs->ns_writer, and this became eliminable since sb is now made
per device and all inodes have a valid pointer to it.

This deletes the ns_writer pointer and a reader/writer semaphore
protecting it.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/mdt.c       |   33 ++-------------------------------
 fs/nilfs2/recovery.c  |    4 ----
 fs/nilfs2/segment.c   |    4 ----
 fs/nilfs2/the_nilfs.c |    1 -
 fs/nilfs2/the_nilfs.h |   21 ---------------------
 5 files changed, 2 insertions(+), 61 deletions(-)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 32695f3..0a2ccfc 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -78,25 +78,11 @@ static int nilfs_mdt_create_block(struct inode *inode, unsigned long block,
 						     struct buffer_head *,
 						     void *))
 {
-	struct the_nilfs *nilfs = NILFS_I_NILFS(inode);
 	struct super_block *sb = inode->i_sb;
 	struct nilfs_transaction_info ti;
 	struct buffer_head *bh;
 	int err;
 
-	if (!sb) {
-		/*
-		 * Make sure this function is not called from any
-		 * read-only context.
-		 */
-		if (!nilfs->ns_writer) {
-			WARN_ON(1);
-			err = -EROFS;
-			goto out;
-		}
-		sb = nilfs->ns_writer->s_super;
-	}
-
 	nilfs_transaction_begin(sb, &ti, 0);
 
 	err = -ENOMEM;
@@ -112,7 +98,7 @@ static int nilfs_mdt_create_block(struct inode *inode, unsigned long block,
 	if (buffer_uptodate(bh))
 		goto failed_bh;
 
-	bh->b_bdev = nilfs->ns_bdev;
+	bh->b_bdev = sb->s_bdev;
 	err = nilfs_mdt_insert_new_block(inode, block, bh, init_block);
 	if (likely(!err)) {
 		get_bh(bh);
@@ -129,7 +115,7 @@ static int nilfs_mdt_create_block(struct inode *inode, unsigned long block,
 		err = nilfs_transaction_commit(sb);
 	else
 		nilfs_transaction_abort(sb);
- out:
+
 	return err;
 }
 
@@ -398,8 +384,6 @@ nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 {
 	struct inode *inode;
 	struct super_block *sb;
-	struct the_nilfs *nilfs;
-	struct nilfs_sb_info *writer = NULL;
 	int err = 0;
 
 	redirty_page_for_writepage(wbc, page);
@@ -410,25 +394,12 @@ nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 		return 0;
 
 	sb = inode->i_sb;
-	nilfs = NILFS_SB(sb)->s_nilfs;
-
-	if (!sb) {
-		down_read(&nilfs->ns_writer_sem);
-		writer = nilfs->ns_writer;
-		if (!writer) {
-			up_read(&nilfs->ns_writer_sem);
-			return -EROFS;
-		}
-		sb = writer->s_super;
-	}
 
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		err = nilfs_construct_segment(sb);
 	else if (wbc->for_reclaim)
 		nilfs_flush_segment(sb, inode->i_ino);
 
-	if (writer)
-		up_read(&nilfs->ns_writer_sem);
 	return err;
 }
 
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index dcb5a98..5d2711c 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -440,7 +440,6 @@ static int nilfs_prepare_segment_for_recovery(struct the_nilfs *nilfs,
 	segnum[2] = ri->ri_segnum;
 	segnum[3] = ri->ri_nextnum;
 
-	nilfs_attach_writer(nilfs, sbi);
 	/*
 	 * Releasing the next segment of the latest super root.
 	 * The next segment is invalidated by this recovery.
@@ -480,7 +479,6 @@ static int nilfs_prepare_segment_for_recovery(struct the_nilfs *nilfs,
 
  failed:
 	/* No need to recover sufile because it will be destroyed on error */
-	nilfs_detach_writer(nilfs, sbi);
 	return err;
 }
 
@@ -599,7 +597,6 @@ static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
 	};
 	int state = RF_INIT_ST;
 
-	nilfs_attach_writer(nilfs, sbi);
 	pseg_start = ri->ri_lsegs_start;
 	seg_seq = ri->ri_lsegs_start_seq;
 	segnum = nilfs_get_segnum_of_block(nilfs, pseg_start);
@@ -690,7 +687,6 @@ static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
  out:
 	brelse(bh_sum);
 	dispose_recovery_list(&dsync_blocks);
-	nilfs_detach_writer(nilfs, sbi);
 	return err;
 
  confused:
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index b0c5e08..56350bf 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2799,7 +2799,6 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 int nilfs_attach_segment_constructor(struct nilfs_sb_info *sbi,
 				     struct nilfs_root *root)
 {
-	struct the_nilfs *nilfs = sbi->s_nilfs;
 	int err;
 
 	if (NILFS_SC(sbi)) {
@@ -2815,10 +2814,8 @@ int nilfs_attach_segment_constructor(struct nilfs_sb_info *sbi,
 	if (!sbi->s_sc_info)
 		return -ENOMEM;
 
-	nilfs_attach_writer(nilfs, sbi);
 	err = nilfs_segctor_start_thread(NILFS_SC(sbi));
 	if (err) {
-		nilfs_detach_writer(nilfs, sbi);
 		kfree(sbi->s_sc_info);
 		sbi->s_sc_info = NULL;
 	}
@@ -2855,5 +2852,4 @@ void nilfs_detach_segment_constructor(struct nilfs_sb_info *sbi)
 	up_write(&nilfs->ns_segctor_sem);
 
 	nilfs_dispose_list(sbi, &garbage_list, 1);
-	nilfs_detach_writer(nilfs, sbi);
 }
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index f973333..a300298 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -75,7 +75,6 @@ struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 	nilfs->ns_bdev = bdev;
 	atomic_set(&nilfs->ns_ndirtyblks, 0);
 	init_rwsem(&nilfs->ns_sem);
-	init_rwsem(&nilfs->ns_writer_sem);
 	INIT_LIST_HEAD(&nilfs->ns_gc_inodes);
 	spin_lock_init(&nilfs->ns_last_segment_lock);
 	nilfs->ns_cptree = RB_ROOT;
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index cae56f3..bbbc1c7 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -48,9 +48,7 @@ enum {
  * @ns_flags: flags
  * @ns_bdev: block device
  * @ns_bdi: backing dev info
- * @ns_writer: back pointer to writable nilfs_sb_info
  * @ns_sem: semaphore for shared states
- * @ns_writer_sem: semaphore protecting ns_writer attach/detach
  * @ns_sbh: buffer heads of on-disk super blocks
  * @ns_sbp: pointers to super block data
  * @ns_sbwtime: previous write time of super block
@@ -93,9 +91,7 @@ struct the_nilfs {
 
 	struct block_device    *ns_bdev;
 	struct backing_dev_info *ns_bdi;
-	struct nilfs_sb_info   *ns_writer;
 	struct rw_semaphore	ns_sem;
-	struct rw_semaphore	ns_writer_sem;
 
 	/*
 	 * used for
@@ -252,23 +248,6 @@ static inline void nilfs_get_root(struct nilfs_root *root)
 	atomic_inc(&root->count);
 }
 
-static inline void
-nilfs_attach_writer(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
-{
-	down_write(&nilfs->ns_writer_sem);
-	nilfs->ns_writer = sbi;
-	up_write(&nilfs->ns_writer_sem);
-}
-
-static inline void
-nilfs_detach_writer(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
-{
-	down_write(&nilfs->ns_writer_sem);
-	if (sbi == nilfs->ns_writer)
-		nilfs->ns_writer = NULL;
-	up_write(&nilfs->ns_writer_sem);
-}
-
 static inline int nilfs_valid_fs(struct the_nilfs *nilfs)
 {
 	unsigned valid_fs;
-- 
1.6.6.2

