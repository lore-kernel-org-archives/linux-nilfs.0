From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 4/4] nilfs-utils: add extra flags to nilfs_vdesc and update sui_nblocks
Date: Sun, 16 Mar 2014 11:49:18 +0100
Message-ID: <f75f4b78d9d30a5805d8a79bba603d9ee59c43b3.1394966935.git.andreas.rohner@gmx.net>
References: <cover.1394966728.git.andreas.rohner@gmx.net>
 <36b7f57861b69c7fdb9d9e54a21df6f5c7f21061.1394966935.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <36b7f57861b69c7fdb9d9e54a21df6f5c7f21061.1394966935.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
In-Reply-To: <36b7f57861b69c7fdb9d9e54a21df6f5c7f21061.1394966935.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
References: <36b7f57861b69c7fdb9d9e54a21df6f5c7f21061.1394966935.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This patch adds extra flags to nilfs_vdesc that indicate the reason for
which a particular block is considered alive. If it is because of a
snapshot, then the snapshot flag is set, if it is because of the
protection period, then that flag is set.

This information is useful to determine the number of live blocks in a
segment. If a block is part of a snapshot, it is counted as alive, if it
is alive because of the protection period it is counted as reclaimable.
These flags are used both in userspace and by the kernel.

Additionally this patch adds code that calculates the correct number of
live blocks per segment if nilfs_set_suinfo() is used.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 include/nilfs.h     |  6 +++++
 include/nilfs2_fs.h | 52 +++++++++++++++++++++++++++++++++++++--
 lib/gc.c            | 71 +++++++++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 119 insertions(+), 10 deletions(-)

diff --git a/include/nilfs.h b/include/nilfs.h
index bd134be..3585f6b 100644
--- a/include/nilfs.h
+++ b/include/nilfs.h
@@ -329,4 +329,10 @@ static inline __u32 nilfs_get_blocks_per_segment(const struct nilfs *nilfs)
 	return le32_to_cpu(nilfs->n_sb->s_blocks_per_segment);
 }
 
+static inline __u64
+nilfs_get_segnum_of_block(const struct nilfs *nilfs, sector_t blocknr)
+{
+	return blocknr / nilfs_get_blocks_per_segment(nilfs);
+}
+
 #endif	/* NILFS_H */
