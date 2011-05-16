From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 5/9] nilfs2: add ioctl to compare two checkpoints and get their changes
Date: Mon, 16 May 2011 18:05:18 +0900
Message-ID: <1305536722-1311-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1305536722-1311-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305536722-1311-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This adds NILFS_IOCTL_COMPARE_CHECKPOINTS ioctl command which are
intended to enumerate changed inodes between two checkpoints.  This
implements the API by comparing two ifiles and scanning inodes on the
modifed blocks with prepared comparison routines.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c         |  123 +++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/ioctl.c         |   59 +++++++++++++++++++++
 fs/nilfs2/nilfs.h         |    6 ++
 fs/nilfs2/super.c         |   49 ++++++++++++++++++
 include/linux/nilfs2_fs.h |   43 ++++++++++++++++
 5 files changed, 280 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 587f184..8e19c0b 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -1067,3 +1067,126 @@ int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	mutex_unlock(&inode->i_mutex);
 	return ret;
 }
+
+static void nilfs_scan_inode_changes(struct nilfs_ifile_change *ifc,
+				     struct nilfs_inode_change *ic,
+				     size_t offset)
+{
+	struct nilfs_inode *raw_inode1, *raw_inode2;
+	void *kaddr1, *kaddr2;
+	int i;
+
+	ic->ic_ino = ifc->ino;
+	ic->ic_flags = 0;
+	ic->ic_attr = 0;
+
+	if (!ifc->bh1) {
+		if (ifc->bh2)
+			ic->ic_flags = NILFS_IC_CREATE;
+	} else if (!ifc->bh2) {
+		ic->ic_flags = NILFS_IC_DELETE;
+	} else {
+		kaddr1 = kmap_atomic(ifc->bh1->b_page, KM_USER0);
+		raw_inode1 = kaddr1 + bh_offset(ifc->bh1) + offset;
+
+		kaddr2 = kmap_atomic(ifc->bh2->b_page, KM_USER1);
+		raw_inode2 = kaddr2 + bh_offset(ifc->bh2) + offset;
+
+		if (raw_inode1->i_links_count != raw_inode2->i_links_count)
+			ic->ic_flags |= NILFS_IC_LINKCOUNT;
+
+		for (i = 0; i < NILFS_INODE_BMAP_SIZE; i++) {
+			if (raw_inode1->i_bmap[i] != raw_inode2->i_bmap[i]) {
+				ic->ic_flags |= NILFS_IC_DATA;
+				break;
+			}
+		}
+
+		if (raw_inode1->i_flags != raw_inode2->i_flags)
+			ic->ic_flags |= NILFS_IC_FS_FLAGS;
+
+		if (raw_inode1->i_generation != raw_inode2->i_generation)
+			ic->ic_flags |= (NILFS_IC_GENERATION |
+					 NILFS_IC_DELETE | NILFS_IC_CREATE);
+#if 0
+		if (raw_inode1->i_xattr != raw_inode2->i_xattr)
+			ic->ic_flags |= NILFS_IC_XATTR;
+#endif
+		if (raw_inode1->i_mode != raw_inode2->i_mode)
+			ic->ic_attr |= ATTR_MODE;
+
+		if (raw_inode1->i_uid != raw_inode2->i_uid)
+			ic->ic_attr |= ATTR_UID;
+
+		if (raw_inode1->i_gid != raw_inode2->i_gid)
+			ic->ic_attr |= ATTR_GID;
+
+		if (raw_inode1->i_size != raw_inode2->i_size)
+			ic->ic_attr |= ATTR_SIZE;
+
+		if (raw_inode1->i_mtime_nsec != raw_inode2->i_mtime_nsec ||
+		    raw_inode1->i_mtime != raw_inode2->i_mtime)
+			ic->ic_attr |= ATTR_MTIME;
+
+		if (raw_inode1->i_ctime_nsec != raw_inode2->i_ctime_nsec ||
+		    raw_inode1->i_ctime != raw_inode2->i_ctime)
+			ic->ic_attr |= ATTR_CTIME;
+
+		kunmap_atomic(kaddr2, KM_USER1);
+		kunmap_atomic(kaddr1, KM_USER0);
+	}
+
+	brelse(ifc->bh1);
+	brelse(ifc->bh2);
+}
+
+/**
+ * nilfs_compare_inodes - lookup inode changes between two checkpoints
+ * @sb: super block instance
+ * @root1: root object of source checkpoint
+ * @root2: root object of target checkpoint
+ * @start: start inode number
+ * @changes: array of nilfs_inode_change structures to store results
+ * @maxchanges: maximum number of @changes array
+ */
+ssize_t nilfs_compare_inodes(struct super_block *sb, struct nilfs_root *root1,
+			     struct nilfs_root *root2, ino_t start,
+			     struct nilfs_inode_change *changes,
+			     size_t maxchanges)
+{
+	struct nilfs_ifile_change *ibuf;
+	unsigned ninodes_per_block;
+	size_t isz, maxifc, count, offset_bytes;
+	ssize_t i, nc = 0, n;
+
+	ibuf = (struct nilfs_ifile_change *)__get_free_pages(GFP_NOFS, 0);
+	if (unlikely(!ibuf))
+		return -ENOMEM;
+
+	maxifc = PAGE_SIZE / sizeof(*ibuf);
+	isz = NILFS_MDT(root1->ifile)->mi_entry_size;
+	ninodes_per_block = NILFS_MDT(root1->ifile)->mi_entries_per_block;
+
+	do {
+		count = min_t(size_t, maxchanges - nc, maxifc);
+		n = nilfs_ifile_compare(root1->ifile, root2->ifile, start,
+					ibuf, count);
+		if (n < 0) {
+			nc = n;
+			break;
+		}
+		if (n == 0)
+			break;
+		for (i = 0; i < n; i++, nc++) {
+			offset_bytes = (ibuf[i].ino % ninodes_per_block) * isz;
+
+			nilfs_scan_inode_changes(&ibuf[i], &changes[nc],
+						 offset_bytes);
+		}
+		start = ibuf[n - 1].ino + 1;
+
+	} while (n == count && nc < maxchanges);
+
+	free_pages((unsigned long)ibuf, 0);
+	return nc;
+}
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 41d6743..79f3719 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -755,6 +755,63 @@ out:
 	return ret;
 }
 
