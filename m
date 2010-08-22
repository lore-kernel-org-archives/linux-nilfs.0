From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 5/6] nilfs2: separate initializer of metadata file inode
Date: Sun, 22 Aug 2010 19:05:05 +0900
Message-ID: <1282471506-29618-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1282471506-29618-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1282471506-29618-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

This separates a part of initialization code of metadata file inode,
and makes it available from the nilfs iget function that a later patch
will add to.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/gcinode.c |    6 +++++-
 fs/nilfs2/mdt.c     |   44 +++++++++++++++++++++++++++-----------------
 fs/nilfs2/mdt.h     |    4 +++-
 3 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index bed3a78..cd19a37 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -225,10 +225,14 @@ static struct inode *alloc_gcinode(struct the_nilfs *nilfs, ino_t ino,
 	struct inode *inode;
 	struct nilfs_inode_info *ii;
 
-	inode = nilfs_mdt_new_common(nilfs, NULL, ino, GFP_NOFS, 0);
+	inode = nilfs_mdt_new_common(nilfs, NULL, ino);
 	if (!inode)
 		return NULL;
 
+	if (nilfs_mdt_init(inode, nilfs, GFP_NOFS, 0) < 0) {
+		nilfs_destroy_inode(inode);
+		return NULL;
+	}
 	inode->i_op = NULL;
 	inode->i_fop = NULL;
 	inode->i_mapping->a_ops = &def_gcinode_aops;
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index ee943a3..73e5da3 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -439,6 +439,27 @@ static const struct address_space_operations def_mdt_aops = {
 static const struct inode_operations def_mdt_iops;
 static const struct file_operations def_mdt_fops;
 
+
+int nilfs_mdt_init(struct inode *inode, struct the_nilfs *nilfs,
+		   gfp_t gfp_mask, size_t objsz)
+{
+	struct nilfs_mdt_info *mi;
+
+	mi = kzalloc(max(sizeof(*mi), objsz), GFP_NOFS);
+	if (!mi)
+		return -ENOMEM;
+
+	mi->mi_nilfs = nilfs;
+	init_rwsem(&mi->mi_sem);
+	inode->i_private = mi;
+
+	inode->i_mode = S_IFREG;
+	mapping_set_gfp_mask(inode->i_mapping, gfp_mask);
+	inode->i_mapping->backing_dev_info = nilfs->ns_bdi;
+
+	return 0;
+}
+
 /*
  * NILFS2 uses pseudo inodes for meta data files such as DAT, cpfile, sufile,
  * ifile, or gcinodes.  This allows the B-tree code and segment constructor
@@ -454,12 +475,10 @@ static const struct file_operations def_mdt_fops;
  * @nilfs: nilfs object
  * @sb: super block instance the metadata file belongs to
  * @ino: inode number
- * @gfp_mask: gfp mask for data pages
- * @objsz: size of the private object attached to inode->i_private
  */
 struct inode *
 nilfs_mdt_new_common(struct the_nilfs *nilfs, struct super_block *sb,
-		     ino_t ino, gfp_t gfp_mask, size_t objsz)
+		     ino_t ino)
 {
 	struct inode *inode = nilfs_alloc_inode_common(nilfs);
 
@@ -467,15 +486,6 @@ nilfs_mdt_new_common(struct the_nilfs *nilfs, struct super_block *sb,
 		return NULL;
 	else {
 		struct address_space * const mapping = &inode->i_data;
-		struct nilfs_mdt_info *mi;
-
-		mi = kzalloc(max(sizeof(*mi), objsz), GFP_NOFS);
-		if (!mi) {
-			nilfs_destroy_inode(inode);
-			return NULL;
-		}
-		mi->mi_nilfs = nilfs;
-		init_rwsem(&mi->mi_sem);
 
 		inode->i_sb = sb; /* sb may be NULL for some meta data files */
 		inode->i_blkbits = nilfs->ns_blocksize_bits;
@@ -483,8 +493,6 @@ nilfs_mdt_new_common(struct the_nilfs *nilfs, struct super_block *sb,
 		atomic_set(&inode->i_count, 1);
 		inode->i_nlink = 1;
 		inode->i_ino = ino;
-		inode->i_mode = S_IFREG;
-		inode->i_private = mi;
 
 #ifdef INIT_UNUSED_INODE_FIELDS
 		atomic_set(&inode->i_writecount, 0);
@@ -515,9 +523,7 @@ nilfs_mdt_new_common(struct the_nilfs *nilfs, struct super_block *sb,
 
 		mapping->host = NULL;  /* instead of inode */
 		mapping->flags = 0;
-		mapping_set_gfp_mask(mapping, gfp_mask);
 		mapping->assoc_mapping = NULL;
-		mapping->backing_dev_info = nilfs->ns_bdi;
 
 		inode->i_mapping = mapping;
 	}
@@ -530,10 +536,14 @@ struct inode *nilfs_mdt_new(struct the_nilfs *nilfs, struct super_block *sb,
 {
 	struct inode *inode;
 
-	inode = nilfs_mdt_new_common(nilfs, sb, ino, NILFS_MDT_GFP, objsz);
+	inode = nilfs_mdt_new_common(nilfs, sb, ino);
 	if (!inode)
 		return NULL;
 
+	if (nilfs_mdt_init(inode, nilfs, NILFS_MDT_GFP, objsz) < 0) {
+		nilfs_destroy_inode(inode);
+		return NULL;
+	}
 	inode->i_op = &def_mdt_iops;
 	inode->i_fop = &def_mdt_fops;
 	inode->i_mapping->a_ops = &def_mdt_aops;
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index 6c4bbb0..f445602 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -76,10 +76,12 @@ int nilfs_mdt_forget_block(struct inode *, unsigned long);
 int nilfs_mdt_mark_block_dirty(struct inode *, unsigned long);
 int nilfs_mdt_fetch_dirty(struct inode *);
 
+int nilfs_mdt_init(struct inode *inode, struct the_nilfs *nilfs,
+		   gfp_t gfp_mask, size_t objsz);
 struct inode *nilfs_mdt_new(struct the_nilfs *, struct super_block *, ino_t,
 			    size_t);
 struct inode *nilfs_mdt_new_common(struct the_nilfs *, struct super_block *,
-				   ino_t, gfp_t, size_t);
+				   ino_t);
 void nilfs_mdt_destroy(struct inode *);
 void nilfs_mdt_set_entry_size(struct inode *, unsigned, unsigned);
 void nilfs_mdt_set_shadow(struct inode *, struct inode *);
-- 
1.6.6.2

