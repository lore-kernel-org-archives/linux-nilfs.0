From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 07/23] nilfs2: deny write access to inodes in snapshots
Date: Tue, 14 Sep 2010 00:37:08 +0900
Message-ID: <1284392244-27100-8-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

Snapshots of nilfs are read-only.

After super block instances (sb) will be unified, nilfs will need to
check write access by a way other than implicit test with
IS_RDONLY(inode).  This is because IS_RDONLY() refers to MS_RDONLY bit
of inode->i_sb->s_flags and it will become inaccurate after the
unification of sb.

To prepare for the issue, this uses i_op->permission to deny write
access to inodes in snapshots.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/inode.c |   11 +++++++++++
 fs/nilfs2/namei.c |    1 +
 fs/nilfs2/nilfs.h |    4 +---
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index ca09e43..3efef0e 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -764,6 +764,17 @@ out_err:
 	return err;
 }
 
+int nilfs_permission(struct inode *inode, int mask)
+{
+	struct nilfs_root *root = NILFS_I(inode)->i_root;
+
+	if ((mask & MAY_WRITE) && root &&
+	    root->cno != NILFS_CPTREE_CURRENT_CNO)
+		return -EROFS; /* snapshot is not writable */
+
+	return generic_permission(inode, mask, NULL);
+}
+
 int nilfs_load_inode_block(struct nilfs_sb_info *sbi, struct inode *inode,
 			   struct buffer_head **pbh)
 {
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index a65f465..185d160 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -588,6 +588,7 @@ const struct inode_operations nilfs_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.follow_link	= page_follow_link_light,
 	.put_link	= page_put_link,
+	.permission     = nilfs_permission,
 };
 
 const struct export_operations nilfs_export_ops = {
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 3870c10..cf5507a 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -201,12 +201,9 @@ static inline struct inode *nilfs_dat_inode(const struct the_nilfs *nilfs)
  */
 #ifdef CONFIG_NILFS_POSIX_ACL
 #error "NILFS: not yet supported POSIX ACL"
-extern int nilfs_permission(struct inode *, int, struct nameidata *);
 extern int nilfs_acl_chmod(struct inode *);
 extern int nilfs_init_acl(struct inode *, struct inode *);
 #else
-#define nilfs_permission   NULL
-
 static inline int nilfs_acl_chmod(struct inode *inode)
 {
 	return 0;
@@ -256,6 +253,7 @@ extern void nilfs_update_inode(struct inode *, struct buffer_head *);
 extern void nilfs_truncate(struct inode *);
 extern void nilfs_evict_inode(struct inode *);
 extern int nilfs_setattr(struct dentry *, struct iattr *);
+int nilfs_permission(struct inode *inode, int mask);
 extern int nilfs_load_inode_block(struct nilfs_sb_info *, struct inode *,
 				  struct buffer_head **);
 extern int nilfs_inode_dirty(struct inode *);
-- 
1.6.6.2

