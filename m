From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCHv2 1/2] nilfs2-utils: add nilfs_sb_write
Date: Fri,  3 Sep 2010 23:10:42 +0900
Message-ID: <1283523043-7166-2-git-send-email-jir@unicus.jp>
References: <1283523043-7166-1-git-send-email-jir@unicus.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283523043-7166-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This patch adds nilfs_sb_write to modify super blocks.
To modify a part of both super blocks, it first reads both super blocks
then copes fields specified as "mask".

To read the super blocks, new functions nilfs_sb_read and __nilfs_sb_read
are introduced.  __nilfs_sb_read reads both super blocks and returns
both super blocks.  nilfs_sb_read calls __nilfs_sb_read and returns
effective super block out of two super blocks.

nilfs_read_sb now calls nilfs_sb_read to read super block.

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 include/nilfs.h |    7 +++
 lib/nilfs.c     |   16 +++++++
 lib/sb.c        |  128 ++++++++++++++++++++++++++++++++++++++++---------------
 3 files changed, 116 insertions(+), 35 deletions(-)

diff --git a/include/nilfs.h b/include/nilfs.h
index 5feac85..8a83dd3 100644
--- a/include/nilfs.h
+++ b/include/nilfs.h
@@ -94,6 +94,10 @@ typedef __u64 nilfs_cno_t;
 #define NILFS_CNO_MIN	((nilfs_cno_t)1)
 #define NILFS_CNO_MAX	(~(nilfs_cno_t)0)
 
+#define NILFS_SB_LABEL			0x0001
+#define NILFS_SB_UUID			0x0002
+#define NILFS_SB_COMMIT_INTERVAL	0x4000
+#define NILFS_SB_BLOCK_MAX		0x8000
 
 /**
  * struct nilfs - nilfs object
@@ -287,6 +291,9 @@ static inline int nilfs_block_is_node(const struct nilfs_block *blk)
 
 #define NILFS_SB_BLOCK_SIZE_SHIFT	10
 
+struct nilfs_super_block *nilfs_sb_read(int devfd);
+int nilfs_sb_write(int devfd, struct nilfs_super_block *sbp, int mask);
+
 int nilfs_read_sb(struct nilfs *);
 
 ssize_t nilfs_get_segment(struct nilfs *, unsigned long, void **);
diff --git a/lib/nilfs.c b/lib/nilfs.c
index 44e368b..19bf6e4 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -939,3 +939,19 @@ nilfs_cno_t nilfs_get_oldest_cno(struct nilfs *nilfs)
 	nilfs_get_cpinfo(nilfs, nilfs->n_mincno, NILFS_CHECKPOINT, cpinfo, 1);
 	return nilfs->n_mincno;
 }
+
+struct nilfs_super_block *nilfs_get_sb(struct nilfs *nilfs)
+{
+	return nilfs->n_sb;
+}
+
+int nilfs_read_sb(struct nilfs *nilfs)
+{
+	assert(nilfs->n_sb == NULL);
+
+	nilfs->n_sb = nilfs_sb_read(nilfs->n_devfd);
+	if (!nilfs->n_sb)
+		return -1;
+
+	return 0;
+}
diff --git a/lib/sb.c b/lib/sb.c
index ae10e55..201b9ad 100644
--- a/lib/sb.c
+++ b/lib/sb.c
@@ -36,6 +36,10 @@
 #include <stdlib.h>
 #endif	/* HAVE_STDLIB_H */
 
+#if HAVE_STRING_H
+#include <string.h>
+#endif	/* HAVE_STRING_H */
+
 #if HAVE_UNISTD_H
 #include <unistd.h>
 #endif	/* HAVE_UNISTD_H */
@@ -68,15 +72,22 @@
 
 #define NILFS_MAX_SB_SIZE	1024
 
-struct nilfs_super_block *nilfs_get_sb(struct nilfs *nilfs)
+static __u32 nilfs_sb_check_sum(struct nilfs_super_block *sbp)
 {
-	return nilfs->n_sb;
+	__u32 seed, crc;
+	__le32 sum;
+
+	seed = le32_to_cpu(sbp->s_crc_seed);
+	sum = sbp->s_sum;
+	sbp->s_sum = 0;
+	crc = crc32_le(seed, (unsigned char *)sbp, le16_to_cpu(sbp->s_bytes));
+	sbp->s_sum = sum;
+	return crc;
 }
 
 static int nilfs_sb_is_valid(struct nilfs_super_block *sbp, int check_crc)
 {
-	__le32 sum;
-	__u32 seed, crc;
+	__u32 crc;
 
 	if (le16_to_cpu(sbp->s_magic) != NILFS_SUPER_MAGIC)
 		return 0;
@@ -85,39 +96,39 @@ static int nilfs_sb_is_valid(struct nilfs_super_block *sbp, int check_crc)
 	if (!check_crc)
 		return 1;
 
-	seed = le32_to_cpu(sbp->s_crc_seed);
-	sum = sbp->s_sum;
-	sbp->s_sum = 0;
-	crc = crc32_le(seed, (unsigned char *)sbp, le16_to_cpu(sbp->s_bytes));
-	sbp->s_sum = sum;
-	return crc == le32_to_cpu(sum);
+	crc = nilfs_sb_check_sum(sbp);
+
+	return crc == le32_to_cpu(sbp->s_sum);
 }
 
