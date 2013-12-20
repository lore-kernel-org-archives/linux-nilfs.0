From: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] fs/nilfs2: Integer overflow in nilfs_ioctl_wrap_copy()
Date: Fri, 20 Dec 2013 15:46:08 +0800
Message-ID: <1387525568-30025-1-git-send-email-fanwlexca@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=59GCfvyIZ0QlTIotk8ykkjoMGHgPGDIvSukfBGpePaM=;
        b=jL9N6w2OETGmxgvwvBZAvJdvV5ypxgopjXsTykQikplZFvdlI3mg5mb+DSbCKMCRIa
         RlRDs3CxHrJAH9TkownDd85oFlOmCySBlMvO+AGU5hRHwfW4l2w4VjTNx9oYU610ZYwh
         pRMu3s/I1AbZ4zOnyjBxl5k9yLESi6KQWtDCsf2C0ghpUiENQ0pc4iZ44FaJ89BwSpc2
         DwHwBdovQHBRZRzf5Bhj1lnTx7XWe70iADGdN1tTyVAXFG3EfNa4nxOeXUbfAz315L5c
         AnP99eafuwGgZm0hDosQWkHBrFOusd4qKZq7vnmVtek47vgVS7vTO/vTIVHgL/gBX8Oi
         6Yaw==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The local variable 'pos' comes from userspace. If a large number was
passed, there would be an integer overflow in the following line:
	pos += n;

Signed-off-by: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/ioctl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index b44bdb2..b2bac9a 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -90,8 +90,13 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 		total += nr;
 		if ((size_t)nr < n)
 			break;
-		if (pos == ppos)
+		if (pos == ppos) {
+			if (pos > ULONG_MAX - n) {
+				ret = -EINVAL;
+				break;
+			}
 			pos += n;
+		}
 	}
 	argv->v_nmembs = total;
 
-- 
1.8.5.rc1.28.g7061504

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
