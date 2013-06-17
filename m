From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 19/24] nilfs2: implement superfluous debugging output option
Date: Mon, 17 Jun 2013 16:25:59 +0400
Message-ID: <1371471959.2075.151.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=zprXLOkquiv9DMzPvIr5BM9n8yescb1rO7aI9auRiYo=;
	b=dTSi7rSqMsM4lHVIh8bY+r9uaJqch6b3qZ7aUhpMZAfxRAuUUxDOXdmz+x4Fp5wgh4pe1b7vkcfPBl1Sn1cS1TSxcFO0bqUri5z2gpjwJysaZ2ZjfxSJ8MZEmeSdbUIp;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 19/24] nilfs2: implement superfluous debugging output option

This patch implements DBG_SPAM flag using. This flag requests output
from frequently called functions or detailed debugging output
from function's body.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/alloc.c  |  102 +++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/nilfs2/btree.c  |   19 ++++++++++
 fs/nilfs2/dat.c    |   77 +++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/dir.c    |   24 +++++++++++++
 fs/nilfs2/inode.c  |   24 +++++++++++++
 fs/nilfs2/mdt.c    |    4 +++
 fs/nilfs2/segbuf.c |   28 +++++++++++++++
 7 files changed, 273 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index ee67a07..dc5432d 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -99,6 +99,11 @@ static unsigned long nilfs_palloc_group(const struct inode *inode, __u64 nr,
 	__u64 group = nr;
 
 	*offset = do_div(group, nilfs_palloc_entries_per_group(inode));
+
+	nilfs2_debug((DBG_ALLOC | DBG_SPAM),
+			"i_ino %lu, nr %llu, offset %lu\n",
+			inode->i_ino, nr, *offset);
+
 	return group;
 }
 
