From: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] fix bulid against newer glibc
Date: Sat, 13 Feb 2010 12:34:30 -0600
Message-ID: <4B76F0B6.5060800@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Changes in recent glibc were breaking the build on Rawhide;
we need to explicitly include sys/stat.h to get S_ISREG etc.

See also https://bugzilla.redhat.com/show_bug.cgi?id=564788

Signed-off-by: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

Index: nilfs-utils-2.0.15/sbin/mkfs/mkfs.c
===================================================================
--- nilfs-utils-2.0.15.orig/sbin/mkfs/mkfs.c
+++ nilfs-utils-2.0.15/sbin/mkfs/mkfs.c
@@ -42,6 +42,7 @@
 #include <strings.h>
 #include <stdarg.h>
 #include <sys/ioctl.h>
+#include <sys/stat.h>
 #include <sys/wait.h>
 #include <uuid/uuid.h>
 #include <string.h>


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
