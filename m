From: Marco Stornelli <marco.stornelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 17/21] nilfs2: drop vmtruncate
Date: Sat, 03 Nov 2012 10:30:59 +0100
Message-ID: <5094E453.9030209@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        bh=BLRx22z6WaUH47U1/xFTv2mVmBvf3jDc7OkkFCsAL+c=;
        b=vXEhdlpmVQokv14n8XAunkL6puO7+K7KZVS6X6DkzAL8B5sX7oRE8lBeBwpj0+m5nr
         TseAdjFuJ+hgFfmqtJYakwQdRNUDT8fqjpMA5cWbmhvmlVqtSBxrh9zknpx6YixylDTE
         3xqoJk9cASQ7p+FRmrK2PF7ucBWNuS5stq6L1jaImRi0i8DVbazF9QBBUlkuF2pDxzk+
         K023siJ0E327drtUPCuaj18KjZNFt9kitFGuH7MKy6K0Ztqp8fU9SKk3kXqwDdYYANH9
         7ybpUboZvgwVjFeY7vZ6rJ9YnRvBxenT4B++C1/5mHwzVAW35HV4ndhyzKARg7/r9qmV
         FVJA==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/file.c     |    1 -
 fs/nilfs2/inode.c    |   24 +++++++++++++++---------
 fs/nilfs2/nilfs.h    |    1 +
 fs/nilfs2/recovery.c |    3 ++-
 4 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 16f35f7..6194688 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -167,7 +167,6 @@ const struct file_operations nilfs_file_operations = {
 };
 
 const struct inode_operations nilfs_file_inode_operations = {
-	.truncate	= nilfs_truncate,
 	.setattr	= nilfs_setattr,
 	.permission     = nilfs_permission,
 	.fiemap		= nilfs_fiemap,
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 4d31d2c..6b49f14 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -213,6 +213,16 @@ static int nilfs_set_page_dirty(struct page *page)
 	return ret;
 }
 
+void nilfs_write_failed(struct address_space *mapping, loff_t to)
+{
+	struct inode *inode = mapping->host;
+
+	if (to > inode->i_size) {
+		truncate_pagecache(inode, to, inode->i_size);
+		nilfs_truncate(inode);
+	}
+}
+
 static int nilfs_write_begin(struct file *file, struct address_space *mapping,
 			     loff_t pos, unsigned len, unsigned flags,
 			     struct page **pagep, void **fsdata)
@@ -227,10 +237,7 @@ static int nilfs_write_begin(struct file *file, struct address_space *mapping,
 	err = block_write_begin(mapping, pos, len, flags, pagep,
 				nilfs_get_block);
 	if (unlikely(err)) {
-		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
-
+		nilfs_write_failed(mapping, pos + len);
 		nilfs_transaction_abort(inode->i_sb);
 	}
 	return err;
@@ -259,6 +266,7 @@ nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 		loff_t offset, unsigned long nr_segs)
 {
 	struct file *file = iocb->ki_filp;
+	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = file->f_mapping->host;
 	ssize_t size;
 
@@ -278,7 +286,7 @@ nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 		loff_t end = offset + iov_length(iov, nr_segs);
 
 		if (end > isize)
-			vmtruncate(inode, isize);
+			nilfs_write_failed(mapping, end);
 	}
 
 	return size;
@@ -786,10 +794,8 @@ int nilfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	if ((iattr->ia_valid & ATTR_SIZE) &&
 	    iattr->ia_size != i_size_read(inode)) {
 		inode_dio_wait(inode);
-
-		err = vmtruncate(inode, iattr->ia_size);
-		if (unlikely(err))
-			goto out_err;
+		truncate_setsize(inode, iattr->ia_size);
+		nilfs_truncate(inode);
 	}
 
 	setattr_copy(inode, iattr);
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 74cece8..9bc72de 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -277,6 +277,7 @@ extern void nilfs_update_inode(struct inode *, struct buffer_head *);
 extern void nilfs_truncate(struct inode *);
 extern void nilfs_evict_inode(struct inode *);
 extern int nilfs_setattr(struct dentry *, struct iattr *);
+extern void nilfs_write_failed(struct address_space *mapping, loff_t to);
 int nilfs_permission(struct inode *inode, int mask);
 int nilfs_load_inode_block(struct inode *inode, struct buffer_head **pbh);
 extern int nilfs_inode_dirty(struct inode *);
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index f1626f5..ff00a0b 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -527,7 +527,8 @@ static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
 		if (unlikely(err)) {
 			loff_t isize = inode->i_size;
 			if (pos + blocksize > isize)
-				vmtruncate(inode, isize);
+				nilfs_write_failed(inode->i_mapping,
+							pos + blocksize);
 			goto failed_inode;
 		}
 
-- 
1.7.3.4
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
