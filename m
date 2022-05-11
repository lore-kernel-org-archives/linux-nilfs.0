From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: Fix some kernel-doc comments
Date: Wed, 11 May 2022 22:38:36 +0900
Message-ID: <1652276316-7791-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=jsRV8EvMOtUfJsgLKEp/CDjMrcTGRjbK7SqrPRT4roE=;
        b=hqvlJxq9PAR5+noe0CxheCXcFPfVtVGDqaiEGYE94YokujbrehQTT7oHQ74ftn3YaA
         7yHJwGUtm76af2ozPbSrExtHWwQXisy2UFTIGtQ3yn6PmKZ/yUWONEt8YZz6FFevGwf0
         AI3+I1mE51loi5LF4VH2qJxFHmz1ZiI+YgrQTmqPOEoJxTje7cC54RLotlocuQoi95C8
         vxchaX4SaqvDP5cuB6MKfCR8HCu82At6+MEBYocGMUAXMePgdPPBF7oYmR/XNQCAIQDn
         SCpVc7epYS8pZhvVKlw/dBDiMcqkzUGqv4L+ae/+E6hqqZ1WU3/CdJVMPnotLAN9OqM7
         ZUXQ==
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

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

Link: https://lkml.kernel.org/r/20220324024215.63479-1-yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org
Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Signed-off-by: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/inode.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 6045cea21f52..6a00cf324cbd 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -63,10 +63,10 @@ void nilfs_inode_sub_blocks(struct inode *inode, int n)
 
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
@@ -142,8 +142,8 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
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
@@ -1088,6 +1088,7 @@ int __nilfs_mark_inode_dirty(struct inode *inode, int flags)
 /**
  * nilfs_dirty_inode - reflect changes on given inode to an inode block.
  * @inode: inode of the file to be registered.
+ * @flags: flags to determine the dirty state of the inode
  *
  * nilfs_dirty_inode() loads a inode block containing the specified
  * @inode and copies data from a nilfs_inode to a corresponding inode
-- 
1.8.3.1

