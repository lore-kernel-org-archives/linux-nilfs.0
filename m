Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C552E0B71
	for <linux-nilfs@vger.kernel.org>; Thu, 19 Feb 2026 20:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771533850; cv=none; b=uKcU2bbp7fqy6fEcOAuMFBVcibUE/rg2uKinnA2HEp45D3rSNGPot1pdGbRgLy+70aSC4GqgLvv3+VcVzEXCd0vsIp4ipY8/9VA97ABb9N7wXxpDg44KPaHG07FB//aycB7QaHcX5qrRlnrpsv+dGVrJWc6+J+MoLNyhPFwi7nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771533850; c=relaxed/simple;
	bh=qmyLQXVvQ0eDhB0y2+Nvh71DHMZrJ8fY4ZFdlPK/Vxc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KetWsDwtXnucA1thdi5OnMCNamHDPPiozJxHftnEUCJ4f17rbc9yi1nJ4NVgceXoYc7bJsowpLwG/1LPlpNIEg5y3x600FUk7veCQOnLBjiBoBGdHlVI9CfWBtW2Sdzm1SdqTOs0yPeTMslYP0K6dbKTRD+oxkTsBC94x/3jfXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=eXASMBUG; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="eXASMBUG"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-46391f4c1f9so867463b6e.0
        for <linux-nilfs@vger.kernel.org>; Thu, 19 Feb 2026 12:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1771533847; x=1772138647; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9TILSzKrzY8Grxofyfoajx7wPzE8mWVXVIM94zwxYSE=;
        b=eXASMBUGjqsmjCVTGDSXbJ5shL7AVyegncJMQdV/3vVjBlLHFnM1G73OfHcViywrR0
         hwrYey1pc8ppyrGS8ML5Cxmhs+cdXoDrl7dPUYYwnM2tthjSBnaXzJgHPoXWW80QZfLV
         vvj/ooayA7usFdgl6S8MLmnsoylQsT0zOPXSqJfRdbm/CGQ1wvmXpiZt5DyGHhagRj8I
         YB6LQZHVk/075dlYlTZgeu8FBOOnAnveKIG1CZWD9I2KnX1u14hllxa+6RvmYD94Zjpi
         45t1L9Jmr0KjWmUEaQA1X6LrqrGFjnLOMpLQnLEZal96mSY+bwmUJl7byQ5VrtcqrfTZ
         pDvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771533847; x=1772138647;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9TILSzKrzY8Grxofyfoajx7wPzE8mWVXVIM94zwxYSE=;
        b=En4nvfedIXhdg2YDPqSGO0plMhDGMDwwzZ2jLXbWkYqc/yqVJxi9Pg88+bkkJ4OTYr
         1KtM5AaFIIGbsCLmfHIxrHME7AXIQXiq7qKjjmFYQOpUKCoXNqOuXEdzObSlcWJMU7nB
         DROYKjhMT32EVrPX/brNXgAyO4HiZ1DRdfV4dRbBpynYYPClxqprMa3TnHzQHvhyoZfN
         xFo6yCHrl9EjpeXbg2wKCHaXtmZFqEOrr3h+5Mu+h8FGR65c5mJjrp9ENL7G5Up4CYlg
         agPg6lg78kyzHIwK/+CBXnzVnKu/dxdO32YVLluaM1SC7ObMn6H8pShUtqLGlZgEcL3r
         R/sA==
X-Forwarded-Encrypted: i=1; AJvYcCVuc2kpqLar60Iu6U1PB56B8Ullcp7OVC26PXK/74zwbzMQG2XsyyzVypNm+GfDqzYbG8CDu1tU61ZBoA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwhfYlfbySDbksvn7R/0QKfXo1bIm5DTXpRxviw7vrfh1goIPn8
	xZBLnK3KDz1UH6wAVUHHCPUcOqYaJjw5tfGpaXFpdnhNlxIdMmziOSbOcjZEe4S1QB+aWiy7vwh
	1VwMyHIQ=
