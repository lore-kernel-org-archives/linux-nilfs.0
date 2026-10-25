Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.252
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792901059;
	b=NPnlv8G28k8WW9YK+UQX1XWUcXTbUA04B2SWn7n+O/nodaomubAZj/jBpXuK1JsEM7J2
	 yhxUEH6lsZCnXEfMLO3+ZH7kC2297XDKcI25LSVMItZuBXCFOGdwj3tF/Lf985ClKBpA3
	 6RmbtnZ2i2sGnDipZrzSkkb0zvHlRaLNPF4f2OTsjHNU8W2u6FeocEmp+6ItybgwXiTok
	 fyloT/1rpCmdD8PF37r36ahegCjzSverZSVct4wYC4grcekz0FQEbld18Cn/J/bYZUozc
	 q6UKAEJgG8Xh/zyTeUtMsaRYk3Gcev62rtj/VV2++ROAZ4onZ4eV52U/6ltLkTZQQQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792901059;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=zlDTu0+rj5QcafGfw4BzS+L3W33szTnntE/NHGZ2tP4=;
	b=tOxGkH6bmxH9JMFzsXJKtPC5z35vtHMB+iOcUuzuTKmBtGeMoenggb+EyWLlskTeW0By
	 GqDPEk721Y7XWnBnv1czoNamrWOvuHuIIK2AGolsYo+00S4Uo2y3vFqMLD8XxzvhnkIWQ
	 uU8M1vuIeBesJdOJSkVgOyV4bPXnYLDRpw7t9U3MW2OUa7Te/pVS3EEv4PEgCbXGV35ZI
	 JBeQH/eGyDZXClTOgu2SRE8WrUk3twlKFCcjDLDh4aNcN5NjEy4NbuwIVxrx8u+ucfCD1
	 2hRgSRfBQfMWETky75QIl6j9M5mLHxGOCgmL0n3g0pSjHvO8IXAC3zgGySw1lWNfcpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=foxmail.com;
	spf=pass smtp.mailfrom=foxmail.com;
	dkim=pass header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=t2SYPfRb;
	arc=none smtp.remote-ip=162.62.57.252
Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EA5606A31A
	for <linux-nilfs@vger.kernel.org>; Sun, 25 Oct 2026 04:04:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87EA5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=t2SYPfRb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1792901052;
	bh=zlDTu0+rj5QcafGfw4BzS+L3W33szTnntE/NHGZ2tP4=;
	h=From:To:Cc:Subject:Date;
	b=t2SYPfRbzgSk2k3st+bm3Uiij2aQe5Lz/6fRUxYMT+tXU3GfDaRrTAdxd8xgAxvob
	 nmkQePBi/TiJl56HvU8ht0tVOjTnYAe1Z+kR2+FPWooceR4dZyiSx1KmrIWhsSSjok
	 QRcuXGyhMCTK2wr+Xhe5vkTZSXlp1z9DKxG50Bh0=
