From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/4] nilfs2: add norepair mount option
Date: Fri, 20 Nov 2009 02:09:13 +0900
Message-ID: <1258650553-10743-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This adds norepair mount option that allows users to avoid temporal
write access to a read-only mount or snapshots during mount/recovery.
Without this option, write access will be even performed for those
types of mounts; the temporal write access is needed to mount root
file system read-only after an unclean shutdown.

This option is useful for users to avoid any write access on the
device.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 Documentation/filesystems/nilfs2.txt |    4 ++++
 fs/nilfs2/super.c                    |   14 +++++++++++++-
 fs/nilfs2/the_nilfs.c                |   20 ++++++++++++++++++--
 include/linux/nilfs2_fs.h            |    2 ++
 4 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/nilfs2.txt b/Documentation/filesystems/nilfs2.txt
index cbd8779..77b2c25 100644
--- a/Documentation/filesystems/nilfs2.txt
+++ b/Documentation/filesystems/nilfs2.txt
@@ -70,6 +70,10 @@ order=strict		Apply strict in-order semantics that preserves sequence
 			blocks.  That means, it is guaranteed that no
 			overtaking of events occurs in the recovered file
 			system after a crash.
+norepair		Disable repair action of filesystem on mount.
+			This disables every write access on the device for
+			read-only mount or snapshots.  This option will fail
+			for r/w mounts on an unclean volume.
 
 NILFS2 usage
 ============
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 990ead4..d516316 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -547,7 +547,7 @@ static const struct export_operations nilfs_export_ops = {
 
 enum {
 	Opt_err_cont, Opt_err_panic, Opt_err_ro,
-	Opt_nobarrier, Opt_snapshot, Opt_order,
+	Opt_nobarrier, Opt_snapshot, Opt_order, Opt_norepair,
 	Opt_err,
 };
 
@@ -558,6 +558,7 @@ static match_table_t tokens = {
 	{Opt_nobarrier, "nobarrier"},
 	{Opt_snapshot, "cp=%u"},
 	{Opt_order, "order=%s"},
+	{Opt_norepair, "norepair"},
 	{Opt_err, NULL}
 };
 
@@ -608,6 +609,9 @@ static int parse_options(char *options, struct super_block *sb)
 			sbi->s_snapshot_cno = option;
 			nilfs_set_opt(sbi, SNAPSHOT);
 			break;
+		case Opt_norepair:
+			nilfs_set_opt(sbi, NOREPAIR);
+			break;
 		default:
 			printk(KERN_ERR
 			       "NILFS: Unrecognized mount option \"%s\"\n", p);
@@ -863,6 +867,14 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
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
index 890a8d3..352fed9 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -264,8 +264,14 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 	int valid_fs = nilfs_valid_fs(nilfs);
 	int err;
 
-	if (nilfs_loaded(nilfs))
-		return 0;
+	if (nilfs_loaded(nilfs)) {
+		if (valid_fs ||
+		    ((s_flags & MS_RDONLY) && nilfs_test_opt(sbi, NOREPAIR)))
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
+		if (nilfs_test_opt(sbi, NOREPAIR)) {
+			printk(KERN_INFO "NILFS: norepair option specified. "
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
+	} else if (nilfs_test_opt(sbi, NOREPAIR)) {
+		printk(KERN_ERR "NILFS: recovery cancelled because norepair "
+		       "option was specified for a read/write mount\n");
+		err = -EINVAL;
+		goto failed_unload;
 	}
 
 	err = nilfs_recover_logical_segments(nilfs, sbi, &ri);
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 72289d2..8376fcb 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -151,6 +151,8 @@ struct nilfs_super_root {
 #define NILFS_MOUNT_BARRIER		0x1000  /* Use block barriers */
 #define NILFS_MOUNT_STRICT_ORDER	0x2000  /* Apply strict in-order
 						   semantics also for data */
+#define NILFS_MOUNT_NOREPAIR		0x4000  /* Disable write access during
+						   mount-time recovery */
 
 
 /**
-- 
1.6.3.4
