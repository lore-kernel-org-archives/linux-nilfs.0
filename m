From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [RFC][PATCH 15/15] nilfs2: integrate xattrs support functionality
 into driver
Date: Wed, 27 Nov 2013 16:43:44 +0400
Message-ID: <1385556224.2589.81.camel@slavad-ubuntu>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=WBG/7yEYSplXdeVmTjQEWkAMXue/vLxo6sX+bF0HVd4=;
	b=pO/8PdgPSyFMpOGcBYVtXEDJs1DpAi9q9g+qkp57zKtKuZ0iyuOPYoJuttffDCL8TCAnF1jaf4qc2yqUy5Qelm+BXimbu4csVGcOnsiTbPWZJxdegReNflmDtlg8pBzj;
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-nilfs@vger.kernel.org

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [RFC][PATCH 15/15] nilfs2: integrate xattrs support functionality into driver

This patch integrates xattrs support functionality into
file system driver.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/Kconfig     |   38 ++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/Makefile    |    6 +++++-
 fs/nilfs2/bmap.c      |    1 +
 fs/nilfs2/file.c      |    7 +++++++
 fs/nilfs2/inode.c     |   22 ++++++++--------------
 fs/nilfs2/namei.c     |   42 ++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/segment.c   |   22 ++++++++++++++++++++++
 fs/nilfs2/super.c     |   20 +++++++++++++++++---
 fs/nilfs2/the_nilfs.c |   19 +++++++++++++++++++
 9 files changed, 159 insertions(+), 18 deletions(-)

diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index 80da8eb..dcd420e 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -22,3 +22,41 @@ config NILFS2_FS
 
 	  To compile this file system support as a module, choose M here: the
 	  module will be called nilfs2.  If unsure, say N.
+
+config NILFS2_FS_DEBUG
+	bool "NILFS2 debugging"
+	depends on NILFS2_FS
+	help
+	  This option enables additional pre-condition and post-condition
+	  checking in functions. It can enable debug output too. The main
+	  goal of this option is providing environment for debugging code
+	  of NILFS2 driver and excluding debug checking and output from
+	  end-users' kernel build.
+
+	  If you are going to debug NILFS2 driver then choose Y here.
+	  If unsure, say N.
+
+config NILFS2_FS_POSIX_ACL
+	bool "NILFS2 POSIX Access Control Lists"
+	depends on NILFS2_FS
+	select FS_POSIX_ACL
+	help
+	  POSIX Access Control Lists (ACLs) support permissions for users and
+	  groups beyond the owner/group/world scheme.
+
+	  To learn more about Access Control Lists, visit the POSIX ACLs for
+	  Linux website <http://acl.bestbits.at/>.
+
+	  If you don't know what Access Control Lists are, say N
+
+config NILFS2_FS_SECURITY
+	bool "NILFS2 Security Labels"
+	depends on NILFS2_FS
+	help
+	  Security labels support alternative access control models
+	  implemented by security modules like SELinux.  This option
+	  enables an extended attribute handler for file security
+	  labels in the NILFS2 filesystem.
+
+	  If you are not using a security module that requires using
+	  extended attributes for file security labels, say N.
diff --git a/fs/nilfs2/Makefile b/fs/nilfs2/Makefile
index 85c9873..8e56dbd 100644
--- a/fs/nilfs2/Makefile
+++ b/fs/nilfs2/Makefile
@@ -2,4 +2,8 @@ obj-$(CONFIG_NILFS2_FS) += nilfs2.o
 nilfs2-y := inode.o file.o dir.o super.o namei.o page.o mdt.o \
 	btnode.o bmap.o btree.o direct.o dat.o recovery.o \
 	the_nilfs.o segbuf.o segment.o cpfile.o sufile.o \
