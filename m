From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: update comment on deactivate_super at nilfs_get_sb
Date: Sun,  9 May 2010 11:14:28 +0900
Message-ID: <1273371268-25256-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1273371268-25256-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1273371268-25256-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

deactivate_super was replaced with deactivate_locked_super, but the
comment of nilfs_get_sb remain unchanged.  This renews the comment.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 22cdd94..53ed08e 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1105,7 +1105,7 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	put_nilfs(nilfs);
 	deactivate_locked_super(s);
 	/*
-	 * deactivate_super() invokes close_bdev_exclusive().
+	 * deactivate_locked_super() invokes close_bdev_exclusive().
 	 * We must finish all post-cleaning before this call;
 	 * put_nilfs() needs the block device.
 	 */
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
