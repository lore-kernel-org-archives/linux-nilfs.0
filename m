From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v3 1/2] nilfs2: add nilfs_sufile_trim_fs to trim clean segs
Date: Fri, 21 Feb 2014 15:56:50 +0100
Message-ID: <149e07e7a88e8dace12335b18e553d533c0f3443.1392994051.git.andreas.rohner@gmx.net>
References: <cover.1392994051.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1392994051.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
In-Reply-To: <cover.1392994051.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
References: <cover.1392994051.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This patch adds the nilfs_sufile_trim_fs function, which takes a
fstrim_range structure and calls blkdev_issue_discard for every
clean segment in the specified range. The range is truncated to
file system block boundaries.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/sufile.c | 147 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/sufile.h |   1 +
 2 files changed, 148 insertions(+)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 3127e9f..6c3b350 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -870,6 +870,153 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
 }
 
 /**
+ * nilfs_sufile_trim_fs() - trim ioctl handle function
+ * @sufile: inode of segment usage file
+ * @range: fstrim_range structure
+ *
+ * start:	First Byte to trim
+ * len:		number of Bytes to trim from start
+ * minlen:	minimum extent length in Bytes
+ *
+ * Decription: nilfs_sufile_trim_fs goes through all segments containing bytes
+ * from start to start+len. start is rounded up to the next block boundary
+ * and start+len is rounded down. For each clean segment blkdev_issue_discard
+ * function is invoked.
+ *
+ * Return Value: On success, 0 is returned or negative error code, otherwise.
+ */
+int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range)
+{
+	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
+	struct buffer_head *su_bh;
+	struct nilfs_segment_usage *su;
+	void *kaddr;
+	size_t n, i, susz = NILFS_MDT(sufile)->mi_entry_size;
+	sector_t seg_start, seg_end, start_block, end_block;
+	sector_t start = 0, nblocks = 0;
+	u64 segnum, segnum_end, minlen, len, max_blocks, ndiscarded = 0;
+	int ret = 0;
+	unsigned int sects_per_block;
+
+	sects_per_block = (1 << nilfs->ns_blocksize_bits) /
+			bdev_logical_block_size(nilfs->ns_bdev);
+	len = range->len >> nilfs->ns_blocksize_bits;
+	minlen = range->minlen >> nilfs->ns_blocksize_bits;
+	max_blocks = ((u64)nilfs->ns_nsegments * nilfs->ns_blocks_per_segment);
+
+	if (!len || range->start >= max_blocks << nilfs->ns_blocksize_bits)
+		return -EINVAL;
+
+	start_block = (range->start + nilfs->ns_blocksize - 1) >>
+			nilfs->ns_blocksize_bits;
+
+	if (max_blocks - start_block < len)
+		end_block = max_blocks - 1;
+	else
+		end_block = start_block + len - 1;
+
+	segnum = nilfs_get_segnum_of_block(nilfs, start_block);
+	segnum_end = nilfs_get_segnum_of_block(nilfs, end_block);
+
+	down_read(&NILFS_MDT(sufile)->mi_sem);
+
+	while (segnum <= segnum_end) {
+		n = nilfs_sufile_segment_usages_in_block(sufile, segnum,
+				segnum_end);
+
+		ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0,
+							   &su_bh);
+		if (ret < 0) {
+			if (ret != -ENOENT)
+				goto out_sem;
+			/* hole */
+			segnum += n;
+			continue;
+		}
+
+		kaddr = kmap_atomic(su_bh->b_page);
+		su = nilfs_sufile_block_get_segment_usage(sufile, segnum,
+				su_bh, kaddr);
+		for (i = 0; i < n; ++i, ++segnum, su = (void *)su + susz) {
+			if (!nilfs_segment_usage_clean(su))
+				continue;
+
+			nilfs_get_segment_range(nilfs, segnum, &seg_start,
+						&seg_end);
+
+			if (!nblocks) {
+				/* start new extent */
+				start = seg_start;
+				nblocks = seg_end - seg_start + 1;
+				continue;
+			}
+
+			if (start + nblocks == seg_start) {
+				/* add to previous extent */
+				nblocks += seg_end - seg_start + 1;
+				continue;
+			}
+
+			/* discard previous extent */
+			if (start < start_block) {
+				nblocks -= start_block - start;
+				start = start_block;
+			}
+
+			if (nblocks >= minlen) {
+				kunmap_atomic(kaddr);
+
+				ret = blkdev_issue_discard(nilfs->ns_bdev,
+						start * sects_per_block,
+						nblocks * sects_per_block,
+						GFP_NOFS, 0);
+				if (ret < 0) {
+					put_bh(su_bh);
+					goto out_sem;
+				}
+
+				ndiscarded += nblocks;
+				kaddr = kmap_atomic(su_bh->b_page);
+				su = nilfs_sufile_block_get_segment_usage(
+					sufile, segnum, su_bh, kaddr);
+			}
+
+			/* start new extent */
+			start = seg_start;
+			nblocks = seg_end - seg_start + 1;
+		}
+		kunmap_atomic(kaddr);
+		put_bh(su_bh);
+	}
+
+
+	if (nblocks) {
+		/* discard last extent */
+		if (start < start_block) {
+			nblocks -= start_block - start;
+			start = start_block;
+		}
+		if (start + nblocks > end_block + 1)
+			nblocks = end_block - start + 1;
+
+		if (nblocks >= minlen) {
+			ret = blkdev_issue_discard(nilfs->ns_bdev,
+					start * sects_per_block,
+					nblocks * sects_per_block,
+					GFP_NOFS, 0);
+			if (!ret)
+				ndiscarded += nblocks;
+		}
+	}
+
+out_sem:
+	up_read(&NILFS_MDT(sufile)->mi_sem);
+
+	range->len = ndiscarded << nilfs->ns_blocksize_bits;
+	return ret;
+}
+
+/**
  * nilfs_sufile_read - read or get sufile inode
  * @sb: super block instance
  * @susize: size of a segment usage entry
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index e84bc5b..2434abd 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -65,6 +65,7 @@ void nilfs_sufile_do_set_error(struct inode *, __u64, struct buffer_head *,
 int nilfs_sufile_resize(struct inode *sufile, __u64 newnsegs);
 int nilfs_sufile_read(struct super_block *sb, size_t susize,
 		      struct nilfs_inode *raw_inode, struct inode **inodep);
+int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range);
 
 /**
  * nilfs_sufile_scrap - make a segment garbage
-- 
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