X-Gm-Gg: AZuq6aKtrrOa+TLDFmf7eKJZafZxRn7jumpdSOw7Jz3ODcXZy/m78XTzZ54RoM14oGQ
	0yC5yo6mhIIpZvuFV6ehYsXMwPlcxj41vLSXTxGR1N3W8ILT2J+A30bYCjU/8J4G3g2VPFUdplf
	LepgpqCAdNc0wCHBeQ/93yXu3JxnY/HmbMFbOZJ4nI0aKuw/Do11T8PcyQXYMBFZ8lISpaocXVe
	StSp7+Y5ZRyU2/dAQDCALQBzCsL59mEmH0/IC7X8DsYtO6WrO2aU7Hp2MqV42WXO3efA8C/Ba/L
	m4g1zct0jBNK1dLqXfZJrHHhVNVRovvNX5uUuWqjRMT9T01LW/CiXtne0VIawBR1EOyVGkSrtQP
	d5yOZE2PSDPmynqsUqfYEFaPj4PqyqA0zOyGJ6h4wxFsAfwWCHv4yc03LdBLMHhxaH+RL6Gzgp0
	+i1tzCVqpy8XLbXbP/KYjY02Pk2gpWYV714Ts1M4QzIm6XMnVDD+Xixm1L2dcuK/0shkLPFyXGU
	F0vqof+qHxazYVxT1SsGgli
X-Received: by 2002:a05:6808:130f:b0:45e:c00c:d063 with SMTP id 5614622812f47-46421d835a7mr2022029b6e.37.1771533847242;
        Thu, 19 Feb 2026 12:44:07 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:2c6a:c844:1f92:bfbb])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-463bfcdd689sm11672609b6e.0.2026.02.19.12.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 12:44:06 -0800 (PST)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: konishi.ryusuke@gmail.com,
	linux-nilfs@vger.kernel.org
Cc: Slava.Dubeyko@ibm.com,
	slava@dubeyko.com
Subject: [RFC PATCH] nilfs2: introduce atime support
Date: Thu, 19 Feb 2026 12:43:44 -0800
Message-Id: <20260219204343.70117-1-slava@dubeyko.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, NILFS2 doesn't support atime. And it is possible
to see the evidence of it by running generic/003 test-case of
xfstests suite:

sudo ./check generic/003
FSTYP -- nilfs2
PLATFORM -- Linux/x86_64 hfsplus-testing-0001 6.18.0-rc1+ #10 SMP PREEMPT_DYNAMIC Fri Nov 28 20:48:25 PST 2025
MKFS_OPTIONS -- /dev/loop51
MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch

