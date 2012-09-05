From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 01/11] nilfs-utils: fsck: integrate skeleton of fsck.nilfs2 utility into nilfs-utils package
Date: Wed, 5 Sep 2012 23:13:34 +0400
Message-ID: <8A82F0E8-F4C7-4193-A4FF-AB7DFD172120@dubeyko.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:To:Message-Id:Date:Subject:Content-Transfer-Encoding:Content-Type:From; bh=wbnPTPlR19+Nnm0OBhrWcYfE2KypbajQdC7GHt2Shvc=;
	b=GrkfJP+BdL6p+7Oi4UJpFLZV0rbUUO3XsFO2+I7UiMQR7IkaPHLadYl2Yn4BC25MQzY+zCUcYqS6zd388ALrQapiM8fci5QptwxmN+3uyy1X/3fmTVcIZ8v0hq68KdFr;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch integrates skeleton of fsck.nilfs2 utility into nilfs-utils package.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 01/11] nilfs-utils: fsck: integrate skeleton of fsck.nilfs2 utility into nilfs-utils package

This patch integrates skeleton of fsck.nilfs2 utility into nilfs-utils package.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 configure.ac     |    3 ++-
 sbin/Makefile.am |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index c2bcf4c..0d1a2d1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -167,5 +167,6 @@ AC_CONFIG_FILES([Makefile
 		 sbin/mount/Makefile
 		 sbin/nilfs-tune/Makefile
 		 sbin/nilfs-clean/Makefile
-		 sbin/nilfs-resize/Makefile])
+		 sbin/nilfs-resize/Makefile
+		 sbin/fsck/Makefile])
 AC_OUTPUT
diff --git a/sbin/Makefile.am b/sbin/Makefile.am
index 302e9a7..8a0d306 100644
--- a/sbin/Makefile.am
+++ b/sbin/Makefile.am
@@ -1,3 +1,3 @@
 ## Makefile.am
 
-SUBDIRS = cleanerd mkfs mount nilfs-tune nilfs-clean nilfs-resize
+SUBDIRS = cleanerd mkfs mount nilfs-tune nilfs-clean nilfs-resize fsck
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
