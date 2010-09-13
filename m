From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 19/23] nilfs2: use iget for all metadata files
Date: Tue, 14 Sep 2010 00:37:20 +0900
Message-ID: <1284392244-27100-20-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1284392244-27100-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This makes use of iget5_locked to allocate or get inode for metadata
files to stop using own inode allocator.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/cpfile.c    |   49 +++++++++++++++++++++------------
 fs/nilfs2/cpfile.h    |    4 +-
 fs/nilfs2/dat.c       |   61 +++++++++++++++++++++++-----------------
 fs/nilfs2/dat.h       |    4 +-
 fs/nilfs2/ifile.c     |   51 ++++++++++++++++++++++++----------
 fs/nilfs2/ifile.h     |    4 ++-
 fs/nilfs2/inode.c     |   13 +++++++--
 fs/nilfs2/mdt.c       |   16 +++++-----
 fs/nilfs2/mdt.h       |    3 +-
 fs/nilfs2/nilfs.h     |    2 +
 fs/nilfs2/sufile.c    |   73 +++++++++++++++++++++++++++---------------------
 fs/nilfs2/sufile.h    |    4 +-
 fs/nilfs2/super.c     |   21 +++++++++-----
 fs/nilfs2/the_nilfs.c |   58 +++++++++++++-------------------------
 14 files changed, 207 insertions(+), 156 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 1873781..03de1da 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -933,27 +933,40 @@ int nilfs_cpfile_get_stat(struct inode *cpfile, struct nilfs_cpstat *cpstat)
 }
 
 /**
- * nilfs_cpfile_read - read cpfile inode
- * @cpfile: cpfile inode
- * @raw_inode: on-disk cpfile inode
- */
-int nilfs_cpfile_read(struct inode *cpfile, struct nilfs_inode *raw_inode)
-{
-	return nilfs_read_inode_common(cpfile, raw_inode);
-}
-
-/**
- * nilfs_cpfile_new - create cpfile
- * @nilfs: nilfs object
+ * nilfs_cpfile_read - read or get cpfile inode
+ * @sb: super block instance
  * @cpsize: size of a checkpoint entry
+ * @raw_inode: on-disk cpfile inode
+ * @inodep: buffer to store the inode
  */
-struct inode *nilfs_cpfile_new(struct the_nilfs *nilfs, size_t cpsize)
+int nilfs_cpfile_read(struct super_block *sb, size_t cpsize,
+		      struct nilfs_inode *raw_inode, struct inode **inodep)
 {
 	struct inode *cpfile;
+	int err;
 
-	cpfile = nilfs_mdt_new(nilfs, NULL, NILFS_CPFILE_INO, 0);
-	if (cpfile)
-		nilfs_mdt_set_entry_size(cpfile, cpsize,
-					 sizeof(struct nilfs_cpfile_header));
-	return cpfile;
+	cpfile = nilfs_iget_locked(sb, NULL, NILFS_CPFILE_INO);
+	if (unlikely(!cpfile))
+		return -ENOMEM;
+	if (!(cpfile->i_state & I_NEW))
+		goto out;
+
+	err = nilfs_mdt_init(cpfile, NILFS_MDT_GFP, 0);
+	if (err)
+		goto failed;
+
+	nilfs_mdt_set_entry_size(cpfile, cpsize,
+				 sizeof(struct nilfs_cpfile_header));
+
+	err = nilfs_read_inode_common(cpfile, raw_inode);
+	if (err)
+		goto failed;
+
+	unlock_new_inode(cpfile);
+ out:
+	*inodep = cpfile;
+	return 0;
+ failed:
+	iget_failed(cpfile);
+	return err;
 }
diff --git a/fs/nilfs2/cpfile.h b/fs/nilfs2/cpfile.h
index bc0809e..a242b9a 100644
--- a/fs/nilfs2/cpfile.h
+++ b/fs/nilfs2/cpfile.h
@@ -40,7 +40,7 @@ int nilfs_cpfile_get_stat(struct inode *, struct nilfs_cpstat *);
 ssize_t nilfs_cpfile_get_cpinfo(struct inode *, __u64 *, int, void *, unsigned,
 				size_t);
 
