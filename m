From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 21/24] nilfs2: implement hexdump of internal structures
 option
Date: Mon, 17 Jun 2013 16:26:28 +0400
Message-ID: <1371471988.2075.153.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=ion2TWCzZXJz3d921L+XWlgnCjrQVdEOnk9bUSO1nDY=;
	b=YDQKFa3JckVOe+X3NH0UmHA7tzpaub8Xqr4HN3mwUjNvECpAQSsFEhQCax7mxOjrRBsNckmOucsZ3ZOQuwU5H7F+S8GaLXsSNWK7Mhznk/w8OycVZHWG3eE8QOdVx8BN;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 21/24] nilfs2: implement hexdump of internal structures option

This patch implements DBG_HEX_DUMP flag using. This flag requests writing
in system log hexdumps of internal structures.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.c     |  126 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/cpfile.c    |   10 ++++
 fs/nilfs2/dat.c       |    5 ++
 fs/nilfs2/direct.c    |   28 +++++++++++
 fs/nilfs2/ifile.c     |    2 +
 fs/nilfs2/inode.c     |    5 ++
 fs/nilfs2/recovery.c  |   20 ++++++++
 fs/nilfs2/segment.c   |   84 +++++++++++++++++++++++++++++++++
 fs/nilfs2/sufile.c    |    6 +++
 fs/nilfs2/the_nilfs.c |    2 +
 10 files changed, 288 insertions(+)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 9116be3..bf297ba 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -75,6 +75,8 @@ static int nilfs_btree_get_new_block(const struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK | DBG_SPAM),
 			"i_ino %lu, ptr %llu\n",
 			btnc->host->i_ino, ptr);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP | DBG_SPAM),
+			"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	bh = nilfs_btnode_create_block(btnc, ptr);
 	if (!bh)
@@ -184,6 +186,10 @@ static void nilfs_btree_node_init(struct nilfs_btree_node *node, int flags,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"node %p, flags %d, level %d, nchildren %d, ncmax %d\n",
 		node, flags, level, nchildren, ncmax);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+			"keys: ", keys, nchildren * sizeof(__u64));
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+			"ptrs: ", ptrs, nchildren * sizeof(__u64));
 
 	nilfs_btree_node_set_flags(node, flags);
 	nilfs_btree_node_set_level(node, level);
@@ -195,6 +201,9 @@ static void nilfs_btree_node_init(struct nilfs_btree_node *node, int flags,
 		dkeys[i] = cpu_to_le64(keys[i]);
 		dptrs[i] = cpu_to_le64(ptrs[i]);
 	}
+
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+			"node: ", node, sizeof(struct nilfs_btree_node));
 }
 
 /* Assume the buffer heads corresponding to left and right are locked. */
@@ -209,6 +218,10 @@ static void nilfs_btree_node_move_left(struct nilfs_btree_node *left,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"left %p, right %p, n %d, lncmax %d, rncmax %d\n",
 		left, right, n, lncmax, rncmax);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"left node: ", left, sizeof(struct nilfs_btree_node));
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"right node: ", right, sizeof(struct nilfs_btree_node));
 
 	ldkeys = nilfs_btree_node_dkeys(left);
 	ldptrs = nilfs_btree_node_dptrs(left, lncmax);
@@ -241,6 +254,10 @@ static void nilfs_btree_node_move_right(struct nilfs_btree_node *left,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"left %p, right %p, n %d, lncmax %d, rncmax %d\n",
 		left, right, n, lncmax, rncmax);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"left node: ", left, sizeof(struct nilfs_btree_node));
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"right node: ", right, sizeof(struct nilfs_btree_node));
 
 	ldkeys = nilfs_btree_node_dkeys(left);
 	ldptrs = nilfs_btree_node_dptrs(left, lncmax);
@@ -286,6 +303,9 @@ static void nilfs_btree_node_insert(struct nilfs_btree_node *node, int index,
 	dptrs[index] = cpu_to_le64(ptr);
 	nchildren++;
 	nilfs_btree_node_set_nchildren(node, nchildren);
+
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"node: ", node, sizeof(struct nilfs_btree_node));
 }
 
 /* Assume that the buffer head corresponding to node is locked. */
@@ -322,6 +342,8 @@ static void nilfs_btree_node_delete(struct nilfs_btree_node *node, int index,
 	nilfs_btree_node_set_nchildren(node, nchildren);
 
 	nilfs2_debug(DBG_BTREE, "key %llu, ptr %llu\n", key, ptr);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"node: ", node, sizeof(struct nilfs_btree_node));
 }
 
 static int nilfs_btree_node_lookup(const struct nilfs_btree_node *node,
@@ -333,6 +355,8 @@ static int nilfs_btree_node_lookup(const struct nilfs_btree_node *node,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"node %p, key %llu, indexp %p\n",
 		node, key, indexp);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"node: ", node, sizeof(struct nilfs_btree_node));
 
 	/* binary search */
 	low = 0;
@@ -484,6 +508,8 @@ static int __nilfs_btree_get_block(const struct nilfs_bmap *btree, __u64 ptr,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK | DBG_SPAM),
 		"btree ino %lu, ptr %llu, bhp %p, ra %p\n",
 		btree->b_inode->i_ino, ptr, bhp, ra);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP | DBG_SPAM),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	ret = nilfs_btnode_submit_block(btnc, ptr, 0, READ, &bh, &submit_ptr);
 	if (ret) {
@@ -550,6 +576,8 @@ static int nilfs_btree_do_lookup(const struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, path %p, key %llu, ptrp %p, minlevel %d, ra %d\n",
 		btree->b_inode->i_ino, path, key, ptrp, minlevel, readahead);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	node = nilfs_btree_get_root(btree);
 	level = nilfs_btree_node_get_level(node);
@@ -616,6 +644,8 @@ static int nilfs_btree_do_lookup_last(const struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, path %p, keyp %p, ptrp %p\n",
 		btree->b_inode->i_ino, path, keyp, ptrp);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	node = nilfs_btree_get_root(btree);
 	index = nilfs_btree_node_get_nchildren(node) - 1;
@@ -661,6 +691,8 @@ static int nilfs_btree_lookup(const struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, key %llu, level %d, ptrp %p\n",
 		btree->b_inode->i_ino, key, level, ptrp);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
@@ -688,6 +720,8 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, key %llu, ptrp %p, maxblocks %u\n",
 		btree->b_inode->i_ino, key, ptrp, maxblocks);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
