From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 15/23] nilfs2: use nilfs_btnode_create_block
	function
Date: Sun, 15 Nov 2009 21:46:53 +0900
Message-ID: <1258289221-3827-16-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This displaces nilfs_btnode_get() use to create new btree node block
with nilfs_btnode_create_block.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btnode.c |   13 +++++++------
 fs/nilfs2/btree.c  |   13 ++++++++-----
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index fc3e4bd..7086a2a 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -270,12 +270,13 @@ retry:
 		unlock_page(obh->b_page);
 	}
 
-	err = nilfs_btnode_get(btnc, newkey, 0, &nbh, 1);
-	if (likely(!err)) {
-		BUG_ON(nbh == obh);
-		ctxt->newbh = nbh;
-	}
-	return err;
+	nbh = nilfs_btnode_create_block(btnc, newkey);
+	if (!nbh)
+		return -ENOMEM;
+
+	BUG_ON(nbh == obh);
+	ctxt->newbh = nbh;
+	return 0;
 
  failed_unlock:
 	unlock_page(obh->b_page);
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index c9aab29..7b0cc4f 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -122,12 +122,15 @@ static int nilfs_btree_get_new_block(const struct nilfs_btree *btree,
 {
 	struct address_space *btnc =
 		&NILFS_BMAP_I((struct nilfs_bmap *)btree)->i_btnode_cache;
-	int ret;
+	struct buffer_head *bh;
 
-	ret = nilfs_btnode_get(btnc, ptr, 0, bhp, 1);
-	if (!ret)
-		set_buffer_nilfs_volatile(*bhp);
-	return ret;
+	bh = nilfs_btnode_create_block(btnc, ptr);
+	if (!bh)
+		return -ENOMEM;
+
+	set_buffer_nilfs_volatile(bh);
+	*bhp = bh;
+	return 0;
 }
 
 static inline int
-- 
1.6.3.4
