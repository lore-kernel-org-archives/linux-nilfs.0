From: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH -next v2] fs: Fix some kernel-doc comments
Date: Thu, 24 Mar 2022 10:42:15 +0800
Message-ID: <20220324024215.63479-1-yang.lee@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

The description of @flags in nilfs_dirty_inode() kernel-doc
comment is missing, and some functions had kernel-doc that
used a hash instead of a colon to separate the parameter
name from the one line description.

Fix them to remove some warnings found by running scripts/kernel-doc,
which is caused by using 'make W=1'.

fs/nilfs2/inode.c:73: warning: Function parameter or member 'inode' not
described in 'nilfs_get_block'
fs/nilfs2/inode.c:73: warning: Function parameter or member 'blkoff' not
described in 'nilfs_get_block'
fs/nilfs2/inode.c:73: warning: Function parameter or member 'bh_result'
not described in 'nilfs_get_block'
fs/nilfs2/inode.c:73: warning: Function parameter or member 'create' not
described in 'nilfs_get_block'
fs/nilfs2/inode.c:145: warning: Function parameter or member 'file' not
described in 'nilfs_readpage'
fs/nilfs2/inode.c:145: warning: Function parameter or member 'page' not
described in 'nilfs_readpage'
fs/nilfs2/inode.c:968: warning: Function parameter or member 'flags' not
described in 'nilfs_dirty_inode'

Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Signed-off-by: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---

--Changes in v2:
Modified description of @flags in nilfs_dirty_inode() kernel-doc comment

 fs/nilfs2/inode.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 476a4a649f38..ae0afc6a30bb 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -59,10 +59,10 @@ void nilfs_inode_sub_blocks(struct inode *inode, int n)
 
 /**
  * nilfs_get_block() - get a file block on the filesystem (callback function)
- * @inode - inode struct of the target file
- * @blkoff - file block number
- * @bh_result - buffer head to be mapped on
- * @create - indicate whether allocating the block or not when it has not
+ * @inode: inode struct of the target file
+ * @blkoff: file block number
+ * @bh_result: buffer head to be mapped on
+ * @create: indicate whether allocating the block or not when it has not
  *      been allocated yet.
  *
  * This function does not issue actual read request of the specified data
@@ -138,8 +138,8 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
 /**
  * nilfs_readpage() - implement readpage() method of nilfs_aops {}
  * address_space_operations.
- * @file - file struct of the file to be read
- * @page - the page to be read
+ * @file: file struct of the file to be read
+ * @page: the page to be read
  */
 static int nilfs_readpage(struct file *file, struct page *page)
 {
@@ -957,6 +957,7 @@ int __nilfs_mark_inode_dirty(struct inode *inode, int flags)
 /**
  * nilfs_dirty_inode - reflect changes on given inode to an inode block.
  * @inode: inode of the file to be registered.
+ * @flags: flags to determine the dirty state of the inode
  *
  * nilfs_dirty_inode() loads a inode block containing the specified
  * @inode and copies data from a nilfs_inode to a corresponding inode
-- 
2.20.1.7.g153144c

