From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/5] nilfs2: use empty_aops for gc-inodes
Date: Thu,  5 May 2011 13:13:49 +0900
Message-ID: <1304568833-31021-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1304568833-31021-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1304568833-31021-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Applies empty_aops for address space operations of gc-inodes.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/gcinode.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 1c2a3e2..6f0d60a 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -48,9 +48,6 @@
 #include "dat.h"
 #include "ifile.h"
 
-static const struct address_space_operations def_gcinode_aops = {
-};
-
 /*
  * nilfs_gccache_submit_read_data() - add data buffer and submit read request
  * @inode - gc inode
@@ -178,7 +175,7 @@ int nilfs_init_gcinode(struct inode *inode)
 
 	inode->i_mode = S_IFREG;
 	mapping_set_gfp_mask(inode->i_mapping, GFP_NOFS);
-	inode->i_mapping->a_ops = &def_gcinode_aops;
+	inode->i_mapping->a_ops = &empty_aops;
 	inode->i_mapping->backing_dev_info = inode->i_sb->s_bdi;
 
 	ii->i_flags = 0;
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
