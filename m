From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] nilfs-utils: renew parser library
Date: Mon, 10 Feb 2014 03:48:33 +0900
Message-ID: <1391971714-1724-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1391971714-1724-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391971714-1724-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This renames checkpoint number library "lib/cno.c" to "lib/parser.c",
and moves a parser routine of a protection period option included in
nilfs-clean.c into parser.c to make it available from other programs.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 bin/Makefile.am                |    4 +-
 bin/chcp.c                     |    2 +-
 bin/rmcp.c                     |    2 +-
 include/Makefile.am            |    2 +-
 include/cno.h                  |   17 -----
 include/parser.h               |   19 +++++
 lib/Makefile.am                |   10 +--
 lib/cno.c                      |  101 --------------------------
 lib/parser.c                   |  154 ++++++++++++++++++++++++++++++++++++++++
 sbin/nilfs-clean/Makefile.am   |    3 +-
 sbin/nilfs-clean/nilfs-clean.c |   69 ++++--------------
 11 files changed, 200 insertions(+), 183 deletions(-)
 delete mode 100644 include/cno.h
 create mode 100644 include/parser.h
 delete mode 100644 lib/cno.c
 create mode 100644 lib/parser.c

diff --git a/bin/Makefile.am b/bin/Makefile.am
index 6623022..9d63d06 100644
--- a/bin/Makefile.am
+++ b/bin/Makefile.am
@@ -7,7 +7,7 @@ LDADD = $(top_builddir)/lib/libnilfs.la
 bin_PROGRAMS = chcp dumpseg lscp lssu mkcp rmcp
 
 chcp_SOURCES = chcp.c
-chcp_LDADD = $(LDADD) $(LIB_POSIX_SEM) $(top_builddir)/lib/libcno.la
+chcp_LDADD = $(LDADD) $(LIB_POSIX_SEM) $(top_builddir)/lib/libparser.la
 
 dumpseg_SOURCES = dumpseg.c
 
@@ -19,6 +19,6 @@ mkcp_SOURCES = mkcp.c
 mkcp_LDADD = $(LDADD) $(LIB_POSIX_SEM)
 
 rmcp_SOURCES = rmcp.c
-rmcp_LDADD = $(LDADD) $(top_builddir)/lib/libcno.la
+rmcp_LDADD = $(LDADD) $(top_builddir)/lib/libparser.la
 
 EXTRA_DIST = .gitignore
diff --git a/bin/chcp.c b/bin/chcp.c
index 5cf8c22..e1d31fd 100644
--- a/bin/chcp.c
+++ b/bin/chcp.c
@@ -49,7 +49,7 @@
 #include <errno.h>
 #include <signal.h>
 #include "nilfs.h"
-#include "cno.h"
+#include "parser.h"
 
 
 #define CHCP_MODE_CP	"cp"
diff --git a/bin/rmcp.c b/bin/rmcp.c
index 26d1282..af9eeb0 100644
--- a/bin/rmcp.c
+++ b/bin/rmcp.c
@@ -49,7 +49,7 @@
 
 #include <errno.h>
 #include "nilfs.h"
-#include "cno.h"
+#include "parser.h"
 
 
 #ifdef _GNU_SOURCE
diff --git a/include/Makefile.am b/include/Makefile.am
index 1b6d812..2b46bb5 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -1,6 +1,6 @@
 ## Makefile.am
 
 include_HEADERS = nilfs.h nilfs2_fs.h nilfs_cleaner.h
-noinst_HEADERS = realpath.h nls.h cno.h nilfs_feature.h \
+noinst_HEADERS = realpath.h nls.h parser.h nilfs_feature.h \
 	vector.h nilfs_gc.h cnoconv.h cleaner_msg.h cleaner_exec.h \
 	pathnames.h
