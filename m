Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014361109
	for <linux-nilfs@vger.kernel.org>; Wed, 14 Aug 2024 12:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723638672; cv=none; b=t0u+r1i+p3sBA1S0BtynpcDf3Noh60ihivWlLa9utJdDxe+PA1nSKzSzqt+4144Xj2rIk+w2DnSSNL/FbVhXcyBuzCAw6qhmW1PWhyyNOWneYyuAnG8wvh3pxSgz0HlKO+7WsWFxCcVYUuH35bOsUa33bTqma2uUUV/xKI0GVT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723638672; c=relaxed/simple;
	bh=Th2Shj8pXwQ6o35psNEnTVmFOnLYXyUtmGQDNoqjCjY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZWb4YTVuMyVeMiekrms05mLn8tr7kGqz65wnPXgwZyLP42afT+gLxMw1SSpSYIAS1JlEZhliSY4ez5SjamnKJ0oXHtLucH/MoeAX5fwA6KKSXpb0DhaiB8felpNh/RqZOqw6jEpzBt4EHkloMk8bkdRFZEtewULDK8IM0JHsELA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4WkSCf6B1tz1S7tW
	for <linux-nilfs@vger.kernel.org>; Wed, 14 Aug 2024 20:26:06 +0800 (CST)
Received: from dggpemm500021.china.huawei.com (unknown [7.185.36.109])
	by mail.maildlp.com (Postfix) with ESMTPS id 4E2DF14022D
	for <linux-nilfs@vger.kernel.org>; Wed, 14 Aug 2024 20:30:59 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemm500021.china.huawei.com
 (7.185.36.109) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 14 Aug
 2024 20:30:58 +0800
From: Huang Xiaojia <huangxiaojia2@huawei.com>
To: <konishi.ryusuke@gmail.com>, <yuehaibing@huawei.com>
CC: <linux-nilfs@vger.kernel.org>, <huangxiaojia2@huawei.com>
Subject: [PATCH -next] nilfs2: use common implementation of file type
Date: Wed, 14 Aug 2024 20:38:01 +0800
Message-ID: <20240814123801.1196678-1-huangxiaojia2@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500021.china.huawei.com (7.185.36.109)

Deduplicate the nilfs2 file type conversion implementation and
remove NILFS_FT_* definitions since it's the same as defined
by POSIX.

Signed-off-by: Huang Xiaojia <huangxiaojia2@huawei.com>
---
 fs/nilfs2/dir.c                    | 44 ++++--------------------------
 include/uapi/linux/nilfs2_ondisk.h | 16 -----------
 2 files changed, 5 insertions(+), 55 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 4a29b0138d75..ba6bc6efcf11 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -231,37 +231,6 @@ static struct nilfs_dir_entry *nilfs_next_entry(struct nilfs_dir_entry *p)
 					  nilfs_rec_len_from_disk(p->rec_len));
 }
 
