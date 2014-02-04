From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] lib/gc.c: refactor reclaim function
Date: Wed,  5 Feb 2014 03:37:25 +0900
Message-ID: <1391539046-13046-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1391539046-13046-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391539046-13046-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Add the following structures and functions to libnilfsgc library
and its header file (i.e. nilfs_gc.h):

 - nilfs_xreclaim_segment() function
 - nilfs_reclaim_params struct
 - nilfs_reclaim_stat struct
 - nilfs_assess_segment() inline function

nilfs_xreclaim_segment() function is the enhanced version of
nilfs_reclaim_segment().  This function takes GC parameters in an
expandable way using nilfs_reclaim_params structure, and outputs
statistics information of garbage collection including count of
live/dead blocks if a valid pointer to nilfs_reclaim_stat structure is
given.  This function also takes a dryrun argument, which allows
callers to get the statistics information without actually doing GC.

Developers can use an inline function nilfs_assess_segment() to get
the statistics information hiding the dryrun option.

Old api function nilfs_reclaim_segment() is still available for
compatibility reason, but the implementation is replaced by
nilfs_xreclaim_segment() function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 include/nilfs_gc.h |   60 ++++++++++++++++++++++++++++
 lib/gc.c           |  111 +++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 156 insertions(+), 15 deletions(-)

diff --git a/include/nilfs_gc.h b/include/nilfs_gc.h
index 72e9947..e49cbf4 100644
--- a/include/nilfs_gc.h
+++ b/include/nilfs_gc.h
@@ -14,10 +14,70 @@
 #include <sys/types.h>
 #include "nilfs.h"
 
+/* flags for nilfs_reclaim_params struct */
+#define NILFS_RECLAIM_PARAM_PROTSEQ	(1UL << 0)
+#define NILFS_RECLAIM_PARAM_PROTCNO	(1UL << 1)
+#define __NR_NILFS_RECLAIM_PARAMS	2
+
+/**
+ * struct nilfs_reclaim_params - structure to specify GC parameters
+ * @flags: flags of valid fields
+ * @reserved: padding bytes
+ * @protseq: start of sequence number of protected segments
+ * @protcno: start number of checkpoint to be protected
+ */
+struct nilfs_reclaim_params {
+	unsigned long flags;
+	unsigned long reserved;
+	__u64 protseq;
+	nilfs_cno_t protcno;
+};
+
+/**
+ * struct nilfs_reclaim_stat - structure to store GC statistics
+ * @exflags: flags for extended fields (reserved)
+ * @cleaned_segs: number of cleaned segments
+ * @protected_segs: number of protected (deselected) segments
+ * @deferred_segs: number of deferred segments
+ * @live_blks: number of live (in-use) blocks
+ * @live_vblks: number of live (in-use) virtual blocks
+ * @live_pblks: number of live (in-use) DAT file blocks
+ * @defunct_blks: number of defunct (reclaimable) blocks
+ * @defunct_vblks: number of defunct (reclaimable) virtual blocks
+ * @defunct_pblks: number of defunct (reclaimable) DAT file blocks
+ * @freed_vblks: number of freed virtual blocks
+ */
+struct nilfs_reclaim_stat {
+	unsigned long exflags;
+	size_t cleaned_segs;
+	size_t protected_segs;
+	size_t deferred_segs;
+	size_t live_blks;
+	size_t live_vblks;
+	size_t live_pblks;
+	size_t defunct_blks;
+	size_t defunct_vblks;
+	size_t defunct_pblks;
+	size_t freed_vblks;
+};
+
 ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
 			      __u64 *segnums, size_t nsegs,
 			      __u64 protseq, nilfs_cno_t protcno);
 
