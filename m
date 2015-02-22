From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/4] nilfs2: add bmap function to seek a valid key
Date: Sun, 22 Feb 2015 21:34:08 +0900
Message-ID: <1424608450-32240-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1424608450-32240-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=nANsr4zBg9T6cYbcM2YPHEVONywad0/JmpHJK0SBSSI=;
        b=vPFEZRVErTMnFUcyPl8LA3WqUwaIk79smCTst4+yL2ihF+fN+MnZNynaFEFNbJdZH9
         jNsT8nbgjr4LHA1tVwNi+ANGC+s5+dSEYI7iUYGxq/8mr1a4PuRAO2HZM98ssZSqq4KF
         j/Lhrl1GjTV0ens0kLqcVP4wkO6Gu7znED3ihsl0ys3fTO9wq4/vZFfwHH9mGc5/3eG8
         VvQb5lIvUAfwimh/N2q2+fELDu7Eq99zXFqnXVbsx2D16NTRUa1rSG436m51ouvvazFF
         7c2a65mpNE7yQ9BGUO9+5frHjnj4yTo5hGbdqwQXWTLyERj9rKUAfH+b5Ktgzk78sU1X
         r6PA==
In-Reply-To: <1424608450-32240-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Add a new bmap function, nilfs_bmap_seek_key(), which seeks a valid
entry and returns its key starting from a given key.  This function
can be used to skip hole blocks efficiently.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.c   | 31 +++++++++++++++++++++++++
 fs/nilfs2/bmap.h   |  5 ++++-
 fs/nilfs2/btree.c  | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/direct.c | 17 ++++++++++++++
 4 files changed, 118 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index c82f436..27f75bc 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -189,6 +189,37 @@ static int nilfs_bmap_do_delete(struct nilfs_bmap *bmap, __u64 key)
 	return bmap->b_ops->bop_delete(bmap, key);
 }
 
