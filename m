From: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] fs/nilfs2: Integer overflow in nilfs_ioctl_wrap_copy()
Date: Mon, 30 Dec 2013 15:29:14 +0800
Message-ID: <1388388554-9513-2-git-send-email-fanwlexca@gmail.com>
References: <1388388554-9513-1-git-send-email-fanwlexca@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bNLwfdKms7af2fe1fwITu6gEHJi2S+1dyy4nGlWszss=;
        b=JAwfR78Ve1Gy0CzhFT2jzZ2CHWeVD6yGF2zH4piTs22bMXKfqWp61wVyMbcVCgw80U
         l3Um05zjheJbyTNAYssMazmnBgmqBRftERjx/FQp1NO4E37qwpje8UUdn5plR+Ii8bsp
         bEmBTE/YfSZJXZY0MSU0d3VNASPqQu8Y42yLKhK7aRVMcUJeVEIG3RvOg2nCRCi5WoXj
         /PbJbSOoB7WJ2mixozl4GcfegzDozVNS3eZsajquV4vPZAGlZoS/PoMlHS9HL9V+Kbbe
         VGJoLTscIlLh7OhdrBQTvTpxoyqj6DzOJ9ofoOWtyoamUtDvTa2q/HOqUFsUqLpWLtXN
         4Brw==
In-Reply-To: <1388388554-9513-1-git-send-email-fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Check on every iteration.

The local variable 'pos' comes from userspace. If a large number was
passed, there would be an integer overflow in the following line:
        pos += n;

Signed-off-by: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/ioctl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index a260a98..1db4319 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -92,8 +92,13 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
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
