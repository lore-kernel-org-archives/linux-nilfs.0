From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: get rid of bdi from nilfs object
Date: Thu,  7 Oct 2010 16:15:40 +0900
Message-ID: <1286435740-20006-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Nilfs now can use sb->s_bdi to get backing_dev_info, so we use it
instead of ns_bdi on the nilfs object and remove ns_bdi.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/mdt.c       |    2 +-
 fs/nilfs2/segbuf.c    |    3 ++-
 fs/nilfs2/super.c     |    5 ++++-
 fs/nilfs2/the_nilfs.c |    4 ----
 fs/nilfs2/the_nilfs.h |    2 --
 5 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index d60fdb0..39a5b84 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -457,7 +457,7 @@ int nilfs_mdt_setup_shadow_map(struct inode *inode,
 			       struct nilfs_shadow_map *shadow)
 {
 	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
-	struct backing_dev_info *bdi = NILFS_I_NILFS(inode)->ns_bdi;
+	struct backing_dev_info *bdi = inode->i_sb->s_bdi;
 
 	INIT_LIST_HEAD(&shadow->frozen_buffers);
 	nilfs_mapping_init_once(&shadow->frozen_data);
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 4588fb9..0f83e93 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -371,7 +371,8 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
 	struct bio *bio = wi->bio;
 	int err;
 
-	if (segbuf->sb_nbio > 0 && bdi_write_congested(wi->nilfs->ns_bdi)) {
+	if (segbuf->sb_nbio > 0 &&
+	    bdi_write_congested(segbuf->sb_super->s_bdi)) {
 		wait_for_completion(&segbuf->sb_bio_event);
 		segbuf->sb_nbio--;
 		if (unlikely(atomic_read(&segbuf->sb_err))) {
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 027c7e8..be0cb46 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -915,6 +915,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct the_nilfs *nilfs;
 	struct nilfs_sb_info *sbi;
 	struct nilfs_root *fsroot;
+	struct backing_dev_info *bdi;
 	__u64 cno;
 	int err;
 
@@ -953,7 +954,9 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_export_op = &nilfs_export_ops;
 	sb->s_root = NULL;
 	sb->s_time_gran = 1;
-	sb->s_bdi = nilfs->ns_bdi;
+
+	bdi = sb->s_bdev->bd_inode->i_mapping->backing_dev_info;
+	sb->s_bdi = bdi ? : &default_backing_dev_info;
 
 	err = load_nilfs(nilfs, sbi);
 	if (err)
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index a94aa57..bd02b61 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -535,7 +535,6 @@ int init_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi, char *data)
 {
 	struct super_block *sb = sbi->s_super;
 	struct nilfs_super_block *sbp;
-	struct backing_dev_info *bdi;
 	int blocksize;
 	int err;
 
@@ -598,9 +597,6 @@ int init_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi, char *data)
 
 	nilfs->ns_mount_state = le16_to_cpu(sbp->s_state);
 
-	bdi = nilfs->ns_bdev->bd_inode->i_mapping->backing_dev_info;
-	nilfs->ns_bdi = bdi ? : &default_backing_dev_info;
-
 	err = nilfs_store_log_cursor(nilfs, sbp);
 	if (err)
 		goto failed_sbh;
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index bbbc1c7..69226e1 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -47,7 +47,6 @@ enum {
  * struct the_nilfs - struct to supervise multiple nilfs mount points
  * @ns_flags: flags
  * @ns_bdev: block device
- * @ns_bdi: backing dev info
  * @ns_sem: semaphore for shared states
  * @ns_sbh: buffer heads of on-disk super blocks
  * @ns_sbp: pointers to super block data
@@ -90,7 +89,6 @@ struct the_nilfs {
 	unsigned long		ns_flags;
 
 	struct block_device    *ns_bdev;
-	struct backing_dev_info *ns_bdi;
 	struct rw_semaphore	ns_sem;
 
 	/*
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
