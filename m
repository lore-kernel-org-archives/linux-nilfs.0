From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 4/6] nilfs2: add ioctl() to clean snapshot flags from dat entries
Date: Sun, 16 Mar 2014 11:47:37 +0100
Message-ID: <be7d3bd13015117222aac43194c0fdb9c5d0046f.1394966729.git.andreas.rohner@gmx.net>
References: <cover.1394966728.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1394966728.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
In-Reply-To: <cover.1394966728.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
References: <cover.1394966728.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This patch introduces new flags for nilfs_vdesc to indicate the reason a
block is alive. So if the block would be reclaimable, but must be
treated as if it were alive, because it is part of a snapshot, then the
snapshot flag is set.

Additionally a new ioctl() is added, which enables the userspace GC to
perform a cleanup operation after setting the number of blocks with
NILFS_IOCTL_SET_SUINFO. It sets DAT entries with de_ss values of
NILFS_CNO_MAX to 0. NILFS_CNO_MAX indicates, that the corresponding
block belongs to some snapshot, but was already decremented by a
previous deletion operation. If the segment usage info is changed with
NILFS_IOCTL_SET_SUINFO and the number of blocks is updated, then these
blocks would never be decremented and there are scenarios where the
corresponding segments would starve (never be cleaned). To prevent that
they must be reset to 0.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/dat.c           |  63 ++++++++++++++++++++++++++++
 fs/nilfs2/dat.h           |   1 +
 fs/nilfs2/ioctl.c         | 103 +++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/nilfs2_fs.h |  52 ++++++++++++++++++++++-
 4 files changed, 216 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 89a4a5f..7adb15d 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -382,6 +382,69 @@ int nilfs_dat_move(struct inode *dat, __u64 vblocknr, sector_t blocknr)
 }
 
 /**
+ * nilfs_dat_clean_snapshot_flag - check flags used by snapshots
+ * @dat: DAT file inode
+ * @vblocknr: virtual block number
+ *
+ * Description: nilfs_dat_clean_snapshot_flag() changes the flags from
+ * NILFS_CNO_MAX to 0 if necessary, so that segment usage is accurately
+ * counted. NILFS_CNO_MAX indicates, that the corresponding block belongs
+ * to some snapshot, but was already decremented. If the segment usage info
+ * is changed with NILFS_IOCTL_SET_SUINFO and the number of blocks is updated,
+ * then these blocks would never be decremented and there are scenarios where
+ * the corresponding segments would starve (never be cleaned).
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ */
+int nilfs_dat_clean_snapshot_flag(struct inode *dat, __u64 vblocknr)
+{
+	struct buffer_head *entry_bh;
+	struct nilfs_dat_entry *entry;
+	void *kaddr;
+	int ret;
+
+	ret = nilfs_palloc_get_entry_block(dat, vblocknr, 0, &entry_bh);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * The given disk block number (blocknr) is not yet written to
+	 * the device at this point.
+	 *
+	 * To prevent nilfs_dat_translate() from returning the
+	 * uncommitted block number, this makes a copy of the entry
+	 * buffer and redirects nilfs_dat_translate() to the copy.
+	 */
+	if (!buffer_nilfs_redirected(entry_bh)) {
+		ret = nilfs_mdt_freeze_buffer(dat, entry_bh);
+		if (ret) {
+			brelse(entry_bh);
+			return ret;
+		}
+	}
+
+	kaddr = kmap_atomic(entry_bh->b_page);
+	entry = nilfs_palloc_block_get_entry(dat, vblocknr, entry_bh, kaddr);
+	if (entry->de_ss == cpu_to_le64(NILFS_CNO_MAX)) {
+		entry->de_ss = cpu_to_le64(0);
+		kunmap_atomic(kaddr);
+		mark_buffer_dirty(entry_bh);
+		nilfs_mdt_mark_dirty(dat);
+	} else {
+		kunmap_atomic(kaddr);
+	}
+
+	brelse(entry_bh);
+
+	return 0;
+}
+
+/**
  * nilfs_dat_translate - translate a virtual block number to a block number
  * @dat: DAT file inode
  * @vblocknr: virtual block number
diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
index 92a187e..a528024 100644
--- a/fs/nilfs2/dat.h
+++ b/fs/nilfs2/dat.h
@@ -51,6 +51,7 @@ void nilfs_dat_abort_update(struct inode *, struct nilfs_palloc_req *,
 int nilfs_dat_mark_dirty(struct inode *, __u64);
 int nilfs_dat_freev(struct inode *, __u64 *, size_t);
 int nilfs_dat_move(struct inode *, __u64, sector_t);
+int nilfs_dat_clean_snapshot_flag(struct inode *, __u64);
 ssize_t nilfs_dat_get_vinfo(struct inode *, void *, unsigned, size_t);
 
 int nilfs_dat_read(struct super_block *sb, size_t entry_size,
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 422fb54..0b62bf4 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -578,7 +578,7 @@ static int nilfs_ioctl_move_inode_block(struct inode *inode,
 	struct buffer_head *bh;
 	int ret;
 
-	if (vdesc->vd_flags == 0)
+	if (nilfs_vdesc_data(vdesc))
 		ret = nilfs_gccache_submit_read_data(
 			inode, vdesc->vd_offset, vdesc->vd_blocknr,
 			vdesc->vd_vblocknr, &bh);
@@ -662,6 +662,14 @@ static int nilfs_ioctl_move_blocks(struct super_block *sb,
 		}
 
 		do {
+			/*
+			 * old user space tools to not initialize vd_flags2
+			 * check if it contains invalid flags
+			 */
+			if (vdesc->vd_flags2 &
+					(~0UL << __NR_NILFS_VDESC_FIELDS))
+				vdesc->vd_flags2 = 0;
+
 			ret = nilfs_ioctl_move_inode_block(inode, vdesc,
 							   &buffers);
 			if (unlikely(ret < 0)) {
@@ -984,6 +992,96 @@ out:
 }
 
 /**
+ * nilfs_ioctl_clean_snapshot_flags - clean dat entries with invalid de_ss
+ * @inode: inode object
+ * @filp: file object
+ * @cmd: ioctl's request code
+ * @argp: pointer on argument from userspace
+ *
+ * Description: nilfs_ioctl_clean_snapshot_flags() sets DAT entries with de_ss
+ * values of NILFS_CNO_MAX to 0. NILFS_CNO_MAX indicates, that the
+ * corresponding block belongs to some snapshot, but was already decremented.
+ * If the segment usage info is changed with NILFS_IOCTL_SET_SUINFO and the
+ * number of blocks is updated, then these blocks would never be decremented
+ * and there are scenarios where the corresponding segments would starve (never
+ * be cleaned).
+ *
+ * Return Value: On success, 0 is returned or error code, otherwise.
+ */
+static int nilfs_ioctl_clean_snapshot_flags(struct inode *inode,
+					    struct file *filp,
+					    unsigned int cmd,
+					    void __user *argp)
+{
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	struct nilfs_transaction_info ti;
+	struct nilfs_argv argv;
+	struct nilfs_vdesc *vdesc;
+	size_t len, i;
+	void __user *base;
+	void *kbuf;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ret = mnt_want_write_file(filp);
+	if (ret)
+		return ret;
+
+	ret = -EFAULT;
+	if (copy_from_user(&argv, argp, sizeof(struct nilfs_argv)))
+		goto out;
+
+	ret = -EINVAL;
+	if (argv.v_size != sizeof(struct nilfs_vdesc))
+		goto out;
+	if (argv.v_nmembs > UINT_MAX / sizeof(struct nilfs_vdesc))
+		goto out;
+
+	len = argv.v_size * argv.v_nmembs;
+	if (!len) {
+		ret = 0;
+		goto out;
+	}
+
+	base = (void __user *)(unsigned long)argv.v_base;
+	kbuf = vmalloc(len);
+	if (!kbuf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (copy_from_user(kbuf, base, len)) {
+		ret = -EFAULT;
+		goto out_free;
+	}
+
+	ret = nilfs_transaction_begin(inode->i_sb, &ti, 0);
+	if (unlikely(ret))
+		goto out_free;
+
+	for (i = 0, vdesc = kbuf; i < argv.v_nmembs; ++i, ++vdesc) {
+		if (nilfs_vdesc_snapshot(vdesc)) {
+			ret = nilfs_dat_clean_snapshot_flag(nilfs->ns_dat,
+					vdesc->vd_vblocknr);
+			if (ret) {
+				nilfs_transaction_abort(inode->i_sb);
+				goto out_free;
+			}
+		}
+	}
+
+	nilfs_transaction_commit(inode->i_sb);
+
+out_free:
+	vfree(kbuf);
+out:
+	mnt_drop_write_file(filp);
+	return ret;
+}
+
+/**
  * nilfs_ioctl_sync - make a checkpoint
  * @inode: inode object
  * @filp: file object
@@ -1332,6 +1430,8 @@ long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return nilfs_ioctl_get_bdescs(inode, filp, cmd, argp);
 	case NILFS_IOCTL_CLEAN_SEGMENTS:
 		return nilfs_ioctl_clean_segments(inode, filp, cmd, argp);
+	case NILFS_IOCTL_CLEAN_SNAPSHOT_FLAGS:
+		return nilfs_ioctl_clean_snapshot_flags(inode, filp, cmd, argp);
 	case NILFS_IOCTL_SYNC:
 		return nilfs_ioctl_sync(inode, filp, cmd, argp);
 	case NILFS_IOCTL_RESIZE:
@@ -1368,6 +1468,7 @@ long nilfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case NILFS_IOCTL_GET_VINFO:
 	case NILFS_IOCTL_GET_BDESCS:
 	case NILFS_IOCTL_CLEAN_SEGMENTS:
+	case NILFS_IOCTL_CLEAN_SNAPSHOT_FLAGS:
 	case NILFS_IOCTL_SYNC:
 	case NILFS_IOCTL_RESIZE:
 	case NILFS_IOCTL_SET_ALLOC_RANGE:
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index ba9ebe02..30ddc86 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -863,7 +863,7 @@ struct nilfs_vinfo {
  * @vd_blocknr: disk block number
  * @vd_offset: logical block offset inside a file
  * @vd_flags: flags (data or node block)
- * @vd_pad: padding
+ * @vd_flags2: additional flags
  */
 struct nilfs_vdesc {
 	__u64 vd_ino;
@@ -873,9 +873,55 @@ struct nilfs_vdesc {
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
+
 /**
  * struct nilfs_bdesc - descriptor of disk block number
  * @bd_ino: inode number
@@ -922,5 +968,7 @@ struct nilfs_bdesc {
 	_IOW(NILFS_IOCTL_IDENT, 0x8C, __u64[2])
 #define NILFS_IOCTL_SET_SUINFO  \
 	_IOW(NILFS_IOCTL_IDENT, 0x8D, struct nilfs_argv)
+#define NILFS_IOCTL_CLEAN_SNAPSHOT_FLAGS  \
+	_IOW(NILFS_IOCTL_IDENT, 0x8F, struct nilfs_argv)
 
 #endif	/* _LINUX_NILFS_FS_H */
-- 
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
