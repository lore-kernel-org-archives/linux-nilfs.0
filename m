From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/8] dumpseg: support opening mounted filesystem by directory pathname
Date: Thu,  3 Mar 2011 13:47:47 +0100
Message-ID: <1299156472-4707-3-git-send-email-dexen.devries@gmail.com>
References: <20110302.232110.169818198.ryusuke@osrg.net>
 <1299156472-4707-1-git-send-email-dexen.devries@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:message-id:x-mailer
         :in-reply-to:references:x-face;
        bh=cNeZLlEp/2pPOeaapSFtBzaHmPxKV4PCdXBmGwf9YNA=;
        b=D7LFOULJHAHJDhGFuR3N1fWHezzFNgxlKM5DJkvtuI6W4VYYBAGzflbyQrlHBAhGXg
         j987P0zoFotfFEA46dTa/rZwJvy+hHDoWDoRPlZui1V67gB6yiQ8V4+ShyQ5bKBHfqNU
         KT3gnump2EQt6c81uo8iQgwsCyHn9i054Q9A4=
In-Reply-To: <1299156472-4707-1-git-send-email-dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

---
 bin/dumpseg.c |   35 +++++++++++++++++++++++++++++------
 1 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/bin/dumpseg.c b/bin/dumpseg.c
index 0ee6aee..1910296 100644
--- a/bin/dumpseg.c
+++ b/bin/dumpseg.c
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
@@ -169,17 +177,19 @@ static void dumpseg_print_segment(struct nilfs *nilfs,
 int main(int argc, char *argv[])
 {
 	struct nilfs *nilfs;
+	struct stat statbuf;
 	__u64 segnum;
-	char *dev, *endptr, *progname;
+	char *dev, *dir, *pathname, *endptr, *progname;
 	void *seg;
 	ssize_t segsize;
-	int c, i, status;
+	int c, i, status, ret;
 	unsigned long val;
 #ifdef _GNU_SOURCE
 	int option_index;
 #endif	/* _GNU_SOURCE */
 
 	opterr = 0;
+	dev = dir = NULL;
 
 	if ((progname = strrchr(argv[0], '/')) == NULL)
 		progname = argv[0];
@@ -214,14 +224,27 @@ int main(int argc, char *argv[])
 	} else {
 		val = strtoul(argv[optind], &endptr, DUMPSEG_BASE);
 		if (*endptr == '\0')
-			dev = NULL;
+			pathname = NULL;
 		else
-			dev = argv[optind++];
+			pathname = argv[optind++];
 	}
 
-	nilfs = nilfs_open(dev, NULL, NILFS_OPEN_RAW);
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
+	nilfs = nilfs_open(dev, dir, NILFS_OPEN_RAW);
 	if (nilfs == NULL) {
-		fprintf(stderr, "%s: %s: cannot open NILFS\n", progname, dev);
+		fprintf(stderr, "%s: %s: cannot open NILFS\n", progname, pathname);
 		exit(1);
 	}
 
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