Received: from mypc.. ([2409:8a00:2545:d0f4:8cf1:f261:1d36:a9de])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 10A0EA8F; Sun, 25 Oct 2026 12:04:10 +0800
X-QQ-mid: xmsmtpt1792901050tx8anrqpd
Message-ID: <tencent_A1BD1C90A8E503B41B451E310527DC9E9F07@qq.com>
X-QQ-XMAILINFO: N9lasXYeZMXWYd9/OBgDXX5DUXvmS0m83td2rc8xKf9MTBz3XO9yJVZswR3IrK
	 z5iVQofkiLG8k3zi6miuU9LN71m1utW+Utnlkd3UzmPtqYb4giUjNomDBPraFM5zYT02PjaCTEMV
	 GlnAjNJUCZXaEUZG2X8yppMVsZEovDv6HkbMMnCQ5fkX8/tCqa1o1P13t4BwEZvIiuuNMEfYQ5Ag
	 lOLQRsJXc0sTx4/U6KJ82/LcElJAEYLkqnBvQ0tlVFq0Eb9ylGdn1uCCpixz8/0mOoncX5/K+qBG
	 Z1zGc1RgEuaKzktxIlXrw7uhoBf6aXMpMQ3483XX07YwxxoAuCrg9Sq4y3peXtxT6WoI2fv0WFeo
	 YWZc+E9hPNnD+MQeuM015sRj+nxUySX5Lyf90P2F7CepKappHyjM6LLla8En/668KJEDuiDToY6G
	 zznRfKAKzsO9/cGoO5IEcfzi+sqX2p/fqUZfIIKnr5QL0vlck+Z1lS3sd5ibUVCJq+8W9PM6f+vR
	 KIPlmogwzYfoNfX4QGeIhCRudpqrwU9/xG2KxG38gCYEVNrD8IEjGKy+KHXybHgoDPa7ivC5TmKr
	 9nrFYEFQ2zD4lTZk4t5cynur9oelm5xgm4ic6Y0cHxNeHsRRIRcBejMWobO9DKdbgQJSIweI3XXp
	 GQYuNvOBtrzBlqW3p2W4gqBMsxYT9SjIDAOKEKHjYif3efkf4fjC90MEM0AEAyRyHAH1KEo33IQM
	 N9CXz3JG0VgE6/xvcPBsXI6Vi9zhYC7ElvkIxoZIo2h+5djNSsp/HytP+2Du8P6uv8iGOmV0OYC2
	 TYPfGQgOC7P1siFGAbudg2J4xIQ6VGSxz7sXKbfk59gl1OBTc34FYboDM+0+PbUeP6IgpMXUY5Am
	 mYc6qSmQR43U/gsjcI4gydXoi0XzJhjk53aVKfeq3W60MOgPokfV2Wq4toXvMB/Suwgt3crVnIXa
	 x2g+FWGi7PokVBWVIJohKwhFYW9VIDLQPpdKH3oQ21iDnbMl2Jz6UiNVIDZ+WQghULFTJb+92Vsu
	 P+wkJnRksygeK8OIQyGMez6VTMB0pO5CIBy3Yb5AQbSxtmYecpv4U1IVpTm/qQ73QhzUetfATMbL
	 0yh97d
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: wangjianjian0@foxmail.com
To: konishi.ryusuke@gmail.com,
	slava@dubeyko.com
Cc: linux-nilfs@vger.kernel.org,
	Wang Jianjian <wangjianjian0@foxmail.com>
Subject: [PATCH] nilfs2: add atime support
Date: Sun, 25 Oct 2026 12:04:08 +0800
X-OQ-MSGID: <20261025040408.625539-1-wangjianjian0@foxmail.com>
X-Mailer: git-send-email 2.34.1
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

From: Wang Jianjian <wangjianjian0@foxmail.com>

This RFC patch added atime support for nilfs2. To keep disk inode
layout, reuse {i_xattr, i_pad} as {i_atime, i_atime_nosec}. And remove
SB_NOATIME from sb_flags.

For now, the default behavior is relatime and other time mount
options(such as noatime, lazytime,...) are not considered.

Signed-off-by: Wang Jianjian <wangjianjian0@foxmail.com>
---
 fs/nilfs2/inode.c                  | 6 ++++--
 fs/nilfs2/nilfs.h                  | 2 --
 fs/nilfs2/segment.c                | 3 ---
 fs/nilfs2/super.c                  | 5 -----
 include/uapi/linux/nilfs2_ondisk.h | 4 ++--
 5 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 34e6096069ad..c04f6aea5dee 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -409,8 +409,8 @@ int nilfs_read_inode_common(struct inode *inode,
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
@@ -721,8 +721,10 @@ void nilfs_write_inode_common(struct inode *inode,
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
index 4fc42d3787a4..23e2624f13ac 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -234,8 +234,6 @@ static inline int nilfs_init_acl(struct inode *inode, struct inode *dir)
 }
 #endif
 
-#define NILFS_ATIME_DISABLE
-
 /* Flags that should be inherited by new inodes from their parent. */
 #define NILFS_FL_INHERITED						\
 	(FS_SECRM_FL | FS_UNRM_FL | FS_COMPR_FL | FS_SYNC_FL |		\
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 829573cb6131..3a9a66cc22e0 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -929,9 +929,6 @@ static void nilfs_write_root_mdt_inode(struct inode *inode,
 
 	nilfs_write_inode_common(inode, raw_inode);
 
-	/* zero-fill unused portion of raw_inode */
-	raw_inode->i_xattr = 0;
-	raw_inode->i_pad = 0;
 	memset((void *)raw_inode + sizeof(*raw_inode), 0,
 	       nilfs->ns_inode_size - sizeof(*raw_inode));
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 893a504cb80c..75c068359b7c 100644
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
index b3442b16ff6a..ed365ba4565f 100644
--- a/include/uapi/linux/nilfs2_ondisk.h
+++ b/include/uapi/linux/nilfs2_ondisk.h
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

base-commit: a4ff2be345d0abc943da8dd8da98151843b750dc
-- 
2.34.1

