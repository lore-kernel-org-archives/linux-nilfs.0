From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCHv4 1/2] nilfs2: introduce nilfs_prepare_super
Date: Fri, 25 Jun 2010 00:27:39 +0900
Message-ID: <1277393260-19835-2-git-send-email-jir@unicus.jp>
References: <1277393260-19835-1-git-send-email-jir@unicus.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277393260-19835-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, ryusuke-sG5X7nlA6pw@public.gmane.org, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This function checks validity of super block pointers.
If first super block is invalid, it will swap the super blocks.
The function should be called before any super block information updates.
Caller must obtain nilfs->ns_sem.

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/nilfs.h     |    1 +
 fs/nilfs2/segment.c   |    6 ++-
 fs/nilfs2/super.c     |   87 ++++++++++++++++++++++++++++++++----------------
 fs/nilfs2/the_nilfs.c |   11 ++++--
 4 files changed, 71 insertions(+), 34 deletions(-)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 47d6d79..649e079 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -270,6 +270,7 @@ extern struct nilfs_super_block *
 nilfs_read_super_block(struct super_block *, u64, int, struct buffer_head **);
 extern int nilfs_store_magic_and_option(struct super_block *,
 					struct nilfs_super_block *, char *);
+extern struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *);
 extern int nilfs_commit_super(struct nilfs_sb_info *, int);
 extern int nilfs_attach_checkpoint(struct nilfs_sb_info *, __u64);
 extern void nilfs_detach_checkpoint(struct nilfs_sb_info *);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 1f7881c..075d7b0 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2423,8 +2423,10 @@ static int nilfs_segctor_construct(struct nilfs_sc_info *sci, int mode)
 		if (test_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags) &&
 		    nilfs_discontinued(nilfs)) {
 			down_write(&nilfs->ns_sem);
-			err = nilfs_commit_super(
-				sbi, nilfs_altsb_need_update(nilfs));
+			err = -EIO;
+			if (likely(nilfs_prepare_super(sbi)))
+				err = nilfs_commit_super(
+					sbi, nilfs_altsb_need_update(nilfs));
 			up_write(&nilfs->ns_sem);
 		}
 	}
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 414ef68..045b8d7 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -90,6 +90,7 @@ void nilfs_error(struct super_block *sb, const char *function,
 		 const char *fmt, ...)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct nilfs_super_block **sbp;
 	va_list args;
 
 	va_start(args, fmt);
@@ -104,9 +105,11 @@ void nilfs_error(struct super_block *sb, const char *function,
 		down_write(&nilfs->ns_sem);
 		if (!(nilfs->ns_mount_state & NILFS_ERROR_FS)) {
 			nilfs->ns_mount_state |= NILFS_ERROR_FS;
-			nilfs->ns_sbp[0]->s_state |=
-				cpu_to_le16(NILFS_ERROR_FS);
-			nilfs_commit_super(sbi, 1);
+			sbp = nilfs_prepare_super(sbi);
+			if (likely(sbp)) {
+				sbp[0]->s_state |= cpu_to_le16(NILFS_ERROR_FS);
+				nilfs_commit_super(sbi, 1);
+			}
 		}
 		up_write(&nilfs->ns_sem);
 
@@ -233,24 +236,34 @@ static int nilfs_sync_super(struct nilfs_sb_info *sbi, int dupsb)
 	return err;
 }
 
-int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
+struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *sbi)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
-	sector_t nfreeblocks;
-	time_t t;
-	int err;
 
