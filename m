From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCHv2 1/3] nilfs2: clarify byte offset in super block format
Date: Thu, 22 Jul 2010 03:22:18 +0900
Message-ID: <1279736540-21556-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1279736540-21556-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1279736540-21556-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This inserts comments indicating hexadecimal offset in declaration of
nilfs_super_block structure so that people can know offset of its
fields without counting from the head.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 include/linux/nilfs2_fs.h |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 8c2c611..cc3465e 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -160,7 +160,7 @@ struct nilfs_super_root {
  * struct nilfs_super_block - structure of super block on disk
  */
 struct nilfs_super_block {
-	__le32	s_rev_level;		/* Revision level */
+/*00*/	__le32	s_rev_level;		/* Revision level */
 	__le16	s_minor_rev_level;	/* minor revision level */
 	__le16	s_magic;		/* Magic signature */
 
@@ -169,47 +169,47 @@ struct nilfs_super_block {
 					   is excluded. */
 	__le16  s_flags;		/* flags */
 	__le32  s_crc_seed;		/* Seed value of CRC calculation */
-	__le32	s_sum;			/* Check sum of super block */
+/*10*/	__le32	s_sum;			/* Check sum of super block */
 
 	__le32	s_log_block_size;	/* Block size represented as follows
 					   blocksize =
 					       1 << (s_log_block_size + 10) */
 	__le64  s_nsegments;		/* Number of segments in filesystem */
-	__le64  s_dev_size;		/* block device size in bytes */
+/*20*/	__le64  s_dev_size;		/* block device size in bytes */
 	__le64	s_first_data_block;	/* 1st seg disk block number */
-	__le32  s_blocks_per_segment;   /* number of blocks per full segment */
+/*30*/	__le32  s_blocks_per_segment;   /* number of blocks per full segment */
 	__le32	s_r_segments_percentage; /* Reserved segments percentage */
 
 	__le64  s_last_cno;		/* Last checkpoint number */
-	__le64  s_last_pseg;		/* disk block addr pseg written last */
+/*40*/	__le64  s_last_pseg;		/* disk block addr pseg written last */
 	__le64  s_last_seq;             /* seq. number of seg written last */
-	__le64	s_free_blocks_count;	/* Free blocks count */
+/*50*/	__le64	s_free_blocks_count;	/* Free blocks count */
 
 	__le64	s_ctime;		/* Creation time (execution time of
 					   newfs) */
-	__le64	s_mtime;		/* Mount time */
+/*60*/	__le64	s_mtime;		/* Mount time */
 	__le64	s_wtime;		/* Write time */
-	__le16	s_mnt_count;		/* Mount count */
+/*70*/	__le16	s_mnt_count;		/* Mount count */
 	__le16	s_max_mnt_count;	/* Maximal mount count */
 	__le16	s_state;		/* File system state */
 	__le16	s_errors;		/* Behaviour when detecting errors */
 	__le64	s_lastcheck;		/* time of last check */
 
-	__le32	s_checkinterval;	/* max. time between checks */
+/*80*/	__le32	s_checkinterval;	/* max. time between checks */
 	__le32	s_creator_os;		/* OS */
 	__le16	s_def_resuid;		/* Default uid for reserved blocks */
 	__le16	s_def_resgid;		/* Default gid for reserved blocks */
 	__le32	s_first_ino;		/* First non-reserved inode */
 
-	__le16  s_inode_size;		/* Size of an inode */
+/*90*/	__le16  s_inode_size;		/* Size of an inode */
 	__le16  s_dat_entry_size;       /* Size of a dat entry */
 	__le16  s_checkpoint_size;      /* Size of a checkpoint */
 	__le16	s_segment_usage_size;	/* Size of a segment usage */
 
-	__u8	s_uuid[16];		/* 128-bit uuid for volume */
-	char	s_volume_name[80];	/* volume name */
+/*98*/	__u8	s_uuid[16];		/* 128-bit uuid for volume */
+/*A8*/	char	s_volume_name[80];	/* volume name */
 
-	__le32  s_c_interval;           /* Commit interval of segment */
+/*F8*/	__le32  s_c_interval;           /* Commit interval of segment */
 	__le32  s_c_block_max;          /* Threshold of data amount for
 					   the segment construction */
 	__u32	s_reserved[192];	/* padding to the end of the block */
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
