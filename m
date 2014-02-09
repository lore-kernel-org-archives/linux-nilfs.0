From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs-clean: fix build warning at nilfs_clean_usage()
Date: Mon, 10 Feb 2014 01:32:06 +0900
Message-ID: <1391963526-24106-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Fix the following gcc warning:

  nilfs-clean.c: In function: 'nilfs_clean_usage':
  nilfs-clean.c:336: warning: unknown conversion type character ']' in
  format

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/nilfs-clean/nilfs-clean.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sbin/nilfs-clean/nilfs-clean.c b/sbin/nilfs-clean/nilfs-clean.c
index a56fa10..0f4a02c 100644
--- a/sbin/nilfs-clean/nilfs-clean.c
+++ b/sbin/nilfs-clean/nilfs-clean.c
@@ -91,7 +91,7 @@ const static struct option long_option[] = {
 	"  -l, --status\t\tdisplay cleaner status\n"			\
 	"  -p, --protection-period=SECONDS\n"				\
 	"               \t\tspecify protection period\n"		\
-	"  -m, --min-reclaimable-blocks=COUNT[%]\n"			\
+	"  -m, --min-reclaimable-blocks=COUNT[%%]\n"			\
 	"               \t\tset minimum number of reclaimable blocks\n"	\
 	"               \t\tbefore a segment can be cleaned\n"		\
 	"  -q, --quit\t\tshutdown cleaner\n"				\
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
