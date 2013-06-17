From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 04/24] nilfs2: introduce metadata (MDT) files debugging
 output option
Date: Mon, 17 Jun 2013 16:22:54 +0400
Message-ID: <1371471774.2075.133.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=ZG+u4xCL5NdK8tiAxotxhDH7xyOSTZwkyiaP0F7DGQU=;
	b=lk8lmYLkXnBS/jWRWeHZu8oEiMhvrbRREAf5QPltktFXGkBB9wwQlao//RsnfXMXXRJ8CNCSuez5S4ESvKP7rLBl4JDmducBZFeVF0ZIabVavLB9211/yLDy1pvUp8MF;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 04/24] nilfs2: introduce metadata (MDT) files debugging output option

This patch adds subsystem's flags for mdt.c, cpfile.c, dat.c,
ifile.c, sufile.c modules. Flags for these modules are
grouped by CONFIG_NILFS2_DEBUG_MDT_FILES kernel configuration
option. This kernel configuration option enables (or disables)
debugging output from of all above-mentioned modules.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/Kconfig |    7 +++++++
 fs/nilfs2/debug.h |   17 ++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index d886e15..3142c0d 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -53,6 +53,13 @@ config NILFS2_DEBUG_BASE_OPERATIONS
 	  This option enables debugging output in super.c, the_nilfs.c,
 	  namei.c, ioctl.c, inode.c, file.c, dir.c modules.
 
+config NILFS2_DEBUG_MDT_FILES
+	bool "Enable metadata (MDT) files subsystem debugging output"
+	default n
+	help
+	  This option enables debugging output in mdt.c, cpfile.c, dat.c,
+	  ifile.c, sufile.c modules.
+
 endif # NILFS2_DEBUG_SUBSYSTEMS
 
 endif # NILFS2_DEBUG
diff --git a/fs/nilfs2/debug.h b/fs/nilfs2/debug.h
index ae264f9..236a18a 100644
--- a/fs/nilfs2/debug.h
+++ b/fs/nilfs2/debug.h
@@ -40,6 +40,17 @@
 #define DBG_FILE	0x00000040
 #define DBG_DIR		0x00000080
 
+/*
+ * These flags enable debugging output in modules that
+ * implement metadata (MDT) files functionality
+ * (mdt.c, cpfile.c, dat.c, ifile.c, sufile.c).
+ */
+#define DBG_MDT		0x00000100
+#define DBG_CPFILE	0x00000200
+#define DBG_DAT		0x00000400
+#define DBG_IFILE	0x00000800
+#define DBG_SUFILE	0x00001000
+
 #ifdef CONFIG_NILFS2_DEBUG
 
 /* Definition of flags' set for debugging */
@@ -48,7 +59,11 @@ static u32 DBG_MASK = (
 	DBG_SUPER | DBG_THE_NILFS | DBG_NAMEI |
 	DBG_IOCTL | DBG_INODE | DBG_FILE | DBG_DIR |
 #endif /* CONFIG_NILFS2_DEBUG_BASE_OPERATIONS */
-0);
+#ifdef CONFIG_NILFS2_DEBUG_MDT_FILES
+	DBG_MDT | DBG_CPFILE | DBG_DAT |
+	DBG_IFILE | DBG_SUFILE |
+#endif /* CONFIG_NILFS2_DEBUG_MDT_FILES */
+	0);
 
 #define NILFS2_SUBSYS_MASK	0x0FFFFFFF
 #define NILFS2_DBG_OUT_MASK	0xF0000000
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