+int nilfs_xreclaim_segment(struct nilfs *nilfs,
+			   __u64 *segnums, size_t nsegs, int dryrun,
+			   const struct nilfs_reclaim_params *params,
+			   struct nilfs_reclaim_stat *stat);
+
+static inline int
+nilfs_assess_segment(struct nilfs *nilfs,
+		     __u64 *segnums, size_t nsegs,
+		     const struct nilfs_reclaim_params *params,
+		     struct nilfs_reclaim_stat *stat)
+{
+	return nilfs_xreclaim_segment(nilfs, segnums, nsegs, 1, params, stat);
+}
 
 static inline int nilfs_suinfo_reclaimable(const struct nilfs_suinfo *si)
 {
diff --git a/lib/gc.c b/lib/gc.c
index 1152299..71c7307 100644
--- a/lib/gc.c
+++ b/lib/gc.c
@@ -601,20 +601,34 @@ static int nilfs_toss_bdescs(struct nilfs_vector *bdescv)
 }
 
 /**
- * nilfs_reclaim_segment - reclaim segments
+ * nilfs_xreclaim_segment - reclaim segments (enhanced API)
  * @nilfs: nilfs object
  * @segnums: array of segment numbers storing selected segments
  * @nsegs: size of the @segnums array
- * @protseq: start of sequence number of protected segments
- * @protcno: start checkpoint number of protected period
+ * @dryrun: dry-run flag
+ * @params: reclaim parameters
+ * @stat: reclaim statistics
  */
-ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
-			      __u64 *segnums, size_t nsegs,
-			      __u64 protseq, nilfs_cno_t protcno)
+int nilfs_xreclaim_segment(struct nilfs *nilfs,
+			   __u64 *segnums, size_t nsegs, int dryrun,
+			   const struct nilfs_reclaim_params *params,
+			   struct nilfs_reclaim_stat *stat)
 {
 	struct nilfs_vector *vdescv, *bdescv, *periodv, *vblocknrv;
 	sigset_t sigset, oldset, waitset;
+	nilfs_cno_t protcno;
 	ssize_t n, ret = -1;
+	size_t nblocks;
+
+	if (!(params->flags & NILFS_RECLAIM_PARAM_PROTSEQ) ||
+	    (params->flags & (~0UL << __NR_NILFS_RECLAIM_PARAMS))) {
+		/*
+		 * The protseq parameter is mandatory.  Unknown
+		 * parameters are rejected.
+		 */
+		errno = EINVAL;
+		return -1;
+	}
 
 	if (nsegs == 0)
 		return 0;
@@ -623,8 +637,7 @@ ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
 	bdescv = nilfs_vector_create(sizeof(struct nilfs_bdesc));
 	periodv = nilfs_vector_create(sizeof(struct nilfs_period));
 	vblocknrv = nilfs_vector_create(sizeof(__u64));
-	if (vdescv == NULL || bdescv == NULL || periodv == NULL ||
-	    vblocknrv == NULL)
+	if (!vdescv || !bdescv || !periodv || !vblocknrv)
 		goto out_vec;
 
 	sigemptyset(&sigset);
@@ -633,7 +646,7 @@ ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
 	ret = sigprocmask(SIG_BLOCK, &sigset, &oldset);
 	if (ret < 0) {
 		nilfs_gc_logger(LOG_ERR, "cannot block signals: %s",
-				     strerror(errno));
+				strerror(errno));
 		goto out_vec;
 	}
 
@@ -641,31 +654,66 @@ ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
 	if (ret < 0)
 		goto out_sig;
 
