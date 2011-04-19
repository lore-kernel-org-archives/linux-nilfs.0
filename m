From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: zero fill unused portion of super root block
Date: Wed, 20 Apr 2011 02:27:16 +0900
Message-ID: <1303234036-11127-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

The super root block is newly-allocated each time it is written back
to disk, so unused portion of the block should be cleared.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c         |   10 ++++++++++
 fs/nilfs2/segment.c       |    2 ++
 include/linux/nilfs2_fs.h |    1 +
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 2cc8c08..699170e 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -596,6 +596,16 @@ void nilfs_write_inode_common(struct inode *inode,
 	raw_inode->i_flags = cpu_to_le32(ii->i_flags);
 	raw_inode->i_generation = cpu_to_le32(inode->i_generation);
 
+	if (NILFS_ROOT_METADATA_FILE(inode->i_ino)) {
+		struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+
+		/* zero-fill unused portion in the case of super root block */
+		raw_inode->i_xattr = 0;
+		raw_inode->i_pad = 0;
+		memset((void *)raw_inode + sizeof(*raw_inode), 0,
+		       nilfs->ns_inode_size - sizeof(*raw_inode));
+	}
+
 	if (has_bmap)
 		nilfs_bmap_write(ii->i_bmap, raw_inode);
 	else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index abbfab9..af53d5b 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -906,6 +906,8 @@ static void nilfs_segctor_fill_in_super_root(struct nilfs_sc_info *sci,
 				 NILFS_SR_CPFILE_OFFSET(isz), 1);
 	nilfs_write_inode_common(nilfs->ns_sufile, (void *)raw_sr +
 				 NILFS_SR_SUFILE_OFFSET(isz), 1);
+	memset((void *)raw_sr + NILFS_SR_RESERVE_OFFSET(isz), 0,
+	       nilfs->ns_blocksize - NILFS_SR_RESERVE_OFFSET(isz));
 }
 
 static void nilfs_redirty_inodes(struct list_head *head)
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 8768c46..9c0dd5f 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -107,6 +107,7 @@ struct nilfs_super_root {
 #define NILFS_SR_DAT_OFFSET(inode_size)     NILFS_SR_MDT_OFFSET(inode_size, 0)
 #define NILFS_SR_CPFILE_OFFSET(inode_size)  NILFS_SR_MDT_OFFSET(inode_size, 1)
 #define NILFS_SR_SUFILE_OFFSET(inode_size)  NILFS_SR_MDT_OFFSET(inode_size, 2)
+#define NILFS_SR_RESERVE_OFFSET(inode_size) NILFS_SR_MDT_OFFSET(inode_size, 3)
 #define NILFS_SR_BYTES                  (sizeof(struct nilfs_super_root))
 
 /*
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
