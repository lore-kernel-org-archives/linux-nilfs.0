From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: fix use-after-free bug of struct nilfs_root
Date: Tue,  4 Oct 2022 00:05:19 +0900
Message-ID: <20221003150519.39789-1-konishi.ryusuke@gmail.com>
References: <000000000000219dcd05e9f95ed9@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ezoaBJIqRF7gg3OoVAkSemBRNoXtolfSSBzIMhoaSGI=;
        b=SZHyb4Rjp36YHYykDDQ3ZcOlnLFNVIk5WEX2UQcpDrbLzDZTOlE+aKtkDmELWkbcYb
         BqGGlm2lr1FNI0XT+ygAmxUjabea4DI4P5MX5zDS9nVrbVFm75vtptTfRldu0yWqJ4r4
         MhvFEjd0KM+WV1m1dDEs8QqZUIzhFoiGuymTKyH0eWDh3Aoy7qD7v7WVZ1FXAy9T8Las
         t8NzxNyc0/icf2kZAkhPQa3Ip49+kme0YAzNlH+/MPW4GQkkf1UZexR1sbT7IK6KzG1L
         Kb+p0M7BQTQuTS7ipBPGQxu9K2sS12jlTRbmqQZ8JwAPcRGljSmOW0yOKDqsNNFFB9NY
         rlJg==
In-Reply-To: <000000000000219dcd05e9f95ed9-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, syzbot <syzbot+b8c672b0e22615c80fe0-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

If the beginning of the inode bitmap area is corrupted on disk, an
inode with the same inode number as the root inode can be allocated
and fail soon after.  In this case, the subsequent call to
nilfs_clear_inode() on that bogus root inode will wrongly decrement
the reference counter of struct nilfs_root, and this will erroneously
free struct nilfs_root, causing kernel oopses.

This fixes the problem by changing nilfs_new_inode() to skip reserved
inode numbers while repairing the inode bitmap.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: syzbot+b8c672b0e22615c80fe0-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Reported-by: Khalid Masum <khalid.masum.92-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 fs/nilfs2/inode.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 67f63cfeade5..b074144f6f83 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -328,6 +328,7 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	struct inode *inode;
 	struct nilfs_inode_info *ii;
 	struct nilfs_root *root;
+	struct buffer_head *bh;
 	int err = -ENOMEM;
 	ino_t ino;
 
@@ -343,11 +344,25 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	ii->i_state = BIT(NILFS_I_NEW);
 	ii->i_root = root;
 
-	err = nilfs_ifile_create_inode(root->ifile, &ino, &ii->i_bh);
+	err = nilfs_ifile_create_inode(root->ifile, &ino, &bh);
 	if (unlikely(err))
 		goto failed_ifile_create_inode;
 	/* reference count of i_bh inherits from nilfs_mdt_read_block() */
 
+	if (unlikely(ino < NILFS_USER_INO)) {
+		nilfs_warn(sb,
+			   "inode bitmap is inconsistent for reserved inodes");
+		do {
+			brelse(bh);
+			err = nilfs_ifile_create_inode(root->ifile, &ino, &bh);
+			if (unlikely(err))
+				goto failed_ifile_create_inode;
+		} while (ino < NILFS_USER_INO);
+
+		nilfs_info(sb, "repaired inode bitmap for reserved inodes");
+	}
+	ii->i_bh = bh;
+
 	atomic64_inc(&root->inodes_count);
 	inode_init_owner(&init_user_ns, inode, dir, mode);
 	inode->i_ino = ino;
-- 
2.34.1

