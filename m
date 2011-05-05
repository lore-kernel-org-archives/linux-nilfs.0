From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/5] nilfs2: get rid of NILFS_I_NILFS
Date: Thu,  5 May 2011 13:13:51 +0900
Message-ID: <1304568833-31021-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This replaces all references of NILFS_I_NILFS(inode)->ns_bdev with
inode->i_sb->s_bdev and unfolds remaining uses of NILFS_I_NILFS inline
function.

Before 2.6.37, referring to a nilfs object from inodes needed a
conditional judgement, and NILFS_I_NILFS was helpful to simplify it.
But now we can simply do it by going through a super block instance
like inode->i_sb->s_fs_info.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.c    |    4 +++-
 fs/nilfs2/btnode.c  |    9 +++++----
 fs/nilfs2/gcinode.c |    8 ++++----
 fs/nilfs2/inode.c   |    8 ++++----
 fs/nilfs2/mdt.h     |    7 +------
 fs/nilfs2/sufile.c  |    4 ++--
 fs/nilfs2/sufile.h  |    2 +-
 7 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index 4723f04..aadbd0b 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -34,7 +34,9 @@
 
 struct inode *nilfs_bmap_get_dat(const struct nilfs_bmap *bmap)
 {
-	return NILFS_I_NILFS(bmap->b_inode)->ns_dat;
+	struct the_nilfs *nilfs = bmap->b_inode->i_sb->s_fs_info;
+
+	return nilfs->ns_dat;
 }
 
 static int nilfs_bmap_convert_error(struct nilfs_bmap *bmap,
diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 609cd22..4817560 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -62,7 +62,7 @@ nilfs_btnode_create_block(struct address_space *btnc, __u64 blocknr)
 		BUG();
 	}
 	memset(bh->b_data, 0, 1 << inode->i_blkbits);
-	bh->b_bdev = NILFS_I_NILFS(inode)->ns_bdev;
+	bh->b_bdev = inode->i_sb->s_bdev;
 	bh->b_blocknr = blocknr;
 	set_buffer_mapped(bh);
 	set_buffer_uptodate(bh);
@@ -94,10 +94,11 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 	if (pblocknr == 0) {
 		pblocknr = blocknr;
 		if (inode->i_ino != NILFS_DAT_INO) {
-			struct inode *dat = NILFS_I_NILFS(inode)->ns_dat;
+			struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 
 			/* blocknr is a virtual block number */
-			err = nilfs_dat_translate(dat, blocknr, &pblocknr);
+			err = nilfs_dat_translate(nilfs->ns_dat, blocknr,
+						  &pblocknr);
 			if (unlikely(err)) {
 				brelse(bh);
 				goto out_locked;
@@ -120,7 +121,7 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 		goto found;
 	}
 	set_buffer_mapped(bh);
-	bh->b_bdev = NILFS_I_NILFS(inode)->ns_bdev;
+	bh->b_bdev = inode->i_sb->s_bdev;
 	bh->b_blocknr = pblocknr; /* set block address for read */
 	bh->b_end_io = end_buffer_read_sync;
 	get_bh(bh);
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 6f0d60a..6e79ac0 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -84,9 +84,9 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
 		goto out;
 
 	if (pbn == 0) {
-		struct inode *dat_inode = NILFS_I_NILFS(inode)->ns_dat;
-					  /* use original dat, not gc dat. */
-		err = nilfs_dat_translate(dat_inode, vbn, &pbn);
+		struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+
+		err = nilfs_dat_translate(nilfs->ns_dat, vbn, &pbn);
 		if (unlikely(err)) { /* -EIO, -ENOMEM, -ENOENT */
 			brelse(bh);
 			goto failed;
@@ -100,7 +100,7 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
 	}
 
 	if (!buffer_mapped(bh)) {
-		bh->b_bdev = NILFS_I_NILFS(inode)->ns_bdev;
+		bh->b_bdev = inode->i_sb->s_bdev;
 		set_buffer_mapped(bh);
 	}
 	bh->b_blocknr = pbn;
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 699170e..34ded2c 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -74,14 +74,14 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
 		    struct buffer_head *bh_result, int create)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 	__u64 blknum = 0;
 	int err = 0, ret;
-	struct inode *dat = NILFS_I_NILFS(inode)->ns_dat;
 	unsigned maxblocks = bh_result->b_size >> inode->i_blkbits;
 
-	down_read(&NILFS_MDT(dat)->mi_sem);
+	down_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	ret = nilfs_bmap_lookup_contig(ii->i_bmap, blkoff, &blknum, maxblocks);
-	up_read(&NILFS_MDT(dat)->mi_sem);
+	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	if (ret >= 0) {	/* found */
 		map_bh(bh_result, inode->i_sb, blknum);
 		if (ret > 0)
@@ -940,7 +940,7 @@ void nilfs_dirty_inode(struct inode *inode)
 int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		 __u64 start, __u64 len)
 {
-	struct the_nilfs *nilfs = NILFS_I_NILFS(inode);
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 	__u64 logical = 0, phys = 0, size = 0;
 	__u32 flags = 0;
 	loff_t isize;
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index ed68563..baea036 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -64,11 +64,6 @@ static inline struct nilfs_mdt_info *NILFS_MDT(const struct inode *inode)
 	return inode->i_private;
 }
 
-static inline struct the_nilfs *NILFS_I_NILFS(struct inode *inode)
-{
-	return inode->i_sb->s_fs_info;
-}
-
 /* Default GFP flags using highmem */
 #define NILFS_MDT_GFP      (__GFP_WAIT | __GFP_IO | __GFP_HIGHMEM)
 
@@ -108,7 +103,7 @@ static inline void nilfs_mdt_clear_dirty(struct inode *inode)
 
 static inline __u64 nilfs_mdt_cno(struct inode *inode)
 {
-	return NILFS_I_NILFS(inode)->ns_cno;
+	return ((struct the_nilfs *)inode->i_sb->s_fs_info)->ns_cno;
 }
 
 #define nilfs_mdt_bgl_lock(inode, bg) \
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 37b9631..ce679cf 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -562,7 +562,7 @@ int nilfs_sufile_get_stat(struct inode *sufile, struct nilfs_sustat *sustat)
 {
 	struct buffer_head *header_bh;
 	struct nilfs_sufile_header *header;
-	struct the_nilfs *nilfs = NILFS_I_NILFS(sufile);
+	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
 	void *kaddr;
 	int ret;
 
@@ -812,7 +812,7 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
 	struct nilfs_segment_usage *su;
 	struct nilfs_suinfo *si = buf;
 	size_t susz = NILFS_MDT(sufile)->mi_entry_size;
-	struct the_nilfs *nilfs = NILFS_I_NILFS(sufile);
+	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
 	void *kaddr;
 	unsigned long nsegs, segusages_per_block;
 	ssize_t n;
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index 1eac4c6..e84bc5b 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -31,7 +31,7 @@
 
 static inline unsigned long nilfs_sufile_get_nsegments(struct inode *sufile)
 {
-	return NILFS_I_NILFS(sufile)->ns_nsegments;
+	return ((struct the_nilfs *)sufile->i_sb->s_fs_info)->ns_nsegments;
 }
 
 unsigned long nilfs_sufile_get_ncleansegs(struct inode *sufile);
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
