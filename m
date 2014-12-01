From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v3] nilfs2: avoid duplicate segment construction for fsync()
Date: Mon,  1 Dec 2014 19:03:11 +0100
Message-ID: <1417456991-32642-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This patch removes filemap_write_and_wait_range() from
nilfs_sync_file(), because it triggers a data segment construction by
calling nilfs_writepages() with WB_SYNC_ALL. A data segment construction
does not remove the inode from the i_dirty list and it does not clear
the NILFS_I_DIRTY flag. Therefore nilfs_inode_dirty() still returns
true, which leads to an unnecessary duplicate segment construction in
nilfs_sync_file().

A call to filemap_write_and_wait_range() is not needed, because NILFS2
does not rely on the generic writeback mechanisms. Instead it implements
its own mechanism to collect all dirty pages and write them into
segments. It is more efficient to initiate the segment construction
directly in nilfs_sync_file() without the detour over
filemap_write_and_wait_range().

Additionally the lock of i_mutex is not needed, because all code blocks
that are protected by i_mutex are also protected by a NILFS transaction:

Function                i_mutex     nilfs_transaction
------------------------------------------------------
nilfs_ioctl_setflags:   yes         yes
nilfs_fiemap:           yes         no
nilfs_write_begin:      yes         yes
nilfs_write_end:        yes         yes
nilfs_lookup:           yes         no
nilfs_create:           yes         yes
nilfs_link:             yes         yes
nilfs_mknod:            yes         yes
nilfs_symlink:          yes         yes
nilfs_mkdir:            yes         yes
nilfs_unlink:           yes         yes
nilfs_rmdir:            yes         yes
nilfs_rename:           yes         yes
nilfs_setattr:          yes         yes

For nilfs_lookup() i_mutex is held for the parent directory, to protect
it from modification. The segment construction does not modify directory
inodes, so no lock is needed.

nilfs_fiemap() reads the block layout on the disk, by using
nilfs_bmap_lookup_contig(). This is already protected by bmap->b_sem.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/file.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index e9e3325..3a03e0a 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -39,21 +39,15 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 */
 	struct the_nilfs *nilfs;
 	struct inode *inode = file->f_mapping->host;
-	int err;
-
-	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
-	if (err)
-		return err;
-	mutex_lock(&inode->i_mutex);
+	int err = 0;
 
 	if (nilfs_inode_dirty(inode)) {
 		if (datasync)
 			err = nilfs_construct_dsync_segment(inode->i_sb, inode,
-							    0, LLONG_MAX);
+							    start, end);
 		else
 			err = nilfs_construct_segment(inode->i_sb);
 	}
-	mutex_unlock(&inode->i_mutex);
 
 	nilfs = inode->i_sb->s_fs_info;
 	if (!err)
-- 
2.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
