From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/1] nilfs2: remove inode->i_version initialization
Date: Tue,  7 Nov 2017 23:21:26 +0900
Message-ID: <1510064486-1728-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1510064486-1728-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=ioOsUXGEI5wf0Mu/mgu1MT/Cz5LEFPRbbcolYZz/NEQ=;
        b=fJC/agAV/UoU5B1LbKeqjz6h1yUpTkVlb35d8BDyI7+9FsI9N8ohRKIhS2sUGojtl9
         B1wm6PBCOARbKgw9HCLt9t7WjDGpyapT8XBLpR5rbkZ4PZ82yofpydcSka6aCxJLU4id
         3AqGQHifMwPVLUr/CJ7KdGSd1xCNSAL8Gh+x9U196gBSDfW38PN0BQjoKajLm2dyskoI
         DhuVxbuDtEVKH5oP5pUJHCDOWVlaDkJDBGvueZ01fn/6xIZ1zZ3O7hLK/qvsTG+DLU8R
         MzTLK4PMjhVWJScMUYb8ftXeZn+0UEAhjdYMStWc+ZtSiWVAh7VAAxFAZyU0ihplCLY4
         9vKQ==
In-Reply-To: <1510064486-1728-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

It's never used in nilfs2.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 4fc018d..3ce20cd 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -160,7 +160,6 @@ struct inode *nilfs_alloc_inode(struct super_block *sb)
 	ii->i_bh = NULL;
 	ii->i_state = 0;
 	ii->i_cno = 0;
-	ii->vfs_inode.i_version = 1;
 	nilfs_mapping_init(&ii->i_btnode_cache, &ii->vfs_inode);
 	return &ii->vfs_inode;
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
