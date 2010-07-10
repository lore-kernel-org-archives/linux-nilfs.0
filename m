From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/6] nilfs2: remove constant qualifier from argument of bmap propagate
Date: Sun, 11 Jul 2010 00:01:50 +0900
Message-ID: <1278774114-17917-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

The first argument of bops->bop_propagate operation takes a constant
qualifier, and causes compilation error when removed cast to pointer
of nilfs_btree structure type.  This fixes the issue to prepare for
succesive removal of nilfs_btree struct.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.h   |    2 +-
 fs/nilfs2/btree.c  |    4 ++--
 fs/nilfs2/direct.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index de88ddf..379fda4 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -66,7 +66,7 @@ struct nilfs_bmap_operations {
 	int (*bop_delete)(struct nilfs_bmap *, __u64);
 	void (*bop_clear)(struct nilfs_bmap *);
 
-	int (*bop_propagate)(const struct nilfs_bmap *, struct buffer_head *);
+	int (*bop_propagate)(struct nilfs_bmap *, struct buffer_head *);
 	void (*bop_lookup_dirty_buffers)(struct nilfs_bmap *,
 					 struct list_head *);
 
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 0b72fc7..6dddfe9 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1898,7 +1898,7 @@ static int nilfs_btree_propagate_v(struct nilfs_btree *btree,
 	return ret;
 }
 
-static int nilfs_btree_propagate(const struct nilfs_bmap *bmap,
+static int nilfs_btree_propagate(struct nilfs_bmap *bmap,
 				 struct buffer_head *bh)
 {
 	struct nilfs_btree *btree;
@@ -1941,7 +1941,7 @@ static int nilfs_btree_propagate(const struct nilfs_bmap *bmap,
 	return ret;
 }
 
-static int nilfs_btree_propagate_gc(const struct nilfs_bmap *bmap,
+static int nilfs_btree_propagate_gc(struct nilfs_bmap *bmap,
 				    struct buffer_head *bh)
 {
 	return nilfs_dat_mark_dirty(nilfs_bmap_get_dat(bmap), bh->b_blocknr);
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 32f1746..fd006ee 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -269,7 +269,7 @@ int nilfs_direct_delete_and_convert(struct nilfs_bmap *bmap,
 	return 0;
 }
 
-static int nilfs_direct_propagate(const struct nilfs_bmap *bmap,
+static int nilfs_direct_propagate(struct nilfs_bmap *bmap,
 				  struct buffer_head *bh)
 {
 	struct nilfs_direct *direct = (struct nilfs_direct *)bmap;
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
