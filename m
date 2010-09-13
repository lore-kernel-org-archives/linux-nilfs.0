From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 09/23] nilfs2: split out nilfs_attach_snapshot
Date: Tue, 14 Sep 2010 00:37:10 +0900
Message-ID: <1284392244-27100-10-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This splits the code to attach snapshots into a separate routine for
convenience sake.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c |   73 ++++++++++++++++++++++++++++++++--------------------
 1 files changed, 45 insertions(+), 28 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 23ad8d4..0ebe4c6 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -788,6 +788,40 @@ static int nilfs_get_root_dentry(struct super_block *sb,
 	return ret;
 }
 
+static int nilfs_attach_snapshot(struct super_block *s, __u64 cno,
+				 struct dentry **root_dentry)
+{
+	struct the_nilfs *nilfs = NILFS_SB(s)->s_nilfs;
+	struct nilfs_root *root;
+	int ret;
+
+	down_read(&nilfs->ns_segctor_sem);
+	ret = nilfs_cpfile_is_snapshot(nilfs->ns_cpfile, cno);
+	up_read(&nilfs->ns_segctor_sem);
+	if (ret < 0) {
+		ret = (ret == -ENOENT) ? -EINVAL : ret;
+		goto out;
+	} else if (!ret) {
+		printk(KERN_ERR "NILFS: The specified checkpoint is "
+		       "not a snapshot (checkpoint number=%llu).\n",
+		       (unsigned long long)cno);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = nilfs_attach_checkpoint(NILFS_SB(s), cno, false, &root);
+	if (ret) {
+		printk(KERN_ERR "NILFS: error loading snapshot "
+		       "(checkpoint number=%llu).\n",
+	       (unsigned long long)cno);
+		goto out;
+	}
+	ret = nilfs_get_root_dentry(s, root, root_dentry);
+	nilfs_put_root(root);
+ out:
+	return ret;
+}
+
 /**
  * nilfs_fill_super() - initialize a super block instance
  * @sb: super_block
@@ -805,7 +839,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 	struct nilfs_sb_info *sbi;
 	struct nilfs_root *fsroot;
 	__u64 cno;
-	int err, curr_mnt;
+	int err;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
@@ -846,35 +880,17 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 	if (err)
 		goto failed_sbi;
 
-	cno = nilfs_last_cno(nilfs);
-	curr_mnt = true;
-
-	if (sb->s_flags & MS_RDONLY) {
-		if (nilfs_test_opt(sbi, SNAPSHOT)) {
-			down_read(&nilfs->ns_segctor_sem);
-			err = nilfs_cpfile_is_snapshot(nilfs->ns_cpfile,
-						       sbi->s_snapshot_cno);
-			up_read(&nilfs->ns_segctor_sem);
-			if (err < 0) {
-				if (err == -ENOENT)
-					err = -EINVAL;
-				goto failed_sbi;
-			}
-			if (!err) {
-				printk(KERN_ERR
-				       "NILFS: The specified checkpoint is "
-				       "not a snapshot "
-				       "(checkpoint number=%llu).\n",
-				       (unsigned long long)sbi->s_snapshot_cno);
-				err = -EINVAL;
-				goto failed_sbi;
-			}
-			cno = sbi->s_snapshot_cno;
-			curr_mnt = false;
-		}
+	if (nilfs_test_opt(sbi, SNAPSHOT)) {
+		err = nilfs_attach_snapshot(sb, sbi->s_snapshot_cno,
+					    &sb->s_root);
+		if (err)
+			goto failed_sbi;
+
+		goto add_to_supers;
 	}
 
-	err = nilfs_attach_checkpoint(sbi, cno, curr_mnt, &fsroot);
+	cno = nilfs_last_cno(nilfs);
+	err = nilfs_attach_checkpoint(sbi, cno, true, &fsroot);
 	if (err) {
 		printk(KERN_ERR "NILFS: error loading a checkpoint"
 		       " (checkpoint number=%llu).\n", (unsigned long long)cno);
@@ -899,6 +915,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 		up_write(&nilfs->ns_sem);
 	}
 
+ add_to_supers:
 	down_write(&nilfs->ns_super_sem);
 	list_add(&sbi->s_list, &nilfs->ns_supers);
 	if (!nilfs_test_opt(sbi, SNAPSHOT))
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
