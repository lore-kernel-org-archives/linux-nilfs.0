From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 02/24] nilfs2: introduce base subsystem debugging output
 option
Date: Mon, 17 Jun 2013 16:22:22 +0400
Message-ID: <1371471742.2075.131.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=uYNET6YkkefzoUCqxFnsrTo3iRy6IJlgEBSEdc6NiCY=;
	b=aW5y8/IlTjFtJi95Yo+qlIYuj0o6n6Yrcrskgv/tNM8WbubEXd0elqOuWBj+vBmG6S3NurdzJiERwPsUDwZN2N3qvBwoUiqxaY3kbRK8sURP77ibIhiRIwkfpRJJdX+l;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Linux FS Devel <linux-fsdevel@vger.kernel.org>

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 02/24] nilfs2: introduce base subsystem debugging output option

This patch adds subsystem's flags for super.c, the_nilfs.c, namei.c,
ioctl.c, inode.c, file.c, dir.c modules. Flags for these modules are
grouped by CONFIG_NILFS2_DEBUG_BASE_OPERATIONS kernel configuration
option. This kernel configuration option enables (or disables)
debugging output from of all above-mentioned modules.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/Kconfig |   23 +++++++++++++++++++++++
 fs/nilfs2/debug.h |   21 ++++++++++++++++++++-
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index a379d8e..d886e15 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -34,4 +34,27 @@ config NILFS2_DEBUG
 	  written to the system log.  Under normal circumstances, this
 	  results in very little overhead.
 
+if NILFS2_DEBUG
+
+config NILFS2_DEBUG_SUBSYSTEMS
+	bool "Enable output from subsystems"
+	depends on NILFS2_DEBUG
+	default n
+	help
+	  This option groups opportunity to enable debugging output from
+	  concrete NILFS2 driver's subsystems.
+
+if NILFS2_DEBUG_SUBSYSTEMS
+
+config NILFS2_DEBUG_BASE_OPERATIONS
+	bool "Enable base operations subsystem debugging output"
+	default n
+	help
+	  This option enables debugging output in super.c, the_nilfs.c,
+	  namei.c, ioctl.c, inode.c, file.c, dir.c modules.
+
+endif # NILFS2_DEBUG_SUBSYSTEMS
+
+endif # NILFS2_DEBUG
+
 endif # NILFS2_FS
diff --git a/fs/nilfs2/debug.h b/fs/nilfs2/debug.h
index c351120..ae264f9 100644
--- a/fs/nilfs2/debug.h
+++ b/fs/nilfs2/debug.h
@@ -26,10 +26,29 @@
 
 #include <linux/printk.h>
 
+/*
+ * These flags enable debugging output in modules that
+ * implement base file system operations functionality
+ * (super.c, the_nilfs.c, namei.c, ioctl.c, inode.c,
+ * file.c, dir.c).
+ */
+#define DBG_SUPER	0x00000002
+#define DBG_THE_NILFS	0x00000004
+#define DBG_NAMEI	0x00000008
+#define DBG_IOCTL	0x00000010
+#define DBG_INODE	0x00000020
+#define DBG_FILE	0x00000040
+#define DBG_DIR		0x00000080
+
 #ifdef CONFIG_NILFS2_DEBUG
 
 /* Definition of flags' set for debugging */
-static u32 DBG_MASK = (0);
+static u32 DBG_MASK = (
+#ifdef CONFIG_NILFS2_DEBUG_BASE_OPERATIONS
+	DBG_SUPER | DBG_THE_NILFS | DBG_NAMEI |
+	DBG_IOCTL | DBG_INODE | DBG_FILE | DBG_DIR |
+#endif /* CONFIG_NILFS2_DEBUG_BASE_OPERATIONS */
+0);
 
 #define NILFS2_SUBSYS_MASK	0x0FFFFFFF
 #define NILFS2_DBG_OUT_MASK	0xF0000000
-- 
1.7.9.5



