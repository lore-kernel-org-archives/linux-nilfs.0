From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/5] nilfs2: add nodiscard mount option
Date: Tue,  6 Jul 2010 00:09:47 +0900
Message-ID: <1278342590-5912-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1278342590-5912-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1278342590-5912-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Nilfs has "discard" mount option which issues discard/TRIM commands to
underlying block device, but it lacks a complementary option and has
no way to disable the feature through remount.

This adds "nodiscard" option to resolve this imbalance.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 Documentation/filesystems/nilfs2.txt |    7 ++++---
 fs/nilfs2/super.c                    |    6 +++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/nilfs2.txt b/Documentation/filesystems/nilfs2.txt
index 54f61c0..d5c0cef 100644
--- a/Documentation/filesystems/nilfs2.txt
+++ b/Documentation/filesystems/nilfs2.txt
@@ -77,9 +77,10 @@ norecovery		Disable recovery of the filesystem on mount.
 			This disables every write access on the device for
 			read-only mounts or snapshots.  This option will fail
 			for r/w mounts on an unclean volume.
-discard			Issue discard/TRIM commands to the underlying block
-			device when blocks are freed.  This is useful for SSD
-			devices and sparse/thinly-provisioned LUNs.
+discard			This enables/disables the use of discard/TRIM commands.
+nodiscard(*)		The discard/TRIM commands are sent to the underlying
+			block device when blocks are freed.  This is useful
+			for SSD devices and sparse/thinly-provisioned LUNs.
 
 NILFS2 usage
 ============
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 7d77913..26e1046 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -599,7 +599,7 @@ static const struct export_operations nilfs_export_ops = {
 enum {
 	Opt_err_cont, Opt_err_panic, Opt_err_ro,
 	Opt_barrier, Opt_nobarrier, Opt_snapshot, Opt_order, Opt_norecovery,
-	Opt_discard, Opt_err,
+	Opt_discard, Opt_nodiscard, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -612,6 +612,7 @@ static match_table_t tokens = {
 	{Opt_order, "order=%s"},
 	{Opt_norecovery, "norecovery"},
 	{Opt_discard, "discard"},
+	{Opt_nodiscard, "nodiscard"},
 	{Opt_err, NULL}
 };
 
@@ -671,6 +672,9 @@ static int parse_options(char *options, struct super_block *sb)
 		case Opt_discard:
 			nilfs_set_opt(sbi, DISCARD);
 			break;
+		case Opt_nodiscard:
+			nilfs_clear_opt(sbi, DISCARD);
+			break;
 		default:
 			printk(KERN_ERR
 			       "NILFS: Unrecognized mount option \"%s\"\n", p);
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
