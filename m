From: Marco Stornelli <marco.stornelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 18/21] nilfs2: drop vmtruncate
Date: Fri, 31 Aug 2012 16:02:03 +0200
Message-ID: <5040C3DB.7090000@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        bh=s49pMBuopLtLEaDqRioRPnKJWscjurmrqIq3kFRnw4I=;
        b=hJFSVMIYgF7GvICtAN4QadtKEePESVDE/3K3hYeiOvELxI3CtPGvBI9Ga6AUODaf5E
         MqvTLdpgRBN83pWnImXtkb/tdruSPnYROs8/TwSEUxtgbPCHR2RikBqpUL7zlCtcecJQ
         ufJ6rRobTEkPUm68Pzc/EDmUF8ISqwIvF7+JQ9tFDl4KeyTv9A9QIzk2mMH0XWdPXW/V
         +cSjH7mLaV7bQ3PKGHCvNl2hVH6r5aIZZwTtL2r9pgm94NS0AGSaOb6SEEWYllauZHIz
         Opp+FTmKfdsQd2iwyScdbrtMb7oeMjOQI5zWxvul+z3/uVAoHkPi5qkjaiy0cR07utSW
         R3nw==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/file.c     |    1 -
 fs/nilfs2/inode.c    |   18 +++++++++++++-----
 fs/nilfs2/recovery.c |    7 +++++--
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index a4d56ac..543554b 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -166,7 +166,6 @@ const struct file_operations nilfs_file_operations = {
 };
 
 const struct inode_operations nilfs_file_inode_operations = {
-	.truncate	= nilfs_truncate,
 	.setattr	= nilfs_setattr,
 	.permission     = nilfs_permission,
 	.fiemap		= nilfs_fiemap,
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 6e2c3db..1f48ee8 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -228,8 +228,11 @@ static int nilfs_write_begin(struct file *file, struct address_space *mapping,
 				nilfs_get_block);
 	if (unlikely(err)) {
 		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
+		if ((pos + len > isize) &&
+			inode_newsize_ok(mapping->host, isize) == 0) {
+			truncate_setsize(mapping->host, isize);
+			nilfs_truncate(mapping->host);
+		}
 
 		nilfs_transaction_abort(inode->i_sb);
 	}
@@ -277,8 +280,10 @@ nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 		loff_t isize = i_size_read(inode);
 		loff_t end = offset + iov_length(iov, nr_segs);
 
-		if (end > isize)
-			vmtruncate(inode, isize);
+		if ((end > isize) && inode_newsize_ok(inode, isize) == 0) {
+			truncate_setsize(inode, isize);
+			nilfs_truncate(inode);
+		}
 	}
 
 	return size;
@@ -787,9 +792,12 @@ int nilfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	    iattr->ia_size != i_size_read(inode)) {
 		inode_dio_wait(inode);
 
-		err = vmtruncate(inode, iattr->ia_size);
+		err = inode_newsize_ok(inode, iattr->ia_size);
 		if (unlikely(err))
 			goto out_err;
+
+		truncate_setsize(inode, iattr->ia_size);
+		nilfs_truncate(inode);
 	}
 
 	setattr_copy(inode, iattr);
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index f1626f5..cec215e 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -526,8 +526,11 @@ static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
 					0, &page, nilfs_get_block);
 		if (unlikely(err)) {
 			loff_t isize = inode->i_size;
-			if (pos + blocksize > isize)
-				vmtruncate(inode, isize);
+			if ((pos + blocksize > isize) &&
+				inode_newsize_ok(inode, isize) == 0) {
+				truncate_setsize(inode, isize);
+				nilfs_truncate(inode);
+			}
 			goto failed_inode;
 		}
 
-- 
1.7.3.4
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
