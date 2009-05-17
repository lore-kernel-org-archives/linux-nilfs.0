From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 6/6] nilfs2: remove header file for segment
	list operations
Date: Mon, 18 May 2009 00:29:46 +0900
Message-ID: <1242574186-21554-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1242574186-21554-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1242574186-21554-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This will eliminate obsolete list operations of nilfs_segment_entry
structure which has been used to handle mutiple segment numbers.

The patch ("nilfs2: remove list of freeing segments") removed use of
the structure from the segment constructor code, and this patch
simplifies the remaining code by integrating it into recovery.c.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/recovery.c  |   37 +++++++++++++++--------
 fs/nilfs2/seglist.h   |   79 -------------------------------------------------
 fs/nilfs2/segment.h   |    1 +
 fs/nilfs2/the_nilfs.c |    1 -
 4 files changed, 25 insertions(+), 93 deletions(-)
 delete mode 100644 fs/nilfs2/seglist.h

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 57afa9d..d80cc71 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -28,7 +28,6 @@
 #include "segment.h"
 #include "sufile.h"
 #include "page.h"
-#include "seglist.h"
 #include "segbuf.h"
 
 /*
@@ -395,6 +394,24 @@ static void dispose_recovery_list(struct list_head *head)
 	}
 }
 
+struct nilfs_segment_entry {
+	struct list_head	list;
+	__u64			segnum;
+};
+
+static int nilfs_segment_list_add(struct list_head *head, __u64 segnum)
+{
+	struct nilfs_segment_entry *ent = kmalloc(sizeof(*ent), GFP_NOFS);
+
+	if (unlikely(!ent))
+		return -ENOMEM;
+
+	ent->segnum = segnum;
+	INIT_LIST_HEAD(&ent->list);
+	list_add_tail(&ent->list, head);
+	return 0;
+}
+
 void nilfs_dispose_segment_list(struct list_head *head)
 {
 	while (!list_empty(head)) {
@@ -402,7 +419,7 @@ void nilfs_dispose_segment_list(struct list_head *head)
 			= list_entry(head->next,
 				     struct nilfs_segment_entry, list);
 		list_del(&ent->list);
-		nilfs_free_segment_entry(ent);
+		kfree(ent);
 	}
 }
 
@@ -431,12 +448,10 @@ static int nilfs_prepare_segment_for_recovery(struct the_nilfs *nilfs,
 	if (unlikely(err))
 		goto failed;
 
-	err = -ENOMEM;
 	for (i = 1; i < 4; i++) {
-		ent = nilfs_alloc_segment_entry(segnum[i]);
-		if (unlikely(!ent))
+		err = nilfs_segment_list_add(head, segnum[i]);
+		if (unlikely(err))
 			goto failed;
-		list_add_tail(&ent->list, head);
 	}
 
 	/*
@@ -450,7 +465,7 @@ static int nilfs_prepare_segment_for_recovery(struct the_nilfs *nilfs,
 				goto failed;
 		}
 		list_del(&ent->list);
-		nilfs_free_segment_entry(ent);
+		kfree(ent);
 	}
 
 	/* Allocate new segments for recovery */
@@ -791,7 +806,6 @@ int nilfs_search_super_root(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi,
 	u64 seg_seq;
 	__u64 segnum, nextnum = 0;
 	__u64 cno;
-	struct nilfs_segment_entry *ent;
 	LIST_HEAD(segments);
 	int empty_seg = 0, scan_newer = 0;
 	int ret;
@@ -892,12 +906,9 @@ int nilfs_search_super_root(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi,
 		if (empty_seg++)
 			goto super_root_found; /* found a valid super root */
 
-		ent = nilfs_alloc_segment_entry(segnum);
-		if (unlikely(!ent)) {
-			ret = -ENOMEM;
+		ret = nilfs_segment_list_add(&segments, segnum);
+		if (unlikely(ret))
 			goto failed;
-		}
-		list_add_tail(&ent->list, &segments);
 
 		seg_seq++;
 		segnum = nextnum;
diff --git a/fs/nilfs2/seglist.h b/fs/nilfs2/seglist.h
deleted file mode 100644
index e448e40..0000000
--- a/fs/nilfs2/seglist.h
+++ /dev/null
@@ -1,79 +0,0 @@
-/*
- * seglist.h - expediential structure and routines to handle list of segments
- *             (would be removed in a future release)
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
-#ifndef _NILFS_SEGLIST_H
-#define _NILFS_SEGLIST_H
-
-#include <linux/fs.h>
-#include <linux/buffer_head.h>
-#include <linux/nilfs2_fs.h>
-#include "sufile.h"
-
-struct nilfs_segment_entry {
-	__u64			segnum;
-
-	struct list_head	list;
-	struct buffer_head     *bh_su;
-	struct nilfs_segment_usage *raw_su;
-};
-
-
-void nilfs_dispose_segment_list(struct list_head *);
-
-static inline struct nilfs_segment_entry *
-nilfs_alloc_segment_entry(__u64 segnum)
-{
-	struct nilfs_segment_entry *ent = kmalloc(sizeof(*ent), GFP_NOFS);
-
-	if (likely(ent)) {
-		ent->segnum = segnum;
-		ent->bh_su = NULL;
-		ent->raw_su = NULL;
-		INIT_LIST_HEAD(&ent->list);
-	}
-	return ent;
-}
-
-static inline int nilfs_open_segment_entry(struct nilfs_segment_entry *ent,
-					   struct inode *sufile)
-{
-	return nilfs_sufile_get_segment_usage(sufile, ent->segnum,
-					      &ent->raw_su, &ent->bh_su);
-}
-
-static inline void nilfs_close_segment_entry(struct nilfs_segment_entry *ent,
-					     struct inode *sufile)
-{
-	if (!ent->bh_su)
-		return;
-	nilfs_sufile_put_segment_usage(sufile, ent->segnum, ent->bh_su);
-	ent->bh_su = NULL;
-	ent->raw_su = NULL;
-}
-
-static inline void nilfs_free_segment_entry(struct nilfs_segment_entry *ent)
-{
-	kfree(ent);
-}
-
-#endif /* _NILFS_SEGLIST_H */
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index f36a851..0d2a475 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -239,5 +239,6 @@ extern int nilfs_search_super_root(struct the_nilfs *, struct nilfs_sb_info *,
 extern int nilfs_recover_logical_segments(struct the_nilfs *,
 					  struct nilfs_sb_info *,
 					  struct nilfs_recovery_info *);
+extern void nilfs_dispose_segment_list(struct list_head *);
 
 #endif /* _NILFS_SEGMENT_H */
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 9befbc8..14b6404 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -32,7 +32,6 @@
 #include "cpfile.h"
 #include "sufile.h"
 #include "dat.h"
-#include "seglist.h"
 #include "segbuf.h"
 
 void nilfs_set_last_segment(struct the_nilfs *nilfs,
-- 
1.6.2
