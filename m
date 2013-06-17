From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 03/24] nilfs2: implement base subsystem debugging output
Date: Mon, 17 Jun 2013 16:22:38 +0400
Message-ID: <1371471758.2075.132.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=PaM5PcHxtjL6zve2nTgEUVsq0wGPa6TyY0Kj86x3Z5M=;
	b=I2nAbTnjm2s2fpZLGrFdfEbAX4+v9oKQSAT9kXgSkrCnSNVjREKLEEyRqab+hVnRR66Cav/srf9/3S+5aP3ZMeoHj2p5HYwSEDSG00K8tGi0gPq0eiRrgOsKWaxw/gD+;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 03/24] nilfs2: implement base subsystem debugging output

This patch adds debugging output by means of nilfs2_debug() method
into modules that are grouped by base subsystem debugging output
option (CONFIG_NILFS2_DEBUG_BASE_OPERATIONS).

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/dir.c       |   24 +++++++++
 fs/nilfs2/file.c      |    6 +++
 fs/nilfs2/inode.c     |  130 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/nilfs2/ioctl.c     |   93 +++++++++++++++++++++++++++++++++++
 fs/nilfs2/namei.c     |   51 ++++++++++++++++++-
 fs/nilfs2/nilfs.h     |    1 +
 fs/nilfs2/super.c     |   87 +++++++++++++++++++++++++++++++++
 fs/nilfs2/the_nilfs.c |   42 ++++++++++++++++
 8 files changed, 431 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index f30b017..cc8acdd 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -268,6 +268,8 @@ static int nilfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	unsigned char *types = NULL;
 	int ret;
 
+	nilfs2_debug(DBG_DIR, "i_ino %lu\n", inode->i_ino);
+
 	if (pos > inode->i_size - NILFS_DIR_REC_LEN(1))
 		goto success;
 
