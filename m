From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: [PATCH] nilfs2: change default of 'errors' mount option to
 'remount-ro' mode
Date: Fri, 02 Apr 2010 19:31:15 +0900 (JST)
Message-ID: <20100402.193115.101588644.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

This patch changes the default mode of "errors=xxx" mount option.

The current default is "errors=continue" and I think this is not
preferable in terms of minimizing damage on severe errors.

So, I'm planning to send this to linux-next.

Note that this patch should be used along with a bugfix ("nilfs2: fix
potential hang in nilfs_error on errors=remount-ro") if applied to
2.6.33 or older kernels.  Without the bugfix, the filesystem has
potential to hang during the remount action (the bugfix is already
merged to the upstream kernel).

Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Like ext3, nilfs has 'errors' mount option to allow specifying desired
behavior on severe errors.

Currently, the default action is 'errors=continue' and has potential
to advance filesystem corruption for severe errors.

This will change the action to 'errors=remount-ro' to avoid the issue.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 Documentation/filesystems/nilfs2.txt |    4 ++--
 fs/nilfs2/super.c                    |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/nilfs2.txt b/Documentation/filesystems/nilfs2.txt
index cf6d0d8..d3e7673 100644
--- a/Documentation/filesystems/nilfs2.txt
+++ b/Documentation/filesystems/nilfs2.txt
@@ -50,8 +50,8 @@ NILFS2 supports the following mount options:
 (*) == default
 
 nobarrier		Disables barriers.
-errors=continue(*)	Keep going on a filesystem error.
-errors=remount-ro	Remount the filesystem read-only on an error.
+errors=continue		Keep going on a filesystem error.
+errors=remount-ro(*)	Remount the filesystem read-only on an error.
 errors=panic		Panic and halt the machine if an error occurs.
 cp=n			Specify the checkpoint-number of the snapshot to be
 			mounted.  Checkpoints and snapshots are listed by lscp
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 0cdbc5e..aa1ad6c 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -470,10 +470,10 @@ static int nilfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (nilfs_test_opt(sbi, SNAPSHOT))
 		seq_printf(seq, ",cp=%llu",
 			   (unsigned long long int)sbi->s_snapshot_cno);
-	if (nilfs_test_opt(sbi, ERRORS_RO))
-		seq_printf(seq, ",errors=remount-ro");
 	if (nilfs_test_opt(sbi, ERRORS_PANIC))
 		seq_printf(seq, ",errors=panic");
+	if (nilfs_test_opt(sbi, ERRORS_CONT))
+		seq_printf(seq, ",errors=continue");
 	if (nilfs_test_opt(sbi, STRICT_ORDER))
 		seq_printf(seq, ",order=strict");
 	if (nilfs_test_opt(sbi, NORECOVERY))
@@ -631,7 +631,7 @@ nilfs_set_default_options(struct nilfs_sb_info *sbi,
 			  struct nilfs_super_block *sbp)
 {
 	sbi->s_mount_opt =
-		NILFS_MOUNT_ERRORS_CONT | NILFS_MOUNT_BARRIER;
+		NILFS_MOUNT_ERRORS_RO | NILFS_MOUNT_BARRIER;
 }
 
 static int nilfs_setup_super(struct nilfs_sb_info *sbi)
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
