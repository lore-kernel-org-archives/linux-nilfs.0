From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 01/15] nilfs-utils: fsck: add necessary constants and
 function declarations
Date: Mon, 12 Nov 2012 13:34:34 +0400
Message-ID: <1352712874.2555.36.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:To:From:Subject:Message-ID; bh=A7vaz49qb9RXo8bjkm+t3oGRE49dnc/ownet/mHyH6I=;
	b=rZkvx6+jp7eBy1OF1mmTKAIzzdEiml1P5Tbq2GY4a3KdTQM0ex67Mu7ujEuYfdMPqUKLsjNLaA6s7ieqFcs1FXgTRGhD7DKJw+gdRjxdHkIm6MUY+r9qCHlwSamtaKe2;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patch adds several additional constants, function declarations and move useful macro from mkfs.c file into nilfs.h.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 01/15] nilfs-utils: fsck: add necessary constants and function declarations

This patch adds several additional constants, function declarations and move useful macro from mkfs.c file into nilfs.h.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 include/nilfs.h     |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/nilfs2_fs.h |    5 +++++
 sbin/mkfs/mkfs.c    |    1 -
 3 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/include/nilfs.h b/include/nilfs.h
index cdb468e..6dc6a47 100644
--- a/include/nilfs.h
+++ b/include/nilfs.h
@@ -87,6 +87,16 @@ typedef __u64 sector_t;	// XXX: __u64 ??
 typedef sector_t nilfs_blkoff_t;
 typedef __u64 nilfs_cno_t;
 
+#ifndef NILFS_FALSE
+#      define  NILFS_FALSE   (0)
+#endif
+
+#ifndef NILFS_TRUE
+#      define  NILFS_TRUE    (1)
+#endif
+
+#define DEFAULT_SECTOR_SIZE 512
+
 #define NILFS_FSTYPE	"nilfs2"
 
 #define NILFS_CNO_MIN	((nilfs_cno_t)1)
@@ -98,6 +108,12 @@ typedef __u64 nilfs_cno_t;
 #define NILFS_SB_COMMIT_INTERVAL	0x4000
 #define NILFS_SB_BLOCK_MAX		0x8000
 
+#define NILFS_PRIMARY_SB_SEG 0
+#define NILFS_SECONDARY_SB_SEG(sb) ((struct nilfs_superblock *)sb->s_nsegments)
+#define NILFS_SB_LOG 0
+
+#define ROUNDUP_DIV(n, m)   (((n) - 1) / (m) + 1)
+
 /**
  * struct nilfs - nilfs object
  * @n_sb: superblock
@@ -285,6 +301,11 @@ struct nilfs_super_block *nilfs_sb_read(int devfd);
 int nilfs_sb_write(int devfd, struct nilfs_super_block *sbp, int mask);
 
 int nilfs_read_sb(struct nilfs *);
+int nilfs_sb_read_unchecked(int devfd,
+				struct nilfs_super_block **sbp);
+int nilfs_sb_is_valid(int devfd,
+			struct nilfs_super_block *sbp,
+			__u64 *check_mask);
 
 ssize_t nilfs_get_segment(struct nilfs *, unsigned long, void **);
 int nilfs_put_segment(struct nilfs *, void *);
@@ -292,6 +313,11 @@ size_t nilfs_get_block_size(struct nilfs *);
 __u64 nilfs_get_segment_seqnum(const struct nilfs *, void *, __u64);
 __u64 nilfs_get_reserved_segments(const struct nilfs *nilfs);
 
+int nilfs_ss_header_is_valid(__u64 segment,
+				struct nilfs_super_block *sbp,
+				struct nilfs_segment_summary *ss_ptr,
+				__u16 *check_mask);
+
 int nilfs_change_cpmode(struct nilfs *, nilfs_cno_t, int);
 ssize_t nilfs_get_cpinfo(struct nilfs *, nilfs_cno_t, int,
 			 struct nilfs_cpinfo *, size_t);
@@ -319,4 +345,33 @@ static inline __u32 nilfs_get_blocks_per_segment(const struct nilfs *nilfs)
 	return le32_to_cpu(nilfs->n_sb->s_blocks_per_segment);
 }
 
+/* Convert segment number into start disk block */
+static inline __u64 seg_num_to_start_block(__u64 segment,
+				struct nilfs_super_block *sbp)
+{
+	if (0 == segment)
+		return le64_to_cpu(sbp->s_first_data_block);
+
+	return segment * le32_to_cpu(sbp->s_blocks_per_segment);
+}
+
+static inline __u64 block_to_seg_num(__u64 block,
+				struct nilfs_super_block *sbp)
+{
+	return block / le32_to_cpu(sbp->s_blocks_per_segment);
+}
+
+/*
+ * The population count.
+ * This is better when most bits in x are 0.
+ * http://en.wikipedia.org/wiki/Hamming_weight
+ */
+static inline int popcount_4(__u64 x)
+{
+	int count;
+	for (count = 0; x; count++)
+		x &= x - 1;
+	return count;
+}
+
 #endif	/* NILFS_H */
diff --git a/include/nilfs2_fs.h b/include/nilfs2_fs.h
index e674f44..30b6703 100644
--- a/include/nilfs2_fs.h
+++ b/include/nilfs2_fs.h
@@ -124,6 +124,11 @@ struct nilfs_super_root {
 #define NILFS_RESIZE_FS			0x0004	/* Resize required */
 
 /*
+ * Behavior when detecting errors flags
+ */
+#define NILFS_ERRORS_CONTINUE		1	/* Continue execution */
+
+/*
  * Mount flags (sbi->s_mount_opt)
  */
 #define NILFS_MOUNT_ERROR_MODE		0x0070  /* Error mode mask */
diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index fde1c76..50c5451 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -81,7 +81,6 @@
 typedef __u64  blocknr_t;
 
 #define BUG_ON(x)	   assert(!(x))
-#define ROUNDUP_DIV(n,m)   (((n) - 1) / (m) + 1)
 #define max_t(type,x,y) \
 	({ type __x = (x); type __y = (y); __x > __y ? __x : __y; })
 
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
