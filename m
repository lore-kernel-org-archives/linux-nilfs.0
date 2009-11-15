From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 17/23] nilfs2: eliminate nilfs_btnode_get
	function
Date: Sun, 15 Nov 2009 21:46:55 +0900
Message-ID: <1258289221-3827-18-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This removes the obsolete nilfs_btnode_get() function and makes
nilfs_btree_get_block() directly call nilfs_btnode_submit_block().

This expansion will provide better opportunity for code optimization.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btnode.c |   21 ---------------------
 fs/nilfs2/btnode.h |    2 --
 fs/nilfs2/btree.c  |   13 ++++++++++++-
 3 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 59658f0..471e269 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -147,27 +147,6 @@ out_locked:
 	return err;
 }
 
-int nilfs_btnode_get(struct address_space *btnc, __u64 blocknr,
-		     sector_t pblocknr, struct buffer_head **pbh)
-{
-	struct buffer_head *bh;
-	int err;
-
-	err = nilfs_btnode_submit_block(btnc, blocknr, pblocknr, pbh);
-	if (err == -EEXIST) /* internal code (cache hit) */
-		return 0;
-	if (unlikely(err))
-		return err;
-
-	bh = *pbh;
-	wait_on_buffer(bh);
-	if (!buffer_uptodate(bh)) {
-		brelse(bh);
-		return -EIO;
-	}
-	return 0;
-}
-
 /**
  * nilfs_btnode_delete - delete B-tree node buffer
  * @bh: buffer to be deleted
diff --git a/fs/nilfs2/btnode.h b/fs/nilfs2/btnode.h
index 3d5cf08..07da83f 100644
--- a/fs/nilfs2/btnode.h
+++ b/fs/nilfs2/btnode.h
@@ -44,8 +44,6 @@ struct buffer_head *nilfs_btnode_create_block(struct address_space *btnc,
 					      __u64 blocknr);
 int nilfs_btnode_submit_block(struct address_space *, __u64, sector_t,
 			      struct buffer_head **);
-int nilfs_btnode_get(struct address_space *, __u64, sector_t,
-		     struct buffer_head **);
 void nilfs_btnode_delete(struct buffer_head *);
 int nilfs_btnode_prepare_change_key(struct address_space *,
 				    struct nilfs_btnode_chkey_ctxt *);
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 7b0cc4f..139b113 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -114,7 +114,18 @@ static int nilfs_btree_get_block(const struct nilfs_btree *btree, __u64 ptr,
 {
 	struct address_space *btnc =
 		&NILFS_BMAP_I((struct nilfs_bmap *)btree)->i_btnode_cache;
-	return nilfs_btnode_get(btnc, ptr, 0, bhp, 0);
+	int err;
+
+	err = nilfs_btnode_submit_block(btnc, ptr, 0, bhp);
+	if (err)
+		return err == -EEXIST ? 0 : err;
+
+	wait_on_buffer(*bhp);
+	if (!buffer_uptodate(*bhp)) {
+		brelse(*bhp);
+		return -EIO;
+	}
+	return 0;
 }
 
 static int nilfs_btree_get_new_block(const struct nilfs_btree *btree,
-- 
1.6.3.4
