From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: fiemap support
Date: Sun, 26 Dec 2010 21:56:14 +0900
Message-ID: <1293368174-1197-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1293368174-1197-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293368174-1197-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This adds fiemap to nilfs.  Two new functions, nilfs_fiemap and
nilfs_find_uncommitted_extent are added.

nilfs_fiemap() implements the fiemap inode operation, and
nilfs_find_uncommitted_extent() helps to get a range of data blocks
whose physical location has not been determined.

nilfs_fiemap() collects extent information by looping through
nilfs_bmap_lookup_contig and nilfs_find_uncommitted_extent routines.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/file.c  |    1 +
 fs/nilfs2/inode.c |  131 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/namei.c |    1 +
 fs/nilfs2/nilfs.h |    2 +
 fs/nilfs2/page.c  |   84 ++++++++++++++++++++++++++++++++++
 fs/nilfs2/page.h  |    3 +
 6 files changed, 222 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index c9a30d7..2f560c9 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -155,6 +155,7 @@ const struct inode_operations nilfs_file_inode_operations = {
 	.truncate	= nilfs_truncate,
 	.setattr	= nilfs_setattr,
 	.permission     = nilfs_permission,
+	.fiemap		= nilfs_fiemap,
 };
 
 /* end of file */
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 7a18093..e96ef23 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -912,3 +912,134 @@ void nilfs_dirty_inode(struct inode *inode)
 	nilfs_mark_inode_dirty(inode);
 	nilfs_transaction_commit(inode->i_sb); /* never fails */
 }
+
+int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
+		 __u64 start, __u64 len)
+{
+	struct the_nilfs *nilfs = NILFS_I_NILFS(inode);
+	__u64 logical = 0, phys = 0, size = 0;
+	__u32 flags = 0;
+	loff_t isize;
+	sector_t blkoff, end_blkoff;
+	sector_t delalloc_blkoff;
+	unsigned long delalloc_blklen;
+	unsigned int blkbits = inode->i_blkbits;
+	int ret, n;
+
+	ret = fiemap_check_flags(fieinfo, FIEMAP_FLAG_SYNC);
+	if (ret)
+		return ret;
+
+	mutex_lock(&inode->i_mutex);
+
+	isize = i_size_read(inode);
+
+	blkoff = start >> blkbits;
+	end_blkoff = (start + len - 1) >> blkbits;
+
+	delalloc_blklen = nilfs_find_uncommitted_extent(inode, blkoff,
+							&delalloc_blkoff);
+
+	do {
+		__u64 blkphy;
+		unsigned int maxblocks;
+
+		if (delalloc_blklen && blkoff == delalloc_blkoff) {
+			if (size) {
+				/* End of the current extent */
+				ret = fiemap_fill_next_extent(
+					fieinfo, logical, phys, size, flags);
+				if (ret)
+					break;
+			}
+			if (blkoff > end_blkoff)
+				break;
+
+			flags = FIEMAP_EXTENT_MERGED | FIEMAP_EXTENT_DELALLOC;
+			logical = blkoff << blkbits;
+			phys = 0;
+			size = delalloc_blklen << blkbits;
+
+			blkoff = delalloc_blkoff + delalloc_blklen;
+			delalloc_blklen = nilfs_find_uncommitted_extent(
+				inode, blkoff, &delalloc_blkoff);
+			continue;
+		}
+
+		/*
+		 * Limit the number of blocks that we look up so as
+		 * not to get into the next delayed allocation extent.
+		 */
+		maxblocks = INT_MAX;
+		if (delalloc_blklen)
+			maxblocks = min_t(sector_t, delalloc_blkoff - blkoff,
+					  maxblocks);
+		blkphy = 0;
+
+		down_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
+		n = nilfs_bmap_lookup_contig(
+			NILFS_I(inode)->i_bmap, blkoff, &blkphy, maxblocks);
+		up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
+
+		if (n < 0) {
+			int past_eof;
+
+			if (unlikely(n != -ENOENT))
+				break; /* error */
+
+			/* HOLE */
+			blkoff++;
+			past_eof = ((blkoff << blkbits) >= isize);
+
+			if (size) {
+				/* End of the current extent */
+
+				if (past_eof)
+					flags |= FIEMAP_EXTENT_LAST;
+
+				ret = fiemap_fill_next_extent(
+					fieinfo, logical, phys, size, flags);
+				if (ret)
+					break;
+				size = 0;
+			}
+			if (blkoff > end_blkoff || past_eof)
+				break;
+		} else {
+			if (size) {
+				if (phys && blkphy << blkbits == phys + size) {
+					/* The current extent goes on */
+					size += n << blkbits;
+				} else {
+					/* Terminate the current extent */
+					ret = fiemap_fill_next_extent(
+						fieinfo, logical, phys, size,
+						flags);
+					if (ret || blkoff > end_blkoff)
+						break;
+
+					/* Start another extent */
+					flags = FIEMAP_EXTENT_MERGED;
+					logical = blkoff << blkbits;
+					phys = blkphy << blkbits;
+					size = n << blkbits;
+				}
+			} else {
+				/* Start a new extent */
+				flags = FIEMAP_EXTENT_MERGED;
+				logical = blkoff << blkbits;
+				phys = blkphy << blkbits;
+				size = n << blkbits;
+			}
+			blkoff += n;
+		}
+		cond_resched();
+	} while (true);
+
+	/* If ret is 1 then we just hit the end of the extent array */
+	if (ret == 1)
+		ret = 0;
+
+	mutex_unlock(&inode->i_mutex);
+	return ret;
+}
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 6e9557e..9803427 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -577,6 +577,7 @@ const struct inode_operations nilfs_dir_inode_operations = {
 	.rename		= nilfs_rename,
 	.setattr	= nilfs_setattr,
 	.permission	= nilfs_permission,
+	.fiemap		= nilfs_fiemap,
 };
 
 const struct inode_operations nilfs_special_inode_operations = {
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index f7560da..5b10f14 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -264,6 +264,8 @@ extern int nilfs_set_file_dirty(struct nilfs_sb_info *, struct inode *,
 				unsigned);
 extern int nilfs_mark_inode_dirty(struct inode *);
 extern void nilfs_dirty_inode(struct inode *);
+int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
+		 __u64 start, __u64 len);
 
 /* super.c */
 extern struct inode *nilfs_alloc_inode(struct super_block *);
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index a6c3c2e8..48a775e 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -546,3 +546,87 @@ int __nilfs_clear_page_dirty(struct page *page)
 	}
 	return TestClearPageDirty(page);
 }
