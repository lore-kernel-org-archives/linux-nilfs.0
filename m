From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 6/9] nilfs2: store parent inode number in disk inode
Date: Mon, 16 May 2011 18:05:19 +0900
Message-ID: <1305536722-1311-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1305536722-1311-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305536722-1311-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This uses the ->i_pad field of disk inodes to store the inode number
of their parent directory, and maintains the parent inode number for
namespace operations such as creation, rename, or unlink.

Although regular files may have two or more parent directories because
of hard link, this only maintains one parent inode and igore the hard
links.

Also, the size of parent inode numbers stored in the new field is
limited to 32-bit width even though inode number may become a 64-bit
value.

So, at this moment, this is only applicable for experimental purposes.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c         |    8 +++++---
 fs/nilfs2/namei.c         |    5 +++++
 fs/nilfs2/nilfs.h         |    1 +
 include/linux/nilfs2_fs.h |    8 +++++---
 4 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 8e19c0b..990c1cf 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -338,6 +338,7 @@ struct inode *nilfs_new_inode(struct inode *dir, int mode)
 	/* ii->i_file_acl = 0; */
 	/* ii->i_dir_acl = 0; */
 	ii->i_dir_start_lookup = 0;
+	ii->i_parent_ino = dir->i_ino;
 	nilfs_set_inode_flags(inode);
 	spin_lock(&nilfs->ns_next_gen_lock);
 	inode->i_generation = nilfs->ns_next_generation++;
@@ -415,6 +416,8 @@ int nilfs_read_inode_common(struct inode *inode,
 		0 : le32_to_cpu(raw_inode->i_dir_acl);
 #endif
 	ii->i_dir_start_lookup = 0;
+	ii->i_parent_ino = le32_to_cpu(raw_inode->i_parent_ino);
+
 	inode->i_generation = le32_to_cpu(raw_inode->i_generation);
 
 	if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
@@ -580,6 +583,7 @@ struct inode *nilfs_iget_for_gc(struct super_block *sb, unsigned long ino,
 void nilfs_write_inode_common(struct inode *inode,
 			      struct nilfs_inode *raw_inode, int has_bmap)
 {
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
@@ -595,13 +599,11 @@ void nilfs_write_inode_common(struct inode *inode,
 
 	raw_inode->i_flags = cpu_to_le32(ii->i_flags);
 	raw_inode->i_generation = cpu_to_le32(inode->i_generation);
+	raw_inode->i_parent_ino = cpu_to_le32(ii->i_parent_ino);
 
 	if (NILFS_ROOT_METADATA_FILE(inode->i_ino)) {
-		struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
-
 		/* zero-fill unused portion in the case of super root block */
 		raw_inode->i_xattr = 0;
-		raw_inode->i_pad = 0;
 		memset((void *)raw_inode + sizeof(*raw_inode), 0,
 		       nilfs->ns_inode_size - sizeof(*raw_inode));
 	}
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 546849b..16bfa37 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -300,6 +300,9 @@ static int nilfs_do_unlink(struct inode *dir, struct dentry *dentry)
 	if (err)
 		goto out;
 
+	if (NILFS_I(inode)->i_parent_ino == dir->i_ino)
+		NILFS_I(inode)->i_parent_ino = 0;
+
 	inode->i_ctime = dir->i_ctime;
 	drop_nlink(inode);
 	err = 0;
@@ -419,6 +422,8 @@ static int nilfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		}
 	}
 
+	if (NILFS_I(old_inode)->i_parent_ino == old_dir->i_ino)
+		NILFS_I(old_inode)->i_parent_ino = new_dir->i_ino;
 	/*
 	 * Like most other Unix systems, set the ctime for inodes on a
 	 * rename.
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 56ca055..40bada2 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -42,6 +42,7 @@ struct nilfs_inode_info {
 	struct nilfs_bmap i_bmap_data;
 	__u64 i_xattr;	/* sector_t ??? */
 	__u32 i_dir_start_lookup;
+	__u32 i_parent_ino;	/* parent inode number (test) */
 	__u64 i_cno;		/* check point number for GC inode */
 	struct address_space i_btnode_cache;
 	struct list_head i_dirty;	/* List for connecting dirty files */
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index ae49b20..599ccd1 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -60,7 +60,7 @@
  * @i_bmap: block mapping
  * @i_xattr: extended attributes
  * @i_generation: file generation (for NFS)
- * @i_pad:	padding
+ * @i_parent_ino: parent inode number (for test)
  */
 struct nilfs_inode {
 	__le64	i_blocks;
@@ -78,7 +78,7 @@ struct nilfs_inode {
 #define i_device_code	i_bmap[0]
 	__le64	i_xattr;
 	__le32	i_generation;
-	__le32	i_pad;
+	__le32	i_parent_ino;
 };
 
 /**
@@ -218,9 +218,11 @@ struct nilfs_super_block {
  * doesn't know about, it should refuse to mount the filesystem.
  */
 #define NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT	0x00000001ULL
+#define NILFS_FEATURE_COMPAT_RO_PARENT_INO	0x00000002ULL
 
 #define NILFS_FEATURE_COMPAT_SUPP	0ULL
-#define NILFS_FEATURE_COMPAT_RO_SUPP	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT
+#define NILFS_FEATURE_COMPAT_RO_SUPP	(NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT \
+					 | NILFS_FEATURE_COMPAT_RO_PARENT_INO)
 #define NILFS_FEATURE_INCOMPAT_SUPP	0ULL
 
 /*
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
