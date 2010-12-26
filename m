From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 6/6] nilfs2: unfold nilfs_dat_inode function
Date: Mon, 27 Dec 2010 01:02:42 +0900
Message-ID: <1293379362-3340-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1293379362-3340-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293379362-3340-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_dat_inode function was a wrapper to switch between normal dat
inode and gcdat, a clone of the dat inode for garbage collection.

This function got obsolete when the gcdat inode was removed, and now
we can access the dat inode directly from a nilfs object.  So, we will
unfold the wrapper and remove it.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.c      |    2 +-
 fs/nilfs2/btnode.c    |    3 +--
 fs/nilfs2/inode.c     |   11 +++++------
 fs/nilfs2/ioctl.c     |   12 +++++-------
 fs/nilfs2/nilfs.h     |    5 -----
 fs/nilfs2/segment.c   |   11 +++++------
 fs/nilfs2/the_nilfs.c |    5 ++---
 7 files changed, 19 insertions(+), 30 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index 4b7aeb3..3ee67c6 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -35,7 +35,7 @@
 
 struct inode *nilfs_bmap_get_dat(const struct nilfs_bmap *bmap)
 {
-	return nilfs_dat_inode(NILFS_I_NILFS(bmap->b_inode));
+	return NILFS_I_NILFS(bmap->b_inode)->ns_dat;
 }
 
 static int nilfs_bmap_convert_error(struct nilfs_bmap *bmap,
diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 5115814..388e9e8 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -104,8 +104,7 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 	if (pblocknr == 0) {
 		pblocknr = blocknr;
 		if (inode->i_ino != NILFS_DAT_INO) {
-			struct inode *dat =
-				nilfs_dat_inode(NILFS_I_NILFS(inode));
+			struct inode *dat = NILFS_I_NILFS(inode)->ns_dat;
 
 			/* blocknr is a virtual block number */
 			err = nilfs_dat_translate(dat, blocknr, &pblocknr);
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index de38843..3becc12 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -58,7 +58,7 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 	__u64 blknum = 0;
 	int err = 0, ret;
-	struct inode *dat = nilfs_dat_inode(NILFS_I_NILFS(inode));
+	struct inode *dat = NILFS_I_NILFS(inode)->ns_dat;
 	unsigned maxblocks = bh_result->b_size >> inode->i_blkbits;
 
 	down_read(&NILFS_MDT(dat)->mi_sem);
@@ -420,13 +420,12 @@ static int __nilfs_read_inode(struct super_block *sb,
 			      struct nilfs_root *root, unsigned long ino,
 			      struct inode *inode)
 {
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
-	struct inode *dat = nilfs_dat_inode(sbi->s_nilfs);
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
 	struct buffer_head *bh;
 	struct nilfs_inode *raw_inode;
 	int err;
 
-	down_read(&NILFS_MDT(dat)->mi_sem);	/* XXX */
+	down_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	err = nilfs_ifile_get_inode_block(root->ifile, ino, &bh);
 	if (unlikely(err))
 		goto bad_inode;
@@ -456,7 +455,7 @@ static int __nilfs_read_inode(struct super_block *sb,
 	}
 	nilfs_ifile_unmap_inode(root->ifile, ino, bh);
 	brelse(bh);
-	up_read(&NILFS_MDT(dat)->mi_sem);	/* XXX */
+	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	nilfs_set_inode_flags(inode);
 	return 0;
 
@@ -465,7 +464,7 @@ static int __nilfs_read_inode(struct super_block *sb,
 	brelse(bh);
 
  bad_inode:
-	up_read(&NILFS_MDT(dat)->mi_sem);	/* XXX */
+	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	return err;
 }
 
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index b185e93..4967389 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -233,7 +233,7 @@ nilfs_ioctl_do_get_vinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 	int ret;
 
 	down_read(&nilfs->ns_segctor_sem);
-	ret = nilfs_dat_get_vinfo(nilfs_dat_inode(nilfs), buf, size, nmembs);
+	ret = nilfs_dat_get_vinfo(nilfs->ns_dat, buf, size, nmembs);
 	up_read(&nilfs->ns_segctor_sem);
 	return ret;
 }
@@ -242,8 +242,7 @@ static ssize_t
 nilfs_ioctl_do_get_bdescs(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			  void *buf, size_t size, size_t nmembs)
 {
-	struct inode *dat = nilfs_dat_inode(nilfs);
-	struct nilfs_bmap *bmap = NILFS_I(dat)->i_bmap;
+	struct nilfs_bmap *bmap = NILFS_I(nilfs->ns_dat)->i_bmap;
 	struct nilfs_bdesc *bdescs = buf;
 	int ret, i;
 
@@ -421,7 +420,7 @@ static int nilfs_ioctl_free_vblocknrs(struct the_nilfs *nilfs,
 	size_t nmembs = argv->v_nmembs;
 	int ret;
 
-	ret = nilfs_dat_freev(nilfs_dat_inode(nilfs), buf, nmembs);
+	ret = nilfs_dat_freev(nilfs->ns_dat, buf, nmembs);
 
 	return (ret < 0) ? ret : nmembs;
 }
@@ -430,8 +429,7 @@ static int nilfs_ioctl_mark_blocks_dirty(struct the_nilfs *nilfs,
 					 struct nilfs_argv *argv, void *buf)
 {
 	size_t nmembs = argv->v_nmembs;
-	struct inode *dat = nilfs_dat_inode(nilfs);
-	struct nilfs_bmap *bmap = NILFS_I(dat)->i_bmap;
+	struct nilfs_bmap *bmap = NILFS_I(nilfs->ns_dat)->i_bmap;
 	struct nilfs_bdesc *bdescs = buf;
 	int ret, i;
 
@@ -450,7 +448,7 @@ static int nilfs_ioctl_mark_blocks_dirty(struct the_nilfs *nilfs,
 			/* skip dead block */
 			continue;
 		if (bdescs[i].bd_level == 0) {
-			ret = nilfs_mdt_mark_block_dirty(dat,
+			ret = nilfs_mdt_mark_block_dirty(nilfs->ns_dat,
 							 bdescs[i].bd_offset);
 			if (ret < 0) {
 				WARN_ON(ret == -ENOENT);
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 80b867f..04ba110 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -190,11 +190,6 @@ static inline int nilfs_doing_construction(void)
 	return nilfs_test_transaction_flag(NILFS_TI_WRITER);
 }
 
-static inline struct inode *nilfs_dat_inode(const struct the_nilfs *nilfs)
-{
-	return nilfs->ns_dat;
-}
-
 /*
  * function prototype
  */
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index efc7d0a..55ebae5 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -757,9 +757,8 @@ static int nilfs_test_metadata_dirty(struct the_nilfs *nilfs,
 		ret++;
 	if (nilfs_mdt_fetch_dirty(nilfs->ns_sufile))
 		ret++;
-	if (ret || nilfs_doing_gc())
-		if (nilfs_mdt_fetch_dirty(nilfs_dat_inode(nilfs)))
-			ret++;
+	if ((ret || nilfs_doing_gc()) && nilfs_mdt_fetch_dirty(nilfs->ns_dat))
+		ret++;
 	return ret;
 }
 
@@ -795,7 +794,7 @@ static void nilfs_segctor_clear_metadata_dirty(struct nilfs_sc_info *sci)
 	nilfs_mdt_clear_dirty(sci->sc_root->ifile);
 	nilfs_mdt_clear_dirty(nilfs->ns_cpfile);
 	nilfs_mdt_clear_dirty(nilfs->ns_sufile);
-	nilfs_mdt_clear_dirty(nilfs_dat_inode(nilfs));
+	nilfs_mdt_clear_dirty(nilfs->ns_dat);
 }
 
 static int nilfs_segctor_create_checkpoint(struct nilfs_sc_info *sci)
@@ -904,7 +903,7 @@ static void nilfs_segctor_fill_in_super_root(struct nilfs_sc_info *sci,
 			      nilfs->ns_nongc_ctime : sci->sc_seg_ctime);
 	raw_sr->sr_flags = 0;
 
-	nilfs_write_inode_common(nilfs_dat_inode(nilfs), (void *)raw_sr +
+	nilfs_write_inode_common(nilfs->ns_dat, (void *)raw_sr +
 				 NILFS_SR_DAT_OFFSET(isz), 1);
 	nilfs_write_inode_common(nilfs->ns_cpfile, (void *)raw_sr +
 				 NILFS_SR_CPFILE_OFFSET(isz), 1);
@@ -1160,7 +1159,7 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
 		sci->sc_stage.scnt++;  /* Fall through */
 	case NILFS_ST_DAT:
  dat_stage:
-		err = nilfs_segctor_scan_file(sci, nilfs_dat_inode(nilfs),
+		err = nilfs_segctor_scan_file(sci, nilfs->ns_dat,
 					      &nilfs_sc_dat_ops);
 		if (unlikely(err))
 			break;
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 95e4443..ad4ac60 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -650,12 +650,11 @@ int nilfs_discard_segments(struct the_nilfs *nilfs, __u64 *segnump,
 
 int nilfs_count_free_blocks(struct the_nilfs *nilfs, sector_t *nblocks)
 {
-	struct inode *dat = nilfs_dat_inode(nilfs);
 	unsigned long ncleansegs;
 
-	down_read(&NILFS_MDT(dat)->mi_sem);	/* XXX */
+	down_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	ncleansegs = nilfs_sufile_get_ncleansegs(nilfs->ns_sufile);
-	up_read(&NILFS_MDT(dat)->mi_sem);	/* XXX */
+	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	*nblocks = (sector_t)ncleansegs * nilfs->ns_blocks_per_segment;
 	return 0;
 }
-- 
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
