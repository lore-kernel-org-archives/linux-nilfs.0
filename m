From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: fix style problems in nilfs2_fs.h
Date: Mon, 26 Apr 2010 02:57:53 +0900
Message-ID: <1272218273-9482-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This kills the following checkpatch warnings:

WARNING: please, no space before tabs
+^I__le32^Is_first_ino; ^I^I/* First non-reserved inode */$

WARNING: please, no space before tabs
+^I__le16  s_inode_size; ^I^I/* Size of an inode */$

WARNING: please, no space before tabs
+^Ichar^Is_volume_name[16]; ^I/* volume name */$

WARNING: please, no space before tabs
+^Ichar^Is_last_mounted[64]; ^I/* directory where last mounted */$

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 include/linux/nilfs2_fs.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 478ee34..f960e1d 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -199,16 +199,16 @@ struct nilfs_super_block {
 	__le32	s_creator_os;		/* OS */
 	__le16	s_def_resuid;		/* Default uid for reserved blocks */
 	__le16	s_def_resgid;		/* Default gid for reserved blocks */
-	__le32	s_first_ino; 		/* First non-reserved inode */
+	__le32	s_first_ino;		/* First non-reserved inode */
 
-	__le16  s_inode_size; 		/* Size of an inode */
+	__le16  s_inode_size;		/* Size of an inode */
 	__le16  s_dat_entry_size;       /* Size of a dat entry */
 	__le16  s_checkpoint_size;      /* Size of a checkpoint */
 	__le16	s_segment_usage_size;	/* Size of a segment usage */
 
 	__u8	s_uuid[16];		/* 128-bit uuid for volume */
-	char	s_volume_name[16]; 	/* volume name */
-	char	s_last_mounted[64]; 	/* directory where last mounted */
+	char	s_volume_name[16];	/* volume name */
+	char	s_last_mounted[64];	/* directory where last mounted */
 
 	__le32  s_c_interval;           /* Commit interval of segment */
 	__le32  s_c_block_max;          /* Threshold of data amount for
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
