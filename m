From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 05/11] MAINTAINERS: add web link for nilfs project
Date: Fri, 29 Apr 2016 22:15:41 +0900
Message-ID: <1461935747-10380-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1461935747-10380-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=MUPZj7uORXn2th6Poo0KSyUxANqv7GgOhIb60NCmXyc=;
        b=s1mXBySB/ZCpn4nGRZE5EKtFSkrKqSx2ejxlsaW9F4WKO9dyorgSuj+Rioizw+gRsl
         F3VbfDr5iz+UPKOUca16i+zxtRqnmOj178iapI15AoVJSyorJCnBMjpx+0lx9pQdX1+d
         V6yNkNga1MO4HOhWUM9rG7zEa5oorWB5dMbSoHI2vbBJwZ+6L/n3AcrpWGmRNWLIv2Bs
         5iHFlfCjVYdEQVbmPkEayAWRzVrfRjiDk07AxmFJGfpft6wcgUYt/sbudtk7Wnj/ROt9
         wwbaYzxfnmDGAgL3igHtS7fg6bvzOszWJfzh4MkKH8drMZqrScbgdMGH5pFIaYynKWqR
         aAhg==
In-Reply-To: <1461935747-10380-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Add nilfs.osdn.jp as the second web site of nilfs project.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1d5b4be..1c4f5fa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7794,6 +7794,7 @@ NILFS2 FILESYSTEM
 M:	Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
 L:	linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 W:	http://nilfs.sourceforge.net/
+W:	http://nilfs.osdn.jp/
 T:	git git://github.com/konis/nilfs2.git
 S:	Supported
 F:	Documentation/filesystems/nilfs2.txt
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
