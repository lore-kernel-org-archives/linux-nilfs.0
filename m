From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] lssu: fix format-security warning at lssu_print_header()
Date: Sat, 15 Feb 2014 14:11:11 +0900
Message-ID: <1392441071-19824-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Fix the following gcc warning on some platforms:

 lssu.c: In function 'lssu_print_header':
 lssu.c:127:2: warning: format not a string literal and no format arguments [-Wformat-security]
   printf(lssu_format[disp_mode].header);
   ^

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 bin/lssu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/bin/lssu.c b/bin/lssu.c
index d19f7ba..5f501b1 100644
--- a/bin/lssu.c
+++ b/bin/lssu.c
@@ -99,12 +99,12 @@ struct lssu_format {
 
 static const struct lssu_format lssu_format[] = {
 	{
-		"              SEGNUM        DATE     TIME STAT     NBLOCKS\n",
+		"              SEGNUM        DATE     TIME STAT     NBLOCKS",
 		"%20llu  %s  %c%c%c  %10u\n"
 	},
 	{
-		"           SEGNUM        DATE     TIME STAT     NBLOCKS"
-		"       NLIVEBLOCKS\n",
+		"           SEGNUM        DATE     TIME STAT     NBLOCKS" \
+		"       NLIVEBLOCKS",
 		"%17llu  %s %c%c%c%c  %10u %10u (%3u%%)\n"
 	}
 };
@@ -124,7 +124,7 @@ static struct nilfs_suinfo suinfos[LSSU_NSEGS];
 
 static void lssu_print_header(void)
 {
-	printf(lssu_format[disp_mode].header);
+	puts(lssu_format[disp_mode].header);
 }
 
 static ssize_t lssu_get_latest_usage(struct nilfs *nilfs,
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
