From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 16/23] nilfs2: remove newblk argument from
	nilfs_btnode_submit_block
Date: Sun, 15 Nov 2009 21:46:54 +0900
Message-ID: <1258289221-3827-17-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This removes the obsolete argument from nilfs_btnode_submit_block().
This will complete separating a create function of btree node.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btnode.c  |   20 +++-----------------
 fs/nilfs2/btnode.h  |    4 ++--
 fs/nilfs2/gcinode.c |    2 +-
 3 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 7086a2a..59658f0 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -95,8 +95,7 @@ nilfs_btnode_create_block(struct address_space *btnc, __u64 blocknr)
 }
 
 int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
-			      sector_t pblocknr, struct buffer_head **pbh,
-			      int newblk)
+			      sector_t pblocknr, struct buffer_head **pbh)
 {
 	struct buffer_head *bh;
 	struct inode *inode = NILFS_BTNC_I(btnc);
@@ -107,19 +106,6 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 		return -ENOMEM;
 
 	err = -EEXIST; /* internal code */
-	if (newblk) {
-		if (unlikely(buffer_mapped(bh) || buffer_uptodate(bh) ||
-			     buffer_dirty(bh))) {
-			brelse(bh);
-			BUG();
-		}
-		memset(bh->b_data, 0, 1 << inode->i_blkbits);
-		bh->b_bdev = NILFS_I_NILFS(inode)->ns_bdev;
-		bh->b_blocknr = blocknr;
-		set_buffer_mapped(bh);
-		set_buffer_uptodate(bh);
-		goto found;
-	}
 
 	if (buffer_uptodate(bh) || buffer_dirty(bh))
 		goto found;
@@ -162,12 +148,12 @@ out_locked:
 }
 
 int nilfs_btnode_get(struct address_space *btnc, __u64 blocknr,
-		     sector_t pblocknr, struct buffer_head **pbh, int newblk)
+		     sector_t pblocknr, struct buffer_head **pbh)
 {
 	struct buffer_head *bh;
 	int err;
 
-	err = nilfs_btnode_submit_block(btnc, blocknr, pblocknr, pbh, newblk);
+	err = nilfs_btnode_submit_block(btnc, blocknr, pblocknr, pbh);
 	if (err == -EEXIST) /* internal code (cache hit) */
 		return 0;
 	if (unlikely(err))
diff --git a/fs/nilfs2/btnode.h b/fs/nilfs2/btnode.h
index c53644c..3d5cf08 100644
--- a/fs/nilfs2/btnode.h
+++ b/fs/nilfs2/btnode.h
@@ -43,9 +43,9 @@ void nilfs_btnode_cache_clear(struct address_space *);
 struct buffer_head *nilfs_btnode_create_block(struct address_space *btnc,
 					      __u64 blocknr);
 int nilfs_btnode_submit_block(struct address_space *, __u64, sector_t,
-			      struct buffer_head **, int);
+			      struct buffer_head **);
 int nilfs_btnode_get(struct address_space *, __u64, sector_t,
-		     struct buffer_head **, int);
+		     struct buffer_head **);
 void nilfs_btnode_delete(struct buffer_head *);
 int nilfs_btnode_prepare_change_key(struct address_space *,
 				    struct nilfs_btnode_chkey_ctxt *);
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 67d2099..e16a666 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -149,7 +149,7 @@ int nilfs_gccache_submit_read_node(struct inode *inode, sector_t pbn,
 				   __u64 vbn, struct buffer_head **out_bh)
 {
 	int ret = nilfs_btnode_submit_block(&NILFS_I(inode)->i_btnode_cache,
-					    vbn ? : pbn, pbn, out_bh, 0);
+					    vbn ? : pbn, pbn, out_bh);
 	if (ret == -EEXIST) /* internal code (cache hit) */
 		ret = 0;
 	return ret;
-- 
1.6.3.4
