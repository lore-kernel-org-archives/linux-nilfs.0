From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/6] nilfs2: get rid of nilfs_direct uses
Date: Sun, 11 Jul 2010 00:01:51 +0900
Message-ID: <1278774114-17917-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This replaces all uses of nilfs_direct struct in implementation of
direct mapping with nilfs_bmap struct.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/direct.c |   78 +++++++++++++++++++++------------------------------
 1 files changed, 32 insertions(+), 46 deletions(-)

diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index fd006ee..cfc7218 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -27,31 +27,29 @@
 #include "alloc.h"
 #include "dat.h"
 
-static inline __le64 *nilfs_direct_dptrs(const struct nilfs_direct *direct)
+static inline __le64 *nilfs_direct_dptrs(const struct nilfs_bmap *direct)
 {
 	return (__le64 *)
-		((struct nilfs_direct_node *)direct->d_bmap.b_u.u_data + 1);
+		((struct nilfs_direct_node *)direct->b_u.u_data + 1);
 }
 
 static inline __u64
-nilfs_direct_get_ptr(const struct nilfs_direct *direct, __u64 key)
+nilfs_direct_get_ptr(const struct nilfs_bmap *direct, __u64 key)
 {
 	return le64_to_cpu(*(nilfs_direct_dptrs(direct) + key));
 }
 
