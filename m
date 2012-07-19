From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 2/2] NILFS2: add omitted comments for different
 structures in driver implementation
Date: Thu, 19 Jul 2012 14:01:52 +0400
Message-ID: <1342692112.1982.10.camel@slavad-ubuntu-11>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:Cc:To:From:Subject; bh=z3wT0hNdTnLvPUQj38QCwpYP+bTo7+q3Sh4xOUd21To=;
	b=YIQ9VVdkJpGxzb1ZRaQKD9MMraW0s+SLXTT85n1iC4NXixg80zv60UK8xZPwb6EXMky64N8YfhJHyqYhm2Xney5VcWMgO8dyMPFd0jLY3+K3uzfFsTbKJ5dAhzt1NSXx;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Hi,

This second version of patch adds omitted comments for different
structures in driver implementation.

With the best regards,
Vyacheslav Dubeyko.
--
From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 2/2] NILFS2: add omitted comments for different
structures in driver implementation

This patch adds omitted comments for different structures in driver
implementation.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index f5fde36..ab59048 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -77,14 +77,22 @@ int nilfs_palloc_freev(struct inode *, __u64 *,
size_t);
 #define nilfs_find_next_zero_bit	find_next_zero_bit_le
 
 /*
- * persistent object allocator cache
+ * nilfs_bh_assoc - block offset and buffer head association
+ * @blkoff: block offset
+ * @bh: buffer head
  */
-
 struct nilfs_bh_assoc {
 	unsigned long blkoff;
 	struct buffer_head *bh;
 };
 
