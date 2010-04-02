From: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: Combine nilfs_btree_release_path() and
 nilfs_btree_free_path()
Date: Fri, 2 Apr 2010 21:37:41 +0800
Message-ID: <20100402133741.GB10602@xhl>
References: <20100402133605.GA10602@xhl>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:date:from:to:subject
         :message-id:mail-followup-to:references:mime-version:content-type
         :content-disposition:in-reply-to:x-operating-system:user-agent;
        bh=I8/RvisCz+BEHaBi3QtC4144hThQK+7Z8CR6m4N7Dbg=;
        b=kbkxa2WaRXuzEpB6LekkqacNrDyOi4u5zpkDy68NSVsGI4UDITbXTHBL0ApfQtpmM4
         +GZlNOrm0ll5Ci1NquZTObyLojmFmd7CETVnm3aa4EzqZODZ+l19JJv+9zeqbca/Kvrp
         bN7c/zo3bMbd+dnt0zq/CD+cn44p0KI1Xnrgs=
Content-Disposition: inline
In-Reply-To: <20100402133605.GA10602@xhl>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From e55080f9e01f04376296212178bdca1ac0f2a02b Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Fri, 2 Apr 2010 18:35:00 +0800
Subject: [PATCH 2/2] nilfs2: Combine nilfs_btree_release_path() and nilfs_btree_free_path()

nilfs_btree_release_path() and nilfs_btree_free_path() are bound into each other
tightly. Make them into one procedure to clearify the logic and avoid some
misusages.

Signed-off-by: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/btree.c |   22 +++++-----------------
 1 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index bb31ab3..fa4b123 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -93,18 +93,14 @@ out:
 	return path;
 }
 
-static inline void nilfs_btree_free_path(struct nilfs_btree_path *path)
+static void nilfs_btree_free_path(struct nilfs_btree_path *path)
 {
-	kmem_cache_free(nilfs_btree_path_cache, path);
-}
-
-static void nilfs_btree_release_path(struct nilfs_btree_path *path)
-{
-	int level;
+	int level = NILFS_BTREE_LEVEL_DATA;
 
-	for (level = NILFS_BTREE_LEVEL_DATA; level < NILFS_BTREE_LEVEL_MAX;
-	     level++)
+	for (; level < NILFS_BTREE_LEVEL_MAX; level++)
 		brelse(path[level].bp_bh);
+
+	kmem_cache_free(nilfs_btree_path_cache, path);
 }
 
 /*
@@ -573,7 +569,6 @@ static int nilfs_btree_lookup(const struct nilfs_bmap *bmap,
 	if (ptrp != NULL)
 		*ptrp = ptr;
 
-	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 
 	return ret;
@@ -655,7 +650,6 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *bmap,
 	*ptrp = ptr;
 	ret = cnt;
  out:
-	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 	return ret;
 }
@@ -1139,7 +1133,6 @@ static int nilfs_btree_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
 	nilfs_bmap_add_blocks(bmap, stats.bs_nblocks);
 
  out:
-	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 	return ret;
 }
@@ -1472,7 +1465,6 @@ static int nilfs_btree_delete(struct nilfs_bmap *bmap, __u64 key)
 	nilfs_bmap_sub_blocks(bmap, stats.bs_nblocks);
 
 out:
-	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 	return ret;
 }
@@ -1490,7 +1482,6 @@ static int nilfs_btree_last_key(const struct nilfs_bmap *bmap, __u64 *keyp)
 
 	ret = nilfs_btree_do_lookup_last(btree, path, keyp, NULL);
 
-	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 
 	return ret;
@@ -1944,7 +1935,6 @@ static int nilfs_btree_propagate(const struct nilfs_bmap *bmap,
 		nilfs_btree_propagate_p(btree, path, level, bh);
 
  out:
-	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 
 	return ret;
@@ -2126,7 +2116,6 @@ static int nilfs_btree_assign(struct nilfs_bmap *bmap,
 		nilfs_btree_assign_p(btree, path, level, bh, blocknr, binfo);
 
  out:
-	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 
 	return ret;
@@ -2190,7 +2179,6 @@ static int nilfs_btree_mark(struct nilfs_bmap *bmap, __u64 key, int level)
 		nilfs_bmap_set_dirty(&btree->bt_bmap);
 
  out:
-	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 	return ret;
 }
-- 
1.6.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
