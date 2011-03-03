From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/8] bin/*: update inline help to indicate possibility of accessing filesystem by mountpoint pathname
Date: Thu,  3 Mar 2011 13:47:51 +0100
Message-ID: <1299156472-4707-7-git-send-email-dexen.devries@gmail.com>
References: <20110302.232110.169818198.ryusuke@osrg.net>
 <1299156472-4707-1-git-send-email-dexen.devries@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:message-id:x-mailer
         :in-reply-to:references:x-face;
        bh=jrsvqDYlpd8EKBw9BqSfJNNI1FxPv/8gfmszqYE0oC0=;
        b=Qu0luSm6Ui4YMoap8viSqgURJgeezy1lOHaQ+1G60mm7Wsfp8xa51xtipARw8Ku/Op
         fgXwONvO2DZiwxQeMqfkG7f0081PPErSfEI4CpnetsQ7xd733nE/2lDc9wmQdxcsiEob
         RN19ZpxRsPAeMDZ7fn15eLDWvLilJsLRH7nvo=
In-Reply-To: <1299156472-4707-1-git-send-email-dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

---
 bin/chcp.c    |    2 +-
 bin/dumpseg.c |    2 +-
 bin/lscp.c    |    2 +-
 bin/lssu.c    |    2 +-
 bin/mkcp.c    |    2 +-
 bin/rmcp.c    |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/bin/chcp.c b/bin/chcp.c
index 28a66ea..a13abc0 100644
--- a/bin/chcp.c
+++ b/bin/chcp.c
@@ -71,7 +71,7 @@ const static struct option long_option[] = {
 };
 
 #define CHCP_USAGE	\
-	"Usage: %s [OPTION]... " CHCP_MODE_CP "|" CHCP_MODE_SS" [DEVICE] CNO...\n"	\
+	"Usage: %s [OPTION]... " CHCP_MODE_CP "|" CHCP_MODE_SS" [DEVICE|MOUNTPOINT] CNO...\n"	\
 	"  -h, --help\t\tdisplay this help and exit\n"			\
 	"  -V, --version\t\tdisplay version and exit\n"
 #else	/* !_GNU_SOURCE */
diff --git a/bin/dumpseg.c b/bin/dumpseg.c
index 1910296..2d8de79 100644
--- a/bin/dumpseg.c
+++ b/bin/dumpseg.c
@@ -66,7 +66,7 @@ const static struct option long_option[] = {
 };
 
 #define DUMPSEG_USAGE	\
-	"Usage: %s [OPTION]... [DEVICE] SEGNUM...\n"	\
+	"Usage: %s [OPTION]... [DEVICE|MOUNTPOINT] SEGNUM...\n"	\
 	"  -h, --help\t\tdisplay this help and exit\n"	\
 	"  -V, --version\t\tdisplay version and exit\n"
 #else	/* !_GNU_SOURCE */
diff --git a/bin/lscp.c b/bin/lscp.c
index a9be26e..fad5f09 100644
--- a/bin/lscp.c
+++ b/bin/lscp.c
@@ -72,7 +72,7 @@ const static struct option long_option[] = {
 	{"version", no_argument, NULL, 'V'},
 	{NULL, 0, NULL, 0}
 };
-#define LSCP_USAGE	"Usage: %s [OPTION]... [DEVICE]\n"		\
+#define LSCP_USAGE	"Usage: %s [OPTION]... [DEVICE|MOUNTPOINT]\n"		\
 			"  -b, --show-block-count\t\tshow block count\n"\
 			"  -g, --show-increment\t\tshow increment count\n"\
 			"  -r, --reverse\t\treverse order\n"		\
diff --git a/bin/lssu.c b/bin/lssu.c
index e8dccc3..b4e834c 100644
--- a/bin/lssu.c
+++ b/bin/lssu.c
@@ -63,7 +63,7 @@ const static struct option long_option[] = {
 	{NULL, 0, NULL, 0}
 };
 
-#define LSSU_USAGE	"Usage: %s [OPTION]... [DEVICE]\n"		\
+#define LSSU_USAGE	"Usage: %s [OPTION]... [DEVICE|MOUNTPOINT]\n"		\
 			"  -a, --all\t\tdo not hide clean segments\n"	\
 			"  -i, --index\t\tstart index\n"		\
 			"  -n, --lines\t\toutput lines\n"		\
diff --git a/bin/mkcp.c b/bin/mkcp.c
index d2f45e9..92aaad8 100644
--- a/bin/mkcp.c
+++ b/bin/mkcp.c
@@ -64,7 +64,7 @@ const static struct option long_option[] = {
 	{NULL, 0, NULL, 0}
 };
 
-#define MKCP_USAGE	"Usage: %s [OPTION] [DEVICE]\n"			\
+#define MKCP_USAGE	"Usage: %s [OPTION] [DEVICE|MOUNTPOINT]\n"			\
 			"  -s, --snapshot\tcreate a snapshot\n"		\
 			"  -h, --help\t\tdisplay this help and exit\n"	\
 			"  -V, --version\t\tdisplay version and exit\n"
diff --git a/bin/rmcp.c b/bin/rmcp.c
index 91ddf60..455818b 100644
--- a/bin/rmcp.c
+++ b/bin/rmcp.c
@@ -69,7 +69,7 @@ const static struct option long_options[] = {
 	{NULL, 0, NULL, 0}
 };
 #define RMCP_USAGE							\
-	"Usage: %s [OPTION]... [DEVICE] CNO...\n"			\
+	"Usage: %s [OPTION]... [DEVICE|MOUNTPOINT] CNO...\n"			\
 	"  -f, --force\t\tignore snapshots or nonexistent checkpoints\n" \
 	"  -i, --interactive\tprompt before any removal\n"		\
 	"  -h, --help\t\tdisplay this help and exit\n"			\
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