@@ -113,9 +118,17 @@ static unsigned long nilfs_palloc_group(const struct inode *inode, __u64 nr,
 static unsigned long
 nilfs_palloc_desc_blkoff(const struct inode *inode, unsigned long group)
 {
+	unsigned long blkoff;
 	unsigned long desc_block =
 		group / nilfs_palloc_groups_per_desc_block(inode);
-	return desc_block * NILFS_MDT(inode)->mi_blocks_per_desc_block;
+
+	blkoff = desc_block * NILFS_MDT(inode)->mi_blocks_per_desc_block;
+
+	nilfs2_debug((DBG_ALLOC | DBG_SPAM),
+			"i_ino %lu, group %lu, blkoff %lu\n",
+			inode->i_ino, group, blkoff);
+
+	return blkoff;
 }
 
 /**
@@ -129,10 +142,18 @@ nilfs_palloc_desc_blkoff(const struct inode *inode, unsigned long group)
 static unsigned long
 nilfs_palloc_bitmap_blkoff(const struct inode *inode, unsigned long group)
 {
+	unsigned long blkoff;
 	unsigned long desc_offset =
 		group % nilfs_palloc_groups_per_desc_block(inode);
-	return nilfs_palloc_desc_blkoff(inode, group) + 1 +
+
+	blkoff = nilfs_palloc_desc_blkoff(inode, group) + 1 +
 		desc_offset * NILFS_MDT(inode)->mi_blocks_per_group;
+
+	nilfs2_debug((DBG_ALLOC | DBG_SPAM),
+			"i_ino %lu, group %lu, blkoff %lu\n",
+			inode->i_ino, group, blkoff);
+
+	return blkoff;
 }
 
 /**
@@ -150,6 +171,11 @@ nilfs_palloc_group_desc_nfrees(struct inode *inode, unsigned long group,
 	spin_lock(nilfs_mdt_bgl_lock(inode, group));
 	nfree = le32_to_cpu(desc->pg_nfrees);
 	spin_unlock(nilfs_mdt_bgl_lock(inode, group));
+
+	nilfs2_debug((DBG_ALLOC | DBG_SPAM),
+			"i_ino %lu, group %lu, nfree %lu\n",
+			inode->i_ino, group, nfree);
+
 	return nfree;
 }
 
@@ -166,6 +192,10 @@ nilfs_palloc_group_desc_add_entries(struct inode *inode,
 				    struct nilfs_palloc_group_desc *desc,
 				    u32 n)
 {
+	nilfs2_debug((DBG_ALLOC | DBG_SPAM),
+			"i_ino %lu, group %lu, n %u\n",
+			inode->i_ino, group, n);
+
 	spin_lock(nilfs_mdt_bgl_lock(inode, group));
 	le32_add_cpu(&desc->pg_nfrees, n);
 	spin_unlock(nilfs_mdt_bgl_lock(inode, group));
@@ -179,12 +209,18 @@ nilfs_palloc_group_desc_add_entries(struct inode *inode,
 static unsigned long
 nilfs_palloc_entry_blkoff(const struct inode *inode, __u64 nr)
 {
-	unsigned long group, group_offset;
+	unsigned long group, group_offset, blkoff;
 
 	group = nilfs_palloc_group(inode, nr, &group_offset);
 
-	return nilfs_palloc_bitmap_blkoff(inode, group) + 1 +
+	blkoff = nilfs_palloc_bitmap_blkoff(inode, group) + 1 +
 		group_offset / NILFS_MDT(inode)->mi_entries_per_block;
+
+	nilfs2_debug((DBG_ALLOC | DBG_SPAM),
+			"i_ino %lu, nr %llu, blkoff %lu\n",
+			inode->i_ino, nr, blkoff);
+
+	return blkoff;
 }
 
 /**
@@ -218,6 +254,10 @@ static int nilfs_palloc_get_block(struct inode *inode, unsigned long blkoff,
 {
 	int ret;
 
+	nilfs2_debug((DBG_ALLOC | DBG_SPAM | DBG_DUMP_STACK),
+			"i_ino %lu, blkoff %lu, create %d\n",
+			inode->i_ino, blkoff, create);
+
 	spin_lock(lock);
 	if (prev->bh && blkoff == prev->blkoff) {
 		get_bh(prev->bh);
@@ -256,6 +296,10 @@ static int nilfs_palloc_get_desc_block(struct inode *inode,
 {
 	struct nilfs_palloc_cache *cache = NILFS_MDT(inode)->mi_palloc_cache;
 
+	nilfs2_debug((DBG_ALLOC | DBG_SPAM),
+			"i_ino %lu, group %lu, create %d\n",
+			inode->i_ino, group, create);
+
 	return nilfs_palloc_get_block(inode,
 				      nilfs_palloc_desc_blkoff(inode, group),
 				      create, nilfs_palloc_desc_block_init,
@@ -275,6 +319,10 @@ static int nilfs_palloc_get_bitmap_block(struct inode *inode,
 {
 	struct nilfs_palloc_cache *cache = NILFS_MDT(inode)->mi_palloc_cache;
 
+	nilfs2_debug((DBG_ALLOC | DBG_SPAM),
+			"i_ino %lu, group %lu, create %d\n",
+			inode->i_ino, group, create);
+
 	return nilfs_palloc_get_block(inode,
 				      nilfs_palloc_bitmap_blkoff(inode, group),
 				      create, NULL, bhp,
@@ -293,6 +341,10 @@ int nilfs_palloc_get_entry_block(struct inode *inode, __u64 nr,
 {
 	struct nilfs_palloc_cache *cache = NILFS_MDT(inode)->mi_palloc_cache;
 
+	nilfs2_debug((DBG_ALLOC | DBG_SPAM),
+			"i_ino %lu, nr %llu, create %d\n",
+			inode->i_ino, nr, create);
+
 	return nilfs_palloc_get_block(inode,
 				      nilfs_palloc_entry_blkoff(inode, nr),
 				      create, NULL, bhp,
@@ -311,6 +363,10 @@ nilfs_palloc_block_get_group_desc(const struct inode *inode,
 				  unsigned long group,
 				  const struct buffer_head *bh, void *kaddr)
 {
+	nilfs2_debug((DBG_ALLOC | DBG_SPAM),
+			"i_ino %lu, group %lu, kaddr %p, bh_offset(bh) %lu\n",
+			inode->i_ino, group, kaddr, bh_offset(bh));
+
 	return (struct nilfs_palloc_group_desc *)(kaddr + bh_offset(bh)) +
 		group % nilfs_palloc_groups_per_desc_block(inode);
 }
@@ -327,6 +383,10 @@ void *nilfs_palloc_block_get_entry(const struct inode *inode, __u64 nr,
 {
 	unsigned long entry_offset, group_offset;
 
+	nilfs2_debug((DBG_ALLOC | DBG_SPAM | DBG_DUMP_STACK),
+			"i_ino %lu, nr %llu, kaddr %p, bh_offset(bh) %lu\n",
+			inode->i_ino, nr, kaddr, bh_offset(bh));
+
 	nilfs_palloc_group(inode, nr, &group_offset);
 	entry_offset = group_offset % NILFS_MDT(inode)->mi_entries_per_block;
 
@@ -348,7 +408,11 @@ static int nilfs_palloc_find_available_slot(struct inode *inode,
 					    unsigned char *bitmap,
 					    int bsize)
 {
-	int curr, pos, end, i;
+	unsigned long curr, pos, end, i;
+
+	nilfs2_debug((DBG_ALLOC | DBG_SPAM | DBG_DUMP_STACK),
+		"i_ino %lu, group %lu, target %lu, bitmap %p, %d bsize\n",
+		inode->i_ino, group, target, bitmap, bsize);
 
 	if (target > 0) {
 		end = (target + BITS_PER_LONG - 1) & ~(BITS_PER_LONG - 1);
@@ -419,6 +483,10 @@ int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
 	unsigned long i, j;
 	int pos, ret;
 
+	nilfs2_debug((DBG_ALLOC | DBG_SPAM | DBG_DUMP_STACK),
+			"i_ino %lu, req->pr_entry_nr %llu\n",
+			inode->i_ino, req->pr_entry_nr);
+
 	ngroups = nilfs_palloc_groups_count(inode);
 	maxgroup = ngroups - 1;
 	group = nilfs_palloc_group(inode, req->pr_entry_nr, &group_offset);
@@ -493,6 +561,10 @@ int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
 void nilfs_palloc_commit_alloc_entry(struct inode *inode,
 				     struct nilfs_palloc_req *req)
 {
+	nilfs2_debug((DBG_ALLOC | DBG_SPAM | DBG_DUMP_STACK),
+			"i_ino %lu, req->pr_entry_nr %llu\n",
+			inode->i_ino, req->pr_entry_nr);
+
 	mark_buffer_dirty(req->pr_bitmap_bh);
 	mark_buffer_dirty(req->pr_desc_bh);
 	nilfs_mdt_mark_dirty(inode);
@@ -514,6 +586,10 @@ void nilfs_palloc_commit_free_entry(struct inode *inode,
 	unsigned char *bitmap;
 	void *desc_kaddr, *bitmap_kaddr;
 
+	nilfs2_debug((DBG_ALLOC | DBG_SPAM | DBG_DUMP_STACK),
+			"i_ino %lu, req->pr_entry_nr %llu\n",
+			inode->i_ino, req->pr_entry_nr);
+
 	group = nilfs_palloc_group(inode, req->pr_entry_nr, &group_offset);
 	desc_kaddr = kmap(req->pr_desc_bh->b_page);
 	desc = nilfs_palloc_block_get_group_desc(inode, group,
@@ -552,6 +628,10 @@ void nilfs_palloc_abort_alloc_entry(struct inode *inode,
 	unsigned char *bitmap;
 	unsigned long group, group_offset;
 
+	nilfs2_debug((DBG_ALLOC | DBG_SPAM | DBG_DUMP_STACK),
+			"i_ino %lu, req->pr_entry_nr %llu\n",
+			inode->i_ino, req->pr_entry_nr);
+
 	group = nilfs_palloc_group(inode, req->pr_entry_nr, &group_offset);
 	desc_kaddr = kmap(req->pr_desc_bh->b_page);
 	desc = nilfs_palloc_block_get_group_desc(inode, group,
@@ -588,6 +668,10 @@ int nilfs_palloc_prepare_free_entry(struct inode *inode,
 	unsigned long group, group_offset;
 	int ret;
 
+	nilfs2_debug((DBG_ALLOC | DBG_SPAM | DBG_DUMP_STACK),
+			"i_ino %lu, req->pr_entry_nr %llu\n",
+			inode->i_ino, req->pr_entry_nr);
+
 	group = nilfs_palloc_group(inode, req->pr_entry_nr, &group_offset);
 	ret = nilfs_palloc_get_desc_block(inode, group, 1, &desc_bh);
 	if (ret < 0)
@@ -611,6 +695,10 @@ int nilfs_palloc_prepare_free_entry(struct inode *inode,
 void nilfs_palloc_abort_free_entry(struct inode *inode,
 				   struct nilfs_palloc_req *req)
 {
+	nilfs2_debug((DBG_ALLOC | DBG_SPAM | DBG_DUMP_STACK),
+			"i_ino %lu, req->pr_entry_nr %llu\n",
+			inode->i_ino, req->pr_entry_nr);
+
 	brelse(req->pr_bitmap_bh);
 	brelse(req->pr_desc_bh);
 
@@ -630,6 +718,10 @@ nilfs_palloc_group_is_in(struct inode *inode, unsigned long group, __u64 nr)
 {
 	__u64 first, last;
 
+	nilfs2_debug((DBG_ALLOC | DBG_SPAM),
+			"i_ino %lu, group %lu, nr %llu\n",
+			inode->i_ino, group, nr);
+
 	first = group * nilfs_palloc_entries_per_group(inode);
 	last = first + nilfs_palloc_entries_per_group(inode) - 1;
 	return (nr >= first) && (nr <= last);
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index c4af24a..9116be3 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -72,6 +72,10 @@ static int nilfs_btree_get_new_block(const struct nilfs_bmap *btree,
 	struct address_space *btnc = &NILFS_BMAP_I(btree)->i_btnode_cache;
 	struct buffer_head *bh;
 
+	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, ptr %llu\n",
+			btnc->host->i_ino, ptr);
+
 	bh = nilfs_btnode_create_block(btnc, ptr);
 	if (!bh)
 		return -ENOMEM;
@@ -477,6 +481,10 @@ static int __nilfs_btree_get_block(const struct nilfs_bmap *btree, __u64 ptr,
 	sector_t submit_ptr = 0;
 	int ret;
 
+	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK | DBG_SPAM),
+		"btree ino %lu, ptr %llu, bhp %p, ra %p\n",
+		btree->b_inode->i_ino, ptr, bhp, ra);
+
 	ret = nilfs_btnode_submit_block(btnc, ptr, 0, READ, &bh, &submit_ptr);
 	if (ret) {
 		if (ret != -EEXIST)
@@ -758,6 +766,10 @@ static void nilfs_btree_promote_key(struct nilfs_bmap *btree,
 				    struct nilfs_btree_path *path,
 				    int level, __u64 key)
 {
+	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK | DBG_SPAM),
+		"btree ino %lu, level %d, key %llu\n",
+		btree->b_inode->i_ino, level, key);
+
 	if (level < nilfs_btree_height(btree) - 1) {
 		do {
 			nilfs_btree_node_set_key(
@@ -1006,6 +1018,9 @@ static __u64 nilfs_btree_find_near(const struct nilfs_bmap *btree,
 	struct nilfs_btree_node *node;
 	int level, ncmax;
 
+	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK | DBG_SPAM),
+			"btree ino %lu\n", btree->b_inode->i_ino);
+
 	if (path == NULL)
 		return NILFS_BMAP_INVALID_PTR;
 
@@ -1035,6 +1050,10 @@ static __u64 nilfs_btree_find_target_v(const struct nilfs_bmap *btree,
 {
 	__u64 ptr;
 
+	nilfs2_debug((DBG_BTREE | DBG_DUMP_STACK | DBG_SPAM),
+		"btree ino %lu, key %llu\n",
+		btree->b_inode->i_ino, key);
+
 	ptr = nilfs_bmap_find_target_seq(btree, key);
 	if (ptr != NILFS_BMAP_INVALID_PTR)
 		/* sequential access */
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index db987db..4b7875e 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -53,6 +53,10 @@ static inline struct nilfs_dat_info *NILFS_DAT_I(struct inode *dat)
 static int nilfs_dat_prepare_entry(struct inode *dat,
 				   struct nilfs_palloc_req *req, int create)
 {
+	nilfs2_debug((DBG_DAT | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, pr_entry_nr %llu, create %d\n",
+			dat->i_ino, req->pr_entry_nr, create);
+
 	return nilfs_palloc_get_entry_block(dat, req->pr_entry_nr,
 					    create, &req->pr_entry_bh);
 }
@@ -60,6 +64,10 @@ static int nilfs_dat_prepare_entry(struct inode *dat,
 static void nilfs_dat_commit_entry(struct inode *dat,
 				   struct nilfs_palloc_req *req)
 {
+	nilfs2_debug((DBG_DAT | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, pr_entry_nr %llu\n",
+			dat->i_ino, req->pr_entry_nr);
+
 	mark_buffer_dirty(req->pr_entry_bh);
 	nilfs_mdt_mark_dirty(dat);
 	brelse(req->pr_entry_bh);
@@ -68,6 +76,10 @@ static void nilfs_dat_commit_entry(struct inode *dat,
 static void nilfs_dat_abort_entry(struct inode *dat,
 				  struct nilfs_palloc_req *req)
 {
+	nilfs2_debug((DBG_DAT | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, pr_entry_nr %llu\n",
+			dat->i_ino, req->pr_entry_nr);
+
 	brelse(req->pr_entry_bh);
 }
 
@@ -75,6 +87,10 @@ int nilfs_dat_prepare_alloc(struct inode *dat, struct nilfs_palloc_req *req)
 {
 	int ret;
 
+	nilfs2_debug((DBG_DAT | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, pr_entry_nr %llu\n",
+			dat->i_ino, req->pr_entry_nr);
+
 	ret = nilfs_palloc_prepare_alloc_entry(dat, req);
 	if (ret < 0)
 		return ret;
@@ -91,6 +107,10 @@ void nilfs_dat_commit_alloc(struct inode *dat, struct nilfs_palloc_req *req)
 	struct nilfs_dat_entry *entry;
 	void *kaddr;
 
+	nilfs2_debug((DBG_DAT | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, pr_entry_nr %llu\n",
+			dat->i_ino, req->pr_entry_nr);
+
 	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
@@ -105,6 +125,10 @@ void nilfs_dat_commit_alloc(struct inode *dat, struct nilfs_palloc_req *req)
 
 void nilfs_dat_abort_alloc(struct inode *dat, struct nilfs_palloc_req *req)
 {
+	nilfs2_debug((DBG_DAT | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, pr_entry_nr %llu\n",
+			dat->i_ino, req->pr_entry_nr);
+
 	nilfs_dat_abort_entry(dat, req);
 	nilfs_palloc_abort_alloc_entry(dat, req);
 }
@@ -115,6 +139,10 @@ static void nilfs_dat_commit_free(struct inode *dat,
 	struct nilfs_dat_entry *entry;
 	void *kaddr;
 
+	nilfs2_debug((DBG_DAT | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, pr_entry_nr %llu\n",
+			dat->i_ino, req->pr_entry_nr);
+
 	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
@@ -131,6 +159,10 @@ int nilfs_dat_prepare_start(struct inode *dat, struct nilfs_palloc_req *req)
 {
 	int ret;
 
+	nilfs2_debug((DBG_DAT | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, pr_entry_nr %llu\n",
+			dat->i_ino, req->pr_entry_nr);
+
 	ret = nilfs_dat_prepare_entry(dat, req, 0);
 	WARN_ON(ret == -ENOENT);
 	return ret;
@@ -142,6 +174,10 @@ void nilfs_dat_commit_start(struct inode *dat, struct nilfs_palloc_req *req,
 	struct nilfs_dat_entry *entry;
 	void *kaddr;
 
+	nilfs2_debug((DBG_DAT | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, pr_entry_nr %llu, blocknr %lu\n",
+			dat->i_ino, req->pr_entry_nr, blocknr);
+
 	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
@@ -160,6 +196,10 @@ int nilfs_dat_prepare_end(struct inode *dat, struct nilfs_palloc_req *req)
 	void *kaddr;
 	int ret;
 
+	nilfs2_debug((DBG_DAT | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, pr_entry_nr %llu\n",
+			dat->i_ino, req->pr_entry_nr);
+
 	ret = nilfs_dat_prepare_entry(dat, req, 0);
 	if (ret < 0) {
 		WARN_ON(ret == -ENOENT);
@@ -192,6 +232,10 @@ void nilfs_dat_commit_end(struct inode *dat, struct nilfs_palloc_req *req,
 	sector_t blocknr;
 	void *kaddr;
 
+	nilfs2_debug((DBG_DAT | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, pr_entry_nr %llu, dead %d\n",
+			dat->i_ino, req->pr_entry_nr, dead);
+
 	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
@@ -217,6 +261,10 @@ void nilfs_dat_abort_end(struct inode *dat, struct nilfs_palloc_req *req)
 	sector_t blocknr;
 	void *kaddr;
 
+	nilfs2_debug((DBG_DAT | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, pr_entry_nr %llu\n",
+			dat->i_ino, req->pr_entry_nr);
+
 	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
@@ -235,6 +283,10 @@ int nilfs_dat_prepare_update(struct inode *dat,
 {
 	int ret;
 
+	nilfs2_debug((DBG_DAT | DBG_DUMP_STACK | DBG_SPAM),
+		"i_ino %lu, old pr_entry_nr %llu, new pr_entry_nr %llu\n",
+		dat->i_ino, oldreq->pr_entry_nr, newreq->pr_entry_nr);
+
 	ret = nilfs_dat_prepare_end(dat, oldreq);
 	if (!ret) {
 		ret = nilfs_dat_prepare_alloc(dat, newreq);
@@ -248,6 +300,11 @@ void nilfs_dat_commit_update(struct inode *dat,
 			     struct nilfs_palloc_req *oldreq,
 			     struct nilfs_palloc_req *newreq, int dead)
 {
+	nilfs2_debug((DBG_DAT | DBG_DUMP_STACK | DBG_SPAM),
+		"i_ino %lu, old pr_entry_nr %llu, "
+		"new pr_entry_nr %llu, dead %d\n",
+		dat->i_ino, oldreq->pr_entry_nr, newreq->pr_entry_nr, dead);
+
 	nilfs_dat_commit_end(dat, oldreq, dead);
 	nilfs_dat_commit_alloc(dat, newreq);
 }
@@ -256,6 +313,10 @@ void nilfs_dat_abort_update(struct inode *dat,
 			    struct nilfs_palloc_req *oldreq,
 			    struct nilfs_palloc_req *newreq)
 {
+	nilfs2_debug((DBG_DAT | DBG_DUMP_STACK | DBG_SPAM),
+		"i_ino %lu, old pr_entry_nr %llu, new pr_entry_nr %llu\n",
+		dat->i_ino, oldreq->pr_entry_nr, newreq->pr_entry_nr);
+
 	nilfs_dat_abort_end(dat, oldreq);
 	nilfs_dat_abort_alloc(dat, newreq);
 }
@@ -279,6 +340,10 @@ int nilfs_dat_mark_dirty(struct inode *dat, __u64 vblocknr)
 	struct nilfs_palloc_req req;
 	int ret;
 
+	nilfs2_debug((DBG_DAT | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, vblocknr %llu\n",
+			dat->i_ino, vblocknr);
+
 	req.pr_entry_nr = vblocknr;
 	ret = nilfs_dat_prepare_entry(dat, &req, 0);
 	if (ret == 0)
@@ -336,6 +401,10 @@ int nilfs_dat_move(struct inode *dat, __u64 vblocknr, sector_t blocknr)
 	void *kaddr;
 	int ret;
 
+	nilfs2_debug((DBG_DAT | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, vblocknr %llu, blocknr %lu\n",
+			dat->i_ino, vblocknr, blocknr);
+
 	ret = nilfs_palloc_get_entry_block(dat, vblocknr, 0, &entry_bh);
 	if (ret < 0)
 		return ret;
@@ -406,6 +475,10 @@ int nilfs_dat_translate(struct inode *dat, __u64 vblocknr, sector_t *blocknrp)
 	void *kaddr;
 	int ret;
 
+	nilfs2_debug((DBG_DAT | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, vblocknr %llu, blocknrp %p\n",
+			dat->i_ino, vblocknr, blocknrp);
+
 	ret = nilfs_palloc_get_entry_block(dat, vblocknr, 0, &entry_bh);
 	if (ret < 0)
 		return ret;
@@ -445,6 +518,10 @@ ssize_t nilfs_dat_get_vinfo(struct inode *dat, void *buf, unsigned visz,
 	unsigned long entries_per_block = NILFS_MDT(dat)->mi_entries_per_block;
 	int i, j, n, ret;
 
+	nilfs2_debug((DBG_DAT | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, buf %p, visz %u, nvi %zu\n",
+			dat->i_ino, buf, visz, nvi);
+
 	for (i = 0; i < nvi; i += n) {
 		ret = nilfs_palloc_get_entry_block(dat, vinfo->vi_vblocknr,
 						   0, &entry_bh);
diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 9fc053c..7a5f449 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -57,6 +57,9 @@ static inline unsigned nilfs_chunk_size(struct inode *inode)
 
 static inline void nilfs_put_page(struct page *page)
 {
+	nilfs2_debug((DBG_DIR | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu\n", page->mapping->host->i_ino);
+
 	kunmap(page);
 	page_cache_release(page);
 }
@@ -74,15 +77,26 @@ static unsigned nilfs_last_byte(struct inode *inode, unsigned long page_nr)
 {
 	unsigned last_byte = inode->i_size;
 
+	nilfs2_debug((DBG_DIR | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, page_nr %lu\n", inode->i_ino, page_nr);
+
 	last_byte -= page_nr << PAGE_CACHE_SHIFT;
 	if (last_byte > PAGE_CACHE_SIZE)
 		last_byte = PAGE_CACHE_SIZE;
+
+	nilfs2_debug((DBG_DIR | DBG_SPAM), "last_byte %u\n", last_byte);
+
 	return last_byte;
 }
 
 static int nilfs_prepare_chunk(struct page *page, unsigned from, unsigned to)
 {
 	loff_t pos = page_offset(page) + from;
+
+	nilfs2_debug((DBG_DIR | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, from %u, to %u\n",
+			page->mapping->host->i_ino, from, to);
+
 	return __block_write_begin(page, pos, to - from, nilfs_get_block);
 }
 
@@ -96,6 +110,10 @@ static void nilfs_commit_chunk(struct page *page,
 	unsigned nr_dirty, copied;
 	int err;
 
+	nilfs2_debug((DBG_DIR | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, from %u, to %u\n",
+			dir->i_ino, from, to);
+
 	nr_dirty = nilfs_page_count_clean_buffers(page, from, to);
 	copied = block_write_end(NULL, mapping, pos, len, len, page, NULL);
 	if (pos + copied > dir->i_size)
@@ -118,6 +136,9 @@ static void nilfs_check_page(struct page *page)
 	struct nilfs_dir_entry *p;
 	char *error;
 
+	nilfs2_debug((DBG_DIR | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu\n", page->mapping->host->i_ino);
+
 	if ((dir->i_size >> PAGE_CACHE_SHIFT) == page->index) {
 		limit = dir->i_size & ~PAGE_CACHE_MASK;
 		if (limit & (chunk_size - 1))
@@ -187,6 +208,9 @@ static struct page *nilfs_get_page(struct inode *dir, unsigned long n)
 	struct address_space *mapping = dir->i_mapping;
 	struct page *page = read_mapping_page(mapping, n, NULL);
 
+	nilfs2_debug((DBG_DIR | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, n %lu\n", dir->i_ino, n);
+
 	if (!IS_ERR(page)) {
 		kmap(page);
 		if (!PageChecked(page))
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 26e78f2..ca594f2 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -160,6 +160,12 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
  */
 static int nilfs_readpage(struct file *file, struct page *page)
 {
+	nilfs2_debug((DBG_INODE | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, i_size %llu, offset %llu\n",
+			page->mapping->host->i_ino,
+			i_size_read(page->mapping->host),
+			page_offset(page));
+
 	return mpage_readpage(page, nilfs_get_block);
 }
 
@@ -174,6 +180,12 @@ static int nilfs_readpage(struct file *file, struct page *page)
 static int nilfs_readpages(struct file *file, struct address_space *mapping,
 			   struct list_head *pages, unsigned nr_pages)
 {
+	nilfs2_debug((DBG_INODE | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, i_size %llu, nr_pages %u\n",
+			mapping->host->i_ino,
+			i_size_read(mapping->host),
+			nr_pages);
+
 	return mpage_readpages(mapping, pages, nr_pages, nilfs_get_block);
 }
 
@@ -183,6 +195,12 @@ static int nilfs_writepages(struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	int err = 0;
 
+	nilfs2_debug((DBG_INODE | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, i_size %llu, nr_to_write %lu\n",
+			mapping->host->i_ino,
+			i_size_read(mapping->host),
+			wbc->nr_to_write);
+
 	if (inode->i_sb->s_flags & MS_RDONLY) {
 		nilfs_clear_dirty_pages(mapping, false);
 		return -EROFS;
@@ -200,6 +218,12 @@ static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
 	struct inode *inode = page->mapping->host;
 	int err;
 
+	nilfs2_debug((DBG_INODE | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, i_size %llu, start %llu, end %llu\n",
+			page->mapping->host->i_ino,
+			i_size_read(page->mapping->host),
+			wbc->range_start, wbc->range_end);
+
 	if (inode->i_sb->s_flags & MS_RDONLY) {
 		/*
 		 * It means that filesystem was remounted in read-only
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 292b43e..bcd188d 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -427,6 +427,10 @@ nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 	if (!inode)
 		return 0;
 
+	nilfs2_debug((DBG_MDT | DBG_DUMP_STACK | DBG_SPAM),
+			"i_ino %lu, offset %llu\n",
+			inode->i_ino, page_offset(page));
+
 	sb = inode->i_sb;
 
 	if (wbc->sync_mode == WB_SYNC_ALL)
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 2d4c5e0..10e7b38 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -373,6 +373,10 @@ static void nilfs_end_bio_write(struct bio *bio, int err)
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct nilfs_segment_buffer *segbuf = bio->bi_private;
 
+	nilfs2_debug((DBG_SEGBUF | DBG_DUMP_STACK | DBG_SPAM),
+			"sb_segnum %llu, sb_pseg_start %lu, err %d\n",
+			segbuf->sb_segnum, segbuf->sb_pseg_start, err);
+
 	if (err == -EOPNOTSUPP) {
 		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
 		bio_put(bio);
@@ -392,6 +396,12 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
 	struct bio *bio = wi->bio;
 	int err;
 
+	nilfs2_debug((DBG_SEGBUF | DBG_DUMP_STACK | DBG_SPAM),
+			"sb_segnum %llu, sb_pseg_start %lu, "
+			"blocknr %lu, mode %#x\n",
+			segbuf->sb_segnum, segbuf->sb_pseg_start,
+			wi->blocknr, mode);
+
 	if (segbuf->sb_nbio > 0 &&
 	    bdi_write_congested(segbuf->sb_super->s_bdi)) {
 		wait_for_completion(&segbuf->sb_bio_event);
@@ -440,6 +450,10 @@ static struct bio *nilfs_alloc_seg_bio(struct the_nilfs *nilfs, sector_t start,
 {
 	struct bio *bio;
 
+	nilfs2_debug((DBG_SEGBUF | DBG_DUMP_STACK | DBG_SPAM),
+			"nilfs %p, start %lu, nr_vecs %d\n",
+			nilfs, start, nr_vecs);
+
 	bio = bio_alloc(GFP_NOIO, nr_vecs);
 	if (bio == NULL) {
 		while (!bio && (nr_vecs >>= 1))
@@ -469,6 +483,12 @@ static int nilfs_segbuf_submit_bh(struct nilfs_segment_buffer *segbuf,
 {
 	int len, err;
 
+	nilfs2_debug((DBG_SEGBUF | DBG_DUMP_STACK | DBG_SPAM),
+			"sb_segnum %llu, sb_pseg_start %lu, "
+			"blocknr %lu, mode %#x\n",
+			segbuf->sb_segnum, segbuf->sb_pseg_start,
+			wi->blocknr, mode);
+
 	BUG_ON(wi->nr_vecs <= 0);
  repeat:
 	if (!wi->bio) {
@@ -510,6 +530,10 @@ static int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
 	struct buffer_head *bh;
 	int res = 0, rw = WRITE;
 
+	nilfs2_debug((DBG_SEGBUF | DBG_DUMP_STACK | DBG_SPAM),
+			"sb_segnum %llu, sb_pseg_start %lu, nilfs %p\n",
+			segbuf->sb_segnum, segbuf->sb_pseg_start, nilfs);
+
 	wi.nilfs = nilfs;
 	nilfs_segbuf_prepare_write(segbuf, &wi);
 
@@ -551,6 +575,10 @@ static int nilfs_segbuf_wait(struct nilfs_segment_buffer *segbuf)
 {
 	int err = 0;
 
+	nilfs2_debug((DBG_SEGBUF | DBG_DUMP_STACK | DBG_SPAM),
+			"sb_segnum %llu, sb_pseg_start %lu\n",
+			segbuf->sb_segnum, segbuf->sb_pseg_start);
+
 	if (!segbuf->sb_nbio)
 		return 0;
 
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
