From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: fix use-after-free bug in nilfs_mdt_destroy()
Date: Tue, 16 Aug 2022 02:51:14 +0900
Message-ID: <20220815175114.23576-1-konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=yFM5NAH4FbqVZAUN+RpSLe1Fb5MJe458XF5fgVWxzb8=;
        b=CK0iyepL58aRSd9LzU3quaQk58TnfOXRzthLNyTjGfWMiRTJsrmdiF/ja9RaaNW2c7
         +fHU/9iCI9PjCnXTg49kGl/pME6keQJQVdyeA1Q/TAR30FKQYG7X4gWMyXdlUKQE+T5x
         gi6wRafz2djcfvrN/EgRyKfGR06izb63WYF/zQa1pSgccwk9SttjFfIC7Y7uvne6ytQj
         BedEFLdHTBW+qMFCmXwtM53T6JqvB0nkw/iCOf5vgRRaZ6SgXdh63pIWmq/cBvj+7X6f
         jkKx7Qd02UV422TUXwxuJeFA4edIw4BqNEbUHPSGU5tfExwX8XRDDauCo7t5KsYuEPGU
         IeCA==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jiacheng Xu <stitch-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>, Mudong Liang <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

In alloc_inode(), inode_init_always() could return -ENOMEM if
security_inode_alloc() fails.  If this happens for nilfs2,
nilfs_free_inode() is called without initializing inode->i_private and
nilfs_free_inode() wrongly calls nilfs_mdt_destroy(), which frees
uninitialized inode->i_private and can trigger a crash.

Fix this bug by initializing inode->i_private in nilfs_alloc_inode().

Link: https://lkml.kernel.org/r/CAFcO6XOcf1Jj2SeGt=jJV59wmhESeSKpfR0omdFRq+J9nD1vfQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
Link: https://lkml.kernel.org/r/20211011030956.2459172-1-mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Reported-by: butt3rflyh4ck <butterflyhuangxx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: Hao Sun <sunhao.th-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: Jiacheng Xu <stitch-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>
Reported-by: Mudong Liang <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
---
 fs/nilfs2/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index ba108f915391..aca5614f1b44 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -159,6 +159,7 @@ struct inode *nilfs_alloc_inode(struct super_block *sb)
 	ii->i_cno = 0;
 	ii->i_assoc_inode = NULL;
 	ii->i_bmap = &ii->i_bmap_data;
+	ii->vfs_inode.i_private = NULL;
 	return &ii->vfs_inode;
 }
 
-- 
2.34.1

