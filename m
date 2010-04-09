From: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: add a print message after loading nilfs2
Date: Fri, 9 Apr 2010 23:19:54 +0800
Message-ID: <20100409151954.GB4582@xhl>
References: <20100409151837.GA4582@xhl>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:date:from:to:subject
         :message-id:mail-followup-to:references:mime-version:content-type
         :content-disposition:in-reply-to:x-operating-system:user-agent;
        bh=orRU4fIg8Z+9m1teT6LUJx+t49KKmfRnpvwZ+TVHyEI=;
        b=IV0NS9dmo2haHfVpYEngAdIJ6h46bd7JIvm1Zfti9HEsVQ7+TEHB1l8fZsZxyMP19Y
         /dygVl5acYu2dmqW0SqOMMgHsrord12ZNShGIQdSMsQRQv9gmOtxzXdsBg9t2B3e91R6
         vVYp/U98ckJQ+ElJEfUi9kNqhQKC/ukGsMiZ0=
Content-Disposition: inline
In-Reply-To: <20100409151837.GA4582@xhl>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From 7045703b978d8396535c7ccce72ca5684f608ca9 Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Fri, 9 Apr 2010 23:09:53 +0800
Subject: [PATCH 2/2] nilfs2: add a print message after loading nilfs2

Printing a message after loading a file system is a practice. Add this to
provide a better user-friendly experience.

Signed-off-by: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 51fd922..51f3802 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1189,6 +1189,7 @@ static int __init init_nilfs_fs(void)
 	if (err)
 		goto free_cachep;
 
+	printk(KERN_INFO "NILFS version 2 loaded\n");
 	return 0;
 
 free_cachep:
-- 
1.6.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
