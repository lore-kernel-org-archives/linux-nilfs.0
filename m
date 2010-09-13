From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 18/23] nilfs2: get rid of GCDAT inode
Date: Tue, 14 Sep 2010 00:37:19 +0900
Message-ID: <1284392244-27100-19-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1284392244-27100-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This applies prepared rollback function and redirect function of
metadata file to DAT file, and eliminates GCDAT inode.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/Makefile    |    2 +-
 fs/nilfs2/bmap.c      |   16 ---------
 fs/nilfs2/bmap.h      |    2 -
 fs/nilfs2/dat.c       |   30 ++++++++++++++++-
 fs/nilfs2/gcdat.c     |   87 -------------------------------------------------
 fs/nilfs2/mdt.c       |    9 -----
 fs/nilfs2/mdt.h       |    1 -
 fs/nilfs2/nilfs.h     |    8 +----
 fs/nilfs2/page.c      |   28 +--------------
 fs/nilfs2/segment.c   |   14 ++++----
 fs/nilfs2/the_nilfs.c |   13 +-------
 fs/nilfs2/the_nilfs.h |    2 -
 12 files changed, 41 insertions(+), 171 deletions(-)
 delete mode 100644 fs/nilfs2/gcdat.c

diff --git a/fs/nilfs2/Makefile b/fs/nilfs2/Makefile
index df3e62c..85c9873 100644
--- a/fs/nilfs2/Makefile
+++ b/fs/nilfs2/Makefile
@@ -2,4 +2,4 @@ obj-$(CONFIG_NILFS2_FS) += nilfs2.o
 nilfs2-y := inode.o file.o dir.o super.o namei.o page.o mdt.o \
 	btnode.o bmap.o btree.o direct.o dat.o recovery.o \
 	the_nilfs.o segbuf.o segment.o cpfile.o sufile.o \
-	ifile.o alloc.o gcinode.o ioctl.o gcdat.o
+	ifile.o alloc.o gcinode.o ioctl.o
diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index 0024440..8b782b0 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -533,22 +533,6 @@ void nilfs_bmap_init_gc(struct nilfs_bmap *bmap)
 	nilfs_btree_init_gc(bmap);
 }
 
