From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: fix leak of shadow dat inode in error path of load_nilfs
Date: Sun, 29 Aug 2010 02:40:51 +0900
Message-ID: <1283017251-25573-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

If load_nilfs() gets an error while doing recovery, it will fail to
free the shadow inode of dat (nilfs->ns_gc_dat).

This fixes the leak issue.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/the_nilfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 4317f17..ba7c10c 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -446,6 +446,7 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 	nilfs_mdt_destroy(nilfs->ns_cpfile);
 	nilfs_mdt_destroy(nilfs->ns_sufile);
 	nilfs_mdt_destroy(nilfs->ns_dat);
+	nilfs_mdt_destroy(nilfs->ns_gc_dat);
 
  failed:
 	nilfs_clear_recovery_info(&ri);
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
