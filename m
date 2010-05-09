From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: use huge_encode_dev/huge_decode_dev
Date: Sun,  9 May 2010 16:27:13 +0900
Message-ID: <1273390033-27298-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This replaces uses of new_encode_dev/new_decode_dev with their 64-bit
counterparts, huge_encode_dev/huge_decode_dev respectively.

This is just for clarification and has no impact on the disk format.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 0957b58..5e226d4 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -451,7 +451,7 @@ static int __nilfs_read_inode(struct super_block *sb, unsigned long ino,
 		inode->i_op = &nilfs_special_inode_operations;
 		init_special_inode(
 			inode, inode->i_mode,
-			new_decode_dev(le64_to_cpu(raw_inode->i_device_code)));
+			huge_decode_dev(le64_to_cpu(raw_inode->i_device_code)));
 	}
 	nilfs_ifile_unmap_inode(sbi->s_ifile, ino, bh);
 	brelse(bh);
@@ -511,7 +511,7 @@ void nilfs_write_inode_common(struct inode *inode,
 		nilfs_bmap_write(ii->i_bmap, raw_inode);
 	else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
 		raw_inode->i_device_code =
-			cpu_to_le64(new_encode_dev(inode->i_rdev));
+			cpu_to_le64(huge_encode_dev(inode->i_rdev));
 	/* When extending inode, nilfs->ns_inode_size should be checked
 	   for substitutions of appended fields */
 }
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