-void nilfs_bmap_init_gcdat(struct nilfs_bmap *gcbmap, struct nilfs_bmap *bmap)
-{
-	memcpy(gcbmap, bmap, sizeof(*bmap));
-	init_rwsem(&gcbmap->b_sem);
-	lockdep_set_class(&bmap->b_sem, &nilfs_bmap_dat_lock_key);
-	gcbmap->b_inode = &NILFS_BMAP_I(gcbmap)->vfs_inode;
-}
-
-void nilfs_bmap_commit_gcdat(struct nilfs_bmap *gcbmap, struct nilfs_bmap *bmap)
-{
-	memcpy(bmap, gcbmap, sizeof(*bmap));
-	init_rwsem(&bmap->b_sem);
-	lockdep_set_class(&bmap->b_sem, &nilfs_bmap_dat_lock_key);
-	bmap->b_inode = &NILFS_BMAP_I(bmap)->vfs_inode;
-}
-
 void nilfs_bmap_save(const struct nilfs_bmap *bmap,
 		     struct nilfs_bmap_store *store)
 {
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index 5f3339e..bde1c0a 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -159,8 +159,6 @@ int nilfs_bmap_lookup_at_level(struct nilfs_bmap *, __u64, int, __u64 *);
 int nilfs_bmap_mark(struct nilfs_bmap *, __u64, int);
 
 void nilfs_bmap_init_gc(struct nilfs_bmap *);
-void nilfs_bmap_init_gcdat(struct nilfs_bmap *, struct nilfs_bmap *);
-void nilfs_bmap_commit_gcdat(struct nilfs_bmap *, struct nilfs_bmap *);
 
 void nilfs_bmap_save(const struct nilfs_bmap *, struct nilfs_bmap_store *);
 void nilfs_bmap_restore(struct nilfs_bmap *, const struct nilfs_bmap_store *);
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 0131467..7091c4e 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -36,6 +36,7 @@
 struct nilfs_dat_info {
 	struct nilfs_mdt_info mi;
 	struct nilfs_palloc_cache palloc_cache;
+	struct nilfs_shadow_map shadow;
 };
 
 static inline struct nilfs_dat_info *NILFS_DAT_I(struct inode *dat)
@@ -327,6 +328,23 @@ int nilfs_dat_move(struct inode *dat, __u64 vblocknr, sector_t blocknr)
 	ret = nilfs_palloc_get_entry_block(dat, vblocknr, 0, &entry_bh);
 	if (ret < 0)
 		return ret;
+
+	/*
+	 * The given disk block number (blocknr) is not yet written to
+	 * the device at this point.
+	 *
+	 * To prevent nilfs_dat_translate() from returning the
+	 * uncommited block number, this makes a copy of the entry
+	 * buffer and redirects nilfs_dat_translate() to the copy.
+	 */
+	if (!buffer_nilfs_redirected(entry_bh)) {
+		ret = nilfs_mdt_freeze_buffer(dat, entry_bh);
+		if (ret) {
+			brelse(entry_bh);
+			return ret;
+		}
+	}
+
 	kaddr = kmap_atomic(entry_bh->b_page, KM_USER0);
 	entry = nilfs_palloc_block_get_entry(dat, vblocknr, entry_bh, kaddr);
 	if (unlikely(entry->de_blocknr == cpu_to_le64(0))) {
@@ -371,7 +389,7 @@ int nilfs_dat_move(struct inode *dat, __u64 vblocknr, sector_t blocknr)
  */
 int nilfs_dat_translate(struct inode *dat, __u64 vblocknr, sector_t *blocknrp)
 {
-	struct buffer_head *entry_bh;
+	struct buffer_head *entry_bh, *bh;
 	struct nilfs_dat_entry *entry;
 	sector_t blocknr;
 	void *kaddr;
@@ -381,6 +399,15 @@ int nilfs_dat_translate(struct inode *dat, __u64 vblocknr, sector_t *blocknrp)
 	if (ret < 0)
 		return ret;
 
+	if (!nilfs_doing_gc() && buffer_nilfs_redirected(entry_bh)) {
+		bh = nilfs_mdt_get_frozen_buffer(dat, entry_bh);
+		if (bh) {
+			WARN_ON(!buffer_uptodate(bh));
+			brelse(entry_bh);
+			entry_bh = bh;
+		}
+	}
+
 	kaddr = kmap_atomic(entry_bh->b_page, KM_USER0);
 	entry = nilfs_palloc_block_get_entry(dat, vblocknr, entry_bh, kaddr);
 	blocknr = le64_to_cpu(entry->de_blocknr);
@@ -468,6 +495,7 @@ struct inode *nilfs_dat_new(struct the_nilfs *nilfs, size_t entry_size)
 		di = NILFS_DAT_I(dat);
 		lockdep_set_class(&di->mi.mi_sem, &dat_lock_key);
 		nilfs_palloc_setup_cache(dat, &di->palloc_cache);
+		nilfs_mdt_setup_shadow_map(dat, &di->shadow);
 	}
 	return dat;
 }
diff --git a/fs/nilfs2/gcdat.c b/fs/nilfs2/gcdat.c
deleted file mode 100644
index 84a45d1..0000000
--- a/fs/nilfs2/gcdat.c
+++ /dev/null
@@ -1,87 +0,0 @@
-/*
- * gcdat.c - NILFS shadow DAT inode for GC
- *
- * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
- * Written by Seiji Kihara <kihara-sG5X7nlA6pw@public.gmane.org>, Amagai Yoshiji <amagai-sG5X7nlA6pw@public.gmane.org>,
- *            and Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>.
- *
- */
-
-#include <linux/buffer_head.h>
-#include "nilfs.h"
-#include "page.h"
-#include "mdt.h"
-
-int nilfs_init_gcdat_inode(struct the_nilfs *nilfs)
-{
-	struct inode *dat = nilfs->ns_dat, *gcdat = nilfs->ns_gc_dat;
-	struct nilfs_inode_info *dii = NILFS_I(dat), *gii = NILFS_I(gcdat);
-	int err;
-
-	gcdat->i_state = 0;
-	gcdat->i_blocks = dat->i_blocks;
-	gii->i_flags = dii->i_flags;
-	gii->i_state = dii->i_state | (1 << NILFS_I_GCDAT);
-	gii->i_cno = 0;
-	nilfs_bmap_init_gcdat(gii->i_bmap, dii->i_bmap);
-	err = nilfs_copy_dirty_pages(gcdat->i_mapping, dat->i_mapping);
-	if (unlikely(err))
-		return err;
-
-	return nilfs_copy_dirty_pages(&gii->i_btnode_cache,
-				      &dii->i_btnode_cache);
-}
-
-void nilfs_commit_gcdat_inode(struct the_nilfs *nilfs)
-{
-	struct inode *dat = nilfs->ns_dat, *gcdat = nilfs->ns_gc_dat;
-	struct nilfs_inode_info *dii = NILFS_I(dat), *gii = NILFS_I(gcdat);
-	struct address_space *mapping = dat->i_mapping;
-	struct address_space *gmapping = gcdat->i_mapping;
-
-	down_write(&NILFS_MDT(dat)->mi_sem);
-	dat->i_blocks = gcdat->i_blocks;
-	dii->i_flags = gii->i_flags;
-	dii->i_state = gii->i_state & ~(1 << NILFS_I_GCDAT);
-
-	nilfs_bmap_commit_gcdat(gii->i_bmap, dii->i_bmap);
-
-	nilfs_palloc_clear_cache(dat);
-	nilfs_palloc_clear_cache(gcdat);
-	nilfs_clear_dirty_pages(mapping);
-	nilfs_copy_back_pages(mapping, gmapping);
-	/* note: mdt dirty flags should be cleared by segctor. */
-
-	nilfs_clear_dirty_pages(&dii->i_btnode_cache);
-	nilfs_copy_back_pages(&dii->i_btnode_cache, &gii->i_btnode_cache);
-
-	up_write(&NILFS_MDT(dat)->mi_sem);
-}
-
-void nilfs_clear_gcdat_inode(struct the_nilfs *nilfs)
-{
-	struct inode *gcdat = nilfs->ns_gc_dat;
-	struct nilfs_inode_info *gii = NILFS_I(gcdat);
-
-	gcdat->i_state = I_FREEING | I_CLEAR;
-	gii->i_flags = 0;
-
-	nilfs_palloc_clear_cache(gcdat);
-	truncate_inode_pages(gcdat->i_mapping, 0);
-	truncate_inode_pages(&gii->i_btnode_cache, 0);
-}
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 532f85a..3bbd340 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -414,8 +414,6 @@ nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 	sb = inode->i_sb;
 	nilfs = NILFS_MDT(inode)->mi_nilfs;
 
-	if (page->mapping->assoc_mapping)
-		return 0; /* Do not request flush for shadow page cache */
 	if (!sb) {
 		down_read(&nilfs->ns_writer_sem);
 		writer = nilfs->ns_writer;
@@ -566,13 +564,6 @@ void nilfs_mdt_set_entry_size(struct inode *inode, unsigned entry_size,
 	mi->mi_first_entry_offset = DIV_ROUND_UP(header_size, entry_size);
 }
 
-void nilfs_mdt_set_shadow(struct inode *orig, struct inode *shadow)
-{
-	shadow->i_mapping->assoc_mapping = orig->i_mapping;
-	NILFS_I(shadow)->i_btnode_cache.assoc_mapping =
-		&NILFS_I(orig)->i_btnode_cache;
-}
-
 static const struct address_space_operations shadow_map_aops = {
 	.sync_page		= block_sync_page,
 };
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index e60bbfe..1e0901c 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -93,7 +93,6 @@ struct inode *nilfs_mdt_new_common(struct the_nilfs *, struct super_block *,
 				   ino_t);
 void nilfs_mdt_destroy(struct inode *);
 void nilfs_mdt_set_entry_size(struct inode *, unsigned, unsigned);
-void nilfs_mdt_set_shadow(struct inode *, struct inode *);
 
 int nilfs_mdt_setup_shadow_map(struct inode *inode,
 			       struct nilfs_shadow_map *shadow);
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index cf5507a..e9f4579 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -101,7 +101,6 @@ enum {
 	NILFS_I_INODE_DIRTY,		/* write_inode is requested */
 	NILFS_I_BMAP,			/* has bmap and btnode_cache */
 	NILFS_I_GCINODE,		/* inode for GC, on memory only */
-	NILFS_I_GCDAT,			/* shadow DAT, on memory only */
 };
 
 /*
@@ -193,7 +192,7 @@ static inline int nilfs_doing_construction(void)
 
 static inline struct inode *nilfs_dat_inode(const struct the_nilfs *nilfs)
 {
-	return nilfs_doing_gc() ? nilfs->ns_gc_dat : nilfs->ns_dat;
+	return nilfs->ns_dat;
 }
 
 /*
@@ -294,11 +293,6 @@ int nilfs_gccache_wait_and_mark_dirty(struct buffer_head *);
 int nilfs_init_gcinode(struct inode *inode);
 void nilfs_remove_all_gcinodes(struct the_nilfs *nilfs);
 
-/* gcdat.c */
-int nilfs_init_gcdat_inode(struct the_nilfs *);
-void nilfs_commit_gcdat_inode(struct the_nilfs *);
-void nilfs_clear_gcdat_inode(struct the_nilfs *);
-
 /*
  * Inodes and files operations
  */
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 7083344..a6c3c2e 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -79,8 +79,8 @@ struct buffer_head *nilfs_grab_buffer(struct inode *inode,
 {
 	int blkbits = inode->i_blkbits;
 	pgoff_t index = blkoff >> (PAGE_CACHE_SHIFT - blkbits);
-	struct page *page, *opage;
-	struct buffer_head *bh, *obh;
+	struct page *page;
+	struct buffer_head *bh;
 
 	page = grab_cache_page(mapping, index);
 	if (unlikely(!page))
@@ -92,30 +92,6 @@ struct buffer_head *nilfs_grab_buffer(struct inode *inode,
 		page_cache_release(page);
 		return NULL;
 	}
-	if (!buffer_uptodate(bh) && mapping->assoc_mapping != NULL) {
-		/*
-		 * Shadow page cache uses assoc_mapping to point its original
-		 * page cache.  The following code tries the original cache
-		 * if the given cache is a shadow and it didn't hit.
-		 */
-		opage = find_lock_page(mapping->assoc_mapping, index);
-		if (!opage)
-			return bh;
-
-		obh = __nilfs_get_page_block(opage, blkoff, index, blkbits,
-					     b_state);
-		if (buffer_uptodate(obh)) {
-			nilfs_copy_buffer(bh, obh);
-			if (buffer_dirty(obh)) {
-				nilfs_mark_buffer_dirty(bh);
-				if (!buffer_nilfs_node(bh) && NILFS_MDT(inode))
-					nilfs_mdt_mark_dirty(inode);
-			}
-		}
-		brelse(obh);
-		unlock_page(opage);
-		page_cache_release(opage);
-	}
 	return bh;
 }
 
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 91dc066..b0c5e08 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1945,11 +1945,9 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 
 	nilfs_drop_collected_inodes(&sci->sc_dirty_files);
 
-	if (nilfs_doing_gc()) {
+	if (nilfs_doing_gc())
 		nilfs_drop_collected_inodes(&sci->sc_gc_inodes);
-		if (update_sr)
-			nilfs_commit_gcdat_inode(nilfs);
-	} else
+	else
 		nilfs->ns_nongc_ctime = sci->sc_seg_ctime;
 
 	sci->sc_nblk_inc += sci->sc_nblk_this_inc;
@@ -2472,13 +2470,15 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 
 	nilfs_transaction_lock(sbi, &ti, 1);
 
-	err = nilfs_init_gcdat_inode(nilfs);
+	err = nilfs_mdt_save_to_shadow_map(nilfs->ns_dat);
 	if (unlikely(err))
 		goto out_unlock;
 
 	err = nilfs_ioctl_prepare_clean_segments(nilfs, argv, kbufs);
-	if (unlikely(err))
+	if (unlikely(err)) {
+		nilfs_mdt_restore_from_shadow_map(nilfs->ns_dat);
 		goto out_unlock;
+	}
 
 	sci->sc_freesegs = kbufs[4];
 	sci->sc_nfreesegs = argv[4].v_nmembs;
@@ -2510,7 +2510,7 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
  out_unlock:
 	sci->sc_freesegs = NULL;
 	sci->sc_nfreesegs = 0;
-	nilfs_clear_gcdat_inode(nilfs);
+	nilfs_mdt_clear_shadow_map(nilfs->ns_dat);
 	nilfs_transaction_unlock(sbi);
 	return err;
 }
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index bc9a3e2..10e3ef0 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -96,7 +96,6 @@ void destroy_nilfs(struct the_nilfs *nilfs)
 		nilfs_mdt_destroy(nilfs->ns_sufile);
 		nilfs_mdt_destroy(nilfs->ns_cpfile);
 		nilfs_mdt_destroy(nilfs->ns_dat);
-		nilfs_mdt_destroy(nilfs->ns_gc_dat);
 	}
 	if (nilfs_init(nilfs)) {
 		brelse(nilfs->ns_sbh[0]);
@@ -131,20 +130,14 @@ static int nilfs_load_super_root(struct the_nilfs *nilfs, sector_t sr_block)
 	if (unlikely(!nilfs->ns_dat))
 		goto failed;
 
-	nilfs->ns_gc_dat = nilfs_dat_new(nilfs, dat_entry_size);
-	if (unlikely(!nilfs->ns_gc_dat))
-		goto failed_dat;
-
 	nilfs->ns_cpfile = nilfs_cpfile_new(nilfs, checkpoint_size);
 	if (unlikely(!nilfs->ns_cpfile))
-		goto failed_gc_dat;
+		goto failed_dat;
 
 	nilfs->ns_sufile = nilfs_sufile_new(nilfs, segment_usage_size);
 	if (unlikely(!nilfs->ns_sufile))
 		goto failed_cpfile;
 
-	nilfs_mdt_set_shadow(nilfs->ns_dat, nilfs->ns_gc_dat);
-
 	err = nilfs_dat_read(nilfs->ns_dat, (void *)bh_sr->b_data +
 			     NILFS_SR_DAT_OFFSET(inode_size));
 	if (unlikely(err))
@@ -173,9 +166,6 @@ static int nilfs_load_super_root(struct the_nilfs *nilfs, sector_t sr_block)
  failed_cpfile:
 	nilfs_mdt_destroy(nilfs->ns_cpfile);
 
- failed_gc_dat:
-	nilfs_mdt_destroy(nilfs->ns_gc_dat);
-
  failed_dat:
 	nilfs_mdt_destroy(nilfs->ns_dat);
 	goto failed;
@@ -371,7 +361,6 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 	nilfs_mdt_destroy(nilfs->ns_cpfile);
 	nilfs_mdt_destroy(nilfs->ns_sufile);
 	nilfs_mdt_destroy(nilfs->ns_dat);
-	nilfs_mdt_destroy(nilfs->ns_gc_dat);
 
  failed:
 	nilfs_clear_recovery_info(&ri);
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 1908dc7..a5178dc 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -74,7 +74,6 @@ enum {
  * @ns_dat: DAT file inode
  * @ns_cpfile: checkpoint file inode
  * @ns_sufile: segusage file inode
- * @ns_gc_dat: shadow inode of the DAT file inode for GC
  * @ns_cptree: rb-tree of all mounted checkpoints (nilfs_root)
  * @ns_cptree_lock: lock protecting @ns_cptree
  * @ns_gc_inodes: dummy inodes to keep live blocks
@@ -149,7 +148,6 @@ struct the_nilfs {
 	struct inode	       *ns_dat;
 	struct inode	       *ns_cpfile;
 	struct inode	       *ns_sufile;
-	struct inode	       *ns_gc_dat;
 
 	/* Checkpoint tree */
 	struct rb_root		ns_cptree;
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
