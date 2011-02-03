From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCHv2 1/5] nilfs2: use common file attribute macros
Date: Fri,  4 Feb 2011 00:20:10 +0900
Message-ID: <1296746414-11444-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1296746414-11444-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296746414-11444-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Replaces uses of own inode flags (i.e. NILFS_SECRM_FL, NILFS_UNRM_FL,
NILFS_COMPR_FL, and so forth) with common inode flags, and removes the
own flag declarations.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/dir.c           |    3 ---
 fs/nilfs2/inode.c         |   14 +++++++-------
 include/linux/nilfs2_fs.h |   20 --------------------
 3 files changed, 7 insertions(+), 30 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 9d45773..b72833a 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -440,7 +440,6 @@ void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
 	nilfs_commit_chunk(page, mapping, from, to);
 	nilfs_put_page(page);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
-/*	NILFS_I(dir)->i_flags &= ~NILFS_BTREE_FL; */
 }
 
 /*
@@ -531,7 +530,6 @@ got_it:
 	nilfs_set_de_type(de, inode);
 	nilfs_commit_chunk(page, page->mapping, from, to);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
-/*	NILFS_I(dir)->i_flags &= ~NILFS_BTREE_FL; */
 	nilfs_mark_inode_dirty(dir);
 	/* OFFSET_CACHE */
 out_put:
@@ -579,7 +577,6 @@ int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct page *page)
 	dir->inode = 0;
 	nilfs_commit_chunk(page, mapping, from, to);
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
-/*	NILFS_I(inode)->i_flags &= ~NILFS_BTREE_FL; */
 out:
 	nilfs_put_page(page);
 	return err;
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 2fd440d..b97bcfc 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -317,9 +317,9 @@ struct inode *nilfs_new_inode(struct inode *dir, int mode)
 
 	ii->i_flags = NILFS_I(dir)->i_flags;
 	if (S_ISLNK(mode))
-		ii->i_flags &= ~(NILFS_IMMUTABLE_FL | NILFS_APPEND_FL);
+		ii->i_flags &= ~(FS_IMMUTABLE_FL | FS_APPEND_FL);
 	if (!S_ISDIR(mode))
-		ii->i_flags &= ~NILFS_DIRSYNC_FL;
+		ii->i_flags &= ~FS_DIRSYNC_FL;
 
 	/* ii->i_file_acl = 0; */
 	/* ii->i_dir_acl = 0; */
@@ -359,17 +359,17 @@ void nilfs_set_inode_flags(struct inode *inode)
 
 	inode->i_flags &= ~(S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME |
 			    S_DIRSYNC);
-	if (flags & NILFS_SYNC_FL)
+	if (flags & FS_SYNC_FL)
 		inode->i_flags |= S_SYNC;
-	if (flags & NILFS_APPEND_FL)
+	if (flags & FS_APPEND_FL)
 		inode->i_flags |= S_APPEND;
-	if (flags & NILFS_IMMUTABLE_FL)
+	if (flags & FS_IMMUTABLE_FL)
 		inode->i_flags |= S_IMMUTABLE;
 #ifndef NILFS_ATIME_DISABLE
-	if (flags & NILFS_NOATIME_FL)
+	if (flags & FS_NOATIME_FL)
 #endif
 		inode->i_flags |= S_NOATIME;
-	if (flags & NILFS_DIRSYNC_FL)
+	if (flags & FS_DIRSYNC_FL)
 		inode->i_flags |= S_DIRSYNC;
 	mapping_set_gfp_mask(inode->i_mapping,
 			     mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 227e49d..fdcd1bc 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -41,26 +41,6 @@
 #include <linux/types.h>
 #include <linux/ioctl.h>
 
-/*
- * Inode flags stored in nilfs_inode and on-memory nilfs inode
- *
- * We define these flags based on ext2-fs because of the
- * compatibility reason; to avoid problems in chattr(1)
- */
-#define NILFS_SECRM_FL		0x00000001 /* Secure deletion */
-#define NILFS_UNRM_FL		0x00000002 /* Undelete */
-#define NILFS_SYNC_FL		0x00000008 /* Synchronous updates */
-#define NILFS_IMMUTABLE_FL	0x00000010 /* Immutable file */
-#define NILFS_APPEND_FL		0x00000020 /* writes to file may only append */
-#define NILFS_NODUMP_FL		0x00000040 /* do not dump file */
-#define NILFS_NOATIME_FL	0x00000080 /* do not update atime */
-/* Reserved for compression usage... */
-#define NILFS_NOTAIL_FL		0x00008000 /* file tail should not be merged */
-#define NILFS_DIRSYNC_FL	0x00010000 /* dirsync behaviour */
-
-#define NILFS_FL_USER_VISIBLE	0x0003DFFF /* User visible flags */
-#define NILFS_FL_USER_MODIFIABLE	0x000380FF /* User modifiable flags */
-
 
 #define NILFS_INODE_BMAP_SIZE	7
 /**
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
