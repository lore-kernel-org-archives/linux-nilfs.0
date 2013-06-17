From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 20/24] nilfs2: introduce hexdump of internal structures
 option
Date: Mon, 17 Jun 2013 16:26:15 +0400
Message-ID: <1371471975.2075.152.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=qMker4Lrh0JDCQwz4Dby+xocBtvK74+xs76pC+bZPTo=;
	b=q0ioaX1MH9lSLWvAD+0Cd+6KBvKzvkq8spXtN77buO9pPMlmBa4ALiraIP/bNYEdvY9a/j2B6D+BBQ2DCo3IQvpv1Ci0SrlyQZF9+xpTZAnss57SLxVa9Yaz7vPgr6mB;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 20/24] nilfs2: introduce hexdump of internal structures option

This patch adds CONFIG_NILFS2_DEBUG_HEXDUMP kernel configuration
option. This option enables writing in system log hexdumps of
internal structures.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/Kconfig |   12 ++++++++++++
 fs/nilfs2/debug.h |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index 39dc5c39..37fee87 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -119,6 +119,18 @@ config NILFS2_DEBUG_SHOW_SPAM
 	  option is depended implicitly from options that enable output of
 	  concrete modules of NILFS2 driver.
 
+config NILFS2_DEBUG_HEXDUMP
+	bool "Enable debugging hexdump of internal structures"
+	default n
+	help
+	  This option enables writing in system log hexdumps of internal
+	  structures. Some of big internal and raw on-disk structures can be
+	  written in system log for deep analysis of processed data related
+	  to an issue. Please, remember that hexdump output is depended
+	  implicitly from options that enable output of concrete modules of
+	  NILFS2 driver. It makes sense to log hexdumps only for modules that
+	  have enabled debugging output.
+
 endif # NILFS2_DEBUG_SUBSYSTEMS
 
 endif # NILFS2_DEBUG
diff --git a/fs/nilfs2/debug.h b/fs/nilfs2/debug.h
index 3f3b42b..3132367 100644
--- a/fs/nilfs2/debug.h
+++ b/fs/nilfs2/debug.h
@@ -109,6 +109,17 @@
  */
 #define DBG_SPAM	0x40000000
 
+/*
+ * This flag enables writing in system log hexdumps of internal
+ * structures. Some of big internal and raw on-disk structures can be
+ * written in system log for deep analysis of processed data related
+ * to an issue. Please, remember that hexdump output is depended
+ * implicitly from options that enable output of concrete modules of
+ * NILFS2 driver. It makes sense to log hexdumps only for modules that
+ * have enabled debugging output.
+ */
+#define DBG_HEX_DUMP	0x80000000
+
 #ifdef CONFIG_NILFS2_DEBUG
 
 /* Definition of flags' set for debugging */
@@ -143,6 +154,9 @@ static u32 DBG_MASK = (
 #ifdef CONFIG_NILFS2_DEBUG_SHOW_SPAM
 	DBG_SPAM |
 #endif /* CONFIG_NILFS2_DEBUG_SHOW_SPAM */
+#ifdef CONFIG_NILFS2_DEBUG_HEXDUMP
+	DBG_HEX_DUMP |
+#endif /* CONFIG_NILFS2_DEBUG_HEXDUMP */
 	0);
 
 #define NILFS2_SUBSYS_MASK	0x0FFFFFFF
@@ -172,9 +186,34 @@ static u32 DBG_MASK = (
 		} \
 	} while (0)
 
+#define nilfs2_print_hexdump(prefix, ptr, size) \
+	do { \
+		printk(KERN_DEBUG "NILFS HEXDUMP (%s, %d): %s:\n", \
+				__FILE__, __LINE__, __func__); \
+		print_hex_dump(KERN_DEBUG, prefix, \
+				DUMP_PREFIX_ADDRESS, 16, 1, \
+				ptr, size, true); \
+	} while (0)
+
+#define nilfs2_hexdump(flg, prefix, ptr, size) \
+	do { \
+		bool can_print_spam = DBG_MASK & DBG_SPAM; \
+		bool is_spam = flg & DBG_SPAM; \
+		bool can_do_hexdump = DBG_MASK & DBG_HEX_DUMP; \
+		bool is_hexdump = flg & DBG_HEX_DUMP; \
+		if ((flg & NILFS2_SUBSYS_MASK) & DBG_MASK) { \
+			if (!is_spam && (is_hexdump && can_do_hexdump)) \
+				nilfs2_print_hexdump(prefix, ptr, size); \
+			else if ((is_spam && can_print_spam) && \
+					(is_hexdump && can_do_hexdump)) \
+				nilfs2_print_hexdump(prefix, ptr, size); \
+		} \
+	} while (0)
+
 #else /* CONFIG_NILFS2_DEBUG */
 
 #define nilfs2_debug(flg, fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
+#define nilfs2_hexdump(flg, prefix, ptr, size)	no_printk(prefix)
 
 #endif /* CONFIG_NILFS2_DEBUG */
 
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