-int nilfs_cpfile_read(struct inode *cpfile, struct nilfs_inode *raw_inode);
-struct inode *nilfs_cpfile_new(struct the_nilfs *nilfs, size_t cpsize);
+int nilfs_cpfile_read(struct super_block *sb, size_t cpsize,
+		      struct nilfs_inode *raw_inode, struct inode **inodep);
 
 #endif	/* _NILFS_CPFILE_H */
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 7091c4e..ab04a68 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -463,39 +463,48 @@ ssize_t nilfs_dat_get_vinfo(struct inode *dat, void *buf, unsigned visz,
 }
 
 /**
- * nilfs_dat_read - read dat inode
- * @dat: dat inode
- * @raw_inode: on-disk dat inode
- */
-int nilfs_dat_read(struct inode *dat, struct nilfs_inode *raw_inode)
-{
-	return nilfs_read_inode_common(dat, raw_inode);
-}
-
-/**
- * nilfs_dat_new - create dat file
- * @nilfs: nilfs object
+ * nilfs_dat_read - read or get dat inode
+ * @sb: super block instance
  * @entry_size: size of a dat entry
+ * @raw_inode: on-disk dat inode
+ * @inodep: buffer to store the inode
  */
-struct inode *nilfs_dat_new(struct the_nilfs *nilfs, size_t entry_size)
+int nilfs_dat_read(struct super_block *sb, size_t entry_size,
+		   struct nilfs_inode *raw_inode, struct inode **inodep)
 {
 	static struct lock_class_key dat_lock_key;
 	struct inode *dat;
 	struct nilfs_dat_info *di;
 	int err;
 
-	dat = nilfs_mdt_new(nilfs, NULL, NILFS_DAT_INO, sizeof(*di));
-	if (dat) {
-		err = nilfs_palloc_init_blockgroup(dat, entry_size);
-		if (unlikely(err)) {
-			nilfs_mdt_destroy(dat);
-			return NULL;
-		}
+	dat = nilfs_iget_locked(sb, NULL, NILFS_DAT_INO);
+	if (unlikely(!dat))
+		return -ENOMEM;
+	if (!(dat->i_state & I_NEW))
+		goto out;
 
-		di = NILFS_DAT_I(dat);
-		lockdep_set_class(&di->mi.mi_sem, &dat_lock_key);
-		nilfs_palloc_setup_cache(dat, &di->palloc_cache);
-		nilfs_mdt_setup_shadow_map(dat, &di->shadow);
-	}
-	return dat;
+	err = nilfs_mdt_init(dat, NILFS_MDT_GFP, sizeof(*di));
+	if (err)
+		goto failed;
+
+	err = nilfs_palloc_init_blockgroup(dat, entry_size);
+	if (err)
+		goto failed;
+
+	di = NILFS_DAT_I(dat);
+	lockdep_set_class(&di->mi.mi_sem, &dat_lock_key);
+	nilfs_palloc_setup_cache(dat, &di->palloc_cache);
+	nilfs_mdt_setup_shadow_map(dat, &di->shadow);
+
+	err = nilfs_read_inode_common(dat, raw_inode);
+	if (err)
+		goto failed;
+
+	unlock_new_inode(dat);
+ out:
+	*inodep = dat;
+	return 0;
+ failed:
+	iget_failed(dat);
+	return err;
 }
diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
index d31c3aa..cbd8e97 100644
--- a/fs/nilfs2/dat.h
+++ b/fs/nilfs2/dat.h
@@ -53,7 +53,7 @@ int nilfs_dat_freev(struct inode *, __u64 *, size_t);
 int nilfs_dat_move(struct inode *, __u64, sector_t);
 ssize_t nilfs_dat_get_vinfo(struct inode *, void *, unsigned, size_t);
 
