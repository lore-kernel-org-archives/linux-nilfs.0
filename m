From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 03/11] nilfs-utils: fsck: add libnilfsmessages.la and libfsck.la library into nilfs-utils package
Date: Wed, 5 Sep 2012 23:14:12 +0400
Message-ID: <CDC50010-F23C-4822-85A5-0E94E4C51820@dubeyko.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:To:Message-Id:Date:Subject:Content-Transfer-Encoding:Content-Type:From; bh=Gj+Q3YR8MZ8QtzyJPrYxjqx/LnKo7vUX6+7yd13vmAY=;
	b=Td+icJStjRxOQr3oKLgETrFsRb6WqzsrMckEFTXl32eDiuSIfZwae/X+/MFZDoa0RzHjFq5OZO5eb4Nn5R++edZzJ157oCGduU28TGfD5HxwGRuRq7ucPyDqVrvUqJf/;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch adds libnilfsmessages.la and libfsck.la library into nilfs-utils package. These libraries have purpose to encapsulate common functionality.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 03/11] nilfs-utils: fsck: add libnilfsmessages.la and libfsck.la library into nilfs-utils package

This patch adds libnilfsmessages.la and libfsck.la library into nilfs-utils package. These libraries have purpose to encapsulate common functionality.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 include/Makefile.am |    3 ++-
 lib/Makefile.am     |   16 ++++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/Makefile.am b/include/Makefile.am
index 1b6d812..5c51024 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -3,4 +3,5 @@
 include_HEADERS = nilfs.h nilfs2_fs.h nilfs_cleaner.h
 noinst_HEADERS = realpath.h nls.h cno.h nilfs_feature.h \
 	vector.h nilfs_gc.h cnoconv.h cleaner_msg.h cleaner_exec.h \
-	pathnames.h
+	pathnames.h nilfs_messages.h nilfs_messages.def fsck_raw_ops.h \
+	fsck_nilfs2.h
diff --git a/lib/Makefile.am b/lib/Makefile.am
index 11d17f3..fefb830 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -2,7 +2,8 @@
 
 lib_LTLIBRARIES = libnilfs.la libnilfsgc.la libnilfscleaner.la
 noinst_LTLIBRARIES = librealpath.la libnilfsfeature.la libcno.la \
-	libmountchk.la libcrc32.la libcleanerexec.la
+	libmountchk.la libcrc32.la libcleanerexec.la \
+	libnilfsmessages.la libfsck.la
 
 librealpath_la_SOURCES = realpath.c
 librealpath_la_CFLAGS = -Wall -fPIC
@@ -43,7 +44,7 @@ libnilfs_la_SOURCES = nilfs.c sb.c
 libnilfs_la_CFLAGS = -Wall
 libnilfs_la_CPPFLAGS = -I$(top_srcdir)/include
 libnilfs_la_LDFLAGS = -version-info $(libnilfs_VERSIONINFO)
-libnilfs_la_LIBADD = librealpath.la libcrc32.la $(LIB_POSIX_SEM)
+libnilfs_la_LIBADD = librealpath.la libcrc32.la libnilfsmessages.la $(LIB_POSIX_SEM)
 
 nilfsgc_CURRENT = 0
 nilfsgc_REVISION = 0
@@ -66,3 +67,14 @@ libnilfscleaner_la_CFLAGS = -Wall -fPIC
 libnilfscleaner_la_CPPFLAGS = -I$(top_srcdir)/include
 libnilfscleaner_la_LDFLAGS = -version-info $(cleanerctl_VERSIONINFO)
 libnilfscleaner_la_LIBADD = librealpath.la libcleanerexec.la $(LIB_POSIX_MQ) -luuid
+
+libnilfsmessages_la_SOURCES = nilfs_messages.c
+libnilfsmessages_la_CFLAGS = -Wall -fPIC
+libnilfsmessages_la_CPPFLAGS = -I$(top_srcdir)/include
+libnilfsmessages_la_LDFLAGS = -static
+
+libfsck_la_SOURCES = fsck_raw_ops.c
+libfsck_la_CFLAGS = -Wall -fPIC
+libfsck_la_CPPFLAGS = -I$(top_srcdir)/include
+libfsck_la_LDFLAGS = -static
+libfsck_la_LIBADD = libnilfsmessages.la
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
