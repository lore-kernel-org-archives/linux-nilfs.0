From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/4] nilfs2: implement resize ioctl
Date: Thu,  5 May 2011 03:18:55 +0900
Message-ID: <1304533135-25398-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This adds resize ioctl which makes online resize possible.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/ioctl.c     |   27 ++++++++++++++++++
 fs/nilfs2/nilfs.h     |    1 +
 fs/nilfs2/sufile.c    |   67 +++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/sufile.h    |    1 +
 fs/nilfs2/super.c     |   72 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/the_nilfs.c |   24 +++++++++++++---
 fs/nilfs2/the_nilfs.h |    2 +
 7 files changed, 189 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 6f61777..41d6743 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -698,6 +698,31 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
 	return 0;
 }
 
+static int nilfs_ioctl_resize(struct inode *inode, struct file *filp,
+			      void __user *argp)
+{
+	__u64 newsize;
+	int ret = -EPERM;
+
+	if (!capable(CAP_SYS_ADMIN))
+		goto out;
+
+	ret = mnt_want_write(filp->f_path.mnt);
+	if (ret)
+		goto out;
+
+	ret = -EFAULT;
+	if (copy_from_user(&newsize, argp, sizeof(newsize)))
+		goto out_drop_write;
+
+	ret = nilfs_resize_fs(inode->i_sb, newsize);
+
+out_drop_write:
+	mnt_drop_write(filp->f_path.mnt);
+out:
+	return ret;
+}
+
 static int nilfs_ioctl_set_alloc_range(struct inode *inode, void __user *argp)
 {
 	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
@@ -795,6 +820,8 @@ long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return nilfs_ioctl_clean_segments(inode, filp, cmd, argp);
 	case NILFS_IOCTL_SYNC:
 		return nilfs_ioctl_sync(inode, filp, cmd, argp);
+	case NILFS_IOCTL_RESIZE:
+		return nilfs_ioctl_resize(inode, filp, argp);
 	case NILFS_IOCTL_SET_ALLOC_RANGE:
 		return nilfs_ioctl_set_alloc_range(inode, argp);
 	default:
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index a8dd344..09af009 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -298,6 +298,7 @@ struct nilfs_super_block **nilfs_prepare_super(struct super_block *sb,
 					       int flip);
 int nilfs_commit_super(struct super_block *sb, int flag);
 int nilfs_cleanup_super(struct super_block *sb);
+int nilfs_resize_fs(struct super_block *sb, __u64 newsize);
 int nilfs_attach_checkpoint(struct super_block *sb, __u64 cno, int curr_mnt,
 			    struct nilfs_root **root);
 int nilfs_checkpoint_is_mounted(struct super_block *sb, __u64 cno);
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 22f2e6e..37b9631 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -722,6 +722,73 @@ out:
 }
 
 /**
+ * nilfs_sufile_resize - resize segment array
+ * @sufile: inode of segment usage file
+ * @newnsegs: new number of segments
+ *
+ * Return Value: On success, 0 is returned.  On error, one of the
+ * following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOSPC - Enough free space is not left for shrinking
+ *
+ * %-EBUSY - Dirty or active segments exist in the region to be truncated
+ */
+int nilfs_sufile_resize(struct inode *sufile, __u64 newnsegs)
+{
+	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
+	struct buffer_head *header_bh;
+	struct nilfs_sufile_header *header;
+	struct nilfs_sufile_info *sui = NILFS_SUI(sufile);
+	void *kaddr;
+	unsigned long nsegs, nrsvsegs;
+	int ret = 0;
+
+	down_write(&NILFS_MDT(sufile)->mi_sem);
+
+	nsegs = nilfs_sufile_get_nsegments(sufile);
+	if (nsegs == newnsegs)
+		goto out;
+
+	ret = -ENOSPC;
+	nrsvsegs = nilfs_nrsvsegs(nilfs, newnsegs);
+	if (newnsegs < nsegs && nsegs - newnsegs + nrsvsegs > sui->ncleansegs)
+		goto out;
+
+	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
+	if (ret < 0)
+		goto out;
+
+	if (newnsegs > nsegs) {
+		sui->ncleansegs += newnsegs - nsegs;
+	} else /* newnsegs < nsegs */ {
+		ret = nilfs_sufile_truncate_range(sufile, newnsegs, nsegs - 1);
+		if (ret < 0)
+			goto out_header;
+
+		sui->ncleansegs -= nsegs - newnsegs;
+	}
+
+	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	header = kaddr + bh_offset(header_bh);
+	header->sh_ncleansegs = cpu_to_le64(sui->ncleansegs);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	nilfs_mdt_mark_buffer_dirty(header_bh);
+	nilfs_mdt_mark_dirty(sufile);
+	nilfs_set_nsegments(nilfs, newnsegs);
+
+out_header:
+	brelse(header_bh);
+out:
+	up_write(&NILFS_MDT(sufile)->mi_sem);
+	return ret;
+}
+
+/**
  * nilfs_sufile_get_suinfo -
  * @sufile: inode of segment usage file
  * @segnum: segment number to start looking
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index 57bfee9..1eac4c6 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -62,6 +62,7 @@ void nilfs_sufile_do_cancel_free(struct inode *, __u64, struct buffer_head *,
 void nilfs_sufile_do_set_error(struct inode *, __u64, struct buffer_head *,
 			       struct buffer_head *);
 
+int nilfs_sufile_resize(struct inode *sufile, __u64 newnsegs);
 int nilfs_sufile_read(struct super_block *sb, size_t susize,
 		      struct nilfs_inode *raw_inode, struct inode **inodep);
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index eba5b53..2846491 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -56,6 +56,7 @@
 #include "btnode.h"
 #include "page.h"
 #include "cpfile.h"
+#include "sufile.h" /* nilfs_sufile_resize(), nilfs_sufile_set_alloc_range() */
 #include "ifile.h"
 #include "dat.h"
 #include "segment.h"
