From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/2] NILFS2: add omitted comments for different structures in driver implementation
Date: Mon, 16 Jul 2012 23:52:06 +0400
Message-ID: <DBB2EDBA-17E4-41B9-9B46-250D0DC12127@dubeyko.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:To:Message-Id:Date:Subject:Content-Transfer-Encoding:Content-Type:From; bh=dAgTpi61DO27WSR4wDO987UHFRWFbdIAj1/zfTtLsdA=;
	b=Yet6hmXmLNL8UzhjZ90hQBC6yxYO5QrkHkXm81PffEJ7TNuGD0UiTYVeP5tyofDfmONth3g1VcnN9Hvfblapv1iAsbJTKW7K0UXlFX7jCsVMP7ngrieq+lPa+lOnAXDe;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

This patch adds omitted comments for different structures in driver imp=
lementation.

With the best regards,
Vyacheslav Dubeyko.
--
=46rom: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/2] NILFS2: add omitted comments for different structu=
res in driver implementation

This patch adds omitted comments for different structures in driver imp=
lementation.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index f5fde36..ab59048 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -77,14 +77,22 @@ int nilfs_palloc_freev(struct inode *, __u64 *, siz=
e_t);
 #define nilfs_find_next_zero_bit	find_next_zero_bit_le
=20
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
=20
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
=20
+/*
+ * nilfs_bmap_store - shadow copy of bmap state
+ * @data: cached raw block mapping of on-disk inode
+ * @last_allocated_key: cached value of last allocated key for data bl=
ock
+ * @last_allocated_ptr: cached value of last allocated ptr for data bl=
ock
+ * @state: cached value of state field of bmap structure
+ */
 struct nilfs_bmap_store {
 	__le64 data[NILFS_BMAP_SIZE / sizeof(__le64)];
 	__u64 last_allocated_key;
diff --git a/fs/nilfs2/btnode.h b/fs/nilfs2/btnode.h
index 3a4dd2d..148f03b 100644
--- a/fs/nilfs2/btnode.h
+++ b/fs/nilfs2/btnode.h
@@ -29,7 +29,13 @@
 #include <linux/fs.h>
 #include <linux/backing-dev.h>
=20
-
+/*
+ * nilfs_btnode_chkey_ctxt - change key context
+ * @oldkey: old key of block=92s moving content
+ * @newkey: new key for block=92s content
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
=20
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
=20
 extern const struct export_operations nilfs_export_ops;
=20
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
=20
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
=20
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
=20
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
=20
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
=20
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
index 9992b11..6b3ac84 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -229,7 +229,6 @@ THE_NILFS_FNS(SB_DIRTY, sb_dirty)
  * @count: refcount of this structure
  * @nilfs: nilfs object
  * @ifile: inode file
- * @root: root inode
  * @inodes_count: number of inodes
  * @blocks_count: number of blocks (Reserved)
  */
--

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
