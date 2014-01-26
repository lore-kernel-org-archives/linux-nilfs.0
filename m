From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] lib/nilfs.c: remove broken readonly fs check at nilfs_sync()
Date: Sun, 26 Jan 2014 17:02:37 +0900
Message-ID: <1390723358-31066-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_sync() API function is wrongly checking EROFS error.  It sees
the return value of ioctl instead of errno variable.  This removes the
broken error check from nilfs_sync() instead of fixing it because
EROFS should by rights be used or ignored by callers.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 lib/nilfs.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/lib/nilfs.c b/lib/nilfs.c
index 05b9b03..c1771e8 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -688,19 +688,12 @@ int nilfs_clean_segments(struct nilfs *nilfs,
  */
 int nilfs_sync(const struct nilfs *nilfs, nilfs_cno_t *cnop)
 {
-	int ret;
-
 	if (nilfs->n_iocfd < 0) {
 		errno = EBADF;
 		return -1;
 	}
 
-	ret = ioctl(nilfs->n_iocfd, NILFS_IOCTL_SYNC, cnop);
-	if (ret < 0 && ret == -EROFS)
-		/* syncing read-only filesystem */
-		ret = 0;
-
-	return ret;
+	return ioctl(nilfs->n_iocfd, NILFS_IOCTL_SYNC, cnop);
 }
 
 /**
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
