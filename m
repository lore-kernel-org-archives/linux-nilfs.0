From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: make splice write available again
Date: Mon,  8 Feb 2021 20:35:01 +0900
Message-ID: <1612784101-14353-1-git-send-email-konishi.ryusuke@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3Ph8qsKmXSqFKVv7QVwyNev8raeZwIr8Rm9tqiLL8AY=;
        b=TG/s4IiQ6uTzTy6DW5yj2V2Pesqv+sw6iXbp4YQ8u8xFKYjsyjz2HG5KdO5Sn5+Omi
         BMRSf6BaaJ93P706w/iDvr1RZd7WtcadR49k+ST7NgNQxiu0DHvZi0ATO6YzztkkV3T2
         JPn0Dyaqp5w2UlutPpp59wI+9WZpcw2uhuJSXsmzucQyO1StFZbQs6vCBjevyePMOpID
         zfwzwcJ6RAVBZTNa4tCZ74b+Dg7w3z/t4t77DtgQmY8QQNwkdfRdU8RBhg0UbXbXgJ4r
         TEZEgOi0tOQjZBMqMkzvo6ywJ4xVrqvaINd8KsaITNa5+hUxIh6Qpn1RdVMNrhfe70LE
         Bxrg==
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Joachim Henke <joachim.henke-kyawv7ubMNaakBO8gow8eQ@public.gmane.org>

Since 5.10, splice() or sendfile() to NILFS2 return EINVAL. This was
caused by commit 36e2c7421f02 ("fs: don't allow splice read/write
without explicit ops").

This patch initializes the splice_write field in file_operations, like
most file systems do, to restore the functionality.

Signed-off-by: Joachim Henke <joachim.henke-kyawv7ubMNaakBO8gow8eQ@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 5.10+
---
 fs/nilfs2/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 64bc81363c6c..e1bd592ce700 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -141,6 +141,7 @@ static int nilfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	/* .release	= nilfs_release_file, */
 	.fsync		= nilfs_sync_file,
 	.splice_read	= generic_file_splice_read,
+	.splice_write   = iter_file_splice_write,
 };
 
 const struct inode_operations nilfs_file_inode_operations = {
-- 
1.8.3.1

