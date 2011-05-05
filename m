From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/5] nilfs2: always set back pointer to host inode in mapping->host
Date: Thu,  5 May 2011 13:13:52 +0900
Message-ID: <1304568833-31021-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1304568833-31021-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1304568833-31021-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

In the current nilfs, page cache for btree nodes and meta data files
do not set a valid back pointer to the host inode in mapping->host.

This will change it so that every address space in nilfs uses
mapping->host to hold its host inode.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btnode.c  |    6 ------
 fs/nilfs2/btnode.h  |    1 -
 fs/nilfs2/mdt.c     |    4 ++--
 fs/nilfs2/nilfs.h   |    6 ------
 fs/nilfs2/page.c    |   13 +++++--------
 fs/nilfs2/page.h    |    2 +-
 fs/nilfs2/segment.c |   16 +++++-----------
 fs/nilfs2/super.c   |    2 +-
 8 files changed, 14 insertions(+), 36 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 4817560..c353e4f 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -34,12 +34,6 @@
 #include "page.h"
 #include "btnode.h"
 
-void nilfs_btnode_cache_init(struct address_space *btnc,
-			     struct backing_dev_info *bdi)
-{
-	nilfs_mapping_init(btnc, bdi);
-}
-
 void nilfs_btnode_cache_clear(struct address_space *btnc)
 {
 	invalidate_mapping_pages(btnc, 0, -1);
diff --git a/fs/nilfs2/btnode.h b/fs/nilfs2/btnode.h
index 1b8ebd8..7de449c 100644
--- a/fs/nilfs2/btnode.h
+++ b/fs/nilfs2/btnode.h
@@ -37,7 +37,6 @@ struct nilfs_btnode_chkey_ctxt {
 	struct buffer_head *newbh;
 };
 
-void nilfs_btnode_cache_init(struct address_space *, struct backing_dev_info *);
 void nilfs_btnode_cache_clear(struct address_space *);
 struct buffer_head *nilfs_btnode_create_block(struct address_space *btnc,
 					      __u64 blocknr);
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index a649b05..6790ca6 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -450,9 +450,9 @@ int nilfs_mdt_setup_shadow_map(struct inode *inode,
 
 	INIT_LIST_HEAD(&shadow->frozen_buffers);
 	address_space_init_once(&shadow->frozen_data);
-	nilfs_mapping_init(&shadow->frozen_data, bdi);
+	nilfs_mapping_init(&shadow->frozen_data, inode, bdi);
 	address_space_init_once(&shadow->frozen_btnodes);
-	nilfs_mapping_init(&shadow->frozen_btnodes, bdi);
+	nilfs_mapping_init(&shadow->frozen_btnodes, inode, bdi);
 	mi->mi_shadow = shadow;
 	return 0;
 }
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 09af009..a9c6a53 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -80,12 +80,6 @@ static inline struct inode *NILFS_BTNC_I(struct address_space *btnc)
 	return &ii->vfs_inode;
 }
 
-static inline struct inode *NILFS_AS_I(struct address_space *mapping)
-{
-	return (mapping->host) ? :
-		container_of(mapping, struct inode, i_data);
-}
-
 /*
  * Dynamic state flags of NILFS on-memory inode (i_state)
  */
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index b3b988c..3f18f5c 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -182,7 +182,7 @@ int nilfs_page_buffers_clean(struct page *page)
 void nilfs_page_bug(struct page *page)
 {
 	struct address_space *m;
-	unsigned long ino = 0;
+	unsigned long ino;
 
 	if (unlikely(!page)) {
 		printk(KERN_CRIT "NILFS_PAGE_BUG(NULL)\n");
@@ -190,11 +190,8 @@ void nilfs_page_bug(struct page *page)
 	}
 
 	m = page->mapping;
-	if (m) {
-		struct inode *inode = NILFS_AS_I(m);
-		if (inode != NULL)
-			ino = inode->i_ino;
-	}
+	ino = m ? m->host->i_ino : 0;
+
 	printk(KERN_CRIT "NILFS_PAGE_BUG(%p): cnt=%d index#=%llu flags=0x%lx "
 	       "mapping=%p ino=%lu\n",
 	       page, atomic_read(&page->_count),
@@ -441,10 +438,10 @@ unsigned nilfs_page_count_clean_buffers(struct page *page,
 	return nc;
 }
 
-void nilfs_mapping_init(struct address_space *mapping,
+void nilfs_mapping_init(struct address_space *mapping, struct inode *inode,
 			struct backing_dev_info *bdi)
 {
-	mapping->host = NULL;
+	mapping->host = inode;
 	mapping->flags = 0;
 	mapping_set_gfp_mask(mapping, GFP_NOFS);
 	mapping->assoc_mapping = NULL;
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index f827afa..e301e56 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -57,7 +57,7 @@ void nilfs_page_bug(struct page *);
 int nilfs_copy_dirty_pages(struct address_space *, struct address_space *);
 void nilfs_copy_back_pages(struct address_space *, struct address_space *);
 void nilfs_clear_dirty_pages(struct address_space *);
-void nilfs_mapping_init(struct address_space *mapping,
+void nilfs_mapping_init(struct address_space *mapping, struct inode *inode,
 			struct backing_dev_info *bdi);
 unsigned nilfs_page_count_clean_buffers(struct page *, unsigned, unsigned);
 unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 186cabb..eeb1bc2 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -655,13 +655,10 @@ static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
 		if (unlikely(page->index > last))
 			break;
 
-		if (mapping->host) {
-			lock_page(page);
-			if (!page_has_buffers(page))
-				create_empty_buffers(page,
-						     1 << inode->i_blkbits, 0);
-			unlock_page(page);
-		}
+		lock_page(page);
+		if (!page_has_buffers(page))
+			create_empty_buffers(page, 1 << inode->i_blkbits, 0);
+		unlock_page(page);
 
 		bh = head = page_buffers(page);
 		do {
@@ -1503,10 +1500,7 @@ nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
 			nblocks = le32_to_cpu(finfo->fi_nblocks);
 			ndatablk = le32_to_cpu(finfo->fi_ndatablk);
 
-			if (buffer_nilfs_node(bh))
-				inode = NILFS_BTNC_I(bh->b_page->mapping);
-			else
-				inode = NILFS_AS_I(bh->b_page->mapping);
+			inode = bh->b_page->mapping->host;
 
 			if (mode == SC_LSEG_DSYNC)
 				sc_op = &nilfs_sc_dsync_ops;
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 2846491..8351c44 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -166,7 +166,7 @@ struct inode *nilfs_alloc_inode(struct super_block *sb)
 	ii->i_state = 0;
 	ii->i_cno = 0;
 	ii->vfs_inode.i_version = 1;
-	nilfs_btnode_cache_init(&ii->i_btnode_cache, sb->s_bdi);
+	nilfs_mapping_init(&ii->i_btnode_cache, &ii->vfs_inode, sb->s_bdi);
 	return &ii->vfs_inode;
 }
 
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
