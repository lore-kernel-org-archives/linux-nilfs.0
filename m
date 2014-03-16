From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 3/4] nilfs-utils: add support for nilfs_clean_snapshot_flags()
Date: Sun, 16 Mar 2014 11:49:17 +0100
Message-ID: <3a7b518a3a51b86b6f56e8bd0545e0790f93964f.1394966935.git.andreas.rohner@gmx.net>
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

This ioctl enables the userspace GC to perform a cleanup operation after
setting the number of blocks with NILFS_IOCTL_SET_SUINFO. It sets DAT
entries with de_ss values of NILFS_CNO_MAX to 0. NILFS_CNO_MAX
indicates, that the corresponding block belongs to some snapshot, but
was already decremented by a previous deletion operation. If the segment
usage info is changed with NILFS_IOCTL_SET_SUINFO and the number of
blocks is updated, then these blocks would never be decremented and
there are scenarios where the corresponding segments would starve (never
be cleaned). To prevent that the value of de_ss must be set to 0, so
that it can be decremented again, should the snapshot be deleted in the
future.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 include/nilfs.h     |  2 ++
 include/nilfs2_fs.h |  2 ++
 lib/gc.c            |  6 +++++-
 lib/nilfs.c         | 23 +++++++++++++++++++++++
 4 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/include/nilfs.h b/include/nilfs.h
index 05cfe3b..bd134be 100644
--- a/include/nilfs.h
+++ b/include/nilfs.h
@@ -313,6 +313,8 @@ ssize_t nilfs_get_bdescs(const struct nilfs *, struct nilfs_bdesc *, size_t);
 int nilfs_clean_segments(struct nilfs *, struct nilfs_vdesc *, size_t,
 			 struct nilfs_period *, size_t, __u64 *, size_t,
 			 struct nilfs_bdesc *, size_t, __u64 *, size_t);
+int nilfs_clean_snapshot_flags(struct nilfs *nilfs,
+			       struct nilfs_vdesc *vdescs, size_t nvdescs);
 int nilfs_sync(const struct nilfs *, nilfs_cno_t *);
 int nilfs_resize(struct nilfs *nilfs, off_t size);
 int nilfs_set_alloc_range(struct nilfs *nilfs, off_t start, off_t end);
diff --git a/include/nilfs2_fs.h b/include/nilfs2_fs.h
index 967c2af..cb02739 100644
--- a/include/nilfs2_fs.h
+++ b/include/nilfs2_fs.h
@@ -918,5 +918,7 @@ struct nilfs_bdesc {
 	_IOW(NILFS_IOCTL_IDENT, 0x8C, __u64[2])
 #define NILFS_IOCTL_SET_SUINFO  \
 	_IOW(NILFS_IOCTL_IDENT, 0x8D, struct nilfs_argv)
+#define NILFS_IOCTL_CLEAN_SNAPSHOT_FLAGS  \
+	_IOW(NILFS_IOCTL_IDENT, 0x8F, struct nilfs_argv)
 
 #endif	/* _LINUX_NILFS_FS_H */
diff --git a/lib/gc.c b/lib/gc.c
index a165a5c..2338174 100644
--- a/lib/gc.c
+++ b/lib/gc.c
@@ -762,8 +762,12 @@ int nilfs_xreclaim_segment(struct nilfs *nilfs,
 
 		ret = nilfs_set_suinfo(nilfs, nilfs_vector_get_data(supv), n);
 
-		if (ret == 0)
+		if (ret == 0) {
+			ret = nilfs_clean_snapshot_flags(nilfs,
+					nilfs_vector_get_data(vdescv),
+					nilfs_vector_get_size(vdescv));
 			goto out_lock;
+		}
 
 		if (ret < 0 && errno != ENOTTY) {
 			nilfs_gc_logger(LOG_ERR, "cannot set suinfo: %s",
diff --git a/lib/nilfs.c b/lib/nilfs.c
index e8f5c96..b909a23 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -743,6 +743,29 @@ int nilfs_clean_segments(struct nilfs *nilfs,
 }
 
 /**
+ * nilfs_clean_snapshot_flags - cleanup snapshot flags after set_suinfo
+ * @nilfs: nilfs object
+ * @vdescs: array of nilfs_vdesc structs to specify live blocks
+ * @nvdescs: size of @vdescs array (number of items)
+ */
+int nilfs_clean_snapshot_flags(struct nilfs *nilfs,
+			       struct nilfs_vdesc *vdescs, size_t nvdescs)
+{
+	struct nilfs_argv argv;
+
+	if (nilfs->n_iocfd < 0) {
+		errno = EBADF;
+		return -1;
+	}
+
+	memset(&argv, 0, sizeof(struct nilfs_argv));
+	argv.v_base = (unsigned long)vdescs;
+	argv.v_nmembs = nvdescs;
+	argv.v_size = sizeof(struct nilfs_vdesc);
+	return ioctl(nilfs->n_iocfd, NILFS_IOCTL_CLEAN_SNAPSHOT_FLAGS, &argv);
+}
+
+/**
  * nilfs_sync - sync a NILFS file system
  * @nilfs: nilfs object
  * @cnop: buffer to store the latest checkpoint number in
-- 
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