@@ -769,6 +803,8 @@ static void nilfs_btree_promote_key(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK | DBG_SPAM),
 		"btree ino %lu, level %d, key %llu\n",
 		btree->b_inode->i_ino, level, key);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP | DBG_SPAM),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	if (level < nilfs_btree_height(btree) - 1) {
 		do {
@@ -798,6 +834,8 @@ static void nilfs_btree_do_insert(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
 		btree->b_inode->i_ino, level, keyp, ptrp);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	if (level < nilfs_btree_height(btree) - 1) {
 		node = nilfs_btree_get_nonroot_node(path, level);
@@ -829,6 +867,8 @@ static void nilfs_btree_carry_left(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
 		btree->b_inode->i_ino, level, keyp, ptrp);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	node = nilfs_btree_get_nonroot_node(path, level);
 	left = nilfs_btree_get_sib_node(path, level);
@@ -879,6 +919,8 @@ static void nilfs_btree_carry_right(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
 		btree->b_inode->i_ino, level, keyp, ptrp);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	node = nilfs_btree_get_nonroot_node(path, level);
 	right = nilfs_btree_get_sib_node(path, level);
@@ -932,6 +974,8 @@ static void nilfs_btree_split(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
 		btree->b_inode->i_ino, level, keyp, ptrp);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	node = nilfs_btree_get_nonroot_node(path, level);
 	right = nilfs_btree_get_sib_node(path, level);
@@ -989,6 +1033,8 @@ static void nilfs_btree_grow(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
 		btree->b_inode->i_ino, level, keyp, ptrp);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	root = nilfs_btree_get_root(btree);
 	child = nilfs_btree_get_sib_node(path, level);
@@ -1020,6 +1066,8 @@ static __u64 nilfs_btree_find_near(const struct nilfs_bmap *btree,
 
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK | DBG_SPAM),
 			"btree ino %lu\n", btree->b_inode->i_ino);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP | DBG_SPAM),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	if (path == NULL)
 		return NILFS_BMAP_INVALID_PTR;
@@ -1053,6 +1101,8 @@ static __u64 nilfs_btree_find_target_v(const struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK | DBG_SPAM),
 		"btree ino %lu, key %llu\n",
 		btree->b_inode->i_ino, key);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP | DBG_SPAM),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	ptr = nilfs_bmap_find_target_seq(btree, key);
 	if (ptr != NILFS_BMAP_INVALID_PTR)
@@ -1082,6 +1132,10 @@ static int nilfs_btree_prepare_insert(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, levelp %p, key %llu, ptr %llu, stats %p\n",
 		btree->b_inode->i_ino, levelp, key, ptr, stats);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"stats: ", stats, sizeof(struct nilfs_bmap_stats));
 
 	stats->bs_nblocks = 0;
 	level = NILFS_BTREE_LEVEL_DATA;
@@ -1231,6 +1285,8 @@ static void nilfs_btree_commit_insert(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, maxlevel %d, key %llu, ptr %llu\n",
 		btree->b_inode->i_ino, maxlevel, key, ptr);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	set_buffer_nilfs_volatile((struct buffer_head *)((unsigned long)ptr));
 	ptr = path[NILFS_BTREE_LEVEL_DATA].bp_newreq.bpr_ptr;
@@ -1258,6 +1314,8 @@ static int nilfs_btree_insert(struct nilfs_bmap *btree, __u64 key, __u64 ptr)
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, key %llu, ptr %llu\n",
 		btree->b_inode->i_ino, key, ptr);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
@@ -1292,6 +1350,8 @@ static void nilfs_btree_do_delete(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
 		btree->b_inode->i_ino, level, keyp, ptrp);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	if (level < nilfs_btree_height(btree) - 1) {
 		node = nilfs_btree_get_nonroot_node(path, level);
@@ -1321,6 +1381,8 @@ static void nilfs_btree_borrow_left(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
 		btree->b_inode->i_ino, level, keyp, ptrp);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
 
@@ -1357,6 +1419,8 @@ static void nilfs_btree_borrow_right(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
 		btree->b_inode->i_ino, level, keyp, ptrp);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
 
@@ -1394,6 +1458,8 @@ static void nilfs_btree_concat_left(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
 		btree->b_inode->i_ino, level, keyp, ptrp);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
 
@@ -1424,6 +1490,8 @@ static void nilfs_btree_concat_right(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
 		btree->b_inode->i_ino, level, keyp, ptrp);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
 
@@ -1453,6 +1521,8 @@ static void nilfs_btree_shrink(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, level %d, keyp %p, ptrp %p\n",
 		btree->b_inode->i_ino, level, keyp, ptrp);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	nilfs_btree_do_delete(btree, path, level, keyp, ptrp);
 
@@ -1491,6 +1561,10 @@ static int nilfs_btree_prepare_delete(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, levelp %p, stats %p, dat %p\n",
 		btree->b_inode->i_ino, levelp, stats, dat);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"stats: ", stats, sizeof(struct nilfs_bmap_stats));
 
 	ret = 0;
 	stats->bs_nblocks = 0;
@@ -1646,6 +1720,8 @@ static int nilfs_btree_delete(struct nilfs_bmap *btree, __u64 key)
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, key %llu\n",
 		btree->b_inode->i_ino, key);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
@@ -1678,6 +1754,8 @@ static int nilfs_btree_last_key(const struct nilfs_bmap *btree, __u64 *keyp)
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, keyp %p\n",
 		btree->b_inode->i_ino, keyp);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
