From: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Subject: [PATCH 4/7] Alpha sort AC_CHECK_FUNCS list in configure.ac
Date: Wed, 21 Dec 2011 15:34:06 -0600
Message-ID: <1324503249-17432-5-git-send-email-dan@archlinux.org>
References: <1324503249-17432-1-git-send-email-dan@archlinux.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=bVqINTJ2jiCxyyIGis9f5C6lTiQ7lfuz6IYR7wgxsWM=;
        b=TeRg8LIpicfPHssuqcIb2QEiILUhFlxnbNufpv0N7rxCqsBpIJEvOl2UIlnX5QeSA/
         3JDDLraeke8p2PNa96k3SqJothDDf7zFOOmEtu3QkuPbv5XncocyV41uoLrSqJH4+rdI
         RmMw5Y0t0PzZt0sksf61Q9+8K1PYzr4dkrMg0=
In-Reply-To: <1324503249-17432-1-git-send-email-dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

And add strtoull(), which is used in several places. This also changes a
` to a ' character in the libuuid description to fix syntax highlighting
in some editors.

Signed-off-by: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
---
 configure.ac |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index ccd8008..da671a7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -37,7 +37,7 @@ AC_ARG_ENABLE(libmount,
 # Checks for libraries.
 AC_CHECK_LIB([uuid], [uuid_generate],
 	[AC_DEFINE([HAVE_LIBUUID], 1,
-	  [Define to 1 if you have the `uuid' library (-luuid).])],
+	  [Define to 1 if you have the 'uuid' library (-luuid).])],
 	[AC_MSG_ERROR([UUID library not found])])
 
 LIB_POSIX_MQ=''
@@ -101,9 +101,9 @@ AC_FUNC_STRFTIME
 AC_FUNC_VPRINTF
 AC_CHECK_FUNC(posix_memalign,,
 	      [AC_MSG_ERROR([cannot find posix_memalign() function])])
-AC_CHECK_FUNCS([alarm atexit ftruncate getcwd gettimeofday localtime_r \
-		memmove memset munmap strchr strdup strerror strrchr strstr \
-		strtoul getgrgid getpwuid strcasecmp getmntent_r strtok_r])
+AC_CHECK_FUNCS([alarm atexit ftruncate getcwd getgrgid getmntent_r getpwuid \
+		gettimeofday localtime_r memmove memset munmap strcasecmp strchr \
+		strdup strerror strrchr strstr strtok_r strtoul strtoull])
 
 # Checks for system services
 AC_SYS_LARGEFILE
-- 
1.7.8

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
