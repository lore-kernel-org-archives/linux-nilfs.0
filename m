From: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Subject: [PATCH 6/7] rmcp/chcp: sanity check for positive checkpoint number
Date: Wed, 21 Dec 2011 15:34:08 -0600
Message-ID: <1324503249-17432-7-git-send-email-dan@archlinux.org>
References: <1324503249-17432-1-git-send-email-dan@archlinux.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=GKMq182ddlVRNOSgHhVHnQxSpJhzMwHP6KGZijTV8j4=;
        b=aT3SfB6paGK2ipVdGAgxwoowiJiXN4khzG2oJXsB2/JkCpYrMQKynnWmYNAk9jtEBn
         tus7vYkU1lL9Vv6YSzQVzDKndBQsOY5yFz6XsS38wF6ACoPT25R7AGqlJRxSlhb4vifo
         k8NNFHclSXA+BNRbuTfz/I+59yjmQwU2mFLVU=
In-Reply-To: <1324503249-17432-1-git-send-email-dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

These two utilities parse a command line argument with either a
checkpoint number or range. Unfortunately, an unchecked strtoull() call
happily parses a negative number (casting it to a really large unsigned
number).

For rmcp, ensure the single number or range passed in is not negative.
Before, this caused a near-infinite loop with a command such as
`rmcp -- -1`.

For chcp, also ensure the passed in number is not negative by using the
new helper function introduced for the range validation,
nilfs_parse_cno().

Signed-off-by: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
---

Some other commands to try for fuzz testing:

$ rmcp -- '-234'
$ rmcp -- ' -234'
$ rmcp 4135860689012436789324689324061328960812949788907

 bin/Makefile.am |    2 +-
 bin/chcp.c      |    7 ++++---
 include/cno.h   |    1 +
 lib/cno.c       |   29 +++++++++++++++++++++--------
 4 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/bin/Makefile.am b/bin/Makefile.am
index 78928d0..32b6ee8 100644
--- a/bin/Makefile.am
+++ b/bin/Makefile.am
@@ -7,7 +7,7 @@ LDADD = $(top_builddir)/lib/libnilfs.la
 bin_PROGRAMS = chcp dumpseg lscp lssu mkcp rmcp
 
 chcp_SOURCES = chcp.c
-chcp_LDADD = $(LDADD) $(LIB_POSIX_SEM)
+chcp_LDADD = $(LDADD) $(LIB_POSIX_SEM) $(top_builddir)/lib/libcno.la
 
 dumpseg_SOURCES = dumpseg.c
 
diff --git a/bin/chcp.c b/bin/chcp.c
index 13a73d7..a7072ef 100644
--- a/bin/chcp.c
+++ b/bin/chcp.c
@@ -49,6 +49,7 @@
 #include <errno.h>
 #include <signal.h>
 #include "nilfs.h"
+#include "cno.h"
 
 
 #define CHCP_MODE_CP	"cp"
@@ -121,7 +122,7 @@ int main(int argc, char *argv[])
 		dev = NULL;
 	} else {
 		modestr = argv[optind++];
-		strtoul(argv[optind], &endptr, CHCP_BASE);
+		nilfs_parse_cno(argv[optind], &endptr, CHCP_BASE);
 		if (*endptr == '\0')
 			dev = NULL;
 		else
@@ -178,8 +179,8 @@ int main(int argc, char *argv[])
 			break;
 		}
 
-		cno = strtoul(argv[optind], &endptr, CHCP_BASE);
-		if (*endptr != '\0') {
+		cno = nilfs_parse_cno(argv[optind], &endptr, CHCP_BASE);
+		if (cno >= NILFS_CNO_MAX || *endptr != '\0') {
 			fprintf(stderr, "%s: %s: invalid checkpoint number\n",
 				progname, argv[optind]);
 			status = 1;
diff --git a/include/cno.h b/include/cno.h
index 2d5c4af..79a327f 100644
--- a/include/cno.h
+++ b/include/cno.h
@@ -10,6 +10,7 @@
 #ifndef NILFS_CNO_H
 #define NILFS_CNO_H
 
+extern nilfs_cno_t nilfs_parse_cno(const char *arg, char **endptr, int base);
 extern int nilfs_parse_cno_range(const char *arg, __u64 *start, __u64 *end,
 				 int base);
 
diff --git a/lib/cno.c b/lib/cno.c
index 2391f0b..7dcdb71 100644
--- a/lib/cno.c
+++ b/lib/cno.c
@@ -35,8 +35,21 @@
 #endif	/* HAVE_STRING_H */
 
 #include <assert.h>
+#include <ctype.h>
 #include "nilfs.h"
 
+nilfs_cno_t nilfs_parse_cno(const char *arg, char **endptr, int base)
+{
+	/* ensure the number we are about to parse is not negative, which
+	 * strtoull() will happily accept and cast to an unsigned value. */
+	while (isspace(*arg))
+		arg++;
+	if (*arg == '-')
+		return NILFS_CNO_MAX;
+
+	return strtoull(arg, endptr, base);
+}
+
 int nilfs_parse_cno_range(const char *arg, __u64 *start, __u64 *end, int base)
 {
 	const char *delim;
@@ -49,8 +62,8 @@ int nilfs_parse_cno_range(const char *arg, __u64 *start, __u64 *end, int base)
 	if (delim && delim == arg) {
 		if (arg[2] != '\0') {
 			/* ..yyy */
-			cno = strtoull(arg + 2, &endptr, base);
-			if (*endptr == '\0') {
+			cno = nilfs_parse_cno(arg + 2, &endptr, base);
+			if (cno < NILFS_CNO_MAX && *endptr == '\0') {
 				/* ..CNO */
 				*start = NILFS_CNO_MIN;
 				*end = cno;
@@ -59,24 +72,24 @@ int nilfs_parse_cno_range(const char *arg, __u64 *start, __u64 *end, int base)
 		}
 	} else if (!delim) {
 		/* xxx */
-		cno = strtoull(arg, &endptr, base);
-		if (*endptr == '\0') {
+		cno = nilfs_parse_cno(arg, &endptr, base);
+		if (cno < NILFS_CNO_MAX && *endptr == '\0') {
 			/* CNO */
 			*start = *end = cno;
 			return 0;
 		}
 	} else {
 		/* xxx..yyy */
-		cno = strtoull(arg, &endptr, base);
-		if (endptr == delim) {
+		cno = nilfs_parse_cno(arg, &endptr, base);
+		if (cno < NILFS_CNO_MAX && endptr == delim) {
 			if (delim[2] == '\0') {
 				/* CNO.. */
 				*start = cno;
 				*end = NILFS_CNO_MAX;
 				return 0;
 			}
-			cno2 = strtoull(delim + 2, &endptr, base);
-			if (*endptr == '\0') {
+			cno2 = nilfs_parse_cno(delim + 2, &endptr, base);
+			if (cno2 < NILFS_CNO_MAX && *endptr == '\0') {
 				/* CNO..CNO */
 				*start = cno;
 				*end = cno2;
-- 
1.7.8

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
