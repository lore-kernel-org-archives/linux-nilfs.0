From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 1/1] nilfs2: remove unnecessary call to nilfs_construct_dsync_segment()
Date: Sat,  1 Nov 2014 18:01:07 +0100
Message-ID: <1414861267-13103-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

If some of the pages between start and end are dirty, then
filemap_write_and_wait_range() calls nilfs_writepages() with WB_SYNC_ALL
set in the writeback_control structure. This initiates the construction
of a dsync segment via nilfs_construct_dsync_segment(). The problem is,
that the construction of a dsync segment doesnt't remove the inode from
die i_dirty list and doesn't clear the NILFS_I_DIRTY flag. So
nilfs_inode_dirty() still returns true after
nilfs_construct_dsync_segment() succeded. This leads to an
unnecessary second call to nilfs_construct_dsync_segment() in
nilfs_sync_file() if datasync is true.

This patch simply removes the second invokation of
nilfs_construct_dsync_segment().

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/file.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index e9e3325..b12e0ab 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -46,13 +46,9 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		return err;
 	mutex_lock(&inode->i_mutex);
 
-	if (nilfs_inode_dirty(inode)) {
-		if (datasync)
-			err = nilfs_construct_dsync_segment(inode->i_sb, inode,
-							    0, LLONG_MAX);
-		else
-			err = nilfs_construct_segment(inode->i_sb);
-	}
+	if (!datasync && nilfs_inode_dirty(inode))
+		err = nilfs_construct_segment(inode->i_sb);
+
 	mutex_unlock(&inode->i_mutex);
 
 	nilfs = inode->i_sb->s_fs_info;
-- 
2.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
