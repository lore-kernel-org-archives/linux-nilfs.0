From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: fix incorrect masking of permission flags for symlinks
Date: Thu, 23 Jun 2022 17:54:01 +0900
Message-ID: <1655974441-5612-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=CgKFu42pVNbutALOPAyFG9CSppEVlH9cLVPLNYXxSDc=;
        b=TgWNIU0sVyugoVfuKJctmkNZR5g0jvh0wU5ej56Yfj8LnJBA9GMeWdwdhUSMYSgoXs
         vQDKVqw/SQcLjxA6/cIeb94CZs1VsmNQ6GwJB6IJv0D225ciqF3j0ah5Dwf5EqDSVesa
         CtyH9WAqCOdvoJk/R+N1Skk10gECKlAb6cb3lXNW1C/t3+kk7Y+WxD7UhsX5Rg34YvAD
         ka98Ju44pZ9q5Uyu484L4Bu1HrO6aFYSqCJ4MbLOeuNZRKcysCfXRBVL6aNmIBRT68eB
         ofV6E8LNIUBAeYDxaouMz9r1DAJmdqTBJA/as3Zg5s1BJrN41K9F11mCIQGtkPe6QYno
         lVDQ==
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

The permission flags of newly created symlinks are wrongly dropped on
nilfs2 with the current umask value even though symlinks should have
777 (rwxrwxrwx) permissions:

 $ umask
 0022
 $ touch file && ln -s file symlink; ls -l file symlink
 -rw-r--r--. 1 root root 0 Jun 23 16:29 file
 lrwxr-xr-x. 1 root root 4 Jun 23 16:29 symlink -> file

This fixes the bug by inserting a missing check that excludes
symlinks.

Reported-by: Tommy Pettersson <ptp-SamgB31n2u5IcsJQ0EH25Q@public.gmane.org>
Reported-by: Ciprian Craciun <ciprian.craciun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/nilfs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 1344f7d475d3..aecda4fc95f5 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -198,6 +198,9 @@ static inline int nilfs_acl_chmod(struct inode *inode)
 
 static inline int nilfs_init_acl(struct inode *inode, struct inode *dir)
 {
+	if (S_ISLNK(inode->i_mode))
+		return 0;
+
 	inode->i_mode &= ~current_umask();
 	return 0;
 }
-- 
1.8.3.1

