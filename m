From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 17/23] nilfs2: add routines to redirect access to buffers of DAT file
Date: Tue, 14 Sep 2010 00:37:18 +0900
Message-ID: <1284392244-27100-18-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

During garbage collection (GC), DAT file, which converts virtual block
number to real block number, may return disk block number that is not
yet written to the device.

To avoid access to unwritten blocks, the current implementation stores
changes to the caches of GCDAT during GC and atomically commit the
changes into the DAT file after they are written to the device.

This patch, instead, adds a function that makes a copy of specified
buffer and stores it in nilfs_shadow_map, and a function to get the
backup copy as needed (nilfs_mdt_freeze_buffer and
nilfs_mdt_get_frozen_buffer respectively).

Before DAT changes block number in an entry block, it makes a copy and
redirect access to the buffer so that address conversion function
(i.e. nilfs_dat_translate) refers to the old address saved in the
copy.

This patch gives requisites for such redirection.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/mdt.c     |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/mdt.h     |    3 ++
 fs/nilfs2/page.c    |    2 +
 fs/nilfs2/page.h    |    2 +
 fs/nilfs2/segment.c |    1 +
 5 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 0066468..532f85a 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -622,6 +622,72 @@ int nilfs_mdt_save_to_shadow_map(struct inode *inode)
 	return ret;
 }
 
+int nilfs_mdt_freeze_buffer(struct inode *inode, struct buffer_head *bh)
+{
+	struct nilfs_shadow_map *shadow = NILFS_MDT(inode)->mi_shadow;
+	struct buffer_head *bh_frozen;
+	struct page *page;
+	int blkbits = inode->i_blkbits;
+	int ret = -ENOMEM;
+
+	page = grab_cache_page(&shadow->frozen_data, bh->b_page->index);
+	if (!page)
+		return ret;
+
+	if (!page_has_buffers(page))
+		create_empty_buffers(page, 1 << blkbits, 0);
+
+	bh_frozen = nilfs_page_get_nth_block(page, bh_offset(bh) >> blkbits);
+	if (bh_frozen) {
+		if (!buffer_uptodate(bh_frozen))
+			nilfs_copy_buffer(bh_frozen, bh);
+		if (list_empty(&bh_frozen->b_assoc_buffers)) {
+			list_add_tail(&bh_frozen->b_assoc_buffers,
+				      &shadow->frozen_buffers);
+			set_buffer_nilfs_redirected(bh);
+		} else {
+			brelse(bh_frozen); /* already frozen */
+		}
+		ret = 0;
+	}
+	unlock_page(page);
+	page_cache_release(page);
+	return ret;
+}
+
+struct buffer_head *
+nilfs_mdt_get_frozen_buffer(struct inode *inode, struct buffer_head *bh)
+{
+	struct nilfs_shadow_map *shadow = NILFS_MDT(inode)->mi_shadow;
+	struct buffer_head *bh_frozen = NULL;
+	struct page *page;
+	int n;
+
+	page = find_lock_page(&shadow->frozen_data, bh->b_page->index);
+	if (page) {
+		if (page_has_buffers(page)) {
+			n = bh_offset(bh) >> inode->i_blkbits;
+			bh_frozen = nilfs_page_get_nth_block(page, n);
+		}
+		unlock_page(page);
+		page_cache_release(page);
+	}
+	return bh_frozen;
+}
+
+static void nilfs_release_frozen_buffers(struct nilfs_shadow_map *shadow)
+{
+	struct list_head *head = &shadow->frozen_buffers;
+	struct buffer_head *bh;
+
+	while (!list_empty(head)) {
+		bh = list_first_entry(head, struct buffer_head,
+				      b_assoc_buffers);
+		list_del_init(&bh->b_assoc_buffers);
+		brelse(bh); /* drop ref-count to make it releasable */
+	}
+}
+
 /**
  * nilfs_mdt_restore_from_shadow_map - restore dirty pages and bmap state
  * @inode: inode of the metadata file
@@ -658,6 +724,7 @@ void nilfs_mdt_clear_shadow_map(struct inode *inode)
 	struct nilfs_shadow_map *shadow = mi->mi_shadow;
 
 	down_write(&mi->mi_sem);
+	nilfs_release_frozen_buffers(shadow);
 	truncate_inode_pages(&shadow->frozen_data, 0);
 	truncate_inode_pages(&shadow->frozen_btnodes, 0);
 	up_write(&mi->mi_sem);
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index e7f0d15..e60bbfe 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -100,6 +100,9 @@ int nilfs_mdt_setup_shadow_map(struct inode *inode,
 int nilfs_mdt_save_to_shadow_map(struct inode *inode);
 void nilfs_mdt_restore_from_shadow_map(struct inode *inode);
 void nilfs_mdt_clear_shadow_map(struct inode *inode);
+int nilfs_mdt_freeze_buffer(struct inode *inode, struct buffer_head *bh);
+struct buffer_head *nilfs_mdt_get_frozen_buffer(struct inode *inode,
+						struct buffer_head *bh);
 
 #define nilfs_mdt_mark_buffer_dirty(bh)	nilfs_mark_buffer_dirty(bh)
 
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 6384ac1..7083344 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -131,6 +131,7 @@ void nilfs_forget_buffer(struct buffer_head *bh)
 	lock_buffer(bh);
 	clear_buffer_nilfs_volatile(bh);
 	clear_buffer_nilfs_checked(bh);
+	clear_buffer_nilfs_redirected(bh);
 	clear_buffer_dirty(bh);
 	if (nilfs_page_buffers_clean(page))
 		__nilfs_clear_page_dirty(page);
@@ -483,6 +484,7 @@ void nilfs_clear_dirty_pages(struct address_space *mapping)
 				clear_buffer_dirty(bh);
 				clear_buffer_nilfs_volatile(bh);
 				clear_buffer_nilfs_checked(bh);
+				clear_buffer_nilfs_redirected(bh);
 				clear_buffer_uptodate(bh);
 				clear_buffer_mapped(bh);
 				unlock_buffer(bh);
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index 6ec4f49..fb9e8a8 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -35,12 +35,14 @@ enum {
 	BH_NILFS_Node,
 	BH_NILFS_Volatile,
 	BH_NILFS_Checked,
+	BH_NILFS_Redirected,
 };
 
 BUFFER_FNS(NILFS_Allocated, nilfs_allocated)	/* nilfs private buffers */
 BUFFER_FNS(NILFS_Node, nilfs_node)		/* nilfs node buffers */
 BUFFER_FNS(NILFS_Volatile, nilfs_volatile)
 BUFFER_FNS(NILFS_Checked, nilfs_checked)	/* buffer is verified */
+BUFFER_FNS(NILFS_Redirected, nilfs_redirected)	/* redirected to a copy */
 
 
 void nilfs_mark_buffer_dirty(struct buffer_head *bh);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index b75306d..91dc066 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1908,6 +1908,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 			set_buffer_uptodate(bh);
 			clear_buffer_dirty(bh);
 			clear_buffer_nilfs_volatile(bh);
+			clear_buffer_nilfs_redirected(bh);
 			if (bh == segbuf->sb_super_root) {
 				if (bh->b_page != bd_page) {
 					end_page_writeback(bd_page);
-- 
1.6.6.2

