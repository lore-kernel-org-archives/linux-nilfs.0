From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/7] nilfs2: unify type of key arguments in bmap interface
Date: Thu, 12 Mar 2015 23:38:11 +0900
Message-ID: <1426171094-27414-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1426171094-27414-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=dXQL+RJec3mzmIlWJm5+XjAYj9cphPCphGGhIiUYfyg=;
        b=hX1Ti4bdRhXhSAKCABHXXAyNUPBJ2n4ei7UWuPiVALsB2rfSH5KolCfDsXjo80jwPE
         ZlLgrb5EfR+OJQniwILAC9+23pCG+n8N51kB5p1oceoKdUQCfBj9O6bNvNOU+YHddMS4
         bz2sNXyPfScVzSuRyPryU3c3iXtCl5ynozAoapVGCHKyYFv5mk+SY4XXA5H5f+4vL3+8
         jUs1dsNvD+6AD4DJgPQCYNEeHBX80QUqkSgBPFuXvzX1OguksPQDcST+bPWlvGTUxBn9
         +UX1Ot6bF/2ePOWLr4k41PDZwA6tPWOmpeqWUXWtp8ReVlZRdLbY0ACFuuaOuf5Elyy1
         PMwA==
In-Reply-To: <1426171094-27414-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

The type of key arguments in block mapping interface varies depending
on function.  For instance, nilfs_bmap_lookup_at_level() takes "__u64"
for its key argument whereas nilfs_bmap_lookup() takes "unsigned
long".

This fits them to "__u64" to eliminate the variation.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/alloc.c |  5 +++--
 fs/nilfs2/bmap.c  | 17 ++++++-----------
 fs/nilfs2/bmap.h  |  8 ++++----
 fs/nilfs2/inode.c |  6 +++---
 4 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 741fd02..8df0f3b 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -405,13 +405,14 @@ nilfs_palloc_rest_groups_in_desc_block(const struct inode *inode,
 static int nilfs_palloc_count_desc_blocks(struct inode *inode,
 					    unsigned long *desc_blocks)
 {
-	unsigned long blknum;
+	__u64 blknum;
 	int ret;
 
 	ret = nilfs_bmap_last_key(NILFS_I(inode)->i_bmap, &blknum);
 	if (likely(!ret))
 		*desc_blocks = DIV_ROUND_UP(
-			blknum, NILFS_MDT(inode)->mi_blocks_per_desc_block);
+			(unsigned long)blknum,
+			NILFS_MDT(inode)->mi_blocks_per_desc_block);
 	return ret;
 }
 
diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index aadbd0b..c82f436 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -152,9 +152,7 @@ static int nilfs_bmap_do_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
  *
  * %-EEXIST - A record associated with @key already exist.
  */
-int nilfs_bmap_insert(struct nilfs_bmap *bmap,
-		      unsigned long key,
-		      unsigned long rec)
+int nilfs_bmap_insert(struct nilfs_bmap *bmap, __u64 key, unsigned long rec)
 {
 	int ret;
 
@@ -191,19 +189,16 @@ static int nilfs_bmap_do_delete(struct nilfs_bmap *bmap, __u64 key)
 	return bmap->b_ops->bop_delete(bmap, key);
 }
 
-int nilfs_bmap_last_key(struct nilfs_bmap *bmap, unsigned long *key)
+int nilfs_bmap_last_key(struct nilfs_bmap *bmap, __u64 *keyp)
 {
-	__u64 lastkey;
 	int ret;
 
 	down_read(&bmap->b_sem);
-	ret = bmap->b_ops->bop_last_key(bmap, &lastkey);
+	ret = bmap->b_ops->bop_last_key(bmap, keyp);
 	up_read(&bmap->b_sem);
 
 	if (ret < 0)
 		ret = nilfs_bmap_convert_error(bmap, __func__, ret);
-	else
-		*key = lastkey;
 	return ret;
 }
 
@@ -224,7 +219,7 @@ int nilfs_bmap_last_key(struct nilfs_bmap *bmap, unsigned long *key)
  *
  * %-ENOENT - A record associated with @key does not exist.
  */
