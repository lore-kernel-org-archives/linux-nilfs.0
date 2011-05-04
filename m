From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/4] nilfs2: add ioctl which limits range of segment to be allocated
Date: Thu,  5 May 2011 03:18:52 +0900
Message-ID: <1304533135-25398-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1304533135-25398-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1304533135-25398-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This adds a new ioctl command which limits range of segment to be
allocated.  This is intended to gather data whithin a range of the
partition before shrinking the filesystem, or to control new log
location for some purpose.

If a range is specified by the ioctl, segment allocator of nilfs tries
to allocate new segments from the range unless no free segments are
available there.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/ioctl.c         |   34 +++++++++++++++++++++
 fs/nilfs2/sufile.c        |   73 ++++++++++++++++++++++++++++++++++++++------
 fs/nilfs2/sufile.h        |    1 +
 include/linux/nilfs2_fs.h |    2 +
 4 files changed, 100 insertions(+), 10 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index f2469ba..6f61777 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -698,6 +698,38 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
 	return 0;
 }
 
+static int nilfs_ioctl_set_alloc_range(struct inode *inode, void __user *argp)
+{
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	__u64 range[2];
+	__u64 minseg, maxseg;
+	unsigned long segbytes;
+	int ret = -EPERM;
+
+	if (!capable(CAP_SYS_ADMIN))
+		goto out;
+
+	ret = -EFAULT;
+	if (copy_from_user(range, argp, sizeof(__u64[2])))
+		goto out;
+
+	ret = -ERANGE;
+	if (range[1] > i_size_read(inode->i_sb->s_bdev->bd_inode))
+		goto out;
+
+	segbytes = nilfs->ns_blocks_per_segment * nilfs->ns_blocksize;
+
+	minseg = range[0] + segbytes - 1;
+	do_div(minseg, segbytes);
+	maxseg = NILFS_SB2_OFFSET_BYTES(range[1]);
+	do_div(maxseg, segbytes);
+	maxseg--;
+
+	ret = nilfs_sufile_set_alloc_range(nilfs->ns_sufile, minseg, maxseg);
+out:
+	return ret;
+}
+
 static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
 				unsigned int cmd, void __user *argp,
 				size_t membsz,
@@ -763,6 +795,8 @@ long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return nilfs_ioctl_clean_segments(inode, filp, cmd, argp);
 	case NILFS_IOCTL_SYNC:
 		return nilfs_ioctl_sync(inode, filp, cmd, argp);
+	case NILFS_IOCTL_SET_ALLOC_RANGE:
+		return nilfs_ioctl_set_alloc_range(inode, argp);
 	default:
 		return -ENOTTY;
 	}
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 1d6f488..f4374df 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -33,7 +33,9 @@
 
 struct nilfs_sufile_info {
 	struct nilfs_mdt_info mi;
-	unsigned long ncleansegs;
+	unsigned long ncleansegs;/* number of clean segments */
+	__u64 allocmin;		/* lower limit of allocatable segment range */
+	__u64 allocmax;		/* upper limit of allocatable segment range */
 };
 
 static inline struct nilfs_sufile_info *NILFS_SUI(struct inode *sufile)
