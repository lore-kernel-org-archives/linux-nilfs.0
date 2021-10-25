From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: remove filenames from file comments
Date: Mon, 25 Oct 2021 17:51:02 +0900
Message-ID: <1635151862-11547-3-git-send-email-konishi.ryusuke@gmail.com>
References: <1635151862-11547-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Nv98mPif22qA+oqqbcCmi2QFJkv72OA0pxbhj9BmcG8=;
        b=mhuFylsTXHZgzx4e4a0JGhhb46FxbJlPpYZxio+kJKr4fMVWONWAQpDgOpD54m6c2Q
         +6rVhsxlxScfk6ZAJl393CVGgs3Kmrg2HP460ULEnWxWkzJLPtHlP+Xgd/g1R57Tpqfj
         zyUipa4oA/VusO0cohQO1j4Wwj6wGJndUPxhMXrXehdg6lJjSPEsCcpBj0wdUTO7glCa
         LpZcSVenktUbTZeVO/f/t4OO5wDbgpbSvdFqwNzuzJISMmPQU7H3Z3hzLauDMFoHkqKy
         AI7mrPcyXaqdS4OmrS30Q0SInT7O3aF8l4DogbbogUui2yZUhoja8Gz8F+Q0AE+Y7rYx
         eFoQ==
In-Reply-To: <1635151862-11547-1-git-send-email-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Remove filenames that are not particularly useful in file comments,
and suppress checkpatch warnings "WARNING: It's generally not useful
to have the filename in the file".

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/alloc.c     | 2 +-
 fs/nilfs2/alloc.h     | 2 +-
 fs/nilfs2/bmap.c      | 2 +-
 fs/nilfs2/bmap.h      | 2 +-
 fs/nilfs2/btnode.c    | 2 +-
 fs/nilfs2/btnode.h    | 2 +-
 fs/nilfs2/btree.c     | 2 +-
 fs/nilfs2/btree.h     | 2 +-
 fs/nilfs2/cpfile.c    | 2 +-
 fs/nilfs2/cpfile.h    | 2 +-
 fs/nilfs2/dat.c       | 2 +-
 fs/nilfs2/dat.h       | 2 +-
 fs/nilfs2/dir.c       | 2 +-
 fs/nilfs2/direct.c    | 2 +-
 fs/nilfs2/direct.h    | 2 +-
 fs/nilfs2/file.c      | 2 +-
 fs/nilfs2/gcinode.c   | 2 +-
 fs/nilfs2/ifile.c     | 2 +-
 fs/nilfs2/ifile.h     | 2 +-
 fs/nilfs2/inode.c     | 2 +-
 fs/nilfs2/ioctl.c     | 2 +-
 fs/nilfs2/mdt.c       | 2 +-
 fs/nilfs2/mdt.h       | 2 +-
 fs/nilfs2/namei.c     | 2 +-
 fs/nilfs2/nilfs.h     | 2 +-
 fs/nilfs2/page.c      | 2 +-
 fs/nilfs2/page.h      | 2 +-
 fs/nilfs2/recovery.c  | 2 +-
 fs/nilfs2/segbuf.c    | 2 +-
 fs/nilfs2/segbuf.h    | 2 +-
 fs/nilfs2/segment.c   | 2 +-
 fs/nilfs2/segment.h   | 2 +-
 fs/nilfs2/sufile.c    | 2 +-
 fs/nilfs2/sufile.h    | 2 +-
 fs/nilfs2/super.c     | 2 +-
 fs/nilfs2/sysfs.c     | 2 +-
 fs/nilfs2/sysfs.h     | 2 +-
 fs/nilfs2/the_nilfs.c | 2 +-
 fs/nilfs2/the_nilfs.h | 2 +-
 39 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index adf3bb0a8048..6ce8617b562d 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * alloc.c - NILFS dat/inode allocator
