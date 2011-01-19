From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/4] nilfs2: tighten restrictions on inode flags
Date: Thu, 20 Jan 2011 02:41:30 +0900
Message-ID: <1295458891-22715-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1295458891-22715-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295458891-22715-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Nilfs has few rectrictions on which flags may be set on which inodes
like ext2/3/4 filesystems used to be.  Specifically DIRSYNC may only
be set on directories and IMMUTABLE and APPEND may not be set on
links.  Tighten that to disallow TOPDIR being set on non-directories
and only NODUMP and NOATIME to be set on non-regular file,
non-directories.

This introduces a flags masking function like those of extN and uses
it during inode creation.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c |    7 ++-----
 fs/nilfs2/nilfs.h |   17 +++++++++++++++++
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 2db4e92..1b1cadc 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -315,11 +315,8 @@ struct inode *nilfs_new_inode(struct inode *dir, int mode)
 		/* No lock is needed; iget() ensures it. */
 	}
 
-	ii->i_flags = NILFS_I(dir)->i_flags;
-	if (S_ISLNK(mode))
-		ii->i_flags &= ~(FS_IMMUTABLE_FL | FS_APPEND_FL);
-	if (!S_ISDIR(mode))
-		ii->i_flags &= ~FS_DIRSYNC_FL;
+	ii->i_flags = nilfs_mask_flags(
+		mode, NILFS_I(dir)->i_flags & NILFS_FL_INHERITED);
 
 	/* ii->i_file_acl = 0; */
 	/* ii->i_dir_acl = 0; */
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 777e8fd..3e3acb1 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -212,6 +212,23 @@ static inline int nilfs_init_acl(struct inode *inode, struct inode *dir)
 
 #define NILFS_ATIME_DISABLE
 
+/* Flags that should be inherited by new inodes from their parent. */
+#define NILFS_FL_INHERITED						\
+	(FS_SECRM_FL | FS_UNRM_FL | FS_COMPR_FL | FS_SYNC_FL |		\
+	 FS_IMMUTABLE_FL | FS_APPEND_FL | FS_NODUMP_FL | FS_NOATIME_FL |\
+	 FS_COMPRBLK_FL | FS_NOCOMP_FL | FS_NOTAIL_FL | FS_DIRSYNC_FL)
+
+/* Mask out flags that are inappropriate for the given type of inode. */
+static inline __u32 nilfs_mask_flags(umode_t mode, __u32 flags)
+{
+	if (S_ISDIR(mode))
+		return flags;
+	else if (S_ISREG(mode))
+		return flags & ~(FS_DIRSYNC_FL | FS_TOPDIR_FL);
+	else
+		return flags & (FS_NODUMP_FL | FS_NOATIME_FL);
+}
+
 /* dir.c */
 extern int nilfs_add_link(struct dentry *, struct inode *);
 extern ino_t nilfs_inode_by_name(struct inode *, const struct qstr *);
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