+/**
+ * nilfs_bmap_seek_key - seek a valid entry and return its key
+ * @bmap: bmap struct
+ * @start: start key number
+ * @keyp: place to store valid key
+ *
+ * Description: nilfs_bmap_seek_key() seeks a valid key on @bmap
+ * starting from @start, and stores it to @keyp if found.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOENT - No valid entry was found
+ */
+int nilfs_bmap_seek_key(struct nilfs_bmap *bmap, __u64 start, __u64 *keyp)
+{
+	int ret;
+
+	down_read(&bmap->b_sem);
+	ret = bmap->b_ops->bop_seek_key(bmap, start, keyp);
+	up_read(&bmap->b_sem);
+
+	if (ret < 0)
+		ret = nilfs_bmap_convert_error(bmap, __func__, ret);
+	return ret;
+}
+
 int nilfs_bmap_last_key(struct nilfs_bmap *bmap, __u64 *keyp)
 {
 	int ret;
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index 9230d33..bfa817c 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -76,8 +76,10 @@ struct nilfs_bmap_operations {
 			  union nilfs_binfo *);
 	int (*bop_mark)(struct nilfs_bmap *, __u64, int);
 
-	/* The following functions are internal use only. */
+	int (*bop_seek_key)(const struct nilfs_bmap *, __u64, __u64 *);
 	int (*bop_last_key)(const struct nilfs_bmap *, __u64 *);
+
+	/* The following functions are internal use only. */
 	int (*bop_check_insert)(const struct nilfs_bmap *, __u64);
 	int (*bop_check_delete)(struct nilfs_bmap *, __u64);
 	int (*bop_gather_data)(struct nilfs_bmap *, __u64 *, __u64 *, int);
@@ -155,6 +157,7 @@ void nilfs_bmap_write(struct nilfs_bmap *, struct nilfs_inode *);
 int nilfs_bmap_lookup_contig(struct nilfs_bmap *, __u64, __u64 *, unsigned);
 int nilfs_bmap_insert(struct nilfs_bmap *bmap, __u64 key, unsigned long rec);
 int nilfs_bmap_delete(struct nilfs_bmap *bmap, __u64 key);
+int nilfs_bmap_seek_key(struct nilfs_bmap *bmap, __u64 start, __u64 *keyp);
 int nilfs_bmap_last_key(struct nilfs_bmap *bmap, __u64 *keyp);
 int nilfs_bmap_truncate(struct nilfs_bmap *bmap, __u64 key);
 void nilfs_bmap_clear(struct nilfs_bmap *);
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index ecdbae1..841d177 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -633,6 +633,44 @@ static int nilfs_btree_do_lookup_last(const struct nilfs_bmap *btree,
 	return 0;
 }
 
+/**
+ * nilfs_btree_get_next_key - get next valid key from btree path array
+ * @btree: bmap struct of btree
+ * @path: array of nilfs_btree_path struct
+ * @minlevel: start level
+ * @nextkey: place to store the next valid key
+ *
+ * Return Value: If a next key was found, 0 is returned. Otherwise,
+ * -ENOENT is returned.
+ */
+static int nilfs_btree_get_next_key(const struct nilfs_bmap *btree,
+				    const struct nilfs_btree_path *path,
+				    int minlevel, __u64 *nextkey)
+{
+	struct nilfs_btree_node *node;
+	int maxlevel = nilfs_btree_height(btree) - 1;
+	int index, next_adj, level;
+
+	/* Next index is already set to bp_index for leaf nodes. */
+	next_adj = 0;
+	for (level = minlevel; level <= maxlevel; level++) {
+		if (level == maxlevel)
+			node = nilfs_btree_get_root(btree);
+		else
+			node = nilfs_btree_get_nonroot_node(path, level);
+
+		index = path[level].bp_index + next_adj;
+		if (index < nilfs_btree_node_get_nchildren(node)) {
+			/* Next key is in this node */
+			*nextkey = nilfs_btree_node_get_key(node, index);
+			return 0;
+		}
+		/* For non-leaf nodes, next index is stored at bp_index + 1. */
+		next_adj = 1;
+	}
+	return -ENOENT;
+}
+
 static int nilfs_btree_lookup(const struct nilfs_bmap *btree,
 			      __u64 key, int level, __u64 *ptrp)
 {
@@ -1563,6 +1601,30 @@ out:
 	return ret;
 }
 
+static int nilfs_btree_seek_key(const struct nilfs_bmap *btree, __u64 start,
+				__u64 *keyp)
+{
+	struct nilfs_btree_path *path;
+	const int minlevel = NILFS_BTREE_LEVEL_NODE_MIN;
+	int ret;
+
+	if (start > NILFS_BTREE_KEY_MAX)
+		return -ENOENT;
+
+	path = nilfs_btree_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = nilfs_btree_do_lookup(btree, path, start, NULL, minlevel, 0);
+	if (!ret)
+		*keyp = start;
+	else if (ret == -ENOENT)
+		ret = nilfs_btree_get_next_key(btree, path, minlevel, keyp);
+
+	nilfs_btree_free_path(path);
+	return ret;
+}
+
 static int nilfs_btree_last_key(const struct nilfs_bmap *btree, __u64 *keyp)
 {
 	struct nilfs_btree_path *path;
@@ -2298,7 +2360,9 @@ static const struct nilfs_bmap_operations nilfs_btree_ops = {
 	.bop_assign		=	nilfs_btree_assign,
 	.bop_mark		=	nilfs_btree_mark,
 
+	.bop_seek_key		=	nilfs_btree_seek_key,
 	.bop_last_key		=	nilfs_btree_last_key,
+
 	.bop_check_insert	=	NULL,
 	.bop_check_delete	=	nilfs_btree_check_delete,
 	.bop_gather_data	=	nilfs_btree_gather_data,
@@ -2318,7 +2382,9 @@ static const struct nilfs_bmap_operations nilfs_btree_ops_gc = {
 	.bop_assign		=	nilfs_btree_assign_gc,
 	.bop_mark		=	NULL,
 
+	.bop_seek_key		=	NULL,
 	.bop_last_key		=	NULL,
+
 	.bop_check_insert	=	NULL,
 	.bop_check_delete	=	NULL,
 	.bop_gather_data	=	NULL,
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 82f4865..ebf89fd 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -173,6 +173,21 @@ static int nilfs_direct_delete(struct nilfs_bmap *bmap, __u64 key)
 	return ret;
 }
 
+static int nilfs_direct_seek_key(const struct nilfs_bmap *direct, __u64 start,
+				 __u64 *keyp)
+{
+	__u64 key;
+
+	for (key = start; key <= NILFS_DIRECT_KEY_MAX; key++) {
+		if (nilfs_direct_get_ptr(direct, key) !=
+		    NILFS_BMAP_INVALID_PTR) {
+			*keyp = key;
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
 static int nilfs_direct_last_key(const struct nilfs_bmap *direct, __u64 *keyp)
 {
 	__u64 key, lastkey;
@@ -355,7 +370,9 @@ static const struct nilfs_bmap_operations nilfs_direct_ops = {
 	.bop_assign		=	nilfs_direct_assign,
 	.bop_mark		=	NULL,
 
+	.bop_seek_key		=	nilfs_direct_seek_key,
 	.bop_last_key		=	nilfs_direct_last_key,
+
 	.bop_check_insert	=	nilfs_direct_check_insert,
 	.bop_check_delete	=	NULL,
 	.bop_gather_data	=	nilfs_direct_gather_data,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
