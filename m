From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 20/23] nilfs2: see state of root dentry for mount check of snapshots
Date: Tue, 14 Sep 2010 00:37:21 +0900
Message-ID: <1284392244-27100-21-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

After applied the patch that unified sb instances, root dentry of
snapshots can be left in dcache even after their trees are unmounted.

The orphan root dentry/inode keeps a root object, and this causes
false positive of nilfs_checkpoint_is_mounted function.

This resolves the issue by having nilfs_checkpoint_is_mounted test
whether the root dentry is busy or not.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/cpfile.c    |   23 ++++++++---------------
 fs/nilfs2/inode.c     |   10 ++++++++++
 fs/nilfs2/nilfs.h     |    3 +++
 fs/nilfs2/super.c     |   32 ++++++++++++++++++++++++++++++++
 fs/nilfs2/the_nilfs.c |   21 ---------------------
 fs/nilfs2/the_nilfs.h |    1 -
 6 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 03de1da..5ff15a8 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -863,26 +863,19 @@ int nilfs_cpfile_is_snapshot(struct inode *cpfile, __u64 cno)
  */
 int nilfs_cpfile_change_cpmode(struct inode *cpfile, __u64 cno, int mode)
 {
-	struct the_nilfs *nilfs;
 	int ret;
 
-	nilfs = NILFS_MDT(cpfile)->mi_nilfs;
-
 	switch (mode) {
 	case NILFS_CHECKPOINT:
-		/*
-		 * Check for protecting existing snapshot mounts:
-		 * ns_mount_mutex is used to make this operation atomic and
-		 * exclusive with a new mount job.  Though it doesn't cover
-		 * umount, it's enough for the purpose.
-		 */
-		if (nilfs_checkpoint_is_mounted(nilfs, cno, 1)) {
-			/* Current implementation does not have to protect
-			   plain read-only mounts since they are exclusive
-			   with a read/write mount and are protected from the
-			   cleaner. */
+		if (nilfs_checkpoint_is_mounted(cpfile->i_sb, cno))
+			/*
+			 * Current implementation does not have to protect
+			 * plain read-only mounts since they are exclusive
+			 * with a read/write mount and are protected from the
+			 * cleaner.
+			 */
 			ret = -EBUSY;
-		} else
+		else
 			ret = nilfs_cpfile_clear_snapshot(cpfile, cno);
 		return ret;
 	case NILFS_SNAPSHOT:
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 5b3d43f..71d4bc8 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -506,6 +506,16 @@ static int nilfs_iget_set(struct inode *inode, void *opaque)
 	return 0;
 }
 
+struct inode *nilfs_ilookup(struct super_block *sb, struct nilfs_root *root,
+			    unsigned long ino)
+{
+	struct nilfs_iget_args args = {
+		.ino = ino, .root = root, .cno = 0, .for_gc = 0
+	};
+
+	return ilookup5(sb, ino, nilfs_iget_test, &args);
+}
+
 struct inode *nilfs_iget_locked(struct super_block *sb, struct nilfs_root *root,
 				unsigned long ino)
 {
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 2ca2ca5..f6e276e 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -244,6 +244,8 @@ extern int nilfs_get_block(struct inode *, sector_t, struct buffer_head *, int);
 extern void nilfs_set_inode_flags(struct inode *);
 extern int nilfs_read_inode_common(struct inode *, struct nilfs_inode *);
 extern void nilfs_write_inode_common(struct inode *, struct nilfs_inode *, int);
+struct inode *nilfs_ilookup(struct super_block *sb, struct nilfs_root *root,
+			    unsigned long ino);
 struct inode *nilfs_iget_locked(struct super_block *sb, struct nilfs_root *root,
 				unsigned long ino);
 struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root *root,
@@ -285,6 +287,7 @@ extern int nilfs_commit_super(struct nilfs_sb_info *, int);
 extern int nilfs_cleanup_super(struct nilfs_sb_info *);
 int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno, int curr_mnt,
 			    struct nilfs_root **root);
+int nilfs_checkpoint_is_mounted(struct super_block *sb, __u64 cno);
 
 /* gcinode.c */
 int nilfs_gccache_submit_read_data(struct inode *, sector_t, sector_t, __u64,
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 361400b..c0ce90b 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -838,6 +838,38 @@ static int nilfs_try_to_shrink_tree(struct dentry *root_dentry)
 	return nilfs_tree_was_touched(root_dentry);
 }
 
+int nilfs_checkpoint_is_mounted(struct super_block *sb, __u64 cno)
+{
+	struct the_nilfs *nilfs = NILFS_SB(sb)->s_nilfs;
+	struct nilfs_root *root;
+	struct inode *inode;
+	struct dentry *dentry;
+	int ret;
+
+	if (cno < 0 || cno > nilfs->ns_cno)
+		return false;
+
+	if (cno >= nilfs_last_cno(nilfs))
+		return true;	/* protect recent checkpoints */
+
+	ret = false;
+	root = nilfs_lookup_root(NILFS_SB(sb)->s_nilfs, cno);
+	if (root) {
+		inode = nilfs_ilookup(sb, root, NILFS_ROOT_INO);
+		if (inode) {
+			dentry = d_find_alias(inode);
+			if (dentry) {
+				if (nilfs_tree_was_touched(dentry))
+					ret = nilfs_try_to_shrink_tree(dentry);
+				dput(dentry);
+			}
+			iput(inode);
+		}
+		nilfs_put_root(root);
+	}
+	return ret;
+}
+
 /**
  * nilfs_fill_super() - initialize a super block instance
  * @sb: super_block
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 768e162..f973333 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -769,24 +769,3 @@ void nilfs_put_root(struct nilfs_root *root)
 		kfree(root);
 	}
 }
-
-int nilfs_checkpoint_is_mounted(struct the_nilfs *nilfs, __u64 cno,
-				int snapshot_mount)
-{
-	struct nilfs_root *root;
-	int ret;
-
-	if (cno < 0 || cno > nilfs->ns_cno)
-		return false;
-
-	if (cno >= nilfs_last_cno(nilfs))
-		return true;	/* protect recent checkpoints */
-
-	ret = false;
-	root = nilfs_lookup_root(nilfs, cno);
-	if (root) {
-		ret = true;
-		nilfs_put_root(root);
-	}
-	return ret;
-}
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index a5178dc..cae56f3 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -242,7 +242,6 @@ struct nilfs_root *nilfs_find_or_create_root(struct the_nilfs *nilfs,
 					     __u64 cno);
 void nilfs_put_root(struct nilfs_root *root);
 struct nilfs_sb_info *nilfs_find_sbinfo(struct the_nilfs *, int, __u64);
-int nilfs_checkpoint_is_mounted(struct the_nilfs *, __u64, int);
 int nilfs_near_disk_full(struct the_nilfs *);
 void nilfs_fall_back_super_block(struct the_nilfs *);
 void nilfs_swap_super_block(struct the_nilfs *);
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
