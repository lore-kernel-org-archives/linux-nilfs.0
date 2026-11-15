Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.235
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794706422;
	b=ItUPfBZASFEmvTnPM46no7fUVEvYFS8uVmEX6XHsLyWouvU+PojNrtovAwKtK7fRDYhU
	 6/bTXJ6chlx28VePvtPs0bL23QzAfnlkSyXpwXt2UCgnWMib4ZeecKoSm9dCZC/yFts54
	 4OTJSpWIvGC0ZirhguKpKLw9GDkbcwbm0GnmIDnHfpilv1OIxN0xPCTPagxFaJhthVq75
	 tjC2MzZ5OQaFK6F6NqOatcrLMA35FMpcHvVGl3OBcBfy4qzKWSEdnlnUrqZIWStTKdW9M
	 BFtyuWkl5ahlwfYN8X7gtWqUhhfA1znVq3EDt2uwQFAhdoAw2WCu9kIzB2X6IuToT1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794706422;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=E6fB6Hqb+fogftaRgqCELW6oLxTpIP/mTbbjTo1jLXc=;
	b=hn6ZzSrSwEu+hJNeq3mAl1p+XMoSVrYBEtFSX48Ji5FEbztRz4rB5RUhQ/SyXhhr5sLi
	 A6jnKw7E8u+IUWo6jHjdA+lb3XIYVrmAvXpjKROCz1MEI4xTgUx302olXZDVbE/AOjkdE
	 C7mKw18oJHog95Gmmmztq8PRyL6QjtSdhkiz1BfJirIr1trk8N+7GUBL1ELzfOHboM3IV
	 7sk484RlKXhX4IsbO82aegKc5KFtpTDSYrBwGbjeY0rb1wlr/MeBjkQ6OsBXo6RPLrDPu
	 B6+5CZlWPMJ4QP7W31FTWWVGMwqN1/F1bD5uqmu3NQA8f66+EUwX9U6V7H3KY5CvtMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=foxmail.com;
	spf=pass smtp.mailfrom=foxmail.com;
	dkim=pass header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=bjZVH1vJ;
	arc=none smtp.remote-ip=203.205.221.235
Received: from out203-205-221-235.mail.qq.com (out203-205-221-235.mail.qq.com [203.205.221.235])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACBF606A333
	for <linux-nilfs@vger.kernel.org>; Sun, 15 Nov 2026 01:33:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0ACBF606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=bjZVH1vJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1794706412;
	bh=E6fB6Hqb+fogftaRgqCELW6oLxTpIP/mTbbjTo1jLXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bjZVH1vJZYy0Xwwfp/SJsO/doZcbMxPl4d8c/786XT7/R0vYipri0G/Sscwbv/j6m
	 OB7mUMiECttnNuNR6S82pYIbvs4adEbmVSCIF5fFi53UixBrbhen6Wll3R+7kLhf8+
	 9cLAhgofzBI5euchqm+n2KYQiuRNHRTaAnKc6tfU=
Received: from localhost.localdomain ([2409:8a00:2545:bef4:c8bc:9cd1:4eaa:3])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 85BB5C45; Sun, 15 Nov 2026 09:33:27 +0800
X-QQ-mid: xmsmtpt1794706408tox3p94vf
Message-ID: <tencent_F3CAF2061A8AE294D88513588FD3DE1F4806@qq.com>
X-QQ-XMAILINFO: MjEzDxONYx5E8LXVHhFcZOgZqbTtt/bAyQR7pZ6VKjc+RJLJVMP90KWtxaMCQm
	 KDaWqLAtobSpIdUJ+8iiHkRz6w3kXzQo5+uAYjgkmCeTmfV6KC9YOa7DXrqoq+pttogM3uIahjyi
	 IOr7pDKyVwbsH7J+dMErWO8t9+gZ/drZp3zXBQQmJvLAmOaNrWDXPm+fLZWgbMP+pzsatXs/wY2b
	 Zvr4SsXiZZIYFqoO5PSCTBgZIoHhTGh3LyeVtcjUMy3pS8Wn+9TqFzE9XkLn/kAsP/7XiGXGwruZ
	 7BHUGJ4vWuyDGQh3QgfeBhmBnT+h21R6AoU4N/1qezY+yBNzEz01O3SZw9oTpvEr3y6eqLXy8Ntw
	 AKsOPu7izi3cG4XDPNn/gy/W+nZMf50hUGs7Nokkyefu8i1HUc1QxuhZd9rio3z4j1PGklujOY+M
	 OzrmihMcCZ/6/2eeCfMaIJBRAFkCudf3r9JlQsfwBJyMyFCUcwajQzllIGGWdATZcsvBLNfa5v1s
	 DUspciNba7z9pCLMt8QDRam5cWcHSacvF/LRMxRjGLoOqZYzAwhiBCbgjuHFwp2KlCE9+QyrC4sN
	 5omWYNEbXe7KSNp+Wqh0oKKNul5man7TIp0qXEyPHr1dG15BfMt/MNx8+7sAwJplxfFXJS48z/TI
	 6UciAVLRlj2AWxegT97P6InOabCDvFRYLkK2QMspFqb7VBzQwSjitGcFyFkxsqhPXLaIXXIaL36H
	 ynMufNRJwxSL3AHFz0S+k7LgR8DTkfy65Hkr88etmYE0nF4nW8b6+NbGgN2cE/bcFrEGhYHnzWYc
	 wqPehgyGM+yanbpLZpZp334ZY+4glkZ17/ybB+N0HkOcKmeqfghpYsXsR+B+rPykwTogU+z/0e/8
	 W5leuAj4IqHf8v00meFXKqcbUoNYHrB7Le043rNg5ZkoWyj5yQ/o5OJrXGZHfAHUqVMwftpnQQJL
	 JlW4goHmCK0qoS7AHrJd4WPRu6g4LbnhqGvXfwQG7Y25DkBFP4b2voN1iZ5QghY3tgsUIPELQIRm
	 zr8h/CLAlqvfWe4xLIZ6WiZ4qPvJrKRC/XVaNKfrDvryGDney+8jH7hffpj8g+sut+ZJumwmwyyD
	 lNDSm8vdV5gq6G6THhteQEshmuti8mpMUiuDBDxvA10A8aDS2k2vGNSMPXp8bFOYh+w9WO5blHDH
	 SZ34Eekktdhci8B+FiCc34daO2
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Wang Jianjian <wangjianjian0@foxmail.com>
To: konishi.ryusuke@gmail.com,
	slava@dubeyko.com,
	linux-nilfs@vger.kernel.org
