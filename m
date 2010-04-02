From: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: Combine nilfs_btree_release_path() and
 nilfs_btree_free_path()
Date: Fri, 2 Apr 2010 18:48:37 +0800
Message-ID: <20100402104837.GD9652@xhl>
References: <20100402104206.GB9652@xhl>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:date:from:to:subject
         :message-id:mail-followup-to:references:mime-version:content-type
         :content-disposition:in-reply-to:x-operating-system:user-agent;
        bh=PkjyiXP8nm4IOXWVhRHTEEWm+mJ/TIN7osSO+dtAu58=;
        b=SKxOZdYTuCculBw1eN9OmmdiGSMQ0ZhLjG/oOxLMnwYLbArI2Vza2GSwPCbT9K+YTP
         82E1jmd86XUUK0UiRbD+Q4ZXd+6Gwpaj8ueElO1m3lEmz5POnOOmld3WJArZ//xzGNrP
         lxQIiBH1cgC+o6QrzqXzNTfCw9DxJFsnXf+YY=
Content-Disposition: inline
In-Reply-To: <20100402104206.GB9652@xhl>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Sorry, a same patch sent out a short time ago but replied to a wrong thread.
-------------------- cut here ----------------------

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
