From: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Subject: [PATCH v2 2/7] nilfs-utils: fsck: add libfsck.la library into
 nilfs-utils package
Date: Fri, 03 Aug 2012 07:51:59 -0600
Message-ID: <9ea0fc0ec64e281feb8b1f31524068b2@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:Content-Type:MIME-Version; bh=8QyR7SniEfoFXS9aOpcG3GpAvrVCs5AMppjUMRdRhSU=;
	b=eRSQxh9ZJHNeouIWO7vI+5a22oKyiEXCcFlou8wY0jJy7JyUCWmFV45NqDTOwVb46hg+EmDk1PPSlb1wK4Aqdpg4O6DUbNuzkS/TxOS1eXRVwHh8Vpajlkq2uXvQ+JhX;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,

This patch adds libfsck.la library into nilfs-utils package. The 
library has purpose to encapsulate common functionality of fsck.

With the best regards,
Vyacheslav Dubeyko.
--
 From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 2/7] nilfs-utils: fsck: add libfsck.la library into 
nilfs-utils package

This patch adds libfsck.la library into nilfs-utils package. The 
library has purpose to encapsulate common functionality of fsck.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
diff --git a/include/Makefile.am b/include/Makefile.am
index 1b6d812..668c6d4 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -3,4 +3,4 @@
  include_HEADERS = nilfs.h nilfs2_fs.h nilfs_cleaner.h
  noinst_HEADERS = realpath.h nls.h cno.h nilfs_feature.h \
         vector.h nilfs_gc.h cnoconv.h cleaner_msg.h cleaner_exec.h \
-       pathnames.h
+       pathnames.h fsck_messages.h fsck_messages.def fsck_raw_ops.h
diff --git a/lib/Makefile.am b/lib/Makefile.am
index 11d17f3..82245ed 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -2,7 +2,8 @@

  lib_LTLIBRARIES = libnilfs.la libnilfsgc.la libnilfscleaner.la
  noinst_LTLIBRARIES = librealpath.la libnilfsfeature.la libcno.la \
-       libmountchk.la libcrc32.la libcleanerexec.la
+       libmountchk.la libcrc32.la libcleanerexec.la \
+       libfsck.la

  librealpath_la_SOURCES = realpath.c
  librealpath_la_CFLAGS = -Wall -fPIC
@@ -66,3 +67,8 @@ libnilfscleaner_la_CFLAGS = -Wall -fPIC
  libnilfscleaner_la_CPPFLAGS = -I$(top_srcdir)/include
  libnilfscleaner_la_LDFLAGS = -version-info $(cleanerctl_VERSIONINFO)
  libnilfscleaner_la_LIBADD = librealpath.la libcleanerexec.la 
$(LIB_POSIX_MQ) -luuid
+
+libfsck_la_SOURCES = fsck_messages.c fsck_raw_ops.c
+libfsck_la_CFLAGS = -Wall -fPIC
+libfsck_la_CPPFLAGS = -I$(top_srcdir)/include
+libfsck_la_LDFLAGS = -static
--

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
