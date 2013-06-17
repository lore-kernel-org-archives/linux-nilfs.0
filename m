From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 06/24] nilfs2: introduce segments subsystem debugging output
 option
Date: Mon, 17 Jun 2013 16:23:19 +0400
Message-ID: <1371471799.2075.136.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=u72yA2D2G1am30k/T+d+3Z+G+JiKssQ+47KJEJz2cgs=;
	b=XBBtShwrXbdY9ZAzIqEuSc+7ABLNGwEwSdWRSLZLuyNOwosEf+rF1zyalPMwEy7dfKTYS6s7OE5yPFAaEFYrLpfScKur3A3OhYMiL0mCAsIveEcrZm+49oUv/llbEHUO;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Linux FS Devel <linux-fsdevel@vger.kernel.org>

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 06/24] nilfs2: introduce segments subsystem debugging output option

This patch adds subsystem's flags for segbuf.c, segment.c modules.
Flags for these modules are grouped by CONFIG_NILFS2_DEBUG_SEGMENTS_SUBSYSTEM
kernel configuration option. This kernel configuration option enables
(or disables) debugging output from of all above-mentioned modules.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/Kconfig |    7 +++++++
 fs/nilfs2/debug.h |   11 +++++++++++
 2 files changed, 18 insertions(+)

diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index 3142c0d..91ae8b3 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -60,6 +60,13 @@ config NILFS2_DEBUG_MDT_FILES
 	  This option enables debugging output in mdt.c, cpfile.c, dat.c,
 	  ifile.c, sufile.c modules.
 
+config NILFS2_DEBUG_SEGMENTS_SUBSYSTEM
+	bool "Enable segments subsystem debugging output"
+	default n
+	help
+	  This option enables debugging output in segbuf.c, segment.c
+	  modules.
+
 endif # NILFS2_DEBUG_SUBSYSTEMS
 
 endif # NILFS2_DEBUG
diff --git a/fs/nilfs2/debug.h b/fs/nilfs2/debug.h
index 236a18a..e2e619e 100644
--- a/fs/nilfs2/debug.h
+++ b/fs/nilfs2/debug.h
@@ -51,6 +51,14 @@
 #define DBG_IFILE	0x00000800
 #define DBG_SUFILE	0x00001000
 
+/*
+ * These flags enable debugging output in modules that
+ * implement segments subsystem functionality
+ * (segbuf.c, segment.c).
+ */
+#define DBG_SEGBUF	0x00002000
+#define DBG_SEGMENT	0x00004000
+
 #ifdef CONFIG_NILFS2_DEBUG
 
 /* Definition of flags' set for debugging */
@@ -63,6 +71,9 @@ static u32 DBG_MASK = (
 	DBG_MDT | DBG_CPFILE | DBG_DAT |
 	DBG_IFILE | DBG_SUFILE |
 #endif /* CONFIG_NILFS2_DEBUG_MDT_FILES */
+#ifdef CONFIG_NILFS2_DEBUG_SEGMENTS_SUBSYSTEM
+	DBG_SEGBUF | DBG_SEGMENT |
+#endif /* CONFIG_NILFS2_DEBUG_SEGMENTS_SUBSYSTEM */
 	0);
 
 #define NILFS2_SUBSYS_MASK	0x0FFFFFFF
-- 
1.7.9.5



