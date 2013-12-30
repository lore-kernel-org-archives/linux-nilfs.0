From: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] fs/nilfs2: Integer overflow in nilfs_ioctl_wrap_copy()
Date: Mon, 30 Dec 2013 15:29:13 +0800
Message-ID: <1388388554-9513-1-git-send-email-fanwlexca@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=19z3rR7PY1uZxJR6l3UqulKFnErQvSY2J8WNeKuTNJ4=;
        b=O+DFTANhBzia2F93iCphx+2G7ys34fQmtxRqLJnR8gKv99lgTQDXCduCmL+pAnErRl
         dR9H9jv3h62oS9OYCzcoH7UqjZ9ZEfeHYTsxRp6SfageHH8X4Qw4zCdpKANt6wKKCYnI
         DdGWHVK8jX6nifbXNYn5ic0ojohTyEqxjyjugKEjFE8aNplxi3VCZvj5kHqsVJRm+bX/
         YcEV/GLfmtIWhbua6estilzEfLnhwEUpT/BR7sCxuMxOHStk4zHk6spwRfu4TiIBdxT0
         DTUmw6BVR8Xu5LByhTYID3E3D4zEqbnPG+dDwf7EWsf3j+8UTKsOLPKh2niMsyr1To+q
         1/PQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Check before entering into cycle.

The local variable 'pos' comes from userspace. If a large number was
passed, there would be an integer overflow in the following line:
        pos += n;

Signed-off-by: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index b44bdb2..a260a98 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -65,6 +65,8 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 	ret = 0;
 	total = 0;
 	pos = argv->v_index;
+	if (pos > ULONG_MAX - argv->v_nmembs)
+		return -EINVAL;
 	for (i = 0; i < argv->v_nmembs; i += n) {
 		n = (argv->v_nmembs - i < maxmembs) ?
 			argv->v_nmembs - i : maxmembs;
-- 
1.8.5.rc1.28.g7061504

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
