From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: crash
Date: Thu, 11 Feb 2010 14:30:01 +0900 (JST)
Message-ID: <20100211.143001.184824921.ryusuke@osrg.net>
References: <20100210.130700.55835591.ryusuke@osrg.net>
	<ee5afd761002092314i1ba1ec66ie6fe7d0f22d6927e@mail.gmail.com>
	<ee5afd761002092326k3bb3a74fq7145cdb9925d88d5@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ee5afd761002092326k3bb3a74fq7145cdb9925d88d5-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Wed, 10 Feb 2010 09:26:46 +0200, Jan de Kruyf wrote:
> Hallo,
> This patch never made it to the module tree:
> 
> from    Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
> to    users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org,
> sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> cc    jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
> konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org
> date    Thu, Nov 19, 2009 at 9:10 PM
> subject    Re: [NILFS users] [PATCH 4/4] nilfs2: add norepair mount option
> 
> 
> Could I apply the original patch without a problem to the latest module tree?
> 
> from    Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
> to    users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org,
> jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> date    Sat, Nov 7, 2009 at 9:28 PM
> subject    Re: [NILFS users] [SPAM] Re: [SPAM] Re: urgent help need!
> disk partition info lost
> 
> Regards,
> 
> Jan de Kruyf.

The patch looks a bit old.

I attached the latest patch against 2.0.18.

Maybe both are safe, but this new one would be better.

Regards,
Ryusuke Konishi

