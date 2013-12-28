From: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] fs/nilfs2: Integer overflow in nilfs_ioctl_wrap_copy()
Date: Sat, 28 Dec 2013 10:28:16 +0800
Message-ID: <1388197696-4648-1-git-send-email-fanwlexca@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=SvIPl4Q4TXDGLgTA2C8PhkXnYASS1/zU9j/JohZHonI=;
        b=n/FRuPC1zquRh6uZ68ahwg2l4AiuOwkk8RL2uz7ATm+0jTb3fZ04tfarbuH7GzjtG5
         lWuWQlFkpO1QCmGRgE2QF8X8Z71Qgk9ZfZfzfuTJdV09uRiL7XtlNwSeSkeU4NsMWOJW
         Z96j7xLRFgh/iKqzdSv1LpVyS98eYSyaj4PsAN4rlMDMFT5D90gt4SCZBGy3JQHRvo6V
         IS8brGXMmFxiCIsYrhVrjKNMui/GRWybuDKD21XbqCz5gJY/djJv7dSeuTGvq9CmUfAX
         B4IZXDHcm4MabsiurKmMxAVqxTNgPzfzwYEoZuJwW38Vj6Bxwat5xgFDcIPf+tT9ZTZi
         zfXA==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

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
