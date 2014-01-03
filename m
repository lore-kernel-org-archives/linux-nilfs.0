From: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] fs/nilfs2: Integer overflow in nilfs_ioctl_wrap_copy()
Date: Fri,  3 Jan 2014 14:10:54 +0800
Message-ID: <1388729454-30256-1-git-send-email-fanwlexca@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=kJO4QzoA/1FPaVw2rxc1EVCNGqqnmMbn8VabLbv+Bg0=;
        b=i1nwZD57kmWJ6RJmkROOSQ/k3OR7Akde3QKd9sjRxEN5GYXBmX/k58LZT5Kygxc2XC
         x/xGRFXRyFtwQAwXFSWIx3p19aFv5r3mxFdjW4q08Vz5Ugevj6Sjx5a+cI0U6HMpHnsR
         MvSfqddwsiwfBHICQ3BHbd0+eGMtrR14xVSBjYIHfDTNr4nku2lSjQlnuIUij48sKgR0
         xO2Wy8rAjahqd9a8bh/7OZx1EWlt8r4mc7kOkQ2JhthuSbJsx/b0WfWlqlavdOvzj+vX
         S6LGmyFs0zS18Pzf3VlUcR+erAUAQjErqBnN1Ho+30fNkQsqRLbru2hO1si6WHRypM83
         e4Ng==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

v1->v2
*Check on every iteration is removed because the check before cycle is enough.

Check before entering into cycle.

The local variable 'pos' comes from userspace. If a large number was
passed, there would be an integer overflow in the following line:
        pos += n;

Signed-off-by: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index b44bdb2..231c945 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -57,6 +57,9 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 	if (argv->v_size > PAGE_SIZE)
 		return -EINVAL;
 
+	if (argv->v_index > (~(__u64)0 - argv->v_nmembs))
+		return -EINVAL;
+
 	buf = (void *)__get_free_pages(GFP_NOFS, 0);
 	if (unlikely(!buf))
 		return -ENOMEM;
-- 
1.8.5.rc1.28.g7061504

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
