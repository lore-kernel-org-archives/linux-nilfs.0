From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: call nilfs_error inside bmap routines
Date: Fri, 19 Nov 2010 16:50:30 +0900
Message-ID: <1290153030-20180-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Some functions using nilfs bmap routines can wrongly return invalid
argument error (i.e. -EINVAL) that bmap returns as an internal code
for btree corruption.

This fixes the issue by catching and converting the internal EINVAL to
EIO and calling nilfs_error function inside bmap routines.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/bmap.c    |   45 +++++++++++++++++++++++++++++++++++----------
 fs/nilfs2/ifile.c   |   11 +++--------
 fs/nilfs2/inode.c   |   19 +++++--------------
 fs/nilfs2/mdt.c     |    6 ------
 fs/nilfs2/segment.c |   30 +++++-------------------------
 5 files changed, 48 insertions(+), 63 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index 8b782b0..4b7aeb3 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -38,6 +38,19 @@ struct inode *nilfs_bmap_get_dat(const struct nilfs_bmap *bmap)
 	return nilfs_dat_inode(NILFS_I_NILFS(bmap->b_inode));
 }
 
+static int nilfs_bmap_convert_error(struct nilfs_bmap *bmap,
+				     const char *fname, int err)
+{
+	struct inode *inode = bmap->b_inode;
+
+	if (err == -EINVAL) {
+		nilfs_error(inode->i_sb, fname,
+			    "broken bmap (inode number=%lu)\n", inode->i_ino);
+		err = -EIO;
+	}
+	return err;
+}
+
 /**
  * nilfs_bmap_lookup_at_level - find a data block or node block
  * @bmap: bmap
@@ -66,8 +79,10 @@ int nilfs_bmap_lookup_at_level(struct nilfs_bmap *bmap, __u64 key, int level,
 
 	down_read(&bmap->b_sem);
 	ret = bmap->b_ops->bop_lookup(bmap, key, level, ptrp);
-	if (ret < 0)
+	if (ret < 0) {
+		ret = nilfs_bmap_convert_error(bmap, __func__, ret);
 		goto out;
+	}
 	if (NILFS_BMAP_USE_VBN(bmap)) {
 		ret = nilfs_dat_translate(nilfs_bmap_get_dat(bmap), *ptrp,
 					  &blocknr);
@@ -88,7 +103,8 @@ int nilfs_bmap_lookup_contig(struct nilfs_bmap *bmap, __u64 key, __u64 *ptrp,
 	down_read(&bmap->b_sem);
 	ret = bmap->b_ops->bop_lookup_contig(bmap, key, ptrp, maxblocks);
 	up_read(&bmap->b_sem);
-	return ret;
+
+	return nilfs_bmap_convert_error(bmap, __func__, ret);
 }
 
 static int nilfs_bmap_do_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
@@ -144,7 +160,8 @@ int nilfs_bmap_insert(struct nilfs_bmap *bmap,
 	down_write(&bmap->b_sem);
 	ret = nilfs_bmap_do_insert(bmap, key, rec);
 	up_write(&bmap->b_sem);
-	return ret;
+
+	return nilfs_bmap_convert_error(bmap, __func__, ret);
 }
 
 static int nilfs_bmap_do_delete(struct nilfs_bmap *bmap, __u64 key)
@@ -180,9 +197,12 @@ int nilfs_bmap_last_key(struct nilfs_bmap *bmap, unsigned long *key)
 
 	down_read(&bmap->b_sem);
 	ret = bmap->b_ops->bop_last_key(bmap, &lastkey);
-	if (!ret)
-		*key = lastkey;
 	up_read(&bmap->b_sem);
+
+	if (ret < 0)
+		ret = nilfs_bmap_convert_error(bmap, __func__, ret);
+	else
+		*key = lastkey;
 	return ret;
 }
 
@@ -210,7 +230,8 @@ int nilfs_bmap_delete(struct nilfs_bmap *bmap, unsigned long key)
 	down_write(&bmap->b_sem);
 	ret = nilfs_bmap_do_delete(bmap, key);
 	up_write(&bmap->b_sem);
-	return ret;
+
+	return nilfs_bmap_convert_error(bmap, __func__, ret);
 }
 
 static int nilfs_bmap_do_truncate(struct nilfs_bmap *bmap, unsigned long key)
@@ -261,7 +282,8 @@ int nilfs_bmap_truncate(struct nilfs_bmap *bmap, unsigned long key)
 	down_write(&bmap->b_sem);
 	ret = nilfs_bmap_do_truncate(bmap, key);
 	up_write(&bmap->b_sem);
-	return ret;
+
+	return nilfs_bmap_convert_error(bmap, __func__, ret);
 }
 
 /**
@@ -300,7 +322,8 @@ int nilfs_bmap_propagate(struct nilfs_bmap *bmap, struct buffer_head *bh)
 	down_write(&bmap->b_sem);
 	ret = bmap->b_ops->bop_propagate(bmap, bh);
 	up_write(&bmap->b_sem);
-	return ret;
+
+	return nilfs_bmap_convert_error(bmap, __func__, ret);
 }
 
 /**
@@ -344,7 +367,8 @@ int nilfs_bmap_assign(struct nilfs_bmap *bmap,
 	down_write(&bmap->b_sem);
 	ret = bmap->b_ops->bop_assign(bmap, bh, blocknr, binfo);
 	up_write(&bmap->b_sem);
-	return ret;
+
+	return nilfs_bmap_convert_error(bmap, __func__, ret);
 }
 
 /**
@@ -373,7 +397,8 @@ int nilfs_bmap_mark(struct nilfs_bmap *bmap, __u64 key, int level)
 	down_write(&bmap->b_sem);
 	ret = bmap->b_ops->bop_mark(bmap, key, level);
 	up_write(&bmap->b_sem);
-	return ret;
+
+	return nilfs_bmap_convert_error(bmap, __func__, ret);
 }
 
 /**
diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index 9f8a2da..bfc73d3 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -149,14 +149,9 @@ int nilfs_ifile_get_inode_block(struct inode *ifile, ino_t ino,
 	}
 
 	err = nilfs_palloc_get_entry_block(ifile, ino, 0, out_bh);
-	if (unlikely(err)) {
-		if (err == -EINVAL)
-			nilfs_error(sb, __func__, "ifile is broken");
-		else
-			nilfs_warning(sb, __func__,
-				      "unable to read inode: %lu",
-				      (unsigned long) ino);
-	}
+	if (unlikely(err))
+		nilfs_warning(sb, __func__, "unable to read inode: %lu",
+			      (unsigned long) ino);
 	return err;
 }
 
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 71d4bc8..bddb4f4 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -96,11 +96,6 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
 				       inode->i_ino,
 				       (unsigned long long)blkoff);
 				err = 0;
-			} else if (err == -EINVAL) {
-				nilfs_error(inode->i_sb, __func__,
-					    "broken bmap (inode=%lu)\n",
-					    inode->i_ino);
-				err = -EIO;
 			}
 			nilfs_transaction_abort(inode->i_sb);
 			goto out;
@@ -629,7 +624,7 @@ static void nilfs_truncate_bmap(struct nilfs_inode_info *ii,
 
 	if (!test_bit(NILFS_I_BMAP, &ii->i_state))
 		return;
- repeat:
+repeat:
 	ret = nilfs_bmap_last_key(ii->i_bmap, &b);
 	if (ret == -ENOENT)
 		return;
@@ -646,14 +641,10 @@ static void nilfs_truncate_bmap(struct nilfs_inode_info *ii,
 		     nilfs_bmap_truncate(ii->i_bmap, b) == 0))
 		goto repeat;
 
- failed:
-	if (ret == -EINVAL)
-		nilfs_error(ii->vfs_inode.i_sb, __func__,
-			    "bmap is broken (ino=%lu)", ii->vfs_inode.i_ino);
-	else
-		nilfs_warning(ii->vfs_inode.i_sb, __func__,
-			      "failed to truncate bmap (ino=%lu, err=%d)",
-			      ii->vfs_inode.i_ino, ret);
+failed:
+	nilfs_warning(ii->vfs_inode.i_sb, __func__,
+		      "failed to truncate bmap (ino=%lu, err=%d)",
+		      ii->vfs_inode.i_ino, ret);
 }
 
 void nilfs_truncate(struct inode *inode)
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 39a5b84..f5d4b18 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -237,8 +237,6 @@ static int nilfs_mdt_read_block(struct inode *inode, unsigned long block,
  *
  * %-ENOENT - the specified block does not exist (hole block)
  *
- * %-EINVAL - bmap is broken. (the caller should call nilfs_error())
- *
  * %-EROFS - Read only filesystem (for create mode)
  */
 int nilfs_mdt_get_block(struct inode *inode, unsigned long blkoff, int create,
@@ -273,8 +271,6 @@ int nilfs_mdt_get_block(struct inode *inode, unsigned long blkoff, int create,
  * %-ENOMEM - Insufficient memory available.
  *
  * %-EIO - I/O error
- *
- * %-EINVAL - bmap is broken. (the caller should call nilfs_error())
  */
 int nilfs_mdt_delete_block(struct inode *inode, unsigned long block)
 {
@@ -350,8 +346,6 @@ int nilfs_mdt_forget_block(struct inode *inode, unsigned long block)
  * %-EIO - I/O error
  *
  * %-ENOENT - the specified block does not exist (hole block)
- *
- * %-EINVAL - bmap is broken. (the caller should call nilfs_error())
  */
 int nilfs_mdt_mark_block_dirty(struct inode *inode, unsigned long block)
 {
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 687d090..d3d2f43 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -504,17 +504,6 @@ static int nilfs_segctor_add_file_block(struct nilfs_sc_info *sci,
 	return err;
 }
 
-static int nilfs_handle_bmap_error(int err, const char *fname,
-				   struct inode *inode, struct super_block *sb)
-{
-	if (err == -EINVAL) {
-		nilfs_error(sb, fname, "broken bmap (inode=%lu)\n",
-			    inode->i_ino);
-		err = -EIO;
-	}
-	return err;
-}
-
 /*
  * Callback functions that enumerate, mark, and collect dirty blocks
  */
@@ -524,9 +513,8 @@ static int nilfs_collect_file_data(struct nilfs_sc_info *sci,
 	int err;
 
 	err = nilfs_bmap_propagate(NILFS_I(inode)->i_bmap, bh);
-	if (unlikely(err < 0))
-		return nilfs_handle_bmap_error(err, __func__, inode,
-					       sci->sc_super);
+	if (err < 0)
+		return err;
 
 	err = nilfs_segctor_add_file_block(sci, bh, inode,
 					   sizeof(struct nilfs_binfo_v));
@@ -539,13 +527,7 @@ static int nilfs_collect_file_node(struct nilfs_sc_info *sci,
 				   struct buffer_head *bh,
 				   struct inode *inode)
 {
-	int err;
-
-	err = nilfs_bmap_propagate(NILFS_I(inode)->i_bmap, bh);
-	if (unlikely(err < 0))
-		return nilfs_handle_bmap_error(err, __func__, inode,
-					       sci->sc_super);
-	return 0;
+	return nilfs_bmap_propagate(NILFS_I(inode)->i_bmap, bh);
 }
 
 static int nilfs_collect_file_bmap(struct nilfs_sc_info *sci,
@@ -588,9 +570,8 @@ static int nilfs_collect_dat_data(struct nilfs_sc_info *sci,
 	int err;
 
 	err = nilfs_bmap_propagate(NILFS_I(inode)->i_bmap, bh);
-	if (unlikely(err < 0))
-		return nilfs_handle_bmap_error(err, __func__, inode,
-					       sci->sc_super);
+	if (err < 0)
+		return err;
 
 	err = nilfs_segctor_add_file_block(sci, bh, inode, sizeof(__le64));
 	if (!err)
@@ -1563,7 +1544,6 @@ nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
 	return 0;
 
  failed_bmap:
-	err = nilfs_handle_bmap_error(err, __func__, inode, sci->sc_super);
 	return err;
 }
 
-- 
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
