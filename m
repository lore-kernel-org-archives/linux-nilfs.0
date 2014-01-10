From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH v2 17/17] nilfs2: implement functionality of
 xafile creation on existed volume
Date: Fri, 10 Jan 2014 16:10:39 +0400
Message-ID: <1389355839.3938.139.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=cJ5fz59sU0JKi/YAJX6HyRnpRRUGLbZ77XErx8FhOv0=;
	b=WvWsaXaB2DGb8jlagn0hssNliV5p0J82KRjRK1Lu7v2P5mhUeEsDQnvxmQdnmBlJHY3uKULgaJSCzlRFReR88NigiCQNNZtJJ+3nvWg1FR97NevT4W3P7bIxaefkHmfa;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][STEP 1][PATCH v2 17/17] nilfs2: implement functionality of xafile creation on existed volume

The patch implements functionality of xafile creation on
NILFS2 volumes that it were created without xafile. Such
volume was used without xattrs presence.

First of all, the nilfs-tune utility should modify
superblock of such volume by means of setting
NILFS_FEATURE_COMPAT_INIT_XAFILE in s_feature_compat
field of superblock. Then, file system driver creates
xafile in the case of presence above-mentioned flag
(NILFS_FEATURE_COMPAT_INIT_XAFILE). Finally, file
system driver sets NILFS_FEATURE_COMPAT_RO_XAFILE
flag in s_feature_compat_ro field and clear
NILFS_FEATURE_COMPAT_INIT_XAFILE flag in
s_feature_compat flag of superblock.

Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/alloc.c         |   46 ++++++++++++++++++++++++
 fs/nilfs2/alloc.h         |    1 +
 fs/nilfs2/the_nilfs.c     |   30 ++++++++++++----
 fs/nilfs2/the_nilfs.h     |    2 ++
 fs/nilfs2/xafile.c        |   86 +++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/xafile.h        |    2 ++
 include/linux/nilfs2_fs.h |    7 +++-
 7 files changed, 166 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 741fd02..17c0673 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -331,6 +331,52 @@ void *nilfs_palloc_block_get_entry(const struct inode *inode, __u64 nr,
 }
 
 /**
+ * nilfs_palloc_create_xafile - create metadata blocks of xafile
+ * @sb: superblock object
+ * @xafile: inode object of xafile
+ */
+int nilfs_palloc_create_xafile(struct super_block *sb, struct inode *xafile)
+{
+	struct buffer_head *desc_bh;
+	struct buffer_head *bmp_bh;
+	struct nilfs_palloc_group_desc *desc;
+	unsigned group_descs_per_block;
+	u8 *bmp;
+	int i;
+	int err;
+
+	err = nilfs_palloc_get_desc_block(xafile, 0, 1, &desc_bh);
+	if (unlikely(err))
+		return err;
+
+	err = nilfs_palloc_get_bitmap_block(xafile, 0, 1, &bmp_bh);
+	if (unlikely(err))
+		goto free_desc_bh;
+
+	group_descs_per_block = nilfs_palloc_groups_per_desc_block(xafile);
+	desc = (struct nilfs_palloc_group_desc *)desc_bh->b_data;
+	memset(desc, 0, desc_bh->b_size);
+	for (i = 0; i < group_descs_per_block; i++)
+		(desc + i)->pg_nfrees = cpu_to_le32(sb->s_blocksize * 8);
+
+	bmp = (u8 *)bmp_bh->b_data;
+	memset(bmp, 0, bmp_bh->b_size);
+	/* Reserve block for invalid xanode number */
+	nilfs_set_bit_atomic(nilfs_mdt_bgl_lock(xafile, 0), 0, bmp);
+	le32_add_cpu(&desc->pg_nfrees, -1);
+
+	mark_buffer_dirty(desc_bh);
+	mark_buffer_dirty(bmp_bh);
+	brelse(desc_bh);
+	brelse(bmp_bh);
+	return 0;
+
+ free_desc_bh:
+	brelse(desc_bh);
+	return err;
+}
+
+/**
  * nilfs_palloc_find_available_slot - find available slot in a group
  * @inode: inode of metadata file using this allocator
  * @group: group number
diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index 4bd6451..229b1aa 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -47,6 +47,7 @@ int nilfs_palloc_get_entry_block(struct inode *, __u64, int,
 				 struct buffer_head **);
 void *nilfs_palloc_block_get_entry(const struct inode *, __u64,
 				   const struct buffer_head *, void *);
+int nilfs_palloc_create_xafile(struct super_block *sb, struct inode *xafile);
 
 int nilfs_palloc_count_max_entries(struct inode *, u64, u64 *);
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index a5fa271..993be9d 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -35,6 +35,7 @@
 #include "dat.h"
 #include "xafile.h"
 #include "segbuf.h"
+#include "acl.h"
 
 
 static int nilfs_valid_sb(struct nilfs_super_block *sbp);
@@ -148,7 +149,14 @@ static int nilfs_load_super_root(struct the_nilfs *nilfs,
 				NILFS_SR_XAFILE_OFFSET(inode_size);
 		err = nilfs_xafile_read(sb, rawi, &nilfs->ns_xafile);
 		if (err)
-			goto failed_xafile;
+			goto failed_sufile;
+	} else if (nilfs_xafile_need_init(nilfs)) {
+		rawi = (void *)bh_sr->b_data +
+				NILFS_SR_XAFILE_OFFSET(inode_size);
+		err = nilfs_xafile_create(sb, rawi, &nilfs->ns_xafile);
+		if (err)
+			goto failed_sufile;
+		set_posix_acl_flag(sb);
 	}
 
 	raw_sr = (struct nilfs_super_root *)bh_sr->b_data;
@@ -158,9 +166,8 @@ static int nilfs_load_super_root(struct the_nilfs *nilfs,
 	brelse(bh_sr);
 	return err;
 
- failed_xafile:
-	if (nilfs_has_xafile(nilfs))
-		iput(nilfs->ns_xafile);
+ failed_sufile:
+	iput(nilfs->ns_sufile);
 
  failed_cpfile:
 	iput(nilfs->ns_cpfile);
@@ -599,9 +606,18 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 	if (err)
 		goto failed_sbh;
 
-	if (le64_to_cpu(sbp->s_feature_compat_ro) &
-	    NILFS_FEATURE_COMPAT_RO_XAFILE)
-		set_nilfs_has_xafile(nilfs);
+	if (le64_to_cpu(sbp->s_feature_compat) &
+	    NILFS_FEATURE_COMPAT_INIT_XAFILE) {
+		if (le64_to_cpu(sbp->s_feature_compat_ro) &
+		    NILFS_FEATURE_COMPAT_RO_XAFILE) {
+			printk(KERN_ERR "NILFS: superblock is corrupted. The xafile exists and cannot be initialized again.\n");
+			err = -EIO;
+			goto failed_sbh;
+		} else
+			set_nilfs_xafile_need_init(nilfs);
+	} else if (le64_to_cpu(sbp->s_feature_compat_ro) &
+		    NILFS_FEATURE_COMPAT_RO_XAFILE)
+			set_nilfs_has_xafile(nilfs);
 
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbp->s_log_block_size);
 	if (blocksize < NILFS_MIN_BLOCK_SIZE ||
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 0e69495..4a638a3 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -41,6 +41,7 @@ enum {
 	THE_NILFS_GC_RUNNING,	/* gc process is running */
 	THE_NILFS_SB_DIRTY,	/* super block is dirty */
 	THE_NILFS_HAS_XAFILE,	/* volume contains xafile */
