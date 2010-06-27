From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: do not update mount time on rw->ro remount
Date: Sun, 27 Jun 2010 21:58:58 +0900
Message-ID: <1277643538-733-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Mount time field in super block is wrongly updated when nilfs remounts
the partition from read-write to read-only.  This fixes the issue.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 414ef68..39b28cf 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -884,7 +884,6 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		if (!(sbp->s_state & le16_to_cpu(NILFS_VALID_FS)) &&
 		    (nilfs->ns_mount_state & NILFS_VALID_FS))
 			sbp->s_state = cpu_to_le16(nilfs->ns_mount_state);
-		sbp->s_mtime = cpu_to_le64(get_seconds());
 		nilfs_commit_super(sbi, 1);
 		up_write(&nilfs->ns_sem);
 	} else {
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