@@ -1701,6 +1779,8 @@ static int nilfs_btree_check_delete(struct nilfs_bmap *btree, __u64 key)
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, key %llu\n",
 		btree->b_inode->i_ino, key);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	root = nilfs_btree_get_root(btree);
 	switch (nilfs_btree_height(btree)) {
@@ -1746,6 +1826,8 @@ static int nilfs_btree_gather_data(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, keys %p, ptrs %p, nitems %d\n",
 		btree->b_inode->i_ino, keys, ptrs, nitems);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	root = nilfs_btree_get_root(btree);
 	switch (nilfs_btree_height(btree)) {
@@ -1800,6 +1882,10 @@ nilfs_btree_prepare_convert_and_insert(struct nilfs_bmap *btree, __u64 key,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, key %llu, dreq %p, nreq %p, bhp %p, stats %p\n",
 		btree->b_inode->i_ino, key, dreq, nreq, bhp, stats);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"stats: ", stats, sizeof(struct nilfs_bmap_stats));
 
 	stats->bs_nblocks = 0;
 
@@ -1861,6 +1947,8 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *btree,
 		"btree ino %lu, key %llu, ptr %llu, keys %p,"
 		" ptrs %p, n %d, dreq %p, nreq %p, bh %p\n",
 		btree->b_inode->i_ino, key, ptr, keys, ptrs, n, dreq, nreq, bh);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	/* free resources */
 	if (btree->b_ops->bop_clear != NULL)
@@ -1933,6 +2021,8 @@ int nilfs_btree_convert_and_insert(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, key %llu, ptr %llu, keys %p, ptrs %p, n %d\n",
 		btree->b_inode->i_ino, key, ptr, keys, ptrs, n);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	if (n + 1 <= NILFS_BTREE_ROOT_NCHILDREN_MAX) {
 		di = &dreq;
@@ -1979,6 +2069,8 @@ static int nilfs_btree_prepare_update_v(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, level %d, dat %p\n",
 		btree->b_inode->i_ino, level, dat);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	parent = nilfs_btree_get_node(btree, path, level + 1, &ncmax);
 	path[level].bp_oldreq.bpr_ptr =
@@ -2018,6 +2110,8 @@ static void nilfs_btree_commit_update_v(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, level %d, dat %p\n",
 		btree->b_inode->i_ino, level, dat);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	nilfs_dat_commit_update(dat, &path[level].bp_oldreq.bpr_req,
 				&path[level].bp_newreq.bpr_req,
@@ -2043,6 +2137,8 @@ static void nilfs_btree_abort_update_v(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, level %d, dat %p\n",
 		btree->b_inode->i_ino, level, dat);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	nilfs_dat_abort_update(dat, &path[level].bp_oldreq.bpr_req,
 			       &path[level].bp_newreq.bpr_req);
@@ -2062,6 +2158,8 @@ static int nilfs_btree_prepare_propagate_v(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, minlevel %d, maxlevelp %p, dat %p\n",
 		btree->b_inode->i_ino, minlevel, maxlevelp, dat);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	level = minlevel;
 	if (!buffer_nilfs_volatile(path[level].bp_bh)) {
@@ -2102,6 +2200,8 @@ static void nilfs_btree_commit_propagate_v(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, minlevel %d, maxlevel %d, bh %p, dat %p\n",
 		btree->b_inode->i_ino, minlevel, maxlevel, bh, dat);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	if (!buffer_nilfs_volatile(path[minlevel].bp_bh))
 		nilfs_btree_commit_update_v(btree, path, minlevel, dat);
@@ -2123,6 +2223,8 @@ static int nilfs_btree_propagate_v(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, level %d, bh %p\n",
 		btree->b_inode->i_ino, level, bh);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	get_bh(bh);
 	path[level].bp_bh = bh;
@@ -2160,6 +2262,8 @@ static int nilfs_btree_propagate(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, bh %p\n",
 		btree->b_inode->i_ino, bh);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	WARN_ON(!buffer_dirty(bh));
 
@@ -2213,6 +2317,8 @@ static void nilfs_btree_add_dirty_buffer(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, lists %p, bh %p\n",
 		btree->b_inode->i_ino, lists, bh);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	get_bh(bh);
 	node = (struct nilfs_btree_node *)bh->b_data;
@@ -2253,6 +2359,8 @@ static void nilfs_btree_lookup_dirty_buffers(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, listp %p\n",
 		btree->b_inode->i_ino, listp);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	for (level = NILFS_BTREE_LEVEL_NODE_MIN;
 	     level < NILFS_BTREE_LEVEL_MAX;
@@ -2296,6 +2404,10 @@ static int nilfs_btree_assign_p(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, level %d, bh %p, blocknr %lu, binfo %p\n",
 		btree->b_inode->i_ino, level, bh, blocknr, binfo);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"binfo: ", binfo, sizeof(union nilfs_binfo));
 
 	parent = nilfs_btree_get_node(btree, path, level + 1, &ncmax);
 	ptr = nilfs_btree_node_get_ptr(parent, path[level + 1].bp_index,
@@ -2343,6 +2455,10 @@ static int nilfs_btree_assign_v(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, level %d, bh %p, blocknr %lu, binfo %p\n",
 		btree->b_inode->i_ino, level, bh, blocknr, binfo);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"binfo: ", binfo, sizeof(union nilfs_binfo));
 
 	parent = nilfs_btree_get_node(btree, path, level + 1, &ncmax);
 	ptr = nilfs_btree_node_get_ptr(parent, path[level + 1].bp_index,
@@ -2374,6 +2490,10 @@ static int nilfs_btree_assign(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, bh %p, blocknr %lu, binfo %p\n",
 		btree->b_inode->i_ino, bh, blocknr, binfo);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"binfo: ", binfo, sizeof(union nilfs_binfo));
 
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
@@ -2416,6 +2536,10 @@ static int nilfs_btree_assign_gc(struct nilfs_bmap *btree,
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, bh %p, blocknr %lu, binfo %p\n",
 		btree->b_inode->i_ino, bh, blocknr, binfo);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"binfo: ", binfo, sizeof(union nilfs_binfo));
 
 	ret = nilfs_dat_move(nilfs_bmap_get_dat(btree), (*bh)->b_blocknr,
 			     blocknr);
@@ -2445,6 +2569,8 @@ static int nilfs_btree_mark(struct nilfs_bmap *btree, __u64 key, int level)
 	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK),
 		"btree ino %lu, key %llu, level %d\n",
 		btree->b_inode->i_ino, key, level);
+	nilfs2_hexdump((DBG_BTREE | DBG_HEX_DUMP),
+		"btree: ", btree, sizeof(struct nilfs_bmap));
 
 	path = nilfs_btree_alloc_path();
 	if (path == NULL)
diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 490c839..f5231f7 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -404,6 +404,10 @@ static void nilfs_cpfile_checkpoint_to_cpinfo(struct inode *cpfile,
 	nilfs2_debug((DBG_CPFILE | DBG_DUMP_STACK),
 			"i_ino %lu, cp %p, ci %p\n",
 			cpfile->i_ino, cp, ci);
+	nilfs2_hexdump((DBG_CPFILE | DBG_HEX_DUMP),
+			"checkpoint: ", cp, sizeof(struct nilfs_checkpoint));
+	nilfs2_hexdump((DBG_CPFILE | DBG_HEX_DUMP),
+			"cpinfo: ", ci, sizeof(struct nilfs_cpinfo));
 
 	ci->ci_flags = le32_to_cpu(cp->cp_flags);
 	ci->ci_cno = le64_to_cpu(cp->cp_cno);
@@ -989,6 +993,10 @@ int nilfs_cpfile_get_stat(struct inode *cpfile, struct nilfs_cpstat *cpstat)
 
  out_sem:
 	up_read(&NILFS_MDT(cpfile)->mi_sem);
+
+	nilfs2_hexdump((DBG_CPFILE | DBG_HEX_DUMP),
+			"cpstat: ", cpstat, sizeof(struct nilfs_cpstat));
+
 	return ret;
 }
 
@@ -1008,6 +1016,8 @@ int nilfs_cpfile_read(struct super_block *sb, size_t cpsize,
 	nilfs2_debug((DBG_CPFILE | DBG_DUMP_STACK),
 			"sb %p, cpsize %zu, raw_inode %p, inodep %p\n",
 			sb, cpsize, raw_inode, inodep);
+	nilfs2_hexdump((DBG_CPFILE | DBG_HEX_DUMP),
+			"raw_inode: ", raw_inode, sizeof(struct nilfs_inode));
 
 	cpfile = nilfs_iget_locked(sb, NULL, NILFS_CPFILE_INO);
 	if (unlikely(!cpfile))
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 4b7875e..5443c6b 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -547,6 +547,9 @@ ssize_t nilfs_dat_get_vinfo(struct inode *dat, void *buf, unsigned visz,
 		brelse(entry_bh);
 	}
 
+	nilfs2_hexdump((DBG_DAT | DBG_HEX_DUMP | DBG_SPAM),
+			"vinfo: ", buf, nvi * sizeof(struct nilfs_vinfo));
+
 	return nvi;
 }
 
