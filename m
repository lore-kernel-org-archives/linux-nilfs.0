From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/6] nilfs2: get rid of private conversion macros on bmap key and pointer
Date: Sun, 11 Jul 2010 00:01:49 +0900
Message-ID: <1278774114-17917-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1278774114-17917-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1278774114-17917-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Will remove nilfs_bmap_key_to_dkey(), nilfs_bmap_dkey_to_key(),
nilfs_bmap_ptr_to_dptr(), and nilfs_bmap_dptr_to_ptr() for simplicity.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.h   |    5 -----
 fs/nilfs2/btree.c  |   34 ++++++++++++++++------------------
 fs/nilfs2/direct.c |   12 ++++++------
 3 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index 9980d7d..de88ddf 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -32,11 +32,6 @@
 
 #define NILFS_BMAP_INVALID_PTR	0
 
-#define nilfs_bmap_dkey_to_key(dkey)	le64_to_cpu(dkey)
-#define nilfs_bmap_key_to_dkey(key)	cpu_to_le64(key)
-#define nilfs_bmap_dptr_to_ptr(dptr)	le64_to_cpu(dptr)
-#define nilfs_bmap_ptr_to_dptr(ptr)	cpu_to_le64(ptr)
-
 #define nilfs_bmap_keydiff_abs(diff)	((diff) < 0 ? -(diff) : (diff))
 
 
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index d210a8a..0b72fc7 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -190,29 +190,27 @@ nilfs_btree_node_dptrs(const struct nilfs_btree_node *node,
 static inline __u64
 nilfs_btree_node_get_key(const struct nilfs_btree_node *node, int index)
 {
-	return nilfs_bmap_dkey_to_key(*(nilfs_btree_node_dkeys(node) + index));
+	return le64_to_cpu(*(nilfs_btree_node_dkeys(node) + index));
 }
 
 static inline void
 nilfs_btree_node_set_key(struct nilfs_btree_node *node, int index, __u64 key)
 {
-	*(nilfs_btree_node_dkeys(node) + index) = nilfs_bmap_key_to_dkey(key);
+	*(nilfs_btree_node_dkeys(node) + index) = cpu_to_le64(key);
 }
 
 static inline __u64
 nilfs_btree_node_get_ptr(const struct nilfs_btree *btree,
 			 const struct nilfs_btree_node *node, int index)
 {
-	return nilfs_bmap_dptr_to_ptr(*(nilfs_btree_node_dptrs(node, btree) +
-					index));
+	return le64_to_cpu(*(nilfs_btree_node_dptrs(node, btree) + index));
 }
 
 static inline void
 nilfs_btree_node_set_ptr(struct nilfs_btree *btree,
 			 struct nilfs_btree_node *node, int index, __u64 ptr)
 {
-	*(nilfs_btree_node_dptrs(node, btree) + index) =
-		nilfs_bmap_ptr_to_dptr(ptr);
+	*(nilfs_btree_node_dptrs(node, btree) + index) = cpu_to_le64(ptr);
 }
 
 static void nilfs_btree_node_init(struct nilfs_btree *btree,
@@ -231,8 +229,8 @@ static void nilfs_btree_node_init(struct nilfs_btree *btree,
 	dkeys = nilfs_btree_node_dkeys(node);
 	dptrs = nilfs_btree_node_dptrs(node, btree);
 	for (i = 0; i < nchildren; i++) {
-		dkeys[i] = nilfs_bmap_key_to_dkey(keys[i]);
-		dptrs[i] = nilfs_bmap_ptr_to_dptr(ptrs[i]);
+		dkeys[i] = cpu_to_le64(keys[i]);
+		dptrs[i] = cpu_to_le64(ptrs[i]);
 	}
 }
 
@@ -312,8 +310,8 @@ static void nilfs_btree_node_insert(struct nilfs_btree *btree,
 		memmove(dptrs + index + 1, dptrs + index,
 			(nchildren - index) * sizeof(*dptrs));
 	}
-	dkeys[index] = nilfs_bmap_key_to_dkey(key);
-	dptrs[index] = nilfs_bmap_ptr_to_dptr(ptr);
+	dkeys[index] = cpu_to_le64(key);
+	dptrs[index] = cpu_to_le64(ptr);
 	nchildren++;
 	nilfs_btree_node_set_nchildren(node, nchildren);
 }
@@ -331,8 +329,8 @@ static void nilfs_btree_node_delete(struct nilfs_btree *btree,
 
 	dkeys = nilfs_btree_node_dkeys(node);
 	dptrs = nilfs_btree_node_dptrs(node, btree);
-	key = nilfs_bmap_dkey_to_key(dkeys[index]);
-	ptr = nilfs_bmap_dptr_to_ptr(dptrs[index]);
+	key = le64_to_cpu(dkeys[index]);
+	ptr = le64_to_cpu(dptrs[index]);
 	nchildren = nilfs_btree_node_get_nchildren(node);
 	if (keyp != NULL)
 		*keyp = key;
@@ -1568,8 +1566,8 @@ static int nilfs_btree_gather_data(struct nilfs_bmap *bmap,
 	dkeys = nilfs_btree_node_dkeys(node);
 	dptrs = nilfs_btree_node_dptrs(node, btree);
 	for (i = 0; i < nitems; i++) {
-		keys[i] = nilfs_bmap_dkey_to_key(dkeys[i]);
-		ptrs[i] = nilfs_bmap_dptr_to_ptr(dptrs[i]);
+		keys[i] = le64_to_cpu(dkeys[i]);
+		ptrs[i] = le64_to_cpu(dptrs[i]);
 	}
 
 	if (bh != NULL)
@@ -2058,7 +2056,7 @@ static int nilfs_btree_assign_p(struct nilfs_btree *btree,
 
 	key = nilfs_btree_node_get_key(parent, path[level + 1].bp_index);
 	/* on-disk format */
-	binfo->bi_dat.bi_blkoff = nilfs_bmap_key_to_dkey(key);
+	binfo->bi_dat.bi_blkoff = cpu_to_le64(key);
 	binfo->bi_dat.bi_level = level;
 
 	return 0;
@@ -2089,8 +2087,8 @@ static int nilfs_btree_assign_v(struct nilfs_btree *btree,
 
 	key = nilfs_btree_node_get_key(parent, path[level + 1].bp_index);
 	/* on-disk format */
-	binfo->bi_v.bi_vblocknr = nilfs_bmap_ptr_to_dptr(ptr);
-	binfo->bi_v.bi_blkoff = nilfs_bmap_key_to_dkey(key);
+	binfo->bi_v.bi_vblocknr = cpu_to_le64(ptr);
+	binfo->bi_v.bi_blkoff = cpu_to_le64(key);
 
 	return 0;
 }
@@ -2158,7 +2156,7 @@ static int nilfs_btree_assign_gc(struct nilfs_bmap *bmap,
 
 	/* on-disk format */
 	binfo->bi_v.bi_vblocknr = cpu_to_le64((*bh)->b_blocknr);
-	binfo->bi_v.bi_blkoff = nilfs_bmap_key_to_dkey(key);
+	binfo->bi_v.bi_blkoff = cpu_to_le64(key);
 
 	return 0;
 }
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 236753d..32f1746 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -36,13 +36,13 @@ static inline __le64 *nilfs_direct_dptrs(const struct nilfs_direct *direct)
 static inline __u64
 nilfs_direct_get_ptr(const struct nilfs_direct *direct, __u64 key)
 {
-	return nilfs_bmap_dptr_to_ptr(*(nilfs_direct_dptrs(direct) + key));
+	return le64_to_cpu(*(nilfs_direct_dptrs(direct) + key));
 }
 
 static inline void nilfs_direct_set_ptr(struct nilfs_direct *direct,
 					__u64 key, __u64 ptr)
 {
-	*(nilfs_direct_dptrs(direct) + key) = nilfs_bmap_ptr_to_dptr(ptr);
+	*(nilfs_direct_dptrs(direct) + key) = cpu_to_le64(ptr);
 }
 
 static int nilfs_direct_lookup(const struct nilfs_bmap *bmap,
@@ -258,7 +258,7 @@ int nilfs_direct_delete_and_convert(struct nilfs_bmap *bmap,
 	for (i = 0, j = 0; i < NILFS_DIRECT_NBLOCKS; i++) {
 		if ((j < n) && (i == keys[j])) {
 			dptrs[i] = (i != key) ?
-				nilfs_bmap_ptr_to_dptr(ptrs[j]) :
+				cpu_to_le64(ptrs[j]) :
 				NILFS_BMAP_INVALID_PTR;
 			j++;
 		} else
@@ -315,8 +315,8 @@ static int nilfs_direct_assign_v(struct nilfs_direct *direct,
 	ret = nilfs_dat_prepare_start(dat, &req.bpr_req);
 	if (!ret) {
 		nilfs_dat_commit_start(dat, &req.bpr_req, blocknr);
-		binfo->bi_v.bi_vblocknr = nilfs_bmap_ptr_to_dptr(ptr);
-		binfo->bi_v.bi_blkoff = nilfs_bmap_key_to_dkey(key);
+		binfo->bi_v.bi_vblocknr = cpu_to_le64(ptr);
+		binfo->bi_v.bi_blkoff = cpu_to_le64(key);
 	}
 	return ret;
 }
@@ -329,7 +329,7 @@ static int nilfs_direct_assign_p(struct nilfs_direct *direct,
 {
 	nilfs_direct_set_ptr(direct, key, blocknr);
 
-	binfo->bi_dat.bi_blkoff = nilfs_bmap_key_to_dkey(key);
+	binfo->bi_dat.bi_blkoff = cpu_to_le64(key);
 	binfo->bi_dat.bi_level = 0;
 
 	return 0;
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