diff --git a/include/nilfs2_fs.h b/include/nilfs2_fs.h
index cb02739..7a060b3 100644
--- a/include/nilfs2_fs.h
+++ b/include/nilfs2_fs.h
@@ -859,7 +859,7 @@ struct nilfs_vinfo {
  * @vd_blocknr: disk block number
  * @vd_offset: logical block offset inside a file
  * @vd_flags: flags (data or node block)
- * @vd_pad: padding
+ * @vd_flags2: additional flags
  */
 struct nilfs_vdesc {
 	__u64 vd_ino;
@@ -869,9 +869,57 @@ struct nilfs_vdesc {
 	__u64 vd_blocknr;
 	__u64 vd_offset;
 	__u32 vd_flags;
-	__u32 vd_pad;
+	/* vd_flags2 needed because of backwards compatibility */
+	__u32 vd_flags2;
 };
 
+/* vdesc flags */
+enum {
+	NILFS_VDESC_DATA,
+	NILFS_VDESC_NODE,
+	/* ... */
+};
+enum {
+	NILFS_VDESC_SNAPSHOT,
+	NILFS_VDESC_PROTECTION_PERIOD,
+	__NR_NILFS_VDESC_FIELDS,
+	/* ... */
+};
+
+#define NILFS_VDESC_FNS(flag, name)					\
+static inline void							\
+nilfs_vdesc_set_##name(struct nilfs_vdesc *vdesc)			\
+{									\
+	vdesc->vd_flags = NILFS_VDESC_##flag;				\
+}									\
+static inline int							\
+nilfs_vdesc_##name(const struct nilfs_vdesc *vdesc)			\
+{									\
+	return vdesc->vd_flags == NILFS_VDESC_##flag;			\
+}
+
+#define NILFS_VDESC_FNS2(flag, name)					\
+static inline void							\
+nilfs_vdesc_set_##name(struct nilfs_vdesc *vdesc)			\
+{									\
+	vdesc->vd_flags2 |= (1UL << NILFS_VDESC_##flag);		\
+}									\
+static inline void							\
+nilfs_vdesc_clear_##name(struct nilfs_vdesc *vdesc)			\
+{									\
+	vdesc->vd_flags2 &= ~(1UL << NILFS_VDESC_##flag);		\
+}									\
+static inline int							\
+nilfs_vdesc_##name(const struct nilfs_vdesc *vdesc)			\
+{									\
+	return !!(vdesc->vd_flags2 & (1UL << NILFS_VDESC_##flag));	\
+}
+
+NILFS_VDESC_FNS(DATA, data)
+NILFS_VDESC_FNS(NODE, node)
+NILFS_VDESC_FNS2(SNAPSHOT, snapshot)
+NILFS_VDESC_FNS2(PROTECTION_PERIOD, protection_period)
+
 /**
  * struct nilfs_bdesc - descriptor of disk block number
  * @bd_ino: inode number
diff --git a/lib/gc.c b/lib/gc.c
index 2338174..2df15f7 100644
--- a/lib/gc.c
+++ b/lib/gc.c
@@ -128,6 +128,7 @@ static int nilfs_acc_blocks_file(struct nilfs_file *file,
 				return -1;
 			bdesc->bd_ino = ino;
 			bdesc->bd_oblocknr = blk.b_blocknr;
+			bdesc->bd_pad = 0;
 			if (nilfs_block_is_data(&blk)) {
 				bdesc->bd_offset =
 					le64_to_cpu(*(__le64 *)blk.b_binfo);
@@ -148,17 +149,19 @@ static int nilfs_acc_blocks_file(struct nilfs_file *file,
 			vdesc->vd_ino = ino;
 			vdesc->vd_cno = cno;
 			vdesc->vd_blocknr = blk.b_blocknr;
+			vdesc->vd_flags = 0;
+			vdesc->vd_flags2 = 0;
 			if (nilfs_block_is_data(&blk)) {
 				binfo = blk.b_binfo;
 				vdesc->vd_vblocknr =
 					le64_to_cpu(binfo->bi_v.bi_vblocknr);
 				vdesc->vd_offset =
 					le64_to_cpu(binfo->bi_v.bi_blkoff);
-				vdesc->vd_flags = 0;	/* data */
+				nilfs_vdesc_set_data(vdesc);
 			} else {
 				vdesc->vd_vblocknr =
 					le64_to_cpu(*(__le64 *)blk.b_binfo);
-				vdesc->vd_flags = 1;	/* node */
+				nilfs_vdesc_set_node(vdesc);
 			}
 		}
 	}
@@ -391,7 +394,7 @@ static ssize_t nilfs_get_snapshot(struct nilfs *nilfs, nilfs_cno_t **ssp)
  * @n: size of @ss array
  * @last_hit: the last snapshot number hit
  */
-static int nilfs_vdesc_is_live(const struct nilfs_vdesc *vdesc,
+static int nilfs_vdesc_is_live(struct nilfs_vdesc *vdesc,
 			       nilfs_cno_t protect, const nilfs_cno_t *ss,
 			       size_t n, nilfs_cno_t *last_hit)
 {
@@ -407,18 +410,22 @@ static int nilfs_vdesc_is_live(const struct nilfs_vdesc *vdesc,
 		return vdesc->vd_period.p_end == NILFS_CNO_MAX;
 	}
 
-	if (vdesc->vd_period.p_end == NILFS_CNO_MAX ||
-	    vdesc->vd_period.p_end > protect)
+	if (vdesc->vd_period.p_end == NILFS_CNO_MAX)
 		return 1;
 
+	if (vdesc->vd_period.p_end > protect)
+		nilfs_vdesc_set_protection_period(vdesc);
+
 	if (n == 0 || vdesc->vd_period.p_start > ss[n - 1] ||
 	    vdesc->vd_period.p_end <= ss[0])
-		return 0;
+		return nilfs_vdesc_protection_period(vdesc);
 
 	/* Try the last hit snapshot number */
 	if (*last_hit >= vdesc->vd_period.p_start &&
-	    *last_hit < vdesc->vd_period.p_end)
+	    *last_hit < vdesc->vd_period.p_end) {
+		nilfs_vdesc_set_snapshot(vdesc);
 		return 1;
+	}
 
 	low = 0;
 	high = n - 1;
@@ -434,10 +441,11 @@ static int nilfs_vdesc_is_live(const struct nilfs_vdesc *vdesc,
 		} else {
 			/* ss[index] is in the range [p_start, p_end) */
 			*last_hit = ss[index];
+			nilfs_vdesc_set_snapshot(vdesc);
 			return 1;
 		}
 	}
-	return 0;
+	return nilfs_vdesc_protection_period(vdesc);
 }
 
 /**
@@ -602,6 +610,47 @@ static int nilfs_toss_bdescs(struct nilfs_vector *bdescv)
 }
 
 /**
+ * nilfs_count_live_blocks - returns the number of blocks in segnum
+ * @nilfs: nilfs object
+ * @segnum: segment number
+ * @bdescv: vector object storing (descriptors of) disk block numbers
+ * @vdescv: vector object storing (descriptors of) virtual block numbers
+ */
+static size_t nilfs_count_live_blocks(const struct nilfs *nilfs,
+				      __u64 segnum,
+				      struct nilfs_vector *vdescv,
+				      struct nilfs_vector *bdescv)
+{
+	struct nilfs_vdesc *vdesc;
+	struct nilfs_bdesc *bdesc;
+	int i;
+	size_t res = 0;
+
+	for (i = 0; i < nilfs_vector_get_size(bdescv); i++) {
+		bdesc = nilfs_vector_get_element(bdescv, i);
+		assert(bdesc != NULL);
+
+		if (nilfs_get_segnum_of_block(nilfs, bdesc->bd_blocknr) ==
+				segnum && nilfs_bdesc_is_live(bdesc)) {
+			++res;
+		}
+	}
+
+	for (i = 0; i < nilfs_vector_get_size(vdescv); i++) {
+		vdesc = nilfs_vector_get_element(vdescv, i);
+		assert(vdesc != NULL);
+
+		if (nilfs_get_segnum_of_block(nilfs, vdesc->vd_blocknr) ==
+				segnum && (nilfs_vdesc_snapshot(vdesc) ||
+				!nilfs_vdesc_protection_period(vdesc))) {
+			++res;
+		}
+	}
+
+	return res;
+}
+
+/**
  * nilfs_xreclaim_segment - reclaim segments (enhanced API)
  * @nilfs: nilfs object
  * @segnums: array of segment numbers storing selected segments
@@ -757,7 +806,13 @@ int nilfs_xreclaim_segment(struct nilfs *nilfs,
 			sup->sup_segnum = segnums[i];
 			sup->sup_flags = 0;
 			nilfs_suinfo_update_set_lastmod(sup);
+			nilfs_suinfo_update_set_nblocks(sup);
+
 			sup->sup_sui.sui_lastmod = tv.tv_sec;
+			sup->sup_sui.sui_nblocks =
+				nilfs_count_live_blocks(nilfs,
+						segnums[i], vdescv, bdescv);
+
 		}
 
 		ret = nilfs_set_suinfo(nilfs, nilfs_vector_get_data(supv), n);
-- 
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
