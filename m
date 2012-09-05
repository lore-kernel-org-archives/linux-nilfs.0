From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 09/11] nilfs-utils: fsck: add Makefile for fsck.nilfs2
Date: Wed, 5 Sep 2012 23:15:23 +0400
Message-ID: <9E6DCE8A-4352-48F0-8102-D076BD7C09BE@dubeyko.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:To:Message-Id:Date:Subject:Content-Transfer-Encoding:Content-Type:From; bh=r3lv1UNVUaYVors11sp4hQwlDYt7i85juzTRXM9lXK8=;
	b=XzvQfrSy3sjjLq61po9d3MjA0oZBOY8zfRapXpd1ehbsfzRGrtlnkCthFXV6NsVdhtXIAVs1sEujblS46ajFRhDOw3ctsh8eeLrIbM4gUTvj2Bx4gtta4NwS761ztSZo;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch adds Makefile for fsck.nilfs2.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 09/11] nilfs-utils: fsck: add Makefile for fsck.nilfs2

This patch adds Makefile for fsck.nilfs2.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 sbin/fsck/Makefile.am |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)
 create mode 100644 sbin/fsck/Makefile.am

diff --git a/sbin/fsck/Makefile.am b/sbin/fsck/Makefile.am
new file mode 100644
index 0000000..fcb31ae
--- /dev/null
+++ b/sbin/fsck/Makefile.am
@@ -0,0 +1,14 @@
+## Makefile.am
+
+AM_CFLAGS = -Wall
+AM_CPPFLAGS = -I$(top_srcdir)/include
+LDADD = $(top_builddir)/lib/libnilfsmessages.la \
+	$(top_builddir)/lib/libfsck.la \
+	$(top_builddir)/lib/libmountchk.la \
+	$(top_builddir)/lib/libcrc32.la \
+	$(top_builddir)/lib/libnilfs.la
+
+sbin_PROGRAMS = fsck.nilfs2
+
+fsck_nilfs2_SOURCES = fsck_common.h fsck_nilfs2.c \
+			nilfs_superblock.c nilfs_superblock.h
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
