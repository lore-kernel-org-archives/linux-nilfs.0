From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: introduce nilfs_prepare_super
Date: Sun,  6 Jun 2010 07:19:08 +0900
Message-ID: <1275776349-22820-2-git-send-email-jir@unicus.jp>
References: <1275776349-22820-1-git-send-email-jir@unicus.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1275776349-22820-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This function checks validity of super block pointer.
If first super block is invalid, it will swap the super blocks.
The function should be called before any super block information updates.
Caller must obtain nilfs->ns_sem.

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/nilfs.h     |    1 +
 fs/nilfs2/segment.c   |    6 +++-
 fs/nilfs2/super.c     |   58 ++++++++++++++++++++++++++++++++++--------------
 fs/nilfs2/the_nilfs.c |    9 +++++--
 4 files changed, 52 insertions(+), 22 deletions(-)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 8723e5b..c8edffd 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -270,6 +270,7 @@ extern struct nilfs_super_block *
 nilfs_read_super_block(struct super_block *, u64, int, struct buffer_head **);
 extern int nilfs_store_magic_and_option(struct super_block *,
 					struct nilfs_super_block *, char *);
+extern int nilfs_prepare_super(struct nilfs_sb_info *);
 extern int nilfs_commit_super(struct nilfs_sb_info *, int);
 extern int nilfs_attach_checkpoint(struct nilfs_sb_info *, __u64);
 extern void nilfs_detach_checkpoint(struct nilfs_sb_info *);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 6a7dbd8..72f779f 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2490,8 +2490,10 @@ static int nilfs_segctor_construct(struct nilfs_sc_info *sci, int mode)
 		if (test_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags) &&
 		    nilfs_discontinued(nilfs)) {
 			down_write(&nilfs->ns_sem);
-			err = nilfs_commit_super(
-				sbi, nilfs_altsb_need_update(nilfs));
+			err = nilfs_prepare_super(sbi);
+			if (likely(!err))
+				err = nilfs_commit_super(
+					sbi, nilfs_altsb_need_update(nilfs));
 			up_write(&nilfs->ns_sem);
 		}
 	}
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 48145f5..312b34a 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -97,7 +97,8 @@ void nilfs_error(struct super_block *sb, const char *function,
 		struct the_nilfs *nilfs = sbi->s_nilfs;
 
 		down_write(&nilfs->ns_sem);
-		if (!(nilfs->ns_mount_state & NILFS_ERROR_FS)) {
+		if (!(nilfs->ns_mount_state & NILFS_ERROR_FS) &&
+		    !nilfs_prepare_super(sbi)) {
 			nilfs->ns_mount_state |= NILFS_ERROR_FS;
 			nilfs->ns_sbp[0]->s_state |=
 				cpu_to_le16(NILFS_ERROR_FS);
@@ -257,14 +258,10 @@ static int nilfs_sync_super(struct nilfs_sb_info *sbi, int dupsb)
 	return err;
 }
 
-int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
+int nilfs_prepare_super(struct nilfs_sb_info *sbi)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
-	sector_t nfreeblocks;
-	time_t t;
-	int err;
-
 	/* nilfs->sem must be locked by the caller. */
 	if (sbp[0]->s_magic != NILFS_SUPER_MAGIC) {
 		if (sbp[1] && sbp[1]->s_magic == NILFS_SUPER_MAGIC)
@@ -275,6 +272,18 @@ int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
 			return -EIO;
 		}
 	}
+	return 0;
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
+	/* nilfs->sem must be locked by the caller. */
 	err = nilfs_count_free_blocks(nilfs, &nfreeblocks);
 	if (unlikely(err)) {
 		printk(KERN_ERR "NILFS: failed to count free blocks\n");
@@ -314,7 +323,8 @@ static void nilfs_put_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY)) {
 		down_write(&nilfs->ns_sem);
 		nilfs->ns_sbp[0]->s_state = cpu_to_le16(nilfs->ns_mount_state);
-		nilfs_commit_super(sbi, 1);
+		if (likely(!nilfs_prepare_super(sbi)))
+			nilfs_commit_super(sbi, 1);
 		up_write(&nilfs->ns_sem);
 	}
 	down_write(&nilfs->ns_super_sem);
@@ -342,7 +352,7 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
 		err = nilfs_construct_segment(sb);
 
 	down_write(&nilfs->ns_sem);
-	if (nilfs_sb_dirty(nilfs))
+	if (nilfs_sb_dirty(nilfs) && likely(!nilfs_prepare_super(sbi)))
 		nilfs_commit_super(sbi, 1);
 	up_write(&nilfs->ns_sem);
 
@@ -637,9 +647,20 @@ nilfs_set_default_options(struct nilfs_sb_info *sbi,
 static int nilfs_setup_super(struct nilfs_sb_info *sbi)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
-	struct nilfs_super_block *sbp = nilfs->ns_sbp[0];
-	int max_mnt_count = le16_to_cpu(sbp->s_max_mnt_count);
-	int mnt_count = le16_to_cpu(sbp->s_mnt_count);
+	struct nilfs_super_block *sbp;
+	int max_mnt_count;
+	int mnt_count;
+	int err;
+
+	err = nilfs_prepare_super(sbi);
+
+	if (unlikely(err))
+		return err;
+
+	sbp = nilfs->ns_sbp[0];
+	max_mnt_count = le16_to_cpu(sbp->s_max_mnt_count);
+	mnt_count = le16_to_cpu(sbp->s_mnt_count);
+
 
 	/* nilfs->sem must be locked by the caller. */
 	if (nilfs->ns_mount_state & NILFS_ERROR_FS) {
@@ -896,12 +917,15 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		 * the RDONLY flag and then mark the partition as valid again.
 		 */
 		down_write(&nilfs->ns_sem);
-		sbp = nilfs->ns_sbp[0];
-		if (!(sbp->s_state & le16_to_cpu(NILFS_VALID_FS)) &&
-		    (nilfs->ns_mount_state & NILFS_VALID_FS))
-			sbp->s_state = cpu_to_le16(nilfs->ns_mount_state);
-		sbp->s_mtime = cpu_to_le64(get_seconds());
-		nilfs_commit_super(sbi, 1);
+		if (likely(!nilfs_prepare_super(sbi))) {
+			sbp = nilfs->ns_sbp[0];
+			if (!(sbp->s_state & le16_to_cpu(NILFS_VALID_FS)) &&
+			    (nilfs->ns_mount_state & NILFS_VALID_FS))
+				sbp->s_state =
+				    cpu_to_le16(nilfs->ns_mount_state);
+			sbp->s_mtime = cpu_to_le64(get_seconds());
+			nilfs_commit_super(sbi, 1);
+		}
 		up_write(&nilfs->ns_sem);
 	} else {
 		/*
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index a756168..636cefe 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -325,9 +325,12 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 		goto failed_unload;
 
 	down_write(&nilfs->ns_sem);
-	nilfs->ns_mount_state |= NILFS_VALID_FS;
-	nilfs->ns_sbp[0]->s_state = cpu_to_le16(nilfs->ns_mount_state);
-	err = nilfs_commit_super(sbi, 1);
+	err = nilfs_prepare_super(sbi);
+	if (likely(!err)) {
+		nilfs->ns_mount_state |= NILFS_VALID_FS;
+		nilfs->ns_sbp[0]->s_state = cpu_to_le16(nilfs->ns_mount_state);
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
