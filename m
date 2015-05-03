From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v2 8/9] nilfs2: correct live block tracking for GC protection period
Date: Sun,  3 May 2015 12:05:21 +0200
Message-ID: <1430647522-14304-9-git-send-email-andreas.rohner@gmx.net>
References: <1430647522-14304-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430647522-14304-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The userspace GC uses the concept of a so-called protection period,
which is a period of time, where actually reclaimable blocks are
protected. If a segment is cleaned and there are blocks in it that are
protected by this, they have to be treated as if they were live blocks.

This is a problem for the live block tracking on the kernel side,
because the kernel knows nothing about the protection period. This patch
introduces new flags for the nilfs_vdesc data structure, to mark blocks
that need to be treated as if they were alive, but must be counted as if
they were reclaimable. There are two reasons for this to happen.
Either a block was deleted within the protection period, or it is
part of a snapshot.

After the blocks described by the nilfs_vdesc structures are read in,
the flags are passed on to the buffer_heads to get the information to
the segment construction phase. During segment construction, the live
block tracking is adjusted accordingly.

Additionally the blocks are rechecked if they are reclaimable, since the
last check was in userspace without the proper locking.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/dat.c           | 66 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/dat.h           |  1 +
 fs/nilfs2/ioctl.c         | 15 +++++++++++
 fs/nilfs2/page.h          |  6 +++++
 fs/nilfs2/segment.c       | 41 ++++++++++++++++++++++++++++-
 include/linux/nilfs2_fs.h | 38 +++++++++++++++++++++++++--
 6 files changed, 164 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 9c2fc32..80a1905 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -35,6 +35,17 @@
 #define NILFS_CNO_MAX	(~(__u64)0)
 
 /**
+ * nilfs_dat_entry_is_live - check if @entry is alive
+ * @entry: DAT-Entry
+ *
+ * Description: Simple check if @entry is alive in the current checkpoint.
+ */
+static int nilfs_dat_entry_is_live(struct nilfs_dat_entry *entry)
+{
+	return entry->de_end == cpu_to_le64(NILFS_CNO_MAX);
+}
+
+/**
  * struct nilfs_dat_info - on-memory private data of DAT file
  * @mi: on-memory private data of metadata file
  * @palloc_cache: persistent object allocator cache of DAT file
@@ -387,6 +398,61 @@ int nilfs_dat_move(struct inode *dat, __u64 vblocknr, sector_t blocknr)
 }
 
 /**
+ * nilfs_dat_is_live - checks if the virtual block number is alive
+ * @dat: DAT file inode
+ * @vblocknr: virtual block number
+ *
+ * Description: nilfs_dat_is_live() looks up the DAT-Entry for
+ * @vblocknr and determines if the corresponding block is alive in the current
+ * checkpoint or not. This check ignores snapshots and protection periods.
+ *
+ * Return Value: 1 if vblocknr is alive and 0 otherwise. On error one of the
+ * following negative error codes is returned
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOENT - A block number associated with @vblocknr does not exist.
+ */
+int nilfs_dat_is_live(struct inode *dat, __u64 vblocknr)
+{
+	struct buffer_head *entry_bh, *bh;
+	struct nilfs_dat_entry *entry;
+	sector_t blocknr;
+	void *kaddr;
+	int ret;
+
+	ret = nilfs_palloc_get_entry_block(dat, vblocknr, 0, &entry_bh);
+	if (ret < 0)
+		return ret;
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
+		ret = -ENOENT;
+		goto out_unmap;
+	}
+
+	ret = nilfs_dat_entry_is_live(entry);
+
+out_unmap:
+	kunmap_atomic(kaddr);
+	put_bh(entry_bh);
+	return ret;
+}
+
+/**
  * nilfs_dat_translate - translate a virtual block number to a block number
  * @dat: DAT file inode
  * @vblocknr: virtual block number
diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
index cbd8e97..a95547c 100644
--- a/fs/nilfs2/dat.h
+++ b/fs/nilfs2/dat.h
@@ -47,6 +47,7 @@ void nilfs_dat_commit_update(struct inode *, struct nilfs_palloc_req *,
 			     struct nilfs_palloc_req *, int);
 void nilfs_dat_abort_update(struct inode *, struct nilfs_palloc_req *,
 			    struct nilfs_palloc_req *);
+int nilfs_dat_is_live(struct inode *dat, __u64 vblocknr);
 
 int nilfs_dat_mark_dirty(struct inode *, __u64);
 int nilfs_dat_freev(struct inode *, __u64 *, size_t);
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index f6ee54e..40bf74a 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -612,6 +612,12 @@ static int nilfs_ioctl_move_inode_block(struct inode *inode,
 		brelse(bh);
 		return -EEXIST;
 	}
+
+	if (nilfs_vdesc_snapshot_protected(vdesc))
+		set_buffer_nilfs_snapshot_protected(bh);
+	if (nilfs_vdesc_period_protected(vdesc))
+		set_buffer_nilfs_period_protected(bh);
+
 	list_add_tail(&bh->b_assoc_buffers, buffers);
 	return 0;
 }
@@ -662,6 +668,15 @@ static int nilfs_ioctl_move_blocks(struct super_block *sb,
 		}
 
 		do {
+			/*
+			 * old user space tools to not initialize vd_blk_flags
+			 * if vd_period.p_start > 0 then vd_blk_flags was
+			 * not initialized properly and may contain invalid
+			 * flags
+			 */
+			if (vdesc->vd_period.p_start > 0)
+				vdesc->vd_blk_flags = 0;
+
 			ret = nilfs_ioctl_move_inode_block(inode, vdesc,
 							   &buffers);
 			if (unlikely(ret < 0)) {
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index 4e35814..4835e37 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -36,6 +36,8 @@ enum {
 	BH_NILFS_Volatile,
 	BH_NILFS_Checked,
 	BH_NILFS_Redirected,
+	BH_NILFS_Snapshot_Protected,
+	BH_NILFS_Period_Protected,
 	BH_NILFS_Counted,
 };
 
@@ -43,6 +45,10 @@ BUFFER_FNS(NILFS_Node, nilfs_node)		/* nilfs node buffers */
 BUFFER_FNS(NILFS_Volatile, nilfs_volatile)
 BUFFER_FNS(NILFS_Checked, nilfs_checked)	/* buffer is verified */
 BUFFER_FNS(NILFS_Redirected, nilfs_redirected)	/* redirected to a copy */
+/* buffer belongs to a snapshot and is protected by it */
+BUFFER_FNS(NILFS_Snapshot_Protected, nilfs_snapshot_protected)
+/* protected by protection period */
+BUFFER_FNS(NILFS_Period_Protected, nilfs_period_protected)
 /* counted by propagate_p for segment usage */
 BUFFER_FNS(NILFS_Counted, nilfs_counted)
 
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index ab8df33..b476ce7 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1564,12 +1564,41 @@ static void nilfs_list_replace_buffer(struct buffer_head *old_bh,
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
+	bool isreclaimable = buffer_nilfs_period_protected(bh) ||
+				nilfs_dat_is_live(dat, bh->b_blocknr) <= 0;
+
+	if (!buffer_nilfs_snapshot_protected(bh) && isreclaimable)
+		segbuf->sb_nlive_blks--;
+	if (buffer_nilfs_snapshot_protected(bh))
+		segbuf->sb_nsnapshot_blks++;
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
@@ -1579,7 +1608,9 @@ nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
 	union nilfs_binfo binfo;
 	struct buffer_head *bh, *bh_org;
 	ino_t ino = 0;
-	int err = 0;
+	int err = 0, gc_inode = 0, track_live_blks;
+
+	track_live_blks = nilfs_feature_track_live_blks(nilfs);
 
 	if (!nfinfo)
 		goto out;
@@ -1601,6 +1632,9 @@ nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
 
 			inode = bh->b_page->mapping->host;
 
+			ii = NILFS_I(inode);
+			gc_inode = test_bit(NILFS_I_GCINODE, &ii->i_state);
+
 			if (mode == SC_LSEG_DSYNC)
 				sc_op = &nilfs_sc_dsync_ops;
 			else if (ino == NILFS_DAT_INO)
@@ -1608,6 +1642,11 @@ nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
 			else /* file blocks */
 				sc_op = &nilfs_sc_file_ops;
 		}
+
+		if (track_live_blks && gc_inode)
+			nilfs_segctor_dec_nlive_blks_gc(nilfs->ns_dat,
+							segbuf, bh);
+
 		bh_org = bh;
 		get_bh(bh_org);
 		err = nilfs_bmap_assign(NILFS_I(inode)->i_bmap, &bh, blocknr,
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 5f05bbf..ddc98e8 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -905,7 +905,7 @@ struct nilfs_vinfo {
  * @vd_blocknr: disk block number
  * @vd_offset: logical block offset inside a file
  * @vd_flags: flags (data or node block)
- * @vd_pad: padding
+ * @vd_blk_flags: additional flags
  */
 struct nilfs_vdesc {
 	__u64 vd_ino;
@@ -915,9 +915,43 @@ struct nilfs_vdesc {
 	__u64 vd_blocknr;
 	__u64 vd_offset;
 	__u32 vd_flags;
-	__u32 vd_pad;
+	/*
+	 * vd_blk_flags needed because vd_flags doesn't support
+	 * bit-flags because of backwards compatibility
+	 */
+	__u32 vd_blk_flags;
 };
 
+/* vdesc flags */
+enum {
+	NILFS_VDESC_SNAPSHOT_PROTECTED,
+	NILFS_VDESC_PERIOD_PROTECTED,
+
+	/* ... */
+
+	__NR_NILFS_VDESC_FIELDS,
+};
+
+#define NILFS_VDESC_FNS(flag, name)					\
+static inline void							\
+nilfs_vdesc_set_##name(struct nilfs_vdesc *vdesc)			\
+{									\
+	vdesc->vd_blk_flags |= (1UL << NILFS_VDESC_##flag);		\
+}									\
+static inline void							\
+nilfs_vdesc_clear_##name(struct nilfs_vdesc *vdesc)			\
+{									\
+	vdesc->vd_blk_flags &= ~(1UL << NILFS_VDESC_##flag);		\
+}									\
+static inline int							\
+nilfs_vdesc_##name(const struct nilfs_vdesc *vdesc)			\
+{									\
+	return !!(vdesc->vd_blk_flags & (1UL << NILFS_VDESC_##flag));	\
+}
+
+NILFS_VDESC_FNS(SNAPSHOT_PROTECTED, snapshot_protected)
+NILFS_VDESC_FNS(PERIOD_PROTECTED, period_protected)
+
 /**
  * struct nilfs_bdesc - descriptor of disk block number
  * @bd_ino: inode number
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