@@ -248,6 +250,35 @@ int nilfs_sufile_update(struct inode *sufile, __u64 segnum, int create,
 }
 
 /**
+ * nilfs_sufile_set_alloc_range - limit range of segment to be allocated
+ * @sufile: inode of segment usage file
+ * @start: minimum segment number of allocatable region (inclusive)
+ * @end: maximum segment number of allocatable region (inclusive)
+ *
+ * Return Value: On success, 0 is returned.  On error, one of the
+ * following negative error codes is returned.
+ *
+ * %-ERANGE - invalid segment region
+ */
+int nilfs_sufile_set_alloc_range(struct inode *sufile, __u64 start, __u64 end)
+{
+	struct nilfs_sufile_info *sui = NILFS_SUI(sufile);
+	__u64 nsegs;
+	int ret = -ERANGE;
+
+	down_write(&NILFS_MDT(sufile)->mi_sem);
+	nsegs = nilfs_sufile_get_nsegments(sufile);
+
+	if (start <= end && end < nsegs) {
+		sui->allocmin = start;
+		sui->allocmax = end;
+		ret = 0;
+	}
+	up_write(&NILFS_MDT(sufile)->mi_sem);
+	return ret;
+}
+
+/**
  * nilfs_sufile_alloc - allocate a segment
  * @sufile: inode of segment usage file
  * @segnump: pointer to segment number
@@ -269,11 +300,12 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 	struct buffer_head *header_bh, *su_bh;
 	struct nilfs_sufile_header *header;
 	struct nilfs_segment_usage *su;
+	struct nilfs_sufile_info *sui = NILFS_SUI(sufile);
 	size_t susz = NILFS_MDT(sufile)->mi_entry_size;
 	__u64 segnum, maxsegnum, last_alloc;
 	void *kaddr;
-	unsigned long nsegments, ncleansegs, nsus;
-	int ret, i, j;
+	unsigned long nsegments, ncleansegs, nsus, cnt;
+	int ret, j;
 
 	down_write(&NILFS_MDT(sufile)->mi_sem);
 
@@ -287,13 +319,31 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 	kunmap_atomic(kaddr, KM_USER0);
 
 	nsegments = nilfs_sufile_get_nsegments(sufile);
+	maxsegnum = sui->allocmax;
 	segnum = last_alloc + 1;
-	maxsegnum = nsegments - 1;
-	for (i = 0; i < nsegments; i += nsus) {
-		if (segnum >= nsegments) {
-			/* wrap around */
-			segnum = 0;
-			maxsegnum = last_alloc;
+	if (segnum < sui->allocmin || segnum > sui->allocmax)
+		segnum = sui->allocmin;
+
+	for (cnt = 0; cnt < nsegments; cnt += nsus) {
+		if (segnum > maxsegnum) {
+			if (cnt < sui->allocmax - sui->allocmin + 1) {
+				/*
+				 * wrap around in the limited region.
+				 * if allocation started from
+				 * sui->allocmin, this never happens.
+				 */
+				segnum = sui->allocmin;
+				maxsegnum = last_alloc;
+			} else if (segnum > sui->allocmin &&
+				   sui->allocmax + 1 < nsegments) {
+				segnum = sui->allocmax + 1;
+				maxsegnum = nsegments - 1;
+			} else if (sui->allocmin > 0)  {
+				segnum = 0;
+				maxsegnum = sui->allocmin - 1;
+			} else {
+				break; /* never happens */
+			}
 		}
 		ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 1,
 							   &su_bh);
@@ -319,7 +369,7 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 			header->sh_last_alloc = cpu_to_le64(segnum);
 			kunmap_atomic(kaddr, KM_USER0);
 
-			NILFS_SUI(sufile)->ncleansegs--;
+			sui->ncleansegs--;
 			nilfs_mdt_mark_buffer_dirty(header_bh);
 			nilfs_mdt_mark_buffer_dirty(su_bh);
 			nilfs_mdt_mark_dirty(sufile);
@@ -679,6 +729,9 @@ int nilfs_sufile_read(struct super_block *sb, size_t susize,
 	kunmap_atomic(kaddr, KM_USER0);
 	brelse(header_bh);
 
+	sui->allocmax = nilfs_sufile_get_nsegments(sufile) - 1;
+	sui->allocmin = 0;
+
 	unlock_new_inode(sufile);
  out:
 	*inodep = sufile;
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index a943fba..57bfee9 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -36,6 +36,7 @@ static inline unsigned long nilfs_sufile_get_nsegments(struct inode *sufile)
 
 unsigned long nilfs_sufile_get_ncleansegs(struct inode *sufile);
 
+int nilfs_sufile_set_alloc_range(struct inode *sufile, __u64 start, __u64 end);
 int nilfs_sufile_alloc(struct inode *, __u64 *);
 int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum);
 int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index bd8678f..7454ad7 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -845,5 +845,7 @@ struct nilfs_bdesc {
 	_IOR(NILFS_IOCTL_IDENT, 0x8A, __u64)
 #define NILFS_IOCTL_RESIZE  \
 	_IOW(NILFS_IOCTL_IDENT, 0x8B, __u64)
+#define NILFS_IOCTL_SET_ALLOC_RANGE  \
+	_IOW(NILFS_IOCTL_IDENT, 0x8C, __u64[2])
 
 #endif	/* _LINUX_NILFS_FS_H */
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
