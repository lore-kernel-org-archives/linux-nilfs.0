From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 03/23] nilfs2: make snapshots in checkpoint tree exportable
Date: Tue, 14 Sep 2010 00:37:04 +0900
Message-ID: <1284392244-27100-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1284392244-27100-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The previous export operations cannot handle multiple versions of
a filesystem if they belong to the same sb instance.

This adds a new type of file handle and extends export operations so
that they can get the inode specified by a checkpoint number as well
as an inode number and a generation number.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/export.h       |   17 ++++++
 fs/nilfs2/namei.c        |  137 ++++++++++++++++++++++++++++++++++++++++------
 fs/nilfs2/nilfs.h        |    3 -
 fs/nilfs2/super.c        |   52 +-----------------
 include/linux/exportfs.h |   13 ++++
 5 files changed, 151 insertions(+), 71 deletions(-)
 create mode 100644 fs/nilfs2/export.h

diff --git a/fs/nilfs2/export.h b/fs/nilfs2/export.h
new file mode 100644
index 0000000..a71cc41
--- /dev/null
+++ b/fs/nilfs2/export.h
@@ -0,0 +1,17 @@
+#ifndef NILFS_EXPORT_H
+#define NILFS_EXPORT_H
+
+#include <linux/exportfs.h>
+
+extern const struct export_operations nilfs_export_ops;
+
+struct nilfs_fid {
+	u64 cno;
+	u64 ino;
+	u32 gen;
+
+	u32 parent_gen;
+	u64 parent_ino;
+} __attribute__ ((packed));
+
+#endif
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 1110d56..a65f465 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -40,7 +40,11 @@
 
 #include <linux/pagemap.h>
 #include "nilfs.h"
+#include "export.h"
 
+#define NILFS_FID_SIZE_NON_CONNECTABLE \
+	(offsetof(struct nilfs_fid, parent_gen) / 4)
+#define NILFS_FID_SIZE_CONNECTABLE	(sizeof(struct nilfs_fid) / 4)
 
 static inline int nilfs_add_nondir(struct dentry *dentry, struct inode *inode)
 {
@@ -77,23 +81,6 @@ nilfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	return d_splice_alias(inode, dentry);
 }
 
