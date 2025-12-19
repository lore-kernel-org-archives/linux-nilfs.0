Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6F233B6D0
	for <linux-nilfs@vger.kernel.org>; Fri, 19 Dec 2025 18:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766167606; cv=none; b=flQybtGLXmPJS8tsbapPc8139QD+96cdk+NI4aKs9dHGbH71nC12tpdY1V30lXDrYSpWwNU4EOwhEtPmS3vXRteS98948mgGjS9KmglCchmkAcSD3M8+LaXeBJt+I9v5p0EqKvPc5G04Z1wVlPxeA6qvIYz+pOMIVSGL2ILzhNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766167606; c=relaxed/simple;
	bh=SR3AaqbdMw9Oe2F4eEbEQZNViyFTD4hfWmMV0M9Qnk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1y/Jjz+RvO5voSwi6t7GDbohcrt88hbhQ717wCwe4QdhZFKjGK7qnd1gU94uu9Fg1PfIjfJgFuSDRc+a2+makBj5qTYv0N67jc4DP8ESiiTqc9uN7DSwC6W1S+Pu5LHIxSfwcUlLYXreIlKpmVPNSfPtRo1VwVMEYhBlziljNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RXVmCEQL; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RXVmCEQL"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-34c21417781so2053293a91.3
        for <linux-nilfs@vger.kernel.org>; Fri, 19 Dec 2025 10:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766167601; x=1766772401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/76w433R6TTdeqL6SJFFWW2G8zOz6+MYiB5WjeQWsdk=;
        b=RXVmCEQLDiFhSShWtCAMAK/N5Kg+vxTLz78ochpDYvQwe+s6que4w+5vZlLVfuFK7N
         pQZzADH5yqJJL9Brsfw/FBbSkUiUkvg+viB7/TklYNBzS+Y8zMZ55YdXzlHnVb/DYdLF
         11oUM34D/h/EuuZFMwmzxzQ+SeQbi3q7NbEMNZ8eobC4IdPqhTrHSViOsGpG7HXF/V7O
         fwO2v6KH6ibjvsiFwjynAi57sQ7YnQof7Nyi5ARvYHvQgF0pDNQwM59J1DVDjnxByqCj
         NIgzRx8D7kY0iAFaYuoEADSukoK0vt2x61B0J04Zx+JJ1mBaCRFmUvGDltDZy/0iR9Sm
         tG4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766167601; x=1766772401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/76w433R6TTdeqL6SJFFWW2G8zOz6+MYiB5WjeQWsdk=;
        b=JQFfaNEFWiJLHDwSjgHSTz9NGmKwMOmKXmhHGsQu2xVGafpZa8KnCR18s9F/iBfqmP
         5MdlZS99k5oM9pKVnVvfGZBrQyAI5SJ3hsdxYmK/MrNGaCf+5C3mvELbasYAhIM0STr+
         N+2akuasuBOxDDvecl9J6/wfAcz5gj8PAQZsNdZwf5pZVgnPD6HryH5X43d7roKTq1DD
         DXi90fVvR9fpheldmjjV3L9GIAU++wDXArOgOQdbOUjfSESX0wJjGkPa3shJkyxc3K5h
         0gC4GVNJl3KjU6BrWrVestITWHwgLaD5cEb4knwJtdCsSovXkzRyav88H5tezFmbQh81
         WqoQ==
X-Gm-Message-State: AOJu0YwwYG+lZqxQdi/KxwAIEgJVYKTspHsVq2r5OIPaZSAGUspu6Iue
	dqTUOABQlKYNZqB3KY6PKcrNs4Cy9g152coVSfCS1lwYJCfT3007k9+u
X-Gm-Gg: AY/fxX4zjrKAkJ+2FEfp8XQtb1iCMqLf8K+xqnpo5Xbr2VQhzAMYmz8W2pry1jRaV54
	TlpJ3F/XMJK7g31yFQVti45VOU66IUvh9JmWS2frqkAa/jZiG/LiPHipwihHcH/kTKzL+QRKex1
	6ghWOp3HDUlnzFOOxDqfv50CgDEh51UYNLjbcuBytvwhdwpMEzYpAnVahups8YOx52kEfFB7/wQ
	Ehij6XL182xaN/CJ4DGfaXN5n7TZuEWQ5oQAce1XUaH1BRI4r3V7+VoNZwS3lZ2MIJk3v0b1X41
	me522QpZKigGOclN/cdPlPzJ7RZhS7jTKn4qaf9Fly5TSYRCBEPXv1g6kHoF7DIKTC8FU8+3Yld
	RIVWijJw3RH9hTul5B6F0av9lRI/cLHYBrSd47ykTSoezkt/azzgoDo4yw9sGWRkRVs8+s22GF1
	Y9LgW5p0WZDVVO89+wtyJj6H7OB7067wOFhdno1yiFWiJpRAoU4EZ+8mG7chBm4UGn/bxb1zg=
