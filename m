From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 14/23] nilfs2: separate function for creating
	new btree node block
Date: Sun, 15 Nov 2009 21:46:52 +0900
Message-ID: <1258289221-3827-15-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

Adds a separate routine for creating a btree node block.  This is a
preparation to reduce the depth of function calls during submitting
btree node buffer.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btnode.c |   26 ++++++++++++++++++++++++++
 fs/nilfs2/btnode.h |    2 ++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 84c2538..fc3e4bd 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -68,6 +68,32 @@ void nilfs_btnode_cache_clear(struct address_space *btnc)
 	truncate_inode_pages(btnc, 0);
 }
 
+struct buffer_head *
+nilfs_btnode_create_block(struct address_space *btnc, __u64 blocknr)
+{
+	struct inode *inode = NILFS_BTNC_I(btnc);
+	struct buffer_head *bh;
+
+	bh = nilfs_grab_buffer(inode, btnc, blocknr, 1 << BH_NILFS_Node);
+	if (unlikely(!bh))
+		return NULL;
+
+	if (unlikely(buffer_mapped(bh) || buffer_uptodate(bh) ||
+		     buffer_dirty(bh))) {
+		brelse(bh);
+		BUG();
+	}
+	memset(bh->b_data, 0, 1 << inode->i_blkbits);
+	bh->b_bdev = NILFS_I_NILFS(inode)->ns_bdev;
+	bh->b_blocknr = blocknr;
+	set_buffer_mapped(bh);
+	set_buffer_uptodate(bh);
+
+	unlock_page(bh->b_page);
+	page_cache_release(bh->b_page);
+	return bh;
+}
+
 int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 			      sector_t pblocknr, struct buffer_head **pbh,
 			      int newblk)
diff --git a/fs/nilfs2/btnode.h b/fs/nilfs2/btnode.h
index 3e22751..c53644c 100644
--- a/fs/nilfs2/btnode.h
+++ b/fs/nilfs2/btnode.h
@@ -40,6 +40,8 @@ struct nilfs_btnode_chkey_ctxt {
 void nilfs_btnode_cache_init_once(struct address_space *);
 void nilfs_btnode_cache_init(struct address_space *, struct backing_dev_info *);
 void nilfs_btnode_cache_clear(struct address_space *);
+struct buffer_head *nilfs_btnode_create_block(struct address_space *btnc,
+					      __u64 blocknr);
 int nilfs_btnode_submit_block(struct address_space *, __u64, sector_t,
 			      struct buffer_head **, int);
 int nilfs_btnode_get(struct address_space *, __u64, sector_t,
-- 
1.6.3.4
