From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 04/10] nilfs-utils: remove unnecessary whitespace before quoted newlines
Date: Fri, 14 Feb 2014 03:24:04 +0900
Message-ID: <1392315850-29149-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1392315850-29149-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392315850-29149-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Fix the following checkpatch warnings:

 WARNING: unnecessary whitespace before a quoted newline
 #1166: FILE: mkfs/mkfs.c:1166:
 +               "Usage: %s [-b block-size] [-B blocks-per-segment] [-c] [-f] \n"

 WARNING: unnecessary whitespace before a quoted newline
 #1167: FILE: mkfs/mkfs.c:1167:
 +               "       [-L volume-label] [-m reserved-segments-percentage] \n"

 WARNING: unnecessary whitespace before a quoted newline
 #1168: FILE: mkfs/mkfs.c:1168:
 +               "       [-O feature[,...]] \n"

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/mkfs/mkfs.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index 4d6c375..f4be411 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -1163,9 +1163,10 @@ static void parse_options(int argc, char *argv[])
 static void usage(void)
 {
 	fprintf(stderr,
-		"Usage: %s [-b block-size] [-B blocks-per-segment] [-c] [-f] \n"
-		"       [-L volume-label] [-m reserved-segments-percentage] \n"
-		"       [-O feature[,...]] \n"
+		"Usage: %s [-b block-size] [-B blocks-per-segment] [-c] " \
+		"[-f]\n" \
+		"       [-L volume-label] [-m reserved-segments-percentage]\n" \
+		"       [-O feature[,...]]\n" \
 		"       [-hnqvKV] device\n",
 		progname);
 }
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
