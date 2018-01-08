From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] MAINTAINERS, nilfs2: change project home URLs
Date: Mon,  8 Jan 2018 21:55:41 +0900
Message-ID: <1515416141-5614-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=gIBPccOTdL92J34ACzcKGFfrdo3uuH5fkp60gCrzSKs=;
        b=T4hEcYpip//GFhbS2Brb27rsuKqLMfUXOOKMll/C2sFJrP8rKzxVZ4ri4u3rvFdEem
         C6F+Z0psoaq3fFo+cVgQNJ9OmPWUG/4LfuO82sUnIPhMiQAadwSiaZtvAH7LEbLMBZcv
         F9Ff2vYh6aOflDD12Op1TqHKetv9SokHjealYzdQr44Hp/7r3vXbVGEIBl9vZG8nsWKl
         D2ufFxuIgbAarvzFMR1SXXMNYfOIZJsmSCGDGrwBAlpCxdECFHqfIIyrCdNXc90bM5+B
         4Nawbkpta1Q+KkQLzz7PQkTZGpSECGmj0EZbrGLhutf8UerTWf4TBrE9U/qaM2PO/QTO
         9dPw==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

The domain of NILFS project home was changed to "nilfs.sourceforge.io"
to enable https access (the previous domain "nilfs.sourceforge.net" is
redirected to the new one).  Modify URLs of the project home to
reflect this change and to replace their protocol from http to https.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 Documentation/filesystems/nilfs2.txt | 4 ++--
 MAINTAINERS                          | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/nilfs2.txt b/Documentation/filesystems/nilfs2.txt
index c0727dc..f2f3f85 100644
--- a/Documentation/filesystems/nilfs2.txt
+++ b/Documentation/filesystems/nilfs2.txt
@@ -25,8 +25,8 @@ available from the following download page.  At least "mkfs.nilfs2",
 cleaner or garbage collector) are required.  Details on the tools are
 described in the man pages included in the package.
 
-Project web page:    http://nilfs.sourceforge.net/
-Download page:       http://nilfs.sourceforge.net/en/download.html
+Project web page:    https://nilfs.sourceforge.io/
+Download page:       https://nilfs.sourceforge.io/en/download.html
 List info:           http://vger.kernel.org/vger-lists.html#linux-nilfs
 
 Caveats
diff --git a/MAINTAINERS b/MAINTAINERS
index 95c3fa1..9741ce5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9638,8 +9638,8 @@ F:	include/uapi/linux/sunrpc/
 NILFS2 FILESYSTEM
 M:	Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
 L:	linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
-W:	http://nilfs.sourceforge.net/
-W:	http://nilfs.osdn.jp/
+W:	https://nilfs.sourceforge.io/
+W:	https://nilfs.osdn.jp/
 T:	git git://github.com/konis/nilfs2.git
 S:	Supported
 F:	Documentation/filesystems/nilfs2.txt
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
