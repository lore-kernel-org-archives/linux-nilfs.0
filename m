From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: remove obsolete declarations of cache constructor and destructor
Date: Sun, 23 May 2010 21:27:55 +0900
Message-ID: <1274617675-13663-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1274617675-13663-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1274617675-13663-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

The commit 41c88bd7 ("nilfs2: cleanup multi
kmem_cache_{create,destroy} code") consolidated slab constructors and
destructors used in nilfs, but it left some declarations in header
files.

This gets rid of the obsolete declarations.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btree.h   |    2 --
 fs/nilfs2/segbuf.h  |    2 --
 fs/nilfs2/segment.h |    2 --
 3 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/btree.h b/fs/nilfs2/btree.h
index af638d5..43c8c5b 100644
--- a/fs/nilfs2/btree.h
+++ b/fs/nilfs2/btree.h
@@ -75,8 +75,6 @@ struct nilfs_btree_path {
 
 extern struct kmem_cache *nilfs_btree_path_cache;
 
-int nilfs_btree_path_cache_init(void);
-void nilfs_btree_path_cache_destroy(void);
 int nilfs_btree_init(struct nilfs_bmap *);
 int nilfs_btree_convert_and_insert(struct nilfs_bmap *, __u64, __u64,
 				   const __u64 *, const __u64 *, int);
diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
index fdf1c3b..85fbb66 100644
--- a/fs/nilfs2/segbuf.h
+++ b/fs/nilfs2/segbuf.h
@@ -127,8 +127,6 @@ struct nilfs_segment_buffer {
 
 extern struct kmem_cache *nilfs_segbuf_cachep;
 
-int __init nilfs_init_segbuf_cache(void);
-void nilfs_destroy_segbuf_cache(void);
 struct nilfs_segment_buffer *nilfs_segbuf_new(struct super_block *);
 void nilfs_segbuf_free(struct nilfs_segment_buffer *);
 void nilfs_segbuf_map(struct nilfs_segment_buffer *, __u64, unsigned long,
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index dca1423..01e20db 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -221,8 +221,6 @@ enum {
 extern struct kmem_cache *nilfs_transaction_cachep;
 
 /* segment.c */
-extern int nilfs_init_transaction_cache(void);
-extern void nilfs_destroy_transaction_cache(void);
 extern void nilfs_relax_pressure_in_lock(struct super_block *);
 
 extern int nilfs_construct_segment(struct super_block *);
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
