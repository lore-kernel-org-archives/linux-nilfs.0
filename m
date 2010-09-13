From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 14/23] nilfs2: do not allocate nilfs_mdt_info structure to gc-inodes
Date: Tue, 14 Sep 2010 00:37:15 +0900
Message-ID: <1284392244-27100-15-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

GC-inode now doesn't need the nilfs_mdt_info structure and there is no
reason that it is a sort of metadata files.

This stops the allocation and makes them not dependent on metadata
file routines.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/gcinode.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 34f8f84..33ad25d 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -168,7 +168,7 @@ int nilfs_gccache_wait_and_mark_dirty(struct buffer_head *bh)
 		}
 		nilfs_btnode_mark_dirty(bh);
 	} else {
-		nilfs_mdt_mark_buffer_dirty(bh);
+		nilfs_mark_buffer_dirty(bh);
 	}
 	return 0;
 }
@@ -177,24 +177,24 @@ int nilfs_init_gcinode(struct inode *inode)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
-	int ret;
 
-	ret = nilfs_mdt_init(inode, nilfs, GFP_NOFS, 0);
-	if (!ret) {
-		inode->i_mapping->a_ops = &def_gcinode_aops;
+	inode->i_mode = S_IFREG;
+	mapping_set_gfp_mask(inode->i_mapping, GFP_NOFS);
+	inode->i_mapping->a_ops = &def_gcinode_aops;
+	inode->i_mapping->backing_dev_info = inode->i_sb->s_bdi;
 
-		ii->i_flags = 0;
-		nilfs_bmap_init_gc(ii->i_bmap);
+	ii->i_flags = 0;
+	nilfs_bmap_init_gc(ii->i_bmap);
 
-		/*
-		 * Add the inode to GC inode list. Garbage Collection
-		 * is serialized and no two processes manipulate the
-		 * list simultaneously.
-		 */
-		igrab(inode);
-		list_add(&NILFS_I(inode)->i_dirty, &nilfs->ns_gc_inodes);
-	}
-	return ret;
+	/*
+	 * Add the inode to GC inode list. Garbage Collection
+	 * is serialized and no two processes manipulate the
+	 * list simultaneously.
+	 */
+	igrab(inode);
+	list_add(&NILFS_I(inode)->i_dirty, &nilfs->ns_gc_inodes);
+
+	return 0;
 }
 
 /**
-- 
1.6.6.2

