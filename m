From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v2 4/5] nilfs-utils: add support for NILFS_IOCTL_SET_SUINFO ioctl
Date: Tue, 21 Jan 2014 14:59:43 +0100
Message-ID: <72f8c37258d08ba9793b0c1bb0374dd8efcd4756.1390310509.git.andreas.rohner@gmx.net>
References: <cover.1390310509.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1390310509.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
In-Reply-To: <cover.1390310509.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
References: <cover.1390310509.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

With this ioctl the segment usage information in the SUFILE can be
updated from userspace.

This is useful, because it allows the GC to modify and update segment
usage entries for specific segments, which enables it to avoid
unnecessary write operations.

If a segment needs to be cleaned, but there is no or very little free
space to be gained, the cleaning operation basically degrades to
needless expensive copying of data. In the end the only thing that
changes is the location of the data and a timestamp in the segment
usage info. With this ioctl the GC can skip the copying and update the
segment usage entries directly instead.

Additionally this patch implements a simple check in
nilfs_reclaim_segment. If the number of free blocks that can be gained
by cleaning the segments is below the threshold of minblocks, it simply
updates the segment usage information instead.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 include/nilfs.h     |  2 ++
 include/nilfs2_fs.h | 41 +++++++++++++++++++++++++++++++++++++++++
 lib/gc.c            | 44 +++++++++++++++++++++++++++++++++++++++++++-
 lib/nilfs.c         | 26 ++++++++++++++++++++++++++
 4 files changed, 112 insertions(+), 1 deletion(-)

diff --git a/include/nilfs.h b/include/nilfs.h
index 56286a9..1e9b034 100644
--- a/include/nilfs.h
+++ b/include/nilfs.h
@@ -299,6 +299,8 @@ int nilfs_delete_checkpoint(struct nilfs *, nilfs_cno_t);
 int nilfs_get_cpstat(const struct nilfs *, struct nilfs_cpstat *);
 ssize_t nilfs_get_suinfo(const struct nilfs *, __u64, struct nilfs_suinfo *,
 			 size_t);
+ssize_t nilfs_set_suinfo(const struct nilfs *, struct nilfs_suinfo_update *,
+			 size_t);
 int nilfs_get_sustat(const struct nilfs *, struct nilfs_sustat *);
 ssize_t nilfs_get_vinfo(const struct nilfs *, struct nilfs_vinfo *, size_t);
 ssize_t nilfs_get_bdescs(const struct nilfs *, struct nilfs_bdesc *, size_t);
diff --git a/include/nilfs2_fs.h b/include/nilfs2_fs.h
index e674f44..181c482 100644
--- a/include/nilfs2_fs.h
+++ b/include/nilfs2_fs.h
@@ -713,6 +713,45 @@ static inline int nilfs_suinfo_clean(const struct nilfs_suinfo *si)
 	return !si->sui_flags;
 }
 
