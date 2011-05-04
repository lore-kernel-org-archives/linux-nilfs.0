From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/4] nilfs2: add truncation routine of segment usage file
Date: Thu,  5 May 2011 03:18:54 +0900
Message-ID: <1304533135-25398-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

When shrinking the filesystem, segments to be truncated must be test
if they are busy or not, and unneeded sufile block should be deleted.
This adds routines for the truncation.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/sufile.c |  112 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 112 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index f4374df..22f2e6e 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -98,6 +98,13 @@ nilfs_sufile_get_segment_usage_block(struct inode *sufile, __u64 segnum,
 				   create, NULL, bhp);
 }
 
+static int nilfs_sufile_delete_segment_usage_block(struct inode *sufile,
+						   __u64 segnum)
+{
+	return nilfs_mdt_delete_block(sufile,
+				      nilfs_sufile_get_blkoff(sufile, segnum));
+}
+
 static void nilfs_sufile_mod_counter(struct buffer_head *header_bh,
 				     u64 ncleanadd, u64 ndirtyadd)
 {
@@ -610,6 +617,111 @@ void nilfs_sufile_do_set_error(struct inode *sufile, __u64 segnum,
 }
 
 /**
+  * nilfs_sufile_truncate_range - truncate range of segment array
+  * @sufile: inode of segment usage file
+  * @start: start segment number (inclusive)
+  * @end: end segment number (inclusive)
+  *
+  * Return Value: On success, 0 is returned.  On error, one of the
+  * following negative error codes is returned.
+  *
+  * %-EIO - I/O error.
+  *
+  * %-ENOMEM - Insufficient amount of memory available.
+  *
+  * %-EINVAL - Invalid number of segments specified
+  *
+  * %-EBUSY - Dirty or active segments are present in the range
+  */
+static int nilfs_sufile_truncate_range(struct inode *sufile,
+				       __u64 start, __u64 end)
+{
+	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
+	struct buffer_head *header_bh;
+	struct buffer_head *su_bh;
+	struct nilfs_segment_usage *su, *su2;
+	size_t susz = NILFS_MDT(sufile)->mi_entry_size;
+	unsigned long segusages_per_block;
+	unsigned long nsegs, ncleaned;
+	__u64 segnum;
+	void *kaddr;
+	ssize_t n, nc;
+	int ret;
+	int j;
+
+	nsegs = nilfs_sufile_get_nsegments(sufile);
+
+	ret = -EINVAL;
+	if (start > end || start >= nsegs)
+		goto out;
+
+	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
+	if (ret < 0)
+		goto out;
+
+	segusages_per_block = nilfs_sufile_segment_usages_per_block(sufile);
+	ncleaned = 0;
+
+	for (segnum = start; segnum <= end; segnum += n) {
+		n = min_t(unsigned long,
+			  segusages_per_block -
+				  nilfs_sufile_get_offset(sufile, segnum),
+			  end - segnum + 1);
+		ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0,
+							   &su_bh);
+		if (ret < 0) {
+			if (ret != -ENOENT)
+				goto out_header;
+			/* hole */
+			continue;
+		}
+		kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+		su = nilfs_sufile_block_get_segment_usage(
+			sufile, segnum, su_bh, kaddr);
+		su2 = su;
+		for (j = 0; j < n; j++, su = (void *)su + susz) {
+			if ((le32_to_cpu(su->su_flags) &
+			     ~(1UL << NILFS_SEGMENT_USAGE_ERROR)) ||
+			    nilfs_segment_is_active(nilfs, segnum + j)) {
+				ret = -EBUSY;
+				kunmap_atomic(kaddr, KM_USER0);
+				brelse(su_bh);
+				goto out_header;
+			}
+		}
+		nc = 0;
+		for (su = su2, j = 0; j < n; j++, su = (void *)su + susz) {
+			if (nilfs_segment_usage_error(su)) {
+				nilfs_segment_usage_set_clean(su);
+				nc++;
+			}
+		}
+		kunmap_atomic(kaddr, KM_USER0);
+		if (nc > 0) {
+			nilfs_mdt_mark_buffer_dirty(su_bh);
+			ncleaned += nc;
+		}
+		brelse(su_bh);
+
+		if (n == segusages_per_block) {
+			/* make hole */
+			nilfs_sufile_delete_segment_usage_block(sufile, segnum);
+		}
+	}
+	ret = 0;
+
+out_header:
+	if (ncleaned > 0) {
+		NILFS_SUI(sufile)->ncleansegs += ncleaned;
+		nilfs_sufile_mod_counter(header_bh, ncleaned, 0);
+		nilfs_mdt_mark_dirty(sufile);
+	}
+	brelse(header_bh);
+out:
+	return ret;
+}
+
+/**
  * nilfs_sufile_get_suinfo -
  * @sufile: inode of segment usage file
  * @segnum: segment number to start looking
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