+/*
+ * nilfs_palloc_cache - persistent object allocator cache
+ * @lock: cache protecting lock
+ * @prev_desc: blockgroup descriptors cache
+ * @prev_bitmap: blockgroup bitmap cache
+ * @prev_entry: translation entries cache
+ */
 struct nilfs_palloc_cache {
 	spinlock_t lock;
 	struct nilfs_bh_assoc prev_desc;
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index 40d9f45..aa7cbfe 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -135,6 +135,13 @@ struct nilfs_bmap {
 /* state */
 #define NILFS_BMAP_DIRTY	0x00000001
 
+/*
+ * nilfs_bmap_store - shadow copy of bmap state
+ * @data: cached raw block mapping of on-disk inode
+ * @last_allocated_key: cached value of last allocated key for data
block
+ * @last_allocated_ptr: cached value of last allocated ptr for data
block
+ * @state: cached value of state field of bmap structure
+ */
 struct nilfs_bmap_store {
 	__le64 data[NILFS_BMAP_SIZE / sizeof(__le64)];
 	__u64 last_allocated_key;
diff --git a/fs/nilfs2/btnode.h b/fs/nilfs2/btnode.h
index 3a4dd2d..35ee6d0 100644
--- a/fs/nilfs2/btnode.h
+++ b/fs/nilfs2/btnode.h
@@ -29,7 +29,13 @@
 #include <linux/fs.h>
 #include <linux/backing-dev.h>
 
-
+/*
+ * nilfs_btnode_chkey_ctxt - change key context
+ * @oldkey: old key of block's moving content
+ * @newkey: new key for block's content
+ * @bh: buffer head of old buffer
+ * @newbh: buffer head of new buffer
+ */
 struct nilfs_btnode_chkey_ctxt {
 	__u64 oldkey;
 	__u64 newkey;
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index b5c13f3..dda0872 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -33,6 +33,12 @@
 #define NILFS_CNO_MIN	((__u64)1)
 #define NILFS_CNO_MAX	(~(__u64)0)
 
+/*
+ * nilfs_dat_info - on-memory private data of DAT file
+ * @mi: on-memory private data of metadata file
+ * @palloc_cache: persistent object allocator cache of DAT file
+ * @shadow: shadow map of DAT file
+ */
 struct nilfs_dat_info {
 	struct nilfs_mdt_info mi;
 	struct nilfs_palloc_cache palloc_cache;
diff --git a/fs/nilfs2/export.h b/fs/nilfs2/export.h
index a71cc41..8982ae3 100644
--- a/fs/nilfs2/export.h
+++ b/fs/nilfs2/export.h
@@ -5,6 +5,14 @@
 
 extern const struct export_operations nilfs_export_ops;
 
+/*
+ * nilfs_fid - NILFS file id type
+ * @cno: checkpoint number
+ * @ino: inode number
+ * @gen: file generation (version) for NFS
+ * @parent_gen: parent generation (version) for NFS
+ * @parent_ino: parent inode number
+ */
 struct nilfs_fid {
 	u64 cno;
 	u64 ino;
diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index 5a48df7..a043971 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -29,7 +29,11 @@
 #include "alloc.h"
 #include "ifile.h"
 
-
+/*
+ * nilfs_ifile_info - on-memory private data of ifile
+ * @mi: on-memory private data of metadata file
+ * @palloc_cache: persistent object allocator cache of ifile
+ */
 struct nilfs_ifile_info {
 	struct nilfs_mdt_info mi;
 	struct nilfs_palloc_cache palloc_cache;
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 7cc6446..6f05be5 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -34,6 +34,13 @@
 #include "cpfile.h"
 #include "ifile.h"
 
+/*
+ * nilfs_iget_args - arguments used during comparison between inodes
+ * @ino: inode number
+ * @cno: checkpoint number
+ * @root: pointer on NILFS root object (mounted checkpoint)
+ * @for_gc: inode for GC flag
+ */
 struct nilfs_iget_args {
 	u64 ino;
 	__u64 cno;
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index ab20a4b..6041042 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -28,6 +28,13 @@
 #include "nilfs.h"
 #include "page.h"
 
+/*
+ * nilfs_shadow_map - shadow mapping of meta data file
+ * @bmap_store: shadow copy of bmap state
+ * @frozen_data: shadowed dirty data pages
+ * @frozen_btnodes: shadowed dirty b-tree nodes' pages
+ * @frozen_buffers: list of frozen buffers
+ */
 struct nilfs_shadow_map {
 	struct nilfs_bmap_store bmap_store;
 	struct address_space frozen_data;
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 250add8..30fd85c 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -33,7 +33,20 @@
 #include "bmap.h"
 
 /*
- * nilfs inode data in memory
+ * nilfs_inode_info - nilfs inode data in memory
+ * @i_flags: inode flags
+ * @i_state: dynamic state flags
+ * @i_bmap: pointer on i_bmap_data
+ * @i_bmap_data: raw block mapping
+ * @i_xattr: <TODO>
+ * @i_dir_start_lookup: page index of last successful search
+ * @i_cno: checkpoint number for GC inode
+ * @i_btnode_cache: cached pages of b-tree nodes
+ * @i_dirty: list for connecting dirty files
+ * @xattr_sem: semaphore for extended attributes processing
+ * @i_bh: buffer contains disk inode
+ * @i_root: root object of the current filesystem tree
+ * @vfs_inode: VFS inode object
  */
 struct nilfs_inode_info {
 	__u32 i_flags;
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index c5b7653..6abe4bc 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -30,7 +30,13 @@
 #include "mdt.h"
 #include "sufile.h"
 
-
+/*
+ * nilfs_sufile_info - on-memory private data of sufile
+ * @mi: on-memory private data of metadata file
+ * @ncleansegs: number of clean segments
+ * @allocmin: lower limit of allocatable segment range
+ * @allocmax: upper limit of allocatable segment range
+ */
 struct nilfs_sufile_info {
 	struct nilfs_mdt_info mi;
 	unsigned long ncleansegs;/* number of clean segments */
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 9992b11..31198f1 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -229,9 +229,8 @@ THE_NILFS_FNS(SB_DIRTY, sb_dirty)
  * @count: refcount of this structure
  * @nilfs: nilfs object
  * @ifile: inode file
- * @root: root inode
  * @inodes_count: number of inodes
- * @blocks_count: number of blocks (Reserved)
+ * @blocks_count: number of blocks
  */
 struct nilfs_root {
 	__u64 cno;
--


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
