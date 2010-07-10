From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 6/6] nilfs2: get rid of nilfs_bmap_union
Date: Sun, 11 Jul 2010 00:01:54 +0900
Message-ID: <1278774114-17917-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1278774114-17917-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1278774114-17917-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This removes nilfs_bmap_union and finally unifies three structures and
the union in bmap/btree code into one.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.c       |    6 ++++--
 fs/nilfs2/bmap_union.h |   42 ------------------------------------------
 fs/nilfs2/btree.h      |    8 --------
 fs/nilfs2/direct.h     |   11 -----------
 fs/nilfs2/gcinode.c    |    2 ++
 fs/nilfs2/mdt.c        |    1 +
 fs/nilfs2/nilfs.h      |    7 ++-----
 fs/nilfs2/super.c      |    4 +++-
 8 files changed, 12 insertions(+), 69 deletions(-)
 delete mode 100644 fs/nilfs2/bmap_union.h

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index effdbdb..3dbdc1d 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -26,6 +26,8 @@
 #include "nilfs.h"
 #include "bmap.h"
 #include "sb.h"
+#include "btree.h"
+#include "direct.h"
 #include "btnode.h"
 #include "mdt.h"
 #include "dat.h"
@@ -533,7 +535,7 @@ void nilfs_bmap_init_gc(struct nilfs_bmap *bmap)
 
 void nilfs_bmap_init_gcdat(struct nilfs_bmap *gcbmap, struct nilfs_bmap *bmap)
 {
-	memcpy(gcbmap, bmap, sizeof(union nilfs_bmap_union));
+	memcpy(gcbmap, bmap, sizeof(*bmap));
 	init_rwsem(&gcbmap->b_sem);
 	lockdep_set_class(&bmap->b_sem, &nilfs_bmap_dat_lock_key);
 	gcbmap->b_inode = &NILFS_BMAP_I(gcbmap)->vfs_inode;
@@ -541,7 +543,7 @@ void nilfs_bmap_init_gcdat(struct nilfs_bmap *gcbmap, struct nilfs_bmap *bmap)
 
 void nilfs_bmap_commit_gcdat(struct nilfs_bmap *gcbmap, struct nilfs_bmap *bmap)
 {
-	memcpy(bmap, gcbmap, sizeof(union nilfs_bmap_union));
+	memcpy(bmap, gcbmap, sizeof(*bmap));
 	init_rwsem(&bmap->b_sem);
 	lockdep_set_class(&bmap->b_sem, &nilfs_bmap_dat_lock_key);
 	bmap->b_inode = &NILFS_BMAP_I(bmap)->vfs_inode;
diff --git a/fs/nilfs2/bmap_union.h b/fs/nilfs2/bmap_union.h
deleted file mode 100644
index d41509b..0000000
--- a/fs/nilfs2/bmap_union.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * bmap_union.h - NILFS block mapping.
- *
- * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
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
- * Written by Koji Sato <koji-sG5X7nlA6pw@public.gmane.org>.
- */
-
-#ifndef _NILFS_BMAP_UNION_H
-#define _NILFS_BMAP_UNION_H
-
-#include "bmap.h"
-#include "direct.h"
-#include "btree.h"
-
-/**
- * nilfs_bmap_union -
- * @bi_bmap: bmap structure
- * @bi_btree: direct map structure
- * @bi_direct: B-tree structure
- */
-union nilfs_bmap_union {
-	struct nilfs_bmap bi_bmap;
-	struct nilfs_direct bi_direct;
-	struct nilfs_btree bi_btree;
-};
-
-#endif	/* _NILFS_BMAP_UNION_H */
diff --git a/fs/nilfs2/btree.h b/fs/nilfs2/btree.h
index cffbfba..22c02e3 100644
--- a/fs/nilfs2/btree.h
+++ b/fs/nilfs2/btree.h
@@ -31,14 +31,6 @@
 #include "bmap.h"
 
 /**
- * struct nilfs_btree - B-tree structure
- * @bt_bmap: bmap base structure
- */
-struct nilfs_btree {
-	struct nilfs_bmap bt_bmap;
-};
-
-/**
  * struct nilfs_btree_path - A path on which B-tree operations are executed
  * @bp_bh: buffer head of node block
  * @bp_sib_bh: buffer head of sibling node block
diff --git a/fs/nilfs2/direct.h b/fs/nilfs2/direct.h
index a5ffd66..dc643de 100644
--- a/fs/nilfs2/direct.h
+++ b/fs/nilfs2/direct.h
@@ -28,8 +28,6 @@
 #include "bmap.h"
 
 
-struct nilfs_direct;
-
 /**
  * struct nilfs_direct_node - direct node
  * @dn_flags: flags
@@ -40,15 +38,6 @@ struct nilfs_direct_node {
 	__u8 pad[7];
 };
 
-/**
- * struct nilfs_direct - direct mapping
- * @d_bmap: bmap structure
- */
-struct nilfs_direct {
-	struct nilfs_bmap d_bmap;
-};
-
-
 #define NILFS_DIRECT_NBLOCKS	(NILFS_BMAP_SIZE / sizeof(__le64) - 1)
 #define NILFS_DIRECT_KEY_MIN	0
 #define NILFS_DIRECT_KEY_MAX	(NILFS_DIRECT_NBLOCKS - 1)
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index edb53fc..b634382 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -48,6 +48,8 @@
 #include <linux/slab.h>
 #include <linux/swap.h>
 #include "nilfs.h"
+#include "btree.h"
+#include "btnode.h"
 #include "page.h"
 #include "mdt.h"
 #include "dat.h"
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 024be8c..d01aff4 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -28,6 +28,7 @@
 #include <linux/swap.h>
 #include <linux/slab.h>
 #include "nilfs.h"
+#include "btnode.h"
 #include "segment.h"
 #include "page.h"
 #include "mdt.h"
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 36998ea..cfedc48 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -32,7 +32,6 @@
 #include "the_nilfs.h"
 #include "sb.h"
 #include "bmap.h"
-#include "bmap_union.h"
 
 /*
  * nilfs inode data in memory
@@ -41,7 +40,7 @@ struct nilfs_inode_info {
 	__u32 i_flags;
 	unsigned long  i_state;		/* Dynamic state flags */
 	struct nilfs_bmap *i_bmap;
-	union nilfs_bmap_union i_bmap_union;
+	struct nilfs_bmap i_bmap_data;
 	__u64 i_xattr;	/* sector_t ??? */
 	__u32 i_dir_start_lookup;
 	__u64 i_cno;		/* check point number for GC inode */
@@ -71,9 +70,7 @@ static inline struct nilfs_inode_info *NILFS_I(const struct inode *inode)
 static inline struct nilfs_inode_info *
 NILFS_BMAP_I(const struct nilfs_bmap *bmap)
 {
-	return container_of((union nilfs_bmap_union *)bmap,
-			    struct nilfs_inode_info,
-			    i_bmap_union);
+	return container_of(bmap, struct nilfs_inode_info, i_bmap_data);
 }
 
 static inline struct inode *NILFS_BTNC_I(struct address_space *btnc)
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 952f4cc..1644573 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -55,6 +55,8 @@
 #include "nilfs.h"
 #include "mdt.h"
 #include "alloc.h"
+#include "btree.h"
+#include "btnode.h"
 #include "page.h"
 #include "cpfile.h"
 #include "ifile.h"
@@ -1213,7 +1215,7 @@ static void nilfs_inode_init_once(void *obj)
 	init_rwsem(&ii->xattr_sem);
 #endif
 	nilfs_btnode_cache_init_once(&ii->i_btnode_cache);
-	ii->i_bmap = (struct nilfs_bmap *)&ii->i_bmap_union;
+	ii->i_bmap = &ii->i_bmap_data;
 	inode_init_once(&ii->vfs_inode);
 }
 
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
