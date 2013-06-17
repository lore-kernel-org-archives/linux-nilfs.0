From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 14/24] nilfs2: introduce buffer management subsystem
 debugging output option
Date: Mon, 17 Jun 2013 16:24:55 +0400
Message-ID: <1371471895.2075.145.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=hc+rGn71l8D4aqej10wAbaLHbLZSY1iouRdV+QyVPHY=;
	b=LIaRbPLv57tkFbGY8PU9wPH5A6vQZfTj57wTUHjdum0bHckRCPDrmNG7C4qREPpqTFVDFxODvxW+hZGI+PkoTGMtMd2asu1DyObffULLmrbRBblaR0JvjxIWdchVD4mz;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Linux FS Devel <linux-fsdevel@vger.kernel.org>

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 14/24] nilfs2: introduce buffer management subsystem debugging output option

This patch adds subsystem's flags for page.c module.
Flags for these modules are grouped by
CONFIG_NILFS2_DEBUG_BUFFER_MANAGEMENT kernel configuration option.
This kernel configuration option enables (or disables) debugging
output from of all above-mentioned modules.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/Kconfig |    6 ++++++
 fs/nilfs2/debug.h |   10 ++++++++++
 2 files changed, 16 insertions(+)

diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index b40fd85..d6299c6 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -86,6 +86,12 @@ config NILFS2_DEBUG_BLOCK_MAPPING
 	  This option enables debugging output in alloc.c, bmap.c, btnode.c,
 	  btree.c, direct.c modules.
 
+config NILFS2_DEBUG_BUFFER_MANAGEMENT
+	bool "Enable buffer/page management subsystem debugging output"
+	default n
+	help
+	  This option enables debugging output in page.c module.
+
 endif # NILFS2_DEBUG_SUBSYSTEMS
 
 endif # NILFS2_DEBUG
diff --git a/fs/nilfs2/debug.h b/fs/nilfs2/debug.h
index ee712d4..517c5e8 100644
--- a/fs/nilfs2/debug.h
+++ b/fs/nilfs2/debug.h
@@ -82,6 +82,13 @@
 #define DBG_BTREE	0x00100000
 #define DBG_DIRECT	0x00200000
 
+/*
+ * These flags enable debugging output in modules that
+ * implement buffer management subsystem functionality
+ * (page.c).
+ */
+#define DBG_PAGE	0x00400000
+
 #ifdef CONFIG_NILFS2_DEBUG
 
 /* Definition of flags' set for debugging */
@@ -107,6 +114,9 @@ static u32 DBG_MASK = (
 	DBG_ALLOC | DBG_BMAP | DBG_BTNODE |
 	DBG_BTREE | DBG_DIRECT |
 #endif /* CONFIG_NILFS2_DEBUG_BLOCK_MAPPING */
+#ifdef CONFIG_NILFS2_DEBUG_BUFFER_MANAGEMENT
+	DBG_PAGE |
+#endif /* CONFIG_NILFS2_DEBUG_BUFFER_MANAGEMENT */
 	0);
 
 #define NILFS2_SUBSYS_MASK	0x0FFFFFFF
-- 
1.7.9.5



