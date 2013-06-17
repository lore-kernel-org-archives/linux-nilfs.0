From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 07/24] nilfs2: implement segments subsystem debugging output
Date: Mon, 17 Jun 2013 16:23:32 +0400
Message-ID: <1371471812.2075.137.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=wiF/iXIpUoBRbzX1H6B6jSxEp4tCJd/c91+M1qWqa+Y=;
	b=Lbnf7MJwyQigQy1OYFIn9GLcpZvghW9nxKSWJUmyM61691g7vrdr+qRauYiNalJRQR8s9r6syXj0TfDjB9QsZCbUH2x7axj5kpEnpNT1RFKp5ksfnzOOdtLICRl49aoK;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Linux FS Devel <linux-fsdevel@vger.kernel.org>

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 07/24] nilfs2: implement segments subsystem debugging output

This patch adds debugging output by means of nilfs2_debug() method
into modules that are grouped by segments subsystem debugging output
option (CONFIG_NILFS2_DEBUG_SEGMENTS_SUBSYSTEM).

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/segbuf.c  |   30 +++++++
 fs/nilfs2/segment.c |  247 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 274 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index dc9a913..6ee75b1 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -73,6 +73,10 @@ void nilfs_segbuf_free(struct nilfs_segment_buffer *segbuf)
 void nilfs_segbuf_map(struct nilfs_segment_buffer *segbuf, __u64 segnum,
 		     unsigned long offset, struct the_nilfs *nilfs)
 {
+	nilfs2_debug(DBG_SEGBUF,
+			"segbuf %p, segnum %llu, offset %lu, nilfs %p\n",
+			segbuf, segnum, offset, nilfs);
+
 	segbuf->sb_segnum = segnum;
 	nilfs_get_segment_range(nilfs, segnum, &segbuf->sb_fseg_start,
 				&segbuf->sb_fseg_end);
@@ -90,6 +94,10 @@ void nilfs_segbuf_map(struct nilfs_segment_buffer *segbuf, __u64 segnum,
 void nilfs_segbuf_map_cont(struct nilfs_segment_buffer *segbuf,
 			   struct nilfs_segment_buffer *prev)
 {
+	nilfs2_debug(DBG_SEGBUF,
+			"prev->sb_segnum %llu, prev->sb_pseg_start %lu\n",
+			prev->sb_segnum, prev->sb_pseg_start);
+
 	segbuf->sb_segnum = prev->sb_segnum;
 	segbuf->sb_fseg_start = prev->sb_fseg_start;
 	segbuf->sb_fseg_end = prev->sb_fseg_end;
@@ -109,6 +117,10 @@ int nilfs_segbuf_extend_segsum(struct nilfs_segment_buffer *segbuf)
 {
 	struct buffer_head *bh;
 
+	nilfs2_debug(DBG_SEGBUF,
+			"sb_segnum %llu, sb_pseg_start %lu\n",
+			segbuf->sb_segnum, segbuf->sb_pseg_start);
+
 	bh = sb_getblk(segbuf->sb_super,
 		       segbuf->sb_pseg_start + segbuf->sb_sum.nsumblk);
 	if (unlikely(!bh))
@@ -123,6 +135,10 @@ int nilfs_segbuf_extend_payload(struct nilfs_segment_buffer *segbuf,
 {
 	struct buffer_head *bh;
 
+	nilfs2_debug(DBG_SEGBUF,
+			"sb_segnum %llu, sb_pseg_start %lu, bhp %p\n",
+			segbuf->sb_segnum, segbuf->sb_pseg_start, bhp);
+
 	bh = sb_getblk(segbuf->sb_super,
 		       segbuf->sb_pseg_start + segbuf->sb_sum.nblocks);
 	if (unlikely(!bh))
@@ -138,6 +154,12 @@ int nilfs_segbuf_reset(struct nilfs_segment_buffer *segbuf, unsigned flags,
 {
 	int err;
 
+	nilfs2_debug(DBG_SEGBUF,
+			"sb_segnum %llu, sb_pseg_start %lu, "
+			"flags %#x, ctime %lu, cno %llu\n",
+			segbuf->sb_segnum, segbuf->sb_pseg_start,
+			flags, ctime, cno);
+
 	segbuf->sb_sum.nblocks = segbuf->sb_sum.nsumblk = 0;
 	err = nilfs_segbuf_extend_segsum(segbuf);
 	if (unlikely(err))
@@ -159,6 +181,10 @@ void nilfs_segbuf_fill_in_segsum(struct nilfs_segment_buffer *segbuf)
 	struct nilfs_segment_summary *raw_sum;
 	struct buffer_head *bh_sum;
 
+	nilfs2_debug(DBG_SEGBUF,
+			"sb_segnum %llu, sb_pseg_start %lu\n",
+			segbuf->sb_segnum, segbuf->sb_pseg_start);
+
 	bh_sum = list_entry(segbuf->sb_segsum_buffers.next,
 			    struct buffer_head, b_assoc_buffers);
 	raw_sum = (struct nilfs_segment_summary *)bh_sum->b_data;
@@ -263,6 +289,10 @@ static void nilfs_release_buffers(struct list_head *list)
 
 static void nilfs_segbuf_clear(struct nilfs_segment_buffer *segbuf)
 {
+	nilfs2_debug(DBG_SEGBUF,
+			"sb_segnum %llu, sb_pseg_start %lu\n",
+			segbuf->sb_segnum, segbuf->sb_pseg_start);
+
 	nilfs_release_buffers(&segbuf->sb_segsum_buffers);
 	nilfs_release_buffers(&segbuf->sb_payload_buffers);
 	segbuf->sb_super_root = NULL;
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index a5752a58..98b3f96 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -147,6 +147,11 @@ static int nilfs_prepare_segment_lock(struct nilfs_transaction_info *ti)
 	ti->ti_save = save;
 	ti->ti_magic = NILFS_TI_MAGIC;
 	current->journal_info = ti;
+
+	nilfs2_debug(DBG_SEGMENT,
+			"ti_magic %#x, ti_flags %#hx, ti_count %hu\n",
+			ti->ti_magic, ti->ti_flags, ti->ti_count);
+
 	return 0;
 }
 
@@ -182,8 +187,13 @@ int nilfs_transaction_begin(struct super_block *sb,
 			    int vacancy_check)
 {
 	struct the_nilfs *nilfs;
-	int ret = nilfs_prepare_segment_lock(ti);
+	int ret;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sb %p, ti %p, vacancy_check %d\n",
+			sb, ti, vacancy_check);
+
+	ret = nilfs_prepare_segment_lock(ti);
 	if (unlikely(ret < 0))
 		return ret;
 	if (ret > 0)
@@ -227,6 +237,11 @@ int nilfs_transaction_commit(struct super_block *sb)
 	int err = 0;
 
 	BUG_ON(ti == NULL || ti->ti_magic != NILFS_TI_MAGIC);
+
+	nilfs2_debug(DBG_SEGMENT,
+			"ti_magic %#x, ti_flags %#hx, ti_count %hu\n",
+			ti->ti_magic, ti->ti_flags, ti->ti_count);
+
 	ti->ti_flags |= NILFS_TI_COMMIT;
 	if (ti->ti_count > 0) {
 		ti->ti_count--;
@@ -257,6 +272,11 @@ void nilfs_transaction_abort(struct super_block *sb)
 	struct the_nilfs *nilfs = sb->s_fs_info;
 
 	BUG_ON(ti == NULL || ti->ti_magic != NILFS_TI_MAGIC);
+
+	nilfs2_debug(DBG_SEGMENT,
+			"ti_magic %#x, ti_flags %#hx, ti_count %hu\n",
+			ti->ti_magic, ti->ti_flags, ti->ti_count);
+
 	if (ti->ti_count > 0) {
 		ti->ti_count--;
 		return;
@@ -308,6 +328,12 @@ static void nilfs_transaction_lock(struct super_block *sb,
 	INIT_LIST_HEAD(&ti->ti_garbage);
 	current->journal_info = ti;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"ti_magic %#x, ti_flags %#hx, "
+			"ti_count %hu, gcflag %d\n",
+			ti->ti_magic, ti->ti_flags,
+			ti->ti_count, gcflag);
+
 	for (;;) {
 		down_write(&nilfs->ns_segctor_sem);
 		if (!test_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags))
@@ -330,6 +356,10 @@ static void nilfs_transaction_unlock(struct super_block *sb)
 	BUG_ON(ti == NULL || ti->ti_magic != NILFS_TI_MAGIC);
 	BUG_ON(ti->ti_count > 0);
 
+	nilfs2_debug(DBG_SEGMENT,
+			"ti_magic %#x, ti_flags %#hx, ti_count %hu\n",
+			ti->ti_magic, ti->ti_flags, ti->ti_count);
+
 	up_write(&nilfs->ns_segctor_sem);
 	current->journal_info = ti->ti_save;
 	if (!list_empty(&ti->ti_garbage))
@@ -344,6 +374,10 @@ static void *nilfs_segctor_map_segsum_entry(struct nilfs_sc_info *sci,
 	unsigned blocksize = sci->sc_super->s_blocksize;
 	void *p;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, segnum %llu, ssp->offset %u, bytes %u\n",
+			sci, segbuf->sb_segnum, ssp->offset, bytes);
+
 	if (unlikely(ssp->offset + bytes > blocksize)) {
 		ssp->offset = 0;
 		BUG_ON(NILFS_SEGBUF_BH_IS_LAST(ssp->bh,
@@ -367,6 +401,10 @@ static int nilfs_segctor_reset_segment_buffer(struct nilfs_sc_info *sci)
 	unsigned flags = 0;
 	int err;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, segnum %llu, cno %llu\n",
+			sci, segbuf->sb_segnum, sci->sc_cno);
+
 	if (nilfs_doing_gc())
 		flags = NILFS_SS_GC;
 	err = nilfs_segbuf_reset(segbuf, flags, sci->sc_seg_ctime, sci->sc_cno);
@@ -383,6 +421,8 @@ static int nilfs_segctor_reset_segment_buffer(struct nilfs_sc_info *sci)
 
 static int nilfs_segctor_feed_segment(struct nilfs_sc_info *sci)
 {
+	nilfs2_debug(DBG_SEGMENT, "sci %p\n", sci);
+
 	sci->sc_nblk_this_inc += sci->sc_curseg->sb_sum.nblocks;
 	if (NILFS_SEGBUF_IS_LAST(sci->sc_curseg, &sci->sc_segbufs))
 		return -E2BIG; /* The current segment is filled up
@@ -396,6 +436,9 @@ static int nilfs_segctor_add_super_root(struct nilfs_sc_info *sci)
 	struct nilfs_segment_buffer *segbuf = sci->sc_curseg;
 	int err;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, segnum %llu\n", sci, segbuf->sb_segnum);
+
 	if (segbuf->sb_sum.nblocks >= segbuf->sb_rest_blocks) {
 		err = nilfs_segctor_feed_segment(sci);
 		if (err)
@@ -426,6 +469,9 @@ static int nilfs_segctor_segsum_block_required(
 static void nilfs_segctor_begin_finfo(struct nilfs_sc_info *sci,
 				      struct inode *inode)
 {
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, i_ino %lu\n", sci, inode->i_ino);
+
 	sci->sc_curseg->sb_sum.nfinfo++;
 	sci->sc_binfo_ptr = sci->sc_finfo_ptr;
 	nilfs_segctor_map_segsum_entry(
@@ -445,6 +491,10 @@ static void nilfs_segctor_end_finfo(struct nilfs_sc_info *sci,
 	struct nilfs_segment_buffer *segbuf;
 	__u64 cno;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, i_ino %lu, segnum %llu\n",
+			sci, inode->i_ino, sci->sc_curseg->sb_segnum);
+
 	if (sci->sc_blk_cnt == 0)
 		return;
 
@@ -479,6 +529,11 @@ static int nilfs_segctor_add_file_block(struct nilfs_sc_info *sci,
 	struct nilfs_segment_buffer *segbuf;
 	int required, err = 0;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, ino %lu, segnum %llu, bh %p, binfo_size %u\n",
+			sci, inode->i_ino, sci->sc_curseg->sb_segnum,
+			bh, binfo_size);
+
  retry:
 	segbuf = sci->sc_curseg;
 	required = nilfs_segctor_segsum_block_required(
@@ -514,6 +569,9 @@ static int nilfs_collect_file_data(struct nilfs_sc_info *sci,
 {
 	int err;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, i_ino %lu, bh %p\n", sci, inode->i_ino, bh);
+
 	err = nilfs_bmap_propagate(NILFS_I(inode)->i_bmap, bh);
 	if (err < 0)
 		return err;
@@ -529,6 +587,9 @@ static int nilfs_collect_file_node(struct nilfs_sc_info *sci,
 				   struct buffer_head *bh,
 				   struct inode *inode)
 {
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, i_ino %lu, bh %p\n", sci, inode->i_ino, bh);
+
 	return nilfs_bmap_propagate(NILFS_I(inode)->i_bmap, bh);
 }
 
@@ -536,6 +597,9 @@ static int nilfs_collect_file_bmap(struct nilfs_sc_info *sci,
 				   struct buffer_head *bh,
 				   struct inode *inode)
 {
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, i_ino %lu, bh %p\n", sci, inode->i_ino, bh);
+
 	WARN_ON(!buffer_dirty(bh));
 	return nilfs_segctor_add_file_block(sci, bh, inode, sizeof(__le64));
 }
@@ -571,6 +635,9 @@ static int nilfs_collect_dat_data(struct nilfs_sc_info *sci,
 {
 	int err;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, i_ino %lu, bh %p\n", sci, inode->i_ino, bh);
+
 	err = nilfs_bmap_propagate(NILFS_I(inode)->i_bmap, bh);
 	if (err < 0)
 		return err;
@@ -634,6 +701,10 @@ static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
 	size_t ndirties = 0;
 	int i;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"i_ino %lu, nlimit %zu, start %llu, end %llu\n",
+			inode->i_ino, nlimit, start, end);
+
 	if (unlikely(start != 0 || end != LLONG_MAX)) {
 		/*
 		 * A valid range is given for sync-ing data pages. The
@@ -692,6 +763,9 @@ static void nilfs_lookup_dirty_node_buffers(struct inode *inode,
 	unsigned int i;
 	pgoff_t index = 0;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"i_ino %lu, listp %p\n", inode->i_ino, listp);
+
 	pagevec_init(&pvec, 0);
 
 	while (pagevec_lookup_tag(&pvec, mapping, &index, PAGECACHE_TAG_DIRTY,
@@ -719,6 +793,9 @@ static void nilfs_dispose_list(struct the_nilfs *nilfs,
 	struct nilfs_inode_info *ivec[SC_N_INODEVEC], **pii;
 	unsigned nv = 0;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"nilfs %p, head %p, force %d\n", nilfs, head, force);
+
 	while (!list_empty(head)) {
 		spin_lock(&nilfs->ns_inode_lock);
 		list_for_each_entry_safe(ii, n, head, i_dirty) {
@@ -758,6 +835,9 @@ static int nilfs_test_metadata_dirty(struct the_nilfs *nilfs,
 		ret++;
 	if ((ret || nilfs_doing_gc()) && nilfs_mdt_fetch_dirty(nilfs->ns_dat))
 		ret++;
+
+	nilfs2_debug(DBG_SEGMENT, "ret %d\n", ret);
+
 	return ret;
 }
 
@@ -782,6 +862,9 @@ static int nilfs_segctor_confirm(struct nilfs_sc_info *sci)
 		ret++;
 
 	spin_unlock(&nilfs->ns_inode_lock);
+
+	nilfs2_debug(DBG_SEGMENT, "ret %d\n", ret);
+
 	return ret;
 }
 
@@ -789,6 +872,8 @@ static void nilfs_segctor_clear_metadata_dirty(struct nilfs_sc_info *sci)
 {
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 
+	nilfs2_debug(DBG_SEGMENT, "sci %p\n", sci);
+
 	nilfs_mdt_clear_dirty(sci->sc_root->ifile);
 	nilfs_mdt_clear_dirty(nilfs->ns_cpfile);
 	nilfs_mdt_clear_dirty(nilfs->ns_sufile);
@@ -802,6 +887,8 @@ static int nilfs_segctor_create_checkpoint(struct nilfs_sc_info *sci)
 	struct nilfs_checkpoint *raw_cp;
 	int err;
 
+	nilfs2_debug(DBG_SEGMENT, "sci %p\n", sci);
+
 	/* XXX: this interface will be changed */
 	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, 1,
 					  &raw_cp, &bh_cp);
@@ -826,6 +913,8 @@ static int nilfs_segctor_fill_in_checkpoint(struct nilfs_sc_info *sci)
 	struct nilfs_checkpoint *raw_cp;
 	int err;
 
+	nilfs2_debug(DBG_SEGMENT, "sci %p\n", sci);
+
 	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, 0,
 					  &raw_cp, &bh_cp);
 	if (unlikely(err)) {
@@ -864,6 +953,9 @@ static void nilfs_fill_in_file_bmap(struct inode *ifile,
 	struct buffer_head *ibh;
 	struct nilfs_inode *raw_inode;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"i_ino %lu\n", ii->vfs_inode.i_ino);
+
 	if (test_bit(NILFS_I_BMAP, &ii->i_state)) {
 		ibh = ii->i_bh;
 		BUG_ON(!ibh);
@@ -878,6 +970,8 @@ static void nilfs_segctor_fill_in_file_bmap(struct nilfs_sc_info *sci)
 {
 	struct nilfs_inode_info *ii;
 
+	nilfs2_debug(DBG_SEGMENT, "sci %p\n", sci);
+
 	list_for_each_entry(ii, &sci->sc_dirty_files, i_dirty) {
 		nilfs_fill_in_file_bmap(sci->sc_root->ifile, ii);
 		set_bit(NILFS_I_COLLECTED, &ii->i_state);
@@ -891,6 +985,9 @@ static void nilfs_segctor_fill_in_super_root(struct nilfs_sc_info *sci,
 	struct nilfs_super_root *raw_sr;
 	unsigned isz, srsz;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, nilfs %p\n", sci, nilfs);
+
 	bh_sr = NILFS_LAST_SEGBUF(&sci->sc_segbufs)->sb_super_root;
 	raw_sr = (struct nilfs_super_root *)bh_sr->b_data;
 	isz = nilfs->ns_inode_size;
@@ -916,8 +1013,11 @@ static void nilfs_redirty_inodes(struct list_head *head)
 	struct nilfs_inode_info *ii;
 
 	list_for_each_entry(ii, head, i_dirty) {
-		if (test_bit(NILFS_I_COLLECTED, &ii->i_state))
+		if (test_bit(NILFS_I_COLLECTED, &ii->i_state)) {
+			nilfs2_debug(DBG_SEGMENT,
+					"i_ino %lu\n", ii->vfs_inode.i_ino);
 			clear_bit(NILFS_I_COLLECTED, &ii->i_state);
+		}
 	}
 }
 
@@ -929,6 +1029,7 @@ static void nilfs_drop_collected_inodes(struct list_head *head)
 		if (!test_and_clear_bit(NILFS_I_COLLECTED, &ii->i_state))
 			continue;
 
+		nilfs2_debug(DBG_SEGMENT, "i_ino %lu\n", ii->vfs_inode.i_ino);
 		clear_bit(NILFS_I_INODE_DIRTY, &ii->i_state);
 		set_bit(NILFS_I_UPDATED, &ii->i_state);
 	}
@@ -944,6 +1045,10 @@ static int nilfs_segctor_apply_buffers(struct nilfs_sc_info *sci,
 	struct buffer_head *bh, *n;
 	int err = 0;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, i_ino %lu, listp %p, collect %p\n",
+			sci, inode->i_ino, listp, collect);
+
 	if (collect) {
 		list_for_each_entry_safe(bh, n, listp, b_assoc_buffers) {
 			list_del_init(&bh->b_assoc_buffers);
@@ -980,6 +1085,10 @@ static int nilfs_segctor_scan_file(struct nilfs_sc_info *sci,
 	LIST_HEAD(node_buffers);
 	int err;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, i_ino %lu, sc_ops %p\n",
+			sci, inode->i_ino, sc_ops);
+
 	if (!(sci->sc_stage.flags & NILFS_CF_NODE)) {
 		size_t n, rest = nilfs_segctor_buffer_rest(sci);
 
@@ -1032,6 +1141,9 @@ static int nilfs_segctor_scan_file_dsync(struct nilfs_sc_info *sci,
 	size_t n, rest = nilfs_segctor_buffer_rest(sci);
 	int err;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, i_ino %lu\n", sci, inode->i_ino);
+
 	n = nilfs_lookup_dirty_data_buffers(inode, &data_buffers, rest + 1,
 					    sci->sc_dsync_start,
 					    sci->sc_dsync_end);
@@ -1054,6 +1166,10 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
 	size_t ndone;
 	int err = 0;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, sci->sc_stage.scnt %d, mode %#x\n",
+			sci, sci->sc_stage.scnt, mode);
+
 	switch (sci->sc_stage.scnt) {
 	case NILFS_ST_INIT:
 		/* Pre-processes */
@@ -1213,6 +1329,9 @@ static int nilfs_segctor_begin_construction(struct nilfs_sc_info *sci,
 	__u64 nextnum;
 	int err, alloc = 0;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, nilfs %p\n", sci, nilfs);
+
 	segbuf = nilfs_segbuf_new(sci->sc_super);
 	if (unlikely(!segbuf))
 		return -ENOMEM;
@@ -1275,6 +1394,9 @@ static int nilfs_segctor_extend_segments(struct nilfs_sc_info *sci,
 	LIST_HEAD(list);
 	int err, ret, i;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, nilfs %p, nadd %d\n", sci, nilfs, nadd);
+
 	prev = NILFS_LAST_SEGBUF(&sci->sc_segbufs);
 	/*
 	 * Since the segment specified with nextnum might be allocated during
@@ -1329,6 +1451,9 @@ static void nilfs_free_incomplete_logs(struct list_head *logs,
 	struct inode *sufile = nilfs->ns_sufile;
 	int ret;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"logs %p, nilfs %p\n", logs, nilfs);
+
 	segbuf = NILFS_FIRST_SEGBUF(logs);
 	if (nilfs->ns_nextnum != segbuf->sb_nextnum) {
 		ret = nilfs_sufile_free(sufile, segbuf->sb_nextnum);
@@ -1366,6 +1491,9 @@ static void nilfs_segctor_update_segusage(struct nilfs_sc_info *sci,
 	unsigned long live_blocks;
 	int ret;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, sufile %p\n", sci, sufile);
+
 	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
 		live_blocks = segbuf->sb_sum.nblocks +
 			(segbuf->sb_pseg_start - segbuf->sb_fseg_start);
@@ -1381,6 +1509,9 @@ static void nilfs_cancel_segusage(struct list_head *logs, struct inode *sufile)
 	struct nilfs_segment_buffer *segbuf;
 	int ret;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"logs %p, sufile %p\n", logs, sufile);
+
 	segbuf = NILFS_FIRST_SEGBUF(logs);
 	ret = nilfs_sufile_set_segment_usage(sufile, segbuf->sb_segnum,
 					     segbuf->sb_pseg_start -
@@ -1401,6 +1532,9 @@ static void nilfs_segctor_truncate_segments(struct nilfs_sc_info *sci,
 	struct nilfs_segment_buffer *segbuf = last;
 	int ret;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, last %p, sufile %p\n", sci, last, sufile);
+
 	list_for_each_entry_continue(segbuf, &sci->sc_segbufs, sb_list) {
 		sci->sc_segbuf_nblocks -= segbuf->sb_rest_blocks;
 		ret = nilfs_sufile_free(sufile, segbuf->sb_nextnum);
@@ -1416,6 +1550,9 @@ static int nilfs_segctor_collect(struct nilfs_sc_info *sci,
 	struct nilfs_cstage prev_stage = sci->sc_stage;
 	int err, nadd = 1;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, nilfs %p, mode %#x\n", sci, nilfs, mode);
+
 	/* Collection retry loop */
 	for (;;) {
 		sci->sc_nblk_this_inc = 0;
@@ -1486,6 +1623,9 @@ nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
 	ino_t ino = 0;
 	int err = 0;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, segbuf %p, mode %#x\n", sci, segbuf, mode);
+
 	if (!nfinfo)
 		goto out;
 
@@ -1547,6 +1687,9 @@ static int nilfs_segctor_assign(struct nilfs_sc_info *sci, int mode)
 	struct nilfs_segment_buffer *segbuf;
 	int err;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, mode %#x\n", sci, mode);
+
 	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
 		err = nilfs_segctor_update_payload_blocknr(sci, segbuf, mode);
 		if (unlikely(err))
@@ -1563,6 +1706,9 @@ static void nilfs_begin_page_io(struct page *page)
 		   twice.  We ignore the 2nd or later calls by this check. */
 		return;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"i_ino %lu\n", page->mapping->host->i_ino);
+
 	lock_page(page);
 	clear_page_dirty_for_io(page);
 	set_page_writeback(page);
@@ -1574,6 +1720,8 @@ static void nilfs_segctor_prepare_write(struct nilfs_sc_info *sci)
 	struct nilfs_segment_buffer *segbuf;
 	struct page *bd_page = NULL, *fs_page = NULL;
 
+	nilfs2_debug(DBG_SEGMENT, "sci %p\n", sci);
+
 	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
 		struct buffer_head *bh;
 
@@ -1622,6 +1770,9 @@ static int nilfs_segctor_write(struct nilfs_sc_info *sci,
 {
 	int ret;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, nilfs %p\n", sci, nilfs);
+
 	ret = nilfs_write_logs(&sci->sc_segbufs, nilfs);
 	list_splice_tail_init(&sci->sc_segbufs, &sci->sc_write_logs);
 	return ret;
@@ -1632,6 +1783,10 @@ static void nilfs_end_page_io(struct page *page, int err)
 	if (!page)
 		return;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"i_ino %lu, offset %llu, err %d\n",
+			page->mapping->host->i_ino, page_offset(page), err);
+
 	if (buffer_nilfs_node(page_buffers(page)) && !PageWriteback(page)) {
 		/*
 		 * For b-tree node pages, this function may be called twice
@@ -1674,6 +1829,9 @@ static void nilfs_abort_logs(struct list_head *logs, int err)
 	if (list_empty(logs))
 		return;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"logs %p, err %d\n", logs, err);
+
 	list_for_each_entry(segbuf, logs, sb_list) {
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
 				    b_assoc_buffers) {
@@ -1686,6 +1844,13 @@ static void nilfs_abort_logs(struct list_head *logs, int err)
 
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
+
+			nilfs2_debug(DBG_SEGMENT,
+					"segnum %llu, ino %lu, blocknr %lu\n",
+					segbuf->sb_segnum,
+					bh->b_page->mapping->host->i_ino,
+					bh->b_blocknr);
+
 			if (bh == segbuf->sb_super_root) {
 				if (bh->b_page != bd_page) {
 					end_page_writeback(bd_page);
@@ -1711,6 +1876,9 @@ static void nilfs_segctor_abort_construction(struct nilfs_sc_info *sci,
 	LIST_HEAD(logs);
 	int ret;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, nilfs %p, err %d\n", sci, nilfs, err);
+
 	list_splice_tail_init(&sci->sc_write_logs, &logs);
 	ret = nilfs_wait_on_logs(&logs);
 	nilfs_abort_logs(&logs, ret ? : err);
@@ -1748,9 +1916,13 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int update_sr = false;
 
+	nilfs2_debug(DBG_SEGMENT, "sci %p\n", sci);
+
 	list_for_each_entry(segbuf, &sci->sc_write_logs, sb_list) {
 		struct buffer_head *bh;
 
+		nilfs2_debug(DBG_SEGMENT, "segnum %llu\n", segbuf->sb_segnum);
+
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
 				    b_assoc_buffers) {
 			set_buffer_uptodate(bh);
@@ -1839,6 +2011,8 @@ static int nilfs_segctor_wait(struct nilfs_sc_info *sci)
 {
 	int ret;
 
+	nilfs2_debug(DBG_SEGMENT, "sci %p\n", sci);
+
 	ret = nilfs_wait_on_logs(&sci->sc_write_logs);
 	if (!ret) {
 		nilfs_segctor_complete_write(sci);
@@ -1853,6 +2027,9 @@ static int nilfs_segctor_collect_dirty_files(struct nilfs_sc_info *sci,
 	struct nilfs_inode_info *ii, *n;
 	struct inode *ifile = sci->sc_root->ifile;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, nilfs %p\n", sci, nilfs);
+
 	spin_lock(&nilfs->ns_inode_lock);
  retry:
 	list_for_each_entry_safe(ii, n, &nilfs->ns_dirty_files, i_dirty) {
@@ -1860,6 +2037,9 @@ static int nilfs_segctor_collect_dirty_files(struct nilfs_sc_info *sci,
 			struct buffer_head *ibh;
 			int err;
 
+			nilfs2_debug(DBG_SEGMENT,
+					"ino %lu\n", ii->vfs_inode.i_ino);
+
 			spin_unlock(&nilfs->ns_inode_lock);
 			err = nilfs_ifile_get_inode_block(
 				ifile, ii->vfs_inode.i_ino, &ibh);
@@ -1893,12 +2073,18 @@ static void nilfs_segctor_drop_written_files(struct nilfs_sc_info *sci,
 	struct nilfs_transaction_info *ti = current->journal_info;
 	struct nilfs_inode_info *ii, *n;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, nilfs %p\n", sci, nilfs);
+
 	spin_lock(&nilfs->ns_inode_lock);
 	list_for_each_entry_safe(ii, n, &sci->sc_dirty_files, i_dirty) {
 		if (!test_and_clear_bit(NILFS_I_UPDATED, &ii->i_state) ||
 		    test_bit(NILFS_I_DIRTY, &ii->i_state))
 			continue;
 
+		nilfs2_debug(DBG_SEGMENT,
+				"ino %lu\n", ii->vfs_inode.i_ino);
+
 		clear_bit(NILFS_I_BUSY, &ii->i_state);
 		brelse(ii->i_bh);
 		ii->i_bh = NULL;
@@ -1915,6 +2101,9 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int err;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, mode %#x\n", sci, mode);
+
 	sci->sc_stage.scnt = NILFS_ST_INIT;
 	sci->sc_cno = nilfs->ns_cno;
 
@@ -2027,6 +2216,8 @@ static void nilfs_segctor_start_timer(struct nilfs_sc_info *sci)
 
 static void nilfs_segctor_do_flush(struct nilfs_sc_info *sci, int bn)
 {
+	nilfs2_debug(DBG_SEGMENT, "sci %p, bn %d\n", sci, bn);
+
 	spin_lock(&sci->sc_state_lock);
 	if (!(sci->sc_flush_request & (1 << bn))) {
 		unsigned long prev_req = sci->sc_flush_request;
@@ -2048,6 +2239,8 @@ void nilfs_flush_segment(struct super_block *sb, ino_t ino)
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 
+	nilfs2_debug(DBG_SEGMENT, "ino %lu\n", ino);
+
 	if (!sci || nilfs_doing_construction())
 		return;
 	nilfs_segctor_do_flush(sci, NILFS_MDT_INODE(sb, ino) ? ino : 0);
@@ -2066,6 +2259,8 @@ static int nilfs_segctor_sync(struct nilfs_sc_info *sci)
 	struct nilfs_segctor_wait_request wait_req;
 	int err = 0;
 
+	nilfs2_debug(DBG_SEGMENT, "sci %p\n", sci);
+
 	spin_lock(&sci->sc_state_lock);
 	init_wait(&wait_req.wq);
 	wait_req.err = 0;
@@ -2099,6 +2294,9 @@ static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err)
 	struct nilfs_segctor_wait_request *wrq, *n;
 	unsigned long flags;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, err %d\n", sci, err);
+
 	spin_lock_irqsave(&sci->sc_wait_request.lock, flags);
 	list_for_each_entry_safe(wrq, n, &sci->sc_wait_request.task_list,
 				 wq.task_list) {
@@ -2143,6 +2341,8 @@ int nilfs_construct_segment(struct super_block *sb)
 	if (!sci)
 		return -EROFS;
 
+	nilfs2_debug(DBG_SEGMENT, "sb %p\n", sb);
+
 	/* A call inside transactions causes a deadlock. */
 	BUG_ON((ti = current->journal_info) && ti->ti_magic == NILFS_TI_MAGIC);
 
@@ -2182,6 +2382,10 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 	if (!sci)
 		return -EROFS;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"segnum %llu, ino %lu, start %llu, end %llu\n",
+			sci->sc_curseg->sb_segnum, inode->i_ino, start, end);
+
 	nilfs_transaction_lock(sb, &ti, 0);
 
 	ii = NILFS_I(inode);
@@ -2235,6 +2439,9 @@ static void nilfs_segctor_accept(struct nilfs_sc_info *sci)
  */
 static void nilfs_segctor_notify(struct nilfs_sc_info *sci, int mode, int err)
 {
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, mode %#x, err %d\n", sci, mode, err);
+
 	/* Clear requests (even when the construction failed) */
 	spin_lock(&sci->sc_state_lock);
 
@@ -2268,6 +2475,9 @@ static int nilfs_segctor_construct(struct nilfs_sc_info *sci, int mode)
 	struct nilfs_super_block **sbp;
 	int err = 0;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, mode %#x\n", sci, mode);
+
 	nilfs_segctor_accept(sci);
 
 	if (nilfs_discontinued(nilfs))
@@ -2308,9 +2518,15 @@ nilfs_remove_written_gcinodes(struct the_nilfs *nilfs, struct list_head *head)
 {
 	struct nilfs_inode_info *ii, *n;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"nilfs %p, head %p\n", nilfs, head);
+
 	list_for_each_entry_safe(ii, n, head, i_dirty) {
 		if (!test_bit(NILFS_I_UPDATED, &ii->i_state))
 			continue;
+
+		nilfs2_debug(DBG_SEGMENT, "ino %lu\n", ii->vfs_inode.i_ino);
+
 		list_del_init(&ii->i_dirty);
 		truncate_inode_pages(&ii->vfs_inode.i_data, 0);
 		nilfs_btnode_cache_clear(&ii->i_btnode_cache);
@@ -2326,6 +2542,9 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 	struct nilfs_transaction_info ti;
 	int err;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sb %p, argv %p, kbufs %p\n", sb, argv, kbufs);
+
 	if (unlikely(!sci))
 		return -EROFS;
 
@@ -2380,6 +2599,9 @@ static void nilfs_segctor_thread_construct(struct nilfs_sc_info *sci, int mode)
 {
 	struct nilfs_transaction_info ti;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sci %p, mode %#x\n", sci, mode);
+
 	nilfs_transaction_lock(sci->sc_super, &ti, 0);
 	nilfs_segctor_construct(sci, mode);
 
@@ -2399,6 +2621,8 @@ static void nilfs_segctor_do_immediate_flush(struct nilfs_sc_info *sci)
 	int mode = 0;
 	int err;
 
+	nilfs2_debug(DBG_SEGMENT, "sci %p\n", sci);
+
 	spin_lock(&sci->sc_state_lock);
 	mode = (sci->sc_flush_request & FLUSH_DAT_BIT) ?
 		SC_FLUSH_DAT : SC_FLUSH_FILE;
@@ -2440,6 +2664,8 @@ static int nilfs_segctor_thread(void *arg)
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int timeout = 0;
 
+	nilfs2_debug(DBG_SEGMENT, "arg %p\n", arg);
+
 	sci->sc_timer.data = (unsigned long)current;
 	sci->sc_timer.function = nilfs_construction_timeout;
 
@@ -2472,7 +2698,6 @@ static int nilfs_segctor_thread(void *arg)
 		timeout = 0;
 	}
 
-
 	if (freezing(current)) {
 		spin_unlock(&sci->sc_state_lock);
 		try_to_freeze();
@@ -2519,6 +2744,8 @@ static int nilfs_segctor_start_thread(struct nilfs_sc_info *sci)
 {
 	struct task_struct *t;
 
+	nilfs2_debug(DBG_SEGMENT, "sci %p\n", sci);
+
 	t = kthread_run(nilfs_segctor_thread, sci, "segctord");
 	if (IS_ERR(t)) {
 		int err = PTR_ERR(t);
@@ -2537,6 +2764,8 @@ static void nilfs_segctor_kill_thread(struct nilfs_sc_info *sci)
 {
 	sci->sc_state |= NILFS_SEGCTOR_QUIT;
 
+	nilfs2_debug(DBG_SEGMENT, "sci %p\n", sci);
+
 	while (sci->sc_task) {
 		wake_up(&sci->sc_wait_daemon);
 		spin_unlock(&sci->sc_state_lock);
@@ -2554,6 +2783,9 @@ static struct nilfs_sc_info *nilfs_segctor_new(struct super_block *sb,
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sb %p, root %p\n", sb, root);
+
 	sci = kzalloc(sizeof(*sci), GFP_KERNEL);
 	if (!sci)
 		return NULL;
@@ -2588,6 +2820,8 @@ static void nilfs_segctor_write_out(struct nilfs_sc_info *sci)
 {
 	int ret, retrycount = NILFS_SC_CLEANUP_RETRY;
 
+	nilfs2_debug(DBG_SEGMENT, "sci %p\n", sci);
+
 	/* The segctord thread was stopped and its timer was removed.
 	   But some tasks remain. */
 	do {
@@ -2613,6 +2847,8 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int flag;
 
+	nilfs2_debug(DBG_SEGMENT, "sci %p\n", sci);
+
 	up_write(&nilfs->ns_segctor_sem);
 
 	spin_lock(&sci->sc_state_lock);
@@ -2659,6 +2895,9 @@ int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root)
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	int err;
 
+	nilfs2_debug(DBG_SEGMENT,
+			"sb %p, root %p\n", sb, root);
+
 	if (nilfs->ns_writer) {
 		/*
 		 * This happens if the filesystem was remounted
@@ -2692,6 +2931,8 @@ void nilfs_detach_log_writer(struct super_block *sb)
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	LIST_HEAD(garbage_list);
 
+	nilfs2_debug(DBG_SEGMENT, "sb %p\n", sb);
+
 	down_write(&nilfs->ns_segctor_sem);
 	if (nilfs->ns_writer) {
 		nilfs_segctor_destroy(nilfs->ns_writer);
-- 
1.7.9.5



