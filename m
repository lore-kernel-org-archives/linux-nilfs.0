From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/8] mkcp: support opening mounted filesystem by directory pathname
Date: Thu,  3 Mar 2011 13:47:49 +0100
Message-ID: <1299156472-4707-5-git-send-email-dexen.devries@gmail.com>
References: <20110302.232110.169818198.ryusuke@osrg.net>
 <1299156472-4707-1-git-send-email-dexen.devries@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:message-id:x-mailer
         :in-reply-to:references:x-face;
        bh=YjCsarctuPa59UHekU+k2uVnfqVSlxrcDt1QvOmLWp4=;
        b=NoVgg79vygp6Ncurn6N6uD3OTC75FHi/C2HRi00tnYK0ACPeKabGc50uIElW43Eovm
         e2kTt0mvGeh79jUFUWXi9KH2IZfa4SDhpArwvgZ60fv4yD9c+F+VUxuILF3ja7uNDm51
         PZQ1iN5lMdYm4FeUc6fOTEO5Xn6fCxJ+thFNU=
In-Reply-To: <1299156472-4707-1-git-send-email-dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

---
 bin/mkcp.c |   36 +++++++++++++++++++++++++++++-------
 1 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/bin/mkcp.c b/bin/mkcp.c
index 716b809..d2f45e9 100644
--- a/bin/mkcp.c
+++ b/bin/mkcp.c
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
@@ -68,15 +76,17 @@ const static struct option long_option[] = {
 int main(int argc, char *argv[])
 {
 	struct nilfs *nilfs;
+	struct stat statbuf;
 	nilfs_cno_t cno;
-	char *dev, *progname;
-	int ss, c, status;
+	char *dev, *dir, *pathname, *progname;
+	int ss, c, status, ret;
 #ifdef _GNU_SOURCE
 	int option_index;
 #endif	/* _GNU_SOURCE */
 
 	ss = 0;
 	opterr = 0;
+	dev = dir = NULL;
 	if ((progname = strrchr(argv[0], '/')) == NULL)
 		progname = argv[0];
 	else
@@ -111,13 +121,25 @@ int main(int argc, char *argv[])
 		fprintf(stderr, "%s: too many arguments\n", progname);
 		exit(1);
 	} else if (optind > argc - 1)
-		dev = NULL;
+		pathname = NULL;
 	else
-		dev = argv[optind];
-
-	nilfs = nilfs_open(dev, NULL, NILFS_OPEN_RDWR);
+		pathname = argv[optind];
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
