From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/8] chcp: support opening mounted filesystem by directory pathname
Date: Thu,  3 Mar 2011 13:47:46 +0100
Message-ID: <1299156472-4707-2-git-send-email-dexen.devries@gmail.com>
References: <20110302.232110.169818198.ryusuke@osrg.net>
 <1299156472-4707-1-git-send-email-dexen.devries@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:message-id:x-mailer
         :in-reply-to:references:x-face;
        bh=6jB2G92nMkoE+AYNte6u6fPHJ5VNgV/dtpYxtrM5pPk=;
        b=BSBN7tS501bhLww7qP8JVdf29ZfyxPdxiU0VrJUT3PHBPWsgisN6ozkUES3GUmX2X1
         HBKB9wBZPdSdUw3aSmqxGsK4PiYouqsaO6yDJQXB+xIQPM/FBhcmqshCnX4K47Mg7equ
         DDyRRLU+QqnVDAokslIvYT+K+f0ifbXgsnObs=
In-Reply-To: <1299156472-4707-1-git-send-email-dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

---
 bin/chcp.c |   35 +++++++++++++++++++++++++++++------
 1 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/bin/chcp.c b/bin/chcp.c
index a66e437..28a66ea 100644
--- a/bin/chcp.c
+++ b/bin/chcp.c
@@ -28,6 +28,14 @@
 #include "config.h"
 #endif	/* HAVE_CONFIG_H */
 
+#if HAVE_SYS_TYPES_H
+#include <sys/types.h>
+#endif	/* HAVE_SYS_TYPES_H */
+
+#if HAVE_SYS_STAT_H
+#include <sys/stat.h>
+#endif	/* HAVE_SYS_STAT_H */
+
 #include <stdio.h>
 
 #if HAVE_STDLIB_H
@@ -76,13 +84,15 @@ int main(int argc, char *argv[])
 {
 	struct nilfs *nilfs;
 	nilfs_cno_t cno;
-	char *dev, *modestr, *progname, *endptr;
-	int c, mode, status;
+	struct stat statbuf;
+	char *dev, *dir, *pathname, *modestr, *progname, *endptr;
+	int c, mode, status, ret;
 	unsigned long val;
 #ifdef _GNU_SOURCE
 	int option_index;
 #endif	/* _GNU_SOURCE */
 
+	dev = dir = NULL;
 	opterr = 0;
 
 	if ((progname = strrchr(argv[0], '/')) == NULL)
@@ -117,14 +127,14 @@ int main(int argc, char *argv[])
 		exit(1);
 	} else if (optind == argc - 2) {
 		modestr = argv[optind++];
-		dev = NULL;
+		pathname = NULL;
 	} else {
 		modestr = argv[optind++];
 		val = strtoul(argv[optind], &endptr, CHCP_BASE);
 		if (*endptr == '\0')
-			dev = NULL;
+			pathname = NULL;
 		else
-			dev = argv[optind++];
+			pathname = argv[optind++];
 	}
 
 	if (strcmp(modestr, CHCP_MODE_CP) == 0)
@@ -137,7 +147,20 @@ int main(int argc, char *argv[])
 		exit(1);
 	}
 
-	nilfs = nilfs_open(dev, NULL, NILFS_OPEN_RDWR);
+
+	if (pathname) {
+		ret = stat(pathname, &statbuf);
+		if (ret == -1) {
+			fprintf(stderr, "%s: cannot open %s: %s\n",
+				progname, pathname, strerror(errno));
+			exit(EXIT_FAILURE);
+		}
+		if (S_ISDIR(statbuf.st_mode))
+			dir = pathname;
+		else
+			dev = pathname;
+	}
+	nilfs = nilfs_open(dev, dir, NILFS_OPEN_RDWR);
 	if (nilfs == NULL) {
 		fprintf(stderr, "%s: %s: cannot open NILFS\n", progname, dev);
 		exit(1);
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