diff --git a/include/cno.h b/include/cno.h
deleted file mode 100644
index cb4b74b..0000000
--- a/include/cno.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/*
- * cno.h - checkpoint number library
- *
- * Copyright (C) 2005-2012 Nippon Telegraph and Telephone Corporation.
- *
- * This program can be redistributed under the terms of the GNU Lesser
- * General Public License.
- */
-
-#ifndef NILFS_CNO_H
-#define NILFS_CNO_H
-
-extern nilfs_cno_t nilfs_parse_cno(const char *arg, char **endptr, int base);
-extern int nilfs_parse_cno_range(const char *arg, __u64 *start, __u64 *end,
-				 int base);
-
-#endif /* NILFS_CNO_H */
diff --git a/include/parser.h b/include/parser.h
new file mode 100644
index 0000000..7795678
--- /dev/null
+++ b/include/parser.h
@@ -0,0 +1,19 @@
+/*
+ * parser.h - NILFS parser library
+ *
+ * Copyright (C) 2005-2012 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program can be redistributed under the terms of the GNU Lesser
+ * General Public License.
+ */
+
+#ifndef NILFS_PARSER_H
+#define NILFS_PARSER_H
+
+extern nilfs_cno_t nilfs_parse_cno(const char *arg, char **endptr, int base);
+extern int nilfs_parse_cno_range(const char *arg, __u64 *start, __u64 *end,
+				 int base);
+extern int nilfs_parse_protection_period(const char *arg,
+					 unsigned long *period);
+
+#endif /* NILFS_PARSER_H */
diff --git a/lib/Makefile.am b/lib/Makefile.am
index 0b9fbf1..82ba3c3 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -1,7 +1,7 @@
 ## Makefile.am
 
 lib_LTLIBRARIES = libnilfs.la libnilfsgc.la libnilfscleaner.la
-noinst_LTLIBRARIES = librealpath.la libnilfsfeature.la libcno.la \
+noinst_LTLIBRARIES = librealpath.la libnilfsfeature.la libparser.la \
 	libmountchk.la libcrc32.la libcleanerexec.la
 
 librealpath_la_SOURCES = realpath.c
@@ -14,10 +14,10 @@ libnilfsfeature_la_CFLAGS = -Wall -fPIC
 libnilfsfeature_la_CPPFLAGS = -I$(top_srcdir)/include
 libnilfsfeature_la_LDFLAGS = -static
 
-libcno_la_SOURCES = cno.c
-libcno_la_CFLAGS = -Wall -fPIC
-libcno_la_CPPFLAGS = -I$(top_srcdir)/include
-libcno_la_LDFLAGS = -static
+libparser_la_SOURCES = parser.c
+libparser_la_CFLAGS = -Wall -fPIC
+libparser_la_CPPFLAGS = -I$(top_srcdir)/include
+libparser_la_LDFLAGS = -static
 
 libmountchk_la_SOURCES = ismounted.c
 libmountchk_la_CFLAGS = -Wall -fPIC
