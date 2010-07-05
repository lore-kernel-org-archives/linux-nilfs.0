From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/5] nilfs2: use seq_puts to print mount options without argument
Date: Tue,  6 Jul 2010 00:09:48 +0900
Message-ID: <1278342590-5912-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This replaces seq_printf() with seq_puts() in nilfs_show_options for
mount options which have no argument.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 26e1046..fb02e4a 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -516,20 +516,20 @@ static int nilfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
 
 	if (!nilfs_test_opt(sbi, BARRIER))
-		seq_printf(seq, ",nobarrier");
+		seq_puts(seq, ",nobarrier");
 	if (nilfs_test_opt(sbi, SNAPSHOT))
 		seq_printf(seq, ",cp=%llu",
 			   (unsigned long long int)sbi->s_snapshot_cno);
 	if (nilfs_test_opt(sbi, ERRORS_PANIC))
-		seq_printf(seq, ",errors=panic");
+		seq_puts(seq, ",errors=panic");
 	if (nilfs_test_opt(sbi, ERRORS_CONT))
-		seq_printf(seq, ",errors=continue");
+		seq_puts(seq, ",errors=continue");
 	if (nilfs_test_opt(sbi, STRICT_ORDER))
-		seq_printf(seq, ",order=strict");
+		seq_puts(seq, ",order=strict");
 	if (nilfs_test_opt(sbi, NORECOVERY))
-		seq_printf(seq, ",norecovery");
+		seq_puts(seq, ",norecovery");
 	if (nilfs_test_opt(sbi, DISCARD))
-		seq_printf(seq, ",discard");
+		seq_puts(seq, ",discard");
 
 	return 0;
 }
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
