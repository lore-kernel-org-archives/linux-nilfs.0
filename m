Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.235
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793631450;
	b=thHRVQqxtKqmrYNGDt21CsTrByS8gb7HVNYEDupXks99RpcxRUEKZ6omMMloih1gKMmN
	 ef3xS2Ysytf4raGWO2DtloJ5IVaTuy5WG5XuULzcnii6HLBCx5Eg6MF2aZj+gnxQ1W+T5
	 gnory7OvNu78frW4A3AwngvgKG3VmtRZAjLG3gn8XkabXMCkI/EeAFtdM6sCZpCikRJwG
	 d5VsnV8mG1kYaQ+McBm9FHY3xcBq56sZn9SXodu8aRd1GFqXRWWyrrczUDwQLT+YtZUdR
	 QIBc/UvO7eoG7I+ICdwJUC6tXw3fCrtCOlNkpDAnGCD6+2W78chrGcFdoHfqMTfy8kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793631450;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6F2k8z0Vw8oHrQA1I/v1+4a+EkJx16QF3zOpOLCzegw=;
	b=2BChnj4E4hX02c9C/yQMdFAkyRW+sObM9U+ZtxU/unzeb68+gU0VHxDTs8VPYTk75P03
	 Lya3xnMv7VyuNgI3slQJEnWrXfFJmal65NiD24S5IQSYjOQxj0ncMJeRj8QlyvmRkDeQQ
	 pJVHhnjbFr9WzWUcZzThh2z3clYxbMEVCh+OkB68LHie67+Fr3wL3NVq0TlXMcGDIcEiX
	 OgyN0UmanufRVP4zIR7l12rXcAL37F/YRTt6eFF04qcEY3k4Fd0MLteA0W/xTPERRMH5Y
	 VPq2JargifbbevtZd4hEp5+UqBqrMuEMWvlM1pCHEMcuFw1KzToD+isOyeAOSnKw93A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=foxmail.com;
	spf=pass smtp.mailfrom=foxmail.com;
	dkim=pass header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=rHbEH4y7;
	arc=none smtp.remote-ip=203.205.221.235
Received: from out203-205-221-235.mail.qq.com (out203-205-221-235.mail.qq.com [203.205.221.235])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305D2606A5AB
	for <linux-nilfs@vger.kernel.org>; Mon,  2 Nov 2026 14:57:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 305D2606A5AB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=rHbEH4y7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1793631440;
	bh=6F2k8z0Vw8oHrQA1I/v1+4a+EkJx16QF3zOpOLCzegw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rHbEH4y7xB7ij535sriTbrwCtk5IMEH+wvB0QvNLQ2mieJdmREtcqx/eG3yjIKusn
	 0OoYXMbWDKiCPPCSdjjXzS+HD7A6lthMnlRgz1miEAKLQqyueOpx1JJxbXeQgBBLAX
	 /LNH2+MSg1YP8HXQUsHxhN4l7/I9vCnTRj6mIlL8=
Received: from mypc.. ([2409:8a00:2545:d0f4:3ade:2e95:26c5:7e2d])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id E4A33C53; Mon, 02 Nov 2026 22:57:10 +0800
X-QQ-mid: xmsmtpt1793631432t3ivxlo4m
Message-ID: <tencent_F07D82D02C87A0BD288288B53AC1F558ED0A@qq.com>
X-QQ-XMAILINFO: MVP725H+3iamAuOM1Ebn7WIQNvYY1hE+AIC1ohVhYpzCfe45z48nl1CrvY9Ymr
	 5MFMMXttVDZoHcrQx2UjHkv3kpB2xDe9FyckSACKLgZ0Gd3byKbty+8w0Er6ksgyzow4BZskHNj9
	 55Q7CbH5kxjw6GNz+GxqqqgFAvYcr69/bW2gGW6kC27MU9JPeDZPsxtYh7m6BM/Kt0ZxFce2dM/b
	 ZQoxlKlnSUwZP0sbH7AVUdmAt4Tm8fISlUf+2Hczv3MUbmezSohd1DERmWSJvAqHDL4ebt/v7uUq
	 pwmyH6lRs7gYliCEK/aUEa84LAmDbqb4yslstMv9ssPgs1cK15BJPGWNwVbnLmvfqUxWHRKdrdVQ
	 GNZ18sqIv8rcLIOLbld5UgD+91XnM2zdlgG/ZbmzSmvOjXy8PAo7wN5osrv2tUIfR1+P/2xa19GB
	 nTSbSQnnm1NQ0yfc+PxSc5sHPxUKakZ+rMao4IWrQ+km2fjM+gL2nJDJIOkIBqDey99gbYhTW7sY
	 wR2aTXr4jrMuMXzpfbmK6clXKB1lSJW15OxkxyAq/vSTmMFQFgxoxASNq8NBP0ZQ23hAIFJFSEdU
	 j6rpPcGKLzX0lZIRZy/HlR/bZJSDOdYZvHeGdHfFmN4cODPw/DMc+8cM6qrApsyMyOrUnnBhVPLH
	 /zx5sJ/7YOOST83oLnBL7MpdqNfTBFqwMVnetJ3MccoZuwOE3Deg4oz16rx+ohghOWgJ8lAZI9e3
	 gd+cFPG65CLJrLconN+Nbj1AxVNMoI8mRHEKW8Ry5anM6hnPgXwxXp2Cjb+54nnknLiUwH92tE9u
	 RdFWAImS1vY+LZPmybItcen6qXg3Tz1wiPkqdd7YsNtbeFnLvT17LI+E0jJzTi6SVOXdOGkFi4me
	 kueEojgpE/z/fWUsCBGL6TJIoAOLUpzBFncqe+fnxHi4tsUXfniyxFwYsHFQ8kVncBbI28MIAcoO
	 YkxzNjiy58bsjNVL3B5HABVEBM0VrkT4538xlLIruf3ZvONqXQdUrQ5ZnNYG0rPYYIsuCTexNtIr
	 5QQ5ubJlU/JlTbPRWP872mXcWb8p49dccb3h80Iu+U23syRZyaluP1vCPZneAyYbG7/K3xpuYCw2
	 3K/T2zNc/srHT/jGtO/8g/a1agWX5Ln9A206BbFymM9bCRtoqc4RVWJDb68mCCbY0Jj7xO
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: wangjianjian0@foxmail.com
To: konishi.ryusuke@gmail.com,
	slava@dubeyko.com
