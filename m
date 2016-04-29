From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 01/11] nilfs2: fix white space issue in nilfs_mount()
Date: Fri, 29 Apr 2016 22:15:37 +0900
Message-ID: <1461935747-10380-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1461935747-10380-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=Z+KJFLolXRxn8Ddn8iq6BeEVbfvMDtR/za6SDOM5V/Q=;
        b=xD1cmttxBmJodi1S8cI+tIkpi59xqYqQpNrF4nwigEqlG8SifcwHU+DjkVx8Ogkkm0
         BBJTM3O1U/4cR//4beCPJ00eZtFf4yVppoiEpFxz/z/qUjTQAyP/MSSUlP3BtWSzay1e
         3eFv4PQDfovEPksRHq9DqMAPNIKPf4eUCZBqR2Bb7n9IxNzBGZVLijRx/q6GnNIOQ7/d
         y3iJhVi9SojbYI7TdSO3+vhuhQDe5sBm2wsjtq1ue+mWPNJW/el3mZMglaPMqeBl/VcH
         uZDoNjRUCJ6uRwhSGFZOj65CzouSIi7FJU5RrAsH9etbW5ssvSK7NB1+MPlcFrIKCkh1
         yDOA==
In-Reply-To: <1461935747-10380-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Fix the following checkpatch.pl error and warnings:

 ERROR: code indent should use tabs where possible
 #1317: FILE: super.c:1317:
 + ^I^Is_new = true;$

 WARNING: please, no space before tabs
 #1317: FILE: super.c:1317:
 + ^I^Is_new = true;$

 WARNING: please, no spaces at the start of a line
 #1317: FILE: super.c:1317:
 + ^I^Is_new = true;$

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 7f5d3d9..e05d184 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1316,7 +1316,7 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 	}
 
 	if (!s->s_root) {
- 		s_new = true;
+		s_new = true;
 
 		/* New superblock instance created */
 		s->s_mode = mode;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