@@ -404,6 +405,77 @@ out:
 	return ret;
 }
 
+/**
+ * nilfs_resize_fs - resize the filesystem
+ * @sb: super block instance
+ * @newsize: new size of the filesystem (in bytes)
+ */
+int nilfs_resize_fs(struct super_block *sb, __u64 newsize)
+{
+	struct the_nilfs *nilfs = sb->s_fs_info;
+	struct nilfs_super_block **sbp;
+	__u64 devsize, newnsegs;
+	loff_t sb2off;
+	int ret;
+
+	ret = -ERANGE;
+	devsize = i_size_read(sb->s_bdev->bd_inode);
+	if (newsize > devsize)
+		goto out;
+
+	/*
+	 * Write lock is required to protect some functions depending
+	 * on the number of segments, the number of reserved segments,
+	 * and so forth.
+	 */
+	down_write(&nilfs->ns_segctor_sem);
+
+	sb2off = NILFS_SB2_OFFSET_BYTES(newsize);
+	newnsegs = sb2off >> nilfs->ns_blocksize_bits;
+	do_div(newnsegs, nilfs->ns_blocks_per_segment);
+
+	ret = nilfs_sufile_resize(nilfs->ns_sufile, newnsegs);
+	up_write(&nilfs->ns_segctor_sem);
+	if (ret < 0)
+		goto out;
+
+	ret = nilfs_construct_segment(sb);
+	if (ret < 0)
+		goto out;
+
+	down_write(&nilfs->ns_sem);
+	nilfs_move_2nd_super(sb, sb2off);
+	ret = -EIO;
+	sbp = nilfs_prepare_super(sb, 0);
+	if (likely(sbp)) {
+		nilfs_set_log_cursor(sbp[0], nilfs);
+		/*
+		 * Drop NILFS_RESIZE_FS flag for compatibility with
+		 * mount-time resize which may be implemented in a
+		 * future release.
+		 */
+		sbp[0]->s_state = cpu_to_le16(le16_to_cpu(sbp[0]->s_state) &
+					      ~NILFS_RESIZE_FS);
+		sbp[0]->s_dev_size = cpu_to_le64(newsize);
+		sbp[0]->s_nsegments = cpu_to_le64(nilfs->ns_nsegments);
+		if (sbp[1])
+			memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
+		ret = nilfs_commit_super(sb, NILFS_SB_COMMIT_ALL);
+	}
+	up_write(&nilfs->ns_sem);
+
+	/*
+	 * Reset the range of allocatable segments last.  This order
+	 * is important in the case of expansion because the secondary
+	 * superblock must be protected from log write until migration
+	 * completes.
+	 */
+	if (!ret)
+		nilfs_sufile_set_alloc_range(nilfs->ns_sufile, 0, newnsegs - 1);
+out:
+	return ret;
+}
+
 static void nilfs_put_super(struct super_block *sb)
 {
 	struct the_nilfs *nilfs = sb->s_fs_info;
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index d2acd1a..d327140 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -363,6 +363,24 @@ static unsigned long long nilfs_max_size(unsigned int blkbits)
 	return res;
 }
 
+/**
+ * nilfs_nrsvsegs - calculate the number of reserved segments
+ * @nilfs: nilfs object
+ * @nsegs: total number of segments
+ */
+unsigned long nilfs_nrsvsegs(struct the_nilfs *nilfs, unsigned long nsegs)
+{
+	return max_t(unsigned long, NILFS_MIN_NRSVSEGS,
+		     DIV_ROUND_UP(nsegs * nilfs->ns_r_segments_percentage,
+				  100));
+}
+
+void nilfs_set_nsegments(struct the_nilfs *nilfs, unsigned long nsegs)
+{
+	nilfs->ns_nsegments = nsegs;
+	nilfs->ns_nrsvsegs = nilfs_nrsvsegs(nilfs, nsegs);
+}
+
 static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
 				   struct nilfs_super_block *sbp)
 {
@@ -389,13 +407,9 @@ static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
 	}
 
 	nilfs->ns_first_data_block = le64_to_cpu(sbp->s_first_data_block);
-	nilfs->ns_nsegments = le64_to_cpu(sbp->s_nsegments);
 	nilfs->ns_r_segments_percentage =
 		le32_to_cpu(sbp->s_r_segments_percentage);
-	nilfs->ns_nrsvsegs =
-		max_t(unsigned long, NILFS_MIN_NRSVSEGS,
-		      DIV_ROUND_UP(nilfs->ns_nsegments *
-				   nilfs->ns_r_segments_percentage, 100));
+	nilfs_set_nsegments(nilfs, le64_to_cpu(sbp->s_nsegments));
 	nilfs->ns_crc_seed = le32_to_cpu(sbp->s_crc_seed);
 	return 0;
 }
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index f496814..9992b11 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -268,6 +268,8 @@ struct the_nilfs *alloc_nilfs(struct block_device *bdev);
 void destroy_nilfs(struct the_nilfs *nilfs);
 int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data);
 int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb);
+unsigned long nilfs_nrsvsegs(struct the_nilfs *nilfs, unsigned long nsegs);
+void nilfs_set_nsegments(struct the_nilfs *nilfs, unsigned long nsegs);
 int nilfs_discard_segments(struct the_nilfs *, __u64 *, size_t);
 int nilfs_count_free_blocks(struct the_nilfs *, sector_t *);
 struct nilfs_root *nilfs_lookup_root(struct the_nilfs *nilfs, __u64 cno);
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