+	THE_NILFS_XAFILE_NEED_INIT, /* it needs to init xafile */
 };
 
 /**
@@ -212,6 +213,7 @@ THE_NILFS_FNS(DISCONTINUED, discontinued)
 THE_NILFS_FNS(GC_RUNNING, gc_running)
 THE_NILFS_FNS(SB_DIRTY, sb_dirty)
 THE_NILFS_FNS(HAS_XAFILE, has_xafile)
+THE_NILFS_FNS(XAFILE_NEED_INIT, xafile_need_init)
 
 /*
  * Mount option operations
diff --git a/fs/nilfs2/xafile.c b/fs/nilfs2/xafile.c
index 8344590..8dceb60 100644
--- a/fs/nilfs2/xafile.c
+++ b/fs/nilfs2/xafile.c
@@ -481,6 +481,92 @@ int nilfs_xafile_read(struct super_block *sb, struct nilfs_inode *raw_inode,
 }
 
 /*
+ * nilfs_xafile_create - create and initialize xafile
+ * @sb: super block instance
+ * @raw_inode: on-disk raw inode buffer
+ * @inodep: buffer to store the inode [out]
+ */
+int nilfs_xafile_create(struct super_block *sb, struct nilfs_inode *raw_inode,
+			struct inode **inodep)
+{
+	struct the_nilfs *nilfs = sb->s_fs_info;
+	struct nilfs_super_block **sbp = nilfs->ns_sbp;
+	const unsigned group_desc_blocks_per_group = 1;
+	const unsigned bitmap_blocks_per_group = 1;
+	struct inode *xafile;
+	struct timespec cur_time;
+	u64 feature_compat, feature_compat_ro;
+	int err;
+
+	xafile = nilfs_iget_locked(sb, NULL, NILFS_XATTR_INO);
+	if (unlikely(!xafile))
+		return -ENOMEM;
+	BUG_ON(!(xafile->i_state & I_NEW));
+
+	err = nilfs_mdt_init(xafile, NILFS_MDT_GFP,
+			     sizeof(struct nilfs_xafile_info));
+	if (unlikely(err))
+		goto failed;
+
+	/* TODO: [REWORK] it is used 4Kb node size temporary */
+	err = nilfs_palloc_init_blockgroup(xafile, PAGE_CACHE_SIZE);
+	if (unlikely(err))
+		goto failed;
+
+	nilfs_palloc_setup_cache(xafile, &NILFS_XAFILE_I(xafile)->palloc_cache);
+
+	memset(raw_inode, 0, sizeof(*raw_inode));
+
+	raw_inode->i_mode = cpu_to_le16(DT_REG << 12);
+	raw_inode->i_links_count = cpu_to_le16(1);
+	raw_inode->i_blocks = cpu_to_le64(group_desc_blocks_per_group +
+					  bitmap_blocks_per_group);
+	raw_inode->i_size = 0;
+	cur_time = CURRENT_TIME;
+	raw_inode->i_ctime = cpu_to_le64(cur_time.tv_sec);
+	raw_inode->i_mtime = cpu_to_le64(cur_time.tv_sec);
+	raw_inode->i_ctime_nsec = cpu_to_le32(cur_time.tv_nsec);
+	raw_inode->i_mtime_nsec = cpu_to_le32(cur_time.tv_nsec);
+
+	err = nilfs_read_inode_common(xafile, raw_inode);
+	if (unlikely(err))
+		goto failed;
+
+	err = nilfs_palloc_create_xafile(sb, xafile);
+	if (unlikely(err))
+		goto failed;
+
+	nilfs_mdt_mark_dirty(xafile);
+
+	set_nilfs_has_xafile(nilfs);
+	clear_nilfs_xafile_need_init(nilfs);
+
+	feature_compat = le64_to_cpu(sbp[0]->s_feature_compat);
+	sbp[0]->s_feature_compat = cpu_to_le64(feature_compat &
+					~NILFS_FEATURE_COMPAT_INIT_XAFILE);
+	feature_compat = le64_to_cpu(sbp[1]->s_feature_compat);
+	sbp[1]->s_feature_compat = cpu_to_le64(feature_compat &
+					~NILFS_FEATURE_COMPAT_INIT_XAFILE);
+
+	feature_compat_ro = le64_to_cpu(sbp[0]->s_feature_compat_ro);
+	sbp[0]->s_feature_compat_ro = cpu_to_le64(feature_compat_ro |
+						NILFS_FEATURE_COMPAT_RO_XAFILE);
+	feature_compat_ro = le64_to_cpu(sbp[1]->s_feature_compat_ro);
+	sbp[1]->s_feature_compat_ro = cpu_to_le64(feature_compat_ro |
+						NILFS_FEATURE_COMPAT_RO_XAFILE);
+
+	set_nilfs_sb_dirty(nilfs);
+	unlock_new_inode(xafile);
+
+	*inodep = xafile;
+	return 0;
+
+ failed:
+	iget_failed(xafile);
+	return err;
+}
+
+/*
  * calc_name_hash - calculate complex name hash
  * @name_index: name index
  * @name: xattr name
diff --git a/fs/nilfs2/xafile.h b/fs/nilfs2/xafile.h
index 50c4735..09e1345 100644
--- a/fs/nilfs2/xafile.h
+++ b/fs/nilfs2/xafile.h
@@ -449,5 +449,7 @@ int nilfs_xafile_delete_inode(struct inode *inode);
 
 int nilfs_xafile_read(struct super_block *sb, struct nilfs_inode *raw_inode,
 			struct inode **inodep);
+int nilfs_xafile_create(struct super_block *sb, struct nilfs_inode *raw_inode,
+			struct inode **inodep);
 
 #endif /* _NILFS_XAFILE_H */
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 531cf35..f6cd26f 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -221,13 +221,18 @@ struct nilfs_super_block {
  * If there is a bit set in the incompatible feature set that the kernel
  * doesn't know about, it should refuse to mount the filesystem.
  */
+#define NILFS_FEATURE_COMPAT_INIT_XAFILE	0x00000001ULL
+
 #define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT	0x00000001ULL
 #define NILFS_FEATURE_COMPAT_RO_XAFILE		0x00000002ULL
 
-#define NILFS_FEATURE_COMPAT_SUPP	0ULL
+#define NILFS_FEATURE_COMPAT_SUPP \
+	(NILFS_FEATURE_COMPAT_INIT_XAFILE)
+
 #define NILFS_FEATURE_COMPAT_RO_SUPP	\
 	(NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT | \
 	 NILFS_FEATURE_COMPAT_RO_XAFILE)
+
 #define NILFS_FEATURE_INCOMPAT_SUPP	0ULL
 
 /*
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
