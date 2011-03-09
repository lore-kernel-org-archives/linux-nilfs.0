From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 8/8] nilfs2: get rid of nilfs_sb_info structure
Date: Wed,  9 Mar 2011 21:08:13 +0900
Message-ID: <1299672493-28544-9-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1299672493-28544-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1299672493-28544-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This directly uses sb->s_fs_info to keep a nilfs filesystem object and
fully removes the intermediate nilfs_sb_info structure.  With this
change, the hierarchy of on-memory structures of nilfs will be
simplified as follows:

Before:
  super_block
       -> nilfs_sb_info
             -> the_nilfs
                   -> cptree --+-> nilfs_root (current file system)
                               +-> nilfs_root (snapshot A)
                               +-> nilfs_root (snapshot B)
                               :
             -> nilfs_sc_info (log writer structure)
After:
  super_block
       -> the_nilfs
             -> cptree --+-> nilfs_root (current file system)
                         +-> nilfs_root (snapshot A)
                         +-> nilfs_root (snapshot B)
                         :
             -> nilfs_sc_info (log writer structure)

The reason why we didn't design so from the beginning is because the
initial shape also differed from the above.  The early hierachy was
composed of "per-mount-point" super_block -> nilfs_sb_info pairs and a
shared nilfs object.  On the kernel 2.6.37, it was changed to the
current shape in order to unify super block instances into one per
device, and this cleanup became applicable as the result.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.c      |    1 -
 fs/nilfs2/file.c      |    2 +-
 fs/nilfs2/inode.c     |   10 ++++----
 fs/nilfs2/ioctl.c     |   23 ++++++++---------
 fs/nilfs2/mdt.h       |    2 +-
 fs/nilfs2/namei.c     |    2 +-
 fs/nilfs2/nilfs.h     |    3 +-
 fs/nilfs2/sb.h        |   46 -----------------------------------
 fs/nilfs2/segment.c   |   47 ++++++++++++++++++------------------
 fs/nilfs2/segment.h   |    2 +-
 fs/nilfs2/super.c     |   63 ++++++++++++++++++-------------------------------
 fs/nilfs2/the_nilfs.h |    1 -
 12 files changed, 68 insertions(+), 134 deletions(-)
 delete mode 100644 fs/nilfs2/sb.h

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index 85447a2..4723f04 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -25,7 +25,6 @@
 #include <linux/errno.h>
 #include "nilfs.h"
 #include "bmap.h"
-#include "sb.h"
 #include "btree.h"
 #include "direct.h"
 #include "btnode.h"
diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 7a5e4ab..93589fc 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -59,7 +59,7 @@ static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct nilfs_transaction_info ti;
 	int ret;
 