-int nilfs_read_sb(struct nilfs *nilfs)
+static int __nilfs_sb_read(int devfd, struct nilfs_super_block **sbp,
+			   __u64 *offsets)
 {
-	struct nilfs_super_block *sbp[2];
 	__u64 devsize, sb2_offset;
 
-	assert(nilfs->n_sb == NULL);
-
 	sbp[0] = malloc(NILFS_MAX_SB_SIZE);
 	sbp[1] = malloc(NILFS_MAX_SB_SIZE);
 	if (sbp[0] == NULL || sbp[1] == NULL)
 		goto failed;
 
-	if (ioctl(nilfs->n_devfd, BLKGETSIZE64, &devsize) != 0)
+	if (ioctl(devfd, BLKGETSIZE64, &devsize) != 0)
 		goto failed;
 
-	if (lseek64(nilfs->n_devfd, NILFS_SB_OFFSET_BYTES, SEEK_SET) < 0 ||
-	    read(nilfs->n_devfd, sbp[0], NILFS_MAX_SB_SIZE) < 0 ||
+	if (lseek64(devfd, NILFS_SB_OFFSET_BYTES, SEEK_SET) < 0 ||
+	    read(devfd, sbp[0], NILFS_MAX_SB_SIZE) < 0 ||
 	    !nilfs_sb_is_valid(sbp[0], 0)) {
 		free(sbp[0]);
 		sbp[0] = NULL;
 	}
 
 	sb2_offset = NILFS_SB2_OFFSET_BYTES(devsize);
-	if (lseek64(nilfs->n_devfd, sb2_offset, SEEK_SET) < 0 ||
-	    read(nilfs->n_devfd, sbp[1], NILFS_MAX_SB_SIZE) < 0 ||
+	if (offsets) {
+		offsets[0] = NILFS_SB_OFFSET_BYTES;
+		offsets[1] = sb2_offset;
+	}
+
+	if (lseek64(devfd, sb2_offset, SEEK_SET) < 0 ||
+	    read(devfd, sbp[1], NILFS_MAX_SB_SIZE) < 0 ||
 	    !nilfs_sb_is_valid(sbp[1], 0))
 		goto sb2_failed;
 
@@ -129,22 +140,7 @@ int nilfs_read_sb(struct nilfs *nilfs)
 		goto sb2_failed;
 
  sb2_done:
-	if (!sbp[0]) {
-		sbp[0] = sbp[1];
-		sbp[1] = NULL;
-	}
-
-#if 0
-	if (sbp[1] &&
-	    le64_to_cpu(sbp[1]->s_wtime) > le64_to_cpu(sbp[0]->s_wtime)) {
-		nilfs->n_sb = sbp[1];
-		free(sbp[0]);
-	} else
-#endif
-		if (sbp[0]) {
-		nilfs->n_sb = sbp[0];
-		free(sbp[1]);
-	} else
+	if (!sbp[0] && !sbp[1])
 		goto failed;
 
 	return 0;
@@ -159,3 +155,65 @@ int nilfs_read_sb(struct nilfs *nilfs)
 	sbp[1] = NULL;
 	goto sb2_done;
 }
+
+struct nilfs_super_block *nilfs_sb_read(int devfd)
+{
+	struct nilfs_super_block *sbp[2];
+
+	if (__nilfs_sb_read(devfd, sbp, NULL))
+		return -1;
+
+	if (!sbp[0]) {
+		sbp[0] = sbp[1];
+		sbp[1] = NULL;
+	}
+
+	free(sbp[1]);
+
+	return sbp[0];
+}
+
+int nilfs_sb_write(int devfd, struct nilfs_super_block *sbp, int mask)
+{
+	__u64 offsets[2];
+	struct nilfs_super_block *sbps[2];
+	int i;
+	__u32 crc;
+
+	assert(devfd >= 0);
+
+	if (sbp == NULL)
+		return -1;
+
+	if (__nilfs_sb_read(devfd, sbps, offsets))
+		return -1;
+
+	for (i = 0; i < 2; i++) {
+		if (!sbps[i])
+			continue;
+
+		if (mask & NILFS_SB_LABEL)
+			memcpy(sbps[i]->s_volume_name,
+			       sbp->s_volume_name, sizeof(sbp->s_volume_name));
+
+		if (mask & NILFS_SB_COMMIT_INTERVAL)
+			sbps[i]->s_c_interval = sbp->s_c_interval;
+
+		if (mask & NILFS_SB_BLOCK_MAX)
+			sbps[i]->s_c_block_max = sbp->s_c_block_max;
+
+		if (mask & NILFS_SB_UUID)
+			memcpy(sbps[i]->s_uuid, sbp->s_uuid,
+			       sizeof(sbp->s_uuid));
+
+		crc = nilfs_sb_check_sum(sbps[i]);
+		sbps[i]->s_sum = cpu_to_le32(crc);
+		if (lseek(devfd, offsets[i], SEEK_SET) > 0)
+			write(devfd, sbps[i], NILFS_MAX_SB_SIZE);
+	}
+
+	free(sbps[0]);
+	free(sbps[1]);
+
+	return 0;
+}
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