-	/* nilfs->sem must be locked by the caller. */
+	/* nilfs->ns_sem must be locked by the caller. */
 	if (sbp[0]->s_magic != cpu_to_le16(NILFS_SUPER_MAGIC)) {
-		if (sbp[1] && sbp[1]->s_magic == cpu_to_le16(NILFS_SUPER_MAGIC))
+		if (sbp[1] &&
+		    sbp[1]->s_magic == cpu_to_le16(NILFS_SUPER_MAGIC)) {
 			nilfs_swap_super_block(nilfs);
-		else {
+		} else {
 			printk(KERN_CRIT "NILFS: superblock broke on dev %s\n",
 			       sbi->s_super->s_id);
-			return -EIO;
+			return NULL;
 		}
 	}
+	return sbp;
+}
+
+int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
+{
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct nilfs_super_block **sbp = nilfs->ns_sbp;
+	sector_t nfreeblocks;
+	time_t t;
+	int err;
+
+	/* nilfs->ns_sem must be locked by the caller. */
 	err = nilfs_count_free_blocks(nilfs, &nfreeblocks);
 	if (unlikely(err)) {
 		printk(KERN_ERR "NILFS: failed to count free blocks\n");
@@ -282,6 +295,7 @@ static void nilfs_put_super(struct super_block *sb)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
 	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct nilfs_super_block **sbp;
 
 	lock_kernel();
 
@@ -289,8 +303,11 @@ static void nilfs_put_super(struct super_block *sb)
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		down_write(&nilfs->ns_sem);
-		nilfs->ns_sbp[0]->s_state = cpu_to_le16(nilfs->ns_mount_state);
-		nilfs_commit_super(sbi, 1);
+		sbp = nilfs_prepare_super(sbi);
+		if (likely(sbp)) {
+			sbp[0]->s_state = cpu_to_le16(nilfs->ns_mount_state);
+			nilfs_commit_super(sbi, 1);
+		}
 		up_write(&nilfs->ns_sem);
 	}
 	down_write(&nilfs->ns_super_sem);
@@ -318,7 +335,7 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
 		err = nilfs_construct_segment(sb);
 
 	down_write(&nilfs->ns_sem);
-	if (nilfs_sb_dirty(nilfs))
+	if (nilfs_sb_dirty(nilfs) && nilfs_prepare_super(sbi))
 		nilfs_commit_super(sbi, 1);
 	up_write(&nilfs->ns_sem);
 
@@ -613,11 +630,19 @@ nilfs_set_default_options(struct nilfs_sb_info *sbi,
 static int nilfs_setup_super(struct nilfs_sb_info *sbi)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
-	struct nilfs_super_block *sbp = nilfs->ns_sbp[0];
-	int max_mnt_count = le16_to_cpu(sbp->s_max_mnt_count);
-	int mnt_count = le16_to_cpu(sbp->s_mnt_count);
+	struct nilfs_super_block **sbp;
+	int max_mnt_count;
+	int mnt_count;
+
+	/* nilfs->ns_sem must be locked by the caller. */
+	sbp = nilfs_prepare_super(sbi);
+	if (!sbp)
+		return -EIO;
+
+	max_mnt_count = le16_to_cpu(sbp[0]->s_max_mnt_count);
+	mnt_count = le16_to_cpu(sbp[0]->s_mnt_count);
 
-	/* nilfs->sem must be locked by the caller. */
+	/* nilfs->ns_sem must be locked by the caller. */
 	if (nilfs->ns_mount_state & NILFS_ERROR_FS) {
 		printk(KERN_WARNING
 		       "NILFS warning: mounting fs with errors\n");
@@ -628,11 +653,12 @@ static int nilfs_setup_super(struct nilfs_sb_info *sbi)
 #endif
 	}
 	if (!max_mnt_count)
-		sbp->s_max_mnt_count = cpu_to_le16(NILFS_DFL_MAX_MNT_COUNT);
+		sbp[0]->s_max_mnt_count = cpu_to_le16(NILFS_DFL_MAX_MNT_COUNT);
 
-	sbp->s_mnt_count = cpu_to_le16(mnt_count + 1);
-	sbp->s_state = cpu_to_le16(le16_to_cpu(sbp->s_state) & ~NILFS_VALID_FS);
-	sbp->s_mtime = cpu_to_le64(get_seconds());
+	sbp[0]->s_mnt_count = cpu_to_le16(mnt_count + 1);
+	sbp[0]->s_state =
+		cpu_to_le16(le16_to_cpu(sbp[0]->s_state) & ~NILFS_VALID_FS);
+	sbp[0]->s_mtime = cpu_to_le64(get_seconds());
 	return nilfs_commit_super(sbi, 1);
 }
 
@@ -819,7 +845,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
-	struct nilfs_super_block *sbp;
+	struct nilfs_super_block **sbp;
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	unsigned long old_sb_flags;
 	struct nilfs_mount_options old_opts;
@@ -880,12 +906,15 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		 * the RDONLY flag and then mark the partition as valid again.
 		 */
 		down_write(&nilfs->ns_sem);
-		sbp = nilfs->ns_sbp[0];
-		if (!(sbp->s_state & le16_to_cpu(NILFS_VALID_FS)) &&
-		    (nilfs->ns_mount_state & NILFS_VALID_FS))
-			sbp->s_state = cpu_to_le16(nilfs->ns_mount_state);
-		sbp->s_mtime = cpu_to_le64(get_seconds());
-		nilfs_commit_super(sbi, 1);
+		sbp = nilfs_prepare_super(sbi);
+		if (likely(sbp)) {
+			if (!(sbp[0]->s_state & le16_to_cpu(NILFS_VALID_FS)) &&
+			    (nilfs->ns_mount_state & NILFS_VALID_FS))
+				sbp[0]->s_state =
+					cpu_to_le16(nilfs->ns_mount_state);
+			sbp[0]->s_mtime = cpu_to_le64(get_seconds());
+			nilfs_commit_super(sbi, 1);
+		}
 		up_write(&nilfs->ns_sem);
 	} else {
 		/*
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 9f2cb01..74b0480 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -261,6 +261,7 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 	unsigned int s_flags = sbi->s_super->s_flags;
 	int really_read_only = bdev_read_only(nilfs->ns_bdev);
 	int valid_fs = nilfs_valid_fs(nilfs);
+	struct nilfs_super_block **sbp;
 	int err;
 
 	if (nilfs_loaded(nilfs)) {
@@ -324,9 +325,13 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 		goto failed_unload;
 
 	down_write(&nilfs->ns_sem);
-	nilfs->ns_mount_state |= NILFS_VALID_FS;
-	nilfs->ns_sbp[0]->s_state = cpu_to_le16(nilfs->ns_mount_state);
-	err = nilfs_commit_super(sbi, 1);
+	err = -EIO;
+	sbp = nilfs_prepare_super(sbi);
+	if (likely(sbp)) {
+		nilfs->ns_mount_state |= NILFS_VALID_FS;
+		sbp[0]->s_state = cpu_to_le16(nilfs->ns_mount_state);
+		err = nilfs_commit_super(sbi, 1);
+	}
 	up_write(&nilfs->ns_sem);
 
 	if (err) {
-- 
1.5.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