-	if (unlikely(nilfs_near_disk_full(NILFS_SB(inode->i_sb)->s_nilfs)))
+	if (unlikely(nilfs_near_disk_full(inode->i_sb->s_fs_info)))
 		return VM_FAULT_SIGBUS; /* -ENOSPC */
 
 	lock_page(page);
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 7a3dbe4..d5625be 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -295,7 +295,7 @@ const struct address_space_operations nilfs_aops = {
 struct inode *nilfs_new_inode(struct inode *dir, int mode)
 {
 	struct super_block *sb = dir->i_sb;
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct inode *inode;
 	struct nilfs_inode_info *ii;
 	struct nilfs_root *root;
@@ -433,7 +433,7 @@ static int __nilfs_read_inode(struct super_block *sb,
 			      struct nilfs_root *root, unsigned long ino,
 			      struct inode *inode)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct buffer_head *bh;
 	struct nilfs_inode *raw_inode;
 	int err;
@@ -807,7 +807,7 @@ int nilfs_permission(struct inode *inode, int mask, unsigned int flags)
 
 int nilfs_load_inode_block(struct inode *inode, struct buffer_head **pbh)
 {
-	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 	int err;
 
@@ -836,7 +836,7 @@ int nilfs_load_inode_block(struct inode *inode, struct buffer_head **pbh)
 int nilfs_inode_dirty(struct inode *inode)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
-	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 	int ret = 0;
 
 	if (!list_empty(&ii->i_dirty)) {
@@ -851,7 +851,7 @@ int nilfs_inode_dirty(struct inode *inode)
 int nilfs_set_file_dirty(struct inode *inode, unsigned nr_dirty)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
-	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 
 	atomic_add(nr_dirty, &nilfs->ns_ndirtyblks);
 
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 5471eed..95c04c2 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -166,8 +166,7 @@ static int nilfs_ioctl_getversion(struct inode *inode, void __user *argp)
 static int nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
 				     unsigned int cmd, void __user *argp)
 {
-	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
-	struct inode *cpfile = nilfs->ns_cpfile;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 	struct nilfs_transaction_info ti;
 	struct nilfs_cpmode cpmode;
 	int ret;
@@ -187,7 +186,7 @@ static int nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
 
 	nilfs_transaction_begin(inode->i_sb, &ti, 0);
 	ret = nilfs_cpfile_change_cpmode(
-		cpfile, cpmode.cm_cno, cpmode.cm_mode);
+		nilfs->ns_cpfile, cpmode.cm_cno, cpmode.cm_mode);
 	if (unlikely(ret < 0))
 		nilfs_transaction_abort(inode->i_sb);
 	else
@@ -203,7 +202,7 @@ static int
 nilfs_ioctl_delete_checkpoint(struct inode *inode, struct file *filp,
 			      unsigned int cmd, void __user *argp)
 {
-	struct inode *cpfile = NILFS_SB(inode->i_sb)->s_nilfs->ns_cpfile;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 	struct nilfs_transaction_info ti;
 	__u64 cno;
 	int ret;
@@ -220,7 +219,7 @@ nilfs_ioctl_delete_checkpoint(struct inode *inode, struct file *filp,
 		goto out;
 
 	nilfs_transaction_begin(inode->i_sb, &ti, 0);
-	ret = nilfs_cpfile_delete_checkpoint(cpfile, cno);
+	ret = nilfs_cpfile_delete_checkpoint(nilfs->ns_cpfile, cno);
 	if (unlikely(ret < 0))
 		nilfs_transaction_abort(inode->i_sb);
 	else
@@ -246,7 +245,7 @@ nilfs_ioctl_do_get_cpinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 static int nilfs_ioctl_get_cpstat(struct inode *inode, struct file *filp,
 				  unsigned int cmd, void __user *argp)
 {
-	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 	struct nilfs_cpstat cpstat;
 	int ret;
 
@@ -277,7 +276,7 @@ nilfs_ioctl_do_get_suinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 static int nilfs_ioctl_get_sustat(struct inode *inode, struct file *filp,
 				  unsigned int cmd, void __user *argp)
 {
-	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 	struct nilfs_sustat sustat;
 	int ret;
 
@@ -333,7 +332,7 @@ nilfs_ioctl_do_get_bdescs(struct the_nilfs *nilfs, __u64 *posp, int flags,
 static int nilfs_ioctl_get_bdescs(struct inode *inode, struct file *filp,
 				  unsigned int cmd, void __user *argp)
 {
-	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 	struct nilfs_argv argv;
 	int ret;
 
@@ -402,7 +401,7 @@ static int nilfs_ioctl_move_blocks(struct super_block *sb,
 				   struct nilfs_argv *argv, void *buf)
 {
 	size_t nmembs = argv->v_nmembs;
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct inode *inode;
 	struct nilfs_vdesc *vdesc;
 	struct buffer_head *bh, *n;
@@ -616,7 +615,7 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 		ret = PTR_ERR(kbufs[4]);
 		goto out;
 	}
-	nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
+	nilfs = inode->i_sb->s_fs_info;
 
 	for (n = 0; n < 4; n++) {
 		ret = -EINVAL;
@@ -689,7 +688,7 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
 		return ret;
 
 	if (argp != NULL) {
-		nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
+		nilfs = inode->i_sb->s_fs_info;
 		down_read(&nilfs->ns_segctor_sem);
 		cno = nilfs->ns_cno - 1;
 		up_read(&nilfs->ns_segctor_sem);
@@ -707,7 +706,7 @@ static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
 						  void *, size_t, size_t))
 
 {
-	struct the_nilfs *nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 	struct nilfs_argv argv;
 	int ret;
 
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index b13734b..ed68563 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -66,7 +66,7 @@ static inline struct nilfs_mdt_info *NILFS_MDT(const struct inode *inode)
 
 static inline struct the_nilfs *NILFS_I_NILFS(struct inode *inode)
 {
-	return NILFS_SB(inode->i_sb)->s_nilfs;
+	return inode->i_sb->s_fs_info;
 }
 
 /* Default GFP flags using highmem */
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 161791d..546849b 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -482,7 +482,7 @@ static struct dentry *nilfs_get_dentry(struct super_block *sb, u64 cno,
 	if (ino < NILFS_FIRST_INO(sb) && ino != NILFS_ROOT_INO)
 		return ERR_PTR(-ESTALE);
 
-	root = nilfs_lookup_root(NILFS_SB(sb)->s_nilfs, cno);
+	root = nilfs_lookup_root(sb->s_fs_info, cno);
 	if (!root)
 		return ERR_PTR(-ESTALE);
 
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index eba1aaa..856e8e4 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -30,7 +30,6 @@
 #include <linux/blkdev.h>
 #include <linux/nilfs2_fs.h>
 #include "the_nilfs.h"
-#include "sb.h"
 #include "bmap.h"
 
 /*
@@ -122,7 +121,7 @@ enum {
 #define NILFS_SYS_INO_BITS   \
   ((unsigned int)(1 << NILFS_ROOT_INO) | NILFS_MDT_INO_BITS)
 
-#define NILFS_FIRST_INO(sb)  (NILFS_SB(sb)->s_nilfs->ns_first_ino)
+#define NILFS_FIRST_INO(sb) (((struct the_nilfs *)sb->s_fs_info)->ns_first_ino)
 
 #define NILFS_MDT_INODE(sb, ino) \
   ((ino) < NILFS_FIRST_INO(sb) && (NILFS_MDT_INO_BITS & (1 << (ino))))
diff --git a/fs/nilfs2/sb.h b/fs/nilfs2/sb.h
deleted file mode 100644
index 44553f4..0000000
--- a/fs/nilfs2/sb.h
+++ /dev/null
@@ -1,46 +0,0 @@
-/*
- * sb.h - NILFS on-memory super block structure.
- *
- * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
- * Written by Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
- *
- */
-
-#ifndef _NILFS_SB
-#define _NILFS_SB
-
-#include <linux/types.h>
-#include <linux/fs.h>
-
-struct the_nilfs;
-
-/*
- * NILFS super-block data in memory
- */
-struct nilfs_sb_info {
-	/* Fundamental members */
-	struct super_block *s_super;	/* reverse pointer to super_block */
-	struct the_nilfs *s_nilfs;
-};
-
-static inline struct nilfs_sb_info *NILFS_SB(struct super_block *sb)
-{
-	return sb->s_fs_info;
-}
-
-#endif /* _NILFS_SB */
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 90e3130..afe4f21 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -191,7 +191,7 @@ int nilfs_transaction_begin(struct super_block *sb,
 
 	vfs_check_frozen(sb, SB_FREEZE_WRITE);
 
-	nilfs = NILFS_SB(sb)->s_nilfs;
+	nilfs = sb->s_fs_info;
 	down_read(&nilfs->ns_segctor_sem);
 	if (vacancy_check && nilfs_near_disk_full(nilfs)) {
 		up_read(&nilfs->ns_segctor_sem);
@@ -222,7 +222,7 @@ int nilfs_transaction_begin(struct super_block *sb,
 int nilfs_transaction_commit(struct super_block *sb)
 {
 	struct nilfs_transaction_info *ti = current->journal_info;
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	int err = 0;
 
 	BUG_ON(ti == NULL || ti->ti_magic != NILFS_TI_MAGIC);
@@ -252,13 +252,14 @@ int nilfs_transaction_commit(struct super_block *sb)
 void nilfs_transaction_abort(struct super_block *sb)
 {
 	struct nilfs_transaction_info *ti = current->journal_info;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 
 	BUG_ON(ti == NULL || ti->ti_magic != NILFS_TI_MAGIC);
 	if (ti->ti_count > 0) {
 		ti->ti_count--;
 		return;
 	}
-	up_read(&NILFS_SB(sb)->s_nilfs->ns_segctor_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	current->journal_info = ti->ti_save;
 	if (ti->ti_flags & NILFS_TI_DYNAMIC_ALLOC)
@@ -267,7 +268,7 @@ void nilfs_transaction_abort(struct super_block *sb)
 
 void nilfs_relax_pressure_in_lock(struct super_block *sb)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 
 	if (!sci || !sci->sc_flush_request)
@@ -293,7 +294,7 @@ static void nilfs_transaction_lock(struct super_block *sb,
 				   int gcflag)
 {
 	struct nilfs_transaction_info *cur_ti = current->journal_info;
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 
 	WARN_ON(cur_ti);
@@ -321,7 +322,7 @@ static void nilfs_transaction_lock(struct super_block *sb,
 static void nilfs_transaction_unlock(struct super_block *sb)
 {
 	struct nilfs_transaction_info *ti = current->journal_info;
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 
 	BUG_ON(ti == NULL || ti->ti_magic != NILFS_TI_MAGIC);
 	BUG_ON(ti->ti_count > 0);
@@ -770,7 +771,7 @@ static int nilfs_segctor_clean(struct nilfs_sc_info *sci)
 
 static int nilfs_segctor_confirm(struct nilfs_sc_info *sci)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sci->sc_super)->s_nilfs;
+	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int ret = 0;
 
 	if (nilfs_test_metadata_dirty(nilfs, sci->sc_root))
@@ -786,7 +787,7 @@ static int nilfs_segctor_confirm(struct nilfs_sc_info *sci)
 
 static void nilfs_segctor_clear_metadata_dirty(struct nilfs_sc_info *sci)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sci->sc_super)->s_nilfs;
+	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 
 	nilfs_mdt_clear_dirty(sci->sc_root->ifile);
 	nilfs_mdt_clear_dirty(nilfs->ns_cpfile);
@@ -796,7 +797,7 @@ static void nilfs_segctor_clear_metadata_dirty(struct nilfs_sc_info *sci)
 
 static int nilfs_segctor_create_checkpoint(struct nilfs_sc_info *sci)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sci->sc_super)->s_nilfs;
+	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	struct buffer_head *bh_cp;
 	struct nilfs_checkpoint *raw_cp;
 	int err;
@@ -820,7 +821,7 @@ static int nilfs_segctor_create_checkpoint(struct nilfs_sc_info *sci)
 
 static int nilfs_segctor_fill_in_checkpoint(struct nilfs_sc_info *sci)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sci->sc_super)->s_nilfs;
+	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	struct buffer_head *bh_cp;
 	struct nilfs_checkpoint *raw_cp;
 	int err;
@@ -1044,7 +1045,7 @@ static int nilfs_segctor_scan_file_dsync(struct nilfs_sc_info *sci,
 
 static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sci->sc_super)->s_nilfs;
+	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	struct list_head *head;
 	struct nilfs_inode_info *ii;
 	size_t ndone;
@@ -1853,7 +1854,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 {
 	struct nilfs_segment_buffer *segbuf;
 	struct page *bd_page = NULL, *fs_page = NULL;
-	struct the_nilfs *nilfs = NILFS_SB(sci->sc_super)->s_nilfs;
+	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int update_sr = false;
 
 	list_for_each_entry(segbuf, &sci->sc_write_logs, sb_list) {
@@ -2024,7 +2025,7 @@ static void nilfs_segctor_drop_written_files(struct nilfs_sc_info *sci,
  */
 static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sci->sc_super)->s_nilfs;
+	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	struct page *failed_page;
 	int err;
 
@@ -2162,7 +2163,7 @@ static void nilfs_segctor_do_flush(struct nilfs_sc_info *sci, int bn)
  */
 void nilfs_flush_segment(struct super_block *sb, ino_t ino)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 
 	if (!sci || nilfs_doing_construction())
@@ -2252,7 +2253,7 @@ static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err)
  */
 int nilfs_construct_segment(struct super_block *sb)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 	struct nilfs_transaction_info *ti;
 	int err;
@@ -2290,7 +2291,7 @@ int nilfs_construct_segment(struct super_block *sb)
 int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 				  loff_t start, loff_t end)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 	struct nilfs_inode_info *ii;
 	struct nilfs_transaction_info ti;
@@ -2381,7 +2382,7 @@ static void nilfs_segctor_notify(struct nilfs_sc_info *sci, int mode, int err)
  */
 static int nilfs_segctor_construct(struct nilfs_sc_info *sci, int mode)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sci->sc_super)->s_nilfs;
+	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	struct nilfs_super_block **sbp;
 	int err = 0;
 
@@ -2436,7 +2437,7 @@ nilfs_remove_written_gcinodes(struct the_nilfs *nilfs, struct list_head *head)
 int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 			 void **kbufs)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 	struct nilfs_transaction_info ti;
 	int err;
@@ -2552,7 +2553,7 @@ static int nilfs_segctor_flush_mode(struct nilfs_sc_info *sci)
 static int nilfs_segctor_thread(void *arg)
 {
 	struct nilfs_sc_info *sci = (struct nilfs_sc_info *)arg;
-	struct the_nilfs *nilfs = NILFS_SB(sci->sc_super)->s_nilfs;
+	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int timeout = 0;
 
 	sci->sc_timer.data = (unsigned long)current;
@@ -2666,7 +2667,7 @@ static void nilfs_segctor_kill_thread(struct nilfs_sc_info *sci)
 static struct nilfs_sc_info *nilfs_segctor_new(struct super_block *sb,
 					       struct nilfs_root *root)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci;
 
 	sci = kzalloc(sizeof(*sci), GFP_KERNEL);
@@ -2726,7 +2727,7 @@ static void nilfs_segctor_write_out(struct nilfs_sc_info *sci)
  */
 static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sci->sc_super)->s_nilfs;
+	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int flag;
 
 	up_write(&nilfs->ns_segctor_sem);
@@ -2774,7 +2775,7 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
  */
 int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	int err;
 
 	if (nilfs->ns_writer) {
@@ -2807,7 +2808,7 @@ int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root)
  */
 void nilfs_detach_log_writer(struct super_block *sb)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	LIST_HEAD(garbage_list);
 
 	down_write(&nilfs->ns_segctor_sem);
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index e01998e..6c02a86 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -27,7 +27,7 @@
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
 #include <linux/nilfs2_fs.h>
-#include "sb.h"
+#include "nilfs.h"
 
 struct nilfs_root;
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index a8cbd69..062cca0 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -76,7 +76,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data);
 
 static void nilfs_set_error(struct super_block *sb)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_super_block **sbp;
 
 	down_write(&nilfs->ns_sem);
@@ -108,7 +108,7 @@ static void nilfs_set_error(struct super_block *sb)
 void nilfs_error(struct super_block *sb, const char *function,
 		 const char *fmt, ...)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct va_format vaf;
 	va_list args;
 
@@ -190,7 +190,7 @@ void nilfs_destroy_inode(struct inode *inode)
 
 static int nilfs_sync_super(struct super_block *sb, int flag)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	int err;
 
  retry:
@@ -265,7 +265,7 @@ void nilfs_set_log_cursor(struct nilfs_super_block *sbp,
 struct nilfs_super_block **nilfs_prepare_super(struct super_block *sb,
 					       int flip)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
 
 	/* nilfs->ns_sem must be locked by the caller. */
@@ -291,7 +291,7 @@ struct nilfs_super_block **nilfs_prepare_super(struct super_block *sb,
 
 int nilfs_commit_super(struct super_block *sb, int flag)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
 	time_t t;
 
@@ -324,7 +324,7 @@ int nilfs_commit_super(struct super_block *sb, int flag)
  */
 int nilfs_cleanup_super(struct super_block *sb)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_super_block **sbp;
 	int flag = NILFS_SB_COMMIT;
 	int ret = -EIO;
@@ -349,8 +349,7 @@ int nilfs_cleanup_super(struct super_block *sb)
 
 static void nilfs_put_super(struct super_block *sb)
 {
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 
 	nilfs_detach_log_writer(sb);
 
@@ -365,14 +364,12 @@ static void nilfs_put_super(struct super_block *sb)
 	iput(nilfs->ns_dat);
 
 	destroy_nilfs(nilfs);
-	sbi->s_super = NULL;
 	sb->s_fs_info = NULL;
-	kfree(sbi);
 }
 
 static int nilfs_sync_fs(struct super_block *sb, int wait)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_super_block **sbp;
 	int err = 0;
 
@@ -396,7 +393,7 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
 int nilfs_attach_checkpoint(struct super_block *sb, __u64 cno, int curr_mnt,
 			    struct nilfs_root **rootp)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_root *root;
 	struct nilfs_checkpoint *raw_cp;
 	struct buffer_head *bh_cp;
@@ -449,7 +446,7 @@ int nilfs_attach_checkpoint(struct super_block *sb, __u64 cno, int curr_mnt,
 
 static int nilfs_freeze(struct super_block *sb)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	int err;
 
 	if (sb->s_flags & MS_RDONLY)
@@ -464,7 +461,7 @@ static int nilfs_freeze(struct super_block *sb)
 
 static int nilfs_unfreeze(struct super_block *sb)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
@@ -527,7 +524,7 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 static int nilfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 {
 	struct super_block *sb = vfs->mnt_sb;
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_root *root = NILFS_I(vfs->mnt_root->d_inode)->i_root;
 
 	if (!nilfs_test_opt(nilfs, BARRIER))
@@ -591,7 +588,7 @@ static match_table_t tokens = {
 
 static int parse_options(char *options, struct super_block *sb, int is_remount)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
 
@@ -660,7 +657,7 @@ static inline void
 nilfs_set_default_options(struct super_block *sb,
 			  struct nilfs_super_block *sbp)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 
 	nilfs->ns_mount_opt =
 		NILFS_MOUNT_ERRORS_RO | NILFS_MOUNT_BARRIER;
@@ -668,7 +665,7 @@ nilfs_set_default_options(struct super_block *sb,
 
 static int nilfs_setup_super(struct super_block *sb, int is_mount)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_super_block **sbp;
 	int max_mnt_count;
 	int mnt_count;
@@ -726,7 +723,7 @@ int nilfs_store_magic_and_option(struct super_block *sb,
 				 struct nilfs_super_block *sbp,
 				 char *data)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 
 	sb->s_magic = le16_to_cpu(sbp->s_magic);
 
@@ -821,7 +818,7 @@ static int nilfs_get_root_dentry(struct super_block *sb,
 static int nilfs_attach_snapshot(struct super_block *s, __u64 cno,
 				 struct dentry **root_dentry)
 {
-	struct the_nilfs *nilfs = NILFS_SB(s)->s_nilfs;
+	struct the_nilfs *nilfs = s->s_fs_info;
 	struct nilfs_root *root;
 	int ret;
 
@@ -873,7 +870,7 @@ static int nilfs_try_to_shrink_tree(struct dentry *root_dentry)
 
 int nilfs_checkpoint_is_mounted(struct super_block *sb, __u64 cno)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_root *root;
 	struct inode *inode;
 	struct dentry *dentry;
@@ -886,7 +883,7 @@ int nilfs_checkpoint_is_mounted(struct super_block *sb, __u64 cno)
 		return true;	/* protect recent checkpoints */
 
 	ret = false;
-	root = nilfs_lookup_root(NILFS_SB(sb)->s_nilfs, cno);
+	root = nilfs_lookup_root(nilfs, cno);
 	if (root) {
 		inode = nilfs_ilookup(sb, root, NILFS_ROOT_INO);
 		if (inode) {
@@ -916,25 +913,16 @@ static int
 nilfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct the_nilfs *nilfs;
-	struct nilfs_sb_info *sbi;
 	struct nilfs_root *fsroot;
 	struct backing_dev_info *bdi;
 	__u64 cno;
 	int err;
 
-	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
-	if (!sbi)
+	nilfs = alloc_nilfs(sb->s_bdev);
+	if (!nilfs)
 		return -ENOMEM;
 
-	sb->s_fs_info = sbi;
-	sbi->s_super = sb;
-
-	nilfs = alloc_nilfs(sb->s_bdev);
-	if (!nilfs) {
-		err = -ENOMEM;
-		goto failed_sbi;
-	}
-	sbi->s_nilfs = nilfs;
+	sb->s_fs_info = nilfs;
 
 	err = init_nilfs(nilfs, sb, (char *)data);
 	if (err)
@@ -993,16 +981,12 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 
  failed_nilfs:
 	destroy_nilfs(nilfs);
-
- failed_sbi:
-	sb->s_fs_info = NULL;
-	kfree(sbi);
 	return err;
 }
 
 static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 {
-	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct the_nilfs *nilfs = sb->s_fs_info;
 	unsigned long old_sb_flags;
 	unsigned long old_mount_opt;
 	int err;
@@ -1083,7 +1067,6 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 
 struct nilfs_super_data {
 	struct block_device *bdev;
-	struct nilfs_sb_info *sbi;
 	__u64 cno;
 	int flags;
 };
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 793bd27..f496814 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -31,7 +31,6 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/slab.h>
-#include "sb.h"
 
 struct nilfs_sc_info;
 
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