-static unsigned char
-nilfs_filetype_table[NILFS_FT_MAX] = {
-	[NILFS_FT_UNKNOWN]	= DT_UNKNOWN,
-	[NILFS_FT_REG_FILE]	= DT_REG,
-	[NILFS_FT_DIR]		= DT_DIR,
-	[NILFS_FT_CHRDEV]	= DT_CHR,
-	[NILFS_FT_BLKDEV]	= DT_BLK,
-	[NILFS_FT_FIFO]		= DT_FIFO,
-	[NILFS_FT_SOCK]		= DT_SOCK,
-	[NILFS_FT_SYMLINK]	= DT_LNK,
-};
-
-#define S_SHIFT 12
-static unsigned char
-nilfs_type_by_mode[(S_IFMT >> S_SHIFT) + 1] = {
-	[S_IFREG >> S_SHIFT]	= NILFS_FT_REG_FILE,
-	[S_IFDIR >> S_SHIFT]	= NILFS_FT_DIR,
-	[S_IFCHR >> S_SHIFT]	= NILFS_FT_CHRDEV,
-	[S_IFBLK >> S_SHIFT]	= NILFS_FT_BLKDEV,
-	[S_IFIFO >> S_SHIFT]	= NILFS_FT_FIFO,
-	[S_IFSOCK >> S_SHIFT]	= NILFS_FT_SOCK,
-	[S_IFLNK >> S_SHIFT]	= NILFS_FT_SYMLINK,
-};
-
-static void nilfs_set_de_type(struct nilfs_dir_entry *de, struct inode *inode)
-{
-	umode_t mode = inode->i_mode;
-
-	de->file_type = nilfs_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
-}
-
 static int nilfs_readdir(struct file *file, struct dir_context *ctx)
 {
 	loff_t pos = ctx->pos;
@@ -297,10 +266,7 @@ static int nilfs_readdir(struct file *file, struct dir_context *ctx)
 			if (de->inode) {
 				unsigned char t;
 
-				if (de->file_type < NILFS_FT_MAX)
-					t = nilfs_filetype_table[de->file_type];
-				else
-					t = DT_UNKNOWN;
+				t = fs_ftype_to_dtype(de->file_type);
 
 				if (!dir_emit(ctx, de->name, de->name_len,
 						le64_to_cpu(de->inode), t)) {
@@ -444,7 +410,7 @@ void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
 	err = nilfs_prepare_chunk(folio, from, to);
 	BUG_ON(err);
 	de->inode = cpu_to_le64(inode->i_ino);
-	nilfs_set_de_type(de, inode);
+	de->file_type = fs_umode_to_ftype(inode->i_mode);
 	nilfs_commit_chunk(folio, mapping, from, to);
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 }
@@ -531,7 +497,7 @@ int nilfs_add_link(struct dentry *dentry, struct inode *inode)
 	de->name_len = namelen;
 	memcpy(de->name, name, namelen);
 	de->inode = cpu_to_le64(inode->i_ino);
-	nilfs_set_de_type(de, inode);
+	de->file_type = fs_umode_to_ftype(inode->i_mode);
 	nilfs_commit_chunk(folio, folio->mapping, from, to);
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 	nilfs_mark_inode_dirty(dir);
@@ -612,14 +578,14 @@ int nilfs_make_empty(struct inode *inode, struct inode *parent)
 	de->rec_len = nilfs_rec_len_to_disk(NILFS_DIR_REC_LEN(1));
 	memcpy(de->name, ".\0\0", 4);
 	de->inode = cpu_to_le64(inode->i_ino);
-	nilfs_set_de_type(de, inode);
+	de->file_type = fs_umode_to_ftype(inode->i_mode);
 
 	de = (struct nilfs_dir_entry *)(kaddr + NILFS_DIR_REC_LEN(1));
 	de->name_len = 2;
 	de->rec_len = nilfs_rec_len_to_disk(chunk_size - NILFS_DIR_REC_LEN(1));
 	de->inode = cpu_to_le64(parent->i_ino);
 	memcpy(de->name, "..\0", 4);
-	nilfs_set_de_type(de, inode);
+	de->file_type = fs_umode_to_ftype(inode->i_mode);
 	kunmap_local(kaddr);
 	nilfs_commit_chunk(folio, mapping, 0, chunk_size);
 fail:
diff --git a/include/uapi/linux/nilfs2_ondisk.h b/include/uapi/linux/nilfs2_ondisk.h
index c23f91ae5fe8..f52c338103a5 100644
--- a/include/uapi/linux/nilfs2_ondisk.h
+++ b/include/uapi/linux/nilfs2_ondisk.h
@@ -306,22 +306,6 @@ struct nilfs_dir_entry {
 	char    pad;
 };
 
-/*
- * NILFS directory file types.  Only the low 3 bits are used.  The
- * other bits are reserved for now.
- */
-enum {
-	NILFS_FT_UNKNOWN,
-	NILFS_FT_REG_FILE,
-	NILFS_FT_DIR,
-	NILFS_FT_CHRDEV,
-	NILFS_FT_BLKDEV,
-	NILFS_FT_FIFO,
-	NILFS_FT_SOCK,
-	NILFS_FT_SYMLINK,
-	NILFS_FT_MAX
-};
-
 /*
  * NILFS_DIR_PAD defines the directory entries boundaries
  *
-- 
2.34.1