+ * NILFS dat/inode allocator
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index 0303c3968cee..b667e869ac07 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * alloc.h - persistent object (dat entry/disk inode) allocator/deallocator
+ * Persistent object (dat entry/disk inode) allocator/deallocator
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index 5900879d5693..798a2c1b38c6 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * bmap.c - NILFS block mapping.
+ * NILFS block mapping.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index 2c63858e81c9..608168a5cb88 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * bmap.h - NILFS block mapping.
+ * NILFS block mapping.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 4391fd3abd8f..66bdaa2cf496 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * btnode.c - NILFS B-tree node cache
+ * NILFS B-tree node cache
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/btnode.h b/fs/nilfs2/btnode.h
index 0f88dbc9bcb3..11663650add7 100644
--- a/fs/nilfs2/btnode.h
+++ b/fs/nilfs2/btnode.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * btnode.h - NILFS B-tree node cache
+ * NILFS B-tree node cache
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index ab9ec073330f..3594eabe1419 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * btree.c - NILFS B-tree.
+ * NILFS B-tree.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/btree.h b/fs/nilfs2/btree.h
index d1421b646ce4..92868e1a48ca 100644
--- a/fs/nilfs2/btree.h
+++ b/fs/nilfs2/btree.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * btree.h - NILFS B-tree.
+ * NILFS B-tree.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index ce144776b4ef..9ebefb3acb0e 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * cpfile.c - NILFS checkpoint file.
+ * NILFS checkpoint file.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/cpfile.h b/fs/nilfs2/cpfile.h
index 6336222df24a..edabb2dc5756 100644
--- a/fs/nilfs2/cpfile.h
+++ b/fs/nilfs2/cpfile.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * cpfile.h - NILFS checkpoint file.
+ * NILFS checkpoint file.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 8bccdf1158fc..dc51d3b7a7bf 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * dat.c - NILFS disk address translation.
+ * NILFS disk address translation.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
index b17ee34580ae..468c82d26183 100644
--- a/fs/nilfs2/dat.h
+++ b/fs/nilfs2/dat.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * dat.h - NILFS disk address translation.
+ * NILFS disk address translation.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 81394e22d0a0..f8f4c2ff52f4 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * dir.c - NILFS directory entry operations
+ * NILFS directory entry operations
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index f353101955e3..a35f2795b242 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * direct.c - NILFS direct block pointer.
+ * NILFS direct block pointer.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/direct.h b/fs/nilfs2/direct.h
index ec9a23c77994..b7ca896269af 100644
--- a/fs/nilfs2/direct.h
+++ b/fs/nilfs2/direct.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * direct.h - NILFS direct block pointer.
+ * NILFS direct block pointer.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 7cf765258fda..a265d391ffe9 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * file.c - NILFS regular file handling primitives including fsync().
+ * NILFS regular file handling primitives including fsync().
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 448320496856..a8f5315f01e3 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * gcinode.c - dummy inodes to buffer blocks for garbage collection
+ * Dummy inodes to buffer blocks for garbage collection
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index 02727ed3a7c6..a8a4bc8490b4 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * ifile.c - NILFS inode file
+ * NILFS inode file
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/ifile.h b/fs/nilfs2/ifile.h
index a1e1e5711a05..35c5273f4821 100644
--- a/fs/nilfs2/ifile.h
+++ b/fs/nilfs2/ifile.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * ifile.h - NILFS inode file
+ * NILFS inode file
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 2e8eb263cf0f..e3d807d5b83a 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * inode.c - NILFS inode operations.
+ * NILFS inode operations.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 640ac8fe891e..efa76a80ee25 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * ioctl.c - NILFS ioctl operations.
+ * NILFS ioctl operations.
  *
  * Copyright (C) 2007, 2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 97769fe4d588..4b3d33cf0041 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * mdt.c - meta data file for NILFS
+ * Meta data file for NILFS
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index e77aea4bb921..8f86080a436d 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * mdt.h - NILFS meta data file prototype and definitions
+ * NILFS meta data file prototype and definitions
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 91eebeb0c48b..23899e0ae850 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * namei.c - NILFS pathname lookup operations.
+ * NILFS pathname lookup operations.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 60b21b6eeac0..a7b81755c350 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * nilfs.h - NILFS local header file.
+ * NILFS local header file.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 171fb5cd427f..bc3e2cd4117f 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * page.c - buffer/page management specific to NILFS
+ * Buffer/page management specific to NILFS
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index 62b9bb469e92..569263b23c0c 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * page.h - buffer/page management specific to NILFS
+ * Buffer/page management specific to NILFS
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 2217f904a7cf..9e2ed76c0f25 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * recovery.c - NILFS recovery logic
+ * NILFS recovery logic
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 56872e93823d..43287b0d3e9b 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * segbuf.c - NILFS segment buffer
+ * NILFS segment buffer
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
index 9bea1bd59041..e20091ededba 100644
--- a/fs/nilfs2/segbuf.h
+++ b/fs/nilfs2/segbuf.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * segbuf.h - NILFS Segment buffer prototypes and definitions
+ * NILFS Segment buffer prototypes and definitions
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 686c8ee7b29c..85a853334771 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * segment.c - NILFS segment constructor.
+ * NILFS segment constructor.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index f5cf5308f3fc..1060f72ebf5a 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * segment.h - NILFS Segment constructor prototypes and definitions
+ * NILFS Segment constructor prototypes and definitions
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 63722475e17e..e385cca2004a 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * sufile.c - NILFS segment usage file.
+ * NILFS segment usage file.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index c4e2c7a7add1..8e8a1a5a0402 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * sufile.h - NILFS segment usage file.
+ * NILFS segment usage file.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index f6b2d280aab5..63cffe010c6e 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * super.c - NILFS module and super block management.
+ * NILFS module and super block management.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index be407072def7..81f35c5b5a40 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * sysfs.c - sysfs support implementation.
+ * Sysfs support implementation.
  *
  * Copyright (C) 2005-2014 Nippon Telegraph and Telephone Corporation.
  * Copyright (C) 2014 HGST, Inc., a Western Digital Company.
diff --git a/fs/nilfs2/sysfs.h b/fs/nilfs2/sysfs.h
index d001eb862dae..78a87a016928 100644
--- a/fs/nilfs2/sysfs.h
+++ b/fs/nilfs2/sysfs.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * sysfs.h - sysfs support declarations.
+ * Sysfs support declarations.
  *
  * Copyright (C) 2005-2014 Nippon Telegraph and Telephone Corporation.
  * Copyright (C) 2014 HGST, Inc., a Western Digital Company.
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index c8bfc01da5d7..2044a2058be7 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * the_nilfs.c - the_nilfs shared structure.
+ * the_nilfs shared structure.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 987c8ab02aee..47c7dfbb7ea5 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * the_nilfs.h - the_nilfs shared structure.
+ * the_nilfs shared structure.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
-- 
1.8.3.1

