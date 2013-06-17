From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 16/24] nilfs2: introduce dump stack option
Date: Mon, 17 Jun 2013 16:25:16 +0400
Message-ID: <1371471916.2075.148.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=fivofjTNHicQ3wEN+7kH7i/wqf2k85WNtR+PYmkKs7g=;
	b=qHRs64HaeYWAZY3EVKgsDixMYvl/qHZEGM8HC+TFar+y5OJ8JIQF1fzRUB8HP82+L0cfR3vWMVG2tozJu+IhqJ84mXWjs2LhcrDN/Qnvzc2vRUTwlAUKSG5FJUGnRQeu;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 16/24] nilfs2: introduce dump stack option

This patch adds CONFIG_NILFS2_DEBUG_DUMP_STACK kernel
configuration option. This option enables output of dump stack.
Usually, every function in NILFS2 driver begins from debugging
output of function name, file, line and input arguments' value.
In the case of enabling this option debugging output will include
dump stack too.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/Kconfig |   15 +++++++++++++++
 fs/nilfs2/debug.h |   19 ++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index d6299c6..c1ec3c9 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -36,6 +36,21 @@ config NILFS2_DEBUG
 
 if NILFS2_DEBUG
 
+config NILFS2_DEBUG_DUMP_STACK
+	bool "Enable dump stack output"
+	default n
+	help
+	  This option enables output of dump stack. Usually, every
+	  function in NILFS2 driver begins from debugging output of
+	  function name, file, line and input arguments' value.
+	  In the case of enabling this option debugging output
+	  will include dump stack too.
+
+	  Usually, dump stacks are printed out for called functions from
+	  files that are requested by flags. But dump stacks are
+	  printed out for all called functions in the case of dynamic
+	  debug (CONFIG_NILFS2_USE_PR_DEBUG).
+
 config NILFS2_DEBUG_SUBSYSTEMS
 	bool "Enable output from subsystems"
 	depends on NILFS2_DEBUG
diff --git a/fs/nilfs2/debug.h b/fs/nilfs2/debug.h
index 517c5e8..a85454c 100644
--- a/fs/nilfs2/debug.h
+++ b/fs/nilfs2/debug.h
@@ -89,6 +89,15 @@
  */
 #define DBG_PAGE	0x00400000
 
+/*
+ * This flag enables output of dump stack. Usually, every
+ * function in NILFS2 driver begins from debugging output of
+ * function name, file, line and input arguments' value.
+ * In the case of enabling this option debugging output
+ * will include dump stack too.
+ */
+#define DBG_DUMP_STACK	0x20000000
+
 #ifdef CONFIG_NILFS2_DEBUG
 
 /* Definition of flags' set for debugging */
@@ -117,6 +126,9 @@ static u32 DBG_MASK = (
 #ifdef CONFIG_NILFS2_DEBUG_BUFFER_MANAGEMENT
 	DBG_PAGE |
 #endif /* CONFIG_NILFS2_DEBUG_BUFFER_MANAGEMENT */
+#ifdef CONFIG_NILFS2_DEBUG_DUMP_STACK
+	DBG_DUMP_STACK |
+#endif /* CONFIG_NILFS2_DEBUG_DUMP_STACK */
 	0);
 
 #define NILFS2_SUBSYS_MASK	0x0FFFFFFF
@@ -131,8 +143,13 @@ static u32 DBG_MASK = (
 
 #define nilfs2_debug(flg, f, a...) \
 	do { \
-		if ((flg & NILFS2_SUBSYS_MASK) & DBG_MASK) \
+		bool can_dump_stack = DBG_MASK & DBG_DUMP_STACK; \
+		bool should_dump_stack = flg & DBG_DUMP_STACK; \
+		if ((flg & NILFS2_SUBSYS_MASK) & DBG_MASK) { \
 			nilfs2_printk(f, ## a); \
+			if (can_dump_stack && should_dump_stack) \
+				dump_stack(); \
+		} \
 	} while (0)
 
 #else /* CONFIG_NILFS2_DEBUG */
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