-	ifile.o alloc.o gcinode.o ioctl.o
+	ifile.o alloc.o gcinode.o ioctl.o \
+	xafile.o xattr.o xattr_user.o xattr_trusted.o
+
+nilfs2-$(CONFIG_NILFS2_FS_POSIX_ACL)	+= acl.o
+nilfs2-$(CONFIG_NILFS2_FS_SECURITY)	+= xattr_security.o
diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index aadbd0b..7ab515f 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -499,6 +499,7 @@ int nilfs_bmap_read(struct nilfs_bmap *bmap, struct nilfs_inode *raw_inode)
 		break;
 	case NILFS_CPFILE_INO:
 	case NILFS_SUFILE_INO:
+	case NILFS_XATTR_INO:
 		bmap->b_ptr_type = NILFS_BMAP_PTR_VS;
 		bmap->b_last_allocated_key = 0;
 		bmap->b_last_allocated_ptr = NILFS_BMAP_INVALID_PTR;
diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 08fdb77..7592e37 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -26,6 +26,8 @@
 #include <linux/writeback.h>
 #include "nilfs.h"
 #include "segment.h"
+#include "xattr.h"
+#include "acl.h"
 
 int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 {
@@ -169,6 +171,11 @@ const struct file_operations nilfs_file_operations = {
 const struct inode_operations nilfs_file_inode_operations = {
 	.setattr	= nilfs_setattr,
 	.permission     = nilfs_permission,
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
+	.listxattr	= nilfs_listxattr,
+	.removexattr	= generic_removexattr,
+	.get_acl	= nilfs_get_acl,
 	.fiemap		= nilfs_fiemap,
 };
 
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 7e350c5..690072b 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -33,6 +33,8 @@
 #include "mdt.h"
 #include "cpfile.h"
 #include "ifile.h"
+#include "xattr.h"
+#include "acl.h"
 
 /**
  * struct nilfs_iget_args - arguments used during comparison between inodes
@@ -386,8 +388,6 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	ii->i_flags = nilfs_mask_flags(
 		mode, NILFS_I(dir)->i_flags & NILFS_FL_INHERITED);
 
-	/* ii->i_file_acl = 0; */
-	/* ii->i_dir_acl = 0; */
 	ii->i_dir_start_lookup = 0;
 	nilfs_set_inode_flags(inode);
 	spin_lock(&nilfs->ns_next_gen_lock);
@@ -395,15 +395,10 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	spin_unlock(&nilfs->ns_next_gen_lock);
 	insert_inode_hash(inode);
 
-	err = nilfs_init_acl(inode, dir);
-	if (unlikely(err))
-		goto failed_acl; /* never occur. When supporting
-				    nilfs_init_acl(), proper cancellation of
-				    above jobs should be considered */
+	ii->i_xattr = NILFS_INVALID_XANODE;
 
 	return inode;
 
- failed_acl:
  failed_bmap:
 	clear_nlink(inode);
 	iput(inode);  /* raw_inode will be deleted through
@@ -460,14 +455,12 @@ int nilfs_read_inode_common(struct inode *inode,
 
 	inode->i_blocks = le64_to_cpu(raw_inode->i_blocks);
 	ii->i_flags = le32_to_cpu(raw_inode->i_flags);
-#if 0
-	ii->i_file_acl = le32_to_cpu(raw_inode->i_file_acl);
-	ii->i_dir_acl = S_ISREG(inode->i_mode) ?
-		0 : le32_to_cpu(raw_inode->i_dir_acl);
-#endif
+
 	ii->i_dir_start_lookup = 0;
 	inode->i_generation = le32_to_cpu(raw_inode->i_generation);
 
+	ii->i_xattr = le64_to_cpu(raw_inode->i_xattr);
+
 	if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
 	    S_ISLNK(inode->i_mode)) {
 		err = nilfs_bmap_read(ii->i_bmap, raw_inode);
@@ -655,7 +648,8 @@ void nilfs_write_inode_common(struct inode *inode,
 		raw_inode->i_pad = 0;
 		memset((void *)raw_inode + sizeof(*raw_inode), 0,
 		       nilfs->ns_inode_size - sizeof(*raw_inode));
-	}
+	} else
+		raw_inode->i_xattr = cpu_to_le64(ii->i_xattr);
 
 	if (has_bmap)
 		nilfs_bmap_write(ii->i_bmap, raw_inode);
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 9de78f0..dc40a99 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -41,6 +41,8 @@
 #include <linux/pagemap.h>
 #include "nilfs.h"
 #include "export.h"
+#include "xattr.h"
+#include "acl.h"
 
 #define NILFS_FID_SIZE_NON_CONNECTABLE \
 	(offsetof(struct nilfs_fid, parent_gen) / 4)
@@ -97,12 +99,17 @@ static int nilfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	inode = nilfs_new_inode(dir, mode);
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
+		err = nilfs_init_inode_security(inode, dir, &dentry->d_name);
+		if (unlikely(err))
+			goto out;
 		inode->i_op = &nilfs_file_inode_operations;
 		inode->i_fop = &nilfs_file_operations;
 		inode->i_mapping->a_ops = &nilfs_aops;
 		nilfs_mark_inode_dirty(inode);
 		err = nilfs_add_nondir(dentry, inode);
 	}
+
+out:
 	if (!err)
 		err = nilfs_transaction_commit(dir->i_sb);
 	else
@@ -127,10 +134,15 @@ nilfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t rdev)
 	inode = nilfs_new_inode(dir, mode);
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
+		err = nilfs_init_inode_security(inode, dir, &dentry->d_name);
+		if (unlikely(err))
+			goto out;
 		init_special_inode(inode, inode->i_mode, rdev);
 		nilfs_mark_inode_dirty(inode);
 		err = nilfs_add_nondir(dentry, inode);
 	}
+
+out:
 	if (!err)
 		err = nilfs_transaction_commit(dir->i_sb);
 	else
@@ -160,6 +172,10 @@ static int nilfs_symlink(struct inode *dir, struct dentry *dentry,
 	if (IS_ERR(inode))
 		goto out;
 
+	err = nilfs_init_inode_security(inode, dir, &dentry->d_name);
+	if (unlikely(err))
+		goto out;
+
 	/* slow symlink */
 	inode->i_op = &nilfs_symlink_inode_operations;
 	inode->i_mapping->a_ops = &nilfs_aops;
@@ -227,6 +243,10 @@ static int nilfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	if (IS_ERR(inode))
 		goto out_dir;
 
+	err = nilfs_init_inode_security(inode, dir, &dentry->d_name);
+	if (unlikely(err))
+		goto out_dir;
+
 	inode->i_op = &nilfs_dir_inode_operations;
 	inode->i_fop = &nilfs_dir_operations;
 	inode->i_mapping->a_ops = &nilfs_aops;
@@ -285,6 +305,13 @@ static int nilfs_do_unlink(struct inode *dir, struct dentry *dentry)
 			      inode->i_ino, inode->i_nlink);
 		set_nlink(inode, 1);
 	}