Cc: Wang Jianjian <wangjianjian0@foxmail.com>
Subject: [PATCH v2 2/2] nilfs2: introduce atime support
Date: Sun, 15 Nov 2026 09:33:28 +0800
X-OQ-MSGID: <20261115013328.123821-2-wangjianjian0@foxmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115013328.123821-1-wangjianjian0@foxmail.com>
References: <20261115013328.123821-1-wangjianjian0@foxmail.com>
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <slava@dubeyko.com>

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

Co-developed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Wang Jianjian <wangjianjian0@foxmail.com>
---
 fs/nilfs2/Kconfig                  |  2 +-
 fs/nilfs2/inode.c                  | 11 +++++++++--
 fs/nilfs2/nilfs.h                  |  4 ----
 fs/nilfs2/segment.c                |  2 --
 fs/nilfs2/super.c                  |  8 +++-----
 include/uapi/linux/nilfs2_ondisk.h |  8 ++++----
 6 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index 0a5ace60e6ab..79b99c33af06 100644
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
index a99a69e9f91b..d91620f55629 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -386,6 +386,7 @@ void nilfs_set_inode_flags(struct inode *inode)
 int nilfs_read_inode_common(struct inode *inode,
 			    struct nilfs_inode *raw_inode)
 {
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 	int err;
 
@@ -394,8 +395,12 @@ int nilfs_read_inode_common(struct inode *inode,
 	i_gid_write(inode, le32_to_cpu(raw_inode->i_gid));
 	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
 	inode->i_size = le64_to_cpu(raw_inode->i_size);
-	inode_set_atime(inode, le64_to_cpu(raw_inode->i_mtime),
-			le32_to_cpu(raw_inode->i_mtime_nsec));
+	if (nilfs->ns_feature_compat_ro & NILFS_FEATURE_COMPAT_RO_ATIME)
+		inode_set_atime(inode, le64_to_cpu(raw_inode->i_atime),
+				le32_to_cpu(raw_inode->i_atime_nsec));
+	else
+		inode_set_atime(inode, le64_to_cpu(raw_inode->i_mtime),
+				le32_to_cpu(raw_inode->i_mtime_nsec));
 	inode_set_ctime(inode, le64_to_cpu(raw_inode->i_ctime),
 			le32_to_cpu(raw_inode->i_ctime_nsec));
 	inode_set_mtime(inode, le64_to_cpu(raw_inode->i_mtime),
@@ -701,8 +706,10 @@ void nilfs_write_inode_common(struct inode *inode,
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
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 28d35b2fa7f7..81cc6552365e 100644
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
@@ -234,8 +232,6 @@ static inline int nilfs_init_acl(struct inode *inode, struct inode *dir)
 }
 #endif
 
-#define NILFS_ATIME_DISABLE
-
 /* Flags that should be inherited by new inodes from their parent. */
 #define NILFS_FL_INHERITED						\
 	(FS_SECRM_FL | FS_UNRM_FL | FS_COMPR_FL | FS_SYNC_FL |		\
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index af0c3560444f..68b640a7aa5b 100644
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
index f92bcf1a9544..ddad1e4f55ce 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -863,11 +863,6 @@ int nilfs_store_magic(struct super_block *sb,
 
 	sb->s_magic = le16_to_cpu(sbp->s_magic);
 
-	/* FS independent flags */
-#ifdef NILFS_ATIME_DISABLE
-	sb->s_flags |= SB_NOATIME;
-#endif
-
 	nilfs->ns_resuid = le16_to_cpu(sbp->s_def_resuid);
 	nilfs->ns_resgid = le16_to_cpu(sbp->s_def_resgid);
 	nilfs->ns_interval = le32_to_cpu(sbp->s_c_interval);
@@ -876,6 +871,9 @@ int nilfs_store_magic(struct super_block *sb,
 	nilfs->ns_feature_compat_ro = le64_to_cpu(sbp->s_feature_compat_ro);
 	nilfs->ns_feature_incompat = le64_to_cpu(sbp->s_feature_incompat);
 
+	if (!(nilfs->ns_feature_compat_ro & NILFS_FEATURE_COMPAT_RO_ATIME))
+		sb->s_flags |= SB_NOATIME;
+
 	return 0;
 }
 
diff --git a/include/uapi/linux/nilfs2_ondisk.h b/include/uapi/linux/nilfs2_ondisk.h
index 19587700c92c..e94593137adb 100644
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
2.47.3

