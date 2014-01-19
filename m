From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH] nilfs2: depending on flags, update segment usage instead of cleaning
Date: Sun, 19 Jan 2014 15:02:21 +0100
Message-ID: <1390140141-4432-1-git-send-email-andreas.rohner@gmx.net>
References: <cover.1390139797.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1390139797.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This patch introduces two new flags, which can be used to modify the
behavior of the cleaner.

NILFS_CLEAN_SEGMENTS_DEFAULT: Normal GC operation

NILFS_CLEAN_SEGMENTS_UPDATE_SEGUSG: Do not move any blocks, just update
        the segment usage information

Additionally this patch implements a simple update function, that
modifies the SUFILE in such a way, that old segments effectively become
new segments, without the need to move the blocks around.

This is useful because it allows the userspace GC to avoid
copying segments around needlessly, and still get essentially the same
effekt. This way huge amounts of write operations can be avoided and
the performance improves significantly.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/ioctl.c         | 58 ++++++++++++++++++++++++++++++++++++++++-------
 include/linux/nilfs2_fs.h |  6 +++++
 2 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index b44bdb2..52b967a 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -571,6 +571,42 @@ int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
 	return ret;
 }
 
+static int nilfs_ioctl_update_segment_usage(struct super_block *sb,
+				struct nilfs_argv argv[5], void *bufs[5])
+{
+	size_t nmembs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
+	struct inode *sufile = nilfs->ns_sufile;
+	struct nilfs_suinfo si;
+	__u64 *segnums;
+	int i, ret;
+	struct nilfs_transaction_info ti;
+
+	ret = nilfs_transaction_begin(sb, &ti, 0);
+	if (unlikely(ret))
+		return ret;
+
+	nmembs = argv[4].v_nmembs;
+	for (i = 0, segnums = bufs[4]; i < nmembs; ++i) {
+		ret = nilfs_sufile_get_suinfo(sufile, segnums[i],
+				&si, sizeof(struct nilfs_suinfo), 1);
+		if (unlikely(ret < 0))
+			goto failure;
+
+		ret = nilfs_sufile_set_segment_usage(sufile, segnums[i],
+				si.sui_nblocks, nilfs->ns_ctime);
+		if (unlikely(ret < 0))
+			goto failure;
+	}
+
+	nilfs_transaction_commit(sb);
+	return ret;
+
+ failure:
+	nilfs_transaction_abort(sb);
+	return ret;
+}
+
 static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 				      unsigned int cmd, void __user *argp)
 {
@@ -660,14 +696,20 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 		goto out_free;
 	}
 
-	ret = nilfs_ioctl_move_blocks(inode->i_sb, &argv[0], kbufs[0]);
-	if (ret < 0)
-		printk(KERN_ERR "NILFS: GC failed during preparation: "
-			"cannot read source blocks: err=%d\n", ret);
-	else {
-		if (nilfs_sb_need_update(nilfs))
-			set_nilfs_discontinued(nilfs);
-		ret = nilfs_clean_segments(inode->i_sb, argv, kbufs);
+	if (argv[0].v_flags == NILFS_CLEAN_SEGMENTS_UPDATE_SEGUSG) {
+		/* only update segment usage */
+		ret = nilfs_ioctl_update_segment_usage(inode->i_sb, argv,
+				kbufs);
+	} else {
+		ret = nilfs_ioctl_move_blocks(inode->i_sb, &argv[0], kbufs[0]);
+		if (ret < 0)
+			printk(KERN_ERR "NILFS: GC failed during preparation: "
+				"cannot read source blocks: err=%d\n", ret);
+		else {
+			if (nilfs_sb_need_update(nilfs))
+				set_nilfs_discontinued(nilfs);
+			ret = nilfs_clean_segments(inode->i_sb, argv, kbufs);
+		}
 	}
 
 	nilfs_remove_all_gcinodes(nilfs);
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 9875576..420be0b 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -727,6 +727,12 @@ struct nilfs_cpmode {
 	__u32 cm_pad;
 };
 
+/* values for v_flags */
+enum {
+	NILFS_CLEAN_SEGMENTS_DEFAULT,
+	NILFS_CLEAN_SEGMENTS_UPDATE_SEGUSG,
+};
+
 /**
  * struct nilfs_argv - argument vector
  * @v_base: pointer on data array from userspace
-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
