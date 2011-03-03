From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/8] lssu: support opening mounted filesystem by directory pathname
Date: Thu,  3 Mar 2011 13:47:48 +0100
Message-ID: <1299156472-4707-4-git-send-email-dexen.devries@gmail.com>
References: <20110302.232110.169818198.ryusuke@osrg.net>
 <1299156472-4707-1-git-send-email-dexen.devries@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:message-id:x-mailer
         :in-reply-to:references:x-face;
        bh=R9niu4Od40SiXcRp4D1IXCMUqyTujdK4zw1kfEN4bqE=;
        b=atF8nvam3IEVAtu4vOzPWcdGPslIRhopGnYCNCgrV42X4ExDQTA9Xw3VckVEB9vu4H
         ZmVYrY48s1l9vziXCrkBMJVuIKONqZvcBQhTwQD+0m4KtDUMv/F+L8Jjo/+OoO8pJFTC
         LUgGqXWhQTZDJNtSlFTblOYQPTnQCAvH0v3cI=
In-Reply-To: <1299156472-4707-1-git-send-email-dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

---
 bin/lssu.c |   34 ++++++++++++++++++++++++++++------
 1 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/bin/lssu.c b/bin/lssu.c
index c5cd519..e8dccc3 100644
--- a/bin/lssu.c
+++ b/bin/lssu.c
@@ -27,6 +27,14 @@
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
@@ -138,14 +146,16 @@ static int lssu_list_suinfo(struct nilfs *nilfs, int all)
 int main(int argc, char *argv[])
 {
 	struct nilfs *nilfs;
-	char *dev, *progname;
-	int c, all, status;
+	struct stat statbuf;
+	char *dev, *dir, *pathname, *progname;
+	int c, all, status, ret;
 #ifdef _GNU_SOURCE
 	int option_index;
 #endif	/* _GNU_SOURCE */
 
 	all = 0;
 	opterr = 0;
+	dev = dir = NULL;
 	progname = strrchr(argv[0], '/');
 	if (progname == NULL)
 		progname = argv[0];
@@ -184,18 +194,30 @@ int main(int argc, char *argv[])
 	}
 
 	if (optind > argc - 1) {
-		dev = NULL;
+		pathname = NULL;
 	} else if (optind == argc - 1) {
-		dev = argv[optind++];
+		pathname = argv[optind++];
 	} else {
 		fprintf(stderr, "%s: too many arguments\n", progname);
 		exit(1);
 	}
 
-	nilfs = nilfs_open(dev, NULL, NILFS_OPEN_RDONLY);
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
+	nilfs = nilfs_open(dev, dir, NILFS_OPEN_RDONLY);
 	if (nilfs == NULL) {
 		fprintf(stderr, "%s: %s: cannot open NILFS\n",
-			progname, dev);
+			progname, pathname);
 		exit(1);
 	}
 
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