+/**
+ * nilfs_ioctl_compare_checkpoints - look up changes between two checkpoints
+ * @inode: inode
+ * @argp: pointer to nilfs_comp_args structure
+ */
+static int nilfs_ioctl_compare_checkpoints(struct inode *inode,
+					   void __user *argp)
+{
+	struct nilfs_comp_args cmpargs;
+	void *kbuf;
+	void __user *base;
+	int ret;
+
+	ret = -EPERM;
+	if (!capable(CAP_SYS_ADMIN))
+		goto out;
+
+	ret = -EFAULT;
+	if (copy_from_user(&cmpargs, argp, sizeof(cmpargs)))
+		goto out;
+
+	ret = -EOPNOTSUPP;
+	if (cmpargs.argv.v_flags != NILFS_COMPARE_INODES)
+		goto out;
+
+	ret = -EINVAL;
+	if (cmpargs.argv.v_size != sizeof(struct nilfs_inode_change))
+		goto out;
+
+	ret = 0;
+	if (cmpargs.argv.v_nmembs == 0)
+		goto out;
+
+	base = (void __user *)(unsigned long)cmpargs.argv.v_base;
+	kbuf = vmalloc(cmpargs.argv.v_size * cmpargs.argv.v_nmembs);
+	if (!kbuf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = nilfs_compare_fs(inode->i_sb, cmpargs.cno1, cmpargs.cno2,
+			       &cmpargs.argv, kbuf);
+
+	if (!ret && copy_to_user(base, kbuf,
+				 cmpargs.argv.v_nmembs * cmpargs.argv.v_size))
+			 /* v_nmembs has the number of acquired entries */
+		ret = -EFAULT;
+
+	vfree(kbuf);
+
+	if (!ret && copy_to_user(&((struct nilfs_comp_args *)argp)->argv,
+				 &cmpargs.argv, sizeof(cmpargs.argv)))
+		ret = -EFAULT;
+out:
+	return ret;
+}
+
 static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
 				unsigned int cmd, void __user *argp,
 				size_t membsz,
@@ -824,6 +881,8 @@ long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return nilfs_ioctl_resize(inode, filp, argp);
 	case NILFS_IOCTL_SET_ALLOC_RANGE:
 		return nilfs_ioctl_set_alloc_range(inode, argp);
+	case NILFS_IOCTL_COMPARE_CHECKPOINTS:
+		return nilfs_ioctl_compare_checkpoints(inode, argp);
 	default:
 		return -ENOTTY;
 	}
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index a9c6a53..56ca055 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -272,6 +272,10 @@ extern int nilfs_mark_inode_dirty(struct inode *);
 extern void nilfs_dirty_inode(struct inode *);
 int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		 __u64 start, __u64 len);
+ssize_t nilfs_compare_inodes(struct super_block *sb, struct nilfs_root *root1,
+			     struct nilfs_root *root2, ino_t start,
+			     struct nilfs_inode_change *changes,
+			     size_t maxchanges);
 
 /* super.c */
 extern struct inode *nilfs_alloc_inode(struct super_block *);
@@ -296,6 +300,8 @@ int nilfs_resize_fs(struct super_block *sb, __u64 newsize);
 int nilfs_attach_checkpoint(struct super_block *sb, __u64 cno, int curr_mnt,
 			    struct nilfs_root **root);
 int nilfs_checkpoint_is_mounted(struct super_block *sb, __u64 cno);