@@ -345,6 +347,8 @@ nilfs_find_entry(struct inode *dir, const struct qstr *qstr,
 	struct nilfs_inode_info *ei = NILFS_I(dir);
 	struct nilfs_dir_entry *de;
 
+	nilfs2_debug(DBG_DIR, "i_ino %lu\n", dir->i_ino);
+
 	if (npages == 0)
 		goto out;
 
@@ -400,6 +404,8 @@ struct nilfs_dir_entry *nilfs_dotdot(struct inode *dir, struct page **p)
 	struct page *page = nilfs_get_page(dir, 0);
 	struct nilfs_dir_entry *de = NULL;
 
+	nilfs2_debug(DBG_DIR, "i_ino %lu\n", dir->i_ino);
+
 	if (!IS_ERR(page)) {
 		de = nilfs_next_entry(
 			(struct nilfs_dir_entry *)page_address(page));
@@ -414,6 +420,8 @@ ino_t nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr)
 	struct nilfs_dir_entry *de;
 	struct page *page;
 
+	nilfs2_debug(DBG_DIR, "i_ino %lu\n", dir->i_ino);
+
 	de = nilfs_find_entry(dir, qstr, &page);
 	if (de) {
 		res = le64_to_cpu(de->inode);
@@ -432,6 +440,10 @@ void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
 	struct address_space *mapping = page->mapping;
 	int err;
 
+	nilfs2_debug(DBG_DIR,
+			"dir->i_ino %lu, inode->i_ino %lu\n",
+			dir->i_ino, inode->i_ino);
+
 	lock_page(page);
 	err = nilfs_prepare_chunk(page, from, to);
 	BUG_ON(err);
@@ -461,6 +473,10 @@ int nilfs_add_link(struct dentry *dentry, struct inode *inode)
 	unsigned from, to;
 	int err;
 
+	nilfs2_debug(DBG_DIR,
+			"dir->i_ino %lu, inode->i_ino %lu\n",
+			dir->i_ino, inode->i_ino);
+
 	/*
 	 * We take care of directory expansion in the same loop.
 	 * This code plays outside i_size, so it locks the page
@@ -557,6 +573,8 @@ int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct page *page)
 	struct nilfs_dir_entry *de = (struct nilfs_dir_entry *)(kaddr + from);
 	int err;
 
+	nilfs2_debug(DBG_DIR, "i_ino %lu\n", inode->i_ino);
+
 	while ((char *)de < (char *)dir) {
 		if (de->rec_len == 0) {
 			nilfs_error(inode->i_sb, __func__,
@@ -594,6 +612,10 @@ int nilfs_make_empty(struct inode *inode, struct inode *parent)
 	int err;
 	void *kaddr;
 
+	nilfs2_debug(DBG_DIR,
+			"parent->i_ino %lu, inode->i_ino %lu\n",
+			parent->i_ino, inode->i_ino);
+
 	if (!page)
 		return -ENOMEM;
 
@@ -632,6 +654,8 @@ int nilfs_empty_dir(struct inode *inode)
 	struct page *page = NULL;
 	unsigned long i, npages = dir_pages(inode);
 
+	nilfs2_debug(DBG_DIR, "i_ino %lu\n", inode->i_ino);
+
 	for (i = 0; i < npages; i++) {
 		char *kaddr;
 		struct nilfs_dir_entry *de;
diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 08fdb77..85f7229 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -41,6 +41,10 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	struct inode *inode = file->f_mapping->host;
 	int err;
 
+	nilfs2_debug(DBG_FILE,
+			"i_ino %lu, start %llu, end %llu, datasync %d\n",
+			inode->i_ino, start, end, datasync);
+
 	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (err)
 		return err;
@@ -71,6 +75,8 @@ static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct nilfs_transaction_info ti;
 	int ret = 0;
 
+	nilfs2_debug(DBG_FILE, "i_ino %lu\n", inode->i_ino);
+
 	if (unlikely(nilfs_near_disk_full(inode->i_sb->s_fs_info)))
 		return VM_FAULT_SIGBUS; /* -ENOSPC */
 
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index bccfec8..8aba5d3 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -52,6 +52,8 @@ void nilfs_inode_add_blocks(struct inode *inode, int n)
 {
 	struct nilfs_root *root = NILFS_I(inode)->i_root;
 
+	nilfs2_debug(DBG_INODE, "i_ino %lu, n %d\n", inode->i_ino, n);
+
 	inode_add_bytes(inode, (1 << inode->i_blkbits) * n);
 	if (root)
 		atomic_add(n, &root->blocks_count);
@@ -61,6 +63,8 @@ void nilfs_inode_sub_blocks(struct inode *inode, int n)
 {
 	struct nilfs_root *root = NILFS_I(inode)->i_root;
 
+	nilfs2_debug(DBG_INODE, "i_ino %lu, n %d\n", inode->i_ino, n);
+
 	inode_sub_bytes(inode, (1 << inode->i_blkbits) * n);
 	if (root)
 		atomic_sub(n, &root->blocks_count);
@@ -86,6 +90,10 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
 	int err = 0, ret;
 	unsigned maxblocks = bh_result->b_size >> inode->i_blkbits;
 
+	nilfs2_debug(DBG_INODE,
+			"i_ino %lu, blkoff %lu, bh_result %p, create %d\n",
+			inode->i_ino, blkoff, bh_result, create);
+
 	down_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	ret = nilfs_bmap_lookup_contig(ii->i_bmap, blkoff, &blknum, maxblocks);
 	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
@@ -219,7 +227,15 @@ static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
 
 static int nilfs_set_page_dirty(struct page *page)
 {
-	int ret = __set_page_dirty_nobuffers(page);
+	int ret;
+
+	nilfs2_debug(DBG_INODE,
+			"i_ino %lu, i_size %llu. offset %llu\n",
+			page->mapping->host->i_ino,
+			i_size_read(page->mapping->host),
+			page_offset(page));
+
+	ret = __set_page_dirty_nobuffers(page);
 
 	if (page_has_buffers(page)) {
 		struct inode *inode = page->mapping->host;
@@ -253,6 +269,10 @@ void nilfs_write_failed(struct address_space *mapping, loff_t to)
 {
 	struct inode *inode = mapping->host;
 
+	nilfs2_debug(DBG_INODE,
+			"i_ino %lu, i_size %llu, to %llu\n",
+			inode->i_ino, i_size_read(inode), to);
+
 	if (to > inode->i_size) {
 		truncate_pagecache(inode, to, inode->i_size);
 		nilfs_truncate(inode);
@@ -265,8 +285,13 @@ static int nilfs_write_begin(struct file *file, struct address_space *mapping,
 
 {
 	struct inode *inode = mapping->host;
-	int err = nilfs_transaction_begin(inode->i_sb, NULL, 1);
+	int err;
 
+	nilfs2_debug(DBG_INODE,
+			"i_ino %lu, i_size %llu, pos %llu, len %u, flags %#x\n",
+			inode->i_ino, i_size_read(inode), pos, len, flags);
+
+	err = nilfs_transaction_begin(inode->i_sb, NULL, 1);
 	if (unlikely(err))
 		return err;
 
@@ -288,6 +313,10 @@ static int nilfs_write_end(struct file *file, struct address_space *mapping,
 	unsigned nr_dirty;
 	int err;
 
+	nilfs2_debug(DBG_INODE,
+			"i_ino %lu, i_size %llu, pos %llu, len %u copied %u\n",
+			inode->i_ino, i_size_read(inode), pos, len, copied);
+
 	nr_dirty = nilfs_page_count_clean_buffers(page, start,
 						  start + copied);
 	copied = generic_write_end(file, mapping, pos, len, copied, page,
@@ -306,6 +335,10 @@ nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	struct inode *inode = file->f_mapping->host;
 	ssize_t size;
 
+	nilfs2_debug(DBG_INODE,
+		"i_ino %lu, i_size %llu, rw %d, offset %llu, nr_segs %lu\n",
+		inode->i_ino, i_size_read(inode), rw, offset, nr_segs);
+
 	if (rw == WRITE)
 		return 0;
 
@@ -352,10 +385,15 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	int err = -ENOMEM;
 	ino_t ino;
 
+	nilfs2_debug(DBG_INODE,
+			"dir->i_ino %lu, mode %#x\n", dir->i_ino, mode);
+
 	inode = new_inode(sb);
 	if (unlikely(!inode))
 		goto failed;
 
+	nilfs2_debug(DBG_INODE, "inode->i_ino %lu\n", inode->i_ino);
+
 	mapping_set_gfp_mask(inode->i_mapping,
 			     mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
 
@@ -422,6 +460,9 @@ void nilfs_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = NILFS_I(inode)->i_flags;
 
+	nilfs2_debug(DBG_INODE,
+			"i_ino %lu\n", inode->i_ino);
+
 	inode->i_flags &= ~(S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME |
 			    S_DIRSYNC);
 	if (flags & FS_SYNC_FL)
@@ -444,6 +485,9 @@ int nilfs_read_inode_common(struct inode *inode,
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 	int err;
 
+	nilfs2_debug(DBG_INODE,
+			"i_ino %lu\n", inode->i_ino);
+
 	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
 	i_uid_write(inode, le32_to_cpu(raw_inode->i_uid));
 	i_gid_write(inode, le32_to_cpu(raw_inode->i_gid));
@@ -488,6 +532,10 @@ static int __nilfs_read_inode(struct super_block *sb,
 	struct nilfs_inode *raw_inode;
 	int err;
 
+	nilfs2_debug(DBG_INODE,
+			"sb %p, root %p, ino %lu, inode %p\n",
+			sb, root, ino, inode);
+
 	down_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	err = nilfs_ifile_get_inode_block(root->ifile, ino, &bh);
 	if (unlikely(err))
@@ -536,6 +584,8 @@ static int nilfs_iget_test(struct inode *inode, void *opaque)
 	struct nilfs_iget_args *args = opaque;
 	struct nilfs_inode_info *ii;
 
+	nilfs2_debug(DBG_INODE, "i_ino %lu\n", inode->i_ino);
+
 	if (args->ino != inode->i_ino || args->root != NILFS_I(inode)->i_root)
 		return 0;
 
@@ -550,6 +600,8 @@ static int nilfs_iget_set(struct inode *inode, void *opaque)
 {
 	struct nilfs_iget_args *args = opaque;
 
+	nilfs2_debug(DBG_INODE, "i_ino %lu\n", inode->i_ino);
+
 	inode->i_ino = args->ino;
 	if (args->for_gc) {
 		NILFS_I(inode)->i_state = 1 << NILFS_I_GCINODE;
@@ -570,6 +622,10 @@ struct inode *nilfs_ilookup(struct super_block *sb, struct nilfs_root *root,
 		.ino = ino, .root = root, .cno = 0, .for_gc = 0
 	};
 
+	nilfs2_debug(DBG_INODE,
+			"sb %p, root %p, ino %lu\n",
+			sb, root, ino);
+
 	return ilookup5(sb, ino, nilfs_iget_test, &args);
 }
 
@@ -580,6 +636,10 @@ struct inode *nilfs_iget_locked(struct super_block *sb, struct nilfs_root *root,
 		.ino = ino, .root = root, .cno = 0, .for_gc = 0
 	};
 
+	nilfs2_debug(DBG_INODE,
+			"sb %p, root %p, ino %lu\n",
+			sb, root, ino);
+
 	return iget5_locked(sb, ino, nilfs_iget_test, nilfs_iget_set, &args);
 }
 
@@ -589,6 +649,10 @@ struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root *root,
 	struct inode *inode;
 	int err;
 
+	nilfs2_debug(DBG_INODE,
+			"sb %p, root %p, ino %lu\n",
+			sb, root, ino);
+
 	inode = nilfs_iget_locked(sb, root, ino);
 	if (unlikely(!inode))
 		return ERR_PTR(-ENOMEM);
@@ -613,6 +677,10 @@ struct inode *nilfs_iget_for_gc(struct super_block *sb, unsigned long ino,
 	struct inode *inode;
 	int err;
 
+	nilfs2_debug(DBG_INODE,
+			"sb %p, ino %lu, cno %llu\n",
+			sb, ino, cno);
+
 	inode = iget5_locked(sb, ino, nilfs_iget_test, nilfs_iget_set, &args);
 	if (unlikely(!inode))
 		return ERR_PTR(-ENOMEM);
@@ -633,6 +701,10 @@ void nilfs_write_inode_common(struct inode *inode,
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 
+	nilfs2_debug(DBG_INODE,
+			"i_ino %lu, i_size %llu, raw_inode %p, has_bmap %d\n",
+			inode->i_ino, i_size_read(inode), raw_inode, has_bmap);
+
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
 	raw_inode->i_uid = cpu_to_le32(i_uid_read(inode));
 	raw_inode->i_gid = cpu_to_le32(i_gid_read(inode));
@@ -673,6 +745,10 @@ void nilfs_update_inode(struct inode *inode, struct buffer_head *ibh)
 	struct inode *ifile = ii->i_root->ifile;
 	struct nilfs_inode *raw_inode;
 
+	nilfs2_debug(DBG_INODE,
+			"i_ino %lu, i_size %llu, ibh %p\n",
+			inode->i_ino, i_size_read(inode), ibh);
+
 	raw_inode = nilfs_ifile_map_inode(ifile, ino, ibh);
 
 	if (test_and_clear_bit(NILFS_I_NEW, &ii->i_state))
@@ -694,6 +770,12 @@ static void nilfs_truncate_bmap(struct nilfs_inode_info *ii,
 	unsigned long b;
 	int ret;
 
+	nilfs2_debug(DBG_INODE,
+			"i_ino %lu, i_size %llu, from %lu\n",
+			ii->vfs_inode.i_ino,
+			i_size_read(&ii->vfs_inode),
+			from);
+
 	if (!test_bit(NILFS_I_BMAP, &ii->i_state))
 		return;
 repeat:
@@ -727,6 +809,10 @@ void nilfs_truncate(struct inode *inode)
 	struct super_block *sb = inode->i_sb;
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 
+	nilfs2_debug(DBG_INODE,
+			"i_ino %lu, i_size %llu\n",
+			inode->i_ino, i_size_read(inode));
+
 	if (!test_bit(NILFS_I_BMAP, &ii->i_state))
 		return;
 	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
@@ -756,6 +842,10 @@ static void nilfs_clear_inode(struct inode *inode)
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
 
+	nilfs2_debug(DBG_INODE,
+			"i_ino %lu, i_size %llu\n",
+			inode->i_ino, i_size_read(inode));
+
 	/*
 	 * Free resources allocated in nilfs_read_inode(), here.
 	 */
@@ -782,6 +872,10 @@ void nilfs_evict_inode(struct inode *inode)
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 	int ret;
 
+	nilfs2_debug(DBG_INODE,
+			"i_ino %lu, i_size %llu\n",
+			inode->i_ino, i_size_read(inode));
+
 	if (inode->i_nlink || !ii->i_root || unlikely(is_bad_inode(inode))) {
 		if (inode->i_data.nrpages)
 			truncate_inode_pages(&inode->i_data, 0);
@@ -819,6 +913,10 @@ int nilfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	struct super_block *sb = inode->i_sb;
 	int err;
 
+	nilfs2_debug(DBG_INODE,
+		"i_ino %lu, inode->i_size %llu, iattr->ia_size %llu\n",
+		inode->i_ino, i_size_read(inode), iattr->ia_size);
+
 	err = inode_change_ok(inode, iattr);
 	if (err)
 		return err;
@@ -853,6 +951,11 @@ out_err:
 int nilfs_permission(struct inode *inode, int mask)
 {
 	struct nilfs_root *root = NILFS_I(inode)->i_root;
+
+	nilfs2_debug(DBG_INODE,
+			"i_ino %lu, i_size %llu, mask %#x\n",
+			inode->i_ino, i_size_read(inode), mask);
+
 	if ((mask & MAY_WRITE) && root &&
 	    root->cno != NILFS_CPTREE_CURRENT_CNO)
 		return -EROFS; /* snapshot is not writable */
@@ -866,6 +969,9 @@ int nilfs_load_inode_block(struct inode *inode, struct buffer_head **pbh)
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 	int err;
 
+	nilfs2_debug(DBG_INODE,
+			"i_ino %lu, pbh %p\n", inode->i_ino, pbh);
+
 	spin_lock(&nilfs->ns_inode_lock);
 	if (ii->i_bh == NULL) {
 		spin_unlock(&nilfs->ns_inode_lock);
@@ -894,6 +1000,10 @@ int nilfs_inode_dirty(struct inode *inode)
 	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 	int ret = 0;
 
+	nilfs2_debug(DBG_INODE,
+			"i_ino %lu, i_size %llu\n",
+			inode->i_ino, i_size_read(inode));
+
 	if (!list_empty(&ii->i_dirty)) {
 		spin_lock(&nilfs->ns_inode_lock);
 		ret = test_bit(NILFS_I_DIRTY, &ii->i_state) ||
@@ -908,6 +1018,10 @@ int nilfs_set_file_dirty(struct inode *inode, unsigned nr_dirty)
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 
+	nilfs2_debug(DBG_INODE,
+			"i_ino %lu, i_size %llu, nr_dirty %u\n",
+			inode->i_ino, i_size_read(inode), nr_dirty);
+
 	atomic_add(nr_dirty, &nilfs->ns_ndirtyblks);
 
 	if (test_and_set_bit(NILFS_I_DIRTY, &ii->i_state))
@@ -940,6 +1054,10 @@ int nilfs_mark_inode_dirty(struct inode *inode)
 	struct buffer_head *ibh;
 	int err;
 
+	nilfs2_debug(DBG_INODE,
+			"i_ino %lu, i_size %llu\n",
+			inode->i_ino, i_size_read(inode));
+
 	err = nilfs_load_inode_block(inode, &ibh);
 	if (unlikely(err)) {
 		nilfs_warning(inode->i_sb, __func__,
@@ -968,6 +1086,10 @@ void nilfs_dirty_inode(struct inode *inode, int flags)
 	struct nilfs_transaction_info ti;
 	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
 
+	nilfs2_debug(DBG_INODE,
+			"i_ino %lu, i_size %llu, flags %#x\n",
+			inode->i_ino, i_size_read(inode), flags);
+
 	if (is_bad_inode(inode)) {
 		nilfs_warning(inode->i_sb, __func__,
 			      "tried to mark bad_inode dirty. ignored.\n");
@@ -996,6 +1118,10 @@ int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	unsigned int blkbits = inode->i_blkbits;
 	int ret, n;
 
+	nilfs2_debug(DBG_INODE,
+			"i_ino %lu, i_size %llu, start %llu, len %llu\n",
+			inode->i_ino, i_size_read(inode), start, len);
+
 	ret = fiemap_check_flags(fieinfo, FIEMAP_FLAG_SYNC);
 	if (ret)
 		return ret;
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index b44bdb2..21da0d6 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -51,6 +51,10 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 	int ret, i;
 	__u64 pos, ppos;
 
+	nilfs2_debug(DBG_IOCTL,
+			"nilfs %p, argv %p, dir %d, dofunc %p\n",
+			nilfs, argv, dir, dofunc);
+
 	if (argv->v_nmembs == 0)
 		return 0;
 
@@ -103,6 +107,9 @@ static int nilfs_ioctl_getflags(struct inode *inode, void __user *argp)
 {
 	unsigned int flags = NILFS_I(inode)->i_flags & FS_FL_USER_VISIBLE;
 
+	nilfs2_debug(DBG_IOCTL,
+			"i_ino %lu, argp %p\n", inode->i_ino, argp);
+
 	return put_user(flags, (int __user *)argp);
 }
 
@@ -113,6 +120,10 @@ static int nilfs_ioctl_setflags(struct inode *inode, struct file *filp,
 	unsigned int flags, oldflags;
 	int ret;
 
+	nilfs2_debug(DBG_IOCTL,
+			"i_ino %lu, filp %p, argp %p\n",
+			inode->i_ino, filp, argp);
+
 	if (!inode_owner_or_capable(inode))
 		return -EACCES;
 
@@ -160,6 +171,9 @@ out:
 
 static int nilfs_ioctl_getversion(struct inode *inode, void __user *argp)
 {
+	nilfs2_debug(DBG_IOCTL,
+			"i_ino %lu, argp %p\n", inode->i_ino, argp);
+
 	return put_user(inode->i_generation, (int __user *)argp);
 }
 
@@ -171,6 +185,10 @@ static int nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
 	struct nilfs_cpmode cpmode;
 	int ret;
 
+	nilfs2_debug(DBG_IOCTL,
+			"i_ino %lu, filp %p, cmd %#x, argp %p\n",
+			inode->i_ino, filp, cmd, argp);
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
@@ -207,6 +225,10 @@ nilfs_ioctl_delete_checkpoint(struct inode *inode, struct file *filp,
 	__u64 cno;
 	int ret;
 
+	nilfs2_debug(DBG_IOCTL,
+			"i_ino %lu, filp %p, cmd %#x, argp %p\n",
+			inode->i_ino, filp, cmd, argp);
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
@@ -235,6 +257,11 @@ nilfs_ioctl_do_get_cpinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 {
 	int ret;
 
+	nilfs2_debug(DBG_IOCTL,
+			"nilfs %p, posp %p, flags %#x, "
+			"buf %p, size %zu, nmembs %zu\n",
+			nilfs, posp, flags, buf, size, nmembs);
+
 	down_read(&nilfs->ns_segctor_sem);
 	ret = nilfs_cpfile_get_cpinfo(nilfs->ns_cpfile, posp, flags, buf,
 				      size, nmembs);
@@ -249,6 +276,10 @@ static int nilfs_ioctl_get_cpstat(struct inode *inode, struct file *filp,
 	struct nilfs_cpstat cpstat;
 	int ret;
 
+	nilfs2_debug(DBG_IOCTL,
+			"i_ino %lu, filp %p, cmd %#x, argp %p\n",
+			inode->i_ino, filp, cmd, argp);
+
 	down_read(&nilfs->ns_segctor_sem);
 	ret = nilfs_cpfile_get_stat(nilfs->ns_cpfile, &cpstat);
 	up_read(&nilfs->ns_segctor_sem);
@@ -266,6 +297,11 @@ nilfs_ioctl_do_get_suinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 {
 	int ret;
 
+	nilfs2_debug(DBG_IOCTL,
+			"nilfs %p, posp %p, flags %#x, "
+			"buf %p, size %zu, nmembs %zu\n",
+			nilfs, posp, flags, buf, size, nmembs);
+
 	down_read(&nilfs->ns_segctor_sem);
 	ret = nilfs_sufile_get_suinfo(nilfs->ns_sufile, *posp, buf, size,
 				      nmembs);
@@ -280,6 +316,10 @@ static int nilfs_ioctl_get_sustat(struct inode *inode, struct file *filp,
 	struct nilfs_sustat sustat;
 	int ret;
 
+	nilfs2_debug(DBG_IOCTL,
+			"i_ino %lu, filp %p, cmd %#x, argp %p\n",
+			inode->i_ino, filp, cmd, argp);
+
 	down_read(&nilfs->ns_segctor_sem);
 	ret = nilfs_sufile_get_stat(nilfs->ns_sufile, &sustat);
 	up_read(&nilfs->ns_segctor_sem);
@@ -297,6 +337,11 @@ nilfs_ioctl_do_get_vinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 {
 	int ret;
 
+	nilfs2_debug(DBG_IOCTL,
+			"nilfs %p, posp %p, flags %#x, "
+			"buf %p, size %zu, nmembs %zu\n",
+			nilfs, posp, flags, buf, size, nmembs);
+
 	down_read(&nilfs->ns_segctor_sem);
 	ret = nilfs_dat_get_vinfo(nilfs->ns_dat, buf, size, nmembs);
 	up_read(&nilfs->ns_segctor_sem);
@@ -311,6 +356,11 @@ nilfs_ioctl_do_get_bdescs(struct the_nilfs *nilfs, __u64 *posp, int flags,
 	struct nilfs_bdesc *bdescs = buf;
 	int ret, i;
 
+	nilfs2_debug(DBG_IOCTL,
+			"nilfs %p, posp %p, flags %#x, "
+			"buf %p, size %zu, nmembs %zu\n",
+			nilfs, posp, flags, buf, size, nmembs);
+
 	down_read(&nilfs->ns_segctor_sem);
 	for (i = 0; i < nmembs; i++) {
 		ret = nilfs_bmap_lookup_at_level(bmap,
@@ -336,6 +386,10 @@ static int nilfs_ioctl_get_bdescs(struct inode *inode, struct file *filp,
 	struct nilfs_argv argv;
 	int ret;
 
+	nilfs2_debug(DBG_IOCTL,
+			"i_ino %lu, filp %p, cmd %#x, argp %p\n",
+			inode->i_ino, filp, cmd, argp);
+
 	if (copy_from_user(&argv, argp, sizeof(argv)))
 		return -EFAULT;
 
@@ -359,6 +413,10 @@ static int nilfs_ioctl_move_inode_block(struct inode *inode,
 	struct buffer_head *bh;
 	int ret;
 
+	nilfs2_debug(DBG_IOCTL,
+			"i_ino %lu, vdesc %p, buffers %p\n",
+			inode->i_ino, vdesc, buffers);
+
 	if (vdesc->vd_flags == 0)
 		ret = nilfs_gccache_submit_read_data(
 			inode, vdesc->vd_offset, vdesc->vd_blocknr,
@@ -410,6 +468,9 @@ static int nilfs_ioctl_move_blocks(struct super_block *sb,
 	__u64 cno;
 	int i, ret;
 
+	nilfs2_debug(DBG_IOCTL,
+			"sb %p, argv %p, buf %p\n", sb, argv, buf);
+
 	for (i = 0, vdesc = buf; i < nmembs; ) {
 		ino = vdesc->vd_ino;
 		cno = vdesc->vd_cno;
@@ -470,6 +531,9 @@ static int nilfs_ioctl_delete_checkpoints(struct the_nilfs *nilfs,
 	struct nilfs_period *periods = buf;
 	int ret, i;
 
+	nilfs2_debug(DBG_IOCTL,
+			"nilfs %p, argv %p, buf %p\n", nilfs, argv, buf);
+
 	for (i = 0; i < nmembs; i++) {
 		ret = nilfs_cpfile_delete_checkpoints(
 			cpfile, periods[i].p_start, periods[i].p_end);
@@ -485,6 +549,9 @@ static int nilfs_ioctl_free_vblocknrs(struct the_nilfs *nilfs,
 	size_t nmembs = argv->v_nmembs;
 	int ret;
 
+	nilfs2_debug(DBG_IOCTL,
+			"nilfs %p, argv %p, buf %p\n", nilfs, argv, buf);
+
 	ret = nilfs_dat_freev(nilfs->ns_dat, buf, nmembs);
 
 	return (ret < 0) ? ret : nmembs;
@@ -498,6 +565,9 @@ static int nilfs_ioctl_mark_blocks_dirty(struct the_nilfs *nilfs,
 	struct nilfs_bdesc *bdescs = buf;
 	int ret, i;
 
+	nilfs2_debug(DBG_IOCTL,
+			"nilfs %p, argv %p, buf %p\n", nilfs, argv, buf);
+
 	for (i = 0; i < nmembs; i++) {
 		/* XXX: use macro or inline func to check liveness */
 		ret = nilfs_bmap_lookup_at_level(bmap,
@@ -537,6 +607,9 @@ int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
 	const char *msg;
 	int ret;
 
+	nilfs2_debug(DBG_IOCTL,
+			"nilfs %p, argv %p, kbufs %p\n", nilfs, argv, kbufs);
+
 	ret = nilfs_ioctl_delete_checkpoints(nilfs, &argv[1], kbufs[1]);
 	if (ret < 0) {
 		/*
@@ -588,6 +661,10 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 	size_t len, nsegs;
 	int n, ret;
 
+	nilfs2_debug(DBG_IOCTL,
+			"i_ino %lu, filp %p, cmd %#x, argp %p\n",
+			inode->i_ino, filp, cmd, argp);
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
@@ -689,6 +766,10 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
 	int ret;
 	struct the_nilfs *nilfs;
 
+	nilfs2_debug(DBG_IOCTL,
+			"i_ino %lu, filp %p, cmd %#x, argp %p\n",
+			inode->i_ino, filp, cmd, argp);
+
 	ret = nilfs_construct_segment(inode->i_sb);
 	if (ret < 0)
 		return ret;
@@ -716,6 +797,10 @@ static int nilfs_ioctl_resize(struct inode *inode, struct file *filp,
 	__u64 newsize;
 	int ret = -EPERM;
 
+	nilfs2_debug(DBG_IOCTL,
+			"i_ino %lu, filp %p, argp %p\n",
+			inode->i_ino, filp, argp);
+
 	if (!capable(CAP_SYS_ADMIN))
 		goto out;
 
@@ -743,6 +828,9 @@ static int nilfs_ioctl_set_alloc_range(struct inode *inode, void __user *argp)
 	unsigned long segbytes;
 	int ret = -EPERM;
 
+	nilfs2_debug(DBG_IOCTL,
+			"i_ino %lu, argp %p\n", inode->i_ino, argp);
+
 	if (!capable(CAP_SYS_ADMIN))
 		goto out;
 
@@ -779,6 +867,11 @@ static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
 	struct nilfs_argv argv;
 	int ret;
 
+	nilfs2_debug(DBG_IOCTL,
+			"i_ino %lu, filp %p, cmd %#x, argp %p, "
+			"membsz %zu, dofunc %p\n",
+			inode->i_ino, filp, cmd, argp, membsz, dofunc);
+
 	if (copy_from_user(&argv, argp, sizeof(argv)))
 		return -EFAULT;
 
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 9de78f0..7415ada 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -48,7 +48,12 @@
 
 static inline int nilfs_add_nondir(struct dentry *dentry, struct inode *inode)
 {
-	int err = nilfs_add_link(dentry, inode);
+	int err;
+
+	nilfs2_debug(DBG_NAMEI,
+			"i_ino %lu\n", inode->i_ino);
+
+	err = nilfs_add_link(dentry, inode);
 	if (!err) {
 		d_instantiate(dentry, inode);
 		return 0;
@@ -68,10 +73,14 @@ nilfs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 	struct inode *inode;
 	ino_t ino;
 
+	nilfs2_debug(DBG_NAMEI,
+			"dir->i_ino %lu, flags %#x\n", dir->i_ino, flags);
+
 	if (dentry->d_name.len > NILFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
 	ino = nilfs_inode_by_name(dir, &dentry->d_name);
+	nilfs2_debug(DBG_NAMEI, "inode ino %lu\n", ino);
 	inode = ino ? nilfs_iget(dir->i_sb, NILFS_I(dir)->i_root, ino) : NULL;
 	return d_splice_alias(inode, dentry);
 }
@@ -91,6 +100,10 @@ static int nilfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	struct nilfs_transaction_info ti;
 	int err;
 
+	nilfs2_debug(DBG_NAMEI,
+			"dir->i_ino %lu, mode %#x, excl %d\n",
+			dir->i_ino, mode, excl);
+
 	err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
 	if (err)
 		return err;
@@ -118,6 +131,10 @@ nilfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t rdev)
 	struct nilfs_transaction_info ti;
 	int err;
 
+	nilfs2_debug(DBG_NAMEI,
+			"dir->i_ino %lu, mode %#x, rdev %#x\n",
+			dir->i_ino, mode, rdev);
+
 	if (!new_valid_dev(rdev))
 		return -EINVAL;
 
@@ -148,6 +165,9 @@ static int nilfs_symlink(struct inode *dir, struct dentry *dentry,
 	struct inode *inode;
 	int err;
 
+	nilfs2_debug(DBG_NAMEI,
+			"dir->i_ino %lu\n", dir->i_ino);
+
 	if (l > sb->s_blocksize)
 		return -ENAMETOOLONG;
 
@@ -193,6 +213,10 @@ static int nilfs_link(struct dentry *old_dentry, struct inode *dir,
 	struct nilfs_transaction_info ti;
 	int err;
 
+	nilfs2_debug(DBG_NAMEI,
+			"dir->i_ino %lu, inode->i_ino %lu\n",
+			dir->i_ino, inode->i_ino);
+
 	err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
 	if (err)
 		return err;
@@ -216,6 +240,10 @@ static int nilfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	struct nilfs_transaction_info ti;
 	int err;
 
+	nilfs2_debug(DBG_NAMEI,
+			"dir->i_ino %lu, mode %#x\n",
+			dir->i_ino, mode);
+
 	err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
 	if (err)
 		return err;
@@ -269,6 +297,9 @@ static int nilfs_do_unlink(struct inode *dir, struct dentry *dentry)
 	struct page *page;
 	int err;
 
+	nilfs2_debug(DBG_NAMEI,
+			"dir->i_ino %lu\n", dir->i_ino);
+
 	err = -ENOENT;
 	de = nilfs_find_entry(dir, &dentry->d_name, &page);
 	if (!de)
@@ -301,6 +332,9 @@ static int nilfs_unlink(struct inode *dir, struct dentry *dentry)
 	struct nilfs_transaction_info ti;
 	int err;
 
+	nilfs2_debug(DBG_NAMEI,
+			"dir->i_ino %lu\n", dir->i_ino);
+
 	err = nilfs_transaction_begin(dir->i_sb, &ti, 0);
 	if (err)
 		return err;
@@ -323,6 +357,10 @@ static int nilfs_rmdir(struct inode *dir, struct dentry *dentry)
 	struct nilfs_transaction_info ti;
 	int err;
 
+	nilfs2_debug(DBG_NAMEI,
+			"dir->i_ino %lu\n",
+			dir->i_ino);
+
 	err = nilfs_transaction_begin(dir->i_sb, &ti, 0);
 	if (err)
 		return err;
@@ -358,6 +396,10 @@ static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct nilfs_transaction_info ti;
 	int err;
 
+	nilfs2_debug(DBG_NAMEI,
+			"old_dir->i_ino %lu, new_dir->i_ino %lu\n",
+			old_dir->i_ino, new_dir->i_ino);
+
 	err = nilfs_transaction_begin(old_dir->i_sb, &ti, 1);
 	if (unlikely(err))
 		return err;
@@ -444,6 +486,9 @@ static struct dentry *nilfs_get_parent(struct dentry *child)
 	struct qstr dotdot = QSTR_INIT("..", 2);
 	struct nilfs_root *root;
 
+	nilfs2_debug(DBG_NAMEI,
+			"child inode ino %lu\n", child->d_inode->i_ino);
+
 	ino = nilfs_inode_by_name(child->d_inode, &dotdot);
 	if (!ino)
 		return ERR_PTR(-ENOENT);
@@ -463,6 +508,10 @@ static struct dentry *nilfs_get_dentry(struct super_block *sb, u64 cno,
 	struct nilfs_root *root;
 	struct inode *inode;
 
+	nilfs2_debug(DBG_NAMEI,
+			"cno %llu, ino %llu, gen %u\n",
+			cno, ino, gen);
+
 	if (ino < NILFS_FIRST_INO(sb) && ino != NILFS_ROOT_INO)
 		return ERR_PTR(-ESTALE);
 
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 9bc72de..8c36dd6 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -29,6 +29,7 @@
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
 #include <linux/nilfs2_fs.h>
+#include "debug.h"
 #include "the_nilfs.h"
 #include "bmap.h"
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index c7d1f9f..303fec6 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -192,6 +192,9 @@ static int nilfs_sync_super(struct super_block *sb, int flag)
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	int err;
 
+	nilfs2_debug(DBG_SUPER,
+			"sb %p, flag %#x\n", sb, flag);
+
  retry:
 	set_buffer_dirty(nilfs->ns_sbh[0]);
 	if (nilfs_test_opt(nilfs, BARRIER)) {
@@ -259,6 +262,14 @@ void nilfs_set_log_cursor(struct nilfs_super_block *sbp,
 	sbp->s_last_pseg = cpu_to_le64(nilfs->ns_last_pseg);
 	sbp->s_last_cno = cpu_to_le64(nilfs->ns_last_cno);
 	spin_unlock(&nilfs->ns_last_segment_lock);
+
+	nilfs2_debug(DBG_SUPER,
+			"free_blocks %llu, last_seq %llu, "
+			"last_pseg %llu, last_cno %llu\n",
+			sbp->s_free_blocks_count,
+			sbp->s_last_seq,
+			sbp->s_last_pseg,
+			sbp->s_last_cno);
 }
 
 struct nilfs_super_block **nilfs_prepare_super(struct super_block *sb,
@@ -267,6 +278,9 @@ struct nilfs_super_block **nilfs_prepare_super(struct super_block *sb,
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
 
+	nilfs2_debug(DBG_SUPER,
+			"sb %p, flip %d\n", sb, flip);
+
 	/* nilfs->ns_sem must be locked by the caller. */
 	if (sbp[0]->s_magic != cpu_to_le16(NILFS_SUPER_MAGIC)) {
 		if (sbp[1] &&
@@ -294,6 +308,9 @@ int nilfs_commit_super(struct super_block *sb, int flag)
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
 	time_t t;
 
+	nilfs2_debug(DBG_SUPER,
+			"sb %p, flag %#x\n", sb, flag);
+
 	/* nilfs->ns_sem must be locked by the caller. */
 	t = get_seconds();
 	nilfs->ns_sbwtime = t;
@@ -328,6 +345,8 @@ int nilfs_cleanup_super(struct super_block *sb)
 	int flag = NILFS_SB_COMMIT;
 	int ret = -EIO;
 
+	nilfs2_debug(DBG_SUPER, "sb %p\n", sb);
+
 	sbp = nilfs_prepare_super(sb, 0);
 	if (sbp) {
 		sbp[0]->s_state = cpu_to_le16(nilfs->ns_mount_state);
@@ -361,6 +380,9 @@ static int nilfs_move_2nd_super(struct super_block *sb, loff_t sb2off)
 	int sb2i = -1;  /* array index of the secondary superblock */
 	int ret = 0;
 
+	nilfs2_debug(DBG_SUPER,
+			"sb %p, sb2off %llu\n", sb, sb2off);
+
 	/* nilfs->ns_sem must be locked by the caller. */
 	if (nilfs->ns_sbh[1] &&
 	    nilfs->ns_sbh[1]->b_blocknr > nilfs->ns_first_data_block) {
@@ -416,6 +438,9 @@ int nilfs_resize_fs(struct super_block *sb, __u64 newsize)
 	loff_t sb2off;
 	int ret;
 
+	nilfs2_debug(DBG_SUPER,
+			"sb %p, newsize %llu\n", sb, newsize);
+
 	ret = -ERANGE;
 	devsize = i_size_read(sb->s_bdev->bd_inode);
 	if (newsize > devsize)
@@ -478,6 +503,8 @@ static void nilfs_put_super(struct super_block *sb)
 {
 	struct the_nilfs *nilfs = sb->s_fs_info;
 
+	nilfs2_debug(DBG_SUPER, "sb %p\n", sb);
+
 	nilfs_detach_log_writer(sb);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
@@ -500,6 +527,8 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
 	struct nilfs_super_block **sbp;
 	int err = 0;
 
+	nilfs2_debug(DBG_SUPER, "sb %p, wait %d\n", sb, wait);
+
 	/* This function is called when super block should be written back */
 	if (wait)
 		err = nilfs_construct_segment(sb);
@@ -526,6 +555,10 @@ int nilfs_attach_checkpoint(struct super_block *sb, __u64 cno, int curr_mnt,
 	struct buffer_head *bh_cp;
 	int err = -ENOMEM;
 
+	nilfs2_debug(DBG_SUPER,
+			"sb %p, cno %llu, curr_mnt %d, rootp %p\n",
+			sb, cno, curr_mnt, rootp);
+
 	root = nilfs_find_or_create_root(
 		nilfs, curr_mnt ? NILFS_CPTREE_CURRENT_CNO : cno);
 	if (!root)
@@ -579,6 +612,8 @@ static int nilfs_freeze(struct super_block *sb)
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
+	nilfs2_debug(DBG_SUPER, "sb %p\n", sb);
+
 	/* Mark super block clean */
 	down_write(&nilfs->ns_sem);
 	err = nilfs_cleanup_super(sb);
@@ -593,6 +628,8 @@ static int nilfs_unfreeze(struct super_block *sb)
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
+	nilfs2_debug(DBG_SUPER, "sb %p\n", sb);
+
 	down_write(&nilfs->ns_sem);
 	nilfs_setup_super(sb, false);
 	up_write(&nilfs->ns_sem);
@@ -611,6 +648,9 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	sector_t nfreeblocks;
 	int err;
 
+	nilfs2_debug(DBG_SUPER,
+			"dentry %p, buf %p\n", dentry, buf);
+
 	/*
 	 * Compute all of the segment blocks
 	 *
@@ -654,6 +694,9 @@ static int nilfs_show_options(struct seq_file *seq, struct dentry *dentry)
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_root *root = NILFS_I(dentry->d_inode)->i_root;
 
+	nilfs2_debug(DBG_SUPER,
+			"seq %p, dentry %p\n", seq, dentry);
+
 	if (!nilfs_test_opt(nilfs, BARRIER))
 		seq_puts(seq, ",nobarrier");
 	if (root->cno != NILFS_CPTREE_CURRENT_CNO)
@@ -712,6 +755,10 @@ static int parse_options(char *options, struct super_block *sb, int is_remount)
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
 
+	nilfs2_debug(DBG_SUPER,
+			"options %p, sb %p, is_remount %d\n",
+			options, sb, is_remount);
+
 	if (!options)
 		return 1;
 
@@ -790,6 +837,9 @@ static int nilfs_setup_super(struct super_block *sb, int is_mount)
 	int max_mnt_count;
 	int mnt_count;
 
+	nilfs2_debug(DBG_SUPER,
+			"sb %p, is_mount %d\n", sb, is_mount);
+
 	/* nilfs->ns_sem must be locked by the caller. */
 	sbp = nilfs_prepare_super(sb, 0);
 	if (!sbp)
@@ -832,6 +882,10 @@ struct nilfs_super_block *nilfs_read_super_block(struct super_block *sb,
 	unsigned long long sb_index = pos;
 	unsigned long offset;
 
+	nilfs2_debug(DBG_SUPER,
+			"sb %p, pos %llu, blocksize %d, pbh %p\n",
+			sb, pos, blocksize, pbh);
+
 	offset = do_div(sb_index, blocksize);
 	*pbh = sb_bread(sb, sb_index);
 	if (!*pbh)
@@ -847,6 +901,10 @@ int nilfs_store_magic_and_option(struct super_block *sb,
 
 	sb->s_magic = le16_to_cpu(sbp->s_magic);
 
+	nilfs2_debug(DBG_SUPER,
+			"sb %p, sbp %p, data %p, magic %#lx\n",
+			sb, sbp, data, sb->s_magic);
+
 	/* FS independent flags */
 #ifdef NILFS_ATIME_DISABLE
 	sb->s_flags |= MS_NOATIME;
@@ -869,6 +927,8 @@ int nilfs_check_feature_compatibility(struct super_block *sb,
 
 	features = le64_to_cpu(sbp->s_feature_incompat) &
 		~NILFS_FEATURE_INCOMPAT_SUPP;
+	nilfs2_debug(DBG_SUPER,
+			"incompat features %#llx\n", features);
 	if (features) {
 		printk(KERN_ERR "NILFS: couldn't mount because of unsupported "
 		       "optional features (%llx)\n",
@@ -877,6 +937,8 @@ int nilfs_check_feature_compatibility(struct super_block *sb,
 	}
 	features = le64_to_cpu(sbp->s_feature_compat_ro) &
 		~NILFS_FEATURE_COMPAT_RO_SUPP;
+	nilfs2_debug(DBG_SUPER,
+			"compat RO features %#llx\n", features);
 	if (!(sb->s_flags & MS_RDONLY) && features) {
 		printk(KERN_ERR "NILFS: couldn't mount RDWR because of "
 		       "unsupported optional features (%llx)\n",
@@ -894,6 +956,10 @@ static int nilfs_get_root_dentry(struct super_block *sb,
 	struct dentry *dentry;
 	int ret = 0;
 
+	nilfs2_debug(DBG_SUPER,
+			"sb %p, root %p, root_dentry %p\n",
+			sb, root, root_dentry);
+
 	inode = nilfs_iget(sb, root, NILFS_ROOT_INO);
 	if (IS_ERR(inode)) {
 		printk(KERN_ERR "NILFS: get root inode failed\n");
@@ -941,6 +1007,10 @@ static int nilfs_attach_snapshot(struct super_block *s, __u64 cno,
 	struct nilfs_root *root;
 	int ret;
 
+	nilfs2_debug(DBG_SUPER,
+			"sb %p, cno %llu, root_dentry %p\n",
+			s, cno, root_dentry);
+
 	mutex_lock(&nilfs->ns_snapshot_mount_mutex);
 
 	down_read(&nilfs->ns_segctor_sem);
@@ -998,6 +1068,9 @@ int nilfs_checkpoint_is_mounted(struct super_block *sb, __u64 cno)
 	struct dentry *dentry;
 	int ret;
 
+	nilfs2_debug(DBG_SUPER,
+			"sb %p, cno %llu\n", sb, cno);
+
 	if (cno < 0 || cno > nilfs->ns_cno)
 		return false;
 
@@ -1040,6 +1113,9 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 	__u64 cno;
 	int err;
 
+	nilfs2_debug(DBG_SUPER,
+			"sb %p, data %p, silent %d\n", sb, data, silent);
+
 	nilfs = alloc_nilfs(sb->s_bdev);
 	if (!nilfs)
 		return -ENOMEM;
@@ -1114,6 +1190,9 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	unsigned long old_mount_opt;
 	int err;
 
+	nilfs2_debug(DBG_SUPER,
+			"sb %p, flags %#x, data %p\n", sb, *flags, data);
+
 	old_sb_flags = sb->s_flags;
 	old_mount_opt = nilfs->ns_mount_opt;
 
@@ -1206,6 +1285,10 @@ static int nilfs_identify(char *data, struct nilfs_super_data *sd)
 	int token;
 	int ret = 0;
 
+	nilfs2_debug(DBG_SUPER,
+			"data %p, cno %llu, flags %#x\n",
+			data, sd->cno, sd->flags);
+
 	do {
 		p = strsep(&options, ",");
 		if (p != NULL && *p) {
@@ -1259,6 +1342,10 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 	struct dentry *root_dentry;
 	int err, s_new = false;
 
+	nilfs2_debug(DBG_SUPER,
+			"fs_type %p, flags %#x, dev_name %p, data %p\n",
+			fs_type, flags, dev_name, data);
+
 	if (!(flags & MS_RDONLY))
 		mode |= FMODE_WRITE;
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 41e6a04..f3e65dd 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -41,6 +41,10 @@ static int nilfs_valid_sb(struct nilfs_super_block *sbp);
 void nilfs_set_last_segment(struct the_nilfs *nilfs,
 			    sector_t start_blocknr, u64 seq, __u64 cno)
 {
+	nilfs2_debug(DBG_THE_NILFS,
+			"nilfs %p, start_blocknr %lu, seq %llu, cno %llu\n",
+			nilfs, start_blocknr, seq, cno);
+
 	spin_lock(&nilfs->ns_last_segment_lock);
 	nilfs->ns_last_pseg = start_blocknr;
 	nilfs->ns_last_seq = seq;
@@ -69,6 +73,8 @@ struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 {
 	struct the_nilfs *nilfs;
 
+	nilfs2_debug(DBG_THE_NILFS, "bdev %p\n", bdev);
+
 	nilfs = kzalloc(sizeof(*nilfs), GFP_KERNEL);
 	if (!nilfs)
 		return NULL;
@@ -95,6 +101,8 @@ struct the_nilfs *alloc_nilfs(struct block_device *bdev)
  */
 void destroy_nilfs(struct the_nilfs *nilfs)
 {
+	nilfs2_debug(DBG_THE_NILFS, "nilfs %p\n", nilfs);
+
 	might_sleep();
 	if (nilfs_init(nilfs)) {
 		brelse(nilfs->ns_sbh[0]);
@@ -114,6 +122,10 @@ static int nilfs_load_super_root(struct the_nilfs *nilfs,
 	unsigned inode_size;
 	int err;
 
+	nilfs2_debug(DBG_THE_NILFS,
+			"nilfs %p, sb %p, sr_block %lu\n",
+			nilfs, sb, sr_block);
+
 	err = nilfs_read_super_root_block(nilfs, sr_block, &bh_sr, 1);
 	if (unlikely(err))
 		return err;
@@ -187,6 +199,12 @@ static int nilfs_store_log_cursor(struct the_nilfs *nilfs,
 	nilfs->ns_last_cno = le64_to_cpu(sbp->s_last_cno);
 	nilfs->ns_last_seq = le64_to_cpu(sbp->s_last_seq);
 
+	nilfs2_debug(DBG_THE_NILFS,
+			"last_pseg %lu, last_cno %llu, last_seq %llu\n",
+			nilfs->ns_last_pseg,
+			nilfs->ns_last_cno,
+			nilfs->ns_last_seq);
+
 	nilfs->ns_prev_seq = nilfs->ns_last_seq;
 	nilfs->ns_seg_seq = nilfs->ns_last_seq;
 	nilfs->ns_segnum =
@@ -216,6 +234,10 @@ int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 	int valid_fs = nilfs_valid_fs(nilfs);
 	int err;
 
+	nilfs2_debug(DBG_THE_NILFS,
+			"nilfs %p, sb %p, s_flags %#x, RO %d, valid_fs %d\n",
+			nilfs, sb, s_flags, really_read_only, valid_fs);
+
 	if (!valid_fs) {
 		printk(KERN_WARNING "NILFS warning: mounting unchecked fs\n");
 		if (s_flags & MS_RDONLY) {
@@ -490,6 +512,10 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
 	u64 sb2off = NILFS_SB2_OFFSET_BYTES(nilfs->ns_bdev->bd_inode->i_size);
 	int valid[2], swp = 0;
 
+	nilfs2_debug(DBG_THE_NILFS,
+			"nilfs %p, sb %p, blocksize %d, sbpp %p\n",
+			nilfs, sb, blocksize, sbpp);
+
 	sbp[0] = nilfs_read_super_block(sb, NILFS_SB_OFFSET_BYTES, blocksize,
 					&sbh[0]);
 	sbp[1] = nilfs_read_super_block(sb, sb2off, blocksize, &sbh[1]);
@@ -564,6 +590,9 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 	int blocksize;
 	int err;
 
+	nilfs2_debug(DBG_THE_NILFS,
+			"nilfs %p, sb %p, data %p\n", nilfs, sb, data);
+
 	down_write(&nilfs->ns_sem);
 
 	blocksize = sb_min_blocksize(sb, NILFS_MIN_BLOCK_SIZE);
@@ -650,6 +679,10 @@ int nilfs_discard_segments(struct the_nilfs *nilfs, __u64 *segnump,
 	__u64 *sn;
 	int ret = 0;
 
+	nilfs2_debug(DBG_THE_NILFS,
+			"nilfs %p, segnump %p, nsegs %zu\n",
+			nilfs, segnump, nsegs);
+
 	sects_per_block = (1 << nilfs->ns_blocksize_bits) /
 		bdev_logical_block_size(nilfs->ns_bdev);
 	for (sn = segnump; sn < segnump + nsegs; sn++) {
@@ -705,6 +738,9 @@ struct nilfs_root *nilfs_lookup_root(struct the_nilfs *nilfs, __u64 cno)
 	struct rb_node *n;
 	struct nilfs_root *root;
 
+	nilfs2_debug(DBG_THE_NILFS,
+			"nilfs %p, cno %llu\n", nilfs, cno);
+
 	spin_lock(&nilfs->ns_cptree_lock);
 	n = nilfs->ns_cptree.rb_node;
 	while (n) {
@@ -731,6 +767,9 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
 	struct rb_node **p, *parent;
 	struct nilfs_root *root, *new;
 
+	nilfs2_debug(DBG_THE_NILFS,
+			"nilfs %p, cno %llu\n", nilfs, cno);
+
 	root = nilfs_lookup_root(nilfs, cno);
 	if (root)
 		return root;
@@ -780,6 +819,9 @@ void nilfs_put_root(struct nilfs_root *root)
 	if (atomic_dec_and_test(&root->count)) {
 		struct the_nilfs *nilfs = root->nilfs;
 
+		nilfs2_debug(DBG_THE_NILFS,
+				"cno %llu\n", root->cno);
+
 		spin_lock(&nilfs->ns_cptree_lock);
 		rb_erase(&root->rb_node, &nilfs->ns_cptree);
 		spin_unlock(&nilfs->ns_cptree_lock);
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
