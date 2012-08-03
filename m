From: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Subject: [PATCH v2 1/7] nilfs-utils: fsck: integrate skeleton of fsck.nilfs2
 utility into nilfs-utils package
Date: Fri, 03 Aug 2012 07:50:02 -0600
Message-ID: <fb1c22aa62a5a4db4cf02d2f89b128ab@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:Content-Type:MIME-Version; bh=1HPwelsBIE99JrR92txuhCwqUI2SfbfQCxHPwhXFiE0=;
	b=d1yEBGMFiykncGwU1M1m6DwMqIufS+YiI7pgfd22gGSB5PEy1ki9eCwTsS3ny9b+nEx0iK+P33bGDziUAujAxQ+F8s/gmxMu3vfG9KcxvbIgkBOlzjBX7jckVhYYYzzo;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,

This patch integrates skeleton of fsck.nilfs2 utility into nilfs-utils 
package.

With the best regards,
Vyacheslav Dubeyko.
--
 From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 1/7] nilfs-utils: fsck: integrate skeleton of 
fsck.nilfs2 utility into nilfs-utils package

This patch integrates skeleton of fsck.nilfs2 utility into nilfs-utils 
package.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
diff --git a/configure.ac b/configure.ac
index c2bcf4c..0d1a2d1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -167,5 +167,6 @@ AC_CONFIG_FILES([Makefile
                  sbin/mount/Makefile
                  sbin/nilfs-tune/Makefile
                  sbin/nilfs-clean/Makefile
-                sbin/nilfs-resize/Makefile])
+                sbin/nilfs-resize/Makefile
+                sbin/fsck/Makefile])
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
