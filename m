From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: ensure to clear dirty state when
	deleting metadata file block
Date: Sun, 10 May 2009 18:12:15 +0900
Message-ID: <1241946735-14126-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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

This would fix the following failure during GC:

 nilfs_cpfile_delete_checkpoints: cannot delete block
 NILFS: GC failed during preparation: cannot delete checkpoints: err=-2

The problem was caused by a break in state consistency between page
cache and btree; the above block was removed from the btree but the
page buffering the block was remaining in the page cache in dirty
state.

This resolves the inconsistency by ensuring to clear dirty state of
the page buffering the deleted block.

Reported-by: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/mdt.c  |    2 +-
 fs/nilfs2/page.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index e1c6777..bb78745 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -300,7 +300,7 @@ int nilfs_mdt_delete_block(struct inode *inode, unsigned long block)
 	int err;
 
 	err = nilfs_bmap_delete(ii->i_bmap, block);
-	if (likely(!err)) {
+	if (!err || err == -ENOENT) {
 		nilfs_mdt_mark_dirty(inode);
 		nilfs_mdt_forget_block(inode, block);
 	}
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 1bfbba9..a2692bb 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -128,7 +128,8 @@ void nilfs_forget_buffer(struct buffer_head *bh)
 
 	lock_buffer(bh);
 	clear_buffer_nilfs_volatile(bh);
-	if (test_clear_buffer_dirty(bh) && nilfs_page_buffers_clean(page))
+	clear_buffer_dirty(bh);
+	if (nilfs_page_buffers_clean(page))
 		__nilfs_clear_page_dirty(page);
 
 	clear_buffer_uptodate(bh);
-- 
1.6.2
