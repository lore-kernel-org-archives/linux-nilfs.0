From: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: add a print message after loading nilfs2
Date: Tue, 6 Apr 2010 01:35:34 +0800
Message-ID: <20100405173534.GB22644@xhl>
References: <20100405173402.GA22644@xhl>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:date:from:to:subject
         :message-id:mail-followup-to:references:mime-version:content-type
         :content-disposition:in-reply-to:x-operating-system:user-agent;
        bh=2MSHHW87GkpcF4YGTHUEtiHlAeQ/6Xn8XXLKb6wwHMM=;
        b=TXHyuA4ldycc/izL+aWxmhptoj4Yb2Ygil6fN2aogWBAw/+E/gzafn/qpVEK6EUU4O
         339h1loytePPhXnqIfqgai+kzueAyID9IIgKXwZQga2oYlDxMAI+Yux1KpQEE4J0jxRp
         BN2kIfb6ZErkCHJ7abpSLSIu83ZL60tKRIXN8=
Content-Disposition: inline
In-Reply-To: <20100405173402.GA22644@xhl>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From b4e426f77cd05bd6046c1fa67c51ee06368ea23e Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Tue, 6 Apr 2010 01:23:04 +0800
Subject: [PATCH] nilfs2: add a print message after loading nilfs2


Signed-off-by: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/super.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 2e767bc..9f91765 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1186,7 +1186,12 @@ static int __init init_nilfs_fs(void)
 		return err;
 
 	err = register_filesystem(&nilfs_fs_type);
-	return err;
+	if (err)
+		return err;
+
+	printk(KERN_INFO "nilfs2 file system loaded!\n");
+	return 0;
+
 }
 
 static void __exit exit_nilfs_fs(void)
-- 
1.6.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
