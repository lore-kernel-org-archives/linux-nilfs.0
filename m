From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCHv5 4/5] nilfs2: introduce nilfs_prepare_super
Date: Mon, 28 Jun 2010 17:49:32 +0900
Message-ID: <1277714973-12136-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1277714973-12136-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277714973-12136-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This function checks validity of super block pointers.
If first super block is invalid, it will swap the super blocks.
The function should be called before any super block information updates.
Caller must obtain nilfs->ns_sem.

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/nilfs.h   |    1 +
 fs/nilfs2/segment.c |    8 ++++-
 fs/nilfs2/super.c   |   73 +++++++++++++++++++++++++++++++++++---------------
 3 files changed, 58 insertions(+), 24 deletions(-)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 6718616..4626510 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -272,6 +272,7 @@ extern int nilfs_store_magic_and_option(struct super_block *,
 					struct nilfs_super_block *, char *);
 extern void nilfs_set_log_cursor(struct nilfs_super_block *,
 				 struct the_nilfs *);
+extern struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *);
 extern int nilfs_commit_super(struct nilfs_sb_info *, int);
 extern int nilfs_cleanup_super(struct nilfs_sb_info *);
 extern int nilfs_attach_checkpoint(struct nilfs_sb_info *, __u64);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 1f7881c..9e680a9 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2408,6 +2408,7 @@ static int nilfs_segctor_construct(struct nilfs_sc_info *sci, int mode)
 {
 	struct nilfs_sb_info *sbi = sci->sc_sbi;
 	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct nilfs_super_block **sbp;
 	int err = 0;
 
 	nilfs_segctor_accept(sci);
@@ -2423,8 +2424,11 @@ static int nilfs_segctor_construct(struct nilfs_sc_info *sci, int mode)
 		if (test_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags) &&
 		    nilfs_discontinued(nilfs)) {
 			down_write(&nilfs->ns_sem);
-			err = nilfs_commit_super(
-				sbi, nilfs_altsb_need_update(nilfs));
+			err = -EIO;
+			sbp = nilfs_prepare_super(sbi);
+			if (likely(sbp))
+				err = nilfs_commit_super(
+					sbi, nilfs_altsb_need_update(nilfs));
 			up_write(&nilfs->ns_sem);
 		}
 	}
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index c5328c8..eb7de40 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -77,12 +77,16 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data);
 static void nilfs_set_error(struct nilfs_sb_info *sbi)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct nilfs_super_block **sbp;
 
 	down_write(&nilfs->ns_sem);
 	if (!(nilfs->ns_mount_state & NILFS_ERROR_FS)) {
 		nilfs->ns_mount_state |= NILFS_ERROR_FS;
-		nilfs->ns_sbp[0]->s_state |= cpu_to_le16(NILFS_ERROR_FS);
-		nilfs_commit_super(sbi, 1);
+		sbp = nilfs_prepare_super(sbi);
+		if (likely(sbp)) {
+			sbp[0]->s_state |= cpu_to_le16(NILFS_ERROR_FS);
+			nilfs_commit_super(sbi, 1);
+		}
 	}
 	up_write(&nilfs->ns_sem);
 }
@@ -253,22 +257,32 @@ void nilfs_set_log_cursor(struct nilfs_super_block *sbp,
 	spin_unlock(&nilfs->ns_last_segment_lock);
 }
 
-int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
+struct nilfs_super_block **nilfs_prepare_super(struct nilfs_sb_info *sbi)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
-	time_t t;
 
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
+	time_t t;
+
+	/* nilfs->ns_sem must be locked by the caller. */
 	nilfs_set_log_cursor(sbp[0], nilfs);
 
 	t = get_seconds();
@@ -296,11 +310,14 @@ int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
  */
 int nilfs_cleanup_super(struct nilfs_sb_info *sbi)
 {
-	struct nilfs_super_block **sbp = sbi->s_nilfs->ns_sbp;
-	int ret;
+	struct nilfs_super_block **sbp;
+	int ret = -EIO;
 
-	sbp[0]->s_state = cpu_to_le16(sbi->s_nilfs->ns_mount_state);
-	ret = nilfs_commit_super(sbi, 1);
+	sbp = nilfs_prepare_super(sbi);
+	if (sbp) {
+		sbp[0]->s_state = cpu_to_le16(sbi->s_nilfs->ns_mount_state);
+		ret = nilfs_commit_super(sbi, 1);
+	}
 	return ret;
 }
 
@@ -336,6 +353,7 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
 	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct nilfs_super_block **sbp;
 	int err = 0;
 
 	/* This function is called when super block should be written back */
@@ -343,8 +361,11 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
 		err = nilfs_construct_segment(sb);
 
 	down_write(&nilfs->ns_sem);
-	if (nilfs_sb_dirty(nilfs))
-		nilfs_commit_super(sbi, 1);
+	if (nilfs_sb_dirty(nilfs)) {
+		sbp = nilfs_prepare_super(sbi);
+		if (likely(sbp))
+			nilfs_commit_super(sbi, 1);
+	}
 	up_write(&nilfs->ns_sem);
 
 	return err;
@@ -638,11 +659,18 @@ nilfs_set_default_options(struct nilfs_sb_info *sbi,
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
 	if (nilfs->ns_mount_state & NILFS_ERROR_FS) {
 		printk(KERN_WARNING
 		       "NILFS warning: mounting fs with errors\n");
@@ -653,11 +681,12 @@ static int nilfs_setup_super(struct nilfs_sb_info *sbi)
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
 
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
