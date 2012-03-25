From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: flush disk caches in syncing
Date: Mon, 26 Mar 2012 01:26:45 +0900 (JST)
Message-ID: <20120326.012645.133432514.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is an experimental patch that I'm planning to send upstream in
the next release cycle unless it causes problems.

The current nilfs does not flush disk caches in fsync and
checkpointing ioctl called from mkcp command.  So, there is a
potential for data loss after unexpected hang or power failure even
though nilfs guarantees consistency with checksumming for such
troubles.

This patch fixes the potential data loss issue by making a few sync
related functions issue a flush cache request to device.

Regards,
Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

There are two cases that the cache flush is needed to avoid data loss
against unexpected hang or power failure.  One is sync file function
(i.e. nilfs_sync_file) and another is checkpointing ioctl.

This issues a cache flush request to device for such cases if barrier
mount option is enabled, and makes sure data really is on persistent
storage on their completion.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/file.c  |   24 ++++++++++++++----------
 fs/nilfs2/ioctl.c |    8 +++++++-
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 2660152..62cebc8 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -37,6 +37,7 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 * This function should be implemented when the writeback function
 	 * will be implemented.
 	 */
+	struct the_nilfs *nilfs;
 	struct inode *inode = file->f_mapping->host;
 	int err;
 
@@ -45,18 +46,21 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		return err;
 	mutex_lock(&inode->i_mutex);
 
-	if (!nilfs_inode_dirty(inode)) {
-		mutex_unlock(&inode->i_mutex);
-		return 0;
+	if (nilfs_inode_dirty(inode)) {
+		if (datasync)
+			err = nilfs_construct_dsync_segment(inode->i_sb, inode,
+							    0, LLONG_MAX);
+		else
+			err = nilfs_construct_segment(inode->i_sb);
 	}
-
-	if (datasync)
-		err = nilfs_construct_dsync_segment(inode->i_sb, inode, 0,
-						    LLONG_MAX);
-	else
-		err = nilfs_construct_segment(inode->i_sb);
-
 	mutex_unlock(&inode->i_mutex);
+
+	nilfs = inode->i_sb->s_fs_info;
+	if (!err && nilfs_test_opt(nilfs, BARRIER)) {
+		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+		if (err != -EIO)
+			err = 0;
+	}
 	return err;
 }
 
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 2a70fce..06658ca 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -692,8 +692,14 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
 	if (ret < 0)
 		return ret;
 
+	nilfs = inode->i_sb->s_fs_info;
+	if (nilfs_test_opt(nilfs, BARRIER)) {
+		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+		if (ret == -EIO)
+			return ret;
+	}
+
 	if (argp != NULL) {
-		nilfs = inode->i_sb->s_fs_info;
 		down_read(&nilfs->ns_segctor_sem);
 		cno = nilfs->ns_cno - 1;
 		up_read(&nilfs->ns_segctor_sem);
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
