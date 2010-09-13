From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 16/23] nilfs2: add routines to roll back state of DAT file
Date: Tue, 14 Sep 2010 00:37:17 +0900
Message-ID: <1284392244-27100-17-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This adds optional function to metadata files which makes a copy of
bmap, page caches, and b-tree node cache, and rolls back to the copy
as needed.

This enhancement is intended to displace gcdat inode that provides a
similar function in a different way.

In this patch, nilfs_shadow_map structure is added to store a copy of
the foregoing states.  nilfs_mdt_setup_shadow_map relates this
structure to a metadata file.  And, nilfs_mdt_save_to_shadow_map() and
nilfs_mdt_restore_from_shadow_map() provides save and restore
functions respectively.  Finally, nilfs_mdt_clear_shadow_map() clears
states of nilfs_shadow_map.

The copy of b-tree node cache and page cache is made by duplicating
only dirty pages into corresponding caches in nilfs_shadow_map.  Their
restoration is done by clearing dirty pages from original caches and
by copying dirty pages back from nilfs_shadow_map.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/btnode.c |   17 +-------
 fs/nilfs2/mdt.c    |  104 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/nilfs2/mdt.h    |   14 +++++++
 fs/nilfs2/page.c   |   25 ++++++++++++
 fs/nilfs2/page.h   |    4 ++
 5 files changed, 145 insertions(+), 19 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index f78ab10..5115814 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -37,15 +37,7 @@
 
 void nilfs_btnode_cache_init_once(struct address_space *btnc)
 {
-	memset(btnc, 0, sizeof(*btnc));
-	INIT_RADIX_TREE(&btnc->page_tree, GFP_ATOMIC);
-	spin_lock_init(&btnc->tree_lock);
-	INIT_LIST_HEAD(&btnc->private_list);
-	spin_lock_init(&btnc->private_lock);
-
-	spin_lock_init(&btnc->i_mmap_lock);
-	INIT_RAW_PRIO_TREE_ROOT(&btnc->i_mmap);
-	INIT_LIST_HEAD(&btnc->i_mmap_nonlinear);
+	nilfs_mapping_init_once(btnc);
 }
 
 static const struct address_space_operations def_btnode_aops = {
@@ -55,12 +47,7 @@ static const struct address_space_operations def_btnode_aops = {
 void nilfs_btnode_cache_init(struct address_space *btnc,
 			     struct backing_dev_info *bdi)
 {
-	btnc->host = NULL;  /* can safely set to host inode ? */
-	btnc->flags = 0;
-	mapping_set_gfp_mask(btnc, GFP_NOFS);
-	btnc->assoc_mapping = NULL;
-	btnc->backing_dev_info = bdi;
-	btnc->a_ops = &def_btnode_aops;
+	nilfs_mapping_init(btnc, bdi, &def_btnode_aops);
 }
 
 void nilfs_btnode_cache_clear(struct address_space *btnc)
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 73e5da3..0066468 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -398,16 +398,22 @@ int nilfs_mdt_fetch_dirty(struct inode *inode)
 static int
 nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 {
-	struct inode *inode = container_of(page->mapping,
-					   struct inode, i_data);
-	struct super_block *sb = inode->i_sb;
-	struct the_nilfs *nilfs = NILFS_MDT(inode)->mi_nilfs;
+	struct inode *inode;
+	struct super_block *sb;
+	struct the_nilfs *nilfs;
 	struct nilfs_sb_info *writer = NULL;
 	int err = 0;
 
 	redirty_page_for_writepage(wbc, page);
 	unlock_page(page);
 
+	inode = page->mapping->host;
+	if (!inode)
+		return 0;
+
+	sb = inode->i_sb;
+	nilfs = NILFS_MDT(inode)->mi_nilfs;
+
 	if (page->mapping->assoc_mapping)
 		return 0; /* Do not request flush for shadow page cache */
 	if (!sb) {
@@ -567,6 +573,96 @@ void nilfs_mdt_set_shadow(struct inode *orig, struct inode *shadow)
 		&NILFS_I(orig)->i_btnode_cache;
 }
 
+static const struct address_space_operations shadow_map_aops = {
+	.sync_page		= block_sync_page,
+};
+
+/**
+ * nilfs_mdt_setup_shadow_map - setup shadow map and bind it to metadata file
+ * @inode: inode of the metadata file
+ * @shadow: shadow mapping
+ */
+int nilfs_mdt_setup_shadow_map(struct inode *inode,
+			       struct nilfs_shadow_map *shadow)
+{
+	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
+	struct backing_dev_info *bdi = NILFS_I_NILFS(inode)->ns_bdi;
+
+	INIT_LIST_HEAD(&shadow->frozen_buffers);
+	nilfs_mapping_init_once(&shadow->frozen_data);
+	nilfs_mapping_init(&shadow->frozen_data, bdi, &shadow_map_aops);
+	nilfs_mapping_init_once(&shadow->frozen_btnodes);
+	nilfs_mapping_init(&shadow->frozen_btnodes, bdi, &shadow_map_aops);
+	mi->mi_shadow = shadow;
+	return 0;
+}
+
+/**
+ * nilfs_mdt_save_to_shadow_map - copy bmap and dirty pages to shadow map
+ * @inode: inode of the metadata file
+ */
+int nilfs_mdt_save_to_shadow_map(struct inode *inode)
+{
+	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	struct nilfs_shadow_map *shadow = mi->mi_shadow;
+	int ret;
+
+	ret = nilfs_copy_dirty_pages(&shadow->frozen_data, inode->i_mapping);
+	if (ret)
+		goto out;
+
+	ret = nilfs_copy_dirty_pages(&shadow->frozen_btnodes,
+				     &ii->i_btnode_cache);
+	if (ret)
+		goto out;
+
+	nilfs_bmap_save(ii->i_bmap, &shadow->bmap_store);
+ out:
+	return ret;
+}
+
+/**
+ * nilfs_mdt_restore_from_shadow_map - restore dirty pages and bmap state
+ * @inode: inode of the metadata file
+ */
+void nilfs_mdt_restore_from_shadow_map(struct inode *inode)
+{
+	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	struct nilfs_shadow_map *shadow = mi->mi_shadow;
+
+	down_write(&mi->mi_sem);
+
+	if (mi->mi_palloc_cache)
+		nilfs_palloc_clear_cache(inode);
+
+	nilfs_clear_dirty_pages(inode->i_mapping);
+	nilfs_copy_back_pages(inode->i_mapping, &shadow->frozen_data);
+
+	nilfs_clear_dirty_pages(&ii->i_btnode_cache);
+	nilfs_copy_back_pages(&ii->i_btnode_cache, &shadow->frozen_btnodes);
+
+	nilfs_bmap_restore(ii->i_bmap, &shadow->bmap_store);
+
+	up_write(&mi->mi_sem);
+}
+
+/**
+ * nilfs_mdt_clear_shadow_map - truncate pages in shadow map caches
+ * @inode: inode of the metadata file
+ */
+void nilfs_mdt_clear_shadow_map(struct inode *inode)
+{
+	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
+	struct nilfs_shadow_map *shadow = mi->mi_shadow;
+
+	down_write(&mi->mi_sem);
+	truncate_inode_pages(&shadow->frozen_data, 0);
+	truncate_inode_pages(&shadow->frozen_btnodes, 0);
+	up_write(&mi->mi_sem);
+}
+
 static void nilfs_mdt_clear(struct inode *inode)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index f445602..e7f0d15 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -28,6 +28,13 @@
 #include "nilfs.h"
 #include "page.h"
 
+struct nilfs_shadow_map {
+	struct nilfs_bmap_store bmap_store;
+	struct address_space frozen_data;
+	struct address_space frozen_btnodes;
+	struct list_head frozen_buffers;
+};
+
 /**
  * struct nilfs_mdt_info - on-memory private data of meta data files
  * @mi_nilfs: back pointer to the_nilfs struct
@@ -37,6 +44,7 @@
  * @mi_first_entry_offset: offset to the first entry
  * @mi_entries_per_block: number of entries in a block
  * @mi_palloc_cache: persistent object allocator cache
+ * @mi_shadow: shadow of bmap and page caches
  * @mi_blocks_per_group: number of blocks in a group
  * @mi_blocks_per_desc_block: number of blocks per descriptor block
  */
@@ -48,6 +56,7 @@ struct nilfs_mdt_info {
 	unsigned		mi_first_entry_offset;
 	unsigned long		mi_entries_per_block;
 	struct nilfs_palloc_cache *mi_palloc_cache;
+	struct nilfs_shadow_map *mi_shadow;
 	unsigned long		mi_blocks_per_group;
 	unsigned long		mi_blocks_per_desc_block;
 };
@@ -86,6 +95,11 @@ void nilfs_mdt_destroy(struct inode *);
 void nilfs_mdt_set_entry_size(struct inode *, unsigned, unsigned);
 void nilfs_mdt_set_shadow(struct inode *, struct inode *);
 
+int nilfs_mdt_setup_shadow_map(struct inode *inode,
+			       struct nilfs_shadow_map *shadow);
+int nilfs_mdt_save_to_shadow_map(struct inode *inode);
+void nilfs_mdt_restore_from_shadow_map(struct inode *inode);
+void nilfs_mdt_clear_shadow_map(struct inode *inode);
 
 #define nilfs_mdt_mark_buffer_dirty(bh)	nilfs_mark_buffer_dirty(bh)
 
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index aab11db..6384ac1 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -513,6 +513,31 @@ unsigned nilfs_page_count_clean_buffers(struct page *page,
 	}
 	return nc;
 }
+ 
+void nilfs_mapping_init_once(struct address_space *mapping)
+{
+	memset(mapping, 0, sizeof(*mapping));
+	INIT_RADIX_TREE(&mapping->page_tree, GFP_ATOMIC);
+	spin_lock_init(&mapping->tree_lock);
+	INIT_LIST_HEAD(&mapping->private_list);
+	spin_lock_init(&mapping->private_lock);
+
+	spin_lock_init(&mapping->i_mmap_lock);
+	INIT_RAW_PRIO_TREE_ROOT(&mapping->i_mmap);
+	INIT_LIST_HEAD(&mapping->i_mmap_nonlinear);
+}
+
+void nilfs_mapping_init(struct address_space *mapping,
+			struct backing_dev_info *bdi,
+			const struct address_space_operations *aops)
+{
+	mapping->host = NULL;
+	mapping->flags = 0;
+	mapping_set_gfp_mask(mapping, GFP_NOFS);
+	mapping->assoc_mapping = NULL;
+	mapping->backing_dev_info = bdi;
+	mapping->a_ops = aops;
+}
 
 /*
  * NILFS2 needs clear_page_dirty() in the following two cases:
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index f53d8da..6ec4f49 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -59,6 +59,10 @@ void nilfs_free_private_page(struct page *);
 int nilfs_copy_dirty_pages(struct address_space *, struct address_space *);
 void nilfs_copy_back_pages(struct address_space *, struct address_space *);
 void nilfs_clear_dirty_pages(struct address_space *);
+void nilfs_mapping_init_once(struct address_space *mapping);
+void nilfs_mapping_init(struct address_space *mapping,
+			struct backing_dev_info *bdi,
+			const struct address_space_operations *aops);
 unsigned nilfs_page_count_clean_buffers(struct page *, unsigned, unsigned);
 
 #define NILFS_PAGE_BUG(page, m, a...) \
-- 
1.6.6.2

