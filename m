From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: mark buffer heads as delayed until the data is written to disk
Date: Sun, 26 Dec 2010 21:56:13 +0900
Message-ID: <1293368174-1197-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1293368174-1197-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293368174-1197-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Nilfs does not allocate new blocks on disk until they are actually
written to.  To implement fiemap, we need to deal with such blocks.

To allow successive fiemap patch to distinguish mapped but unallocated
regions, this marks buffer heads of those new blocks as delayed and
clears the flag after the blocks are written to disk.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c   |    1 +
 fs/nilfs2/segment.c |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index bddb4f4..7a18093 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -104,6 +104,7 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
 		nilfs_transaction_commit(inode->i_sb); /* never fails */
 		/* Error handling should be detailed */
 		set_buffer_new(bh_result);
+		set_buffer_delay(bh_result);
 		map_bh(bh_result, inode->i_sb, 0); /* dbn must be changed
 						      to proper value */
 	} else if (ret == -ENOENT) {
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index d3d2f43..efc7d0a 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1763,6 +1763,7 @@ static void nilfs_clear_copied_buffers(struct list_head *list, int err)
 				if (!err) {
 					set_buffer_uptodate(bh);
 					clear_buffer_dirty(bh);
+					clear_buffer_delay(bh);
 					clear_buffer_nilfs_volatile(bh);
 				}
 				brelse(bh); /* for b_assoc_buffers */
@@ -1889,6 +1890,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 				    b_assoc_buffers) {
 			set_buffer_uptodate(bh);
 			clear_buffer_dirty(bh);
+			clear_buffer_delay(bh);
 			clear_buffer_nilfs_volatile(bh);
 			clear_buffer_nilfs_redirected(bh);
 			if (bh == segbuf->sb_super_root) {
-- 
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
