From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: fix misuse of open_bdev_exclusive/close_bdev_exclusive
Date: Sun,  9 May 2010 03:36:23 +0900
Message-ID: <1273343784-22709-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

The second argument of open_bdev_exclusive/close_bdev_exclusive takes
fmode_t flags instead of mount flags.  This fixes the misuse.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index f6cff39..40eb231 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -997,10 +997,14 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 {
 	struct nilfs_super_data sd;
 	struct super_block *s;
+	fmode_t mode = FMODE_READ;
 	struct the_nilfs *nilfs;
 	int err, need_to_close = 1;
 
-	sd.bdev = open_bdev_exclusive(dev_name, flags, fs_type);
+	if (!(flags & MS_RDONLY))
+		mode |= FMODE_WRITE;
+
+	sd.bdev = open_bdev_exclusive(dev_name, mode, fs_type);
 	if (IS_ERR(sd.bdev))
 		return PTR_ERR(sd.bdev);
 
@@ -1081,7 +1085,7 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	mutex_unlock(&nilfs->ns_mount_mutex);
 	put_nilfs(nilfs);
 	if (need_to_close)
-		close_bdev_exclusive(sd.bdev, flags);
+		close_bdev_exclusive(sd.bdev, mode);
 	simple_set_mnt(mnt, s);
 	return 0;
 
@@ -1089,7 +1093,7 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	mutex_unlock(&nilfs->ns_mount_mutex);
 	put_nilfs(nilfs);
  failed:
-	close_bdev_exclusive(sd.bdev, flags);
+	close_bdev_exclusive(sd.bdev, mode);
 
 	return err;
 
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
