From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/8] rmcp: support opening mounted filesystem by directory pathname
Date: Thu,  3 Mar 2011 13:47:50 +0100
Message-ID: <1299156472-4707-6-git-send-email-dexen.devries@gmail.com>
References: <20110302.232110.169818198.ryusuke@osrg.net>
 <1299156472-4707-1-git-send-email-dexen.devries@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:message-id:x-mailer
         :in-reply-to:references:x-face;
        bh=7NA6BurwQfSHYkVuGuxOQaL1EKemfEgnK9Etpj7ezJE=;
        b=qi1EYdUAEAR9CHHVFcBVhDS9+2boCvUmW0sUdmyMm9Vnc5VB1QNV0URojN2jPzpCGr
         DYKGGqKykYqJj7V2UZPtix4Es60MoK4AeBzTacxw82vyz+EPNuyM6E05lkVSn5CIsH68
         s9kcaKOUFiSqG64fczwV6iwnXZMOOnIOtUNVo=
In-Reply-To: <1299156472-4707-1-git-send-email-dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

---
 bin/rmcp.c |   36 +++++++++++++++++++++++++++++-------
 1 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/bin/rmcp.c b/bin/rmcp.c
index 9b72f9d..91ddf60 100644
--- a/bin/rmcp.c
+++ b/bin/rmcp.c
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
@@ -129,9 +137,10 @@ static int rmcp_remove_range(struct nilfs *nilfs,
 
 int main(int argc, char *argv[])
 {
-	char *dev;
+	char *dev, *dir, *pathname;
 	struct nilfs *nilfs;
 	struct nilfs_cpstat cpstat;
+	struct stat statbuf;
 	nilfs_cno_t start, end, oldest;
 	size_t nsnapshots, nss, ndel;
 	int c, status, ret;
@@ -140,6 +149,7 @@ int main(int argc, char *argv[])
 #endif	/* _GNU_SOURCE */
 
 	opterr = 0;
+	dev = dir = NULL;
 	if ((progname = strrchr(argv[0], '/')) == NULL)
 		progname = argv[0];
 	else
@@ -179,24 +189,36 @@ int main(int argc, char *argv[])
 		fprintf(stderr, "%s: too few arguments\n", progname);
 		exit(1);
 	} else if (optind == argc - 1) {
-		dev = NULL;
+		pathname = NULL;
 	} else {
 		if (nilfs_parse_cno_range(argv[optind], &start, &end,
 					  RMCP_BASE) < 0)
-			dev = argv[optind++];
+			pathname = argv[optind++];
 		else
-			dev = NULL;
+			pathname = NULL;
 	}
 
-	nilfs = nilfs_open(dev, NULL, NILFS_OPEN_RDWR);
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
 
 	if (nilfs_get_cpstat(nilfs, &cpstat) < 0) {
 		fprintf(stderr, "%s: %s: cannot get checkpoint status: %s\n",
-			progname, dev, strerror(errno));
+			progname, pathname, strerror(errno));
 		exit(1);
 	}
 
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