diff --git a/lib/cno.c b/lib/cno.c
deleted file mode 100644
index df143cb..0000000
--- a/lib/cno.c
+++ /dev/null
@@ -1,101 +0,0 @@
-/*
- * cno.c - NILFS checkpoint number parser
- *
- * Copyright (C) 2009-2012 Nippon Telegraph and Telephone Corporation.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU Lesser General Public License as published
- * by the Free Software Foundation; either version 2.1 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
- * Written by Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>.
- */
-
-#ifdef HAVE_CONFIG_H
-#include "config.h"
-#endif	/* HAVE_CONFIG_H */
-
-#include <stdio.h>
-
-#if HAVE_STDLIB_H
-#include <stdlib.h>
-#endif	/* HAVE_STDLIB_H */
-
-#if HAVE_STRING_H
-#include <string.h>
-#endif	/* HAVE_STRING_H */
-
-#include <assert.h>
-#include <ctype.h>
-#include "nilfs.h"
-
-nilfs_cno_t nilfs_parse_cno(const char *arg, char **endptr, int base)
-{
-	/* ensure the number we are about to parse is not negative, which
-	 * strtoull() will happily accept and cast to an unsigned value. */
-	while (isspace(*arg))
-		arg++;
-	if (*arg == '-')
-		return NILFS_CNO_MAX;
-
-	return strtoull(arg, endptr, base);
-}
-
-int nilfs_parse_cno_range(const char *arg, __u64 *start, __u64 *end, int base)
-{
-	const char *delim;
-	char *endptr;
-	nilfs_cno_t cno, cno2;
-
-	assert(arg && *arg != '\0');
-
-	delim = strstr(arg, "..");
-	if (delim && delim == arg) {
-		if (arg[2] != '\0') {
-			/* ..yyy */
-			cno = nilfs_parse_cno(arg + 2, &endptr, base);
-			if (cno < NILFS_CNO_MAX && *endptr == '\0') {
-				/* ..CNO */
-				*start = NILFS_CNO_MIN;
-				*end = cno;
-				return 0;
-			}
-		}
-	} else if (!delim) {
-		/* xxx */
-		cno = nilfs_parse_cno(arg, &endptr, base);
-		if (cno < NILFS_CNO_MAX && *endptr == '\0') {
-			/* CNO */
-			*start = *end = cno;
-			return 0;
-		}
-	} else {
-		/* xxx..yyy */
-		cno = nilfs_parse_cno(arg, &endptr, base);
-		if (cno < NILFS_CNO_MAX && endptr == delim) {
-			if (delim[2] == '\0') {
-				/* CNO.. */
-				*start = cno;
-				*end = NILFS_CNO_MAX;
-				return 0;
-			}
-			cno2 = nilfs_parse_cno(delim + 2, &endptr, base);
-			if (cno2 < NILFS_CNO_MAX && *endptr == '\0') {
-				/* CNO..CNO */
-				*start = cno;
-				*end = cno2;
-				return 0;
-			}
-		}
-	}
-	return -1; /* parse error */
-}
diff --git a/lib/parser.c b/lib/parser.c
new file mode 100644
index 0000000..44153dc
--- /dev/null
+++ b/lib/parser.c
@@ -0,0 +1,154 @@
+/*
+ * parser.c - NILFS parser library
+ *
+ * Copyright (C) 2009-2012 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published
+ * by the Free Software Foundation; either version 2.1 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>.
+ */
+
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif	/* HAVE_CONFIG_H */
+
+#include <stdio.h>
+
+#if HAVE_STDLIB_H
+#include <stdlib.h>
+#endif	/* HAVE_STDLIB_H */
+
+#if HAVE_STRING_H
+#include <string.h>
+#endif	/* HAVE_STRING_H */
+
+#if HAVE_LIMITS_H
+#include <limits.h>
+#endif	/* HAVE_LIMITS_H */
+
+#include <assert.h>
+#include <ctype.h>
+#include <errno.h>
+#include "nilfs.h"
+
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
+int nilfs_parse_cno_range(const char *arg, __u64 *start, __u64 *end, int base)
+{
+	const char *delim;
+	char *endptr;
+	nilfs_cno_t cno, cno2;
+
+	assert(arg && *arg != '\0');
+
+	delim = strstr(arg, "..");
+	if (delim && delim == arg) {
+		if (arg[2] != '\0') {
+			/* ..yyy */
+			cno = nilfs_parse_cno(arg + 2, &endptr, base);
+			if (cno < NILFS_CNO_MAX && *endptr == '\0') {
+				/* ..CNO */
+				*start = NILFS_CNO_MIN;
+				*end = cno;
+				return 0;
+			}
+		}
+	} else if (!delim) {
+		/* xxx */
+		cno = nilfs_parse_cno(arg, &endptr, base);
+		if (cno < NILFS_CNO_MAX && *endptr == '\0') {
+			/* CNO */
+			*start = *end = cno;
+			return 0;
+		}
+	} else {
+		/* xxx..yyy */
+		cno = nilfs_parse_cno(arg, &endptr, base);
+		if (cno < NILFS_CNO_MAX && endptr == delim) {
+			if (delim[2] == '\0') {
+				/* CNO.. */
+				*start = cno;
+				*end = NILFS_CNO_MAX;
+				return 0;
+			}
+			cno2 = nilfs_parse_cno(delim + 2, &endptr, base);
+			if (cno2 < NILFS_CNO_MAX && *endptr == '\0') {
+				/* CNO..CNO */
+				*start = cno;
+				*end = cno2;
+				return 0;
+			}
+		}
+	}
+	return -1; /* parse error */
+}
+
+int nilfs_parse_protection_period(const char *arg, unsigned long *period)
+{
+	unsigned long long val;
+	char *endptr;
+	int ret = 0;
+
+	val = strtoull(arg, &endptr, 10);
+	if (endptr == arg) {
+		errno = EINVAL;
+		ret = -1;
+		goto out;
+	} else if (endptr[0] != '\0' && endptr[1] == '\0' && val < ULONG_MAX) {
+		switch (endptr[0]) {
+		case 's':
+			break;
+		case 'm':
+			val *= 60;
+			break;
+		case 'h':
+			val *= 3600;
+			break;
+		case 'd':
+			val *= 86400;
+			break;
+		case 'w':
+			val *= 604800;
+			break;
+		case 'M':
+			val *= 2678400;
+			break;
+		case 'Y':
+			val *= 31536000;
+			break;
+		default:
+			ret = -1;
+			goto out;
+		}
+	}
+	if (val >= ULONG_MAX) {
+		errno = ERANGE;
+		ret = -1;
+		goto out;
+	}
+	*period = val;
+out:
+	return ret;
+}
diff --git a/sbin/nilfs-clean/Makefile.am b/sbin/nilfs-clean/Makefile.am
index 930464b..05b0510 100644
--- a/sbin/nilfs-clean/Makefile.am
+++ b/sbin/nilfs-clean/Makefile.am
@@ -3,7 +3,8 @@
 AM_CFLAGS = -Wall
 AM_CPPFLAGS = -I$(top_srcdir)/include
 LDADD = $(top_builddir)/lib/libnilfs.la \
