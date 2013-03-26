From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][PATCH] nilfs2: add necessary declarations and methods for
 debug output infrastructure
Date: Tue, 26 Mar 2013 14:09:33 +0400
Message-ID: <1364292573.2109.9.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:To:Reply-To:From:Subject:Message-ID; bh=oSG6tbUomVXq1d9/FyADJGDblHSrPoPQnWq9V0dDEso=;
	b=JKQV+Q6Cvz5tmiTHOYiW117gBPcy1YyvMMNmjqryqZDIosIcPe/eRKQf3nK3LBuZPNab5ktBqg4J1Q7AEphtdFfjjSZsRL1GZ8sYhIFCRzk17UJcrYDTgG9g7DyvcHtD;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I think that NILFS2 very needs in good debug infrastructure and tracepoints adding. So, this first patch is my vision of necessary declarations and methods for debug output.

This patch is only for discussion because I am working on patch set with debug output for all NILFS2 modules.

Feel free to suggest any ideas and make remarks about debug output infrastructure in NILFS2.

With the best regards,
Vyacheslav Dubeyko.
---
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] nilfs2: add necessary declarations and methods for debug output infrastructure

This patch adds necessary declarations and methods for debug output infrastructure.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 fs/nilfs2/nilfs.h |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 9bc72de..4102667 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -32,6 +32,83 @@
 #include "the_nilfs.h"
 #include "bmap.h"
 
+/*
+ * Define NILFS2_DEBUG to produce debug messages
+ */
+#undef NILFS2_DEBUG
+
+/*
+ * Debug code
+ *
+ * The debug code includes:
+ * (1) NILFS2_DEBUG macro switch on/off debugging;
+ * (2) Debug flags for every NILFS2 module;
+ * (3) Debug mask that defines set of modules for debug output;
+ * (4) The nilfs2_debug() and nilfs2_hexdump() macros for debug output.
+ *
+ * In the case of necessity to enhance NILFS2 output by debug messages
+ * then it needs to do such action. First of all, to define by means of
+ * DBG_MASK what modules will have debug output. Secondly, switch on
+ * debug output by means of change #undef NILFS2_DEBUG on
+ * #define NILFS2_DEBUG. And, finally, recompile kernel.
+ */
+
+/* Debug flag for every module */
+#define DBG_HEX_DUMP	0x00000001
+#define DBG_ALLOC	0x00000002
+#define DBG_BMAP	0x00000004
+#define DBG_BTNODE	0x00000008
+#define DBG_BTREE	0x00000010
+#define DBG_CPFILE	0x00000020
+#define DBG_DAT		0x00000040
+#define DBG_DIR		0x00000080
+#define DBG_DIRECT	0x00000100
+#define DBG_FILE	0x00000200
+#define DBG_GCINODE	0x00000400
+#define DBG_IFILE	0x00000800
+#define DBG_INODE	0x00001000
+#define DBG_IOCTL	0x00002000
+#define DBG_MDT		0x00004000
+#define DBG_NAMEI	0x00008000
+#define DBG_PAGE	0x00010000
+#define DBG_RECOVERY	0x00020000
+#define DBG_SEGBUF	0x00040000
+#define DBG_SEGMENT	0x00080000
+#define DBG_SUFILE	0x00100000
+#define DBG_SUPER	0x00200000
+#define DBG_THE_NILFS	0x00400000
+
+/* Definition of flags' set for debugging */
+#ifdef NILFS2_DEBUG
+#define DBG_MASK	(DBG_SUPER|DBG_CPFILE|DBG_THE_NILFS|DBG_HEX_DUMP)
+#else
+#define DBG_MASK	(0)
+#endif
+
+#ifdef NILFS2_DEBUG
+#define nilfs2_debug(flg, f, a...) \
+	do { \
+		if (flg & DBG_MASK) { \
+			printk(KERN_DEBUG "NILFS DEBUG (%s, %d): %s:", \
+				__FILE__, __LINE__, __func__); \
+			printk(KERN_DEBUG f, ## a); \
+		} \
+	} while (0)
+
+#define nilfs2_hexdump(flg, prefix, ptr, size) \
+	do { \
+		if (flg & DBG_MASK) { \
+			printk(KERN_DEBUG "NILFS DEBUG (%s, %d): %s:", \
+				__FILE__, __LINE__, __func__); \
+			print_hex_dump_bytes(prefix, \
+				DUMP_PREFIX_NONE, ptr, size); \
+		} \
+	} while (0)
+#else
+#define nilfs2_debug(flg, fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
+#define nilfs2_hexdump(flg, prefix, ptr, size)	no_printk(prefix)
+#endif
+
 /**
  * struct nilfs_inode_info - nilfs inode data in memory
  * @i_flags: inode flags
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
