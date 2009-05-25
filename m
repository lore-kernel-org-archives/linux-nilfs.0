From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 11/17] nilfs2: remove useless b_low and b_high
	fields from nilfs_bmap struct
Date: Mon, 25 May 2009 19:18:15 +0900
Message-ID: <1243246701-5193-12-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1243246701-5193-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1243246701-5193-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

This will cut off 16 bytes from the nilfs_bmap struct which is
embedded in the on-memory inode of nilfs.

The b_high field was never used, and the b_low field stores a constant
value which can be determined by whether the inode uses btree for
block mapping or not.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.c   |   13 +++----------
 fs/nilfs2/bmap.h   |    4 ----
 fs/nilfs2/btree.c  |   22 +++++++---------------
 fs/nilfs2/btree.h  |    5 ++---
 fs/nilfs2/direct.c |   13 ++++---------
 fs/nilfs2/direct.h |    4 ++--
 6 files changed, 18 insertions(+), 43 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index cf5c5d2..de67d2a 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -101,8 +101,7 @@ static int nilfs_bmap_do_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
 			if (n < 0)
 				return n;
 			ret = nilfs_btree_convert_and_insert(
-				bmap, key, ptr, keys, ptrs, n,
-				NILFS_BMAP_LARGE_LOW, NILFS_BMAP_LARGE_HIGH);
+				bmap, key, ptr, keys, ptrs, n);
 			if (ret == 0)
 				bmap->b_u.u_flags |= NILFS_BMAP_LARGE;
 
@@ -158,8 +157,7 @@ static int nilfs_bmap_do_delete(struct nilfs_bmap *bmap, __u64 key)
 			if (n < 0)
 				return n;
 			ret = nilfs_direct_delete_and_convert(
-				bmap, key, keys, ptrs, n,
-				NILFS_BMAP_SMALL_LOW, NILFS_BMAP_SMALL_HIGH);
+				bmap, key, keys, ptrs, n);
 			if (ret == 0)
 				bmap->b_u.u_flags &= ~NILFS_BMAP_LARGE;
 
@@ -681,12 +679,7 @@ int nilfs_bmap_read(struct nilfs_bmap *bmap, struct nilfs_inode *raw_inode)
 	}
 
 	return (bmap->b_u.u_flags & NILFS_BMAP_LARGE) ?
-		nilfs_btree_init(bmap,
-				 NILFS_BMAP_LARGE_LOW,
-				 NILFS_BMAP_LARGE_HIGH) :
-		nilfs_direct_init(bmap,
-				  NILFS_BMAP_SMALL_LOW,
-				  NILFS_BMAP_SMALL_HIGH);
+		nilfs_btree_init(bmap) : nilfs_direct_init(bmap);
 }
 
 /**
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index 978073b..28c77bb 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -125,8 +125,6 @@ static inline int nilfs_bmap_is_new_ptr(unsigned long ptr)
  * @b_inode: owner of bmap
  * @b_ops: bmap operation table
  * @b_pops: bmap ptr operation table
- * @b_low: low watermark of conversion
- * @b_high: high watermark of conversion
  * @b_last_allocated_key: last allocated key for data block
  * @b_last_allocated_ptr: last allocated ptr for data block
  * @b_state: state
@@ -140,8 +138,6 @@ struct nilfs_bmap {
 	struct inode *b_inode;
 	const struct nilfs_bmap_operations *b_ops;
 	const struct nilfs_bmap_ptr_operations *b_pops;
-	__u64 b_low;
-	__u64 b_high;
 	__u64 b_last_allocated_key;
 	__u64 b_last_allocated_ptr;
 	int b_state;
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 5b2606a..f5a0ec6 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1527,7 +1527,7 @@ static int nilfs_btree_check_delete(struct nilfs_bmap *bmap, __u64 key)
 	if (bh != NULL)
 		brelse(bh);
 
-	return (maxkey == key) && (nextmaxkey < bmap->b_low);
+	return (maxkey == key) && (nextmaxkey < NILFS_BMAP_LARGE_LOW);
 }
 
 static int nilfs_btree_gather_data(struct nilfs_bmap *bmap,
@@ -1634,7 +1634,7 @@ static void
 nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *bmap,
 				      __u64 key, __u64 ptr,
 				      const __u64 *keys, const __u64 *ptrs,
-				      int n, __u64 low, __u64 high,
+				      int n,
 				      union nilfs_bmap_ptr_req *dreq,
 				      union nilfs_bmap_ptr_req *nreq,
 				      struct buffer_head *bh)
@@ -1652,7 +1652,7 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *bmap,
 
 	/* convert and insert */
 	btree = (struct nilfs_btree *)bmap;
-	nilfs_btree_init(bmap, low, high);
+	nilfs_btree_init(bmap);
 	if (nreq != NULL) {
 		bmap->b_pops->bpop_commit_alloc_ptr(bmap, dreq);
 		bmap->b_pops->bpop_commit_alloc_ptr(bmap, nreq);
@@ -1701,13 +1701,10 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *bmap,
  * @keys:
  * @ptrs:
  * @n:
- * @low:
- * @high:
  */
 int nilfs_btree_convert_and_insert(struct nilfs_bmap *bmap,
 				   __u64 key, __u64 ptr,
-				   const __u64 *keys, const __u64 *ptrs,
-				   int n, __u64 low, __u64 high)
+				   const __u64 *keys, const __u64 *ptrs, int n)
 {
 	struct buffer_head *bh;
 	union nilfs_bmap_ptr_req dreq, nreq, *di, *ni;
@@ -1732,7 +1729,7 @@ int nilfs_btree_convert_and_insert(struct nilfs_bmap *bmap,
 	if (ret < 0)
 		return ret;
 	nilfs_btree_commit_convert_and_insert(bmap, key, ptr, keys, ptrs, n,
-					      low, high, di, ni, bh);
+					      di, ni, bh);
 	nilfs_bmap_add_blocks(bmap, stats.bs_nblocks);
 	return 0;
 }