-	$(top_builddir)/lib/libnilfscleaner.la
+	$(top_builddir)/lib/libnilfscleaner.la \
+	$(top_builddir)/lib/libparser.la
 
 sbin_PROGRAMS = nilfs-clean
 
diff --git a/sbin/nilfs-clean/nilfs-clean.c b/sbin/nilfs-clean/nilfs-clean.c
index 0f4a02c..4a92abf 100644
--- a/sbin/nilfs-clean/nilfs-clean.c
+++ b/sbin/nilfs-clean/nilfs-clean.c
@@ -63,6 +63,7 @@
 #include "nls.h"
 #include "nilfs.h"
 #include "nilfs_cleaner.h"
+#include "parser.h"
 
 #ifdef _GNU_SOURCE
 #include <getopt.h>
@@ -336,56 +337,6 @@ static void nilfs_clean_usage(void)
 	fprintf(stderr, NILFS_CLEAN_USAGE, progname);
 }
 
-static int nilfs_clean_parse_protection_period(const char *arg)
-{
-	unsigned long long period;
-	char *endptr;
-	int ret = 0;
-
-	period = strtoull(arg, &endptr, 10);
-	if (endptr == arg) {
-		myprintf(_("Error: invalid protection period: %s\n"), arg);
-		ret = -1;
-		goto out;
-	} else if (endptr[0] != '\0' && endptr[1] == '\0' &&
-		   period < ULONG_MAX) {
-		switch (endptr[0]) {
-		case 's':
-			break;
-		case 'm':
-			period *= 60;
-			break;
-		case 'h':
-			period *= 3600;
-			break;
-		case 'd':
-			period *= 86400;
-			break;
-		case 'w':
-			period *= 604800;
-			break;
-		case 'M':
-			period *= 2678400;
-			break;
-		case 'Y':
-			period *= 31536000;
-			break;
-		default:
-			ret = -1;
-			goto out;
-		}
-	}
-	if (period >= ULONG_MAX) {
-		myprintf(_("Error: too large period: %s\n"), arg);
-		errno = ERANGE;
-		ret = -1;
-		goto out;
-	}
-	protection_period = period;
-out:
-	return ret;
-}
-
 static int nilfs_clean_parse_gcspeed(const char *arg)
 {
 	unsigned long nsegs;
@@ -473,7 +424,7 @@ static void nilfs_clean_parse_options(int argc, char *argv[])
 #ifdef _GNU_SOURCE
 	int option_index;
 #endif	/* _GNU_SOURCE */
-	int c;
+	int c, ret;
 
 #ifdef _GNU_SOURCE
 	while ((c = getopt_long(argc, argv, "bc::hlm:p:qrsS:vV",
@@ -502,9 +453,19 @@ static void nilfs_clean_parse_options(int argc, char *argv[])
 				exit(EXIT_FAILURE);
 			break;
 		case 'p':
-			if (nilfs_clean_parse_protection_period(optarg) < 0)
-				exit(EXIT_FAILURE);
-			break;
+			ret = nilfs_parse_protection_period(
+				optarg, &protection_period);
+			if (!ret)
+				break;
+
+			if (errno == ERANGE) {
+				myprintf(_("Error: too large period: %s\n"),
+					 optarg);
+			} else {
+				myprintf(_("Error: invalid protection period: "
+					   "%s\n"), optarg);
+			}
+			exit(EXIT_FAILURE);
 		case 'q':
 			clean_cmd = NILFS_CLEAN_CMD_SHUTDOWN;
 			break;
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
