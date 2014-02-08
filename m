From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] lib/gc.c: remove redundant NULL check before nilfs_vector_destroy()
Date: Sat,  8 Feb 2014 16:20:09 +0900
Message-ID: <1391844009-18395-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_vector_destroy() does nothing if the given argument is NULL,
thus we don't have to do a NULL check before calling
nilfs_vector_destroy().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 lib/gc.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/lib/gc.c b/lib/gc.c
index cd540ad..1119fa8 100644
--- a/lib/gc.c
+++ b/lib/gc.c
@@ -811,16 +811,11 @@ out_sig:
 	sigprocmask(SIG_SETMASK, &oldset, NULL);
 
 out_vec:
-	if (vdescv != NULL)
-		nilfs_vector_destroy(vdescv);
-	if (bdescv != NULL)
-		nilfs_vector_destroy(bdescv);
-	if (periodv != NULL)
-		nilfs_vector_destroy(periodv);
-	if (vblocknrv != NULL)
-		nilfs_vector_destroy(vblocknrv);
-	if (supv != NULL)
-		nilfs_vector_destroy(supv);
+	nilfs_vector_destroy(vdescv);
+	nilfs_vector_destroy(bdescv);
+	nilfs_vector_destroy(periodv);
+	nilfs_vector_destroy(vblocknrv);
+	nilfs_vector_destroy(supv);
 	/*
 	 * Flags of valid fields in stat->exflags must be unset.
 	 */
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
