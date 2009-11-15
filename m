From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 04/23] nilfs2: move out mark_inode_dirty calls
	from bmap routines
Date: Sun, 15 Nov 2009 21:46:42 +0900
Message-ID: <1258289221-3827-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

Previously, nilfs_bmap_add_blocks() and nilfs_bmap_sub_blocks() called
mark_inode_dirty() after they changed the number of data blocks.

This moves these calls outside bmap outermost functions like
nilfs_bmap_insert() or nilfs_bmap_truncate().

This will mitigate overhead for truncate or delete operation since
they repeatedly remove set of blocks.  Nearly 10 percent improvement
was observed for removal of a large file:

 # dd if=/dev/zero of=/test/aaa bs=1M count=512
 # time rm /test/aaa

  real  2.968s -> 2.705s

Further optimization may be possible by eliminating these
mark_inode_dirty() uses though I avoid mixing separate changes here.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.c  |    4 ----
 fs/nilfs2/inode.c |    3 +++
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index afc060a..f4a14ea 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -402,15 +402,11 @@ int nilfs_bmap_test_and_clear_dirty(struct nilfs_bmap *bmap)
 void nilfs_bmap_add_blocks(const struct nilfs_bmap *bmap, int n)
 {
 	inode_add_bytes(bmap->b_inode, (1 << bmap->b_inode->i_blkbits) * n);
-	if (!NILFS_MDT(bmap->b_inode))
-		mark_inode_dirty(bmap->b_inode);
 }
 
 void nilfs_bmap_sub_blocks(const struct nilfs_bmap *bmap, int n)
 {
 	inode_sub_bytes(bmap->b_inode, (1 << bmap->b_inode->i_blkbits) * n);
-	if (!NILFS_MDT(bmap->b_inode))
-		mark_inode_dirty(bmap->b_inode);
 }
 
 __u64 nilfs_bmap_data_get_key(const struct nilfs_bmap *bmap,
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 412b25a..a16c179 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -97,6 +97,7 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
 			nilfs_transaction_abort(inode->i_sb);
 			goto out;
 		}
+		mark_inode_dirty(inode);
 		nilfs_transaction_commit(inode->i_sb); /* never fails */
 		/* Error handling should be detailed */
 		set_buffer_new(bh_result);
@@ -598,6 +599,7 @@ void nilfs_truncate(struct inode *inode)
 	if (IS_SYNC(inode))
 		nilfs_set_transaction_flag(NILFS_TI_SYNC);
 
+	mark_inode_dirty(inode);
 	nilfs_set_file_dirty(NILFS_SB(sb), inode, 0);
 	nilfs_transaction_commit(sb);
 	/* May construct a logical segment and may fail in sync mode.
@@ -622,6 +624,7 @@ void nilfs_delete_inode(struct inode *inode)
 		truncate_inode_pages(&inode->i_data, 0);
 
 	nilfs_truncate_bmap(ii, 0);
+	mark_inode_dirty(inode);
 	nilfs_free_inode(inode);
 	/* nilfs_free_inode() marks inode buffer dirty */
 	if (IS_SYNC(inode))
-- 
1.6.3.4
