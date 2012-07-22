From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/2] nilfs-utils: integrate skeleton of fsck.nilfs2 utility into nilfs-utils package
Date: Sun, 22 Jul 2012 19:13:17 +0400
Message-ID: <83A3B84C-2558-4C14-AF65-95E3B46F9F74@dubeyko.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:To:Message-Id:Date:Subject:Content-Transfer-Encoding:Content-Type:From; bh=3Pr6WC6qHaSYVpH6fPJGj7WHue+KXQgII1EFjEWZeZY=;
	b=gDkUGOZ0bULY87ye+5foiXGr/cVo07tewr4/PbBiw+XhSHVBkqCF/ChmDIpyIMPDw+nZtw2vAH4PJd96bzq5jFTG+sN3wUTIczZDKugSxZuDRODAK/WSANE4xh778kE2;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

This patch integrates skeleton of fsck.nilfs2 utility into nilfs-utils package.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/2] nilfs-utils: integrate skeleton of fsck.nilfs2 utility into nilfs-utils package

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

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
