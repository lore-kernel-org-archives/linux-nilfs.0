From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: replace MS_VERBOSE with MS_SILENT
Date: Sun,  9 May 2010 11:14:27 +0900
Message-ID: <1273371268-25256-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

MS_VERBOSE is deprecated.  This replaces it with MS_SILENT in
reference to get_sb_bdev function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 7772e43..22cdd94 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1075,7 +1075,8 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 		strlcpy(s->s_id, bdevname(sd.bdev, b), sizeof(s->s_id));
 		sb_set_blocksize(s, block_size(sd.bdev));
 
-		err = nilfs_fill_super(s, data, flags & MS_VERBOSE, nilfs);
+		err = nilfs_fill_super(s, data, flags & MS_SILENT ? 1 : 0,
+				       nilfs);
 		if (err)
 			goto cancel_new;
 
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
