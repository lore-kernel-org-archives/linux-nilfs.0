From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 13/24] nilfs2: implement block mapping subsystem debugging
 output
Date: Mon, 17 Jun 2013 16:24:43 +0400
Message-ID: <1371471883.2075.144.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=thtm8zSj6LFmSsEI72cqo+umFsl6K6s78Z+TIq4/Uc8=;
	b=slqBGJUP83jao4IlgxAeToFvxk51Ub39C80q6/M8x9IRMjEX/ouw8FludWnLeza/KsaY3LCJSzosrgR1c20aT25c77BHRTvMgY9ZGCUQy2qDO0wtURSXQk5ULIhQV8gm;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Linux FS Devel <linux-fsdevel@vger.kernel.org>

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 13/24] nilfs2: implement block mapping subsystem debugging output

This patch adds debugging output by means of nilfs2_debug() method
into modules that are grouped by block mapping subsystem debugging output
option (CONFIG_NILFS2_DEBUG_BLOCK_MAPPING).

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/alloc.c  |   15 ++++
 fs/nilfs2/bmap.c   |   81 ++++++++++++++++++++-
 fs/nilfs2/btnode.c |   28 +++++++
 fs/nilfs2/btree.c  |  205 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/nilfs2/direct.c |   51 +++++++++++++
 5 files changed, 375 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index eed4d7b..2ce1fd4 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -62,6 +62,10 @@ int nilfs_palloc_init_blockgroup(struct inode *inode, unsigned entry_size)
 {
 	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
 
+	nilfs2_debug(DBG_ALLOC,
+			"i_ino %lu, entry_size %u\n",
+			inode->i_ino, entry_size);
+
 	mi->mi_bgl = kmalloc(sizeof(*mi->mi_bgl), GFP_NOFS);
 	if (!mi->mi_bgl)
 		return -ENOMEM;
@@ -646,6 +650,10 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 	unsigned long group, group_offset;
 	int i, j, n, ret;
 
+	nilfs2_debug(DBG_ALLOC,
+			"i_ino %lu, entry_nrs %p, nitems %zu\n",
+			inode->i_ino, entry_nrs, nitems);
+
 	for (i = 0; i < nitems; i = j) {
 		group = nilfs_palloc_group(inode, entry_nrs[i], &group_offset);
 		ret = nilfs_palloc_get_desc_block(inode, group, 0, &desc_bh);
@@ -696,6 +704,9 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 void nilfs_palloc_setup_cache(struct inode *inode,
 			      struct nilfs_palloc_cache *cache)
 {
+	nilfs2_debug(DBG_ALLOC,
+			"i_ino %lu, cache %p\n", inode->i_ino, cache);
+
 	NILFS_MDT(inode)->mi_palloc_cache = cache;
 	spin_lock_init(&cache->lock);
 }
@@ -704,6 +715,8 @@ void nilfs_palloc_clear_cache(struct inode *inode)
 {
 	struct nilfs_palloc_cache *cache = NILFS_MDT(inode)->mi_palloc_cache;
 
+	nilfs2_debug(DBG_ALLOC, "i_ino %lu\n", inode->i_ino);
+
 	spin_lock(&cache->lock);
 	brelse(cache->prev_desc.bh);
 	brelse(cache->prev_bitmap.bh);
@@ -716,6 +729,8 @@ void nilfs_palloc_clear_cache(struct inode *inode)
 
 void nilfs_palloc_destroy_cache(struct inode *inode)
 {
+	nilfs2_debug(DBG_ALLOC, "i_ino %lu\n", inode->i_ino);
+
 	nilfs_palloc_clear_cache(inode);
 	NILFS_MDT(inode)->mi_palloc_cache = NULL;
 }
diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index aadbd0b..5df4ebd 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -78,6 +78,11 @@ int nilfs_bmap_lookup_at_level(struct nilfs_bmap *bmap, __u64 key, int level,
 	sector_t blocknr;
 	int ret;
 
+	nilfs2_debug(DBG_BMAP,
+			"i_ino %lu, key %llu, level %d\n",
+			bmap->b_inode->i_ino,
+			key, level);
+
 	down_read(&bmap->b_sem);
 	ret = bmap->b_ops->bop_lookup(bmap, key, level, ptrp);
 	if (ret < 0) {
@@ -91,6 +96,8 @@ int nilfs_bmap_lookup_at_level(struct nilfs_bmap *bmap, __u64 key, int level,
 			*ptrp = blocknr;
 	}
 
+	nilfs2_debug(DBG_BMAP, "ptr %llu\n", *ptrp);
+
  out:
 	up_read(&bmap->b_sem);
 	return ret;
@@ -101,10 +108,16 @@ int nilfs_bmap_lookup_contig(struct nilfs_bmap *bmap, __u64 key, __u64 *ptrp,
 {
 	int ret;
 
+	nilfs2_debug(DBG_BMAP,
+			"i_ino %lu, key %llu, maxblocks %u\n",
+			bmap->b_inode->i_ino, key, maxblocks);
+
 	down_read(&bmap->b_sem);
 	ret = bmap->b_ops->bop_lookup_contig(bmap, key, ptrp, maxblocks);
 	up_read(&bmap->b_sem);
 
+	nilfs2_debug(DBG_BMAP, "ptr %llu\n", *ptrp);
+
 	return nilfs_bmap_convert_error(bmap, __func__, ret);
 }
 
@@ -114,6 +127,10 @@ static int nilfs_bmap_do_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
 	__u64 ptrs[NILFS_BMAP_SMALL_HIGH + 1];
 	int ret, n;
 
+	nilfs2_debug(DBG_BMAP,
+			"i_ino %lu, key %llu, ptr %llu\n",
+			bmap->b_inode->i_ino, key, ptr);
+
 	if (bmap->b_ops->bop_check_insert != NULL) {
 		ret = bmap->b_ops->bop_check_insert(bmap, key);
 		if (ret > 0) {
@@ -158,6 +175,10 @@ int nilfs_bmap_insert(struct nilfs_bmap *bmap,
 {
 	int ret;
 
+	nilfs2_debug(DBG_BMAP,
+			"i_ino %lu, key %lu, rec %lu\n",
+			bmap->b_inode->i_ino, key, rec);
+
 	down_write(&bmap->b_sem);
 	ret = nilfs_bmap_do_insert(bmap, key, rec);
 	up_write(&bmap->b_sem);
@@ -171,6 +192,10 @@ static int nilfs_bmap_do_delete(struct nilfs_bmap *bmap, __u64 key)
 	__u64 ptrs[NILFS_BMAP_LARGE_LOW + 1];
 	int ret, n;
 
+	nilfs2_debug(DBG_BMAP,
+			"i_ino %lu, key %llu\n",
+			bmap->b_inode->i_ino, key);
+
 	if (bmap->b_ops->bop_check_delete != NULL) {
 		ret = bmap->b_ops->bop_check_delete(bmap, key);
 		if (ret > 0) {
@@ -196,14 +221,19 @@ int nilfs_bmap_last_key(struct nilfs_bmap *bmap, unsigned long *key)
 	__u64 lastkey;
 	int ret;
 
+	nilfs2_debug(DBG_BMAP, "i_ino %lu\n",
+			bmap->b_inode->i_ino);
+
 	down_read(&bmap->b_sem);
 	ret = bmap->b_ops->bop_last_key(bmap, &lastkey);
 	up_read(&bmap->b_sem);
 
 	if (ret < 0)
 		ret = nilfs_bmap_convert_error(bmap, __func__, ret);
-	else
+	else {
+		nilfs2_debug(DBG_BMAP, "lastkey %llu\n", lastkey);
 		*key = lastkey;
+	}
 	return ret;
 }
 
@@ -228,6 +258,10 @@ int nilfs_bmap_delete(struct nilfs_bmap *bmap, unsigned long key)
 {
 	int ret;
 
+	nilfs2_debug(DBG_BMAP,
+			"i_ino %lu, key %lu\n",
+			bmap->b_inode->i_ino, key);
+
 	down_write(&bmap->b_sem);
 	ret = nilfs_bmap_do_delete(bmap, key);
 	up_write(&bmap->b_sem);
@@ -240,6 +274,10 @@ static int nilfs_bmap_do_truncate(struct nilfs_bmap *bmap, unsigned long key)
 	__u64 lastkey;
 	int ret;
 
+	nilfs2_debug(DBG_BMAP,
+			"i_ino %lu, key %lu\n",
+			bmap->b_inode->i_ino, key);
+
 	ret = bmap->b_ops->bop_last_key(bmap, &lastkey);
 	if (ret < 0) {
 		if (ret == -ENOENT)
@@ -280,6 +318,10 @@ int nilfs_bmap_truncate(struct nilfs_bmap *bmap, unsigned long key)
 {
 	int ret;
 
+	nilfs2_debug(DBG_BMAP,
+			"i_ino %lu, key %lu\n",
+			bmap->b_inode->i_ino, key);
+
 	down_write(&bmap->b_sem);
 	ret = nilfs_bmap_do_truncate(bmap, key);
 	up_write(&bmap->b_sem);
@@ -296,8 +338,11 @@ int nilfs_bmap_truncate(struct nilfs_bmap *bmap, unsigned long key)
 void nilfs_bmap_clear(struct nilfs_bmap *bmap)
 {
 	down_write(&bmap->b_sem);
-	if (bmap->b_ops->bop_clear != NULL)
+	if (bmap->b_ops->bop_clear != NULL) {
+		nilfs2_debug(DBG_BMAP,
+			"i_ino %lu\n", bmap->b_inode->i_ino);
 		bmap->b_ops->bop_clear(bmap);
+	}
 	up_write(&bmap->b_sem);
 }
 
@@ -320,6 +365,10 @@ int nilfs_bmap_propagate(struct nilfs_bmap *bmap, struct buffer_head *bh)
 {
 	int ret;
 
+	nilfs2_debug(DBG_BMAP,
+			"i_ino %lu, bh->b_blocknr %lu\n",
+			bmap->b_inode->i_ino, bh->b_blocknr);
+
 	down_write(&bmap->b_sem);
 	ret = bmap->b_ops->bop_propagate(bmap, bh);
 	up_write(&bmap->b_sem);
@@ -365,6 +414,10 @@ int nilfs_bmap_assign(struct nilfs_bmap *bmap,
 {
 	int ret;
 
+	nilfs2_debug(DBG_BMAP,
+			"i_ino %lu, blocknr %lu\n",
+			bmap->b_inode->i_ino, blocknr);
+
 	down_write(&bmap->b_sem);
 	ret = bmap->b_ops->bop_assign(bmap, bh, blocknr, binfo);
 	up_write(&bmap->b_sem);
@@ -395,6 +448,10 @@ int nilfs_bmap_mark(struct nilfs_bmap *bmap, __u64 key, int level)
 	if (bmap->b_ops->bop_mark == NULL)
 		return 0;
 
+	nilfs2_debug(DBG_BMAP,
+			"i_ino %lu, key %llu, level %d\n",
+			bmap->b_inode->i_ino, key, level);
+
 	down_write(&bmap->b_sem);
 	ret = bmap->b_ops->bop_mark(bmap, key, level);
 	up_write(&bmap->b_sem);
@@ -415,6 +472,9 @@ int nilfs_bmap_test_and_clear_dirty(struct nilfs_bmap *bmap)
 {
 	int ret;
 
+	nilfs2_debug(DBG_BMAP,
+			"i_ino %lu\n", bmap->b_inode->i_ino);
+
 	down_write(&bmap->b_sem);
 	ret = nilfs_bmap_dirty(bmap);
 	nilfs_bmap_clear_dirty(bmap);
@@ -490,6 +550,11 @@ int nilfs_bmap_read(struct nilfs_bmap *bmap, struct nilfs_inode *raw_inode)
 	init_rwsem(&bmap->b_sem);
 	bmap->b_state = 0;
 	bmap->b_inode = &NILFS_BMAP_I(bmap)->vfs_inode;
+
+	nilfs2_debug(DBG_BMAP,
+			"i_ino %lu, raw_inode %p\n",
+			bmap->b_inode->i_ino, raw_inode);
+
 	switch (bmap->b_inode->i_ino) {
 	case NILFS_DAT_INO:
 		bmap->b_ptr_type = NILFS_BMAP_PTR_P;
@@ -527,6 +592,10 @@ int nilfs_bmap_read(struct nilfs_bmap *bmap, struct nilfs_inode *raw_inode)
  */
 void nilfs_bmap_write(struct nilfs_bmap *bmap, struct nilfs_inode *raw_inode)
 {
+	nilfs2_debug(DBG_BMAP,
+			"i_ino %lu, raw_inode %p\n",
+			bmap->b_inode->i_ino, raw_inode);
+
 	down_write(&bmap->b_sem);
 	memcpy(raw_inode->i_bmap, bmap->b_u.u_data,
 	       NILFS_INODE_BMAP_SIZE * sizeof(__le64));
@@ -551,6 +620,10 @@ void nilfs_bmap_init_gc(struct nilfs_bmap *bmap)
 void nilfs_bmap_save(const struct nilfs_bmap *bmap,
 		     struct nilfs_bmap_store *store)
 {
+	nilfs2_debug(DBG_BMAP,
+			"i_ino %lu, store %p\n",
+			bmap->b_inode->i_ino, store);
+
 	memcpy(store->data, bmap->b_u.u_data, sizeof(store->data));
 	store->last_allocated_key = bmap->b_last_allocated_key;
 	store->last_allocated_ptr = bmap->b_last_allocated_ptr;
@@ -560,6 +633,10 @@ void nilfs_bmap_save(const struct nilfs_bmap *bmap,
 void nilfs_bmap_restore(struct nilfs_bmap *bmap,
 			const struct nilfs_bmap_store *store)
 {
+	nilfs2_debug(DBG_BMAP,
+			"i_ino %lu, store %p\n",
+			bmap->b_inode->i_ino, store);
+
 	memcpy(bmap->b_u.u_data, store->data, sizeof(store->data));
 	bmap->b_last_allocated_key = store->last_allocated_key;
 	bmap->b_last_allocated_ptr = store->last_allocated_ptr;
diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index a35ae35..54b3f2a 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -36,6 +36,9 @@
 
 void nilfs_btnode_cache_clear(struct address_space *btnc)
 {
+	nilfs2_debug(DBG_BTNODE,
+			"i_ino %lu\n", btnc->host->i_ino);
+
 	invalidate_mapping_pages(btnc, 0, -1);
 	truncate_inode_pages(btnc, 0);
 }
@@ -46,6 +49,10 @@ nilfs_btnode_create_block(struct address_space *btnc, __u64 blocknr)
 	struct inode *inode = NILFS_BTNC_I(btnc);
 	struct buffer_head *bh;
 
+	nilfs2_debug(DBG_BTNODE,
+			"i_ino %lu, blocknr %llu\n",
+			btnc->host->i_ino, blocknr);
+
 	bh = nilfs_grab_buffer(inode, btnc, blocknr, 1 << BH_NILFS_Node);
 	if (unlikely(!bh))
 		return NULL;
@@ -75,6 +82,10 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 	struct page *page;
 	int err;
 
+	nilfs2_debug(DBG_BTNODE,
+			"i_ino %lu, blocknr %llu, pblocknr %lu, mode %d\n",
+			btnc->host->i_ino, blocknr, pblocknr, mode);
+
 	bh = nilfs_grab_buffer(inode, btnc, blocknr, 1 << BH_NILFS_Node);
 	if (unlikely(!bh))
 		return -ENOMEM;
@@ -123,6 +134,7 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 	bh->b_blocknr = blocknr; /* set back to the given block address */
 	*submit_ptr = pblocknr;
 	err = 0;
+	nilfs2_debug(DBG_BTNODE, "submit_ptr %lu\n", *submit_ptr);
 found:
 	*pbh = bh;
 
@@ -146,6 +158,10 @@ void nilfs_btnode_delete(struct buffer_head *bh)
 	pgoff_t index = page_index(page);
 	int still_dirty;
 
+	nilfs2_debug(DBG_BTNODE,
+			"i_ino %lu, bh->blocknr %lu\n",
+			page->mapping->host->i_ino, bh->b_blocknr);
+
 	page_cache_get(page);
 	lock_page(page);
 	wait_on_page_writeback(page);
@@ -178,6 +194,10 @@ int nilfs_btnode_prepare_change_key(struct address_space *btnc,
 	if (oldkey == newkey)
 		return 0;
 
+	nilfs2_debug(DBG_BTNODE,
+			"i_ino %lu, oldkey %llu, newkey %llu\n",
+			btnc->host->i_ino, ctxt->oldkey, ctxt->newkey);
+
 	obh = ctxt->bh;
 	ctxt->newbh = NULL;
 
@@ -247,6 +267,10 @@ void nilfs_btnode_commit_change_key(struct address_space *btnc,
 	if (oldkey == newkey)
 		return;
 
+	nilfs2_debug(DBG_BTNODE,
+			"i_ino %lu, oldkey %llu, newkey %llu\n",
+			btnc->host->i_ino, ctxt->oldkey, ctxt->newkey);
+
 	if (nbh == NULL) {	/* blocksize == pagesize */
 		opage = obh->b_page;
 		if (unlikely(oldkey != opage->index))
@@ -287,6 +311,10 @@ void nilfs_btnode_abort_change_key(struct address_space *btnc,
 	if (oldkey == newkey)
 		return;
 
+	nilfs2_debug(DBG_BTNODE,
+			"i_ino %lu, oldkey %llu, newkey %llu\n",
+			btnc->host->i_ino, ctxt->oldkey, ctxt->newkey);
+
 	if (nbh == NULL) {	/* blocksize == pagesize */
 		spin_lock_irq(&btnc->tree_lock);
 		radix_tree_delete(&btnc->page_tree, newkey);
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index b2e3ff3..44e8ce0 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -177,6 +177,10 @@ static void nilfs_btree_node_init(struct nilfs_btree_node *node, int flags,
 	__le64 *dptrs;
 	int i;
 
+	nilfs2_debug(DBG_BTREE,
+		"node %p, flags %d, level %d, nchildren %d, ncmax %d\n",
+		node, flags, level, nchildren, ncmax);
+
 	nilfs_btree_node_set_flags(node, flags);
 	nilfs_btree_node_set_level(node, level);
 	nilfs_btree_node_set_nchildren(node, nchildren);
@@ -198,6 +202,10 @@ static void nilfs_btree_node_move_left(struct nilfs_btree_node *left,
 	__le64 *ldptrs, *rdptrs;
 	int lnchildren, rnchildren;
 
+	nilfs2_debug(DBG_BTREE,
+		"left %p, right %p, n %d, lncmax %d, rncmax %d\n",
+		left, right, n, lncmax, rncmax);
+
 	ldkeys = nilfs_btree_node_dkeys(left);
 	ldptrs = nilfs_btree_node_dptrs(left, lncmax);
 	lnchildren = nilfs_btree_node_get_nchildren(left);
@@ -226,6 +234,10 @@ static void nilfs_btree_node_move_right(struct nilfs_btree_node *left,
 	__le64 *ldptrs, *rdptrs;
 	int lnchildren, rnchildren;
 
+	nilfs2_debug(DBG_BTREE,
+		"left %p, right %p, n %d, lncmax %d, rncmax %d\n",
+		left, right, n, lncmax, rncmax);
+
 	ldkeys = nilfs_btree_node_dkeys(left);
 	ldptrs = nilfs_btree_node_dptrs(left, lncmax);
 	lnchildren = nilfs_btree_node_get_nchildren(left);
@@ -253,6 +265,10 @@ static void nilfs_btree_node_insert(struct nilfs_btree_node *node, int index,
 	__le64 *dptrs;
 	int nchildren;
 
+	nilfs2_debug(DBG_BTREE,
+		"node %p, index %d, key %llu, ptr %llu, ncmax %d\n",
+		node, index, key, ptr, ncmax);
+
 	dkeys = nilfs_btree_node_dkeys(node);
 	dptrs = nilfs_btree_node_dptrs(node, ncmax);
 	nchildren = nilfs_btree_node_get_nchildren(node);
@@ -278,6 +294,10 @@ static void nilfs_btree_node_delete(struct nilfs_btree_node *node, int index,
 	__le64 *dptrs;
 	int nchildren;
 
+	nilfs2_debug(DBG_BTREE,
+		"node %p, index %d, keyp %p, ptrp %p, ncmax %d\n",
+		node, index, keyp, ptrp, ncmax);
+
 	dkeys = nilfs_btree_node_dkeys(node);
 	dptrs = nilfs_btree_node_dptrs(node, ncmax);
 	key = le64_to_cpu(dkeys[index]);
@@ -296,6 +316,8 @@ static void nilfs_btree_node_delete(struct nilfs_btree_node *node, int index,
 	}
 	nchildren--;
 	nilfs_btree_node_set_nchildren(node, nchildren);
+
+	nilfs2_debug(DBG_BTREE, "key %llu, ptr %llu\n", key, ptr);
 }
 
 static int nilfs_btree_node_lookup(const struct nilfs_btree_node *node,
@@ -304,6 +326,10 @@ static int nilfs_btree_node_lookup(const struct nilfs_btree_node *node,
 	__u64 nkey;
 	int index, low, high, s;
 
+	nilfs2_debug(DBG_BTREE,
+		"node %p, key %llu, indexp %p\n",
+		node, key, indexp);
+
 	/* binary search */
 	low = 0;
 	high = nilfs_btree_node_get_nchildren(node) - 1;
@@ -333,6 +359,7 @@ static int nilfs_btree_node_lookup(const struct nilfs_btree_node *node,
 
  out:
 	*indexp = index;
+	nilfs2_debug(DBG_BTREE, "index %d\n", index);
 
 	return s == 0;
 }
@@ -512,6 +539,10 @@ static int nilfs_btree_do_lookup(const struct nilfs_bmap *btree,
 	__u64 ptr;
 	int level, index, found, ncmax, ret;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, path %p, key %llu, ptrp %p, minlevel %d, ra %d\n",
+		btree->b_inode->i_ino, path, key, ptrp, minlevel, readahead);
+
 	node = nilfs_btree_get_root(btree);
 	level = nilfs_btree_node_get_level(node);
 	if (level < minlevel || nilfs_btree_node_get_nchildren(node) <= 0)
@@ -558,8 +589,10 @@ static int nilfs_btree_do_lookup(const struct nilfs_bmap *btree,
 	if (!found)
 		return -ENOENT;
 
-	if (ptrp != NULL)
+	if (ptrp != NULL) {
 		*ptrp = ptr;
+		nilfs2_debug(DBG_BTREE, "ptr %llu\n", ptr);
+	}
 
 	return 0;
 }
@@ -572,6 +605,10 @@ static int nilfs_btree_do_lookup_last(const struct nilfs_bmap *btree,
 	__u64 ptr;
 	int index, level, ncmax, ret;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, path %p, keyp %p, ptrp %p\n",
+		btree->b_inode->i_ino, path, keyp, ptrp);
+
 	node = nilfs_btree_get_root(btree);
 	index = nilfs_btree_node_get_nchildren(node) - 1;
 	if (index < 0)
@@ -595,10 +632,14 @@ static int nilfs_btree_do_lookup_last(const struct nilfs_bmap *btree,
 		path[level].bp_index = index;
 	}
 
-	if (keyp != NULL)
+	if (keyp != NULL) {
 		*keyp = nilfs_btree_node_get_key(node, index);
-	if (ptrp != NULL)
+		nilfs2_debug(DBG_BTREE, "key %llu\n", *keyp);
+	}
+	if (ptrp != NULL) {
 		*ptrp = ptr;
+		nilfs2_debug(DBG_BTREE, "ptr %llu\n", ptr);
+	}
 
 	return 0;
 }
@@ -609,6 +650,10 @@ static int nilfs_btree_lookup(const struct nilfs_bmap *btree,
 	struct nilfs_btree_path *path;
 	int ret;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, key %llu, level %d, ptrp %p\n",
+		btree->b_inode->i_ino, key, level, ptrp);
+
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
@@ -632,6 +677,10 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *btree,
 	int ret, cnt, index, maxlevel, ncmax;
 	struct nilfs_btree_readahead_info p;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, key %llu, ptrp %p, maxblocks %u\n",
+		btree->b_inode->i_ino, key, ptrp, maxblocks);
+
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
@@ -698,6 +747,7 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *btree,
 	}
  end:
 	*ptrp = ptr;
+	nilfs2_debug(DBG_BTREE, "ptr %llu\n", ptr);
 	ret = cnt;
  out:
 	nilfs_btree_free_path(path);
@@ -733,6 +783,10 @@ static void nilfs_btree_do_insert(struct nilfs_bmap *btree,
 	struct nilfs_btree_node *node;
 	int ncblk;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
+		btree->b_inode->i_ino, level, keyp, ptrp);
+
 	if (level < nilfs_btree_height(btree) - 1) {
 		node = nilfs_btree_get_nonroot_node(path, level);
 		ncblk = nilfs_btree_nchildren_per_block(btree);
@@ -760,6 +814,10 @@ static void nilfs_btree_carry_left(struct nilfs_bmap *btree,
 	struct nilfs_btree_node *node, *left;
 	int nchildren, lnchildren, n, move, ncblk;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
+		btree->b_inode->i_ino, level, keyp, ptrp);
+
 	node = nilfs_btree_get_nonroot_node(path, level);
 	left = nilfs_btree_get_sib_node(path, level);
 	nchildren = nilfs_btree_node_get_nchildren(node);
@@ -806,6 +864,10 @@ static void nilfs_btree_carry_right(struct nilfs_bmap *btree,
 	struct nilfs_btree_node *node, *right;
 	int nchildren, rnchildren, n, move, ncblk;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
+		btree->b_inode->i_ino, level, keyp, ptrp);
+
 	node = nilfs_btree_get_nonroot_node(path, level);
 	right = nilfs_btree_get_sib_node(path, level);
 	nchildren = nilfs_btree_node_get_nchildren(node);
@@ -855,6 +917,10 @@ static void nilfs_btree_split(struct nilfs_bmap *btree,
 	__u64 newptr;
 	int nchildren, n, move, ncblk;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
+		btree->b_inode->i_ino, level, keyp, ptrp);
+
 	node = nilfs_btree_get_nonroot_node(path, level);
 	right = nilfs_btree_get_sib_node(path, level);
 	nchildren = nilfs_btree_node_get_nchildren(node);
@@ -908,6 +974,10 @@ static void nilfs_btree_grow(struct nilfs_bmap *btree,
 	struct nilfs_btree_node *root, *child;
 	int n, ncblk;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
+		btree->b_inode->i_ino, level, keyp, ptrp);
+
 	root = nilfs_btree_get_root(btree);
 	child = nilfs_btree_get_sib_node(path, level);
 	ncblk = nilfs_btree_nchildren_per_block(btree);
@@ -990,6 +1060,10 @@ static int nilfs_btree_prepare_insert(struct nilfs_bmap *btree,
 	int pindex, level, ncmax, ncblk, ret;
 	struct inode *dat = NULL;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, levelp %p, key %llu, ptr %llu, stats %p\n",
+		btree->b_inode->i_ino, levelp, key, ptr, stats);
+
 	stats->bs_nblocks = 0;
 	level = NILFS_BTREE_LEVEL_DATA;
 
@@ -1135,6 +1209,10 @@ static void nilfs_btree_commit_insert(struct nilfs_bmap *btree,
 	struct inode *dat = NULL;
 	int level;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, maxlevel %d, key %llu, ptr %llu\n",
+		btree->b_inode->i_ino, maxlevel, key, ptr);
+
 	set_buffer_nilfs_volatile((struct buffer_head *)((unsigned long)ptr));
 	ptr = path[NILFS_BTREE_LEVEL_DATA].bp_newreq.bpr_ptr;
 	if (NILFS_BMAP_USE_VBN(btree)) {
@@ -1158,6 +1236,10 @@ static int nilfs_btree_insert(struct nilfs_bmap *btree, __u64 key, __u64 ptr)
 	struct nilfs_bmap_stats stats;
 	int level, ret;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, key %llu, ptr %llu\n",
+		btree->b_inode->i_ino, key, ptr);
+
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
@@ -1188,6 +1270,10 @@ static void nilfs_btree_do_delete(struct nilfs_bmap *btree,
 	struct nilfs_btree_node *node;
 	int ncblk;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
+		btree->b_inode->i_ino, level, keyp, ptrp);
+
 	if (level < nilfs_btree_height(btree) - 1) {
 		node = nilfs_btree_get_nonroot_node(path, level);
 		ncblk = nilfs_btree_nchildren_per_block(btree);
@@ -1213,6 +1299,10 @@ static void nilfs_btree_borrow_left(struct nilfs_bmap *btree,
 	struct nilfs_btree_node *node, *left;
 	int nchildren, lnchildren, n, ncblk;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
+		btree->b_inode->i_ino, level, keyp, ptrp);
+
 	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
 
 	node = nilfs_btree_get_nonroot_node(path, level);
@@ -1245,6 +1335,10 @@ static void nilfs_btree_borrow_right(struct nilfs_bmap *btree,
 	struct nilfs_btree_node *node, *right;
 	int nchildren, rnchildren, n, ncblk;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
+		btree->b_inode->i_ino, level, keyp, ptrp);
+
 	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
 
 	node = nilfs_btree_get_nonroot_node(path, level);
@@ -1278,6 +1372,10 @@ static void nilfs_btree_concat_left(struct nilfs_bmap *btree,
 	struct nilfs_btree_node *node, *left;
 	int n, ncblk;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
+		btree->b_inode->i_ino, level, keyp, ptrp);
+
 	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
 
 	node = nilfs_btree_get_nonroot_node(path, level);
@@ -1304,6 +1402,10 @@ static void nilfs_btree_concat_right(struct nilfs_bmap *btree,
 	struct nilfs_btree_node *node, *right;
 	int n, ncblk;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
+		btree->b_inode->i_ino, level, keyp, ptrp);
+
 	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
 
 	node = nilfs_btree_get_nonroot_node(path, level);
@@ -1329,6 +1431,10 @@ static void nilfs_btree_shrink(struct nilfs_bmap *btree,
 	struct nilfs_btree_node *root, *child;
 	int n, ncblk;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
+		btree->b_inode->i_ino, level, keyp, ptrp);
+
 	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
 
 	root = nilfs_btree_get_root(btree);
@@ -1363,6 +1469,10 @@ static int nilfs_btree_prepare_delete(struct nilfs_bmap *btree,
 	__u64 sibptr;
 	int pindex, dindex, level, ncmin, ncmax, ncblk, ret;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, levelp %p, stats %p, dat %p\n",
+		btree->b_inode->i_ino, levelp, stats, dat);
+
 	ret = 0;
 	stats->bs_nblocks = 0;
 	ncmin = NILFS_BTREE_NODE_NCHILDREN_MIN(nilfs_btree_node_size(btree));
@@ -1493,6 +1603,10 @@ static void nilfs_btree_commit_delete(struct nilfs_bmap *btree,
 {
 	int level;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, maxlevel %d, dat %p\n",
+		btree->b_inode->i_ino, maxlevel, dat);
+
 	for (level = NILFS_BTREE_LEVEL_NODE_MIN; level <= maxlevel; level++) {
 		nilfs_bmap_commit_end_ptr(btree, &path[level].bp_oldreq, dat);
 		path[level].bp_op(btree, path, level, NULL, NULL);
@@ -1510,6 +1624,10 @@ static int nilfs_btree_delete(struct nilfs_bmap *btree, __u64 key)
 	struct inode *dat;
 	int level, ret;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, key %llu\n",
+		btree->b_inode->i_ino, key);
+
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
@@ -1538,6 +1656,10 @@ static int nilfs_btree_last_key(const struct nilfs_bmap *btree, __u64 *keyp)
 	struct nilfs_btree_path *path;
 	int ret;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, keyp %p\n",
+		btree->b_inode->i_ino, keyp);
+
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
@@ -1557,6 +1679,10 @@ static int nilfs_btree_check_delete(struct nilfs_bmap *btree, __u64 key)
 	__u64 ptr;
 	int nchildren, ret;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, key %llu\n",
+		btree->b_inode->i_ino, key);
+
 	root = nilfs_btree_get_root(btree);
 	switch (nilfs_btree_height(btree)) {
 	case 2:
@@ -1598,6 +1724,10 @@ static int nilfs_btree_gather_data(struct nilfs_bmap *btree,
 	__u64 ptr;
 	int nchildren, ncmax, i, ret;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, keys %p, ptrs %p, nitems %d\n",
+		btree->b_inode->i_ino, keys, ptrs, nitems);
+
 	root = nilfs_btree_get_root(btree);
 	switch (nilfs_btree_height(btree)) {
 	case 2:
@@ -1648,6 +1778,10 @@ nilfs_btree_prepare_convert_and_insert(struct nilfs_bmap *btree, __u64 key,
 	struct inode *dat = NULL;
 	int ret;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, key %llu, dreq %p, nreq %p, bhp %p, stats %p\n",
+		btree->b_inode->i_ino, key, dreq, nreq, bhp, stats);
+
 	stats->bs_nblocks = 0;
 
 	/* for data */
@@ -1704,6 +1838,11 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *btree,
 	__u64 tmpptr;
 	int ncblk;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, key %llu, ptr %llu, keys %p,"
+		" ptrs %p, n %d, dreq %p, nreq %p, bh %p\n",
+		btree->b_inode->i_ino, key, ptr, keys, ptrs, n, dreq, nreq, bh);
+
 	/* free resources */
 	if (btree->b_ops->bop_clear != NULL)
 		btree->b_ops->bop_clear(btree);
@@ -1772,6 +1911,10 @@ int nilfs_btree_convert_and_insert(struct nilfs_bmap *btree,
 	struct nilfs_bmap_stats stats;
 	int ret;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, key %llu, ptr %llu, keys %p, ptrs %p, n %d\n",
+		btree->b_inode->i_ino, key, ptr, keys, ptrs, n);
+
 	if (n + 1 <= NILFS_BTREE_ROOT_NCHILDREN_MAX) {
 		di = &dreq;
 		ni = NULL;
@@ -1814,6 +1957,10 @@ static int nilfs_btree_prepare_update_v(struct nilfs_bmap *btree,
 	struct nilfs_btree_node *parent;
 	int ncmax, ret;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, level %d, dat %p\n",
+		btree->b_inode->i_ino, level, dat);
+
 	parent = nilfs_btree_get_node(btree, path, level + 1, &ncmax);
 	path[level].bp_oldreq.bpr_ptr =
 		nilfs_btree_node_get_ptr(parent, path[level + 1].bp_index,
@@ -1849,6 +1996,10 @@ static void nilfs_btree_commit_update_v(struct nilfs_bmap *btree,
 	struct nilfs_btree_node *parent;
 	int ncmax;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, level %d, dat %p\n",
+		btree->b_inode->i_ino, level, dat);
+
 	nilfs_dat_commit_update(dat, &path[level].bp_oldreq.bpr_req,
 				&path[level].bp_newreq.bpr_req,
 				btree->b_ptr_type == NILFS_BMAP_PTR_VS);
@@ -1870,6 +2021,10 @@ static void nilfs_btree_abort_update_v(struct nilfs_bmap *btree,
 				       struct nilfs_btree_path *path,
 				       int level, struct inode *dat)
 {
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, level %d, dat %p\n",
+		btree->b_inode->i_ino, level, dat);
+
 	nilfs_dat_abort_update(dat, &path[level].bp_oldreq.bpr_req,
 			       &path[level].bp_newreq.bpr_req);
 	if (buffer_nilfs_node(path[level].bp_bh))
@@ -1885,6 +2040,10 @@ static int nilfs_btree_prepare_propagate_v(struct nilfs_bmap *btree,
 {
 	int level, ret;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, minlevel %d, maxlevelp %p, dat %p\n",
+		btree->b_inode->i_ino, minlevel, maxlevelp, dat);
+
 	level = minlevel;
 	if (!buffer_nilfs_volatile(path[level].bp_bh)) {
 		ret = nilfs_btree_prepare_update_v(btree, path, level, dat);
@@ -1921,6 +2080,10 @@ static void nilfs_btree_commit_propagate_v(struct nilfs_bmap *btree,
 {
 	int level;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, minlevel %d, maxlevel %d, bh %p, dat %p\n",
+		btree->b_inode->i_ino, minlevel, maxlevel, bh, dat);
+
 	if (!buffer_nilfs_volatile(path[minlevel].bp_bh))
 		nilfs_btree_commit_update_v(btree, path, minlevel, dat);
 
@@ -1938,6 +2101,10 @@ static int nilfs_btree_propagate_v(struct nilfs_bmap *btree,
 	__u64 ptr;
 	int ncmax;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, level %d, bh %p\n",
+		btree->b_inode->i_ino, level, bh);
+
 	get_bh(bh);
 	path[level].bp_bh = bh;
 	ret = nilfs_btree_prepare_propagate_v(btree, path, level, &maxlevel,
@@ -1971,6 +2138,10 @@ static int nilfs_btree_propagate(struct nilfs_bmap *btree,
 	__u64 key;
 	int level, ret;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, bh %p\n",
+		btree->b_inode->i_ino, bh);
+
 	WARN_ON(!buffer_dirty(bh));
 
 	path = nilfs_btree_alloc_path();
@@ -2020,6 +2191,10 @@ static void nilfs_btree_add_dirty_buffer(struct nilfs_bmap *btree,
 	__u64 key, ckey;
 	int level;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, lists %p, bh %p\n",
+		btree->b_inode->i_ino, lists, bh);
+
 	get_bh(bh);
 	node = (struct nilfs_btree_node *)bh->b_data;
 	key = nilfs_btree_node_get_key(node, 0);
@@ -2056,6 +2231,10 @@ static void nilfs_btree_lookup_dirty_buffers(struct nilfs_bmap *btree,
 	pgoff_t index = 0;
 	int level, i;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, listp %p\n",
+		btree->b_inode->i_ino, listp);
+
 	for (level = NILFS_BTREE_LEVEL_NODE_MIN;
 	     level < NILFS_BTREE_LEVEL_MAX;
 	     level++)
@@ -2095,6 +2274,10 @@ static int nilfs_btree_assign_p(struct nilfs_bmap *btree,
 	__u64 ptr;
 	int ncmax, ret;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, level %d, bh %p, blocknr %lu, binfo %p\n",
+		btree->b_inode->i_ino, level, bh, blocknr, binfo);
+
 	parent = nilfs_btree_get_node(btree, path, level + 1, &ncmax);
 	ptr = nilfs_btree_node_get_ptr(parent, path[level + 1].bp_index,
 				       ncmax);
@@ -2138,6 +2321,10 @@ static int nilfs_btree_assign_v(struct nilfs_bmap *btree,
 	union nilfs_bmap_ptr_req req;
 	int ncmax, ret;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, level %d, bh %p, blocknr %lu, binfo %p\n",
+		btree->b_inode->i_ino, level, bh, blocknr, binfo);
+
 	parent = nilfs_btree_get_node(btree, path, level + 1, &ncmax);
 	ptr = nilfs_btree_node_get_ptr(parent, path[level + 1].bp_index,
 				       ncmax);
@@ -2165,6 +2352,10 @@ static int nilfs_btree_assign(struct nilfs_bmap *btree,
 	__u64 key;
 	int level, ret;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, bh %p, blocknr %lu, binfo %p\n",
+		btree->b_inode->i_ino, bh, blocknr, binfo);
+
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
@@ -2203,6 +2394,10 @@ static int nilfs_btree_assign_gc(struct nilfs_bmap *btree,
 	__u64 key;
 	int ret;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, bh %p, blocknr %lu, binfo %p\n",
+		btree->b_inode->i_ino, bh, blocknr, binfo);
+
 	ret = nilfs_dat_move(nilfs_bmap_get_dat(btree), (*bh)->b_blocknr,
 			     blocknr);
 	if (ret < 0)
@@ -2228,6 +2423,10 @@ static int nilfs_btree_mark(struct nilfs_bmap *btree, __u64 key, int level)
 	__u64 ptr;
 	int ret;
 
+	nilfs2_debug(DBG_BTREE,
+		"btree ino %lu, key %llu, level %d\n",
+		btree->b_inode->i_ino, key, level);
+
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
 		return -ENOMEM;
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 82f4865..51f8dcf 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -50,12 +50,18 @@ static int nilfs_direct_lookup(const struct nilfs_bmap *direct,
 {
 	__u64 ptr;
 
+	nilfs2_debug(DBG_DIRECT,
+			"i_ino %lu, key %llu, level %d, ptrp %p\n",
+			direct->b_inode->i_ino, key, level, ptrp);
+
 	if (key > NILFS_DIRECT_KEY_MAX || level != 1)
 		return -ENOENT;
 	ptr = nilfs_direct_get_ptr(direct, key);
 	if (ptr == NILFS_BMAP_INVALID_PTR)
 		return -ENOENT;
 
+	nilfs2_debug(DBG_DIRECT, "ptr %llu\n", ptr);
+
 	*ptrp = ptr;
 	return 0;
 }
@@ -69,6 +75,10 @@ static int nilfs_direct_lookup_contig(const struct nilfs_bmap *direct,
 	sector_t blocknr;
 	int ret, cnt;
 
+	nilfs2_debug(DBG_DIRECT,
+			"i_ino %lu, key %llu, ptrp %p, maxblocks %u\n",
+			direct->b_inode->i_ino, key, ptrp, maxblocks);
+
 	if (key > NILFS_DIRECT_KEY_MAX)
 		return -ENOENT;
 	ptr = nilfs_direct_get_ptr(direct, key);
@@ -97,6 +107,9 @@ static int nilfs_direct_lookup_contig(const struct nilfs_bmap *direct,
 		if (ptr2 != ptr + cnt)
 			break;
 	}
+
+	nilfs2_debug(DBG_DIRECT, "ptr %llu\n", ptr);
+
 	*ptrp = ptr;
 	return cnt;
 }
@@ -106,6 +119,10 @@ nilfs_direct_find_target_v(const struct nilfs_bmap *direct, __u64 key)
 {
 	__u64 ptr;
 
+	nilfs2_debug(DBG_DIRECT,
+			"i_ino %lu, key %llu\n",
+			direct->b_inode->i_ino, key);
+
 	ptr = nilfs_bmap_find_target_seq(direct, key);
 	if (ptr != NILFS_BMAP_INVALID_PTR)
 		/* sequential access */
@@ -122,6 +139,10 @@ static int nilfs_direct_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
 	struct buffer_head *bh;
 	int ret;
 
+	nilfs2_debug(DBG_DIRECT,
+			"i_ino %lu, key %llu, ptr %llu\n",
+			bmap->b_inode->i_ino, key, ptr);
+
 	if (key > NILFS_DIRECT_KEY_MAX)
 		return -ENOENT;
 	if (nilfs_direct_get_ptr(bmap, key) != NILFS_BMAP_INVALID_PTR)
@@ -157,6 +178,10 @@ static int nilfs_direct_delete(struct nilfs_bmap *bmap, __u64 key)
 	struct inode *dat;
 	int ret;
 
+	nilfs2_debug(DBG_DIRECT,
+			"i_ino %lu, key %llu\n",
+			bmap->b_inode->i_ino, key);
+
 	if (key > NILFS_DIRECT_KEY_MAX ||
 	    nilfs_direct_get_ptr(bmap, key) == NILFS_BMAP_INVALID_PTR)
 		return -ENOENT;
@@ -203,6 +228,10 @@ static int nilfs_direct_gather_data(struct nilfs_bmap *direct,
 	__u64 ptr;
 	int n;
 
+	nilfs2_debug(DBG_DIRECT,
+			"i_ino %lu, keys %p, ptrs %p, nitems %d\n",
+			direct->b_inode->i_ino, keys, ptrs, nitems);
+
 	if (nitems > NILFS_DIRECT_NBLOCKS)
 		nitems = NILFS_DIRECT_NBLOCKS;
 	n = 0;
@@ -223,6 +252,10 @@ int nilfs_direct_delete_and_convert(struct nilfs_bmap *bmap,
 	__le64 *dptrs;
 	int ret, i, j;
 
+	nilfs2_debug(DBG_DIRECT,
+			"i_ino %lu, keys %p, ptrs %p, n %d\n",
+			bmap->b_inode->i_ino, keys, ptrs, n);
+
 	/* no need to allocate any resource for conversion */
 
 	/* delete */
@@ -259,6 +292,10 @@ static int nilfs_direct_propagate(struct nilfs_bmap *bmap,
 	__u64 ptr;
 	int ret;
 
+	nilfs2_debug(DBG_DIRECT,
+			"i_ino %lu, bh %p\n",
+			bmap->b_inode->i_ino, bh);
+
 	if (!NILFS_BMAP_USE_VBN(bmap))
 		return 0;
 
@@ -291,6 +328,11 @@ static int nilfs_direct_assign_v(struct nilfs_bmap *direct,
 	union nilfs_bmap_ptr_req req;
 	int ret;
 
+	nilfs2_debug(DBG_DIRECT,
+			"i_ino %lu, key %llu, ptr %llu, "
+			"bh %p, blocknr %lu, binfo %p\n",
+			direct->b_inode->i_ino, key, ptr, bh, blocknr, binfo);
+
 	req.bpr_ptr = ptr;
 	ret = nilfs_dat_prepare_start(dat, &req.bpr_req);
 	if (!ret) {
@@ -307,6 +349,11 @@ static int nilfs_direct_assign_p(struct nilfs_bmap *direct,
 				 sector_t blocknr,
 				 union nilfs_binfo *binfo)
 {
+	nilfs2_debug(DBG_DIRECT,
+			"i_ino %lu, key %llu, ptr %llu, "
+			"bh %p, blocknr %lu, binfo %p\n",
+			direct->b_inode->i_ino, key, ptr, bh, blocknr, binfo);
+
 	nilfs_direct_set_ptr(direct, key, blocknr);
 
 	binfo->bi_dat.bi_blkoff = cpu_to_le64(key);
@@ -323,6 +370,10 @@ static int nilfs_direct_assign(struct nilfs_bmap *bmap,
 	__u64 key;
 	__u64 ptr;
 
+	nilfs2_debug(DBG_DIRECT,
+			"i_ino %lu, bh %p, blocknr %lu, binfo %p\n",
+			bmap->b_inode->i_ino, bh, blocknr, binfo);
+
 	key = nilfs_bmap_data_get_key(bmap, *bh);
 	if (unlikely(key > NILFS_DIRECT_KEY_MAX)) {
 		printk(KERN_CRIT "%s: invalid key: %llu\n", __func__,
-- 
1.7.9.5