+int nilfs_compare_fs(struct super_block *sb, __u64 cno1, __u64 cno2,
+		     struct nilfs_argv *argv, void *changes);
 
 /* gcinode.c */
 int nilfs_gccache_submit_read_data(struct inode *, sector_t, sector_t, __u64,
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 8351c44..520d7e9 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -476,6 +476,55 @@ out:
 	return ret;
 }
 
+/**
+ * nilfs_compare_fs - lookup file system changes between two checkpoints
+ * @sb: super block instance
+ * @cno1: source checkpoint number
+ * @cno2: target checkpoint number
+ * @argv: nilfs_argv structure
+ * @changes: buffer to store array of nilfs_inode_change structures or so
+ */
+int nilfs_compare_fs(struct super_block *sb, __u64 cno1, __u64 cno2,
+		     struct nilfs_argv *argv, void *changes)
+{
+	struct nilfs_root *root1, *root2;
+	int ret;
+
+	if (cno1 == 0 || cno2 == 0 || cno1 > cno2)
+		return -EINVAL;
+
+	if (cno1 == cno2) {
+		argv->v_nmembs = 0;
+		return 0;
+	}
+
+	down_read(&sb->s_umount);
+
+	ret = nilfs_attach_checkpoint(sb, cno1, false, &root1);
+	if (ret < 0)
+		goto out_unlock;
+
+	ret = nilfs_attach_checkpoint(sb, cno2, false, &root2);
+	if (ret < 0) {
+		nilfs_put_root(root1);
+		goto out_unlock;
+	}
+
+	ret = nilfs_compare_inodes(sb, root1, root2, argv->v_index, changes,
+				   argv->v_nmembs);
+	if (ret >= 0) {
+		argv->v_nmembs = ret;
+		ret = 0;
+	}
+
+	nilfs_put_root(root2);
+	nilfs_put_root(root1);
+
+out_unlock:
+	up_read(&sb->s_umount);
+	return ret;
+}
+
 static void nilfs_put_super(struct super_block *sb)
 {
 	struct the_nilfs *nilfs = sb->s_fs_info;
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 7454ad7..ae49b20 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -821,6 +821,47 @@ struct nilfs_bdesc {
 	__u32 bd_pad;
 };
 
+
+/**
+ * struct nilfs_inode_change - information on how inode was changed
+ * @ic_ino: inode number
+ * @ic_flags: flags of changes
+ * @ic_attr: attribute flags (ATTR_MODE, ATTR_UID, ATTR_SIZE, ...)
+ */
+struct nilfs_inode_change {
+	__u64 ic_ino;
+	__u32 ic_flags;
+	__u32 ic_attr;
+};
+
+#define NILFS_IC_CREATE		(1 << 0)  /* Inode was.. created */
+#define NILFS_IC_DELETE		(1 << 1)  /*             deleted */
+
+#define NILFS_IC_LINKCOUNT	(1 << 8)  /* Link count */
+#define NILFS_IC_DATA		(1 << 9)  /* Data */
+#define NILFS_IC_XATTR		(1 << 10) /* Extended attributes (reserved) */
+#define NILFS_IC_FS_FLAGS	(1 << 11) /* file attribute flags (i_flags) */
+#define NILFS_IC_GENERATION	(1 << 12) /* i_generation */
+
+/* mode value of checkpoints comparison (for argv->v_flags) */
+enum {
+	NILFS_COMPARE_INODES,      /* look up changed inodes */
+	NILFS_COMPARE_FILE_EXTENT, /* look up changed data extent (reserved) */
+};
+
+/**
+ * struct nilfs_comp_args - arguments to compare items between two checkpoints
+ * @cno1: source checkpoint number
+ * @cno2: target checkpoint number
+ * @argv: argument vector to exchange items changed between two checkpoints
+ */
+struct nilfs_comp_args {
+	__u64 cno1;
+	__u64 cno2;
+	struct nilfs_argv argv;
+};
+
+
 #define NILFS_IOCTL_IDENT		'n'
 
 #define NILFS_IOCTL_CHANGE_CPMODE  \
@@ -847,5 +888,7 @@ struct nilfs_bdesc {
 	_IOW(NILFS_IOCTL_IDENT, 0x8B, __u64)
 #define NILFS_IOCTL_SET_ALLOC_RANGE  \
 	_IOW(NILFS_IOCTL_IDENT, 0x8C, __u64[2])
+#define NILFS_IOCTL_COMPARE_CHECKPOINTS  \
+	_IOWR(NILFS_IOCTL_IDENT, 0x8D, struct nilfs_comp_args)
 
 #endif	/* _LINUX_NILFS_FS_H */
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