@@ -568,6 +571,8 @@ int nilfs_dat_read(struct super_block *sb, size_t entry_size,
 	nilfs2_debug((DBG_DAT | DBG_DUMP_STACK),
 			"sb %p, entry_size %zu, raw_inode %p, inodep %p\n",
 			sb, entry_size, raw_inode, inodep);
+	nilfs2_hexdump((DBG_DAT | DBG_HEX_DUMP),
+			"raw_inode: ", raw_inode, sizeof(struct nilfs_inode));
 
 	dat = nilfs_iget_locked(sb, NULL, NILFS_DAT_INO);
 	if (unlikely(!dat))
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 5569184..093dcb7 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -53,6 +53,8 @@ static int nilfs_direct_lookup(const struct nilfs_bmap *direct,
 	nilfs2_debug((DBG_DIRECT | DBG_DUMP_STACK),
 			"i_ino %lu, key %llu, level %d, ptrp %p\n",
 			direct->b_inode->i_ino, key, level, ptrp);
+	nilfs2_hexdump((DBG_DIRECT | DBG_HEX_DUMP),
+			"bmap: ", direct, sizeof(struct nilfs_bmap));
 
 	if (key > NILFS_DIRECT_KEY_MAX || level != 1)
 		return -ENOENT;
@@ -78,6 +80,8 @@ static int nilfs_direct_lookup_contig(const struct nilfs_bmap *direct,
 	nilfs2_debug((DBG_DIRECT | DBG_DUMP_STACK),
 			"i_ino %lu, key %llu, ptrp %p, maxblocks %u\n",
 			direct->b_inode->i_ino, key, ptrp, maxblocks);
+	nilfs2_hexdump((DBG_DIRECT | DBG_HEX_DUMP),
+			"bmap: ", direct, sizeof(struct nilfs_bmap));
 
 	if (key > NILFS_DIRECT_KEY_MAX)
 		return -ENOENT;
@@ -122,6 +126,8 @@ nilfs_direct_find_target_v(const struct nilfs_bmap *direct, __u64 key)
 	nilfs2_debug((DBG_DIRECT | DBG_DUMP_STACK),
 			"i_ino %lu, key %llu\n",
 			direct->b_inode->i_ino, key);
+	nilfs2_hexdump((DBG_DIRECT | DBG_HEX_DUMP),
+			"bmap: ", direct, sizeof(struct nilfs_bmap));
 
 	ptr = nilfs_bmap_find_target_seq(direct, key);
 	if (ptr != NILFS_BMAP_INVALID_PTR)
@@ -142,6 +148,8 @@ static int nilfs_direct_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
 	nilfs2_debug((DBG_DIRECT | DBG_DUMP_STACK),
 			"i_ino %lu, key %llu, ptr %llu\n",
 			bmap->b_inode->i_ino, key, ptr);
+	nilfs2_hexdump((DBG_DIRECT | DBG_HEX_DUMP),
+			"bmap: ", bmap, sizeof(struct nilfs_bmap));
 
 	if (key > NILFS_DIRECT_KEY_MAX)
 		return -ENOENT;
@@ -181,6 +189,8 @@ static int nilfs_direct_delete(struct nilfs_bmap *bmap, __u64 key)
 	nilfs2_debug((DBG_DIRECT | DBG_DUMP_STACK),
 			"i_ino %lu, key %llu\n",
 			bmap->b_inode->i_ino, key);
+	nilfs2_hexdump((DBG_DIRECT | DBG_HEX_DUMP),
+			"bmap: ", bmap, sizeof(struct nilfs_bmap));
 
 	if (key > NILFS_DIRECT_KEY_MAX ||
 	    nilfs_direct_get_ptr(bmap, key) == NILFS_BMAP_INVALID_PTR)
@@ -231,6 +241,8 @@ static int nilfs_direct_gather_data(struct nilfs_bmap *direct,
 	nilfs2_debug((DBG_DIRECT | DBG_DUMP_STACK),
 			"i_ino %lu, keys %p, ptrs %p, nitems %d\n",
 			direct->b_inode->i_ino, keys, ptrs, nitems);
+	nilfs2_hexdump((DBG_DIRECT | DBG_HEX_DUMP),
+			"bmap: ", direct, sizeof(struct nilfs_bmap));
 
 	if (nitems > NILFS_DIRECT_NBLOCKS)
 		nitems = NILFS_DIRECT_NBLOCKS;
@@ -255,6 +267,8 @@ int nilfs_direct_delete_and_convert(struct nilfs_bmap *bmap,
 	nilfs2_debug((DBG_DIRECT | DBG_DUMP_STACK),
 			"i_ino %lu, keys %p, ptrs %p, n %d\n",
 			bmap->b_inode->i_ino, keys, ptrs, n);
+	nilfs2_hexdump((DBG_DIRECT | DBG_HEX_DUMP),
+			"bmap: ", bmap, sizeof(struct nilfs_bmap));
 
 	/* no need to allocate any resource for conversion */
 
@@ -295,6 +309,8 @@ static int nilfs_direct_propagate(struct nilfs_bmap *bmap,
 	nilfs2_debug((DBG_DIRECT | DBG_DUMP_STACK),
 			"i_ino %lu, bh %p\n",
 			bmap->b_inode->i_ino, bh);
+	nilfs2_hexdump((DBG_DIRECT | DBG_HEX_DUMP),
+			"bmap: ", bmap, sizeof(struct nilfs_bmap));
 
 	if (!NILFS_BMAP_USE_VBN(bmap))
 		return 0;
@@ -332,6 +348,10 @@ static int nilfs_direct_assign_v(struct nilfs_bmap *direct,
 			"i_ino %lu, key %llu, ptr %llu, "
 			"bh %p, blocknr %lu, binfo %p\n",
 			direct->b_inode->i_ino, key, ptr, bh, blocknr, binfo);
+	nilfs2_hexdump((DBG_DIRECT | DBG_HEX_DUMP),
+			"bmap: ", direct, sizeof(struct nilfs_bmap));
+	nilfs2_hexdump((DBG_DIRECT | DBG_HEX_DUMP),
+			"binfo: ", binfo, sizeof(union nilfs_binfo));
 
 	req.bpr_ptr = ptr;
 	ret = nilfs_dat_prepare_start(dat, &req.bpr_req);
@@ -353,6 +373,10 @@ static int nilfs_direct_assign_p(struct nilfs_bmap *direct,
 			"i_ino %lu, key %llu, ptr %llu, "
 			"bh %p, blocknr %lu, binfo %p\n",
 			direct->b_inode->i_ino, key, ptr, bh, blocknr, binfo);
+	nilfs2_hexdump((DBG_DIRECT | DBG_HEX_DUMP),
+			"bmap: ", direct, sizeof(struct nilfs_bmap));
+	nilfs2_hexdump((DBG_DIRECT | DBG_HEX_DUMP),
+			"binfo: ", binfo, sizeof(union nilfs_binfo));
 
 	nilfs_direct_set_ptr(direct, key, blocknr);
 
@@ -373,6 +397,10 @@ static int nilfs_direct_assign(struct nilfs_bmap *bmap,
 	nilfs2_debug((DBG_DIRECT | DBG_DUMP_STACK),
 			"i_ino %lu, bh %p, blocknr %lu, binfo %p\n",
 			bmap->b_inode->i_ino, bh, blocknr, binfo);
+	nilfs2_hexdump((DBG_DIRECT | DBG_HEX_DUMP),
+			"bmap: ", bmap, sizeof(struct nilfs_bmap));
+	nilfs2_hexdump((DBG_DIRECT | DBG_HEX_DUMP),
+			"binfo: ", binfo, sizeof(union nilfs_binfo));
 
 	key = nilfs_bmap_data_get_key(bmap, *bh);
 	if (unlikely(key > NILFS_DIRECT_KEY_MAX)) {
diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index 61ebbe6..9196e28 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -190,6 +190,8 @@ int nilfs_ifile_read(struct super_block *sb, struct nilfs_root *root,
 	nilfs2_debug((DBG_IFILE | DBG_DUMP_STACK),
 		"sb %p, root %p, inode_size %zu, raw_inode %p, inodep %p\n",
 		sb, root, inode_size, raw_inode, inodep);
+	nilfs2_hexdump((DBG_IFILE | DBG_HEX_DUMP),
+			"raw_inode: ", raw_inode, sizeof(struct nilfs_inode));
 
 	ifile = nilfs_iget_locked(sb, root, NILFS_IFILE_INO);
 	if (unlikely(!ifile))
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index ca594f2..f921caf 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -511,6 +511,8 @@ int nilfs_read_inode_common(struct inode *inode,
 
 	nilfs2_debug((DBG_INODE | DBG_DUMP_STACK),
 			"i_ino %lu\n", inode->i_ino);
+	nilfs2_hexdump((DBG_INODE | DBG_HEX_DUMP),
+			"raw_inode: ", raw_inode, sizeof(struct nilfs_inode));
 
 	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
 	i_uid_write(inode, le32_to_cpu(raw_inode->i_uid));
@@ -760,6 +762,9 @@ void nilfs_write_inode_common(struct inode *inode,
 			cpu_to_le64(huge_encode_dev(inode->i_rdev));
 	/* When extending inode, nilfs->ns_inode_size should be checked
 	   for substitutions of appended fields */
+
+	nilfs2_hexdump((DBG_INODE | DBG_HEX_DUMP),
+			"raw_inode: ", raw_inode, sizeof(struct nilfs_inode));
 }
 
 void nilfs_update_inode(struct inode *inode, struct buffer_head *ibh)
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index f880f6a..40b5274 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -474,6 +474,9 @@ static int nilfs_prepare_segment_for_recovery(struct the_nilfs *nilfs,
 
 	nilfs2_debug((DBG_RECOVERY | DBG_DUMP_STACK),
 			"nilfs %p, sb %p, ri %p\n", nilfs, sb, ri);
+	nilfs2_hexdump((DBG_RECOVERY | DBG_HEX_DUMP),
+			"recovery info: ",
+			ri, sizeof(struct nilfs_recovery_info));
 
 	segnum[0] = nilfs->ns_segnum;
 	segnum[1] = nilfs->ns_nextnum;
@@ -532,6 +535,9 @@ static int nilfs_recovery_copy_block(struct the_nilfs *nilfs,
 	nilfs2_debug((DBG_RECOVERY | DBG_DUMP_STACK),
 			"nilfs %p, rb %p, i_ino %lu\n",
 			nilfs, rb, page->mapping->host->i_ino);
+	nilfs2_hexdump((DBG_RECOVERY | DBG_HEX_DUMP),
+			"recovery block: ",
+			rb, sizeof(struct nilfs_recovery_block));
 
 	bh_org = __bread(nilfs->ns_bdev, rb->blocknr, nilfs->ns_blocksize);
 	if (unlikely(!bh_org))
@@ -650,6 +656,9 @@ static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
 	nilfs2_debug((DBG_RECOVERY | DBG_DUMP_STACK),
 			"nilfs %p, sb %p, root %p, ri %p\n",
 			nilfs, sb, root, ri);
+	nilfs2_hexdump((DBG_RECOVERY | DBG_HEX_DUMP),
+			"recovery info: ",
+			ri, sizeof(struct nilfs_recovery_info));
 
 	pseg_start = ri->ri_lsegs_start;
 	seg_seq = ri->ri_lsegs_start_seq;
@@ -761,6 +770,9 @@ static void nilfs_finish_roll_forward(struct the_nilfs *nilfs,
 
 	nilfs2_debug((DBG_RECOVERY | DBG_DUMP_STACK),
 			"nilfs %p, ri %p\n", nilfs, ri);
+	nilfs2_hexdump((DBG_RECOVERY | DBG_HEX_DUMP),
+			"recovery info: ",
+			ri, sizeof(struct nilfs_recovery_info));
 
 	if (nilfs_get_segnum_of_block(nilfs, ri->ri_lsegs_start) !=
 	    nilfs_get_segnum_of_block(nilfs, ri->ri_super_root))
@@ -807,6 +819,9 @@ int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
 	nilfs2_debug((DBG_RECOVERY | DBG_DUMP_STACK),
 			"nilfs %p, sb %p, ri %p\n",
 			nilfs, sb, ri);
+	nilfs2_hexdump((DBG_RECOVERY | DBG_HEX_DUMP),
+			"recovery info: ",
+			ri, sizeof(struct nilfs_recovery_info));
 
 	if (ri->ri_lsegs_start == 0 || ri->ri_lsegs_end == 0)
 		return 0;
@@ -1018,6 +1033,11 @@ int nilfs_search_super_root(struct the_nilfs *nilfs,
 	nilfs->ns_last_pseg = sr_pseg_start;
 	nilfs->ns_last_seq = nilfs->ns_seg_seq;
 	nilfs->ns_last_cno = ri->ri_cno;
+
+	nilfs2_hexdump((DBG_RECOVERY | DBG_HEX_DUMP),
+			"recovery info: ",
+			ri, sizeof(struct nilfs_recovery_info));
+
 	return 0;
 
  failed:
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 605639f..81271b3 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -377,6 +377,8 @@ static void *nilfs_segctor_map_segsum_entry(struct nilfs_sc_info *sci,
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, segnum %llu, ssp->offset %u, bytes %u\n",
 			sci, segbuf->sb_segnum, ssp->offset, bytes);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	if (unlikely(ssp->offset + bytes > blocksize)) {
 		ssp->offset = 0;
@@ -404,6 +406,8 @@ static int nilfs_segctor_reset_segment_buffer(struct nilfs_sc_info *sci)
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, segnum %llu, cno %llu\n",
 			sci, segbuf->sb_segnum, sci->sc_cno);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	if (nilfs_doing_gc())
 		flags = NILFS_SS_GC;
@@ -422,6 +426,8 @@ static int nilfs_segctor_reset_segment_buffer(struct nilfs_sc_info *sci)
 static int nilfs_segctor_feed_segment(struct nilfs_sc_info *sci)
 {
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK), "sci %p\n", sci);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	sci->sc_nblk_this_inc += sci->sc_curseg->sb_sum.nblocks;
 	if (NILFS_SEGBUF_IS_LAST(sci->sc_curseg, &sci->sc_segbufs))
@@ -438,6 +444,8 @@ static int nilfs_segctor_add_super_root(struct nilfs_sc_info *sci)
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, segnum %llu\n", sci, segbuf->sb_segnum);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	if (segbuf->sb_sum.nblocks >= segbuf->sb_rest_blocks) {
 		err = nilfs_segctor_feed_segment(sci);
@@ -471,6 +479,8 @@ static void nilfs_segctor_begin_finfo(struct nilfs_sc_info *sci,
 {
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, i_ino %lu\n", sci, inode->i_ino);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	sci->sc_curseg->sb_sum.nfinfo++;
 	sci->sc_binfo_ptr = sci->sc_finfo_ptr;
@@ -494,6 +504,8 @@ static void nilfs_segctor_end_finfo(struct nilfs_sc_info *sci,
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, i_ino %lu, segnum %llu\n",
 			sci, inode->i_ino, sci->sc_curseg->sb_segnum);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	if (sci->sc_blk_cnt == 0)
 		return;
@@ -533,6 +545,8 @@ static int nilfs_segctor_add_file_block(struct nilfs_sc_info *sci,
 			"sci %p, ino %lu, segnum %llu, bh %p, binfo_size %u\n",
 			sci, inode->i_ino, sci->sc_curseg->sb_segnum,
 			bh, binfo_size);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
  retry:
 	segbuf = sci->sc_curseg;
@@ -571,6 +585,8 @@ static int nilfs_collect_file_data(struct nilfs_sc_info *sci,
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, i_ino %lu, bh %p\n", sci, inode->i_ino, bh);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	err = nilfs_bmap_propagate(NILFS_I(inode)->i_bmap, bh);
 	if (err < 0)
@@ -589,6 +605,8 @@ static int nilfs_collect_file_node(struct nilfs_sc_info *sci,
 {
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, i_ino %lu, bh %p\n", sci, inode->i_ino, bh);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	return nilfs_bmap_propagate(NILFS_I(inode)->i_bmap, bh);
 }
@@ -599,6 +617,8 @@ static int nilfs_collect_file_bmap(struct nilfs_sc_info *sci,
 {
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, i_ino %lu, bh %p\n", sci, inode->i_ino, bh);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	WARN_ON(!buffer_dirty(bh));
 	return nilfs_segctor_add_file_block(sci, bh, inode, sizeof(__le64));
@@ -637,6 +657,8 @@ static int nilfs_collect_dat_data(struct nilfs_sc_info *sci,
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, i_ino %lu, bh %p\n", sci, inode->i_ino, bh);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	err = nilfs_bmap_propagate(NILFS_I(inode)->i_bmap, bh);
 	if (err < 0)
@@ -888,6 +910,8 @@ static int nilfs_segctor_create_checkpoint(struct nilfs_sc_info *sci)
 	int err;
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK), "sci %p\n", sci);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	/* XXX: this interface will be changed */
 	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, 1,
@@ -914,6 +938,8 @@ static int nilfs_segctor_fill_in_checkpoint(struct nilfs_sc_info *sci)
 	int err;
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK), "sci %p\n", sci);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, 0,
 					  &raw_cp, &bh_cp);
@@ -971,6 +997,8 @@ static void nilfs_segctor_fill_in_file_bmap(struct nilfs_sc_info *sci)
 	struct nilfs_inode_info *ii;
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK), "sci %p\n", sci);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	list_for_each_entry(ii, &sci->sc_dirty_files, i_dirty) {
 		nilfs_fill_in_file_bmap(sci->sc_root->ifile, ii);
@@ -987,6 +1015,8 @@ static void nilfs_segctor_fill_in_super_root(struct nilfs_sc_info *sci,
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, nilfs %p\n", sci, nilfs);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	bh_sr = NILFS_LAST_SEGBUF(&sci->sc_segbufs)->sb_super_root;
 	raw_sr = (struct nilfs_super_root *)bh_sr->b_data;
@@ -1048,6 +1078,8 @@ static int nilfs_segctor_apply_buffers(struct nilfs_sc_info *sci,
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, i_ino %lu, listp %p, collect %p\n",
 			sci, inode->i_ino, listp, collect);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	if (collect) {
 		list_for_each_entry_safe(bh, n, listp, b_assoc_buffers) {
@@ -1088,6 +1120,8 @@ static int nilfs_segctor_scan_file(struct nilfs_sc_info *sci,
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, i_ino %lu, sc_ops %p\n",
 			sci, inode->i_ino, sc_ops);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	if (!(sci->sc_stage.flags & NILFS_CF_NODE)) {
 		size_t n, rest = nilfs_segctor_buffer_rest(sci);
@@ -1143,6 +1177,8 @@ static int nilfs_segctor_scan_file_dsync(struct nilfs_sc_info *sci,
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, i_ino %lu\n", sci, inode->i_ino);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	n = nilfs_lookup_dirty_data_buffers(inode, &data_buffers, rest + 1,
 					    sci->sc_dsync_start,
@@ -1169,6 +1205,8 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, sci->sc_stage.scnt %d, mode %#x\n",
 			sci, sci->sc_stage.scnt, mode);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	switch (sci->sc_stage.scnt) {
 	case NILFS_ST_INIT:
@@ -1331,6 +1369,8 @@ static int nilfs_segctor_begin_construction(struct nilfs_sc_info *sci,
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, nilfs %p\n", sci, nilfs);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	segbuf = nilfs_segbuf_new(sci->sc_super);
 	if (unlikely(!segbuf))
@@ -1396,6 +1436,8 @@ static int nilfs_segctor_extend_segments(struct nilfs_sc_info *sci,
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, nilfs %p, nadd %d\n", sci, nilfs, nadd);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	prev = NILFS_LAST_SEGBUF(&sci->sc_segbufs);
 	/*
@@ -1534,6 +1576,8 @@ static void nilfs_segctor_truncate_segments(struct nilfs_sc_info *sci,
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, last %p, sufile %p\n", sci, last, sufile);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	list_for_each_entry_continue(segbuf, &sci->sc_segbufs, sb_list) {
 		sci->sc_segbuf_nblocks -= segbuf->sb_rest_blocks;
@@ -1552,6 +1596,8 @@ static int nilfs_segctor_collect(struct nilfs_sc_info *sci,
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, nilfs %p, mode %#x\n", sci, nilfs, mode);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	/* Collection retry loop */
 	for (;;) {
@@ -1625,6 +1671,8 @@ nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, segbuf %p, mode %#x\n", sci, segbuf, mode);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	if (!nfinfo)
 		goto out;
@@ -1689,6 +1737,8 @@ static int nilfs_segctor_assign(struct nilfs_sc_info *sci, int mode)
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, mode %#x\n", sci, mode);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
 		err = nilfs_segctor_update_payload_blocknr(sci, segbuf, mode);
@@ -1721,6 +1771,8 @@ static void nilfs_segctor_prepare_write(struct nilfs_sc_info *sci)
 	struct page *bd_page = NULL, *fs_page = NULL;
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK), "sci %p\n", sci);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
 		struct buffer_head *bh;
@@ -1772,6 +1824,8 @@ static int nilfs_segctor_write(struct nilfs_sc_info *sci,
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, nilfs %p\n", sci, nilfs);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	ret = nilfs_write_logs(&sci->sc_segbufs, nilfs);
 	list_splice_tail_init(&sci->sc_segbufs, &sci->sc_write_logs);
@@ -1878,6 +1932,8 @@ static void nilfs_segctor_abort_construction(struct nilfs_sc_info *sci,
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, nilfs %p, err %d\n", sci, nilfs, err);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	list_splice_tail_init(&sci->sc_write_logs, &logs);
 	ret = nilfs_wait_on_logs(&logs);
@@ -1917,6 +1973,8 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 	int update_sr = false;
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK), "sci %p\n", sci);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	list_for_each_entry(segbuf, &sci->sc_write_logs, sb_list) {
 		struct buffer_head *bh;
@@ -2012,6 +2070,8 @@ static int nilfs_segctor_wait(struct nilfs_sc_info *sci)
 	int ret;
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK), "sci %p\n", sci);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	ret = nilfs_wait_on_logs(&sci->sc_write_logs);
 	if (!ret) {
@@ -2029,6 +2089,8 @@ static int nilfs_segctor_collect_dirty_files(struct nilfs_sc_info *sci,
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, nilfs %p\n", sci, nilfs);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	spin_lock(&nilfs->ns_inode_lock);
  retry:
@@ -2075,6 +2137,8 @@ static void nilfs_segctor_drop_written_files(struct nilfs_sc_info *sci,
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, nilfs %p\n", sci, nilfs);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	spin_lock(&nilfs->ns_inode_lock);
 	list_for_each_entry_safe(ii, n, &sci->sc_dirty_files, i_dirty) {
@@ -2103,6 +2167,8 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, mode %#x\n", sci, mode);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	sci->sc_stage.scnt = NILFS_ST_INIT;
 	sci->sc_cno = nilfs->ns_cno;
@@ -2261,6 +2327,8 @@ static int nilfs_segctor_sync(struct nilfs_sc_info *sci)
 	int err = 0;
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK), "sci %p\n", sci);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	spin_lock(&sci->sc_state_lock);
 	init_wait(&wait_req.wq);
@@ -2478,6 +2546,8 @@ static int nilfs_segctor_construct(struct nilfs_sc_info *sci, int mode)
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, mode %#x\n", sci, mode);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	nilfs_segctor_accept(sci);
 
@@ -2545,6 +2615,8 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sb %p, argv %p, kbufs %p\n", sb, argv, kbufs);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"argv: ", argv, sizeof(struct nilfs_argv));
 
 	if (unlikely(!sci))
 		return -EROFS;
@@ -2602,6 +2674,8 @@ static void nilfs_segctor_thread_construct(struct nilfs_sc_info *sci, int mode)
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK),
 			"sci %p, mode %#x\n", sci, mode);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	nilfs_transaction_lock(sci->sc_super, &ti, 0);
 	nilfs_segctor_construct(sci, mode);
@@ -2623,6 +2697,8 @@ static void nilfs_segctor_do_immediate_flush(struct nilfs_sc_info *sci)
 	int err;
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK), "sci %p\n", sci);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	spin_lock(&sci->sc_state_lock);
 	mode = (sci->sc_flush_request & FLUSH_DAT_BIT) ?
@@ -2746,6 +2822,8 @@ static int nilfs_segctor_start_thread(struct nilfs_sc_info *sci)
 	struct task_struct *t;
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK), "sci %p\n", sci);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	t = kthread_run(nilfs_segctor_thread, sci, "segctord");
 	if (IS_ERR(t)) {
@@ -2766,6 +2844,8 @@ static void nilfs_segctor_kill_thread(struct nilfs_sc_info *sci)
 	sci->sc_state |= NILFS_SEGCTOR_QUIT;
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK), "sci %p\n", sci);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	while (sci->sc_task) {
 		wake_up(&sci->sc_wait_daemon);
@@ -2822,6 +2902,8 @@ static void nilfs_segctor_write_out(struct nilfs_sc_info *sci)
 	int ret, retrycount = NILFS_SC_CLEANUP_RETRY;
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK), "sci %p\n", sci);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	/* The segctord thread was stopped and its timer was removed.
 	   But some tasks remain. */
@@ -2849,6 +2931,8 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 	int flag;
 
 	nilfs2_debug((DBG_SEGMENT | DBG_DUMP_STACK), "sci %p\n", sci);
+	nilfs2_hexdump((DBG_SEGMENT | DBG_HEX_DUMP),
+			"sc_info: ", sci, sizeof(struct nilfs_sc_info));
 
 	up_write(&nilfs->ns_segctor_sem);
 
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index b9980fa8..e9921c6 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -194,6 +194,8 @@ int nilfs_sufile_updatev(struct inode *sufile, __u64 *segnumv, size_t nsegs,
 			"sufile ino %lu, segnumv %p, nsegs %zu, "
 			"create %d, ndone %p, dofunc %p\n",
 			sufile->i_ino, segnumv, nsegs, create, ndone, dofunc);
+	nilfs2_hexdump((DBG_SUFILE | DBG_HEX_DUMP),
+			"segnumv: ", segnumv, nsegs * sizeof(__u64));
 
 	if (unlikely(nsegs == 0))
 		goto out;
@@ -628,6 +630,8 @@ int nilfs_sufile_get_stat(struct inode *sufile, struct nilfs_sustat *sustat)
 
 	nilfs2_debug((DBG_SUFILE | DBG_DUMP_STACK),
 			"sufile ino %lu, sustat %p\n", sufile->i_ino, sustat);
+	nilfs2_hexdump((DBG_SUFILE | DBG_HEX_DUMP),
+			"sustat: ", sustat, sizeof(struct nilfs_sustat));
 
 	down_read(&NILFS_MDT(sufile)->mi_sem);
 
@@ -963,6 +967,8 @@ int nilfs_sufile_read(struct super_block *sb, size_t susize,
 	nilfs2_debug((DBG_SUFILE | DBG_DUMP_STACK),
 			"sb %p, susize %zu, raw_inode %p, inodep %p\n",
 			sb, susize, raw_inode, inodep);
+	nilfs2_hexdump((DBG_SUFILE | DBG_HEX_DUMP),
+			"raw_inode: ", raw_inode, sizeof(struct nilfs_inode));
 
 	sufile = nilfs_iget_locked(sb, NULL, NILFS_SUFILE_INO);
 	if (unlikely(!sufile))
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 600bee5..7cc3c64 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -682,6 +682,8 @@ int nilfs_discard_segments(struct the_nilfs *nilfs, __u64 *segnump,
 	nilfs2_debug((DBG_THE_NILFS | DBG_DUMP_STACK),
 			"nilfs %p, segnump %p, nsegs %zu\n",
 			nilfs, segnump, nsegs);
+	nilfs2_hexdump((DBG_THE_NILFS | DBG_HEX_DUMP),
+			"segnums: ", segnump, nsegs * sizeof(__u64));
 
 	sects_per_block = (1 << nilfs->ns_blocksize_bits) /
 		bdev_logical_block_size(nilfs->ns_bdev);
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
