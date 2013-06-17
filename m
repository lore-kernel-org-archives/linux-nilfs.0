From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 18/24] nilfs2: introduce superfluous debugging output option
Date: Mon, 17 Jun 2013 16:25:49 +0400
Message-ID: <1371471949.2075.150.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=IgqMiJgr1X4KEGacT8ErVQTkkHRDcA6mb1Sph3s30K0=;
	b=Rs4X2iVvqXqgTgvNHH9X3OfQOTKsSbNjGFreR7unZ+91fM4DhAxiZiAQIxPYbl9mQ7ukxcdWrFBnBHlyE/aTnRSzBaeGoDt3icuamsIE6FCRisR0CF5DhcOi8LqDtzzc;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 18/24] nilfs2: introduce superfluous debugging output option

This patch adds CONFIG_NILFS2_DEBUG_SHOW_SPAM kernel
configuration option. This option enables output from
frequently called functions or detailed debugging output
from function's body.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/Kconfig |   12 ++++++++++++
 fs/nilfs2/debug.h |   22 +++++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index c1ec3c9..39dc5c39 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -107,6 +107,18 @@ config NILFS2_DEBUG_BUFFER_MANAGEMENT
 	help
 	  This option enables debugging output in page.c module.
 
+config NILFS2_DEBUG_SHOW_SPAM
+	bool "Enable superfluous debugging output"
+	default n
+	help
+	  This option enables output from frequently called functions or
+	  detailed debugging output from function's body. Please, be
+	  cautious with enabling the option. Because it can be resulted
+	  in huge amount of debugging messages in system log and
+	  performance decreasing. Please, remember that superfluos output
+	  option is depended implicitly from options that enable output of
+	  concrete modules of NILFS2 driver.
+
 endif # NILFS2_DEBUG_SUBSYSTEMS
 
 endif # NILFS2_DEBUG
diff --git a/fs/nilfs2/debug.h b/fs/nilfs2/debug.h
index a85454c..3f3b42b 100644
--- a/fs/nilfs2/debug.h
+++ b/fs/nilfs2/debug.h
@@ -98,6 +98,17 @@
  */
 #define DBG_DUMP_STACK	0x20000000
 
+/*
+ * This flag enables output from frequently called functions or
+ * detailed debugging output from function's body. Please, be
+ * cautious with enabling the option. Because it can be resulted
+ * in huge amount of debugging messages in system log and
+ * performance decreasing. Please, remember that superfluos output
+ * option is depended implicitly from options that enable output of
+ * concrete modules of NILFS2 driver.
+ */
+#define DBG_SPAM	0x40000000
+
 #ifdef CONFIG_NILFS2_DEBUG
 
 /* Definition of flags' set for debugging */
@@ -129,6 +140,9 @@ static u32 DBG_MASK = (
 #ifdef CONFIG_NILFS2_DEBUG_DUMP_STACK
 	DBG_DUMP_STACK |
 #endif /* CONFIG_NILFS2_DEBUG_DUMP_STACK */
+#ifdef CONFIG_NILFS2_DEBUG_SHOW_SPAM
+	DBG_SPAM |
+#endif /* CONFIG_NILFS2_DEBUG_SHOW_SPAM */
 	0);
 
 #define NILFS2_SUBSYS_MASK	0x0FFFFFFF
@@ -143,10 +157,16 @@ static u32 DBG_MASK = (
 
 #define nilfs2_debug(flg, f, a...) \
 	do { \
+		bool can_print_spam = DBG_MASK & DBG_SPAM; \
+		bool is_spam = flg & DBG_SPAM; \
 		bool can_dump_stack = DBG_MASK & DBG_DUMP_STACK; \
 		bool should_dump_stack = flg & DBG_DUMP_STACK; \
 		if ((flg & NILFS2_SUBSYS_MASK) & DBG_MASK) { \
-			nilfs2_printk(f, ## a); \
+			if (is_spam) { \
+				if (can_print_spam) \
+					nilfs2_printk(f, ## a); \
+			} else \
+				nilfs2_printk(f, ## a); \
 			if (can_dump_stack && should_dump_stack) \
 				dump_stack(); \
 		} \
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
