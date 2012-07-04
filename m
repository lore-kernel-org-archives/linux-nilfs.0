From: Fernando Luis Vazquez Cao <fernando_b1-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] NILFS2: remove references to long gone super operations
Date: Wed, 04 Jul 2012 19:10:36 +0900
Message-ID: <4FF4169C.3030407@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040909070706080100080808"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is a multi-part message in MIME format.
--------------040909070706080100080808
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



--------------040909070706080100080808
Content-Type: text/x-patch;
 name="nilfs2-remove-references-to-long-gone-super_operations.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="nilfs2-remove-references-to-long-gone-super_operations.patch"

Subject: NILFS2: remove references to long gone super operations

From: Fernando Luis Vazquez Cao <fernando-gVGce1chcLdL9jVzuh4AOg@public.gmane.org>

->delete_inode(), ->write_super_lockfs(), ->unlockfs() are gone so remove
refereces to them in the NTFS code. Noticed while cleaning up the fsfreeze
mess.

Signed-off-by: Fernando Luis Vazquez Cao <fernando-gVGce1chcLdL9jVzuh4AOg@public.gmane.org>
---

diff -urNp linux-3.5-rc5-orig/fs/nilfs2/super.c linux-3.5-rc5/fs/nilfs2/super.c
--- linux-3.5-rc5-orig/fs/nilfs2/super.c	2012-05-21 07:29:13.000000000 +0900
+++ linux-3.5-rc5/fs/nilfs2/super.c	2012-07-04 19:04:48.863112670 +0900
@@ -677,7 +677,6 @@ static const struct super_operations nil
 	.destroy_inode  = nilfs_destroy_inode,
 	.dirty_inode    = nilfs_dirty_inode,
 	/* .write_inode    = nilfs_write_inode, */
-	/* .put_inode      = nilfs_put_inode, */
 	/* .drop_inode	  = nilfs_drop_inode, */
 	.evict_inode    = nilfs_evict_inode,
 	.put_super      = nilfs_put_super,
@@ -685,8 +684,6 @@ static const struct super_operations nil
 	.sync_fs        = nilfs_sync_fs,
 	.freeze_fs	= nilfs_freeze,
 	.unfreeze_fs	= nilfs_unfreeze,
-	/* .write_super_lockfs */
-	/* .unlockfs */
 	.statfs         = nilfs_statfs,
 	.remount_fs     = nilfs_remount,
 	/* .umount_begin */

--------------040909070706080100080808--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