+
+/**
+ * nilfs_find_uncommitted_extent - find extent of uncommitted data
+ * @inode: inode
+ * @start_blk: start block offset (in)
+ * @blkoff: start offset of the found extent (out)
+ *
+ * This function searches an extent of buffers marked "delayed" which
+ * starts from a block offset equal to or larger than @start_blk.  If
+ * such an extent was found, this will store the start offset in
+ * @blkoff and return its length in blocks.  Otherwise, zero is
+ * returned.
+ */
+unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
+					    sector_t start_blk,
+					    sector_t *blkoff)
+{
+	unsigned int i;
+	pgoff_t index;
+	unsigned int nblocks_in_page;
+	unsigned long length = 0;
+	sector_t b;
+	struct pagevec pvec;
+	struct page *page;
+
+	if (inode->i_mapping->nrpages == 0)
+		return 0;
+
+	index = start_blk >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	nblocks_in_page = 1U << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+
+	pagevec_init(&pvec, 0);
+
+repeat:
+	pvec.nr = find_get_pages_contig(inode->i_mapping, index, PAGEVEC_SIZE,
+					pvec.pages);
+	if (pvec.nr == 0)
+		return length;
+
+	if (length > 0 && pvec.pages[0]->index > index)
+		goto out;
+
+	b = pvec.pages[0]->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	i = 0;
+	do {
+		page = pvec.pages[i];
+
+		lock_page(page);
+		if (page_has_buffers(page)) {
+			struct buffer_head *bh, *head;
+
+			bh = head = page_buffers(page);
+			do {
+				if (b < start_blk)
+					continue;
+				if (buffer_delay(bh)) {
+					if (length == 0)
+						*blkoff = b;
+					length++;
+				} else if (length > 0) {
+					goto out_locked;
+				}
+			} while (++b, bh = bh->b_this_page, bh != head);
+		} else {
+			if (length > 0)
+				goto out_locked;
+
+			b += nblocks_in_page;
+		}
+		unlock_page(page);
+
+	} while (++i < pagevec_count(&pvec));
+
+	index = page->index + 1;
+	pagevec_release(&pvec);
+	cond_resched();
+	goto repeat;
+
+out_locked:
+	unlock_page(page);
+out:
+	pagevec_release(&pvec);
+	return length;
+}
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index fb9e8a8..622df27 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -66,6 +66,9 @@ void nilfs_mapping_init(struct address_space *mapping,
 			struct backing_dev_info *bdi,
 			const struct address_space_operations *aops);
 unsigned nilfs_page_count_clean_buffers(struct page *, unsigned, unsigned);
+unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
+					    sector_t start_blk,
+					    sector_t *blkoff);
 
 #define NILFS_PAGE_BUG(page, m, a...) \
 	do { nilfs_page_bug(page); BUG(); } while (0)
-- 
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
