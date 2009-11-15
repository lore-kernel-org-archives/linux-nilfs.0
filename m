From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 23/23] nilfs2: insert cache operation in
	palloc get block routines
Date: Sun, 15 Nov 2009 21:47:01 +0900
Message-ID: <1258289221-3827-24-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This implements cache operation in get block routines of palloc code:
nilfs_palloc_get_desc_block(), nilfs_palloc_get_bitmap_block(), and
nilfs_palloc_get_entry_block().

This will complete the palloc cache.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/alloc.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 54 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index c56300d..3f959f1 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -142,29 +142,75 @@ static void nilfs_palloc_desc_block_init(struct inode *inode,
 	}
 }
 
+static int nilfs_palloc_get_block(struct inode *inode, unsigned long blkoff,
+				  int create,
+				  void (*init_block)(struct inode *,
+						     struct buffer_head *,
+						     void *),
+				  struct buffer_head **bhp,
+				  struct nilfs_bh_assoc *prev,
+				  spinlock_t *lock)
+{
+	int ret;
+
+	spin_lock(lock);
+	if (prev->bh && blkoff == prev->blkoff) {
+		get_bh(prev->bh);
+		*bhp = prev->bh;
+		spin_unlock(lock);
+		return 0;
+	}
+	spin_unlock(lock);
+
+	ret = nilfs_mdt_get_block(inode, blkoff, create, init_block, bhp);
+	if (!ret) {
+		spin_lock(lock);
+		/*
+		 * The following code must be safe for change of the
+		 * cache contents during the get block call.
+		 */
+		brelse(prev->bh);
+		get_bh(*bhp);
+		prev->bh = *bhp;
+		prev->blkoff = blkoff;
+		spin_unlock(lock);
+	}
+	return ret;
+}
+
 static int nilfs_palloc_get_desc_block(struct inode *inode,
 				       unsigned long group,
 				       int create, struct buffer_head **bhp)
 {
-	return nilfs_mdt_get_block(inode,
-				   nilfs_palloc_desc_blkoff(inode, group),
-				   create, nilfs_palloc_desc_block_init, bhp);
+	struct nilfs_palloc_cache *cache = NILFS_MDT(inode)->mi_palloc_cache;
+
+	return nilfs_palloc_get_block(inode,
+				      nilfs_palloc_desc_blkoff(inode, group),
+				      create, nilfs_palloc_desc_block_init,
+				      bhp, &cache->prev_desc, &cache->lock);
 }
 
 static int nilfs_palloc_get_bitmap_block(struct inode *inode,
 					 unsigned long group,
 					 int create, struct buffer_head **bhp)
 {
-	return nilfs_mdt_get_block(inode,
-				   nilfs_palloc_bitmap_blkoff(inode, group),
-				   create, NULL, bhp);
+	struct nilfs_palloc_cache *cache = NILFS_MDT(inode)->mi_palloc_cache;
+
+	return nilfs_palloc_get_block(inode,
+				      nilfs_palloc_bitmap_blkoff(inode, group),
+				      create, NULL, bhp,
+				      &cache->prev_bitmap, &cache->lock);
 }
 
 int nilfs_palloc_get_entry_block(struct inode *inode, __u64 nr,
 				 int create, struct buffer_head **bhp)
 {
-	return nilfs_mdt_get_block(inode, nilfs_palloc_entry_blkoff(inode, nr),
-				   create, NULL, bhp);
+	struct nilfs_palloc_cache *cache = NILFS_MDT(inode)->mi_palloc_cache;
+
+	return nilfs_palloc_get_block(inode,
+				      nilfs_palloc_entry_blkoff(inode, nr),
+				      create, NULL, bhp,
+				      &cache->prev_entry, &cache->lock);
 }
 
 static struct nilfs_palloc_group_desc *
-- 
1.6.3.4
