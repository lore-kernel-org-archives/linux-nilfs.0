From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 08/24] nilfs2: introduce GC subsystem debugging output option
Date: Mon, 17 Jun 2013 16:23:44 +0400
Message-ID: <1371471824.2075.138.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=mQc0Zjac6HiF78qXvbCG6i4jpGy/uFPMnRtr2/97HMI=;
	b=SFUnh9S4QLY936hvhUGmDnC2KGHSxKobxdg+Kk1fjwHAS8Yl09sQwgN1uxj2cN7+jA/enu6sDSswYtP/ny/1Oqnn/YQNn8dy698g89W3cKXCPiCKe29Km/gdtF5kKARn;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 08/24] nilfs2: introduce GC subsystem debugging output option

This patch adds subsystem's flags for gcinode.c module.
Flags for these modules are grouped by CONFIG_NILFS2_DEBUG_GC_SUBSYSTEM
kernel configuration option. This kernel configuration option enables
(or disables) debugging output from of all above-mentioned modules.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/Kconfig |    6 ++++++
 fs/nilfs2/debug.h |    9 +++++++++
 2 files changed, 15 insertions(+)

diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index 91ae8b3..465b9aa 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -67,6 +67,12 @@ config NILFS2_DEBUG_SEGMENTS_SUBSYSTEM
 	  This option enables debugging output in segbuf.c, segment.c
 	  modules.
 
+config NILFS2_DEBUG_GC_SUBSYSTEM
+	bool "Enable GC subsystem debugging output"
+	default n
+	help
+	  This option enables debugging output in gcinode.c module.
+
 endif # NILFS2_DEBUG_SUBSYSTEMS
 
 endif # NILFS2_DEBUG
diff --git a/fs/nilfs2/debug.h b/fs/nilfs2/debug.h
index e2e619e..ae00e9b 100644
--- a/fs/nilfs2/debug.h
+++ b/fs/nilfs2/debug.h
@@ -59,6 +59,12 @@
 #define DBG_SEGBUF	0x00002000
 #define DBG_SEGMENT	0x00004000
 
+/*
+ * These flags enable debugging output in modules that
+ * implement GC subsystem functionality (gcinode.c).
+ */
+#define DBG_GCINODE	0x00008000
+
 #ifdef CONFIG_NILFS2_DEBUG
 
 /* Definition of flags' set for debugging */
@@ -74,6 +80,9 @@ static u32 DBG_MASK = (
 #ifdef CONFIG_NILFS2_DEBUG_SEGMENTS_SUBSYSTEM
 	DBG_SEGBUF | DBG_SEGMENT |
 #endif /* CONFIG_NILFS2_DEBUG_SEGMENTS_SUBSYSTEM */
+#ifdef CONFIG_NILFS2_DEBUG_GC_SUBSYSTEM
+	DBG_GCINODE | DBG_IOCTL |
+#endif /* CONFIG_NILFS2_DEBUG_GC_SUBSYSTEM */
 	0);
 
 #define NILFS2_SUBSYS_MASK	0x0FFFFFFF
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
