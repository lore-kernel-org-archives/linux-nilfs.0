From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 05/23] nilfs2: move inode count and block count into root object
Date: Tue, 14 Sep 2010 00:37:06 +0900
Message-ID: <1284392244-27100-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This moves sbi->s_inodes_count and sbi->s_blocks_count into nilfs_root
object.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c   |    4 ++--
 fs/nilfs2/sb.h      |    2 --
 fs/nilfs2/segment.c |    4 ++--
 fs/nilfs2/super.c   |   11 ++++++-----
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 7e883d5..ca09e43 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -306,7 +306,7 @@ struct inode *nilfs_new_inode(struct inode *dir, int mode)
 		goto failed_ifile_create_inode;
 	/* reference count of i_bh inherits from nilfs_mdt_read_block() */
 
-	atomic_inc(&sbi->s_inodes_count);
+	atomic_inc(&root->inodes_count);
 	inode_init_owner(inode, dir, mode);
 	inode->i_ino = ino;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
@@ -715,7 +715,7 @@ void nilfs_evict_inode(struct inode *inode)
 	end_writeback(inode);
 
 	nilfs_ifile_delete_inode(ii->i_root->ifile, inode->i_ino);
-	atomic_dec(&NILFS_SB(sb)->s_inodes_count);
+	atomic_dec(&ii->i_root->inodes_count);
 
 	nilfs_clear_inode(inode);
 
diff --git a/fs/nilfs2/sb.h b/fs/nilfs2/sb.h
index 50c418e..3cc3675 100644
--- a/fs/nilfs2/sb.h
+++ b/fs/nilfs2/sb.h
@@ -44,8 +44,6 @@ struct nilfs_sc_info;
 struct nilfs_sb_info {
 	/* Snapshot status */
 	__u64 s_snapshot_cno;		/* Checkpoint number */
-	atomic_t s_inodes_count;
-	atomic_t s_blocks_count;	/* Reserved (might be deleted) */
 
 	/* Mount options */
 	unsigned long s_mount_opt;
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 2a6b74e..b75306d 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -856,9 +856,9 @@ static int nilfs_segctor_fill_in_checkpoint(struct nilfs_sc_info *sci)
 	raw_cp->cp_snapshot_list.ssl_next = 0;
 	raw_cp->cp_snapshot_list.ssl_prev = 0;
 	raw_cp->cp_inodes_count =
-		cpu_to_le64(atomic_read(&sbi->s_inodes_count));
+		cpu_to_le64(atomic_read(&sci->sc_root->inodes_count));
 	raw_cp->cp_blocks_count =
-		cpu_to_le64(atomic_read(&sbi->s_blocks_count));
+		cpu_to_le64(atomic_read(&sci->sc_root->blocks_count));
 	raw_cp->cp_nblk_inc =
 		cpu_to_le64(sci->sc_nblk_inc + sci->sc_nblk_this_inc);
 	raw_cp->cp_create = cpu_to_le64(sci->sc_seg_ctime);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index fafb724..dab86bb 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -434,8 +434,9 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno, int curr_mnt,
 	err = nilfs_read_inode_common(root->ifile, &raw_cp->cp_ifile_inode);
 	if (unlikely(err))
 		goto failed_bh;
-	atomic_set(&sbi->s_inodes_count, le64_to_cpu(raw_cp->cp_inodes_count));
-	atomic_set(&sbi->s_blocks_count, le64_to_cpu(raw_cp->cp_blocks_count));
+
+	atomic_set(&root->inodes_count, le64_to_cpu(raw_cp->cp_inodes_count));
+	atomic_set(&root->blocks_count, le64_to_cpu(raw_cp->cp_blocks_count));
 
 	nilfs_cpfile_put_checkpoint(nilfs->ns_cpfile, cno, bh_cp);
 
@@ -454,8 +455,8 @@ int nilfs_attach_checkpoint(struct nilfs_sb_info *sbi, __u64 cno, int curr_mnt,
 static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct nilfs_root *root = NILFS_I(dentry->d_inode)->i_root;
+	struct the_nilfs *nilfs = root->nilfs;
 	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 	unsigned long long blocks;
 	unsigned long overhead;
@@ -491,7 +492,7 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bfree = nfreeblocks;
 	buf->f_bavail = (buf->f_bfree >= nrsvblocks) ?
 		(buf->f_bfree - nrsvblocks) : 0;
-	buf->f_files = atomic_read(&sbi->s_inodes_count);
+	buf->f_files = atomic_read(&root->inodes_count);
 	buf->f_ffree = 0; /* nilfs_count_free_inodes(sb); */
 	buf->f_namelen = NILFS_NAME_LEN;
 	buf->f_fsid.val[0] = (u32)id;
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
