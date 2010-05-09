From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: disallow remount of snapshot from/to a regular mount
Date: Sun,  9 May 2010 23:20:22 +0900
Message-ID: <1273414822-29228-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Snapshots and regular ro/rw mounts are essentially-different within
the meaning whether the checkpoint is static or not and is marked with
a snapshot flag or not.

The current implemenation, however, allows to remount a snapshot to a
regular rw-mount if the checkpoint number equals the latest one.

This transition is actually impossible since changing a checkpoint to
a snapshot makes another checkpoint, thus the condition is never
satisfied.

This fixes the weird state of affairs, and specifically separates
snapshots and regular rw/ro-mounts.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c |   57 +++++++++++++++++++++-------------------------------
 1 files changed, 23 insertions(+), 34 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 53ed08e..bb2e266 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -753,9 +753,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 				goto failed_sbi;
 			}
 			cno = sbi->s_snapshot_cno;
-		} else
-			/* Read-only mount */
-			sbi->s_snapshot_cno = cno;
+		}
 	}
 
 	err = nilfs_attach_checkpoint(sbi, cno);
@@ -824,7 +822,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	unsigned long old_sb_flags;
 	struct nilfs_mount_options old_opts;
-	int err;
+	int was_snapshot, err;
 
 	lock_kernel();
 
@@ -832,6 +830,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	old_sb_flags = sb->s_flags;
 	old_opts.mount_opt = sbi->s_mount_opt;
 	old_opts.snapshot_cno = sbi->s_snapshot_cno;
+	was_snapshot = nilfs_test_opt(sbi, SNAPSHOT);
 
 	if (!parse_options(data, sb)) {
 		err = -EINVAL;
@@ -839,20 +838,32 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	}
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL);
 
-	if ((*flags & MS_RDONLY) &&
-	    sbi->s_snapshot_cno != old_opts.snapshot_cno) {
-		printk(KERN_WARNING "NILFS (device %s): couldn't "
-		       "remount to a different snapshot.\n",
-		       sb->s_id);
-		err = -EINVAL;
-		goto restore_opts;
+	err = -EINVAL;
+	if (was_snapshot) {
+		if (!(*flags & MS_RDONLY)) {
+			printk(KERN_ERR "NILFS (device %s): cannot remount "
+			       "snapshot read/write.\n",
+			       sb->s_id);
+			goto restore_opts;
+		} else if (sbi->s_snapshot_cno != old_opts.snapshot_cno) {
+			printk(KERN_ERR "NILFS (device %s): cannot "
+			       "remount to a different snapshot.\n",
+			       sb->s_id);
+			goto restore_opts;
+		}
+	} else {
+		if (nilfs_test_opt(sbi, SNAPSHOT)) {
+			printk(KERN_ERR "NILFS (device %s): cannot change "
+			       "a regular mount to a snapshot.\n",
+			       sb->s_id);
+			goto restore_opts;
+		}
 	}
 
 	if (!nilfs_valid_fs(nilfs)) {
 		printk(KERN_WARNING "NILFS (device %s): couldn't "
 		       "remount because the filesystem is in an "
 		       "incomplete recovery state.\n", sb->s_id);
-		err = -EINVAL;
 		goto restore_opts;
 	}
 
@@ -863,9 +874,6 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		nilfs_detach_segment_constructor(sbi);
 		sb->s_flags |= MS_RDONLY;
 
-		sbi->s_snapshot_cno = nilfs_last_cno(nilfs);
-		/* nilfs_set_opt(sbi, SNAPSHOT); */
-
 		/*
 		 * Remounting a valid RW partition RDONLY, so set
 		 * the RDONLY flag and then mark the partition as valid again.
@@ -884,24 +892,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		 * store the current valid flag.  (It may have been changed
 		 * by fsck since we originally mounted the partition.)
 		 */
-		if (nilfs->ns_current && nilfs->ns_current != sbi) {
-			printk(KERN_WARNING "NILFS (device %s): couldn't "
-			       "remount because an RW-mount exists.\n",
-			       sb->s_id);
-			err = -EBUSY;
-			goto restore_opts;
-		}
-		if (sbi->s_snapshot_cno != nilfs_last_cno(nilfs)) {
-			printk(KERN_WARNING "NILFS (device %s): couldn't "
-			       "remount because the current RO-mount is not "
-			       "the latest one.\n",
-			       sb->s_id);
-			err = -EINVAL;
-			goto restore_opts;
-		}
 		sb->s_flags &= ~MS_RDONLY;
-		nilfs_clear_opt(sbi, SNAPSHOT);
-		sbi->s_snapshot_cno = 0;
 
 		err = nilfs_attach_segment_constructor(sbi);
 		if (err)
@@ -910,8 +901,6 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		down_write(&nilfs->ns_sem);
 		nilfs_setup_super(sbi);
 		up_write(&nilfs->ns_sem);
-
-		nilfs->ns_current = sbi;
 	}
  out:
 	up_write(&nilfs->ns_super_sem);
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
