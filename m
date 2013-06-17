From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 24/24] nilfs2: introduce option of using dynamic debugging
Date: Mon, 17 Jun 2013 16:29:56 +0400
Message-ID: <1371472196.2075.159.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=d8VqugntGBxV0Og/cwB/E/ae4PtuHR9P2uZc/GoiHGs=;
	b=nR2fTNC3GW+1Pgc1/kWym17S6IDIV+x+6QYeepvhuYbnxVifnAZl1ue2RYM+BvQpBVb0CR2welZCvcku/t/kmHr15nzmQ8FLlS5Q1gGKl4RmsBjab1gIWUN97YTFqOsV;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Linux FS Devel <linux-fsdevel@vger.kernel.org>

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 24/24] nilfs2: introduce option of using dynamic debugging

This patch implements opportunity of dynamic debugging in NILFS2 driver.
It introduces CONFIG_NILFS2_USE_PR_DEBUG kernel configuration
option. Enabling of this option results in using of pr_debug()
instead of printk() and print_hex_dump_bytes() instead of
print_hex_dump(). If CONFIG_NILFS2_USE_PR_DEBUG is not set then
debugging messages are selected for printing in system log by means of
comparing of requested flags and DBG_MASK's flags set. Otherwise, the
behaviour of of pr_debug()/print_hex_dump_bytes()s are controlled via
writing to a control file in the 'debugfs' filesystem.

If CONFIG_NILFS2_USE_PR_DEBUG option is not set then it is used
printk()/print_hex_dump() for printing debugging messages in
system log.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/Kconfig |   22 ++++++++++++++++++++++
 fs/nilfs2/debug.h |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index 451a3a2..502419a 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -36,6 +36,24 @@ config NILFS2_DEBUG
 
 if NILFS2_DEBUG
 
+config NILFS2_USE_PR_DEBUG
+	bool "Use pr_debug() instead of printk()"
+	default n
+	select DYNAMIC_DEBUG
+	help
+	  This option enables using of pr_debug() instead of printk()
+	  and print_hex_dump_bytes() instead of print_hex_dump().
+
+	  If CONFIG_NILFS2_USE_PR_DEBUG is not set then debugging messages are
+	  selected for printing in system log by means of comparing of
+	  requested flags and DBG_MASK's flags set. Otherwise, the behaviour
+	  of of pr_debug()/print_hex_dump_bytes()s are controlled via writing
+	  to a control file in the 'debugfs' filesystem.
+
+	  If CONFIG_NILFS2_USE_PR_DEBUG option is not set then it is used
+	  printk()/print_hex_dump() for printing debugging messages in
+	  system log.
+
 config NILFS2_DEBUG_SHOW_ERRORS
 	bool "Show internal errors"
 	default n
@@ -60,6 +78,8 @@ config NILFS2_DEBUG_DUMP_STACK
 	  printed out for all called functions in the case of dynamic
 	  debug (CONFIG_NILFS2_USE_PR_DEBUG).
 
+if !NILFS2_USE_PR_DEBUG || (NILFS2_USE_PR_DEBUG && !DYNAMIC_DEBUG)
+
 config NILFS2_DEBUG_SUBSYSTEMS
 	bool "Enable output from subsystems"
 	depends on NILFS2_DEBUG
@@ -142,6 +162,8 @@ config NILFS2_DEBUG_HEXDUMP
 
 endif # NILFS2_DEBUG_SUBSYSTEMS
 
+endif # !NILFS2_USE_PR_DEBUG || (NILFS2_USE_PR_DEBUG && !DYNAMIC_DEBUG)
+
 endif # NILFS2_DEBUG
 
 endif # NILFS2_FS
diff --git a/fs/nilfs2/debug.h b/fs/nilfs2/debug.h
index 821fc75..585477e 100644
--- a/fs/nilfs2/debug.h
+++ b/fs/nilfs2/debug.h
@@ -173,6 +173,37 @@ static u32 DBG_MASK = (
 #define NILFS2_SUBSYS_MASK	0x0FFFFFFF
 #define NILFS2_DBG_OUT_MASK	0xF0000000
 
+#if (defined(CONFIG_NILFS2_USE_PR_DEBUG) && defined(CONFIG_DYNAMIC_DEBUG))
+
+#define nilfs2_printk(f, a...) \
+	do { \
+		pr_debug("NILFS DEBUG (%s, %d): %s:\n", \
+			__FILE__, __LINE__, __func__); \
+		pr_debug(f, ## a); \
+	} while (0)
+
+#define nilfs2_debug(flg, f, a...) \
+	do { \
+		bool can_dump_stack = DBG_MASK & DBG_DUMP_STACK; \
+		bool should_dump_stack = flg & DBG_DUMP_STACK; \
+		nilfs2_printk(f, ## a); \
+		if (can_dump_stack && should_dump_stack) \
+			dump_stack(); \
+	} while (0)
+
+#define nilfs2_print_hexdump(prefix, ptr, size) \
+	do { \
+		pr_debug("NILFS HEXDUMP (%s, %d): %s:\n", \
+				__FILE__, __LINE__, __func__); \
+		print_hex_dump_bytes(prefix, \
+				DUMP_PREFIX_ADDRESS, ptr, size); \
+	} while (0)
+
+#define nilfs2_hexdump(flg, prefix, ptr, size) \
+		nilfs2_print_hexdump(prefix, ptr, size)
+
+#else /* CONFIG_NILFS2_USE_PR_DEBUG && CONFIG_DYNAMIC_DEBUG */
+
 #define nilfs2_printk(f, a...) \
 	do { \
 		printk(KERN_DEBUG "NILFS DEBUG (%s, %d): %s:\n", \
@@ -221,6 +252,8 @@ static u32 DBG_MASK = (
 		} \
 	} while (0)
 
+#endif /* CONFIG_NILFS2_USE_PR_DEBUG && CONFIG_DYNAMIC_DEBUG */
+
 static inline int nilfs2_error_dbg(unsigned int flg,
 				    const unsigned char *file,
 				    int line,
-- 
1.7.9.5



