From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 05/24] nilfs2: implement metadata (MDT) files subsystem
 debugging output
Date: Mon, 17 Jun 2013 16:23:06 +0400
Message-ID: <1371471786.2075.135.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=OsMLzomzSd+nvD+whYjxPLe2qk2muWjRWTsxLVLsLeU=;
	b=nSemXpDkI1lYKvsiUsswmuWFYLMdodqbFU/xAjdWaMYjjH0SSGX3uRup2wICOKhtnxYaER3q8ZlMuxaNahCYAjZIa3jC8pNZjyV7lSZuCMwoJJIm0SX0zVLxZcpX/zXO;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Linux FS Devel <linux-fsdevel@vger.kernel.org>

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 05/24] nilfs2: implement metadata (MDT) files subsystem debugging output

This patch adds debugging output by means of nilfs2_debug() method
into modules that are grouped by metadata (MDT) files debugging output
option (CONFIG_NILFS2_DEBUG_MDT_FILES).

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/cpfile.c |   67 ++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/dat.c    |    8 ++++++
 fs/nilfs2/ifile.c  |   17 ++++++++++++
 fs/nilfs2/mdt.c    |   51 ++++++++++++++++++++++++++++++++++
 fs/nilfs2/sufile.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 221 insertions(+)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index deaa3d3..3b6161f 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -133,6 +133,9 @@ static void nilfs_cpfile_block_init(struct inode *cpfile,
 static inline int nilfs_cpfile_get_header_block(struct inode *cpfile,
 						struct buffer_head **bhp)
 {
+	nilfs2_debug(DBG_CPFILE,
+			"i_ino %lu, bhp %p\n", cpfile->i_ino, bhp);
+
 	return nilfs_mdt_get_block(cpfile, 0, 0, NULL, bhp);
 }
 
@@ -141,6 +144,10 @@ static inline int nilfs_cpfile_get_checkpoint_block(struct inode *cpfile,
 						    int create,
 						    struct buffer_head **bhp)
 {
+	nilfs2_debug(DBG_CPFILE,
+			"i_ino %lu, cno %llu, create %d, bhp %p\n",
+			cpfile->i_ino, cno, create, bhp);
+
 	return nilfs_mdt_get_block(cpfile,
 				   nilfs_cpfile_get_blkoff(cpfile, cno),
 				   create, nilfs_cpfile_block_init, bhp);
@@ -149,6 +156,10 @@ static inline int nilfs_cpfile_get_checkpoint_block(struct inode *cpfile,
 static inline int nilfs_cpfile_delete_checkpoint_block(struct inode *cpfile,
 						       __u64 cno)
 {
+	nilfs2_debug(DBG_CPFILE,
+			"i_ino %lu, cno %llu\n",
+			cpfile->i_ino, cno);
+
 	return nilfs_mdt_delete_block(cpfile,
 				      nilfs_cpfile_get_blkoff(cpfile, cno));
 }
@@ -190,6 +201,10 @@ int nilfs_cpfile_get_checkpoint(struct inode *cpfile,
 	void *kaddr;
 	int ret;
 
+	nilfs2_debug(DBG_CPFILE,
+			"i_ino %lu, cno %llu, create %d, cpp %p, bhp %p\n",
+			cpfile->i_ino, cno, create, cpp, bhp);
+
 	if (unlikely(cno < 1 || cno > nilfs_mdt_cno(cpfile) ||
 		     (cno < nilfs_mdt_cno(cpfile) && create)))
 		return -EINVAL;
@@ -252,6 +267,10 @@ int nilfs_cpfile_get_checkpoint(struct inode *cpfile,
 void nilfs_cpfile_put_checkpoint(struct inode *cpfile, __u64 cno,
 				 struct buffer_head *bh)
 {
+	nilfs2_debug(DBG_CPFILE,
+			"i_ino %lu, cno %llu, bh %p\n",
+			cpfile->i_ino, cno, bh);
+
 	kunmap(bh->b_page);
 	brelse(bh);
 }
@@ -288,6 +307,10 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 	unsigned long tnicps;
 	int ret, ncps, nicps, nss, count, i;
 
+	nilfs2_debug(DBG_CPFILE,
+			"i_ino %lu, start %llu, end %llu\n",
+			cpfile->i_ino, start, end);
+
 	if (unlikely(start == 0 || start > end)) {
 		printk(KERN_ERR "%s: invalid range of checkpoint numbers: "
 		       "[%llu, %llu)\n", __func__,
@@ -378,6 +401,10 @@ static void nilfs_cpfile_checkpoint_to_cpinfo(struct inode *cpfile,
 					      struct nilfs_checkpoint *cp,
 					      struct nilfs_cpinfo *ci)
 {
+	nilfs2_debug(DBG_CPFILE,
+			"i_ino %lu, cp %p, ci %p\n",
+			cpfile->i_ino, cp, ci);
+
 	ci->ci_flags = le32_to_cpu(cp->cp_flags);
 	ci->ci_cno = le64_to_cpu(cp->cp_cno);
 	ci->ci_create = le64_to_cpu(cp->cp_create);
@@ -399,6 +426,10 @@ static ssize_t nilfs_cpfile_do_get_cpinfo(struct inode *cpfile, __u64 *cnop,
 	int n, ret;
 	int ncps, i;
 
+	nilfs2_debug(DBG_CPFILE,
+			"i_ino %lu, cnop %p, buf %p, cisz %u, nci %zu\n",
+			cpfile->i_ino, cnop, buf, cisz, nci);
+
 	if (cno == 0)
 		return -ENOENT; /* checkpoint number 0 is invalid */
 	down_read(&NILFS_MDT(cpfile)->mi_sem);
@@ -449,6 +480,10 @@ static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 *cnop,
 	void *kaddr;
 	int n = 0, ret;
 
+	nilfs2_debug(DBG_CPFILE,
+			"i_ino %lu, cnop %p, buf %p, cisz %u, nci %zu\n",
+			cpfile->i_ino, cnop, buf, cisz, nci);
+
 	down_read(&NILFS_MDT(cpfile)->mi_sem);
 
 	if (curr == 0) {
@@ -547,6 +582,10 @@ int nilfs_cpfile_delete_checkpoint(struct inode *cpfile, __u64 cno)
 	__u64 tcno = cno;
 	ssize_t nci;
 
+	nilfs2_debug(DBG_CPFILE,
+			"i_ino %lu, cno %llu\n",
+			cpfile->i_ino, cno);
+
 	nci = nilfs_cpfile_do_get_cpinfo(cpfile, &tcno, &ci, sizeof(ci), 1);
 	if (nci < 0)
 		return nci;
@@ -568,6 +607,10 @@ nilfs_cpfile_block_get_snapshot_list(const struct inode *cpfile,
 	struct nilfs_checkpoint *cp;
 	struct nilfs_snapshot_list *list;
 
+	nilfs2_debug(DBG_CPFILE,
+			"i_ino %lu, cno %llu, bh %p, kaddr %p\n",
+			cpfile->i_ino, cno, bh, kaddr);
+
 	if (cno != 0) {
 		cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, bh, kaddr);
 		list = &cp->cp_snapshot_list;
@@ -589,6 +632,10 @@ static int nilfs_cpfile_set_snapshot(struct inode *cpfile, __u64 cno)
 	void *kaddr;
 	int ret;
 
+	nilfs2_debug(DBG_CPFILE,
+			"i_ino %lu, cno %llu\n",
+			cpfile->i_ino, cno);
+
 	if (cno == 0)
 		return -ENOENT; /* checkpoint number 0 is invalid */
 	down_write(&NILFS_MDT(cpfile)->mi_sem);
@@ -707,6 +754,10 @@ static int nilfs_cpfile_clear_snapshot(struct inode *cpfile, __u64 cno)
 	void *kaddr;
 	int ret;
 
+	nilfs2_debug(DBG_CPFILE,
+			"i_ino %lu, cno %llu\n",
+			cpfile->i_ino, cno);
+
 	if (cno == 0)
 		return -ENOENT; /* checkpoint number 0 is invalid */
 	down_write(&NILFS_MDT(cpfile)->mi_sem);
@@ -824,6 +875,10 @@ int nilfs_cpfile_is_snapshot(struct inode *cpfile, __u64 cno)
 	void *kaddr;
 	int ret;
 
+	nilfs2_debug(DBG_CPFILE,
+			"i_ino %lu, cno %llu\n",
+			cpfile->i_ino, cno);
+
 	/* CP number is invalid if it's zero or larger than the
 	largest	exist one.*/
 	if (cno == 0 || cno >= nilfs_mdt_cno(cpfile))
@@ -869,6 +924,10 @@ int nilfs_cpfile_change_cpmode(struct inode *cpfile, __u64 cno, int mode)
 {
 	int ret;
 
+	nilfs2_debug(DBG_CPFILE,
+			"i_ino %lu, cno %llu, mode %#x\n",
+			cpfile->i_ino, cno, mode);
+
 	switch (mode) {
 	case NILFS_CHECKPOINT:
 		if (nilfs_checkpoint_is_mounted(cpfile->i_sb, cno))
@@ -911,6 +970,10 @@ int nilfs_cpfile_get_stat(struct inode *cpfile, struct nilfs_cpstat *cpstat)
 	void *kaddr;
 	int ret;
 
+	nilfs2_debug(DBG_CPFILE,
+			"i_ino %lu, cpstat %p\n",
+			cpfile->i_ino, cpstat);
+
 	down_read(&NILFS_MDT(cpfile)->mi_sem);
 
 	ret = nilfs_cpfile_get_header_block(cpfile, &bh);
@@ -942,6 +1005,10 @@ int nilfs_cpfile_read(struct super_block *sb, size_t cpsize,
 	struct inode *cpfile;
 	int err;
 
+	nilfs2_debug(DBG_CPFILE,
+			"sb %p, cpsize %zu, raw_inode %p, inodep %p\n",
+			sb, cpsize, raw_inode, inodep);
+
 	cpfile = nilfs_iget_locked(sb, NULL, NILFS_CPFILE_INO);
 	if (unlikely(!cpfile))
 		return -ENOMEM;
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index fa0f803..d382d00 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -306,6 +306,10 @@ int nilfs_dat_mark_dirty(struct inode *dat, __u64 vblocknr)
  */
 int nilfs_dat_freev(struct inode *dat, __u64 *vblocknrs, size_t nitems)
 {
+	nilfs2_debug(DBG_DAT,
+			"i_ino %lu, vblocknrs %p, nitems %zu\n",
+			dat->i_ino, vblocknrs, nitems);
+
 	return nilfs_palloc_freev(dat, vblocknrs, nitems);
 }
 
@@ -484,6 +488,10 @@ int nilfs_dat_read(struct super_block *sb, size_t entry_size,
 	struct nilfs_dat_info *di;
 	int err;
 
+	nilfs2_debug(DBG_DAT,
+			"sb %p, entry_size %zu, raw_inode %p, inodep %p\n",
+			sb, entry_size, raw_inode, inodep);
+
 	dat = nilfs_iget_locked(sb, NULL, NILFS_DAT_INO);
 	if (unlikely(!dat))
 		return -ENOMEM;
diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index d8e65bd..28cd24d 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -68,6 +68,10 @@ int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
 	struct nilfs_palloc_req req;
 	int ret;
 
+	nilfs2_debug(DBG_IFILE,
+		"i_ino %lu, out_ino ptr %p, out_bh %p\n",
+		ifile->i_ino, out_ino, out_bh);
+
 	req.pr_entry_nr = 0;  /* 0 says find free inode from beginning of
 				 a group. dull code!! */
 	req.pr_entry_bh = NULL;
@@ -87,6 +91,7 @@ int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
 	mark_buffer_dirty(req.pr_entry_bh);
 	nilfs_mdt_mark_dirty(ifile);
 	*out_ino = (ino_t)req.pr_entry_nr;
+	nilfs2_debug(DBG_IFILE, "out_ino %lu\n", *out_ino);
 	*out_bh = req.pr_entry_bh;
 	return 0;
 }
@@ -114,6 +119,10 @@ int nilfs_ifile_delete_inode(struct inode *ifile, ino_t ino)
 	void *kaddr;
 	int ret;
 
+	nilfs2_debug(DBG_IFILE,
+			"ifile ino %lu, deleted ino %lu\n",
+			ifile->i_ino, ino);
+
 	ret = nilfs_palloc_prepare_free_entry(ifile, &req);
 	if (!ret) {
 		ret = nilfs_palloc_get_entry_block(ifile, req.pr_entry_nr, 0,
@@ -146,6 +155,10 @@ int nilfs_ifile_get_inode_block(struct inode *ifile, ino_t ino,
 	struct super_block *sb = ifile->i_sb;
 	int err;
 
+	nilfs2_debug(DBG_IFILE,
+			"ifile ino %lu, get ino %lu, out_bh %p\n",
+			ifile->i_ino, ino, out_bh);
+
 	if (unlikely(!NILFS_VALID_INODE(sb, ino))) {
 		nilfs_error(sb, __func__, "bad inode number: %lu",
 			    (unsigned long) ino);
@@ -174,6 +187,10 @@ int nilfs_ifile_read(struct super_block *sb, struct nilfs_root *root,
 	struct inode *ifile;
 	int err;
 
+	nilfs2_debug(DBG_IFILE,
+		"sb %p, root %p, inode_size %zu, raw_inode %p, inodep %p\n",
+		sb, root, inode_size, raw_inode, inodep);
+
 	ifile = nilfs_iget_locked(sb, root, NILFS_IFILE_INO);
 	if (unlikely(!ifile))
 		return -ENOMEM;
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index c4dcd1d..723723f 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -47,6 +47,10 @@ nilfs_mdt_insert_new_block(struct inode *inode, unsigned long block,
 	void *kaddr;
 	int ret;
 
+	nilfs2_debug(DBG_MDT,
+			"i_ino %lu, block %lu, bh %p, init_block %p\n",
+			inode->i_ino, block, bh, init_block);
+
 	/* Caller exclude read accesses using page lock */
 
 	/* set_buffer_new(bh); */
@@ -82,6 +86,10 @@ static int nilfs_mdt_create_block(struct inode *inode, unsigned long block,
 	struct buffer_head *bh;
 	int err;
 
+	nilfs2_debug(DBG_MDT,
+			"i_ino %lu, block %lu, out_bh %p, init_block %p\n",
+			inode->i_ino, block, out_bh, init_block);
+
 	nilfs_transaction_begin(sb, &ti, 0);
 
 	err = -ENOMEM;
@@ -126,6 +134,10 @@ nilfs_mdt_submit_block(struct inode *inode, unsigned long blkoff,
 	__u64 blknum = 0;
 	int ret = -ENOMEM;
 
+	nilfs2_debug(DBG_MDT,
+			"i_ino %lu, blkoff %lu, mode %#x, out_bh %p\n",
+			inode->i_ino, blkoff, mode, out_bh);
+
 	bh = nilfs_grab_buffer(inode, inode->i_mapping, blkoff, 0);
 	if (unlikely(!bh))
 		goto failed;
@@ -178,6 +190,10 @@ static int nilfs_mdt_read_block(struct inode *inode, unsigned long block,
 	int i, nr_ra_blocks = NILFS_MDT_MAX_RA_BLOCKS;
 	int err;
 
+	nilfs2_debug(DBG_MDT,
+			"i_ino %lu, block %lu, readahead %d, out_bh %p\n",
+			inode->i_ino, block, readahead, out_bh);
+
 	err = nilfs_mdt_submit_block(inode, block, READ, &first_bh);
 	if (err == -EEXIST) /* internal code */
 		goto out;
@@ -246,6 +262,11 @@ int nilfs_mdt_get_block(struct inode *inode, unsigned long blkoff, int create,
 {
 	int ret;
 
+	nilfs2_debug(DBG_MDT,
+			"i_ino %lu, blkoff %lu, create %d, "
+			"init_block %p, out_bh %p\n",
+			inode->i_ino, blkoff, create, init_block, out_bh);
+
 	/* Should be rewritten with merging nilfs_mdt_read_block() */
  retry:
 	ret = nilfs_mdt_read_block(inode, blkoff, !create, out_bh);
@@ -277,6 +298,9 @@ int nilfs_mdt_delete_block(struct inode *inode, unsigned long block)
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 	int err;
 
+	nilfs2_debug(DBG_MDT,
+			"i_ino %lu, block %lu\n", inode->i_ino, block);
+
 	err = nilfs_bmap_delete(ii->i_bmap, block);
 	if (!err || err == -ENOENT) {
 		nilfs_mdt_mark_dirty(inode);
@@ -309,6 +333,9 @@ int nilfs_mdt_forget_block(struct inode *inode, unsigned long block)
 	int ret = 0;
 	int still_dirty;
 
+	nilfs2_debug(DBG_MDT,
+			"i_ino %lu, block %lu\n", inode->i_ino, block);
+
 	page = find_lock_page(inode->i_mapping, index);
 	if (!page)
 		return -ENOENT;
@@ -352,6 +379,9 @@ int nilfs_mdt_mark_block_dirty(struct inode *inode, unsigned long block)
 	struct buffer_head *bh;
 	int err;
 
+	nilfs2_debug(DBG_MDT,
+			"i_ino %lu, block %lu\n", inode->i_ino, block);
+
 	err = nilfs_mdt_read_block(inode, block, 0, &bh);
 	if (unlikely(err))
 		return err;
@@ -420,6 +450,10 @@ int nilfs_mdt_init(struct inode *inode, gfp_t gfp_mask, size_t objsz)
 {
 	struct nilfs_mdt_info *mi;
 
+	nilfs2_debug(DBG_MDT,
+			"i_ino %lu, gfp_mask %#x, objsz %zu\n",
+			inode->i_ino, gfp_mask, objsz);
+
 	mi = kzalloc(max(sizeof(*mi), objsz), GFP_NOFS);
 	if (!mi)
 		return -ENOMEM;
@@ -459,6 +493,9 @@ int nilfs_mdt_setup_shadow_map(struct inode *inode,
 	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
 	struct backing_dev_info *bdi = inode->i_sb->s_bdi;
 
+	nilfs2_debug(DBG_MDT,
+			"i_ino %lu, shadow %p\n", inode->i_ino, shadow);
+
 	INIT_LIST_HEAD(&shadow->frozen_buffers);
 	address_space_init_once(&shadow->frozen_data);
 	nilfs_mapping_init(&shadow->frozen_data, inode, bdi);
@@ -479,6 +516,8 @@ int nilfs_mdt_save_to_shadow_map(struct inode *inode)
 	struct nilfs_shadow_map *shadow = mi->mi_shadow;
 	int ret;
 
+	nilfs2_debug(DBG_MDT, "i_ino %lu\n", inode->i_ino);
+
 	ret = nilfs_copy_dirty_pages(&shadow->frozen_data, inode->i_mapping);
 	if (ret)
 		goto out;
@@ -500,6 +539,9 @@ int nilfs_mdt_freeze_buffer(struct inode *inode, struct buffer_head *bh)
 	struct page *page;
 	int blkbits = inode->i_blkbits;
 
+	nilfs2_debug(DBG_MDT,
+			"i_ino %lu, bh %p\n", inode->i_ino, bh);
+
 	page = grab_cache_page(&shadow->frozen_data, bh->b_page->index);
 	if (!page)
 		return -ENOMEM;
@@ -532,6 +574,9 @@ nilfs_mdt_get_frozen_buffer(struct inode *inode, struct buffer_head *bh)
 	struct page *page;
 	int n;
 
+	nilfs2_debug(DBG_MDT,
+			"i_ino %lu, bh %p\n", inode->i_ino, bh);
+
 	page = find_lock_page(&shadow->frozen_data, bh->b_page->index);
 	if (page) {
 		if (page_has_buffers(page)) {
@@ -549,6 +594,8 @@ static void nilfs_release_frozen_buffers(struct nilfs_shadow_map *shadow)
 	struct list_head *head = &shadow->frozen_buffers;
 	struct buffer_head *bh;
 
+	nilfs2_debug(DBG_MDT, "shadow %p\n", shadow);
+
 	while (!list_empty(head)) {
 		bh = list_first_entry(head, struct buffer_head,
 				      b_assoc_buffers);
@@ -567,6 +614,8 @@ void nilfs_mdt_restore_from_shadow_map(struct inode *inode)
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 	struct nilfs_shadow_map *shadow = mi->mi_shadow;
 
+	nilfs2_debug(DBG_MDT, "i_ino %lu\n", inode->i_ino);
+
 	down_write(&mi->mi_sem);
 
 	if (mi->mi_palloc_cache)
@@ -592,6 +641,8 @@ void nilfs_mdt_clear_shadow_map(struct inode *inode)
 	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
 	struct nilfs_shadow_map *shadow = mi->mi_shadow;
 
+	nilfs2_debug(DBG_MDT, "i_ino %lu\n", inode->i_ino);
+
 	down_write(&mi->mi_sem);
 	nilfs_release_frozen_buffers(shadow);
 	truncate_inode_pages(&shadow->frozen_data, 0);
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 3127e9f..b6408c4 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -92,6 +92,9 @@ nilfs_sufile_block_get_segment_usage(const struct inode *sufile, __u64 segnum,
 static inline int nilfs_sufile_get_header_block(struct inode *sufile,
 						struct buffer_head **bhp)
 {
+	nilfs2_debug(DBG_SUFILE,
+			"sufile ino %lu, bhp %p\n", sufile->i_ino, bhp);
+
 	return nilfs_mdt_get_block(sufile, 0, 0, NULL, bhp);
 }
 
@@ -99,6 +102,10 @@ static inline int
 nilfs_sufile_get_segment_usage_block(struct inode *sufile, __u64 segnum,
 				     int create, struct buffer_head **bhp)
 {
+	nilfs2_debug(DBG_SUFILE,
+			"sufile ino %lu, segnum %llu, create %d, bhp %p\n",
+			sufile->i_ino, segnum, create, bhp);
+
 	return nilfs_mdt_get_block(sufile,
 				   nilfs_sufile_get_blkoff(sufile, segnum),
 				   create, NULL, bhp);
@@ -107,6 +114,10 @@ nilfs_sufile_get_segment_usage_block(struct inode *sufile, __u64 segnum,
 static int nilfs_sufile_delete_segment_usage_block(struct inode *sufile,
 						   __u64 segnum)
 {
+	nilfs2_debug(DBG_SUFILE,
+			"sufile ino %lu, segnum %llu\n",
+			sufile->i_ino, segnum);
+
 	return nilfs_mdt_delete_block(sufile,
 				      nilfs_sufile_get_blkoff(sufile, segnum));
 }
@@ -117,6 +128,10 @@ static void nilfs_sufile_mod_counter(struct buffer_head *header_bh,
 	struct nilfs_sufile_header *header;
 	void *kaddr;
 
+	nilfs2_debug(DBG_SUFILE,
+			"header_bh %p, ncleanadd %llu, ndirtyadd %llu\n",
+			header_bh, ncleanadd, ndirtyadd);
+
 	kaddr = kmap_atomic(header_bh->b_page);
 	header = kaddr + bh_offset(header_bh);
 	le64_add_cpu(&header->sh_ncleansegs, ncleanadd);
@@ -175,6 +190,11 @@ int nilfs_sufile_updatev(struct inode *sufile, __u64 *segnumv, size_t nsegs,
 	size_t nerr = 0, n = 0;
 	int ret = 0;
 
+	nilfs2_debug(DBG_SUFILE,
+			"sufile ino %lu, segnumv %p, nsegs %zu, "
+			"create %d, ndone %p, dofunc %p\n",
+			sufile->i_ino, segnumv, nsegs, create, ndone, dofunc);
+
 	if (unlikely(nsegs == 0))
 		goto out;
 
@@ -239,6 +259,10 @@ int nilfs_sufile_update(struct inode *sufile, __u64 segnum, int create,
 	struct buffer_head *header_bh, *bh;
 	int ret;
 
+	nilfs2_debug(DBG_SUFILE,
+			"sufile ino %lu, segnum %llu, create %d, dofunc %p\n",
+			sufile->i_ino, segnum, create, dofunc);
+
 	if (unlikely(segnum >= nilfs_sufile_get_nsegments(sufile))) {
 		printk(KERN_WARNING "%s: invalid segment number: %llu\n",
 		       __func__, (unsigned long long)segnum);
@@ -279,6 +303,10 @@ int nilfs_sufile_set_alloc_range(struct inode *sufile, __u64 start, __u64 end)
 	__u64 nsegs;
 	int ret = -ERANGE;
 
+	nilfs2_debug(DBG_SUFILE,
+			"sufile ino %lu, start %llu, end %llu\n",
+			sufile->i_ino, start, end);
+
 	down_write(&NILFS_MDT(sufile)->mi_sem);
 	nsegs = nilfs_sufile_get_nsegments(sufile);
 
@@ -320,6 +348,10 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 	unsigned long nsegments, ncleansegs, nsus, cnt;
 	int ret, j;
 
+	nilfs2_debug(DBG_SUFILE,
+			"sufile ino %lu, segnump %p\n",
+			sufile->i_ino, segnump);
+
 	down_write(&NILFS_MDT(sufile)->mi_sem);
 
 	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
@@ -403,6 +435,7 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 
  out_sem:
 	up_write(&NILFS_MDT(sufile)->mi_sem);
+	nilfs2_debug(DBG_SUFILE, "segnum %llu\n", *segnump);
 	return ret;
 }
 
@@ -413,6 +446,10 @@ void nilfs_sufile_do_cancel_free(struct inode *sufile, __u64 segnum,
 	struct nilfs_segment_usage *su;
 	void *kaddr;
 
+	nilfs2_debug(DBG_SUFILE,
+			"sufile ino %lu, segnum %llu, header_bh %p, su_bh %p\n",
+			sufile->i_ino, segnum, header_bh, su_bh);
+
 	kaddr = kmap_atomic(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (unlikely(!nilfs_segment_usage_clean(su))) {
@@ -439,6 +476,10 @@ void nilfs_sufile_do_scrap(struct inode *sufile, __u64 segnum,
 	void *kaddr;
 	int clean, dirty;
 
+	nilfs2_debug(DBG_SUFILE,
+			"sufile ino %lu, segnum %llu, header_bh %p, su_bh %p\n",
+			sufile->i_ino, segnum, header_bh, su_bh);
+
 	kaddr = kmap_atomic(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (su->su_flags == cpu_to_le32(1UL << NILFS_SEGMENT_USAGE_DIRTY) &&
@@ -470,6 +511,10 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
 	void *kaddr;
 	int sudirty;
 
+	nilfs2_debug(DBG_SUFILE,
+			"sufile ino %lu, segnum %llu, header_bh %p, su_bh %p\n",
+			sufile->i_ino, segnum, header_bh, su_bh);
+
 	kaddr = kmap_atomic(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (nilfs_segment_usage_clean(su)) {
@@ -502,6 +547,10 @@ int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
 	struct buffer_head *bh;
 	int ret;
 
+	nilfs2_debug(DBG_SUFILE,
+			"sufile ino %lu, segnum %llu\n",
+			sufile->i_ino, segnum);
+
 	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
 	if (!ret) {
 		mark_buffer_dirty(bh);
@@ -526,6 +575,11 @@ int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
 	void *kaddr;
 	int ret;
 
+	nilfs2_debug(DBG_SUFILE,
+			"sufile ino %lu, segnum %llu, "
+			"nblocks %lu, modtime %lu\n",
+			sufile->i_ino, segnum, nblocks, modtime);
+
 	down_write(&NILFS_MDT(sufile)->mi_sem);
 	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
 	if (ret < 0)
@@ -572,6 +626,9 @@ int nilfs_sufile_get_stat(struct inode *sufile, struct nilfs_sustat *sustat)
 	void *kaddr;
 	int ret;
 
+	nilfs2_debug(DBG_SUFILE,
+			"sufile ino %lu, sustat %p\n", sufile->i_ino, sustat);
+
 	down_read(&NILFS_MDT(sufile)->mi_sem);
 
 	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
@@ -604,6 +661,10 @@ void nilfs_sufile_do_set_error(struct inode *sufile, __u64 segnum,
 	void *kaddr;
 	int suclean;
 
+	nilfs2_debug(DBG_SUFILE,
+			"sufile ino %lu, segnum %llu, header_bh %p, su_bh %p\n",
+			sufile->i_ino, segnum, header_bh, su_bh);
+
 	kaddr = kmap_atomic(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (nilfs_segment_usage_error(su)) {
@@ -655,6 +716,10 @@ static int nilfs_sufile_truncate_range(struct inode *sufile,
 	int ret;
 	int j;
 
+	nilfs2_debug(DBG_SUFILE,
+			"sufile ino %lu, start %llu, end %llu\n",
+			sufile->i_ino, start, end);
+
 	nsegs = nilfs_sufile_get_nsegments(sufile);
 
 	ret = -EINVAL;
@@ -753,6 +818,10 @@ int nilfs_sufile_resize(struct inode *sufile, __u64 newnsegs)
 	unsigned long nsegs, nrsvsegs;
 	int ret = 0;
 
+	nilfs2_debug(DBG_SUFILE,
+			"sufile ino %lu, newnsegs %llu\n",
+			sufile->i_ino, newnsegs);
+
 	down_write(&NILFS_MDT(sufile)->mi_sem);
 
 	nsegs = nilfs_sufile_get_nsegments(sufile);
@@ -824,6 +893,11 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
 	ssize_t n;
 	int ret, i, j;
 
+	nilfs2_debug(DBG_SUFILE,
+			"sufile ino %lu, segnum %llu, "
+			"buf %p, sisz %u, nsi %zu\n",
+			sufile->i_ino, segnum, buf, sisz, nsi);
+
 	down_read(&NILFS_MDT(sufile)->mi_sem);
 
 	segusages_per_block = nilfs_sufile_segment_usages_per_block(sufile);
@@ -886,6 +960,10 @@ int nilfs_sufile_read(struct super_block *sb, size_t susize,
 	void *kaddr;
 	int err;
 
+	nilfs2_debug(DBG_SUFILE,
+			"sb %p, susize %zu, raw_inode %p, inodep %p\n",
+			sb, susize, raw_inode, inodep);
+
 	sufile = nilfs_iget_locked(sb, NULL, NILFS_SUFILE_INO);
 	if (unlikely(!sufile))
 		return -ENOMEM;
-- 
1.7.9.5



