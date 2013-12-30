From: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] fs/nilfs2: Integer overflow in nilfs_ioctl_wrap_copy()
Date: Mon, 30 Dec 2013 21:54:41 +0800
Message-ID: <1388411681-16584-1-git-send-email-fanwlexca@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=No9amvDhVs3d7CB0JWVuvbbq8mhxtxHVXFyBNSux0xk=;
        b=pEBYO5JNBwnNqDkGApaADoZiOt9Sw4oVaPI8aBgSQ50mW294DAn/+1Fc/slDjBTd9b
         X6pZtQmsdN85jp4tO0imqyg/Ji+aRALhg48Q8XH1CSjunPNk9PCVXgq+485lXdi2hTFl
         U9m3eODyBkh7ggqXarAYvOyU5Fg1fdFsrPAyBl66s43cKyuccNHeTujHM9eZ1wqlA/ak
         Prti49ttTFvcRWcspzucTxXXF+OsTc+gLcDrvRIb7yIlHX+96U/ZaHHvHnI7jW/lA0NG
         Nu83VZAAuQIU12xaw9j4gme/tbl5FSHiyDdWC/m9wp8NOiuZCRDwBlAto3UlQwwlLATk
         SXsg==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Check before entering into cycle and on every iteration.

The local variable 'pos' comes from userspace. If a large number was
passed, there would be an integer overflow in the following line:
        pos += n;

Signed-off-by: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/ioctl.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index b44bdb2..5f4be69 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -57,6 +57,9 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 	if (argv->v_size > PAGE_SIZE)
 		return -EINVAL;
 
+	if (argv->v_index > ULONG_MAX - argv->v_nmembs)
+		return -EINVAL;
+
 	buf = (void *)__get_free_pages(GFP_NOFS, 0);
 	if (unlikely(!buf))
 		return -ENOMEM;
@@ -90,8 +93,13 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
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
