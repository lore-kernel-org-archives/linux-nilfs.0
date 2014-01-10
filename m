From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH v2 05/17] nilfs2: introduce xafile API
 implementation
Date: Fri, 10 Jan 2014 16:08:09 +0400
Message-ID: <1389355689.3938.125.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=Vlw3+f6ScJkRFFXfD4MiNHcZN0IT1lryfMBeYC/U7Uk=;
	b=WdTtr5AHIAKxnO5tVEVA8bN9BcTB2eeQ2D7MKjamdXoEc8KAlogperCWJP9CGHMlVsHYf3xX5X90n9Q5bs3IYi6Xl1XbFGwGUHabjk+JwOybyEqApdceU7ChTuVl/Rui;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH v2 05/17] nilfs2: introduce xafile API implementation

This patch adds implementation of xafile base functionality.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/nilfs.h         |    8 +-
 fs/nilfs2/the_nilfs.h     |    4 +
 fs/nilfs2/xafile.c        |  249 +++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/xafile.h        |   13 +++
 include/linux/nilfs2_fs.h |   17 +++-
 5 files changed, 282 insertions(+), 9 deletions(-)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 9bc72de..3cdacda 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -38,12 +38,12 @@
  * @i_state: dynamic state flags
  * @i_bmap: pointer on i_bmap_data
  * @i_bmap_data: raw block mapping
- * @i_xattr: <TODO>
  * @i_dir_start_lookup: page index of last successful search
  * @i_cno: checkpoint number for GC inode
  * @i_btnode_cache: cached pages of b-tree nodes
  * @i_dirty: list for connecting dirty files
  * @xattr_sem: semaphore for extended attributes processing
+ * @i_xattr: xanode number
  * @i_bh: buffer contains disk inode
  * @i_root: root object of the current filesystem tree
  * @vfs_inode: VFS inode object
