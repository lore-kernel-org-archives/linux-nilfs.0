From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 01/24] nilfs2: introduce nilfs2_debug() method
Date: Mon, 17 Jun 2013 16:22:10 +0400
Message-ID: <1371471730.2075.130.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=GcniFxkKNAs4DI6FWRMmMsXGYIdjgISmRPA7WWBO264=;
	b=r+LGcsuv+LIPRmIACRjH+kCvN1qoSrzAm1M1MG+YvG87lG7SDdf4W51/7zoSkZBRChVnh/8UXHpB03DIJz+LDocstnNtwB8uuX+lw3y2N5MrMvrV1JMDjF8/q+ozOuwG;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 01/24] nilfs2: introduce nilfs2_debug() method

This patch adds basis for debugging subsystem in NILFS2.
It introduces kernel configuration option CONFIG_NILFS2_DEBUG that
enables debugging opportunity for NILFS2. This configuration option
is depended from CONFIG_NILFS2_FS.

The nilfs2_debug() method is a basic method for debugging output.
It receives a set of flags, format string and variable arguments list.
The debug subsystem has DBG_MASK variable. It defines flags of
subsystems and options that can be printed. The nilfs2_debug()
method compares DBG_MASK with flags during a call. If requested flags
are valid for output then debugging output takes place.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/Kconfig |   13 +++++++++++++
 fs/nilfs2/debug.h |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)
 create mode 100644 fs/nilfs2/debug.h

diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index 80da8eb..a379d8e 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -22,3 +22,16 @@ config NILFS2_FS
 
 	  To compile this file system support as a module, choose M here: the
 	  module will be called nilfs2.  If unsure, say N.
+
+if NILFS2_FS
+
+config NILFS2_DEBUG
+	bool "NILFS2 debugging"
+	default n
+	help
+	  If you are experiencing any problems with the NILFS2 filesystem, say
+	  Y here.  This will result in additional debugging messages to be
+	  written to the system log.  Under normal circumstances, this
+	  results in very little overhead.
+
+endif # NILFS2_FS
diff --git a/fs/nilfs2/debug.h b/fs/nilfs2/debug.h
new file mode 100644
index 0000000..c351120
--- /dev/null
+++ b/fs/nilfs2/debug.h
@@ -0,0 +1,56 @@
+/*
+ * debug.h - NILFS debug output infrastructure.
+ *
+ * Copyright (C) 2005-2013 Nippon Telegraph and Telephone Corporation.
+ * Copyright (c) 2013 Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
+ */
+
+#ifndef _NILFS_DEBUG_H
+#define _NILFS_DEBUG_H
+
+#include <linux/printk.h>
+
+#ifdef CONFIG_NILFS2_DEBUG
+
+/* Definition of flags' set for debugging */
+static u32 DBG_MASK = (0);
+
+#define NILFS2_SUBSYS_MASK	0x0FFFFFFF
+#define NILFS2_DBG_OUT_MASK	0xF0000000
+
+#define nilfs2_printk(f, a...) \
+	do { \
+		printk(KERN_DEBUG "NILFS DEBUG (%s, %d): %s:\n", \
+			__FILE__, __LINE__, __func__); \
+		printk(KERN_DEBUG f, ## a); \
+	} while (0)
+
+#define nilfs2_debug(flg, f, a...) \
+	do { \
+		if ((flg & NILFS2_SUBSYS_MASK) & DBG_MASK) \
+			nilfs2_printk(f, ## a); \
+	} while (0)
+
+#else /* CONFIG_NILFS2_DEBUG */
+
+#define nilfs2_debug(flg, fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
+
+#endif /* CONFIG_NILFS2_DEBUG */
+
+#endif	/* _NILFS_DEBUG_H */
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
