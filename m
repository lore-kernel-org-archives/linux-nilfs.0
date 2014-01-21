From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v2 2/3] nilfs2: add nilfs_sufile_set_suinfo to update segment usage info
Date: Tue, 21 Jan 2014 15:00:29 +0100
Message-ID: <2fd48b2d524a59a02bdad13c0c194de3e5b55cc7.1390312777.git.andreas.rohner@gmx.net>
References: <cover.1390310509.git.andreas.rohner@gmx.net>
 <cec6a449ddf5ae9da2928cdddfb96ebcb2789eee.1390312777.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cec6a449ddf5ae9da2928cdddfb96ebcb2789eee.1390312777.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
In-Reply-To: <cec6a449ddf5ae9da2928cdddfb96ebcb2789eee.1390312777.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
References: <cec6a449ddf5ae9da2928cdddfb96ebcb2789eee.1390312777.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This patch introduces the nilfs_sufile_set_suinfo function, which
expects an array of nilfs_suinfo_update structures and updates the
segment usage information accordingly.

This is basically a helper function for the newly introduced
NILFS_IOCTL_SET_SUINFO ioctl.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/sufile.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/sufile.h |  2 +-
 2 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 3127e9f..81c3438 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -870,6 +870,97 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
 }
 
 /**
+ * nilfs_sufile_set_suinfo -
+ * @sufile: inode of segment usage file
+ * @buf: array of suinfo
+ * @supsz: byte size of suinfo
+ * @nsup: size of suinfo array
+ *
+ * Description: Takes an array of nilfs_suinfo_update structs and updates
+ * segment usage accordingly.
+ *
+ * Return Value: On success, 0 is returned and .... On error, one of the
+ * following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-EINVAL - Invalid segment number in input
+ */
+ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
+				unsigned supsz, size_t nsup)
+{
+	struct buffer_head *bh;
+	struct nilfs_suinfo_update *sup, *supv = buf;
+	struct nilfs_segment_usage *su;
+	void *kaddr;
+	unsigned long blkoff, prev_blkoff;
+	size_t nerr = 0;
+	int ret = 0;
+
+	if (unlikely(nsup == 0))
+		goto out;
+
+	down_write(&NILFS_MDT(sufile)->mi_sem);
+	for (sup = supv; sup < supv + nsup; sup++) {
+		if (unlikely(sup->sup_segnum >=
+				nilfs_sufile_get_nsegments(sufile))) {
+			printk(KERN_WARNING
+			       "%s: invalid segment number: %llu\n", __func__,
+			       (unsigned long long)sup->sup_segnum);
+			nerr++;
+		}
+	}
+	if (nerr > 0) {
+		ret = -EINVAL;
+		goto out_sem;
+	}
+
+	sup = supv;
+	blkoff = nilfs_sufile_get_blkoff(sufile, sup->sup_segnum);
+	ret = nilfs_mdt_get_block(sufile, blkoff, 1, NULL, &bh);
+	if (ret < 0)
+		goto out_sem;
+
+	for (;;) {
+		kaddr = kmap_atomic(bh->b_page);
+		su = nilfs_sufile_block_get_segment_usage(
+			sufile, sup->sup_segnum, bh, kaddr);
+
+		if (nilfs_suinfo_update_lastmod(sup))
+			su->su_lastmod = cpu_to_le64(sup->sup_sui.sui_lastmod);
+
+		if (nilfs_suinfo_update_nblocks(sup))
+			su->su_nblocks = cpu_to_le32(sup->sup_sui.sui_nblocks);
+
+		if (nilfs_suinfo_update_flags(sup))
+			su->su_flags = cpu_to_le32(sup->sup_sui.sui_flags);
+
+		kunmap_atomic(kaddr);
+
+		if (++sup >= supv + nsup)
+			break;
+		prev_blkoff = blkoff;
+		blkoff = nilfs_sufile_get_blkoff(sufile, sup->sup_segnum);
+		if (blkoff == prev_blkoff)
+			continue;
+
+		/* get different block */
+		brelse(bh);
+		ret = nilfs_mdt_get_block(sufile, blkoff, 1, NULL, &bh);
+		if (unlikely(ret < 0))
+			goto out_sem;
+	}
+	brelse(bh);
+
+ out_sem:
+	up_write(&NILFS_MDT(sufile)->mi_sem);
+ out:
+	return ret;
+}
+
+/**
  * nilfs_sufile_read - read or get sufile inode
  * @sb: super block instance
  * @susize: size of a segment usage entry
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index e84bc5b..7aa9d3e 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -44,7 +44,7 @@ int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
 int nilfs_sufile_get_stat(struct inode *, struct nilfs_sustat *);
 ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, void *, unsigned,
 				size_t);
-
+ssize_t nilfs_sufile_set_suinfo(struct inode *, void *, unsigned , size_t);
 int nilfs_sufile_updatev(struct inode *, __u64 *, size_t, int, size_t *,
 			 void (*dofunc)(struct inode *, __u64,
 					struct buffer_head *,
-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
