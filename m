From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 5/6] nilfs2: unify bmap set_target_v operations
Date: Sun, 11 Jul 2010 00:01:53 +0900
Message-ID: <1278774114-17917-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This unifies two similar functions nilfs_btree_set_target_v and
nilfs_direct_set_target_v into one, nilfs_bmap_set_target_v.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.h   |    7 +++++++
 fs/nilfs2/btree.c  |   11 ++---------
 fs/nilfs2/direct.c |    9 +--------
 3 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index 379fda4..fae83cf 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -219,6 +219,13 @@ static inline void nilfs_bmap_abort_end_ptr(struct nilfs_bmap *bmap,
 		nilfs_dat_abort_end(dat, &req->bpr_req);
 }
 
+static inline void nilfs_bmap_set_target_v(struct nilfs_bmap *bmap, __u64 key,
+					   __u64 ptr)
+{
+	bmap->b_last_allocated_key = key;
+	bmap->b_last_allocated_ptr = ptr;
+}
+
 __u64 nilfs_bmap_data_get_key(const struct nilfs_bmap *,
 			      const struct buffer_head *);
 
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 8c425d8..c81893a 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -916,13 +916,6 @@ static __u64 nilfs_btree_find_target_v(const struct nilfs_bmap *btree,
 	return nilfs_bmap_find_target_in_group(btree);
 }
 
-static void nilfs_btree_set_target_v(struct nilfs_bmap *btree, __u64 key,
-				     __u64 ptr)
-{
-	btree->b_last_allocated_key = key;
-	btree->b_last_allocated_ptr = ptr;
-}
-
 static int nilfs_btree_prepare_insert(struct nilfs_bmap *btree,
 				      struct nilfs_btree_path *path,
 				      int *levelp, __u64 key, __u64 ptr,
@@ -1083,7 +1076,7 @@ static void nilfs_btree_commit_insert(struct nilfs_bmap *btree,
 	set_buffer_nilfs_volatile((struct buffer_head *)((unsigned long)ptr));
 	ptr = path[NILFS_BTREE_LEVEL_DATA].bp_newreq.bpr_ptr;
 	if (NILFS_BMAP_USE_VBN(btree)) {
-		nilfs_btree_set_target_v(btree, key, ptr);
+		nilfs_bmap_set_target_v(btree, key, ptr);
 		dat = nilfs_bmap_get_dat(btree);
 	}
 
@@ -1661,7 +1654,7 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *btree,
 	}
 
 	if (NILFS_BMAP_USE_VBN(btree))
-		nilfs_btree_set_target_v(btree, key, dreq->bpr_ptr);
+		nilfs_bmap_set_target_v(btree, key, dreq->bpr_ptr);
 }
 
 /**
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index cfc7218..3186130 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -116,13 +116,6 @@ nilfs_direct_find_target_v(const struct nilfs_bmap *direct, __u64 key)
 		return nilfs_bmap_find_target_in_group(direct);
 }
 
-static void nilfs_direct_set_target_v(struct nilfs_bmap *direct,
-				      __u64 key, __u64 ptr)
-{
-	direct->b_last_allocated_key = key;
-	direct->b_last_allocated_ptr = ptr;
-}
-
 static int nilfs_direct_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
 {
 	union nilfs_bmap_ptr_req req;
@@ -152,7 +145,7 @@ static int nilfs_direct_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
 			nilfs_bmap_set_dirty(bmap);
 
 		if (NILFS_BMAP_USE_VBN(bmap))
-			nilfs_direct_set_target_v(bmap, key, req.bpr_ptr);
+			nilfs_bmap_set_target_v(bmap, key, req.bpr_ptr);
 
 		nilfs_bmap_add_blocks(bmap, 1);
 	}
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
