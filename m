From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 22/24] nilfs2: introduce option of showing internal errors
Date: Mon, 17 Jun 2013 16:26:41 +0400
Message-ID: <1371472001.2075.154.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=SSzI2KQOcDNhedjtxt1CESRuk3X0DUGgK84hDlRphPc=;
	b=LeL0RYo7XckMEfy/7cPKq5/6g6EpVm4DqUcEMMjt5biA5wc4Gw3Rp1qqKoSNjjtecpy+ua2NhZjx96qb7HvcRiXWT4TRgCbDP+270kWU4J9iA6StpWZ8PhkQYR8ClEun;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 22/24] nilfs2: introduce option of showing internal errors

This patch adds CONFIG_NILFS2_DEBUG_SHOW_ERRORS kernel configuration
option. This option enables writing in system log messages about
internal errors of NILFS2 driver. Every such message records file,
function, line and code of error.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/Kconfig |    9 +++++++++
 fs/nilfs2/debug.h |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index 37fee87..451a3a2 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -36,6 +36,15 @@ config NILFS2_DEBUG
 
 if NILFS2_DEBUG
 
+config NILFS2_DEBUG_SHOW_ERRORS
+	bool "Show internal errors"
+	default n
+	help
+	  This option enables writing in system log messages about internal
+	  errors of NILFS2 driver. Every such message records file, function,
+	  line and code of error. These types of debugging messages can be
+	  very usefull for understanding and analyzing reasons of an issue.
+
 config NILFS2_DEBUG_DUMP_STACK
 	bool "Enable dump stack output"
 	default n
diff --git a/fs/nilfs2/debug.h b/fs/nilfs2/debug.h
index 3132367..821fc75 100644
--- a/fs/nilfs2/debug.h
+++ b/fs/nilfs2/debug.h
@@ -27,6 +27,14 @@
 #include <linux/printk.h>
 
 /*
+ * This flag enables writing in system log messages about internal
+ * errors of NILFS2 driver. Every such message records file, function,
+ * line and code of error. These types of debugging messages can be
+ * very usefull for understanding and analyzing reasons of an issue.
+ */
+#define DBG_SHOW_ERR	0x10000000
+
+/*
  * These flags enable debugging output in modules that
  * implement base file system operations functionality
  * (super.c, the_nilfs.c, namei.c, ioctl.c, inode.c,
@@ -124,6 +132,9 @@
 
 /* Definition of flags' set for debugging */
 static u32 DBG_MASK = (
+#ifdef CONFIG_NILFS2_DEBUG_SHOW_ERRORS
+	DBG_SHOW_ERR |
+#endif /* CONFIG_NILFS2_DEBUG_SHOW_ERRORS */
 #ifdef CONFIG_NILFS2_DEBUG_BASE_OPERATIONS
 	DBG_SUPER | DBG_THE_NILFS | DBG_NAMEI |
 	DBG_IOCTL | DBG_INODE | DBG_FILE | DBG_DIR |
@@ -210,11 +221,38 @@ static u32 DBG_MASK = (
 		} \
 	} while (0)
 
+static inline int nilfs2_error_dbg(unsigned int flg,
+				    const unsigned char *file,
+				    int line,
+				    const unsigned char *func,
+				    int err)
+{
+	bool can_show_err = DBG_MASK & DBG_SHOW_ERR;
+	bool should_show_err = flg & DBG_SHOW_ERR;
+
+	if (can_show_err && should_show_err) {
+		printk(KERN_DEBUG "NILFS DBGERR (%s, %d): %s: err %d\n",
+			file, line, func, err);
+	}
+	return err;
+}
+
 #else /* CONFIG_NILFS2_DEBUG */
 
 #define nilfs2_debug(flg, fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
 #define nilfs2_hexdump(flg, prefix, ptr, size)	no_printk(prefix)
+static inline int nilfs2_error_dbg(unsigned int flg,
+				    const unsigned char *file,
+				    int line,
+				    const unsigned char *func,
+				    int err)
+{
+	return err;
+}
 
 #endif /* CONFIG_NILFS2_DEBUG */
 
+#define NILFS_ERR_DBG(err) \
+	nilfs2_error_dbg(DBG_SHOW_ERR, __FILE__, __LINE__, __func__, err)
+
 #endif	/* _NILFS_DEBUG_H */
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