+/**
+ * nilfs_suinfo_update - segment usage information update
+ * @sup_segnum: segment number
+ * @sup_flags: flags for which fields are active in sup_sui
+ * @sup_sui: segment usage information
+ */
+struct nilfs_suinfo_update {
+	__u64 sup_segnum;
+	__u32 sup_flags;
+	struct nilfs_suinfo sup_sui;
+};
+
+enum {
+	NILFS_SUINFO_UPDATE_LASTMOD,
+	NILFS_SUINFO_UPDATE_NBLOCKS,
+	NILFS_SUINFO_UPDATE_FLAGS,
+};
+
+#define NILFS_SUINFO_UPDATE_FNS(flag, name)				\
+static inline void							\
+nilfs_suinfo_update_set_##name(struct nilfs_suinfo_update *sup)		\
+{									\
+	sup->sup_flags |= 1UL << NILFS_SUINFO_UPDATE_##flag;		\
+}									\
+static inline void							\
+nilfs_suinfo_update_clear_##name(struct nilfs_suinfo_update *sup)	\
+{									\
+	sup->sup_flags &= ~(1UL << NILFS_SUINFO_UPDATE_##flag);		\
+}									\
+static inline int							\
+nilfs_suinfo_update_##name(const struct nilfs_suinfo_update *sup)	\
+{									\
+	return !!(sup->sup_flags & (1UL << NILFS_SUINFO_UPDATE_##flag));\
+}
+
+NILFS_SUINFO_UPDATE_FNS(LASTMOD, lastmod)
+NILFS_SUINFO_UPDATE_FNS(NBLOCKS, nblocks)
+NILFS_SUINFO_UPDATE_FNS(FLAGS, flags)
+
 /* ioctl */
 enum {
 	NILFS_CHECKPOINT,
@@ -867,5 +906,7 @@ struct nilfs_bdesc {
 	_IOW(NILFS_IOCTL_IDENT, 0x8B, __u64)
 #define NILFS_IOCTL_SET_ALLOC_RANGE  \
 	_IOW(NILFS_IOCTL_IDENT, 0x8C, __u64[2])
+#define NILFS_IOCTL_SET_SUINFO  \
+	_IOW(NILFS_IOCTL_IDENT, 0x8D, struct nilfs_argv)
 
 #endif	/* _LINUX_NILFS_FS_H */
diff --git a/lib/gc.c b/lib/gc.c
index 0b0e2d6..ebbe0ca 100644
--- a/lib/gc.c
+++ b/lib/gc.c
@@ -29,6 +29,10 @@
 #include <syslog.h>
 #endif	/* HAVE_SYSLOG_H */
 
+#if HAVE_SYS_TIME_H
+#include <sys/time.h>
+#endif	/* HAVE_SYS_TIME */
+
 #include <errno.h>
 #include <assert.h>
 #include <stdarg.h>
@@ -615,7 +619,10 @@ ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
 {
 	struct nilfs_vector *vdescv, *bdescv, *periodv, *vblocknrv;
 	sigset_t sigset, oldset, waitset;
-	ssize_t n, ret = -1;
+	ssize_t n, i, ret = -1;
+	__u32 freeblocks;
+	struct nilfs_suinfo_update *supv;
+	struct timeval tv;
 
 	if (nsegs == 0)
 		return 0;
@@ -678,6 +685,41 @@ ssize_t nilfs_reclaim_segment(struct nilfs *nilfs,
 		goto out_lock;
 	}
 
+	freeblocks = (nilfs_get_blocks_per_segment(nilfs) * n)
+				- (nilfs_vector_get_size(vdescv)
+				+ nilfs_vector_get_size(bdescv));
+
+	/* if there are less free blocks than the
+	 * minimal threshold try to update suinfo
+	 * instead of cleaning */
+	if (freeblocks < minblocks * n) {
+		ret = gettimeofday(&tv, NULL);
+		if (ret < 0)
+			goto out_lock;
+
+		supv = malloc(sizeof(struct nilfs_suinfo_update) * n);
+		if (supv == NULL) {
+			ret = -1;
+			goto out_lock;
+		}
+
+		for (i = 0; i < n; ++i) {
+			supv[i].sup_segnum = segnums[i];
+			supv[i].sup_flags = 0;
+			nilfs_suinfo_update_set_lastmod(&supv[i]);
+			supv[i].sup_sui.sui_lastmod = tv.tv_sec;
+		}
+
+		ret = nilfs_set_suinfo(nilfs, supv, n);
+		free(supv);
+		if (ret >= 0) {
+			/* success, tell caller
+			 * to try another segment/s */
+			ret = -EGCTRYAGAIN;
+			goto out_lock;
+		}
+	}
+
 	ret = nilfs_clean_segments(nilfs,
 				   nilfs_vector_get_data(vdescv),
 				   nilfs_vector_get_size(vdescv),
diff --git a/lib/nilfs.c b/lib/nilfs.c
index 7265830..dbd03e6 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -548,6 +548,32 @@ ssize_t nilfs_get_suinfo(const struct nilfs *nilfs, __u64 segnum,
 }
 
 /**
+ * nilfs_set_suinfo -
+ * @nilfs:
+ * @sup: an array of nilfs_suinfo_update structs
+ * @nsup: number of elements in sup
+ */
+ssize_t nilfs_set_suinfo(const struct nilfs *nilfs,
+			 struct nilfs_suinfo_update *sup, size_t nsup)
+{
+	struct nilfs_argv argv;
+
+	if (nilfs->n_iocfd < 0) {
+		errno = EBADF;
+		return -1;
+	}
+
+	argv.v_base = (unsigned long)sup;
+	argv.v_nmembs = nsup;
+	argv.v_size = sizeof(struct nilfs_suinfo_update);
+	argv.v_index = 0;
+	argv.v_flags = 0;
+	if (ioctl(nilfs->n_iocfd, NILFS_IOCTL_SET_SUINFO, &argv) < 0)
+		return -1;
+	return argv.v_nmembs;
+}
+
+/**
  * nilfs_get_sustat -
  * @nilfs:
  * @sustat:
-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
