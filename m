From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/2] man/lscp.1: remove "experimental" from the description of FLG field
Date: Sat, 18 Jan 2014 22:57:13 +0900
Message-ID: <1390053433-13598-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1390053433-13598-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1390053433-13598-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 man/lscp.1 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/lscp.1 b/man/lscp.1
index bb44cfa..1435a8e 100644
--- a/man/lscp.1
+++ b/man/lscp.1
@@ -61,7 +61,7 @@ Creation time.
 Mode of the checkpoint; \fBcp\fP for a plain checkpoint, and \fBss\fP
 for a snapshot.
 .TP
-.B FLG (experimental)
+.B FLG
 Flags on the checkpoint. At present, character ``i'' is printed in the
 field if the checkpoint was created only by garbage collection,
 checkpoint mode change, or other change of internal state.  Otherwise
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
