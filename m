From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 2/6] nilfs-utils: add additional flags for nilfs_vdesc
Date: Tue, 24 Feb 2015 20:04:15 +0100
Message-ID: <1424804659-10986-2-git-send-email-andreas.rohner@gmx.net>
References: <1424804504-10914-1-git-send-email-andreas.rohner@gmx.net>
 <1424804659-10986-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424804659-10986-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This patch adds support for additional bit-flags to the nilfs_vdesc
structure used by the GC to communicate block information to the
kernel.

The field vd_flags cannot be used for this purpose, because it does
not support bit-flags, and changing that would break backwards
compatibility. Therefore the padding field is renamed to vd_blk_flags
to contain more flags.

Unfortunately older versions of nilfs-utils do not initialize the
padding field to zero. So it is necessary to signal to the kernel if
the new vd_blk_flags field contains usable flags or just random data.
Since the vd_period field is only used in userspace, and is guaranteed
to contain a value that is > 0 (NILFS_CNO_MIN == 1), it can be used to
give the kernel a hint. So if vd_period.p_start is set to 0, the
vd_blk_flags field will be interpreted by the kernel.

The following new flags are added:

NILFS_VDESC_SNAPSHOT:
    The block corresponding to the vdesc structure is protected by a
    snapshot. This information is used in the kernel as well as in
    nilfs-utils to calcualte the number of live blocks in a given
    segment. A block with this flag is counted as live regardless of
    other indicators.

NILFS_VDESC_PROTECTION_PERIOD:
    The block corresponding to the vdesc structure is protected by the
    protection period of the userspace GC. The block is actually
    reclaimable, but for the moment protected. So it has to be
    treated as if it were alive and moved to a new free segment,
    but it must not be counted as live by the kernel. This flag
    indicates to the kernel, that this block should be counted as
    reclaimable.

The nilfs_vdesc_is_live() function is modified to store the
corresponding flags in the vdesc structure. However the algorithm it
uses it not modified, so it should return exactly the same results.

After the nilfs_vdesc_is_live() is called the vd_period field is no
longer needed and set to 0, to indicate to the kernel, that the
vd_blk_flags field should be interpreted. This ensures full backward
compatibility:

Old nilfs2 and new nilfs-utils:
    vd_blk_flags is ignored

New nilfs2 and old nilfs-utils:
    vd_period.p_start > 0 so vd_blk_flags is ignored

New nilfs2 and new nilfs-utils:
    vd_period.p_start == 0 so vd_blk_flags is interpreted

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 include/nilfs2_fs.h | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 lib/gc.c            | 36 ++++++++++++++++++++++++---------
 2 files changed, 83 insertions(+), 11 deletions(-)

diff --git a/include/nilfs2_fs.h b/include/nilfs2_fs.h
index 9137824..d01a924 100644
--- a/include/nilfs2_fs.h
+++ b/include/nilfs2_fs.h
@@ -884,7 +884,7 @@ struct nilfs_vinfo {
  * @vd_blocknr: disk block number
  * @vd_offset: logical block offset inside a file
  * @vd_flags: flags (data or node block)
- * @vd_pad: padding
+ * @vd_blk_flags: additional flags
  */
 struct nilfs_vdesc {
 	__u64 vd_ino;
@@ -894,9 +894,63 @@ struct nilfs_vdesc {
 	__u64 vd_blocknr;
 	__u64 vd_offset;
 	__u32 vd_flags;
-	__u32 vd_pad;
+	/*
+	 * vd_blk_flags needed because vd_flags doesn't support
+	 * bit-flags because of backwards compatibility
+	 */
+	__u32 vd_blk_flags;
 };
 
+/* vdesc flags */
+enum {
+	NILFS_VDESC_DATA,
+	NILFS_VDESC_NODE,
+
+	/* ... */
+};
+enum {
+	NILFS_VDESC_SNAPSHOT,
+	NILFS_VDESC_PROTECTION_PERIOD,
+
+	/* ... */
+
+	__NR_NILFS_VDESC_FIELDS,
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
+	vdesc->vd_blk_flags |= (1UL << NILFS_VDESC_##flag);		\
+}									\
+static inline void							\
+nilfs_vdesc_clear_##name(struct nilfs_vdesc *vdesc)			\
+{									\
+	vdesc->vd_blk_flags &= ~(1UL << NILFS_VDESC_##flag);		\
+}									\
+static inline int							\
+nilfs_vdesc_##name(const struct nilfs_vdesc *vdesc)			\
+{									\
+	return !!(vdesc->vd_blk_flags & (1UL << NILFS_VDESC_##flag));	\
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
index 48c295a..b56744c 100644
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
+			vdesc->vd_blk_flags = 0;
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
@@ -392,7 +395,7 @@ static ssize_t nilfs_get_snapshot(struct nilfs *nilfs, nilfs_cno_t **ssp)
  * @n: size of @ss array
  * @last_hit: the last snapshot number hit
  */
-static int nilfs_vdesc_is_live(const struct nilfs_vdesc *vdesc,
+static int nilfs_vdesc_is_live(struct nilfs_vdesc *vdesc,
 			       nilfs_cno_t protect, const nilfs_cno_t *ss,
 			       size_t n, nilfs_cno_t *last_hit)
 {
@@ -408,18 +411,22 @@ static int nilfs_vdesc_is_live(const struct nilfs_vdesc *vdesc,
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
@@ -435,10 +442,11 @@ static int nilfs_vdesc_is_live(const struct nilfs_vdesc *vdesc,
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
@@ -476,8 +484,18 @@ static int nilfs_toss_vdescs(struct nilfs *nilfs,
 			vdesc = nilfs_vector_get_element(vdescv, j);
 			assert(vdesc != NULL);
 			if (nilfs_vdesc_is_live(vdesc, protcno, ss, n,
-						&last_hit))
+						&last_hit)) {
+				/*
+				 * vd_period is not used any more after this,
+				 * but by setting it to 0 it can be used
+				 * as a flag to the kernel that vd_blk_flags
+				 * is used (old userspace tools didn't
+				 * initialize vd_pad to 0)
+				 */
+				vdesc->vd_period.p_start = 0;
+				vdesc->vd_period.p_end = 0;
 				break;
+			}
 
 			/*
 			 * Add the virtual block number to the candidate
-- 
2.3.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
