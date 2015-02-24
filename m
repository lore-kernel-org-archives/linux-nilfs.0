From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 8/9] nilfs2: improve accuracy and correct for invalid GC values
Date: Tue, 24 Feb 2015 20:01:43 +0100
Message-ID: <1424804504-10914-9-git-send-email-andreas.rohner@gmx.net>
References: <1424804504-10914-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424804504-10914-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This patch improves the accuracy of the su_nlive_blks segment
usage field by also counting the blocks of the DAT-File. A block in
the DAT-File is considered reclaimable as soon as it is overwritten.
There is no need to consider protection periods, snapshots or
checkpoints. So whenever a block is overwritten during segment
construction, the segment usage information of the segment at the
previous location of the block is decremented. To get the previous
location of the block the b_blocknr field of the buffer_head
structure is used.

SUFILE blocks are counted in a similar way, but if the GC reads a
block into a GC inode, that already is in the cache, then there are
two versions of the block. If this happens both versions will be
counted, which can lead to small seemingly random incorrect values.
But it is better to accept these small inaccuracies than to not
count the SUFILE at all. These inaccuracies do not occur for the
DAT-File, because it does not need a GC inode.

Additionally the blocks that belong to a GC inode are rechecked if
they are reclaimable. If so the corresponding counter is
decremented. The blocks were already checked in userspace, but
without the proper locking. It is furthermore possible, that blocks
become reclaimable during the cleaning process. For example by
deleting checkpoints. To improve the performance of these extra
checks, flags from userspace are used to determine reclaimability.
If a block belongs to a snapshot it cannot be reclaimable and if
it is within the protection period it must be counted as
reclaimable.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/dat.c     |  70 ++++++++++++++++++++++++++++++++++++
 fs/nilfs2/dat.h     |   1 +
 fs/nilfs2/inode.c   |   2 ++
 fs/nilfs2/segbuf.c  |   4 +++
 fs/nilfs2/segbuf.h  |   1 +
 fs/nilfs2/segment.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 6 files changed, 177 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index d2c8f7e..63d079c 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -35,6 +35,17 @@
 #define NILFS_CNO_MAX	(~(__u64)0)
 
 /**
+ * nilfs_dat_entry_is_alive - check if @entry is alive
+ * @entry: DAT-Entry
+ *
+ * Description: Simple check if @entry is alive in the current checkpoint.
+ */
+static inline int nilfs_dat_entry_is_live(struct nilfs_dat_entry *entry)
+{
+	return entry->de_end == cpu_to_le64(NILFS_CNO_MAX);
+}
+
+/**
  * struct nilfs_dat_info - on-memory private data of DAT file
  * @mi: on-memory private data of metadata file
  * @palloc_cache: persistent object allocator cache of DAT file
@@ -391,6 +402,65 @@ int nilfs_dat_move(struct inode *dat, __u64 vblocknr, sector_t blocknr)
 }
 
 /**
+ * nilfs_dat_is_live - checks if the virtual block number is alive
+ * @dat: DAT file inode
+ * @vblocknr: virtual block number
+ * @errp: pointer to return code if error occurred
+ *
+ * Description: nilfs_dat_is_live() looks up the DAT-Entry for
+ * @vblocknr and determines if the corresponding block is alive in the current
+ * checkpoint or not. This check ignores snapshots and protection periods.
+ *
+ * Return Value: 1 if vblocknr is alive and 0 otherwise. On error, 0 is
+ * returned and @errp is set to one of the following negative error codes.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOENT - A block number associated with @vblocknr does not exist.
+ */
+int nilfs_dat_is_live(struct inode *dat, __u64 vblocknr, int *errp)
+{
+	struct buffer_head *entry_bh, *bh;
+	struct nilfs_dat_entry *entry;
+	sector_t blocknr;
+	void *kaddr;
+	int ret = 0, err;
+
+	err = nilfs_palloc_get_entry_block(dat, vblocknr, 0, &entry_bh);
+	if (err < 0)
+		goto out;
+
+	if (!nilfs_doing_gc() && buffer_nilfs_redirected(entry_bh)) {
+		bh = nilfs_mdt_get_frozen_buffer(dat, entry_bh);
+		if (bh) {
+			WARN_ON(!buffer_uptodate(bh));
+			put_bh(entry_bh);
+			entry_bh = bh;
+		}
+	}
+
+	kaddr = kmap_atomic(entry_bh->b_page);
+	entry = nilfs_palloc_block_get_entry(dat, vblocknr, entry_bh, kaddr);
+	blocknr = le64_to_cpu(entry->de_blocknr);
+	if (blocknr == 0) {
+		err = -ENOENT;
+		goto out_unmap;
+	}
+
+	ret = nilfs_dat_entry_is_live(entry);
+
+out_unmap:
+	kunmap_atomic(kaddr);
+	put_bh(entry_bh);
+out:
+	if (errp)
+		*errp = err;
+	return ret;
+}
+
+/**
  * nilfs_dat_translate - translate a virtual block number to a block number
  * @dat: DAT file inode
  * @vblocknr: virtual block number
diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
index d196f09..3cbddd6 100644
--- a/fs/nilfs2/dat.h
+++ b/fs/nilfs2/dat.h
@@ -32,6 +32,7 @@ struct nilfs_palloc_req;
 struct nilfs_sufile_mod_cache;
 
 int nilfs_dat_translate(struct inode *, __u64, sector_t *);
+int nilfs_dat_is_live(struct inode *, __u64, int *);
 
 int nilfs_dat_prepare_alloc(struct inode *, struct nilfs_palloc_req *);
 void nilfs_dat_commit_alloc(struct inode *, struct nilfs_palloc_req *);
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 7f6d056..5412a76 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -90,6 +90,8 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
 	int err = 0, ret;
 	unsigned maxblocks = bh_result->b_size >> inode->i_blkbits;
 
+	bh_result->b_blocknr = 0;
+
 	down_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	ret = nilfs_bmap_lookup_contig(ii->i_bmap, blkoff, &blknum, maxblocks);
 	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 7a6e9cd..bbd807b 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -58,6 +58,7 @@ struct nilfs_segment_buffer *nilfs_segbuf_new(struct super_block *sb)
 	INIT_LIST_HEAD(&segbuf->sb_payload_buffers);
 	segbuf->sb_super_root = NULL;
 	segbuf->sb_nlive_blks_added = 0;
+	segbuf->sb_nlive_blks_diff = 0;
 
 	init_completion(&segbuf->sb_bio_event);
 	atomic_set(&segbuf->sb_err, 0);
@@ -451,6 +452,9 @@ static int nilfs_segbuf_submit_bh(struct nilfs_segment_buffer *segbuf,
 
 	len = bio_add_page(wi->bio, bh->b_page, bh->b_size, bh_offset(bh));
 	if (len == bh->b_size) {
+		lock_buffer(bh);
+		map_bh(bh, segbuf->sb_super, wi->blocknr + wi->end);
+		unlock_buffer(bh);
 		wi->end++;
 		return 0;
 	}
diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
index d04da26..4e994f7 100644
--- a/fs/nilfs2/segbuf.h
+++ b/fs/nilfs2/segbuf.h
@@ -84,6 +84,7 @@ struct nilfs_segment_buffer {
 	sector_t		sb_pseg_start;
 	unsigned		sb_rest_blocks;
 	__u32			sb_nlive_blks_added;
+	__s64			sb_nlive_blks_diff;
 
 	/* Buffers */
 	struct list_head	sb_segsum_buffers;
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index dc0070c..16c7c36 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1385,7 +1385,8 @@ static void nilfs_segctor_update_segusage(struct nilfs_sc_info *sci,
 		WARN_ON(ret); /* always succeed because the segusage is dirty */
 
 		/* should always be positive */
-		segbuf->sb_nlive_blks_added = segbuf->sb_sum.nfileblk;
+		segbuf->sb_nlive_blks_added = segbuf->sb_nlive_blks_diff +
+					      segbuf->sb_sum.nfileblk;
 
 		if (nilfs_feature_track_live_blks(nilfs))
 			nilfs_sufile_mod_nlive_blks(sufile, sci->sc_mc,
@@ -1497,12 +1498,98 @@ static void nilfs_list_replace_buffer(struct buffer_head *old_bh,
 	/* The caller must release old_bh */
 }
 
+/**
+ * nilfs_segctor_dec_nlive_blks_gc - dec. nlive_blks for blocks of GC-Inodes
+ * @dat: dat inode
+ * @segbuf: currtent segment buffer
+ * @bh: current buffer head
+ *
+ * Description: nilfs_segctor_dec_nlive_blks_gc() is called if the inode to
+ * which @bh belongs is a GC-Inode. In that case it is not necessary to
+ * decrement the previous segment, because at the end of the GC process it
+ * will be freed anyway. It is however necessary to check again if the blocks
+ * are alive here, because the last check was in userspace without the proper
+ * locking. Additionally the blocks protected by the protection period should
+ * be considered reclaimable. It is assumed, that @bh->b_blocknr contains
+ * a virtual block number, which is only true if @bh is part of a GC-Inode.
+ */
+static void nilfs_segctor_dec_nlive_blks_gc(struct inode *dat,
+					    struct nilfs_segment_buffer *segbuf,
+					    struct buffer_head *bh) {
+	bool isreclaimable = buffer_nilfs_protection_period(bh) ||
+				!nilfs_dat_is_live(dat, bh->b_blocknr, NULL);
+
+	if (!buffer_nilfs_snapshot(bh) && isreclaimable)
+		segbuf->sb_nlive_blks_diff--;
+}
+
+/**
+ * nilfs_segctor_dec_nlive_blks_nogc - dec. nlive_blks of segment
+ * @nilfs: the nilfs object
+ * @mc: modification cache
+ * @sb: currtent segment buffer
+ * @blocknr: current block number
+ *
+ * Description: Gets the segment number of the segment @blocknr belongs to
+ * and decrements the su_nlive_blks field of the corresponding segment usage
+ * entry.
+ */
+static void nilfs_segctor_dec_nlive_blks_nogc(struct the_nilfs *nilfs,
+					      struct nilfs_sufile_mod_cache *mc,
+					      struct nilfs_segment_buffer *sb,
+					      sector_t blocknr)
+{
+	__u64 segnum = nilfs_get_segnum_of_block(nilfs, blocknr);
+
+	if (segnum >= nilfs->ns_nsegments)
+		return;
+
+	if (segnum == sb->sb_segnum)
+		sb->sb_nlive_blks_diff--;
+	else
+		nilfs_sufile_mod_nlive_blks(nilfs->ns_sufile, mc, segnum, -1);
+}
+
+/**
+ * nilfs_segctor_dec_nlive_blks - dec. nlive_blks of previous segment
+ * @nilfs: the nilfs object
+ * @mc: modification cache
+ * @sb: currtent segment buffer
+ * @bh: current buffer head
+ * @ino: current inode number
+ * @gc_inode: true if current inode is a GC-Inode
+ *
+ * Description: Handles GC-Inodes and normal inodes differently. For normal
+ * inodes @bh->b_blocknr contains the location where the block was read in. If
+ * the block is updated, the old version of it is considered reclaimable and so
+ * the su_nlive_blks field of the segment usage information of the old segment
+ * needs to be decremented. Only the DATFILE and SUFILE are decremented here,
+ * because normal files and other meta data files can be better decremented in
+ * nilfs_dat_commit_end().
+ */
+static void nilfs_segctor_dec_nlive_blks(struct the_nilfs *nilfs,
+					 struct nilfs_sufile_mod_cache *mc,
+					 struct nilfs_segment_buffer *sb,
+					 struct buffer_head *bh,
+					 ino_t ino,
+					 bool gc_inode)
+{
+	bool isnode = buffer_nilfs_node(bh);
+
+	if (gc_inode)
+		nilfs_segctor_dec_nlive_blks_gc(nilfs->ns_dat, sb, bh);
+	else if (ino == NILFS_DAT_INO || (ino == NILFS_SUFILE_INO && !isnode))
+		nilfs_segctor_dec_nlive_blks_nogc(nilfs, mc, sb, bh->b_blocknr);
+}
+
 static int
 nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
 				     struct nilfs_segment_buffer *segbuf,
 				     int mode)
 {
+	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	struct inode *inode = NULL;
+	struct nilfs_inode_info *ii;
 	sector_t blocknr;
 	unsigned long nfinfo = segbuf->sb_sum.nfinfo;
 	unsigned long nblocks = 0, ndatablk = 0;
@@ -1512,7 +1599,9 @@ nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
 	union nilfs_binfo binfo;
 	struct buffer_head *bh, *bh_org;
 	ino_t ino = 0;
-	int err = 0;
+	int err = 0, gc_inode = 0, track_live_blks;
+
+	track_live_blks = nilfs_feature_track_live_blks(nilfs);
 
 	if (!nfinfo)
 		goto out;
@@ -1533,6 +1622,9 @@ nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
 
 			inode = bh->b_page->mapping->host;
 
+			ii = NILFS_I(inode);
+			gc_inode = test_bit(NILFS_I_GCINODE, &ii->i_state);
+
 			if (mode == SC_LSEG_DSYNC)
 				sc_op = &nilfs_sc_dsync_ops;
 			else if (ino == NILFS_DAT_INO)
@@ -1540,6 +1632,11 @@ nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
 			else /* file blocks */
 				sc_op = &nilfs_sc_file_ops;
 		}
+
+		if (track_live_blks)
+			nilfs_segctor_dec_nlive_blks(nilfs, sci->sc_mc, segbuf,
+						     bh, ino, gc_inode);
+
 		bh_org = bh;
 		get_bh(bh_org);
 		err = nilfs_bmap_assign(NILFS_I(inode)->i_bmap, &bh, blocknr,
-- 
2.3.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
