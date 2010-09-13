From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 08/23] nilfs2: split out nilfs_get_root_dentry
Date: Tue, 14 Sep 2010 00:37:09 +0900
Message-ID: <1284392244-27100-9-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This splits the code to allocate root dentry into a separate routine
for convenience in successive changes.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c |   54 ++++++++++++++++++++++++++++++++++------------------
 1 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index dab86bb..23ad8d4 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -755,6 +755,39 @@ int nilfs_check_feature_compatibility(struct super_block *sb,
 	return 0;
 }
 
+static int nilfs_get_root_dentry(struct super_block *sb,
+				 struct nilfs_root *root,
+				 struct dentry **root_dentry)
+{
+	struct inode *inode;
+	struct dentry *dentry;
+	int ret = 0;
+
+	inode = nilfs_iget(sb, root, NILFS_ROOT_INO);
+	if (IS_ERR(inode)) {
+		printk(KERN_ERR "NILFS: get root inode failed\n");
+		ret = PTR_ERR(inode);
+		goto out;
+	}
+	if (!S_ISDIR(inode->i_mode) || !inode->i_blocks || !inode->i_size) {
+		iput(inode);
+		printk(KERN_ERR "NILFS: corrupt root inode.\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	dentry = d_alloc_root(inode);
+	if (!dentry) {
+		iput(inode);
+		printk(KERN_ERR "NILFS: get root dentry failed\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+	*root_dentry = dentry;
+ out:
+	return ret;
+}
+
 /**
  * nilfs_fill_super() - initialize a super block instance
  * @sb: super_block
@@ -771,7 +804,6 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 {
 	struct nilfs_sb_info *sbi;
 	struct nilfs_root *fsroot;
-	struct inode *root;
 	__u64 cno;
 	int err, curr_mnt;
 
@@ -855,25 +887,9 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 			goto failed_checkpoint;
 	}
 
-	root = nilfs_iget(sb, fsroot, NILFS_ROOT_INO);
-	if (IS_ERR(root)) {
-		printk(KERN_ERR "NILFS: get root inode failed\n");
-		err = PTR_ERR(root);
-		goto failed_segctor;
-	}
-	if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size) {
-		iput(root);
-		printk(KERN_ERR "NILFS: corrupt root inode.\n");
-		err = -EINVAL;
-		goto failed_segctor;
-	}
-	sb->s_root = d_alloc_root(root);
-	if (!sb->s_root) {
-		iput(root);
-		printk(KERN_ERR "NILFS: get root dentry failed\n");
-		err = -ENOMEM;
+	err = nilfs_get_root_dentry(sb, fsroot, &sb->s_root);
+	if (err)
 		goto failed_segctor;
-	}
 
 	nilfs_put_root(fsroot);
 
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
