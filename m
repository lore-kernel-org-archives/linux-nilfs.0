From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 03/23] nilfs2: stop marking metadata inode
	dirty within btree operations
Date: Sun, 15 Nov 2009 21:46:41 +0900
Message-ID: <1258289221-3827-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1258289221-3827-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1258289221-3827-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Since metadata file routines mark the inode dirty after they
successfully changed bmap objects, nilfs_mdt_mark_dirty() calls in
nilfs_bmap_add_blocks() and nilfs_bmap_sub_blocks() are redundant.

This removes these overlapping calls from the bmap routines.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index 08834df..afc060a 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -402,18 +402,14 @@ int nilfs_bmap_test_and_clear_dirty(struct nilfs_bmap *bmap)
 void nilfs_bmap_add_blocks(const struct nilfs_bmap *bmap, int n)
 {
 	inode_add_bytes(bmap->b_inode, (1 << bmap->b_inode->i_blkbits) * n);
-	if (NILFS_MDT(bmap->b_inode))
-		nilfs_mdt_mark_dirty(bmap->b_inode);
-	else
+	if (!NILFS_MDT(bmap->b_inode))
 		mark_inode_dirty(bmap->b_inode);
 }
 
 void nilfs_bmap_sub_blocks(const struct nilfs_bmap *bmap, int n)
 {
 	inode_sub_bytes(bmap->b_inode, (1 << bmap->b_inode->i_blkbits) * n);
-	if (NILFS_MDT(bmap->b_inode))
-		nilfs_mdt_mark_dirty(bmap->b_inode);
-	else
+	if (!NILFS_MDT(bmap->b_inode))
 		mark_inode_dirty(bmap->b_inode);
 }
 
-- 
1.6.3.4