generic/003 35s ... - output mismatch (see xfstests-dev/results//generic/003.out.bad)

This patch exchanges i_xattr on i_atime and i_pad
on i_atime_nsec fields of struct nilfs_inode in
the on-disk layout, removes all declarations that
disabled atime support. Also, it modifies
nilfs_read_inode_common(), nilfs_write_inode_common(),
and nilfs_setattr() with the goal of proper atime
support.

sudo ./check generic/003
FSTYP         -- nilfs2
PLATFORM      -- Linux/x86_64 nilfs2-testing 6.19.0-rc1+ #8 SMP PREEMPT_DYNAMIC Tue Feb 17 16:21:59 PST 2026
MKFS_OPTIONS  -- /dev/loop51
MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch

generic/003  30s ...  34s
Ran: generic/003
Passed all 1 tests

[1] https://github.com/nilfs-dev/nilfs2/issues/7

Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
---
 fs/nilfs2/Kconfig                  |  2 +-
 fs/nilfs2/inode.c                  | 18 ++++++++++++++----
 fs/nilfs2/nilfs.h                  |  8 ++------
 fs/nilfs2/segment.c                |  2 --
 fs/nilfs2/super.c                  |  5 -----
 include/uapi/linux/nilfs2_ondisk.h |  8 ++++----
 6 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index 7dae168e346e..28de0967745c 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -20,7 +20,7 @@ config NILFS2_FS
 	  snapshot is mountable as a read-only file system concurrently with
 	  its writable mount, and this feature is convenient for online backup.
 
-	  Some features including atime, extended attributes, and POSIX ACLs,
+	  Some features including extended attributes, and POSIX ACLs,
 	  are not supported yet.
 
 	  To compile this file system support as a module, choose M here: the
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 51bde45d5865..a6fcd8133501 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -395,8 +395,8 @@ void nilfs_set_inode_flags(struct inode *inode)
 		new_fl |= S_NOATIME;
 	if (flags & FS_DIRSYNC_FL)
 		new_fl |= S_DIRSYNC;
-	inode_set_flags(inode, new_fl, S_SYNC | S_APPEND | S_IMMUTABLE |
-			S_NOATIME | S_DIRSYNC);
+	inode_set_flags(inode, new_fl,
+			S_SYNC | S_APPEND | S_IMMUTABLE | S_DIRSYNC);
 }
 
 int nilfs_read_inode_common(struct inode *inode,
@@ -410,12 +410,13 @@ int nilfs_read_inode_common(struct inode *inode,
 	i_gid_write(inode, le32_to_cpu(raw_inode->i_gid));
 	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
 	inode->i_size = le64_to_cpu(raw_inode->i_size);
-	inode_set_atime(inode, le64_to_cpu(raw_inode->i_mtime),
-			le32_to_cpu(raw_inode->i_mtime_nsec));
+	inode_set_atime(inode, le64_to_cpu(raw_inode->i_atime),
+			le32_to_cpu(raw_inode->i_atime_nsec));
 	inode_set_ctime(inode, le64_to_cpu(raw_inode->i_ctime),
 			le32_to_cpu(raw_inode->i_ctime_nsec));
 	inode_set_mtime(inode, le64_to_cpu(raw_inode->i_mtime),
 			le32_to_cpu(raw_inode->i_mtime_nsec));
+
 	if (nilfs_is_metadata_file_inode(inode) && !S_ISREG(inode->i_mode))
 		return -EIO; /* this inode is for metadata and corrupted */
 	if (inode->i_nlink == 0)
@@ -723,8 +724,10 @@ void nilfs_write_inode_common(struct inode *inode,
 	raw_inode->i_gid = cpu_to_le32(i_gid_read(inode));
 	raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
 	raw_inode->i_size = cpu_to_le64(inode->i_size);
+	raw_inode->i_atime = cpu_to_le64(inode_get_atime_sec(inode));
 	raw_inode->i_ctime = cpu_to_le64(inode_get_ctime_sec(inode));
 	raw_inode->i_mtime = cpu_to_le64(inode_get_mtime_sec(inode));
+	raw_inode->i_atime_nsec = cpu_to_le32(inode_get_atime_nsec(inode));
 	raw_inode->i_ctime_nsec = cpu_to_le32(inode_get_ctime_nsec(inode));
 	raw_inode->i_mtime_nsec = cpu_to_le32(inode_get_mtime_nsec(inode));
 	raw_inode->i_blocks = cpu_to_le64(inode->i_blocks);
@@ -929,6 +932,13 @@ int nilfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		nilfs_truncate(inode);
 	}
 
+	if (iattr->ia_valid & ATTR_ATIME)
+		inode_set_atime_to_ts(inode, iattr->ia_atime);
+	if (iattr->ia_valid & ATTR_MTIME)
+		inode_set_mtime_to_ts(inode, iattr->ia_mtime);
+	if (iattr->ia_valid & ATTR_CTIME)
+		inode_set_ctime_to_ts(inode, iattr->ia_ctime);
+
 	setattr_copy(&nop_mnt_idmap, inode, iattr);
 	mark_inode_dirty(inode);
 
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index b7e3d91b6243..c78a06883490 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -27,7 +27,6 @@
  * @i_state: dynamic state flags
  * @i_bmap: pointer on i_bmap_data
  * @i_bmap_data: raw block mapping
- * @i_xattr: <TODO>
  * @i_dir_start_lookup: page index of last successful search
  * @i_cno: checkpoint number for GC inode
  * @i_assoc_inode: associated inode (B-tree node cache holder or back pointer)
@@ -43,7 +42,6 @@ struct nilfs_inode_info {
 	unsigned long  i_state;		/* Dynamic state flags */
 	struct nilfs_bmap *i_bmap;
 	struct nilfs_bmap i_bmap_data;
-	__u64 i_xattr;	/* sector_t ??? */
 	__u32 i_dir_start_lookup;
 	__u64 i_cno;		/* check point number for GC inode */
 	struct inode *i_assoc_inode;
@@ -234,12 +232,10 @@ static inline int nilfs_init_acl(struct inode *inode, struct inode *dir)
 }
 #endif
 
-#define NILFS_ATIME_DISABLE
-
 /* Flags that should be inherited by new inodes from their parent. */
 #define NILFS_FL_INHERITED						\
 	(FS_SECRM_FL | FS_UNRM_FL | FS_COMPR_FL | FS_SYNC_FL |		\
-	 FS_IMMUTABLE_FL | FS_APPEND_FL | FS_NODUMP_FL | FS_NOATIME_FL |\
+	 FS_IMMUTABLE_FL | FS_APPEND_FL | FS_NODUMP_FL |		\
 	 FS_COMPRBLK_FL | FS_NOCOMP_FL | FS_NOTAIL_FL | FS_DIRSYNC_FL)
 
 /* Mask out flags that are inappropriate for the given type of inode. */
@@ -250,7 +246,7 @@ static inline __u32 nilfs_mask_flags(umode_t mode, __u32 flags)
 	else if (S_ISREG(mode))
 		return flags & ~(FS_DIRSYNC_FL | FS_TOPDIR_FL);
 	else
-		return flags & (FS_NODUMP_FL | FS_NOATIME_FL);
+		return flags & FS_NODUMP_FL;
 }
 
 /* dir.c */
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index deee16bc9d4e..fae3274e354b 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -930,8 +930,6 @@ static void nilfs_write_root_mdt_inode(struct inode *inode,
 	nilfs_write_inode_common(inode, raw_inode);
 
 	/* zero-fill unused portion of raw_inode */
-	raw_inode->i_xattr = 0;
-	raw_inode->i_pad = 0;
 	memset((void *)raw_inode + sizeof(*raw_inode), 0,
 	       nilfs->ns_inode_size - sizeof(*raw_inode));
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index badc2cbc895e..824d71cbbd8d 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -867,11 +867,6 @@ int nilfs_store_magic(struct super_block *sb,
 
 	sb->s_magic = le16_to_cpu(sbp->s_magic);
 
-	/* FS independent flags */
-#ifdef NILFS_ATIME_DISABLE
-	sb->s_flags |= SB_NOATIME;
-#endif
-
 	nilfs->ns_resuid = le16_to_cpu(sbp->s_def_resuid);
 	nilfs->ns_resgid = le16_to_cpu(sbp->s_def_resgid);
 	nilfs->ns_interval = le32_to_cpu(sbp->s_c_interval);
diff --git a/include/uapi/linux/nilfs2_ondisk.h b/include/uapi/linux/nilfs2_ondisk.h
index b3442b16ff6a..26a1ef28bc66 100644
--- a/include/uapi/linux/nilfs2_ondisk.h
+++ b/include/uapi/linux/nilfs2_ondisk.h
@@ -47,9 +47,9 @@
  * @i_links_count: links count
  * @i_flags: file flags
  * @i_bmap: block mapping
- * @i_xattr: extended attributes
+ * @i_atime: access time (seconds)
  * @i_generation: file generation (for NFS)
- * @i_pad: padding
+ * @i_atime_nsec: access time (nano seconds)
  */
 struct nilfs_inode {
 	__le64	i_blocks;
@@ -65,9 +65,9 @@ struct nilfs_inode {
 	__le32	i_flags;
 	__le64	i_bmap[NILFS_INODE_BMAP_SIZE];
 #define i_device_code	i_bmap[0]
-	__le64	i_xattr;
+	__le64	i_atime;
 	__le32	i_generation;
-	__le32	i_pad;
+	__le32	i_atime_nsec;
 };
 
 #define NILFS_MIN_INODE_SIZE		128
-- 
2.43.0