Cc: linux-nilfs@vger.kernel.org,
	Wang Jianjian <wangjianjian0@foxmail.com>
Subject: [PATCH 2/2] nilfs2: introduce atime support
Date: Mon,  2 Nov 2026 22:57:08 +0800
X-OQ-MSGID: <20261102145708.18588-2-wangjianjian0@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261102145708.18588-1-wangjianjian0@foxmail.com>
References: <20261102145708.18588-1-wangjianjian0@foxmail.com>
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

Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Wang Jianjian <wangjianjian0@foxmail.com>
---
 fs/nilfs2/Kconfig                  |  2 +-
 fs/nilfs2/inode.c                  | 14 ++++++++++++--
 fs/nilfs2/nilfs.h                  |  4 ----
 fs/nilfs2/segment.c                |  2 --
 fs/nilfs2/super.c                  |  9 ++++-----
 include/uapi/linux/nilfs2_ondisk.h |  8 ++++----
 6 files changed, 21 insertions(+), 18 deletions(-)

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
index 34e6096069ad..b77f32be65a8 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -401,20 +401,28 @@ void nilfs_set_inode_flags(struct inode *inode)
 int nilfs_read_inode_common(struct inode *inode,
 			    struct nilfs_inode *raw_inode)
 {
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 	struct nilfs_inode_info *ii = NILFS_I(inode);
+	__u64 features;
 	int err;
 
+	features = le64_to_cpu(nilfs->ns_sbp[0]->s_feature_compat_ro);
 	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
 	i_uid_write(inode, le32_to_cpu(raw_inode->i_uid));
 	i_gid_write(inode, le32_to_cpu(raw_inode->i_gid));
 	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
 	inode->i_size = le64_to_cpu(raw_inode->i_size);
-	inode_set_atime(inode, le64_to_cpu(raw_inode->i_mtime),
-			le32_to_cpu(raw_inode->i_mtime_nsec));
+	if (features & NILFS_FEATURE_COMPAT_RO_ATIME)
+		inode_set_atime(inode, le64_to_cpu(raw_inode->i_atime),
+				le32_to_cpu(raw_inode->i_atime_nsec));
+	else
+		inode_set_atime(inode, le64_to_cpu(raw_inode->i_mtime),
+				le32_to_cpu(raw_inode->i_mtime_nsec));
 	inode_set_ctime(inode, le64_to_cpu(raw_inode->i_ctime),
 			le32_to_cpu(raw_inode->i_ctime_nsec));
 	inode_set_mtime(inode, le64_to_cpu(raw_inode->i_mtime),
 			le32_to_cpu(raw_inode->i_mtime_nsec));
+
 	if (nilfs_is_metadata_file_inode(inode) && !S_ISREG(inode->i_mode))
 		return -EIO; /* this inode is for metadata and corrupted */
 	if (inode->i_nlink == 0)
@@ -721,8 +729,10 @@ void nilfs_write_inode_common(struct inode *inode,
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
index 4fc42d3787a4..80e54a7cc2e4 100644
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
index 829573cb6131..f39271d32a2e 100644
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
index 893a504cb80c..972be00c21be 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -864,13 +864,12 @@ int nilfs_store_magic(struct super_block *sb,
 		      struct nilfs_super_block *sbp)
 {
 	struct the_nilfs *nilfs = sb->s_fs_info;
+	__u64 features;
 
 	sb->s_magic = le16_to_cpu(sbp->s_magic);
-
-	/* FS independent flags */
-#ifdef NILFS_ATIME_DISABLE
-	sb->s_flags |= SB_NOATIME;
-#endif
+	features = le64_to_cpu(nilfs->ns_sbp[0]->s_feature_compat_ro);
+	if ((features & NILFS_FEATURE_COMPAT_RO_ATIME) == 0)
+		sb->s_flags |= SB_NOATIME;
 
 	nilfs->ns_resuid = le16_to_cpu(sbp->s_def_resuid);
 	nilfs->ns_resgid = le16_to_cpu(sbp->s_def_resgid);
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
2.34.1