-	n = nilfs_acc_blocks(nilfs, segnums, nsegs, protseq, vdescv, bdescv);
-	if (n <= 0) {
+	/* count blocks */
+	n = nilfs_acc_blocks(nilfs, segnums, nsegs, params->protseq, vdescv,
+			     bdescv);
+	if (n < 0) {
 		ret = n;
 		goto out_lock;
 	}
+	if (stat) {
+		stat->cleaned_segs = n;
+		stat->protected_segs = nsegs - n;
+		stat->deferred_segs = 0;
+	}
+	if (n == 0) {
+		ret = 0;
+		goto out_lock;
+	}
 
+	/* toss virtual blocks */
 	ret = nilfs_get_vdesc(nilfs, vdescv);
 	if (ret < 0)
 		goto out_lock;
 
+	nblocks = nilfs_vector_get_size(vdescv);
+	protcno = (params->flags & NILFS_RECLAIM_PARAM_PROTCNO) ?
+		params->protcno : NILFS_CNO_MAX;
+
 	ret = nilfs_toss_vdescs(nilfs, vdescv, periodv, vblocknrv, protcno);
 	if (ret < 0)
 		goto out_lock;
 
+	if (stat) {
+		stat->live_vblks = nilfs_vector_get_size(vdescv);
+		stat->defunct_vblks = nblocks - stat->live_vblks;
+		stat->freed_vblks = nilfs_vector_get_size(vblocknrv);
+	}
+
 	nilfs_vector_sort(vdescv, nilfs_comp_vdesc_blocknr);
 	nilfs_unify_period(periodv);
 
+	/* toss DAT file blocks */
 	ret = nilfs_get_bdesc(nilfs, bdescv);
 	if (ret < 0)
 		goto out_lock;
 
+	nblocks = nilfs_vector_get_size(bdescv);
 	ret = nilfs_toss_bdescs(bdescv);
 	if (ret < 0)
 		goto out_lock;
 
+	if (stat) {
+		stat->live_pblks = nilfs_vector_get_size(bdescv);
+		stat->defunct_pblks = nblocks - stat->live_pblks;
+
+		stat->live_blks = stat->live_vblks + stat->live_pblks;
+		stat->defunct_blks = n * nilfs_get_blocks_per_segment(nilfs) -
+			stat->live_blks;
+	}
+	if (dryrun)
+		goto out_lock;
+
 	ret = sigpending(&waitset);
 	if (ret < 0) {
 		nilfs_gc_logger(LOG_ERR, "cannot test signals: %s",
@@ -690,13 +738,14 @@ ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
 	if (ret < 0) {
 		nilfs_gc_logger(LOG_ERR, "cannot clean segments: %s",
 				strerror(errno));
-	} else {
-		ret = n;
 	}
 
 out_lock:
-	if (nilfs_unlock_cleaner(nilfs) < 0)
-		ret = -1;
+	if (nilfs_unlock_cleaner(nilfs) < 0) {
+		nilfs_gc_logger(LOG_CRIT, "failed to unlock cleaner: %s",
+				strerror(errno));
+		exit(1);
+	}
 
 out_sig:
 	sigprocmask(SIG_SETMASK, &oldset, NULL);
@@ -710,6 +759,38 @@ out_vec:
 		nilfs_vector_destroy(periodv);
 	if (vblocknrv != NULL)
 		nilfs_vector_destroy(vblocknrv);
+	/*
+	 * Flags of valid fields in stat->exflags must be unset.
+	 */
+	return ret;
+}
 
+/**
+ * nilfs_reclaim_segment - reclaim segments
+ * @nilfs: nilfs object
+ * @segnums: array of segment numbers storing selected segments
+ * @nsegs: size of the @segnums array
+ * @protseq: start of sequence number of protected segments
+ * @protcno: start checkpoint number of protected period
+ */
+ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
+			      __u64 *segnums, size_t nsegs,
+			      __u64 protseq, nilfs_cno_t protcno)
+{
+	struct nilfs_reclaim_params params;
+	struct nilfs_reclaim_stat stat;
+	int ret;
+
+	params.flags =
+		NILFS_RECLAIM_PARAM_PROTSEQ | NILFS_RECLAIM_PARAM_PROTCNO;
+	params.reserved = 0;
+	params.protseq = protseq;
+	params.protcno = protcno;
+	memset(&stat, 0, sizeof(stat));
+
+	ret = nilfs_xreclaim_segment(nilfs, segnums, nsegs, 0,
+				     &params, &stat);
+	if (!ret)
+		ret = stat.cleaned_segs;
 	return ret;
 }
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
