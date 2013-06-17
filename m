From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 11/24] nilfs2: implement recovery subsystem debugging output
Date: Mon, 17 Jun 2013 16:24:19 +0400
Message-ID: <1371471859.2075.142.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=Uh1NPznEvabNclFptTATZ5qjSVSfhSGtFOpJrXK75qc=;
	b=QqKmW9VXQX0YH3esPbkA/NS1DNQaZO9roJVeGbF48z/B/A1JgHW5D+FMtNEMwA9UDlTkhSr+AyKuNRfaQ6G1DzNyeyi9p/sicUpb/ITk9Ekt431ncIY3ji2DtG4hwrHN;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Linux FS Devel <linux-fsdevel@vger.kernel.org>

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 11/24] nilfs2: implement recovery subsystem debugging output

This patch adds debugging output by means of nilfs2_debug() method
into modules that are grouped by recovery subsystem debugging output
option (CONFIG_NILFS2_DEBUG_RECOVERY_SUBSYSTEM).

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/recovery.c |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index ff00a0b..1099ba1 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -110,6 +110,11 @@ static int nilfs_compute_checksum(struct the_nilfs *nilfs,
 	unsigned long size;
 	u32 crc;
 
+	nilfs2_debug(DBG_RECOVERY,
+			"nilfs %p, bhs %p, sum %p, offset %lu"
+			"check_bytes %llu, start %lu, nblock %lu\n",
+			nilfs, bhs, sum, offset, check_bytes, start, nblock);
+
 	BUG_ON(offset >= blocksize);
 	check_bytes -= offset;
 	size = min_t(u64, check_bytes, blocksize - offset);
@@ -147,6 +152,10 @@ int nilfs_read_super_root_block(struct the_nilfs *nilfs, sector_t sr_block,
 	u32 crc;
 	int ret;
 
+	nilfs2_debug(DBG_RECOVERY,
+			"nilfs %p, sr_block %lu, pbh %p, check %d\n",
+			nilfs, sr_block, pbh, check);
+
 	*pbh = NULL;
 	bh_sr = __bread(nilfs->ns_bdev, sr_block, nilfs->ns_blocksize);
 	if (unlikely(!bh_sr)) {
@@ -195,6 +204,10 @@ nilfs_read_log_header(struct the_nilfs *nilfs, sector_t start_blocknr,
 {
 	struct buffer_head *bh_sum;
 
+	nilfs2_debug(DBG_RECOVERY,
+			"nilfs %p, start_blocknr %lu, sum %p\n",
+			nilfs, start_blocknr, sum);
+
 	bh_sum = __bread(nilfs->ns_bdev, start_blocknr, nilfs->ns_blocksize);
 	if (bh_sum)
 		*sum = (struct nilfs_segment_summary *)bh_sum->b_data;
@@ -216,6 +229,10 @@ static int nilfs_validate_log(struct the_nilfs *nilfs, u64 seg_seq,
 	u32 crc;
 	int ret;
 
+	nilfs2_debug(DBG_RECOVERY,
+			"nilfs %p, seg_seq %llu, bh_sum %p, sum %p\n",
+			nilfs, seg_seq, bh_sum, sum);
+
 	ret = NILFS_SEG_FAIL_MAGIC;
 	if (le32_to_cpu(sum->ss_magic) != NILFS_SEGSUM_MAGIC)
 		goto out;
@@ -258,6 +275,10 @@ static void *nilfs_read_summary_info(struct the_nilfs *nilfs,
 	void *ptr;
 	sector_t blocknr;
 
+	nilfs2_debug(DBG_RECOVERY,
+			"nilfs %p, pbh %p, offset %u, bytes %u\n",
+			nilfs, pbh, *offset, bytes);
+
 	BUG_ON((*pbh)->b_size < *offset);
 	if (bytes > (*pbh)->b_size - *offset) {
 		blocknr = (*pbh)->b_blocknr;
@@ -270,6 +291,9 @@ static void *nilfs_read_summary_info(struct the_nilfs *nilfs,
 	}
 	ptr = (*pbh)->b_data + *offset;
 	*offset += bytes;
+
+	nilfs2_debug(DBG_RECOVERY, "calculated offset %u\n", *offset);
+
 	return ptr;
 }
 
@@ -289,6 +313,10 @@ static void nilfs_skip_summary_info(struct the_nilfs *nilfs,
 	unsigned int rest_item_in_current_block
 		= ((*pbh)->b_size - *offset) / bytes;
 
+	nilfs2_debug(DBG_RECOVERY,
+			"nilfs %p, pbh %p, offset %u, bytes %u, count %lu\n",
+			nilfs, pbh, *offset, bytes, count);
+
 	if (count <= rest_item_in_current_block) {
 		*offset += bytes * count;
 	} else {
@@ -304,6 +332,8 @@ static void nilfs_skip_summary_info(struct the_nilfs *nilfs,
 		*pbh = __bread(nilfs->ns_bdev, blocknr + bcnt,
 			       nilfs->ns_blocksize);
 	}
+
+	nilfs2_debug(DBG_RECOVERY, "calculated offset %u\n", *offset);
 }
 
 /**
@@ -324,6 +354,10 @@ static int nilfs_scan_dsync_log(struct the_nilfs *nilfs, sector_t start_blocknr,
 	ino_t ino;
 	int err = -EIO;
 
+	nilfs2_debug(DBG_RECOVERY,
+			"nilfs %p, start_blocknr %lu, sum %p, head %p\n",
+			nilfs, start_blocknr, sum, head);
+
 	nfinfo = le32_to_cpu(sum->ss_nfinfo);
 	if (!nfinfo)
 		return 0;
@@ -404,6 +438,9 @@ static int nilfs_segment_list_add(struct list_head *head, __u64 segnum)
 {
 	struct nilfs_segment_entry *ent = kmalloc(sizeof(*ent), GFP_NOFS);
 
+	nilfs2_debug(DBG_RECOVERY,
+			"head %p, segnum %llu\n", head, segnum);
+
 	if (unlikely(!ent))
 		return -ENOMEM;
 
@@ -435,6 +472,9 @@ static int nilfs_prepare_segment_for_recovery(struct the_nilfs *nilfs,
 	int err;
 	int i;
 
+	nilfs2_debug(DBG_RECOVERY,
+			"nilfs %p, sb %p, ri %p\n", nilfs, sb, ri);
+
 	segnum[0] = nilfs->ns_segnum;
 	segnum[1] = nilfs->ns_nextnum;
 	segnum[2] = ri->ri_segnum;
@@ -489,6 +529,10 @@ static int nilfs_recovery_copy_block(struct the_nilfs *nilfs,
 	struct buffer_head *bh_org;
 	void *kaddr;
 
+	nilfs2_debug(DBG_RECOVERY,
+			"nilfs %p, rb %p, i_ino %lu\n",
+			nilfs, rb, page->mapping->host->i_ino);
+
 	bh_org = __bread(nilfs->ns_bdev, rb->blocknr, nilfs->ns_blocksize);
 	if (unlikely(!bh_org))
 		return -EIO;
@@ -513,6 +557,11 @@ static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
 	loff_t pos;
 	int err = 0, err2 = 0;
 
+	nilfs2_debug(DBG_RECOVERY,
+			"nilfs %p, sb %p, root %p, "
+			"head %p, nr_salvaged_blocks %p\n",
+			nilfs, sb, root, head, nr_salvaged_blocks);
+
 	list_for_each_entry_safe(rb, n, head, list) {
 		inode = nilfs_iget(sb, root, rb->ino);
 		if (IS_ERR(inode)) {
@@ -598,6 +647,10 @@ static int nilfs_do_roll_forward(struct the_nilfs *nilfs,
 	};
 	int state = RF_INIT_ST;
 
+	nilfs2_debug(DBG_RECOVERY,
+			"nilfs %p, sb %p, root %p, ri %p\n",
+			nilfs, sb, root, ri);
+
 	pseg_start = ri->ri_lsegs_start;
 	seg_seq = ri->ri_lsegs_start_seq;
 	segnum = nilfs_get_segnum_of_block(nilfs, pseg_start);
@@ -706,6 +759,9 @@ static void nilfs_finish_roll_forward(struct the_nilfs *nilfs,
 	struct buffer_head *bh;
 	int err;
 
+	nilfs2_debug(DBG_RECOVERY,
+			"nilfs %p, ri %p\n", nilfs, ri);
+
 	if (nilfs_get_segnum_of_block(nilfs, ri->ri_lsegs_start) !=
 	    nilfs_get_segnum_of_block(nilfs, ri->ri_super_root))
 		return;
@@ -748,6 +804,10 @@ int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
 	struct nilfs_root *root;
 	int err;
 
+	nilfs2_debug(DBG_RECOVERY,
+			"nilfs %p, sb %p, ri %p\n",
+			nilfs, sb, ri);
+
 	if (ri->ri_lsegs_start == 0 || ri->ri_lsegs_end == 0)
 		return 0;
 
@@ -827,6 +887,9 @@ int nilfs_search_super_root(struct the_nilfs *nilfs,
 	int empty_seg = 0, scan_newer = 0;
 	int ret;
 
+	nilfs2_debug(DBG_RECOVERY,
+			"nilfs %p, ri %p\n", nilfs, ri);
+
 	pseg_start = nilfs->ns_last_pseg;
 	seg_seq = nilfs->ns_last_seq;
 	cno = nilfs->ns_last_cno;
-- 
1.7.9.5



