From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 23/23] nilfs2: remove own inode allocator and destructor for metadata files
Date: Tue, 14 Sep 2010 00:37:24 +0900
Message-ID: <1284392244-27100-24-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This finally removes own inode allocator and destructor functions for
metadata files.  Several routines, nilfs_mdt_new(),
nilfs_mdt_new_common(), nilfs_mdt_clear(), nilfs_mdt_destroy(), and
nilfs_alloc_inode_common() will be gone.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/mdt.c   |  111 -----------------------------------------------------
 fs/nilfs2/mdt.h   |    5 --
 fs/nilfs2/nilfs.h |    1 -
 fs/nilfs2/super.c |    9 +---
 4 files changed, 2 insertions(+), 124 deletions(-)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 0a2ccfc..d60fdb0 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -36,7 +36,6 @@
 
 #define NILFS_MDT_MAX_RA_BLOCKS		(16 - 1)
 
-#define INIT_UNUSED_INODE_FIELDS
 
 static int
 nilfs_mdt_insert_new_block(struct inode *inode, unsigned long block,
@@ -435,93 +434,6 @@ int nilfs_mdt_init(struct inode *inode, gfp_t gfp_mask, size_t objsz)
 	return 0;
 }
 
-/*
- * NILFS2 uses pseudo inodes for meta data files such as DAT, cpfile, sufile,
- * ifile, or gcinodes.  This allows the B-tree code and segment constructor
- * to treat them like regular files, and this helps to simplify the
- * implementation.
- *   On the other hand, some of the pseudo inodes have an irregular point:
- * They don't have valid inode->i_sb pointer because their lifetimes are
- * longer than those of the super block structs; they may continue for
- * several consecutive mounts/umounts.  This would need discussions.
- */
-/**
- * nilfs_mdt_new_common - allocate a pseudo inode for metadata file
- * @nilfs: nilfs object
- * @sb: super block instance the metadata file belongs to
- * @ino: inode number
- */
-struct inode *
-nilfs_mdt_new_common(struct the_nilfs *nilfs, struct super_block *sb,
-		     ino_t ino)
-{
-	struct inode *inode = nilfs_alloc_inode_common(nilfs);
-
-	if (!inode)
-		return NULL;
-	else {
-		struct address_space * const mapping = &inode->i_data;
-
-		inode->i_sb = sb; /* sb may be NULL for some meta data files */
-		inode->i_blkbits = nilfs->ns_blocksize_bits;
-		inode->i_flags = 0;
-		atomic_set(&inode->i_count, 1);
-		inode->i_nlink = 1;
-		inode->i_ino = ino;
-
-#ifdef INIT_UNUSED_INODE_FIELDS
-		atomic_set(&inode->i_writecount, 0);
-		inode->i_size = 0;
-		inode->i_blocks = 0;
-		inode->i_bytes = 0;
-		inode->i_generation = 0;
-#ifdef CONFIG_QUOTA
-		memset(&inode->i_dquot, 0, sizeof(inode->i_dquot));
-#endif
-		inode->i_pipe = NULL;
-		inode->i_bdev = NULL;
-		inode->i_cdev = NULL;
-		inode->i_rdev = 0;
-#ifdef CONFIG_SECURITY
-		inode->i_security = NULL;
-#endif
-		inode->dirtied_when = 0;
-
-		INIT_LIST_HEAD(&inode->i_list);
-		INIT_LIST_HEAD(&inode->i_sb_list);
-		inode->i_state = 0;
-#endif
-
-		spin_lock_init(&inode->i_lock);
-		mutex_init(&inode->i_mutex);
-		init_rwsem(&inode->i_alloc_sem);
-
-		mapping->host = NULL;  /* instead of inode */
-		mapping->flags = 0;
-		mapping->assoc_mapping = NULL;
-
-		inode->i_mapping = mapping;
-	}
-
-	return inode;
-}
-
-struct inode *nilfs_mdt_new(struct the_nilfs *nilfs, struct super_block *sb,
-			    ino_t ino, size_t objsz)
-{
-	struct inode *inode;
-
-	inode = nilfs_mdt_new_common(nilfs, sb, ino);
-	if (!inode)
-		return NULL;
-
-	if (nilfs_mdt_init(inode, NILFS_MDT_GFP, objsz) < 0) {
-		nilfs_destroy_inode(inode);
-		return NULL;
-	}
-	return inode;
-}
-
 void nilfs_mdt_set_entry_size(struct inode *inode, unsigned entry_size,
 			      unsigned header_size)
 {
@@ -688,26 +600,3 @@ void nilfs_mdt_clear_shadow_map(struct inode *inode)
 	truncate_inode_pages(&shadow->frozen_btnodes, 0);
 	up_write(&mi->mi_sem);
 }