-struct dentry *nilfs_get_parent(struct dentry *child)
-{
-	unsigned long ino;
-	struct inode *inode;
-	struct qstr dotdot = {.name = "..", .len = 2};
-
-	ino = nilfs_inode_by_name(child->d_inode, &dotdot);
-	if (!ino)
-		return ERR_PTR(-ENOENT);
-
-	inode = nilfs_iget(child->d_inode->i_sb,
-			   NILFS_I(child->d_inode)->i_root, ino);
-	if (IS_ERR(inode))
-		return ERR_CAST(inode);
-	return d_obtain_alias(inode);
-}
-
 /*
  * By the time this is called, we already have created
  * the directory cache entry for the new file, but it
@@ -469,6 +456,115 @@ out:
 	return err;
 }
 
+/*
+ * Export operations
+ */
+static struct dentry *nilfs_get_parent(struct dentry *child)
+{
+	unsigned long ino;
+	struct inode *inode;
+	struct qstr dotdot = {.name = "..", .len = 2};
+	struct nilfs_root *root;
+
+	ino = nilfs_inode_by_name(child->d_inode, &dotdot);
+	if (!ino)
+		return ERR_PTR(-ENOENT);
+
+	root = NILFS_I(child->d_inode)->i_root;
+
+	inode = nilfs_iget(child->d_inode->i_sb, root, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+
+	return d_obtain_alias(inode);
+}
+
+static struct dentry *nilfs_get_dentry(struct super_block *sb, u64 cno,
+				       u64 ino, u32 gen)
+{
+	struct nilfs_root *root;
+	struct inode *inode;
+
+	if (ino < NILFS_FIRST_INO(sb) && ino != NILFS_ROOT_INO)
+		return ERR_PTR(-ESTALE);
+
+	root = nilfs_lookup_root(NILFS_SB(sb)->s_nilfs, cno);
+	if (!root)
+		return ERR_PTR(-ESTALE);
+
+	inode = nilfs_iget(sb, root, ino);
+	nilfs_put_root(root);
+
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+	if (gen && inode->i_generation != gen) {
+		iput(inode);
+		return ERR_PTR(-ESTALE);
+	}
+	return d_obtain_alias(inode);
+}
+
+static struct dentry *nilfs_fh_to_dentry(struct super_block *sb, struct fid *fh,
+					 int fh_len, int fh_type)
+{
+	struct nilfs_fid *fid = (struct nilfs_fid *)fh;
+
+	if ((fh_len != NILFS_FID_SIZE_NON_CONNECTABLE &&
+	     fh_len != NILFS_FID_SIZE_CONNECTABLE) ||
+	    (fh_type != FILEID_NILFS_WITH_PARENT &&
+	     fh_type != FILEID_NILFS_WITHOUT_PARENT))
+		return NULL;
+
+	return nilfs_get_dentry(sb, fid->cno, fid->ino, fid->gen);
+}
+
+static struct dentry *nilfs_fh_to_parent(struct super_block *sb, struct fid *fh,
+					 int fh_len, int fh_type)
+{
+	struct nilfs_fid *fid = (struct nilfs_fid *)fh;
+
+	if (fh_len != NILFS_FID_SIZE_CONNECTABLE ||
+	    fh_type != FILEID_NILFS_WITH_PARENT)
+		return NULL;
+
+	return nilfs_get_dentry(sb, fid->cno, fid->parent_ino, fid->parent_gen);
+}
+
+static int nilfs_encode_fh(struct dentry *dentry, __u32 *fh, int *lenp,
+			   int connectable)
+{
+	struct nilfs_fid *fid = (struct nilfs_fid *)fh;
+	struct inode *inode = dentry->d_inode;
+	struct nilfs_root *root = NILFS_I(inode)->i_root;
+	int type;
+
+	if (*lenp < NILFS_FID_SIZE_NON_CONNECTABLE ||
+	    (connectable && *lenp < NILFS_FID_SIZE_CONNECTABLE))
+		return 255;
+
+	fid->cno = root->cno;
+	fid->ino = inode->i_ino;
+	fid->gen = inode->i_generation;
+
+	if (connectable && !S_ISDIR(inode->i_mode)) {
+		struct inode *parent;
+
+		spin_lock(&dentry->d_lock);
+		parent = dentry->d_parent->d_inode;
+		fid->parent_ino = parent->i_ino;
+		fid->parent_gen = parent->i_generation;
+		spin_unlock(&dentry->d_lock);
+
+		type = FILEID_NILFS_WITH_PARENT;
+		*lenp = NILFS_FID_SIZE_CONNECTABLE;
+	} else {
+		type = FILEID_NILFS_WITHOUT_PARENT;
+		*lenp = NILFS_FID_SIZE_NON_CONNECTABLE;
+	}
+
+	return type;
+}
+
 const struct inode_operations nilfs_dir_inode_operations = {
 	.create		= nilfs_create,
 	.lookup		= nilfs_lookup,
@@ -493,3 +589,10 @@ const struct inode_operations nilfs_symlink_inode_operations = {
 	.follow_link	= page_follow_link_light,
 	.put_link	= page_put_link,
 };
+
+const struct export_operations nilfs_export_ops = {
+	.encode_fh = nilfs_encode_fh,
+	.fh_to_dentry = nilfs_fh_to_dentry,
+	.fh_to_parent = nilfs_fh_to_parent,
+	.get_parent = nilfs_get_parent,
+};
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 21d90c4..aa7940f 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -264,9 +264,6 @@ extern int nilfs_set_file_dirty(struct nilfs_sb_info *, struct inode *,
 extern int nilfs_mark_inode_dirty(struct inode *);
 extern void nilfs_dirty_inode(struct inode *);
 
-/* namei.c */
-extern struct dentry *nilfs_get_parent(struct dentry *);
-
 /* super.c */
 extern struct inode *nilfs_alloc_inode_common(struct the_nilfs *);
 extern struct inode *nilfs_alloc_inode(struct super_block *);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 0b82bdf..8c71f97 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -49,10 +49,10 @@
 #include <linux/vfs.h>
 #include <linux/writeback.h>
 #include <linux/kobject.h>
-#include <linux/exportfs.h>
 #include <linux/seq_file.h>
 #include <linux/mount.h>
 #include "nilfs.h"
+#include "export.h"
 #include "mdt.h"
 #include "alloc.h"
 #include "btree.h"
@@ -561,56 +561,6 @@ static const struct super_operations nilfs_sops = {
 	.show_options = nilfs_show_options
 };
 
-static struct inode *
-nilfs_nfs_get_inode(struct super_block *sb, u64 ino, u32 generation)
-{
-	struct inode *inode;
-	struct nilfs_root *root;
-
-	if (ino < NILFS_FIRST_INO(sb) && ino != NILFS_ROOT_INO &&
-	    ino != NILFS_SKETCH_INO)
-		return ERR_PTR(-ESTALE);
-
-	root = nilfs_lookup_root(NILFS_SB(sb)->s_nilfs,
-				 NILFS_CPTREE_CURRENT_CNO);
-	if (!root)
-		return ERR_PTR(-ESTALE);
-
-	/* new file handle type is required to export snapshots */
-	inode = nilfs_iget(sb, root, ino);
-	nilfs_put_root(root);
-	if (IS_ERR(inode))
-		return ERR_CAST(inode);
-	if (generation && inode->i_generation != generation) {
-		iput(inode);
-		return ERR_PTR(-ESTALE);
-	}
-
-	return inode;
-}
-
-static struct dentry *
-nilfs_fh_to_dentry(struct super_block *sb, struct fid *fid, int fh_len,
-		   int fh_type)
-{
-	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
-				    nilfs_nfs_get_inode);
-}
-
-static struct dentry *
-nilfs_fh_to_parent(struct super_block *sb, struct fid *fid, int fh_len,
-		   int fh_type)
-{
-	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
-				    nilfs_nfs_get_inode);
-}
-
-static const struct export_operations nilfs_export_ops = {
-	.fh_to_dentry = nilfs_fh_to_dentry,
-	.fh_to_parent = nilfs_fh_to_parent,
-	.get_parent = nilfs_get_parent,
-};
-
 enum {
 	Opt_err_cont, Opt_err_panic, Opt_err_ro,
 	Opt_barrier, Opt_nobarrier, Opt_snapshot, Opt_order, Opt_norecovery,
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index a9cd507..2802898 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -67,6 +67,19 @@ enum fid_type {
 	 * 32 bit parent block number, 32 bit parent generation number
 	 */
 	FILEID_UDF_WITH_PARENT = 0x52,
+
+	/*
+	 * 64 bit checkpoint number, 64 bit inode number,
+	 * 32 bit generation number.
+	 */
+	FILEID_NILFS_WITHOUT_PARENT = 0x61,
+
+	/*
+	 * 64 bit checkpoint number, 64 bit inode number,
+	 * 32 bit generation number, 32 bit parent generation.
+	 * 64 bit parent inode number.
+	 */
+	FILEID_NILFS_WITH_PARENT = 0x62,
 };
 
 struct fid {
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