X-Google-Smtp-Source: AGHT+IFyz+71OiXiENLpaiOnaXfX5sdTj+ajSAtQB4Aj+7kXJEQr4WS2il7euZ5aYW6uka/XKtRHvQ==
X-Received: by 2002:a17:90b:560d:b0:343:e461:9022 with SMTP id 98e67ed59e1d1-34e921a3caamr3277447a91.24.1766167600961;
        Fri, 19 Dec 2025 10:06:40 -0800 (PST)
Received: from carrot.devel.local (i114-180-53-102.s42.a014.ap.plala.or.jp. [114.180.53.102])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7961c130sm2688468a12.3.2025.12.19.10.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 10:06:39 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] nilfs2: convert nilfs_super_block to kernel-doc
Date: Sat, 20 Dec 2025 03:04:26 +0900
Message-ID: <20251219180631.27554-3-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251219180631.27554-1-konishi.ryusuke@gmail.com>
References: <20251219180631.27554-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

Eliminate 40+ kernel-doc warnings in nilfs2_ondisk.h by converting
all of the struct member comments to kernel-doc comments.

Fix one misnamed struct member in nilfs_direct_node.

Object files before and after are the same size and content.

Examples of warnings:
Warning: include/uapi/linux/nilfs2_ondisk.h:202 struct member 's_rev_level'
 not described in 'nilfs_super_block'
Warning: include/uapi/linux/nilfs2_ondisk.h:202 struct member
 's_minor_rev_level' not described in 'nilfs_super_block'
Warning: include/uapi/linux/nilfs2_ondisk.h:202 struct member 's_magic'
 not described in 'nilfs_super_block'
Warning: include/uapi/linux/nilfs2_ondisk.h:202 struct member 's_bytes'
 not described in 'nilfs_super_block'
Warning: include/uapi/linux/nilfs2_ondisk.h:202 struct member 's_flags'
 not described in 'nilfs_super_block'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 include/uapi/linux/nilfs2_ondisk.h | 163 +++++++++++++++++------------
 1 file changed, 97 insertions(+), 66 deletions(-)

