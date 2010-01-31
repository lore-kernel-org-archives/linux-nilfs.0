From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: fix potential leak of dirty data on umount
Date: Sun, 31 Jan 2010 15:07:45 +0900
Message-ID: <1264918065-2012-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This fixes incorrect usage of nilfs_segctor_confirm() test function in
nilfs_segctor_destroy(); nilfs_segctor_confirm() returns zero if the
filesystem is not clean, so its use in nilfs_segctor_destroy() needs
inversion.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segment.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 17584c5..105b508 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2829,7 +2829,7 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 		|| sci->sc_seq_request != sci->sc_seq_done);
 	spin_unlock(&sci->sc_state_lock);
 
-	if (flag || nilfs_segctor_confirm(sci))
+	if (flag || !nilfs_segctor_confirm(sci))
 		nilfs_segctor_write_out(sci);
 
 	WARN_ON(!list_empty(&sci->sc_copied_buffers));
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