+
+	if (inode->i_nlink == 1) {
+		err = nilfs_xattr_delete_inode(inode);
+		if (err)
+			goto out;
+	}
+
 	err = nilfs_delete_entry(de, page);
 	if (err)
 		goto out;
@@ -553,12 +580,22 @@ const struct inode_operations nilfs_dir_inode_operations = {
 	.rename		= nilfs_rename,
 	.setattr	= nilfs_setattr,
 	.permission	= nilfs_permission,
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
+	.listxattr	= nilfs_listxattr,
+	.removexattr	= generic_removexattr,
+	.get_acl	= nilfs_get_acl,
 	.fiemap		= nilfs_fiemap,
 };
 
 const struct inode_operations nilfs_special_inode_operations = {
 	.setattr	= nilfs_setattr,
 	.permission	= nilfs_permission,
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
+	.listxattr	= nilfs_listxattr,
+	.removexattr	= generic_removexattr,
+	.get_acl	= nilfs_get_acl,
 };
 
 const struct inode_operations nilfs_symlink_inode_operations = {
@@ -566,6 +603,11 @@ const struct inode_operations nilfs_symlink_inode_operations = {
 	.follow_link	= page_follow_link_light,
 	.put_link	= page_put_link,
 	.permission     = nilfs_permission,
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
+	.listxattr	= nilfs_listxattr,
+	.removexattr	= generic_removexattr,
+	.get_acl	= nilfs_get_acl,
 };
 
 const struct export_operations nilfs_export_ops = {
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 9f6b486..f808934 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -70,6 +70,7 @@ enum {
 	NILFS_ST_IFILE,
 	NILFS_ST_CPFILE,
 	NILFS_ST_SUFILE,
+	NILFS_ST_XAFILE,
 	NILFS_ST_DAT,
 	NILFS_ST_SR,		/* Super root */
 	NILFS_ST_DSYNC,		/* Data sync blocks */
@@ -757,6 +758,10 @@ static int nilfs_test_metadata_dirty(struct the_nilfs *nilfs,
 		ret++;
 	if (nilfs_mdt_fetch_dirty(nilfs->ns_sufile))
 		ret++;
+	if (nilfs_has_xafile(nilfs)) {
+		if (nilfs_mdt_fetch_dirty(nilfs->ns_xafile))
+			ret++;
+	}
 	if ((ret || nilfs_doing_gc()) && nilfs_mdt_fetch_dirty(nilfs->ns_dat))
 		ret++;
 	return ret;
@@ -793,6 +798,8 @@ static void nilfs_segctor_clear_metadata_dirty(struct nilfs_sc_info *sci)
 	nilfs_mdt_clear_dirty(sci->sc_root->ifile);
 	nilfs_mdt_clear_dirty(nilfs->ns_cpfile);
 	nilfs_mdt_clear_dirty(nilfs->ns_sufile);
+	if (nilfs_has_xafile(nilfs))
+		nilfs_mdt_clear_dirty(nilfs->ns_xafile);
 	nilfs_mdt_clear_dirty(nilfs->ns_dat);
 }
 
@@ -909,6 +916,13 @@ static void nilfs_segctor_fill_in_super_root(struct nilfs_sc_info *sci,
 				 NILFS_SR_CPFILE_OFFSET(isz), 1);
 	nilfs_write_inode_common(nilfs->ns_sufile, (void *)raw_sr +
 				 NILFS_SR_SUFILE_OFFSET(isz), 1);
+	if (nilfs_has_xafile(nilfs)) {
+		nilfs_write_inode_common(nilfs->ns_xafile, (void *)raw_sr +
+					 NILFS_SR_XAFILE_OFFSET(isz), 1);
+	} else {
+		memset((void *)raw_sr + NILFS_SR_XAFILE_OFFSET(isz), 0,
+			sizeof(struct nilfs_inode));
+	}
 	memset((void *)raw_sr + srsz, 0, nilfs->ns_blocksize - srsz);
 }
 
@@ -1157,6 +1171,14 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
 		if (unlikely(err))
 			break;
 		sci->sc_stage.scnt++;  /* Fall through */
+	case NILFS_ST_XAFILE:
+		if (nilfs_has_xafile(nilfs)) {
+			err = nilfs_segctor_scan_file(sci, nilfs->ns_xafile,
+							&nilfs_sc_file_ops);
+			if (unlikely(err))
+				break;
+		}
+		sci->sc_stage.scnt++;  /* Fall through */
 	case NILFS_ST_DAT:
  dat_stage:
 		err = nilfs_segctor_scan_file(sci, nilfs->ns_dat,
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 7ac2a12..75b1362 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -61,6 +61,8 @@
 #include "dat.h"
 #include "segment.h"
 #include "segbuf.h"
+#include "xattr.h"
+#include "acl.h"
 
 MODULE_AUTHOR("NTT Corp.");
 MODULE_DESCRIPTION("A New Implementation of the Log-structured Filesystem "
@@ -486,6 +488,8 @@ static void nilfs_put_super(struct super_block *sb)
 		up_write(&nilfs->ns_sem);
 	}
 
+	if (nilfs_has_xafile(nilfs))
+		iput(nilfs->ns_xafile);
 	iput(nilfs->ns_sufile);
 	iput(nilfs->ns_cpfile);
 	iput(nilfs->ns_dat);
@@ -1071,6 +1075,12 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_time_gran = 1;
 	sb->s_max_links = NILFS_LINK_MAX;
 
+	sb->s_xattr = nilfs_xattr_handlers;
+	if (nilfs_has_xafile(nilfs))
+		set_posix_acl_flag(sb);
+	else
+		sb->s_flags &= ~MS_POSIXACL;
+
 	bdi = sb->s_bdev->bd_inode->i_mapping->backing_dev_info;
 	sb->s_bdi = bdi ? : &default_backing_dev_info;
 
@@ -1113,6 +1123,8 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 	nilfs_put_root(fsroot);
 
  failed_unload:
+	if (nilfs_has_xafile(nilfs))
+		iput(nilfs->ns_xafile);
 	iput(nilfs->ns_sufile);
 	iput(nilfs->ns_cpfile);
 	iput(nilfs->ns_dat);
@@ -1136,7 +1148,11 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		err = -EINVAL;
 		goto restore_opts;
 	}
-	sb->s_flags = (sb->s_flags & ~MS_POSIXACL);
+
+	if (nilfs_has_xafile(nilfs))
+		set_posix_acl_flag(sb);
+	else
+		sb->s_flags &= ~MS_POSIXACL;
 
 	err = -EINVAL;
 
@@ -1379,9 +1395,7 @@ static void nilfs_inode_init_once(void *obj)
 	struct nilfs_inode_info *ii = obj;
 
 	INIT_LIST_HEAD(&ii->i_dirty);
-#ifdef CONFIG_NILFS_XATTR
 	init_rwsem(&ii->xattr_sem);
-#endif
 	address_space_init_once(&ii->i_btnode_cache);
 	ii->i_bmap = &ii->i_bmap_data;
 	inode_init_once(&ii->vfs_inode);
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 94c451c..a5fa271 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -33,6 +33,7 @@
 #include "cpfile.h"
 #include "sufile.h"
 #include "dat.h"
+#include "xafile.h"
 #include "segbuf.h"
 
 
@@ -142,6 +143,14 @@ static int nilfs_load_super_root(struct the_nilfs *nilfs,
 	if (err)
 		goto failed_cpfile;
 
+	if (nilfs_has_xafile(nilfs)) {
+		rawi = (void *)bh_sr->b_data +
+				NILFS_SR_XAFILE_OFFSET(inode_size);
+		err = nilfs_xafile_read(sb, rawi, &nilfs->ns_xafile);
+		if (err)
+			goto failed_xafile;
+	}
+
 	raw_sr = (struct nilfs_super_root *)bh_sr->b_data;
 	nilfs->ns_nongc_ctime = le64_to_cpu(raw_sr->sr_nongc_ctime);
 
@@ -149,6 +158,10 @@ static int nilfs_load_super_root(struct the_nilfs *nilfs,
 	brelse(bh_sr);
 	return err;
 
+ failed_xafile:
+	if (nilfs_has_xafile(nilfs))
+		iput(nilfs->ns_xafile);
+
  failed_cpfile:
 	iput(nilfs->ns_cpfile);
 
@@ -343,6 +356,8 @@ int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 	goto failed;
 
  failed_unload:
+	if (nilfs_has_xafile(nilfs))
+		iput(nilfs->ns_xafile);
 	iput(nilfs->ns_cpfile);
 	iput(nilfs->ns_sufile);
 	iput(nilfs->ns_dat);
@@ -584,6 +599,10 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 	if (err)
 		goto failed_sbh;
 
+	if (le64_to_cpu(sbp->s_feature_compat_ro) &
+	    NILFS_FEATURE_COMPAT_RO_XAFILE)
+		set_nilfs_has_xafile(nilfs);
+
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbp->s_log_block_size);
 	if (blocksize < NILFS_MIN_BLOCK_SIZE ||
 	    blocksize > NILFS_MAX_BLOCK_SIZE) {
-- 
1.7.9.5