-static inline void nilfs_direct_set_ptr(struct nilfs_direct *direct,
+static inline void nilfs_direct_set_ptr(struct nilfs_bmap *direct,
 					__u64 key, __u64 ptr)
 {
 	*(nilfs_direct_dptrs(direct) + key) = cpu_to_le64(ptr);
 }
 
-static int nilfs_direct_lookup(const struct nilfs_bmap *bmap,
+static int nilfs_direct_lookup(const struct nilfs_bmap *direct,
 			       __u64 key, int level, __u64 *ptrp)
 {
-	struct nilfs_direct *direct;
 	__u64 ptr;
 
-	direct = (struct nilfs_direct *)bmap;  /* XXX: use macro for level 1 */
 	if (key > NILFS_DIRECT_KEY_MAX || level != 1)
 		return -ENOENT;
 	ptr = nilfs_direct_get_ptr(direct, key);
@@ -63,11 +61,10 @@ static int nilfs_direct_lookup(const struct nilfs_bmap *bmap,
 	return 0;
 }
 
-static int nilfs_direct_lookup_contig(const struct nilfs_bmap *bmap,
+static int nilfs_direct_lookup_contig(const struct nilfs_bmap *direct,
 				      __u64 key, __u64 *ptrp,
 				      unsigned maxblocks)
 {
-	struct nilfs_direct *direct = (struct nilfs_direct *)bmap;
 	struct inode *dat = NULL;
 	__u64 ptr, ptr2;
 	sector_t blocknr;
@@ -79,8 +76,8 @@ static int nilfs_direct_lookup_contig(const struct nilfs_bmap *bmap,
 	if (ptr == NILFS_BMAP_INVALID_PTR)
 		return -ENOENT;
 
-	if (NILFS_BMAP_USE_VBN(bmap)) {
-		dat = nilfs_bmap_get_dat(bmap);
+	if (NILFS_BMAP_USE_VBN(direct)) {
+		dat = nilfs_bmap_get_dat(direct);
 		ret = nilfs_dat_translate(dat, ptr, &blocknr);
 		if (ret < 0)
 			return ret;
@@ -106,29 +103,28 @@ static int nilfs_direct_lookup_contig(const struct nilfs_bmap *bmap,
 }
 
 static __u64
-nilfs_direct_find_target_v(const struct nilfs_direct *direct, __u64 key)
+nilfs_direct_find_target_v(const struct nilfs_bmap *direct, __u64 key)
 {
 	__u64 ptr;
 
-	ptr = nilfs_bmap_find_target_seq(&direct->d_bmap, key);
+	ptr = nilfs_bmap_find_target_seq(direct, key);
 	if (ptr != NILFS_BMAP_INVALID_PTR)
 		/* sequential access */
 		return ptr;
 	else
 		/* block group */
-		return nilfs_bmap_find_target_in_group(&direct->d_bmap);
+		return nilfs_bmap_find_target_in_group(direct);
 }
 
-static void nilfs_direct_set_target_v(struct nilfs_direct *direct,
+static void nilfs_direct_set_target_v(struct nilfs_bmap *direct,
 				      __u64 key, __u64 ptr)
 {
-	direct->d_bmap.b_last_allocated_key = key;
-	direct->d_bmap.b_last_allocated_ptr = ptr;
+	direct->b_last_allocated_key = key;
+	direct->b_last_allocated_ptr = ptr;
 }
 
 static int nilfs_direct_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
 {
-	struct nilfs_direct *direct = (struct nilfs_direct *)bmap;
 	union nilfs_bmap_ptr_req req;
 	struct inode *dat = NULL;
 	struct buffer_head *bh;
@@ -136,11 +132,11 @@ static int nilfs_direct_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
 
 	if (key > NILFS_DIRECT_KEY_MAX)
 		return -ENOENT;
-	if (nilfs_direct_get_ptr(direct, key) != NILFS_BMAP_INVALID_PTR)
+	if (nilfs_direct_get_ptr(bmap, key) != NILFS_BMAP_INVALID_PTR)
 		return -EEXIST;
 
 	if (NILFS_BMAP_USE_VBN(bmap)) {
-		req.bpr_ptr = nilfs_direct_find_target_v(direct, key);
+		req.bpr_ptr = nilfs_direct_find_target_v(bmap, key);
 		dat = nilfs_bmap_get_dat(bmap);
 	}
 	ret = nilfs_bmap_prepare_alloc_ptr(bmap, &req, dat);
@@ -150,13 +146,13 @@ static int nilfs_direct_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
 		set_buffer_nilfs_volatile(bh);
 
 		nilfs_bmap_commit_alloc_ptr(bmap, &req, dat);
-		nilfs_direct_set_ptr(direct, key, req.bpr_ptr);
+		nilfs_direct_set_ptr(bmap, key, req.bpr_ptr);
 
 		if (!nilfs_bmap_dirty(bmap))
 			nilfs_bmap_set_dirty(bmap);
 
 		if (NILFS_BMAP_USE_VBN(bmap))
-			nilfs_direct_set_target_v(direct, key, req.bpr_ptr);
+			nilfs_direct_set_target_v(bmap, key, req.bpr_ptr);
 
 		nilfs_bmap_add_blocks(bmap, 1);
 	}
@@ -165,33 +161,30 @@ static int nilfs_direct_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
 
 static int nilfs_direct_delete(struct nilfs_bmap *bmap, __u64 key)
 {
-	struct nilfs_direct *direct = (struct nilfs_direct *)bmap;
 	union nilfs_bmap_ptr_req req;
 	struct inode *dat;
 	int ret;
 
 	if (key > NILFS_DIRECT_KEY_MAX ||
-	    nilfs_direct_get_ptr(direct, key) == NILFS_BMAP_INVALID_PTR)
+	    nilfs_direct_get_ptr(bmap, key) == NILFS_BMAP_INVALID_PTR)
 		return -ENOENT;
 
 	dat = NILFS_BMAP_USE_VBN(bmap) ? nilfs_bmap_get_dat(bmap) : NULL;
-	req.bpr_ptr = nilfs_direct_get_ptr(direct, key);
+	req.bpr_ptr = nilfs_direct_get_ptr(bmap, key);
 
 	ret = nilfs_bmap_prepare_end_ptr(bmap, &req, dat);
 	if (!ret) {
 		nilfs_bmap_commit_end_ptr(bmap, &req, dat);
-		nilfs_direct_set_ptr(direct, key, NILFS_BMAP_INVALID_PTR);
+		nilfs_direct_set_ptr(bmap, key, NILFS_BMAP_INVALID_PTR);
 		nilfs_bmap_sub_blocks(bmap, 1);
 	}
 	return ret;
 }
 
-static int nilfs_direct_last_key(const struct nilfs_bmap *bmap, __u64 *keyp)
+static int nilfs_direct_last_key(const struct nilfs_bmap *direct, __u64 *keyp)
 {
-	struct nilfs_direct *direct;
 	__u64 key, lastkey;
 
-	direct = (struct nilfs_direct *)bmap;
 	lastkey = NILFS_DIRECT_KEY_MAX + 1;
 	for (key = NILFS_DIRECT_KEY_MIN; key <= NILFS_DIRECT_KEY_MAX; key++)
 		if (nilfs_direct_get_ptr(direct, key) !=
@@ -211,15 +204,13 @@ static int nilfs_direct_check_insert(const struct nilfs_bmap *bmap, __u64 key)
 	return key > NILFS_DIRECT_KEY_MAX;
 }
 
-static int nilfs_direct_gather_data(struct nilfs_bmap *bmap,
+static int nilfs_direct_gather_data(struct nilfs_bmap *direct,
 				    __u64 *keys, __u64 *ptrs, int nitems)
 {
-	struct nilfs_direct *direct;
 	__u64 key;
 	__u64 ptr;
 	int n;
 
-	direct = (struct nilfs_direct *)bmap;
 	if (nitems > NILFS_DIRECT_NBLOCKS)
 		nitems = NILFS_DIRECT_NBLOCKS;
 	n = 0;
@@ -237,7 +228,6 @@ static int nilfs_direct_gather_data(struct nilfs_bmap *bmap,
 int nilfs_direct_delete_and_convert(struct nilfs_bmap *bmap,
 				    __u64 key, __u64 *keys, __u64 *ptrs, int n)
 {
-	struct nilfs_direct *direct;
 	__le64 *dptrs;
 	int ret, i, j;
 
@@ -253,8 +243,7 @@ int nilfs_direct_delete_and_convert(struct nilfs_bmap *bmap,
 		bmap->b_ops->bop_clear(bmap);
 
 	/* convert */
-	direct = (struct nilfs_direct *)bmap;
-	dptrs = nilfs_direct_dptrs(direct);
+	dptrs = nilfs_direct_dptrs(bmap);
 	for (i = 0, j = 0; i < NILFS_DIRECT_NBLOCKS; i++) {
 		if ((j < n) && (i == keys[j])) {
 			dptrs[i] = (i != key) ?
@@ -272,7 +261,6 @@ int nilfs_direct_delete_and_convert(struct nilfs_bmap *bmap,
 static int nilfs_direct_propagate(struct nilfs_bmap *bmap,
 				  struct buffer_head *bh)
 {
-	struct nilfs_direct *direct = (struct nilfs_direct *)bmap;
 	struct nilfs_palloc_req oldreq, newreq;
 	struct inode *dat;
 	__u64 key;
@@ -284,7 +272,7 @@ static int nilfs_direct_propagate(struct nilfs_bmap *bmap,
 
 	dat = nilfs_bmap_get_dat(bmap);
 	key = nilfs_bmap_data_get_key(bmap, bh);
-	ptr = nilfs_direct_get_ptr(direct, key);
+	ptr = nilfs_direct_get_ptr(bmap, key);
 	if (!buffer_nilfs_volatile(bh)) {
 		oldreq.pr_entry_nr = ptr;
 		newreq.pr_entry_nr = ptr;
@@ -294,20 +282,20 @@ static int nilfs_direct_propagate(struct nilfs_bmap *bmap,
 		nilfs_dat_commit_update(dat, &oldreq, &newreq,
 					bmap->b_ptr_type == NILFS_BMAP_PTR_VS);
 		set_buffer_nilfs_volatile(bh);
-		nilfs_direct_set_ptr(direct, key, newreq.pr_entry_nr);
+		nilfs_direct_set_ptr(bmap, key, newreq.pr_entry_nr);
 	} else
 		ret = nilfs_dat_mark_dirty(dat, ptr);
 
 	return ret;
 }
 
-static int nilfs_direct_assign_v(struct nilfs_direct *direct,
+static int nilfs_direct_assign_v(struct nilfs_bmap *direct,
 				 __u64 key, __u64 ptr,
 				 struct buffer_head **bh,
 				 sector_t blocknr,
 				 union nilfs_binfo *binfo)
 {
-	struct inode *dat = nilfs_bmap_get_dat(&direct->d_bmap);
+	struct inode *dat = nilfs_bmap_get_dat(direct);
 	union nilfs_bmap_ptr_req req;
 	int ret;
 
@@ -321,7 +309,7 @@ static int nilfs_direct_assign_v(struct nilfs_direct *direct,
 	return ret;
 }
 
-static int nilfs_direct_assign_p(struct nilfs_direct *direct,
+static int nilfs_direct_assign_p(struct nilfs_bmap *direct,
 				 __u64 key, __u64 ptr,
 				 struct buffer_head **bh,
 				 sector_t blocknr,
@@ -340,18 +328,16 @@ static int nilfs_direct_assign(struct nilfs_bmap *bmap,
 			       sector_t blocknr,
 			       union nilfs_binfo *binfo)
 {
-	struct nilfs_direct *direct;
 	__u64 key;
 	__u64 ptr;
 
-	direct = (struct nilfs_direct *)bmap;
 	key = nilfs_bmap_data_get_key(bmap, *bh);
 	if (unlikely(key > NILFS_DIRECT_KEY_MAX)) {
 		printk(KERN_CRIT "%s: invalid key: %llu\n", __func__,
 		       (unsigned long long)key);
 		return -EINVAL;
 	}
-	ptr = nilfs_direct_get_ptr(direct, key);
+	ptr = nilfs_direct_get_ptr(bmap, key);
 	if (unlikely(ptr == NILFS_BMAP_INVALID_PTR)) {
 		printk(KERN_CRIT "%s: invalid pointer: %llu\n", __func__,
 		       (unsigned long long)ptr);
@@ -359,8 +345,8 @@ static int nilfs_direct_assign(struct nilfs_bmap *bmap,
 	}
 
 	return NILFS_BMAP_USE_VBN(bmap) ?
-		nilfs_direct_assign_v(direct, key, ptr, bh, blocknr, binfo) :
-		nilfs_direct_assign_p(direct, key, ptr, bh, blocknr, binfo);
+		nilfs_direct_assign_v(bmap, key, ptr, bh, blocknr, binfo) :
+		nilfs_direct_assign_p(bmap, key, ptr, bh, blocknr, binfo);
 }
 
 static const struct nilfs_bmap_operations nilfs_direct_ops = {
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