-int nilfs_dat_read(struct inode *dat, struct nilfs_inode *raw_inode);
-struct inode *nilfs_dat_new(struct the_nilfs *nilfs, size_t entry_size);
+int nilfs_dat_read(struct super_block *sb, size_t entry_size,
+		   struct nilfs_inode *raw_inode, struct inode **inodep);
 
 #endif	/* _NILFS_DAT_H */
diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index 922d9dd..9f8a2da 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -161,25 +161,46 @@ int nilfs_ifile_get_inode_block(struct inode *ifile, ino_t ino,
 }
 
 /**
- * nilfs_ifile_new - create inode file
- * @sbi: nilfs_sb_info struct
+ * nilfs_ifile_read - read or get ifile inode
+ * @sb: super block instance
+ * @root: root object
  * @inode_size: size of an inode
+ * @raw_inode: on-disk ifile inode
+ * @inodep: buffer to store the inode
  */
-struct inode *nilfs_ifile_new(struct nilfs_sb_info *sbi, size_t inode_size)
+int nilfs_ifile_read(struct super_block *sb, struct nilfs_root *root,
+		     size_t inode_size, struct nilfs_inode *raw_inode,
+		     struct inode **inodep)
 {
 	struct inode *ifile;
 	int err;
 
-	ifile = nilfs_mdt_new(sbi->s_nilfs, sbi->s_super, NILFS_IFILE_INO,
-			      sizeof(struct nilfs_ifile_info));
-	if (ifile) {
-		err = nilfs_palloc_init_blockgroup(ifile, inode_size);
-		if (unlikely(err)) {
-			nilfs_mdt_destroy(ifile);
-			return NULL;
-		}
-		nilfs_palloc_setup_cache(ifile,
-					 &NILFS_IFILE_I(ifile)->palloc_cache);
-	}
-	return ifile;
+	ifile = nilfs_iget_locked(sb, root, NILFS_IFILE_INO);
+	if (unlikely(!ifile))
+		return -ENOMEM;
+	if (!(ifile->i_state & I_NEW))
+		goto out;
+
+	err = nilfs_mdt_init(ifile, NILFS_MDT_GFP,
+			     sizeof(struct nilfs_ifile_info));
+	if (err)
+		goto failed;
+
+	err = nilfs_palloc_init_blockgroup(ifile, inode_size);
+	if (err)
+		goto failed;
+
+	nilfs_palloc_setup_cache(ifile, &NILFS_IFILE_I(ifile)->palloc_cache);
+
+	err = nilfs_read_inode_common(ifile, raw_inode);
+	if (err)
+		goto failed;
+
+	unlock_new_inode(ifile);
+ out:
+	*inodep = ifile;
+	return 0;
+ failed:
+	iget_failed(ifile);
+	return err;
 }
diff --git a/fs/nilfs2/ifile.h b/fs/nilfs2/ifile.h
index cbca32e..59b6f2b 100644
--- a/fs/nilfs2/ifile.h
+++ b/fs/nilfs2/ifile.h
@@ -49,6 +49,8 @@ int nilfs_ifile_create_inode(struct inode *, ino_t *, struct buffer_head **);
 int nilfs_ifile_delete_inode(struct inode *, ino_t);
 int nilfs_ifile_get_inode_block(struct inode *, ino_t, struct buffer_head **);
 
-struct inode *nilfs_ifile_new(struct nilfs_sb_info *sbi, size_t inode_size);
+int nilfs_ifile_read(struct super_block *sb, struct nilfs_root *root,
+		     size_t inode_size, struct nilfs_inode *raw_inode,
+		     struct inode **inodep);
 
 #endif	/* _NILFS_IFILE_H */
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 5485dd1..5b3d43f 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -506,16 +506,23 @@ static int nilfs_iget_set(struct inode *inode, void *opaque)
 	return 0;
 }
 
-struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root *root,
-			 unsigned long ino)
+struct inode *nilfs_iget_locked(struct super_block *sb, struct nilfs_root *root,
+				unsigned long ino)
 {
 	struct nilfs_iget_args args = {
 		.ino = ino, .root = root, .cno = 0, .for_gc = 0
 	};
+
+	return iget5_locked(sb, ino, nilfs_iget_test, nilfs_iget_set, &args);
+}
+
+struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root *root,
+			 unsigned long ino)
+{
 	struct inode *inode;
 	int err;
 
-	inode = iget5_locked(sb, ino, nilfs_iget_test, nilfs_iget_set, &args);
+	inode = nilfs_iget_locked(sb, root, ino);
 	if (unlikely(!inode))
 		return ERR_PTR(-ENOMEM);
 	if (!(inode->i_state & I_NEW))
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 3bbd340..44326cf 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -444,8 +444,7 @@ static const struct inode_operations def_mdt_iops;
 static const struct file_operations def_mdt_fops;
 
 
-int nilfs_mdt_init(struct inode *inode, struct the_nilfs *nilfs,
-		   gfp_t gfp_mask, size_t objsz)
+int nilfs_mdt_init(struct inode *inode, gfp_t gfp_mask, size_t objsz)
 {
 	struct nilfs_mdt_info *mi;
 
@@ -453,13 +452,17 @@ int nilfs_mdt_init(struct inode *inode, struct the_nilfs *nilfs,
 	if (!mi)
 		return -ENOMEM;
 
-	mi->mi_nilfs = nilfs;
+	mi->mi_nilfs = NILFS_I_NILFS(inode);
 	init_rwsem(&mi->mi_sem);
 	inode->i_private = mi;
 
 	inode->i_mode = S_IFREG;
 	mapping_set_gfp_mask(inode->i_mapping, gfp_mask);
-	inode->i_mapping->backing_dev_info = nilfs->ns_bdi;
+	inode->i_mapping->backing_dev_info = inode->i_sb->s_bdi;
+
+	inode->i_op = &def_mdt_iops;
+	inode->i_fop = &def_mdt_fops;
+	inode->i_mapping->a_ops = &def_mdt_aops;
 
 	return 0;
 }
@@ -544,13 +547,10 @@ struct inode *nilfs_mdt_new(struct the_nilfs *nilfs, struct super_block *sb,
 	if (!inode)
 		return NULL;
 
-	if (nilfs_mdt_init(inode, nilfs, NILFS_MDT_GFP, objsz) < 0) {
+	if (nilfs_mdt_init(inode, NILFS_MDT_GFP, objsz) < 0) {
 		nilfs_destroy_inode(inode);
 		return NULL;
 	}
-	inode->i_op = &def_mdt_iops;
-	inode->i_fop = &def_mdt_fops;
-	inode->i_mapping->a_ops = &def_mdt_aops;
 	return inode;
 }
 
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index 1e0901c..73ff7c0 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -85,8 +85,7 @@ int nilfs_mdt_forget_block(struct inode *, unsigned long);
 int nilfs_mdt_mark_block_dirty(struct inode *, unsigned long);
 int nilfs_mdt_fetch_dirty(struct inode *);
 
-int nilfs_mdt_init(struct inode *inode, struct the_nilfs *nilfs,
-		   gfp_t gfp_mask, size_t objsz);
+int nilfs_mdt_init(struct inode *inode, gfp_t gfp_mask, size_t objsz);
 struct inode *nilfs_mdt_new(struct the_nilfs *, struct super_block *, ino_t,
 			    size_t);
 struct inode *nilfs_mdt_new_common(struct the_nilfs *, struct super_block *,
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index e9f4579..2ca2ca5 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -244,6 +244,8 @@ extern int nilfs_get_block(struct inode *, sector_t, struct buffer_head *, int);
 extern void nilfs_set_inode_flags(struct inode *);
 extern int nilfs_read_inode_common(struct inode *, struct nilfs_inode *);
 extern void nilfs_write_inode_common(struct inode *, struct nilfs_inode *, int);
+struct inode *nilfs_iget_locked(struct super_block *sb, struct nilfs_root *root,
+				unsigned long ino);
 struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root *root,
 			 unsigned long ino);
 extern struct inode *nilfs_iget_for_gc(struct super_block *sb,
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 3c6cc60..599d9c2 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -635,46 +635,55 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
 }
 
 /**
- * nilfs_sufile_read - read sufile inode
- * @sufile: sufile inode
+ * nilfs_sufile_read - read or get sufile inode
+ * @sb: super block instance
+ * @susize: size of a segment usage entry
  * @raw_inode: on-disk sufile inode
+ * @inodep: buffer to store the inode
  */
-int nilfs_sufile_read(struct inode *sufile, struct nilfs_inode *raw_inode)
+int nilfs_sufile_read(struct super_block *sb, size_t susize,
+		      struct nilfs_inode *raw_inode, struct inode **inodep)
 {
-	struct nilfs_sufile_info *sui = NILFS_SUI(sufile);
+	struct inode *sufile;
+	struct nilfs_sufile_info *sui;
 	struct buffer_head *header_bh;
 	struct nilfs_sufile_header *header;
 	void *kaddr;
-	int ret;
+	int err;
 
-	ret = nilfs_read_inode_common(sufile, raw_inode);
-	if (ret < 0)
-		return ret;
+	sufile = nilfs_iget_locked(sb, NULL, NILFS_SUFILE_INO);
+	if (unlikely(!sufile))
+		return -ENOMEM;
+	if (!(sufile->i_state & I_NEW))
+		goto out;
 
-	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
-	if (!ret) {
-		kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
-		header = kaddr + bh_offset(header_bh);
-		sui->ncleansegs = le64_to_cpu(header->sh_ncleansegs);
-		kunmap_atomic(kaddr, KM_USER0);
-		brelse(header_bh);
-	}
-	return ret;
-}
+	err = nilfs_mdt_init(sufile, NILFS_MDT_GFP, sizeof(*sui));
+	if (err)
+		goto failed;
 
-/**
- * nilfs_sufile_new - create sufile
- * @nilfs: nilfs object
- * @susize: size of a segment usage entry
- */
-struct inode *nilfs_sufile_new(struct the_nilfs *nilfs, size_t susize)
-{
-	struct inode *sufile;
+	nilfs_mdt_set_entry_size(sufile, susize,
+				 sizeof(struct nilfs_sufile_header));
+
+	err = nilfs_read_inode_common(sufile, raw_inode);
+	if (err)
+		goto failed;
+
+	err = nilfs_sufile_get_header_block(sufile, &header_bh);
+	if (err)
+		goto failed;
 
-	sufile = nilfs_mdt_new(nilfs, NULL, NILFS_SUFILE_INO,
-			       sizeof(struct nilfs_sufile_info));
-	if (sufile)
-		nilfs_mdt_set_entry_size(sufile, susize,
-					 sizeof(struct nilfs_sufile_header));
-	return sufile;
+	sui = NILFS_SUI(sufile);
+	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	header = kaddr + bh_offset(header_bh);
+	sui->ncleansegs = le64_to_cpu(header->sh_ncleansegs);
+	kunmap_atomic(kaddr, KM_USER0);
+	brelse(header_bh);
+
+	unlock_new_inode(sufile);
+ out:
+	*inodep = sufile;
+	return 0;
+ failed:
+	iget_failed(sufile);
+	return err;
 }
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index 15163b8..203f610 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -61,8 +61,8 @@ void nilfs_sufile_do_cancel_free(struct inode *, __u64, struct buffer_head *,
 void nilfs_sufile_do_set_error(struct inode *, __u64, struct buffer_head *,
 			       struct buffer_head *);
 
-int nilfs_sufile_read(struct inode *sufile, struct nilfs_inode *raw_inode);
-struct inode *nilfs_sufile_new(struct the_nilfs *nilfs, size_t susize);
+int nilfs_sufile_read(struct super_block *sb, size_t susize,
+		      struct nilfs_inode *raw_inode, struct inode **inodep);
 
 /**
  * nilfs_sufile_scrap - make a segment garbage
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 411ee2e..361400b 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -359,6 +359,10 @@ static void nilfs_put_super(struct super_block *sb)
 		up_write(&nilfs->ns_sem);
 	}
 
+	iput(nilfs->ns_sufile);
+	iput(nilfs->ns_cpfile);
+	iput(nilfs->ns_dat);
+
 	destroy_nilfs(nilfs);
 	sbi->s_super = NULL;
 	sb->s_fs_info = NULL;
@@ -408,10 +412,6 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno, int curr_mnt,
 	if (root->ifile)
 		goto reuse; /* already attached checkpoint */
 
-	root->ifile = nilfs_ifile_new(sbi, nilfs->ns_inode_size);
-	if (!root->ifile)
-		goto failed;
-
 	down_read(&nilfs->ns_segctor_sem);
 	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, cno, 0, &raw_cp,
 					  &bh_cp);
@@ -426,8 +426,10 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno, int curr_mnt,
 		}
 		goto failed;
 	}
-	err = nilfs_read_inode_common(root->ifile, &raw_cp->cp_ifile_inode);
-	if (unlikely(err))
+
+	err = nilfs_ifile_read(sbi->s_super, root, nilfs->ns_inode_size,
+			       &raw_cp->cp_ifile_inode, &root->ifile);
+	if (err)
 		goto failed_bh;
 
 	atomic_set(&root->inodes_count, le64_to_cpu(raw_cp->cp_inodes_count));
@@ -900,7 +902,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (err) {
 		printk(KERN_ERR "NILFS: error loading last checkpoint "
 		       "(checkpoint number=%llu).\n", (unsigned long long)cno);
-		goto failed_nilfs;
+		goto failed_unload;
 	}
 
 	if (!(sb->s_flags & MS_RDONLY)) {
@@ -929,6 +931,11 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
  failed_checkpoint:
 	nilfs_put_root(fsroot);
 
+ failed_unload:
+	iput(nilfs->ns_sufile);
+	iput(nilfs->ns_cpfile);
+	iput(nilfs->ns_dat);
+
  failed_nilfs:
 	destroy_nilfs(nilfs);
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 10e3ef0..768e162 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -92,11 +92,6 @@ struct the_nilfs *alloc_nilfs(struct block_device *bdev)
 void destroy_nilfs(struct the_nilfs *nilfs)
 {
 	might_sleep();
-	if (nilfs_loaded(nilfs)) {
-		nilfs_mdt_destroy(nilfs->ns_sufile);
-		nilfs_mdt_destroy(nilfs->ns_cpfile);
-		nilfs_mdt_destroy(nilfs->ns_dat);
-	}
 	if (nilfs_init(nilfs)) {
 		brelse(nilfs->ns_sbh[0]);
 		brelse(nilfs->ns_sbh[1]);
@@ -104,11 +99,13 @@ void destroy_nilfs(struct the_nilfs *nilfs)
 	kfree(nilfs);
 }
 
-static int nilfs_load_super_root(struct the_nilfs *nilfs, sector_t sr_block)
+static int nilfs_load_super_root(struct the_nilfs *nilfs,
+				 struct super_block *sb, sector_t sr_block)
 {
 	struct buffer_head *bh_sr;
 	struct nilfs_super_root *raw_sr;
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
+	struct nilfs_inode *rawi;
 	unsigned dat_entry_size, segment_usage_size, checkpoint_size;
 	unsigned inode_size;
 	int err;
@@ -125,34 +122,22 @@ static int nilfs_load_super_root(struct the_nilfs *nilfs, sector_t sr_block)
 
 	inode_size = nilfs->ns_inode_size;
 
-	err = -ENOMEM;
-	nilfs->ns_dat = nilfs_dat_new(nilfs, dat_entry_size);
-	if (unlikely(!nilfs->ns_dat))
+	rawi = (void *)bh_sr->b_data + NILFS_SR_DAT_OFFSET(inode_size);
+	err = nilfs_dat_read(sb, dat_entry_size, rawi, &nilfs->ns_dat);
+	if (err)
 		goto failed;
 
-	nilfs->ns_cpfile = nilfs_cpfile_new(nilfs, checkpoint_size);
-	if (unlikely(!nilfs->ns_cpfile))
+	rawi = (void *)bh_sr->b_data + NILFS_SR_CPFILE_OFFSET(inode_size);
+	err = nilfs_cpfile_read(sb, checkpoint_size, rawi, &nilfs->ns_cpfile);
+	if (err)
 		goto failed_dat;
 
-	nilfs->ns_sufile = nilfs_sufile_new(nilfs, segment_usage_size);
-	if (unlikely(!nilfs->ns_sufile))
+	rawi = (void *)bh_sr->b_data + NILFS_SR_SUFILE_OFFSET(inode_size);
+	err = nilfs_sufile_read(sb, segment_usage_size, rawi,
+				&nilfs->ns_sufile);
+	if (err)
 		goto failed_cpfile;
 
-	err = nilfs_dat_read(nilfs->ns_dat, (void *)bh_sr->b_data +
-			     NILFS_SR_DAT_OFFSET(inode_size));
-	if (unlikely(err))
-		goto failed_sufile;
-
-	err = nilfs_cpfile_read(nilfs->ns_cpfile, (void *)bh_sr->b_data +
-				NILFS_SR_CPFILE_OFFSET(inode_size));
-	if (unlikely(err))
-		goto failed_sufile;
-
-	err = nilfs_sufile_read(nilfs->ns_sufile, (void *)bh_sr->b_data +
-				NILFS_SR_SUFILE_OFFSET(inode_size));
-	if (unlikely(err))
-		goto failed_sufile;
-
 	raw_sr = (struct nilfs_super_root *)bh_sr->b_data;
 	nilfs->ns_nongc_ctime = le64_to_cpu(raw_sr->sr_nongc_ctime);
 
@@ -160,14 +145,11 @@ static int nilfs_load_super_root(struct the_nilfs *nilfs, sector_t sr_block)
 	brelse(bh_sr);
 	return err;
 
- failed_sufile:
-	nilfs_mdt_destroy(nilfs->ns_sufile);
-
  failed_cpfile:
-	nilfs_mdt_destroy(nilfs->ns_cpfile);
+	iput(nilfs->ns_cpfile);
 
  failed_dat:
-	nilfs_mdt_destroy(nilfs->ns_dat);
+	iput(nilfs->ns_dat);
 	goto failed;
 }
 
@@ -290,7 +272,7 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 			goto scan_error;
 	}
 
-	err = nilfs_load_super_root(nilfs, ri.ri_super_root);
+	err = nilfs_load_super_root(nilfs, sbi->s_super, ri.ri_super_root);
 	if (unlikely(err)) {
 		printk(KERN_ERR "NILFS: error loading super root.\n");
 		goto failed;
@@ -358,9 +340,9 @@ int load_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi)
 	goto failed;
 
  failed_unload:
-	nilfs_mdt_destroy(nilfs->ns_cpfile);
-	nilfs_mdt_destroy(nilfs->ns_sufile);
-	nilfs_mdt_destroy(nilfs->ns_dat);
+	iput(nilfs->ns_cpfile);
+	iput(nilfs->ns_sufile);
+	iput(nilfs->ns_dat);
 
  failed:
 	nilfs_clear_recovery_info(&ri);
@@ -782,7 +764,7 @@ void nilfs_put_root(struct nilfs_root *root)
 		rb_erase(&root->rb_node, &nilfs->ns_cptree);
 		spin_unlock(&nilfs->ns_cptree_lock);
 		if (root->ifile)
-			nilfs_mdt_destroy(root->ifile);
+			iput(root->ifile);
 
 		kfree(root);
 	}
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