--
diff --git a/fs/nilfs2_fs.h b/fs/nilfs2_fs.h
index ce52040..2e4cbd1 100644
--- a/fs/nilfs2_fs.h
+++ b/fs/nilfs2_fs.h
@@ -151,6 +151,8 @@ struct nilfs_super_root {
 #define NILFS_MOUNT_BARRIER		0x1000  /* Use block barriers */
 #define NILFS_MOUNT_STRICT_ORDER	0x2000  /* Apply strict in-order
 						   semantics also for data */
+#define NILFS_MOUNT_NORECOVERY		0x4000  /* Disable write access during
+						   mount-time recovery */
 
 
 /**
diff --git a/fs/super.c b/fs/super.c
index c9acc9a..d15ede2 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -505,22 +505,6 @@ void nilfs_detach_checkpoint(struct nilfs_sb_info *sbi)
 	nilfs_debug(2, "detached ifile\n");
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
@@ -649,7 +633,7 @@ static struct export_operations nilfs_export_ops = {
 
 enum {
 	Opt_err_cont, Opt_err_panic, Opt_err_ro,
-	Opt_barrier, Opt_snapshot, Opt_order,
+	Opt_barrier, Opt_snapshot, Opt_order, Opt_norecovery,
 	Opt_err,
 };
 
@@ -660,6 +644,7 @@ static match_table_t tokens = {
 	{Opt_barrier, "barrier=%s"},
 	{Opt_snapshot, "cp=%u"},
 	{Opt_order, "order=%s"},
+	{Opt_norecovery, "norecovery"},
 	{Opt_err, NULL}
 };
 
@@ -728,6 +713,9 @@ static int parse_options(char *options, struct super_block *sb)
 			sbi->s_snapshot_cno = option;
 			nilfs_set_opt(sbi, SNAPSHOT);
 			break;
+		case Opt_norecovery:
+			nilfs_set_opt(sbi, NORECOVERY);
+			break;
 		default:
 			printk(KERN_ERR
 			       "NILFS: Unrecognized mount option \"%s\"\n", p);
@@ -753,9 +741,7 @@ static int nilfs_setup_super(struct nilfs_sb_info *sbi)
 	int mnt_count = le16_to_cpu(sbp->s_mnt_count);
 
 	/* nilfs->sem must be locked by the caller. */
-	if (!(nilfs->ns_mount_state & NILFS_VALID_FS)) {
-		printk(KERN_WARNING "NILFS warning: mounting unchecked fs\n");
-	} else if (nilfs->ns_mount_state & NILFS_ERROR_FS) {
+	if (nilfs->ns_mount_state & NILFS_ERROR_FS) {
 		printk(KERN_WARNING
 		       "NILFS warning: mounting fs with errors\n");
 #if 0
@@ -865,11 +851,10 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
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
@@ -946,12 +931,6 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
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
@@ -960,10 +939,6 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 	nilfs_debug(1, "mounted filesystem\n");
 	return 0;
 
- failed_root:
-	dput(sb->s_root);
-	sb->s_root = NULL;
-
  failed_segctor:
 	nilfs_detach_segment_constructor(sbi);
 
@@ -1008,6 +983,14 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		goto restore_opts;
 	}
 
+	if (!nilfs_valid_fs(nilfs)) {
+		printk(KERN_WARNING "NILFS (device %s): couldn't "
+		       "remount because the filesystem is in an "
+		       "incomplete recovery state.\n", sb->s_id);
+		err = -EINVAL;
+		goto restore_opts;
+	}
+
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
 		goto out;
 	if (*flags & MS_RDONLY) {
diff --git a/fs/the_nilfs.c b/fs/the_nilfs.c
index 365971b..028f378 100644
--- a/fs/the_nilfs.c
+++ b/fs/the_nilfs.c
@@ -294,29 +294,30 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 	struct nilfs_recovery_info ri;
 	unsigned int s_flags = sbi->s_super->s_flags;
 	int really_read_only = bdev_read_only(nilfs->ns_bdev);
-	unsigned valid_fs;
-	int err = 0;
-
-	nilfs_init_recovery_info(&ri);
+	int valid_fs = nilfs_valid_fs(nilfs);
+	int err;
 
-	down_write(&nilfs->ns_sem);
-	valid_fs = (nilfs->ns_mount_state & NILFS_VALID_FS);
-	up_write(&nilfs->ns_sem);
+	if (nilfs_loaded(nilfs)) {
+		if (valid_fs ||
+		    ((s_flags & MS_RDONLY) && nilfs_test_opt(sbi, NORECOVERY)))
+			return 0;
+		printk(KERN_ERR "NILFS: the filesystem is in an incomplete "
+		       "recovery state.\n");
+		return -EINVAL;
+	}
 
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
@@ -329,19 +330,56 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
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
+		if (nilfs_test_opt(sbi, NORECOVERY)) {
+			printk(KERN_INFO "NILFS: norecovery option specified. "
+			       "skipping roll-forward recovery\n");
+			goto skip_recovery;
 		}
-		if (ri.ri_need_recovery == NILFS_RECOVERY_SR_UPDATED)
-			sbi->s_super->s_dirt = 1;
+		if (really_read_only) {
+			printk(KERN_ERR "NILFS: write access "
+			       "unavailable, cannot proceed.\n");
+			err = -EROFS;
+			goto failed_unload;
+		}
+		sbi->s_super->s_flags &= ~MS_RDONLY;
+	} else if (nilfs_test_opt(sbi, NORECOVERY)) {
+		printk(KERN_ERR "NILFS: recovery cancelled because norecovery "
+		       "option was specified for a read/write mount\n");
+		err = -EINVAL;
+		goto failed_unload;
 	}
 
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
+	}
+	printk(KERN_INFO "NILFS: recovery complete.\n");
+
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
diff --git a/fs/the_nilfs.h b/fs/the_nilfs.h
index fa3a1df..25c24a0 100644
--- a/fs/the_nilfs.h
+++ b/fs/the_nilfs.h
@@ -242,6 +242,16 @@ static inline void nilfs_put_sbinfo(struct nilfs_sb_info *sbi)
 		kfree(sbi);
 }
 
+static inline int nilfs_valid_fs(struct the_nilfs *nilfs)
+{
+	unsigned valid_fs;
+
+	down_read(&nilfs->ns_sem);
+	valid_fs = (nilfs->ns_mount_state & NILFS_VALID_FS);
+	up_read(&nilfs->ns_sem);
+	return valid_fs;
+}
+
 static inline void
 nilfs_get_segment_range(struct the_nilfs *nilfs, __u64 segnum,
 			sector_t *seg_start, sector_t *seg_end)
diff --git a/nilfs2.txt b/nilfs2.txt
index dbbda00..906b505 100644
--- a/nilfs2.txt
+++ b/nilfs2.txt
@@ -71,6 +71,10 @@ order=strict		Apply strict in-order semantics that preserves sequence
 			blocks.  That means, it is guaranteed that no
 			overtaking of events occurs in the recovered file
 			system after a crash.
+norecovery		Disable recovery of the filesystem on mount.
+			This disables every write access on the device for
+			read-only mounts or snapshots.  This option will fail
+			for r/w mounts on an unclean volume.
 
 NILFS2 usage
 ============
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
