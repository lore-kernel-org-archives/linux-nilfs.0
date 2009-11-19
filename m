From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 4/4] nilfs2: add norepair mount option
Date: Fri, 20 Nov 2009 04:10:11 +0900 (JST)
Message-ID: <20091120.041011.123624190.ryusuke@osrg.net>
References: <1258650553-10743-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<4B05821C.4030901@redhat.com>
	<20091120.031015.04647165.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20091120.031015.04647165.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Fri, 20 Nov 2009 03:10:15 +0900 (JST), Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> Hi,
> On Thu, 19 Nov 2009 11:36:28 -0600, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > Ryusuke Konishi wrote:
> > > This adds norepair mount option that allows users to avoid temporal
> > > write access to a read-only mount or snapshots during mount/recovery.
> > > Without this option, write access will be even performed for those
> > > types of mounts; the temporal write access is needed to mount root
> > > file system read-only after an unclean shutdown.
> > > 
> > > This option is useful for users to avoid any write access on the
> > > device.
> > 
> > For what it's worth, ext3 & ext4 just added a "norecovery" option as
> > an alias to "noload" which skips journal replay; xfs already has
> > "norecovery" - so if you wish to be consistent with ext3/ext4/xfs,
> > "norecovery" may be a good choice for the option?
> > 
> > Thanks,
> > -Eric
> 
> Thank you! OK, I'll take your advice.
> 
> Ryusuke

Here is a revised version.  I also fixed that the previous patch did
not support "show option" interface.

Thanks,
Ryusuke Konishi
--
Author: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Date:   Fri Nov 20 03:28:01 2009 +0900

    nilfs2: add norecovery mount option
    
    This adds "norecovery" mount option which disables temporal write
    access to read-only mounts or snapshots during mount/recovery.
    Without this option, write access will be even performed for those
    types of mounts; the temporal write access is needed to mount root
    file system read-only after an unclean shutdown.
    
    This option will be helpful when user wants to prevent any write
    access to the device.
    
    Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
    Cc: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

diff --git a/Documentation/filesystems/nilfs2.txt b/Documentation/filesystems/nilfs2.txt
index cbd8779..4949fca 100644
--- a/Documentation/filesystems/nilfs2.txt
+++ b/Documentation/filesystems/nilfs2.txt
@@ -70,6 +70,10 @@ order=strict		Apply strict in-order semantics that preserves sequence
 			blocks.  That means, it is guaranteed that no
 			overtaking of events occurs in the recovered file
 			system after a crash.
+norecovery		Disable recovery of the filesystem on mount.
+			This disables every write access on the device for
+			read-only mounts or snapshots.  This option will fail
+			for r/w mounts on an unclean volume.
 
 NILFS2 usage
 ============
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 990ead4..5403b3e 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -479,6 +479,8 @@ static int nilfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_printf(seq, ",errors=panic");
 	if (nilfs_test_opt(sbi, STRICT_ORDER))
 		seq_printf(seq, ",order=strict");
+	if (nilfs_test_opt(sbi, NORECOVERY))
+		seq_printf(seq, ",norecovery");
 
 	return 0;
 }
@@ -547,7 +549,7 @@ static const struct export_operations nilfs_export_ops = {
 
 enum {
 	Opt_err_cont, Opt_err_panic, Opt_err_ro,
-	Opt_nobarrier, Opt_snapshot, Opt_order,
+	Opt_nobarrier, Opt_snapshot, Opt_order, Opt_norecovery,
 	Opt_err,
 };
 
@@ -558,6 +560,7 @@ static match_table_t tokens = {
 	{Opt_nobarrier, "nobarrier"},
 	{Opt_snapshot, "cp=%u"},
 	{Opt_order, "order=%s"},
+	{Opt_norecovery, "norecovery"},
 	{Opt_err, NULL}
 };
 
@@ -608,6 +611,9 @@ static int parse_options(char *options, struct super_block *sb)
 			sbi->s_snapshot_cno = option;
 			nilfs_set_opt(sbi, SNAPSHOT);
 			break;
+		case Opt_norecovery:
+			nilfs_set_opt(sbi, NORECOVERY);
+			break;
 		default:
 			printk(KERN_ERR
 			       "NILFS: Unrecognized mount option \"%s\"\n", p);
@@ -863,6 +869,14 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
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
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 890a8d3..6241e17 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -264,8 +264,14 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 	int valid_fs = nilfs_valid_fs(nilfs);
 	int err;
 
-	if (nilfs_loaded(nilfs))
-		return 0;
+	if (nilfs_loaded(nilfs)) {
+		if (valid_fs ||
+		    ((s_flags & MS_RDONLY) && nilfs_test_opt(sbi, NORECOVERY)))
+			return 0;
+		printk(KERN_ERR "NILFS: the filesystem is in an incomplete "
+		       "recovery state.\n");
+		return -EINVAL;
+	}
 
 	if (!valid_fs) {
 		printk(KERN_WARNING "NILFS warning: mounting unchecked fs\n");
@@ -295,6 +301,11 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 		goto skip_recovery;
 
 	if (s_flags & MS_RDONLY) {
+		if (nilfs_test_opt(sbi, NORECOVERY)) {
+			printk(KERN_INFO "NILFS: norecovery option specified. "
+			       "skipping roll-forward recovery\n");
+			goto skip_recovery;
+		}
 		if (really_read_only) {
 			printk(KERN_ERR "NILFS: write access "
 			       "unavailable, cannot proceed.\n");
@@ -302,6 +313,11 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 			goto failed_unload;
 		}
 		sbi->s_super->s_flags &= ~MS_RDONLY;
+	} else if (nilfs_test_opt(sbi, NORECOVERY)) {
+		printk(KERN_ERR "NILFS: recovery cancelled because norecovery "
+		       "option was specified for a read/write mount\n");
+		err = -EINVAL;
+		goto failed_unload;
 	}
 
 	err = nilfs_recover_logical_segments(nilfs, sbi, &ri);
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 72289d2..3fe02cf 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -151,6 +151,8 @@ struct nilfs_super_root {
 #define NILFS_MOUNT_BARRIER		0x1000  /* Use block barriers */
 #define NILFS_MOUNT_STRICT_ORDER	0x2000  /* Apply strict in-order
 						   semantics also for data */
+#define NILFS_MOUNT_NORECOVERY		0x4000  /* Disable write access during
+						   mount-time recovery */
 
 
 /**