-
-static void nilfs_mdt_clear(struct inode *inode)
-{
-	struct nilfs_inode_info *ii = NILFS_I(inode);
-
-	invalidate_mapping_pages(inode->i_mapping, 0, -1);
-	truncate_inode_pages(inode->i_mapping, 0);
-
-	if (test_bit(NILFS_I_BMAP, &ii->i_state))
-		nilfs_bmap_clear(ii->i_bmap);
-	nilfs_btnode_cache_clear(&ii->i_btnode_cache);
-}
-
-void nilfs_mdt_destroy(struct inode *inode)
-{
-	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
-
-	if (mdi->mi_palloc_cache)
-		nilfs_palloc_destroy_cache(inode);
-	nilfs_mdt_clear(inode);
-
-	nilfs_destroy_inode(inode);
-}
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index 76356d2..b13734b 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -82,11 +82,6 @@ int nilfs_mdt_mark_block_dirty(struct inode *, unsigned long);
 int nilfs_mdt_fetch_dirty(struct inode *);
 
 int nilfs_mdt_init(struct inode *inode, gfp_t gfp_mask, size_t objsz);
-struct inode *nilfs_mdt_new(struct the_nilfs *, struct super_block *, ino_t,
-			    size_t);
-struct inode *nilfs_mdt_new_common(struct the_nilfs *, struct super_block *,
-				   ino_t);
-void nilfs_mdt_destroy(struct inode *);
 void nilfs_mdt_set_entry_size(struct inode *, unsigned, unsigned);
 
 int nilfs_mdt_setup_shadow_map(struct inode *inode,
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index f6e276e..f7560da 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -266,7 +266,6 @@ extern int nilfs_mark_inode_dirty(struct inode *);
 extern void nilfs_dirty_inode(struct inode *);
 
 /* super.c */
-extern struct inode *nilfs_alloc_inode_common(struct the_nilfs *);
 extern struct inode *nilfs_alloc_inode(struct super_block *);
 extern void nilfs_destroy_inode(struct inode *);
 extern void nilfs_error(struct super_block *, const char *, const char *, ...)
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index c0ce90b..7bd4b75 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -147,7 +147,7 @@ void nilfs_warning(struct super_block *sb, const char *function,
 }
 
 
-struct inode *nilfs_alloc_inode_common(struct the_nilfs *nilfs)
+struct inode *nilfs_alloc_inode(struct super_block *sb)
 {
 	struct nilfs_inode_info *ii;
 
@@ -158,15 +158,10 @@ struct inode *nilfs_alloc_inode_common(struct the_nilfs *nilfs)
 	ii->i_state = 0;
 	ii->i_cno = 0;
 	ii->vfs_inode.i_version = 1;
-	nilfs_btnode_cache_init(&ii->i_btnode_cache, nilfs->ns_bdi);
+	nilfs_btnode_cache_init(&ii->i_btnode_cache, sb->s_bdi);
 	return &ii->vfs_inode;
 }
 
-struct inode *nilfs_alloc_inode(struct super_block *sb)
-{
-	return nilfs_alloc_inode_common(NILFS_SB(sb)->s_nilfs);
-}
-
 void nilfs_destroy_inode(struct inode *inode)
 {
 	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
-- 
1.6.6.2

