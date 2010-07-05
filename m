From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/5] nilfs2: add barrier mount option
Date: Tue,  6 Jul 2010 00:09:46 +0900
Message-ID: <1278342590-5912-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

Nilfs enables write barriers by default and has "nobarrier" mount
option to disable this feature.  But it lacks the complementary option
and has no way to re-enable the feature on remount.

This adds "barrier" option to resolve this imbalance.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 Documentation/filesystems/nilfs2.txt |    5 ++++-
 fs/nilfs2/super.c                    |    6 +++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/nilfs2.txt b/Documentation/filesystems/nilfs2.txt
index d3e7673..54f61c0 100644
--- a/Documentation/filesystems/nilfs2.txt
+++ b/Documentation/filesystems/nilfs2.txt
@@ -49,7 +49,10 @@ Mount options
 NILFS2 supports the following mount options:
 (*) == default
 
-nobarrier		Disables barriers.
+barrier(*)		This enables/disables the use of write barriers.  This
+nobarrier		requires an IO stack which can support barriers, and
+			if nilfs gets an error on a barrier write, it will
+			disable again with a warning.
 errors=continue		Keep going on a filesystem error.
 errors=remount-ro(*)	Remount the filesystem read-only on an error.
 errors=panic		Panic and halt the machine if an error occurs.
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 29be735..7d77913 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -598,7 +598,7 @@ static const struct export_operations nilfs_export_ops = {
 
 enum {
 	Opt_err_cont, Opt_err_panic, Opt_err_ro,
-	Opt_nobarrier, Opt_snapshot, Opt_order, Opt_norecovery,
+	Opt_barrier, Opt_nobarrier, Opt_snapshot, Opt_order, Opt_norecovery,
 	Opt_discard, Opt_err,
 };
 
@@ -606,6 +606,7 @@ static match_table_t tokens = {
 	{Opt_err_cont, "errors=continue"},
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
+	{Opt_barrier, "barrier"},
 	{Opt_nobarrier, "nobarrier"},
 	{Opt_snapshot, "cp=%u"},
 	{Opt_order, "order=%s"},
@@ -631,6 +632,9 @@ static int parse_options(char *options, struct super_block *sb)
 
 		token = match_token(p, tokens, args);
 		switch (token) {
+		case Opt_barrier:
+			nilfs_set_opt(sbi, BARRIER);
+			break;
 		case Opt_nobarrier:
 			nilfs_clear_opt(sbi, BARRIER);
 			break;
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
