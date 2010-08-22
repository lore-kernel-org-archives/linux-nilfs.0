From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 4/6] nilfs2: use iget5_locked to get inode
Date: Sun, 22 Aug 2010 19:05:04 +0900
Message-ID: <1282471506-29618-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1282471506-29618-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282471506-29618-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This uses iget5_locked instead of iget_locked so that gc cache can
look up inodes with an inode number and an optional checkpoint number.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c |   37 ++++++++++++++++++++++++++++++++++---
 fs/nilfs2/super.c |    1 +
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index f1750ca..6e9df85 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -34,6 +34,11 @@
 #include "cpfile.h"
 #include "ifile.h"
 
+struct nilfs_iget_args {
+	u64 ino;
+	__u64 cno;
+	int for_gc;
+};
 
 /**
  * nilfs_get_block() - get a file block on the filesystem (callback function)
@@ -320,7 +325,6 @@ struct inode *nilfs_new_inode(struct inode *dir, int mode)
 	/* ii->i_file_acl = 0; */
 	/* ii->i_dir_acl = 0; */
 	ii->i_dir_start_lookup = 0;
-	ii->i_cno = 0;
 	nilfs_set_inode_flags(inode);
 	spin_lock(&sbi->s_next_gen_lock);
 	inode->i_generation = sbi->s_next_generation++;
@@ -410,7 +414,6 @@ int nilfs_read_inode_common(struct inode *inode,
 		0 : le32_to_cpu(raw_inode->i_dir_acl);
 #endif
 	ii->i_dir_start_lookup = 0;
-	ii->i_cno = 0;
 	inode->i_generation = le32_to_cpu(raw_inode->i_generation);
 
 	if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
@@ -476,12 +479,40 @@ static int __nilfs_read_inode(struct super_block *sb, unsigned long ino,
 	return err;
 }
 
+static int nilfs_iget_test(struct inode *inode, void *opaque)
+{
+	struct nilfs_iget_args *args = opaque;
+	struct nilfs_inode_info *ii;
+
+	if (args->ino != inode->i_ino)
+		return 0;
+
+	ii = NILFS_I(inode);
+	if (!test_bit(NILFS_I_GCINODE, &ii->i_state))
+		return !args->for_gc;
+
+	return args->for_gc && args->cno == ii->i_cno;
+}
+
+static int nilfs_iget_set(struct inode *inode, void *opaque)
+{
+	struct nilfs_iget_args *args = opaque;
+
+	inode->i_ino = args->ino;
+	if (args->for_gc) {
+		NILFS_I(inode)->i_state = 1 << NILFS_I_GCINODE;
+		NILFS_I(inode)->i_cno = args->cno;
+	}
+	return 0;
+}
+
 struct inode *nilfs_iget(struct super_block *sb, unsigned long ino)
 {
+	struct nilfs_iget_args args = { .ino = ino, .cno = 0, .for_gc = 0 };
 	struct inode *inode;
 	int err;
 
-	inode = iget_locked(sb, ino);
+	inode = iget5_locked(sb, ino, nilfs_iget_test, nilfs_iget_set, &args);
 	if (unlikely(!inode))
 		return ERR_PTR(-ENOMEM);
 	if (!(inode->i_state & I_NEW))
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 6febd32..452004b 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -156,6 +156,7 @@ struct inode *nilfs_alloc_inode_common(struct the_nilfs *nilfs)
 		return NULL;
 	ii->i_bh = NULL;
 	ii->i_state = 0;
+	ii->i_cno = 0;
 	ii->vfs_inode.i_version = 1;
 	nilfs_btnode_cache_init(&ii->i_btnode_cache, nilfs->ns_bdi);
 	return &ii->vfs_inode;
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
