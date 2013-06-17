From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 10/24] nilfs2: introduce recovery subsystem debugging output
 option
Date: Mon, 17 Jun 2013 16:24:06 +0400
Message-ID: <1371471846.2075.141.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=fnsZC57jkpFXEVzWezAuusrj8HBJ7l6ISZbRM1p/q+I=;
	b=JXbi0iPa97a6n2PPkUjc0KuTXjzQCnEovMQ402ymmHhx+0/pBtxhkZ0/eCUZOm7l5AXXgK9YsgcoYzNZGkXrbNO09VPPo/pI/ElPCsUwMSfEnTcCy92MompqRJ1YVumH;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Linux FS Devel <linux-fsdevel@vger.kernel.org>

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 10/24] nilfs2: introduce recovery subsystem debugging output option

This patch adds subsystem's flags for recovery.c module.
Flags for these modules are grouped by CONFIG_NILFS2_DEBUG_RECOVERY_SUBSYSTEM
kernel configuration option. This kernel configuration option enables
(or disables) debugging output from of all above-mentioned modules.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/Kconfig |    6 ++++++
 fs/nilfs2/debug.h |    9 +++++++++
 2 files changed, 15 insertions(+)

diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index 465b9aa..5eb5140 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -73,6 +73,12 @@ config NILFS2_DEBUG_GC_SUBSYSTEM
 	help
 	  This option enables debugging output in gcinode.c module.
 
+config NILFS2_DEBUG_RECOVERY_SUBSYSTEM
+	bool "Enable recovery subsystem debugging output"
+	default n
+	help
+	  This option enables debugging output in recovery.c module.
+
 endif # NILFS2_DEBUG_SUBSYSTEMS
 
 endif # NILFS2_DEBUG
diff --git a/fs/nilfs2/debug.h b/fs/nilfs2/debug.h
index ae00e9b..538726d 100644
--- a/fs/nilfs2/debug.h
+++ b/fs/nilfs2/debug.h
@@ -65,6 +65,12 @@
  */
 #define DBG_GCINODE	0x00008000
 
+/*
+ * These flags enable debugging output in modules that
+ * implement recovery subsystem functionality (recovery.c).
+ */
+#define DBG_RECOVERY	0x00010000
+
 #ifdef CONFIG_NILFS2_DEBUG
 
 /* Definition of flags' set for debugging */
@@ -83,6 +89,9 @@ static u32 DBG_MASK = (
 #ifdef CONFIG_NILFS2_DEBUG_GC_SUBSYSTEM
 	DBG_GCINODE | DBG_IOCTL |
 #endif /* CONFIG_NILFS2_DEBUG_GC_SUBSYSTEM */
+#ifdef CONFIG_NILFS2_DEBUG_RECOVERY_SUBSYSTEM
+	DBG_RECOVERY |
+#endif /* CONFIG_NILFS2_DEBUG_RECOVERY_SUBSYSTEM */
 	0);
 
 #define NILFS2_SUBSYS_MASK	0x0FFFFFFF
-- 
1.7.9.5



