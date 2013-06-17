From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 12/24] nilfs2: introduce block mapping subsystem debugging
 output option
Date: Mon, 17 Jun 2013 16:24:31 +0400
Message-ID: <1371471871.2075.143.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=8U5iOdiM7k9bMFuwgTuAWWnts6H22wWvy/jNaGE4yJk=;
	b=EdT7Nsqrlcj697Np38B0sx+Eky85KNfqVbTDwkSXBljBtee37MErrM1U0+uoNOIYZyUq2+ByFXo3w1A8ZXIddcqiwRUrW5kGJ+uV+IhcoZr5SYcaTHYPyANiSIMJCeSV;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Linux FS Devel <linux-fsdevel@vger.kernel.org>

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 12/24] nilfs2: introduce block mapping subsystem debugging output option

This patch adds subsystem's flags for alloc.c, bmap.c, btnode.c,
btree.c, direct.c modules. Flags for these modules are grouped by
CONFIG_NILFS2_DEBUG_BLOCK_MAPPING kernel configuration option.
This kernel configuration option enables (or disables) debugging
output from of all above-mentioned modules.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/Kconfig |    7 +++++++
 fs/nilfs2/debug.h |   15 +++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index 5eb5140..b40fd85 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -79,6 +79,13 @@ config NILFS2_DEBUG_RECOVERY_SUBSYSTEM
 	help
 	  This option enables debugging output in recovery.c module.
 
+config NILFS2_DEBUG_BLOCK_MAPPING
+	bool "Enable block mapping subsystem debugging output"
+	default n
+	help
+	  This option enables debugging output in alloc.c, bmap.c, btnode.c,
+	  btree.c, direct.c modules.
+
 endif # NILFS2_DEBUG_SUBSYSTEMS
 
 endif # NILFS2_DEBUG
diff --git a/fs/nilfs2/debug.h b/fs/nilfs2/debug.h
index 538726d..ee712d4 100644
--- a/fs/nilfs2/debug.h
+++ b/fs/nilfs2/debug.h
@@ -71,6 +71,17 @@
  */
 #define DBG_RECOVERY	0x00010000
 
+/*
+ * These flags enable debugging output in modules that
+ * implement block mapping subsystem functionality
+ * (alloc.c, bmap.c, btnode.c, btree.c, direct.c).
+ */
+#define DBG_ALLOC	0x00020000
+#define DBG_BMAP	0x00040000
+#define DBG_BTNODE	0x00080000
+#define DBG_BTREE	0x00100000
+#define DBG_DIRECT	0x00200000
+
 #ifdef CONFIG_NILFS2_DEBUG
 
 /* Definition of flags' set for debugging */
@@ -92,6 +103,10 @@ static u32 DBG_MASK = (
 #ifdef CONFIG_NILFS2_DEBUG_RECOVERY_SUBSYSTEM
 	DBG_RECOVERY |
 #endif /* CONFIG_NILFS2_DEBUG_RECOVERY_SUBSYSTEM */
+#ifdef CONFIG_NILFS2_DEBUG_BLOCK_MAPPING
+	DBG_ALLOC | DBG_BMAP | DBG_BTNODE |
+	DBG_BTREE | DBG_DIRECT |
+#endif /* CONFIG_NILFS2_DEBUG_BLOCK_MAPPING */
 	0);
 
 #define NILFS2_SUBSYS_MASK	0x0FFFFFFF
-- 
1.7.9.5