@@ -2245,14 +2242,11 @@ static const struct nilfs_btree_operations nilfs_btree_ops_p = {
 	.btop_assign		=	nilfs_btree_assign_p,
 };
 
-int nilfs_btree_init(struct nilfs_bmap *bmap, __u64 low, __u64 high)
+int nilfs_btree_init(struct nilfs_bmap *bmap)
 {
-	struct nilfs_btree *btree;
+	struct nilfs_btree *btree = (struct nilfs_btree *)bmap;
 
-	btree = (struct nilfs_btree *)bmap;
 	bmap->b_ops = &nilfs_btree_ops;
-	bmap->b_low = low;
-	bmap->b_high = high;
 	switch (bmap->b_inode->i_ino) {
 	case NILFS_DAT_INO:
 		btree->bt_ops = &nilfs_btree_ops_p;
@@ -2267,7 +2261,5 @@ int nilfs_btree_init(struct nilfs_bmap *bmap, __u64 low, __u64 high)
 
 void nilfs_btree_init_gc(struct nilfs_bmap *bmap)
 {
-	bmap->b_low = NILFS_BMAP_LARGE_LOW;
-	bmap->b_high = NILFS_BMAP_LARGE_HIGH;
 	bmap->b_ops = &nilfs_btree_ops_gc;
 }
diff --git a/fs/nilfs2/btree.h b/fs/nilfs2/btree.h
index 4766deb..48aad2a 100644
--- a/fs/nilfs2/btree.h
+++ b/fs/nilfs2/btree.h
@@ -108,10 +108,9 @@ struct nilfs_btree {
 
 int nilfs_btree_path_cache_init(void);
 void nilfs_btree_path_cache_destroy(void);
-int nilfs_btree_init(struct nilfs_bmap *, __u64, __u64);
+int nilfs_btree_init(struct nilfs_bmap *);
 int nilfs_btree_convert_and_insert(struct nilfs_bmap *, __u64, __u64,
-				   const __u64 *, const __u64 *,
-				   int, __u64, __u64);
+				   const __u64 *, const __u64 *, int);
 void nilfs_btree_init_gc(struct nilfs_bmap *);
 
 #endif	/* _NILFS_BTREE_H */
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index eaeccb0..8e8095c 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -242,8 +242,7 @@ static int nilfs_direct_gather_data(struct nilfs_bmap *bmap,
 }
 
 int nilfs_direct_delete_and_convert(struct nilfs_bmap *bmap,
-				    __u64 key, __u64 *keys, __u64 *ptrs,
-				    int n, __u64 low, __u64 high)
+				    __u64 key, __u64 *keys, __u64 *ptrs, int n)
 {
 	struct nilfs_direct *direct;
 	__le64 *dptrs;
@@ -273,8 +272,7 @@ int nilfs_direct_delete_and_convert(struct nilfs_bmap *bmap,
 			dptrs[i] = NILFS_BMAP_INVALID_PTR;
 	}
 
-	nilfs_direct_init(bmap, low, high);
-
+	nilfs_direct_init(bmap);
 	return 0;
 }
 
@@ -410,14 +408,11 @@ static const struct nilfs_direct_operations nilfs_direct_ops_p = {
 	.dop_assign		=	nilfs_direct_assign_p,
 };
 
-int nilfs_direct_init(struct nilfs_bmap *bmap, __u64 low, __u64 high)
+int nilfs_direct_init(struct nilfs_bmap *bmap)
 {
-	struct nilfs_direct *direct;
+	struct nilfs_direct *direct = (struct nilfs_direct *)bmap;
 
-	direct = (struct nilfs_direct *)bmap;
 	bmap->b_ops = &nilfs_direct_ops;
-	bmap->b_low = low;
-	bmap->b_high = high;
 	switch (bmap->b_inode->i_ino) {
 	case NILFS_DAT_INO:
 		direct->d_ops = &nilfs_direct_ops_p;
diff --git a/fs/nilfs2/direct.h b/fs/nilfs2/direct.h
index 45d2c5c..d645f13 100644
--- a/fs/nilfs2/direct.h
+++ b/fs/nilfs2/direct.h
@@ -70,9 +70,9 @@ struct nilfs_direct {
 #define NILFS_DIRECT_KEY_MAX	(NILFS_DIRECT_NBLOCKS - 1)
 
 
-int nilfs_direct_init(struct nilfs_bmap *, __u64, __u64);
+int nilfs_direct_init(struct nilfs_bmap *);
 int nilfs_direct_delete_and_convert(struct nilfs_bmap *, __u64, __u64 *,
-				    __u64 *, int, __u64, __u64);
+				    __u64 *, int);
 
 
 #endif	/* _NILFS_DIRECT_H */
-- 
1.6.2
