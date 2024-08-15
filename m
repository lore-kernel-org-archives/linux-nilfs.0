Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4D7DF5C
	for <linux-nilfs@vger.kernel.org>; Thu, 15 Aug 2024 01:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723685269; cv=none; b=Ly8r9L3mWuHjXrl3wgD2HP6xFXJRXNFe2IIgr0BKXo07A4Lyrj5bKjn5d4DIkzndfLzedB6DfHIn7PPq5MEg8Po6FyiQEtamo4wDoz4JGILetRW5LSiQJFggtSHUj7dCEb/uaOJ4wHBnTRX/JHEdAROS+2lSqdVS/H6AUV5u7CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723685269; c=relaxed/simple;
	bh=pUOVe0UMK+V3vHyLkTlccs1IEsWFfh4yk40tsxzTB6o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dxxsuMl/Mx5LMg+To9J1OTYAuhT3NIBiU7hLZ+BOj0INpdWq7vhhHd20G/3m04ZN2KZkz2o2oRUwxhGqZKkzxVteEu+Gpe7gY/v/AotNz77y/9FSIVQBt/hyW+vJwF/dJ38jEiafuD+Ux+HHq8U3cRa7cKRZvTLW0/wUrbSzVhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WknY65SfwzcdJy
	for <linux-nilfs@vger.kernel.org>; Thu, 15 Aug 2024 09:27:22 +0800 (CST)
Received: from dggpemm500021.china.huawei.com (unknown [7.185.36.109])
	by mail.maildlp.com (Postfix) with ESMTPS id 636F6140417
	for <linux-nilfs@vger.kernel.org>; Thu, 15 Aug 2024 09:27:38 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemm500021.china.huawei.com
 (7.185.36.109) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 15 Aug
 2024 09:27:38 +0800
From: Huang Xiaojia <huangxiaojia2@huawei.com>
To: <konishi.ryusuke@gmail.com>, <yuehaibing@huawei.com>
CC: <linux-nilfs@vger.kernel.org>, <huangxiaojia2@huawei.com>
Subject: [PATCH -next v2] nilfs2: use common implementation of file type
Date: Thu, 15 Aug 2024 09:34:42 +0800
Message-ID: <20240815013442.1220909-1-huangxiaojia2@huawei.com>
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

Deduplicate the nilfs2 file type conversion implementation.

Signed-off-by: Huang Xiaojia <huangxiaojia2@huawei.com>
---
v2: Keep the definitions of NILFS_FT_*
v1: https://lore.kernel.org/all/20240814123801.1196678-1-huangxiaojia2@huawei.com/
---
 fs/nilfs2/dir.c | 44 +++++---------------------------------------
 1 file changed, 5 insertions(+), 39 deletions(-)

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
-- 
2.34.1

