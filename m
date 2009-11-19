From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/4] nilfs2: move recovery completion into
	load_nilfs function
Date: Fri, 20 Nov 2009 02:09:11 +0900
Message-ID: <1258650553-10743-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1258650553-10743-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1258650553-10743-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Although mount recovery of nilfs is integrated in load_nilfs()
procedure, the completion of recovery was isolated from the procedure
and performed at the end of the fill_super routine.

This was somewhat confusing since the recovery is needed for the nilfs
object, not for a super block instance.

To resolve the inconsistency, this will integrate the recovery
completion into load_nilfs().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c     |   39 +++-----------------------
 fs/nilfs2/the_nilfs.c |   70 +++++++++++++++++++++++++++++++++---------------
 2 files changed, 53 insertions(+), 56 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index f526169..990ead4 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -414,22 +414,6 @@ void nilfs_detach_checkpoint(struct nilfs_sb_info *sbi)
 	up_write(&nilfs->ns_super_sem);
 }
 
-static int nilfs_mark_recovery_complete(struct nilfs_sb_info *sbi)
-{
-	struct the_nilfs *nilfs = sbi->s_nilfs;
-	int err = 0;
-
-	down_write(&nilfs->ns_sem);
-	if (!(nilfs->ns_mount_state & NILFS_VALID_FS)) {
-		nilfs->ns_mount_state |= NILFS_VALID_FS;
-		err = nilfs_commit_super(sbi, 1);
-		if (likely(!err))
-			printk(KERN_INFO "NILFS: recovery complete.\n");
-	}
-	up_write(&nilfs->ns_sem);
-	return err;
-}
-
 static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
@@ -649,9 +633,7 @@ static int nilfs_setup_super(struct nilfs_sb_info *sbi)
 	int mnt_count = le16_to_cpu(sbp->s_mnt_count);
 
 	/* nilfs->sem must be locked by the caller. */
-	if (!(nilfs->ns_mount_state & NILFS_VALID_FS)) {
-		printk(KERN_WARNING "NILFS warning: mounting unchecked fs\n");
-	} else if (nilfs->ns_mount_state & NILFS_ERROR_FS) {
+	if (nilfs->ns_mount_state & NILFS_ERROR_FS) {
 		printk(KERN_WARNING
 		       "NILFS warning: mounting fs with errors\n");
 #if 0
@@ -759,11 +741,10 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 	sb->s_root = NULL;
 	sb->s_time_gran = 1;
 
-	if (!nilfs_loaded(nilfs)) {
-		err = load_nilfs(nilfs, sbi);
-		if (err)
-			goto failed_sbi;
-	}
+	err = load_nilfs(nilfs, sbi);
+	if (err)
+		goto failed_sbi;
+
 	cno = nilfs_last_cno(nilfs);
 
 	if (sb->s_flags & MS_RDONLY) {
@@ -831,12 +812,6 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 		up_write(&nilfs->ns_sem);
 	}
 
-	err = nilfs_mark_recovery_complete(sbi);
-	if (unlikely(err)) {
-		printk(KERN_ERR "NILFS: recovery failed.\n");
-		goto failed_root;
-	}
-
 	down_write(&nilfs->ns_super_sem);
 	if (!nilfs_test_opt(sbi, SNAPSHOT))
 		nilfs->ns_current = sbi;
@@ -844,10 +819,6 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 
 	return 0;
 
- failed_root:
-	dput(sb->s_root);
-	sb->s_root = NULL;
-
  failed_segctor:
 	nilfs_detach_segment_constructor(sbi);
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 4d4d35c..aea2b58 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -262,28 +262,27 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 	unsigned int s_flags = sbi->s_super->s_flags;
 	int really_read_only = bdev_read_only(nilfs->ns_bdev);
 	unsigned valid_fs;
-	int err = 0;
+	int err;
 
-	nilfs_init_recovery_info(&ri);
+	if (nilfs_loaded(nilfs))
+		return 0;
 
 	down_write(&nilfs->ns_sem);
 	valid_fs = (nilfs->ns_mount_state & NILFS_VALID_FS);
 	up_write(&nilfs->ns_sem);
 
-	if (!valid_fs && (s_flags & MS_RDONLY)) {
-		printk(KERN_INFO "NILFS: INFO: recovery "
-		       "required for readonly filesystem.\n");
-		if (really_read_only) {
-			printk(KERN_ERR "NILFS: write access "
-			       "unavailable, cannot proceed.\n");
-			err = -EROFS;
-			goto failed;
+	if (!valid_fs) {
+		printk(KERN_WARNING "NILFS warning: mounting unchecked fs\n");
+		if (s_flags & MS_RDONLY) {
+			printk(KERN_INFO "NILFS: INFO: recovery "
+			       "required for readonly filesystem.\n");
+			printk(KERN_INFO "NILFS: write access will "
+			       "be enabled during recovery.\n");
 		}
-		printk(KERN_INFO "NILFS: write access will "
-		       "be enabled during recovery.\n");
-		sbi->s_super->s_flags &= ~MS_RDONLY;
 	}
 
+	nilfs_init_recovery_info(&ri);
+
 	err = nilfs_search_super_root(nilfs, sbi, &ri);
 	if (unlikely(err)) {
 		printk(KERN_ERR "NILFS: error searching super root.\n");
@@ -296,19 +295,46 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 		goto failed;
 	}
 
-	if (!valid_fs) {
-		err = nilfs_recover_logical_segments(nilfs, sbi, &ri);
-		if (unlikely(err)) {
-			nilfs_mdt_destroy(nilfs->ns_cpfile);
-			nilfs_mdt_destroy(nilfs->ns_sufile);
-			nilfs_mdt_destroy(nilfs->ns_dat);
-			goto failed;
+	if (valid_fs)
+		goto skip_recovery;
+
+	if (s_flags & MS_RDONLY) {
+		if (really_read_only) {
+			printk(KERN_ERR "NILFS: write access "
+			       "unavailable, cannot proceed.\n");
+			err = -EROFS;
+			goto failed_unload;
 		}
-		if (ri.ri_need_recovery == NILFS_RECOVERY_SR_UPDATED)
-			sbi->s_super->s_dirt = 1;
+		sbi->s_super->s_flags &= ~MS_RDONLY;
+	}
+
+	err = nilfs_recover_logical_segments(nilfs, sbi, &ri);
+	if (err)
+		goto failed_unload;
+
+	down_write(&nilfs->ns_sem);
+	nilfs->ns_mount_state |= NILFS_VALID_FS;
+	nilfs->ns_sbp[0]->s_state = cpu_to_le16(nilfs->ns_mount_state);
+	err = nilfs_commit_super(sbi, 1);
+	up_write(&nilfs->ns_sem);
+
+	if (err) {
+		printk(KERN_ERR "NILFS: failed to update super block. "
+		       "recovery unfinished.\n");
+		goto failed_unload;
 	}
+	printk(KERN_INFO "NILFS: recovery complete.\n");
 
+ skip_recovery:
 	set_nilfs_loaded(nilfs);
+	nilfs_clear_recovery_info(&ri);
+	sbi->s_super->s_flags = s_flags;
+	return 0;
+
+ failed_unload:
+	nilfs_mdt_destroy(nilfs->ns_cpfile);
+	nilfs_mdt_destroy(nilfs->ns_sufile);
+	nilfs_mdt_destroy(nilfs->ns_dat);
 
  failed:
 	nilfs_clear_recovery_info(&ri);
-- 
1.6.3.4