-int nilfs_bmap_delete(struct nilfs_bmap *bmap, unsigned long key)
+int nilfs_bmap_delete(struct nilfs_bmap *bmap, __u64 key)
 {
 	int ret;
 
@@ -235,7 +230,7 @@ int nilfs_bmap_delete(struct nilfs_bmap *bmap, unsigned long key)
 	return nilfs_bmap_convert_error(bmap, __func__, ret);
 }
 
-static int nilfs_bmap_do_truncate(struct nilfs_bmap *bmap, unsigned long key)
+static int nilfs_bmap_do_truncate(struct nilfs_bmap *bmap, __u64 key)
 {
 	__u64 lastkey;
 	int ret;
@@ -276,7 +271,7 @@ static int nilfs_bmap_do_truncate(struct nilfs_bmap *bmap, unsigned long key)
  *
  * %-ENOMEM - Insufficient amount of memory available.
  */
-int nilfs_bmap_truncate(struct nilfs_bmap *bmap, unsigned long key)
+int nilfs_bmap_truncate(struct nilfs_bmap *bmap, __u64 key)
 {
 	int ret;
 
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index b89e680..9230d33 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -153,10 +153,10 @@ int nilfs_bmap_test_and_clear_dirty(struct nilfs_bmap *);
 int nilfs_bmap_read(struct nilfs_bmap *, struct nilfs_inode *);
 void nilfs_bmap_write(struct nilfs_bmap *, struct nilfs_inode *);
 int nilfs_bmap_lookup_contig(struct nilfs_bmap *, __u64, __u64 *, unsigned);
-int nilfs_bmap_insert(struct nilfs_bmap *, unsigned long, unsigned long);
-int nilfs_bmap_delete(struct nilfs_bmap *, unsigned long);
-int nilfs_bmap_last_key(struct nilfs_bmap *, unsigned long *);
-int nilfs_bmap_truncate(struct nilfs_bmap *, unsigned long);
+int nilfs_bmap_insert(struct nilfs_bmap *bmap, __u64 key, unsigned long rec);
+int nilfs_bmap_delete(struct nilfs_bmap *bmap, __u64 key);
+int nilfs_bmap_last_key(struct nilfs_bmap *bmap, __u64 *keyp);
+int nilfs_bmap_truncate(struct nilfs_bmap *bmap, __u64 key);
 void nilfs_bmap_clear(struct nilfs_bmap *);
 int nilfs_bmap_propagate(struct nilfs_bmap *, struct buffer_head *);
 void nilfs_bmap_lookup_dirty_buffers(struct nilfs_bmap *, struct list_head *);
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 8b59695..cf9e489 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -106,7 +106,7 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
 		err = nilfs_transaction_begin(inode->i_sb, &ti, 1);
 		if (unlikely(err))
 			goto out;
-		err = nilfs_bmap_insert(ii->i_bmap, (unsigned long)blkoff,
+		err = nilfs_bmap_insert(ii->i_bmap, blkoff,
 					(unsigned long)bh_result);
 		if (unlikely(err != 0)) {
 			if (err == -EEXIST) {
@@ -714,7 +714,7 @@ void nilfs_update_inode(struct inode *inode, struct buffer_head *ibh, int flags)
 static void nilfs_truncate_bmap(struct nilfs_inode_info *ii,
 				unsigned long from)
 {
-	unsigned long b;
+	__u64 b;
 	int ret;
 
 	if (!test_bit(NILFS_I_BMAP, &ii->i_state))
@@ -729,7 +729,7 @@ repeat:
 	if (b < from)
 		return;
 
-	b -= min_t(unsigned long, NILFS_MAX_TRUNCATE_BLOCKS, b - from);
+	b -= min_t(__u64, NILFS_MAX_TRUNCATE_BLOCKS, b - from);
 	ret = nilfs_bmap_truncate(ii->i_bmap, b);
 	nilfs_relax_pressure_in_lock(ii->vfs_inode.i_sb);
 	if (!ret || (ret == -ENOMEM &&
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