@@ -53,13 +53,11 @@ struct nilfs_inode_info {
 	unsigned long  i_state;		/* Dynamic state flags */
 	struct nilfs_bmap *i_bmap;
 	struct nilfs_bmap i_bmap_data;
-	__u64 i_xattr;	/* sector_t ??? */
 	__u32 i_dir_start_lookup;
 	__u64 i_cno;		/* check point number for GC inode */
 	struct address_space i_btnode_cache;
 	struct list_head i_dirty;	/* List for connecting dirty files */
 
-#ifdef CONFIG_NILFS_XATTR
 	/*
 	 * Extended attributes can be read independently of the main file
 	 * data. Taking i_sem even when reading would cause contention
@@ -68,7 +66,9 @@ struct nilfs_inode_info {
 	 * EAs.
 	 */
 	struct rw_semaphore xattr_sem;
-#endif
+#define NILFS_INVALID_XANODE	((__u64)(0))
+	__u64 i_xattr;
+
 	struct buffer_head *i_bh;	/* i_bh contains a new or dirty
 					   disk inode */
 	struct nilfs_root *i_root;
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index de8cc53..0e69495 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -40,6 +40,7 @@ enum {
 	THE_NILFS_DISCONTINUED,	/* 'next' pointer chain has broken */
 	THE_NILFS_GC_RUNNING,	/* gc process is running */
 	THE_NILFS_SB_DIRTY,	/* super block is dirty */
+	THE_NILFS_HAS_XAFILE,	/* volume contains xafile */
 };
 
 /**
@@ -73,6 +74,7 @@ enum {
  * @ns_dat: DAT file inode
  * @ns_cpfile: checkpoint file inode
  * @ns_sufile: segusage file inode
+ * @ns_xafile: extended attributes file inode
  * @ns_cptree: rb-tree of all mounted checkpoints (nilfs_root)
  * @ns_cptree_lock: lock protecting @ns_cptree
  * @ns_dirty_files: list of dirty files
@@ -153,6 +155,7 @@ struct the_nilfs {
 	struct inode	       *ns_dat;
 	struct inode	       *ns_cpfile;
 	struct inode	       *ns_sufile;
+	struct inode	       *ns_xafile;
 
 	/* Checkpoint tree */
 	struct rb_root		ns_cptree;
@@ -208,6 +211,7 @@ THE_NILFS_FNS(INIT, init)
 THE_NILFS_FNS(DISCONTINUED, discontinued)
 THE_NILFS_FNS(GC_RUNNING, gc_running)
 THE_NILFS_FNS(SB_DIRTY, sb_dirty)
+THE_NILFS_FNS(HAS_XAFILE, has_xafile)
 
 /*
  * Mount option operations
diff --git a/fs/nilfs2/xafile.c b/fs/nilfs2/xafile.c
index 469b256..c84cf90 100644
--- a/fs/nilfs2/xafile.c
+++ b/fs/nilfs2/xafile.c
@@ -21,6 +21,11 @@
  * Written by Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
  */
 
+#include "nilfs.h"
+#include "alloc.h"
+#include "mdt.h"
+#include "xafile.h"
+
 /*
  *   ----------------------------------------------------------------
  *                     HOW DOES NILFS2 KEEP XATTRs?
@@ -114,3 +119,247 @@
  *   of binary value is defined as difference between
  *   entry_size and name_len.
  */
+
+/*
+ * struct nilfs_xafile_info - on-memory private data of xafile
+ * @mi: on-memory private data of metadata file
+ * @palloc_cache: persistent object allocator cache of xafile
+ */
+struct nilfs_xafile_info {
+	struct nilfs_mdt_info mi;
+	struct nilfs_palloc_cache palloc_cache;
+};
+
+/*
+ * NILFS_XAFILE_I - convert inode info into xafile inode info
+ */
+static inline
+struct nilfs_xafile_info *NILFS_XAFILE_I(struct inode *xafile)
+{
+	return (struct nilfs_xafile_info *)NILFS_MDT(xafile);
+}
+
+/*
+ * nilfs_xafile_get_node - get xafile node
+ * @xafile: xafile inode
+ * @node_id: node number
+ * @node_bh: buffer_head contains xafile node
+ */
+static
+int nilfs_xafile_get_node(struct inode *xafile, __u64 node_id,
+				struct buffer_head **node_bh)
+{
+	int err;
+	struct super_block *sb = xafile->i_sb;
+
+	err = nilfs_palloc_get_entry_block(xafile, node_id, 0, node_bh);
+	if (unlikely(err)) {
+		nilfs_warning(sb, __func__,
+				"unable to get xafile node: %llu",
+				node_id);
+	}
+
+	get_bh(*node_bh);
+
+	return err;
+}
+
+/*
+ * nilfs_xafile_prepare_node_creation - prepare allocation of xafile's xanode
+ * @xafile: xafile inode
+ * @req: request for the xanode allocation
+ */
+static
+int nilfs_xafile_prepare_node_creation(struct inode *xafile,
+					struct nilfs_palloc_req *req)
+{
+	int err;
+	void *kaddr, *nodep;
+
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(req->pr_desc_bh || req->pr_bitmap_bh || req->pr_entry_bh);
+#endif
+
+	req->pr_entry_nr = 0;
+
+	err = nilfs_palloc_prepare_alloc_entry(xafile, req);
+	if (unlikely(err < 0))
+		goto failed_prepare_new_node;
+
+	err = nilfs_palloc_get_entry_block(xafile, req->pr_entry_nr, 1,
+							&req->pr_entry_bh);
+	if (unlikely(err < 0)) {
+		nilfs_palloc_abort_alloc_entry(xafile, req);
+		goto failed_prepare_new_node;
+	}
+
+	get_bh(req->pr_entry_bh);
+
+	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
+	nodep = nilfs_palloc_block_get_entry(xafile, req->pr_entry_nr,
+						 req->pr_entry_bh, kaddr);
+	memset(nodep, 0, BH_SIZE(req->pr_entry_bh));
+	kunmap_atomic(kaddr);
+
+	return 0;
+
+failed_prepare_new_node:
+	return err;
+}
+
+/*
+ * nilfs_xafile_commit_node_creation - commit allocated xanode
+ * @xafile: xafile inode
+ * @req: request for the xanode allocation
+ */
+static inline
+void nilfs_xafile_commit_node_creation(struct inode *xafile,
+					struct nilfs_palloc_req *req)
+{
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(req->pr_entry_nr == NILFS_INVALID_XANODE);
+	BUG_ON(!req->pr_desc_bh || !req->pr_bitmap_bh || !req->pr_entry_bh);
+#endif
+
+	nilfs_palloc_commit_alloc_entry(xafile, req);
+	mark_buffer_dirty(req->pr_entry_bh);
+	nilfs_mdt_mark_dirty(xafile);
+	brelse(req->pr_entry_bh);
+}
+
+/*
+ * nilfs_xafile_abort_node_creation - abort allocation of xanode
+ * @xafile: xafile inode
+ * @req: request for the xanode allocation
+ */
+static inline
+void nilfs_xafile_abort_node_creation(struct inode *xafile,
+					struct nilfs_palloc_req *req)
+{
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(req->pr_entry_nr == NILFS_INVALID_XANODE);
+	BUG_ON(!req->pr_desc_bh || !req->pr_bitmap_bh || !req->pr_entry_bh);
+#endif
+
+	nilfs_forget_buffer(req->pr_entry_bh);
+	nilfs_palloc_abort_alloc_entry(xafile, req);
+}
+
+/*
+ * nilfs_xafile_prepare_node_deletion - prepare freeing of xafile's xanode
+ * @xafile: xafile inode
+ * @req: request for the xanode allocation
+ */
+static
+int nilfs_xafile_prepare_node_deletion(struct inode *xafile,
+					struct nilfs_palloc_req *req)
+{
+	int err;
+
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(req->pr_entry_nr == NILFS_INVALID_XANODE);
+	BUG_ON(req->pr_desc_bh || req->pr_bitmap_bh);
+#endif
+
+	err = nilfs_palloc_prepare_free_entry(xafile, req);
+	if (unlikely(err < 0))
+		goto failed_prepare_delete_node;
+
+	if (!req->pr_entry_bh) {
+		err = nilfs_palloc_get_entry_block(xafile, req->pr_entry_nr, 0,
+							&req->pr_entry_bh);
+		if (unlikely(err < 0)) {
+			nilfs_palloc_abort_free_entry(xafile, req);
+			goto failed_prepare_delete_node;
+		}
+	}
+
+	get_bh(req->pr_entry_bh);
+
+	return 0;
+
+failed_prepare_delete_node:
+	return err;
+}
+
+/*
+ * nilfs_xafile_commit_node_deletion - commit freeing of xafile's xanode
+ * @xafile: xafile inode
+ * @req: request for the xanode allocation
+ */
+static inline
+void nilfs_xafile_commit_node_deletion(struct inode *xafile,
+					struct nilfs_palloc_req *req)
+{
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(req->pr_entry_nr == NILFS_INVALID_XANODE);
+	BUG_ON(!req->pr_desc_bh || !req->pr_bitmap_bh || !req->pr_entry_bh);
+#endif
+
+	nilfs_palloc_commit_free_entry(xafile, req);
+	nilfs_mdt_mark_dirty(xafile);
+	brelse(req->pr_entry_bh);
+}
+
+/*
+ * nilfs_xafile_abort_node_deletion - abort freeing of xafile's xanode
+ * @xafile: xafile inode
+ * @req: request for the xanode allocation
+ */
+static inline
+void nilfs_xafile_abort_node_deletion(struct inode *xafile,
+					struct nilfs_palloc_req *req)
+{
+#ifdef CONFIG_NILFS2_FS_DEBUG
+	BUG_ON(req->pr_entry_nr == NILFS_INVALID_XANODE);
+	BUG_ON(!req->pr_desc_bh || !req->pr_bitmap_bh || !req->pr_entry_bh);
+#endif
+
+	nilfs_forget_buffer(req->pr_entry_bh);
+	nilfs_palloc_abort_free_entry(xafile, req);
+}
+
+/*
+ * nilfs_xafile_read - read or get xafile inode
+ * @sb: super block instance
+ * @raw_inode: on-disk xafile inode
+ * @inodep: buffer to store the inode [out]
+ */
+int nilfs_xafile_read(struct super_block *sb, struct nilfs_inode *raw_inode,
+			struct inode **inodep)
+{
+	struct inode *xafile;
+	int err;
+
+	xafile = nilfs_iget_locked(sb, NULL, NILFS_XATTR_INO);
+	if (unlikely(!xafile))
+		return -ENOMEM;
+	if (!(xafile->i_state & I_NEW))
+		goto out;
+
+	err = nilfs_mdt_init(xafile, NILFS_MDT_GFP,
+			     sizeof(struct nilfs_xafile_info));
+	if (unlikely(err))
+		goto failed;
+
+	/* TODO: [REWORK] it is used 4Kb node size temporary */
+	err = nilfs_palloc_init_blockgroup(xafile, PAGE_CACHE_SIZE);
+	if (unlikely(err))
+		goto failed;
+
+	nilfs_palloc_setup_cache(xafile, &NILFS_XAFILE_I(xafile)->palloc_cache);
+
+	err = nilfs_read_inode_common(xafile, raw_inode);
+	if (unlikely(err))
+		goto failed;
+
+	unlock_new_inode(xafile);
+
+ out:
+	*inodep = xafile;
+	return 0;
+
+ failed:
+	iget_failed(xafile);
+	return err;
+}
diff --git a/fs/nilfs2/xafile.h b/fs/nilfs2/xafile.h
index cee7b03..846ea3a 100644
--- a/fs/nilfs2/xafile.h
+++ b/fs/nilfs2/xafile.h
@@ -417,4 +417,17 @@ NILFS_XANODE_LAST_ENTRY(union nilfs_xanode_header *hdr)
 #define NILFS_XATTR_VALUE(entry, key) \
 	((char *)(entry) + NILFS_XANODE_NAME_HASH(key)->name_len)
 
+/* Xafile API */
+ssize_t nilfs_xafile_listxattr(struct dentry *dentry, char *buf, size_t size);
+ssize_t nilfs_xafile_getxattr(struct inode *inode,
+				int name_index, const char *name,
+				void *value, size_t size);
+int nilfs_xafile_setxattr(struct inode *inode,
+				int name_index, const char *name,
+				const void *value, size_t size, int flags);
+int nilfs_xafile_delete_inode(struct inode *inode);
+
+int nilfs_xafile_read(struct super_block *sb, struct nilfs_inode *raw_inode,
+			struct inode **inodep);
+
 #endif /* _NILFS_XAFILE_H */
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 9875576..531cf35 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -59,7 +59,7 @@
  * @i_links_count: links count
  * @i_flags: file flags
  * @i_bmap: block mapping
- * @i_xattr: extended attributes
+ * @i_xattr: xanode number (index of xafile's node)
  * @i_generation: file generation (for NFS)
  * @i_pad:	padding
  */
@@ -91,6 +91,7 @@ struct nilfs_inode {
  * @sr_dat: DAT file inode
  * @sr_cpfile: checkpoint file inode
  * @sr_sufile: segment usage file inode
+ * @sr_xafile: extended attributes file inode
  */
 struct nilfs_super_root {
 	__le32 sr_sum;
@@ -100,6 +101,7 @@ struct nilfs_super_root {
 	struct nilfs_inode sr_dat;
 	struct nilfs_inode sr_cpfile;
 	struct nilfs_inode sr_sufile;
+	struct nilfs_inode sr_xafile;
 };
 
 #define NILFS_SR_MDT_OFFSET(inode_size, i)  \
@@ -108,7 +110,8 @@ struct nilfs_super_root {
 #define NILFS_SR_DAT_OFFSET(inode_size)     NILFS_SR_MDT_OFFSET(inode_size, 0)
 #define NILFS_SR_CPFILE_OFFSET(inode_size)  NILFS_SR_MDT_OFFSET(inode_size, 1)
 #define NILFS_SR_SUFILE_OFFSET(inode_size)  NILFS_SR_MDT_OFFSET(inode_size, 2)
-#define NILFS_SR_BYTES(inode_size)	    NILFS_SR_MDT_OFFSET(inode_size, 3)
+#define NILFS_SR_XAFILE_OFFSET(inode_size)  NILFS_SR_MDT_OFFSET(inode_size, 3)
+#define NILFS_SR_BYTES(inode_size)	    NILFS_SR_MDT_OFFSET(inode_size, 4)
 
 /*
  * Maximal mount counts
@@ -219,9 +222,12 @@ struct nilfs_super_block {
  * doesn't know about, it should refuse to mount the filesystem.
  */
 #define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT	0x00000001ULL
+#define NILFS_FEATURE_COMPAT_RO_XAFILE		0x00000002ULL
 
 #define NILFS_FEATURE_COMPAT_SUPP	0ULL
-#define NILFS_FEATURE_COMPAT_RO_SUPP	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT
+#define NILFS_FEATURE_COMPAT_RO_SUPP	\
+	(NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT | \
+	 NILFS_FEATURE_COMPAT_RO_XAFILE)
 #define NILFS_FEATURE_INCOMPAT_SUPP	0ULL
 
 /*
@@ -239,7 +245,7 @@ struct nilfs_super_block {
 #define NILFS_SUFILE_INO	5	/* segment usage file */
 #define NILFS_IFILE_INO		6	/* ifile */
 #define NILFS_ATIME_INO		7	/* Atime file (reserved) */
-#define NILFS_XATTR_INO		8	/* Xattribute file (reserved) */
+#define NILFS_XATTR_INO		8	/* Xattribute file */
 #define NILFS_SKETCH_INO	10	/* Sketch file */
 #define NILFS_USER_INO		11	/* Fisrt user's file inode number */
 
@@ -258,7 +264,8 @@ struct nilfs_super_block {
  * garbage collector doesn't keep any past versions of these files.
  */
 #define NILFS_ROOT_METADATA_FILE(ino) \
-	((ino) >= NILFS_DAT_INO && (ino) <= NILFS_SUFILE_INO)
+	(((ino) >= NILFS_DAT_INO && (ino) <= NILFS_SUFILE_INO) || \
+	 (ino) == NILFS_XATTR_INO)
 
 /*
  * bytes offset of secondary super block
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
