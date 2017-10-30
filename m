From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH] nilfs2: remove inode->i_version initialization
Date: Mon, 30 Oct 2017 11:17:02 -0400
Message-ID: <20171030151702.8368-1-jlayton@kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: konishi.ryusuke@lab.ntt.co.jp
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

It's never used in nilfs2.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/nilfs2/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 4fc018dfcfae..3ce20cd44a20 100644
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
2.13.6

