From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 15/24] nilfs2: implement buffer management subsystem
 debugging output
Date: Mon, 17 Jun 2013 16:25:05 +0400
Message-ID: <1371471905.2075.147.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=duae+oswsslZNzBw8yLRRzhMz6SK2tLrVRaSIQiuhQI=;
	b=ZnsAhcm9ovwuobLwLLAPC5741b37OqLGcX3YsRU5TFiPiXrLzkmfUR0UlUB1IpPxN5wdy1a4aciX7TCnvldgJoGKwbLOhJwfK2Hm5b7pSjAb6wsJ5j89yL6aj/ePv1bb;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Linux FS Devel <linux-fsdevel@vger.kernel.org>

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 15/24] nilfs2: implement buffer management subsystem debugging output

This patch adds debugging output by means of nilfs2_debug() method
into modules that are grouped by buffer management subsystem debugging
output option (CONFIG_NILFS2_DEBUG_BUFFER_MANAGEMENT).

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/page.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 0ba6798..330f172 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -47,6 +47,12 @@ __nilfs_get_page_block(struct page *page, unsigned long block, pgoff_t index,
 	unsigned long first_block;
 	struct buffer_head *bh;
 
+	nilfs2_debug(DBG_PAGE,
+			"i_ino %lu, block %lu, index %lu, "
+			"blkbits %d, b_state %#lx\n",
+			page->mapping->host->i_ino,
+			block, index, blkbits, b_state);
+
 	if (!page_has_buffers(page))
 		create_empty_buffers(page, 1 << blkbits, b_state);
 
@@ -68,6 +74,10 @@ struct buffer_head *nilfs_grab_buffer(struct inode *inode,
 	struct page *page;
 	struct buffer_head *bh;
 
+	nilfs2_debug(DBG_PAGE,
+			"i_ino %lu, blkoff %lu, b_state %#lx\n",
+			inode->i_ino, blkoff, b_state);
+
 	page = grab_cache_page(mapping, index);
 	if (unlikely(!page))
 		return NULL;
@@ -90,6 +100,10 @@ void nilfs_forget_buffer(struct buffer_head *bh)
 {
 	struct page *page = bh->b_page;
 
+	nilfs2_debug(DBG_PAGE,
+		"i_ino %lu, bh->b_blocknr %lu, bh->b_size %lu\n",
+		page->mapping->host->i_ino, bh->b_blocknr, bh->b_size);
+
 	lock_buffer(bh);
 	clear_buffer_nilfs_volatile(bh);
 	clear_buffer_nilfs_checked(bh);
@@ -119,6 +133,10 @@ void nilfs_copy_buffer(struct buffer_head *dbh, struct buffer_head *sbh)
 	struct page *spage = sbh->b_page, *dpage = dbh->b_page;
 	struct buffer_head *bh;
 
+	nilfs2_debug(DBG_PAGE,
+			"dbh->b_blocknr %lu, sbh->b_blocknr %lu\n",
+			dbh->b_blocknr, sbh->b_blocknr);
+
 	kaddr0 = kmap_atomic(spage);
 	kaddr1 = kmap_atomic(dpage);
 	memcpy(kaddr1 + bh_offset(dbh), kaddr0 + bh_offset(sbh), sbh->b_size);
@@ -157,6 +175,9 @@ int nilfs_page_buffers_clean(struct page *page)
 {
 	struct buffer_head *bh, *head;
 
+	nilfs2_debug(DBG_PAGE,
+			"i_ino %lu\n", page->mapping->host->i_ino);
+
 	bh = head = page_buffers(page);
 	do {
 		if (buffer_dirty(bh))
@@ -214,6 +235,13 @@ static void nilfs_copy_page(struct page *dst, struct page *src, int copy_dirty)
 	struct buffer_head *dbh, *dbufs, *sbh, *sbufs;
 	unsigned long mask = NILFS_BUFFER_INHERENT_BITS;
 
+	nilfs2_debug(DBG_PAGE,
+			"ino %lu, dst offset %llu, "
+			"src offset  %llu, copy_dirty %d\n",
+			src->mapping->host->i_ino,
+			page_offset(dst), page_offset(src),
+			copy_dirty);
+
 	BUG_ON(PageWriteback(dst));
 
 	sbh = sbufs = page_buffers(src);
@@ -261,6 +289,9 @@ int nilfs_copy_dirty_pages(struct address_space *dmap,
 	pgoff_t index = 0;
 	int err = 0;
 
+	nilfs2_debug(DBG_PAGE,
+			"i_ino %lu\n", smap->host->i_ino);
+
 	pagevec_init(&pvec, 0);
 repeat:
 	if (!pagevec_lookup_tag(&pvec, smap, &index, PAGECACHE_TAG_DIRTY,
@@ -316,6 +347,9 @@ void nilfs_copy_back_pages(struct address_space *dmap,
 	pgoff_t index = 0;
 	int err;
 
+	nilfs2_debug(DBG_PAGE,
+			"i_ino %lu\n", smap->host->i_ino);
+
 	pagevec_init(&pvec, 0);
 repeat:
 	n = pagevec_lookup(&pvec, smap, index, PAGEVEC_SIZE);
@@ -381,6 +415,9 @@ void nilfs_clear_dirty_pages(struct address_space *mapping, bool silent)
 	unsigned int i;
 	pgoff_t index = 0;
 
+	nilfs2_debug(DBG_PAGE,
+			"i_ino %lu\n", mapping->host->i_ino);
+
 	pagevec_init(&pvec, 0);
 
 	while (pagevec_lookup_tag(&pvec, mapping, &index, PAGECACHE_TAG_DIRTY,
@@ -449,6 +486,10 @@ unsigned nilfs_page_count_clean_buffers(struct page *page,
 	struct buffer_head *bh, *head;
 	unsigned nc = 0;
 
+	nilfs2_debug(DBG_PAGE,
+			"i_ino %lu, from %u, to %u\n",
+			page->mapping->host->i_ino, from, to);
+
 	for (bh = head = page_buffers(page), block_start = 0;
 	     bh != head || !block_start;
 	     block_start = block_end, bh = bh->b_this_page) {
@@ -462,6 +503,8 @@ unsigned nilfs_page_count_clean_buffers(struct page *page,
 void nilfs_mapping_init(struct address_space *mapping, struct inode *inode,
 			struct backing_dev_info *bdi)
 {
+	nilfs2_debug(DBG_PAGE, "i_ino %lu\n", inode->i_ino);
+
 	mapping->host = inode;
 	mapping->flags = 0;
 	mapping_set_gfp_mask(mapping, GFP_NOFS);
@@ -485,6 +528,9 @@ int __nilfs_clear_page_dirty(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
 
+	nilfs2_debug(DBG_PAGE,
+			"i_ino %lu\n", page->mapping->host->i_ino);
+
 	if (mapping) {
 		spin_lock_irq(&mapping->tree_lock);
 		if (test_bit(PG_dirty, &page->flags)) {
@@ -524,6 +570,10 @@ unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
 	struct pagevec pvec;
 	struct page *page;
 
+	nilfs2_debug(DBG_PAGE,
+			"i_ino %lu, start_blk %lu, blkoff %p\n",
+			inode->i_ino, start_blk, blkoff);
+
 	if (inode->i_mapping->nrpages == 0)
 		return 0;
 
-- 
1.7.9.5