diff --git a/include/uapi/linux/nilfs2_ondisk.h b/include/uapi/linux/nilfs2_ondisk.h
index 3196cc44a002..b3442b16ff6a 100644
--- a/include/uapi/linux/nilfs2_ondisk.h
+++ b/include/uapi/linux/nilfs2_ondisk.h
@@ -133,73 +133,104 @@ struct nilfs_super_root {
 
 /**
  * struct nilfs_super_block - structure of super block on disk
+ * @s_rev_level:		Revision level
+ * @s_minor_rev_level:		minor revision level
+ * @s_magic:			Magic signature
+ * @s_bytes:			Bytes count of CRC calculation for
+ *				  this structure.  s_reserved is excluded.
+ * @s_flags:			flags
+ * @s_crc_seed:			Seed value of CRC calculation
+ * @s_sum:			Check sum of super block
+ * @s_log_block_size:		Block size represented as follows:
+ *				  blocksize = 1 << (s_log_block_size + 10)
+ * @s_nsegments:		Number of segments in filesystem
+ * @s_dev_size:			block device size in bytes
+ * @s_first_data_block:		1st seg disk block number
+ * @s_blocks_per_segment:	number of blocks per full segment
+ * @s_r_segments_percentage:	Reserved segments percentage
+ * @s_last_cno:			Last checkpoint number
+ * @s_last_pseg:		disk block addr pseg written last
+ * @s_last_seq:			seq. number of seg written last
+ * @s_free_blocks_count:	Free blocks count
+ * @s_ctime:			Creation time (execution time of newfs)
+ * @s_mtime:			Mount time
+ * @s_wtime:			Write time
+ * @s_mnt_count:		Mount count
+ * @s_max_mnt_count:		Maximal mount count
+ * @s_state:			File system state
+ * @s_errors:			Behaviour when detecting errors
+ * @s_lastcheck:		time of last check
+ * @s_checkinterval:		max. time between checks
+ * @s_creator_os:		OS
+ * @s_def_resuid:		Default uid for reserved blocks
+ * @s_def_resgid:		Default gid for reserved blocks
+ * @s_first_ino:		First non-reserved inode
+ * @s_inode_size:		Size of an inode
+ * @s_dat_entry_size:		Size of a dat entry
+ * @s_checkpoint_size:		Size of a checkpoint
+ * @s_segment_usage_size:	Size of a segment usage
+ * @s_uuid:			128-bit uuid for volume
+ * @s_volume_name:		volume name
+ * @s_c_interval:		Commit interval of segment
+ * @s_c_block_max:		Threshold of data amount for the
+ *				  segment construction
+ * @s_feature_compat:		Compatible feature set
+ * @s_feature_compat_ro:	Read-only compatible feature set
+ * @s_feature_incompat:		Incompatible feature set
+ * @s_reserved:			padding to the end of the block
  */
 struct nilfs_super_block {
-/*00*/	__le32	s_rev_level;		/* Revision level */
-	__le16	s_minor_rev_level;	/* minor revision level */
-	__le16	s_magic;		/* Magic signature */
-
-	__le16  s_bytes;		/*
-					 * Bytes count of CRC calculation
-					 * for this structure. s_reserved
-					 * is excluded.
-					 */
-	__le16  s_flags;		/* flags */
-	__le32  s_crc_seed;		/* Seed value of CRC calculation */
-/*10*/	__le32	s_sum;			/* Check sum of super block */
-
-	__le32	s_log_block_size;	/*
-					 * Block size represented as follows
-					 * blocksize =
-					 *     1 << (s_log_block_size + 10)
-					 */
-	__le64  s_nsegments;		/* Number of segments in filesystem */
-/*20*/	__le64  s_dev_size;		/* block device size in bytes */
-	__le64	s_first_data_block;	/* 1st seg disk block number */
-/*30*/	__le32  s_blocks_per_segment;   /* number of blocks per full segment */
-	__le32	s_r_segments_percentage; /* Reserved segments percentage */
-
-	__le64  s_last_cno;		/* Last checkpoint number */
-/*40*/	__le64  s_last_pseg;		/* disk block addr pseg written last */
-	__le64  s_last_seq;             /* seq. number of seg written last */
-/*50*/	__le64	s_free_blocks_count;	/* Free blocks count */
-
-	__le64	s_ctime;		/*
-					 * Creation time (execution time of
-					 * newfs)
-					 */
-/*60*/	__le64	s_mtime;		/* Mount time */
-	__le64	s_wtime;		/* Write time */
-/*70*/	__le16	s_mnt_count;		/* Mount count */
-	__le16	s_max_mnt_count;	/* Maximal mount count */
-	__le16	s_state;		/* File system state */
-	__le16	s_errors;		/* Behaviour when detecting errors */
-	__le64	s_lastcheck;		/* time of last check */
-
-/*80*/	__le32	s_checkinterval;	/* max. time between checks */
-	__le32	s_creator_os;		/* OS */
-	__le16	s_def_resuid;		/* Default uid for reserved blocks */
-	__le16	s_def_resgid;		/* Default gid for reserved blocks */
-	__le32	s_first_ino;		/* First non-reserved inode */
-
-/*90*/	__le16  s_inode_size;		/* Size of an inode */
-	__le16  s_dat_entry_size;       /* Size of a dat entry */
-	__le16  s_checkpoint_size;      /* Size of a checkpoint */
-	__le16	s_segment_usage_size;	/* Size of a segment usage */
-
-/*98*/	__u8	s_uuid[16];		/* 128-bit uuid for volume */
-/*A8*/	char	s_volume_name[80]	/* volume name */
-			__kernel_nonstring;
-
-/*F8*/	__le32  s_c_interval;           /* Commit interval of segment */
-	__le32  s_c_block_max;          /*
-					 * Threshold of data amount for
-					 * the segment construction
-					 */
-/*100*/	__le64  s_feature_compat;	/* Compatible feature set */
-	__le64  s_feature_compat_ro;	/* Read-only compatible feature set */
-	__le64  s_feature_incompat;	/* Incompatible feature set */
-	__u32	s_reserved[186];	/* padding to the end of the block */
+/*00*/	__le32	s_rev_level;
+	__le16	s_minor_rev_level;
+	__le16	s_magic;
+
+	__le16  s_bytes;
+	__le16  s_flags;
+	__le32  s_crc_seed;
+/*10*/	__le32	s_sum;
+
+	__le32	s_log_block_size;
+	__le64  s_nsegments;
+/*20*/	__le64  s_dev_size;
+	__le64	s_first_data_block;
+/*30*/	__le32  s_blocks_per_segment;
+	__le32	s_r_segments_percentage;
+
+	__le64  s_last_cno;
+/*40*/	__le64  s_last_pseg;
+	__le64  s_last_seq;
+/*50*/	__le64	s_free_blocks_count;
+
+	__le64	s_ctime;
+/*60*/	__le64	s_mtime;
+	__le64	s_wtime;
+/*70*/	__le16	s_mnt_count;
+	__le16	s_max_mnt_count;
+	__le16	s_state;
+	__le16	s_errors;
+	__le64	s_lastcheck;
+
+/*80*/	__le32	s_checkinterval;
+	__le32	s_creator_os;
+	__le16	s_def_resuid;
+	__le16	s_def_resgid;
+	__le32	s_first_ino;
+
+/*90*/	__le16  s_inode_size;
+	__le16  s_dat_entry_size;
+	__le16  s_checkpoint_size;
+	__le16	s_segment_usage_size;
+
+/*98*/	__u8	s_uuid[16];
+/*A8*/	char	s_volume_name[80]	__kernel_nonstring;
+
+/*F8*/	__le32  s_c_interval;
+	__le32  s_c_block_max;
+
+/*100*/	__le64  s_feature_compat;
+	__le64  s_feature_compat_ro;
+	__le64  s_feature_incompat;
+	__u32	s_reserved[186];
 };
 
 /*
@@ -449,7 +480,7 @@ struct nilfs_btree_node {
 /**
  * struct nilfs_direct_node - header of built-in bmap array
  * @dn_flags: flags
- * @dn_pad: padding
+ * @pad: padding
  */
 struct nilfs_direct_node {
 	__u8 dn_flags;
-- 
2.43.0

