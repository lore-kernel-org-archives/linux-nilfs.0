Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8501990AF;
	Mon, 26 Aug 2024 17:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724694095; cv=none; b=smmdzbin3mrK5MBSsSM3HCL5DnymAI7G+KnlDfwT0SIGzO7bhNh7uFJndoNqAJkFl+6b5+5OfAo3LUKKb143dT8Iou/T810uykBCpo/zIHOlBMn/iksE5ZCI9cGLy3+jNAJHYR213D1rXbRWQDVDUH8Q+5BsyMcuzaphVq0kT/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724694095; c=relaxed/simple;
	bh=8EnvAihNq6tOIhgL6V5zBWfQsQ5CZXfVaMzGWaWrT5s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HiDPMJ6g/GXtomoYiNI2esQSedwC5Pq0VKImObIlWDWIo7AG7acSg5XTmOvpq57L14WLF3Bwi+kH2AQ7Xk9CHwS4wef6IvA2Xe3WfVyTUg6C4K6Jy6CsBMiFve/S+ld2EqplszxsyPXDYMl0gFsQuXduYbvz6NR3X9eHPWGHvEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZceIzULg; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZceIzULg"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-202318c4f45so46630405ad.0;
        Mon, 26 Aug 2024 10:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724694093; x=1725298893; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bb3DPdn0pj3TNjeQ2c5ACYytiWwIREFsen47gNLgdCE=;
        b=ZceIzULguwXnNlmHrdN/Utxc4O/UEj97t7VVx7itFjHH6AaYxlZsZVpYVMwQg/N9/c
         lQy/RVi2IMnljw9uHqOsld4w1KPg1yiAQYXtexgMnVfKvFRkCIIaD1E/bJomQCF5inhf
         sYqDRkS3pVcpyXXbnPcPGwZWe/icMlHSQemyGF3Lo+7YENtOInj9Hk1s5RjmNDVuRoEx
         RzfHlmjB2gOocxWm+PVChYQhpUlUeAJIJC8VFllQOatJbw83f1A7suHKytpLHc/Q+CkK
         KPMw4qKYsigmx7Bjv6W/vYcoZK72OseUU4lNRBAwOgHlImnUBpN3BcB61npvwfg2BhkG
         IUgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724694093; x=1725298893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bb3DPdn0pj3TNjeQ2c5ACYytiWwIREFsen47gNLgdCE=;
        b=tDu4LqKUC0uvu8H32CdCleQO/xFdo2CviG3bYfZLSjAVvo2Yvqf9zqrs3y3CrYiTjS
         JZzrS+uP6iayxD7HJhXZKpbqA0Nt2D3L0Ct7w64PaCfXRrJ+YF9umPBrFT/ume3C8flX
         yk4akK7cgAVUFc4TvYnWMtlEmiJUkdRidsB8+oZEMlupgUTmGBn5Vt17jMl/XjIoEqx9
         PpIp3tDRo33fJPhaMS6YYNfrHiOaJ4F1H3fFIKuGK3xRU1v/iZoqFzOp1Kd5skjuLNfm
         u8kBSict4hS7PB8YxO/d+xgH3Llt/0RcdcENn/xu7SpaoD9hqOu7n0r69ynbnBqc8vUn
         JWAQ==
X-Forwarded-Encrypted: i=1; AJvYcCX59fJgz0kpv2OSE3a4QLeh66hBkcN8S4Xg5rPXORIbIgP89NKKKBslBRXmdxqYsUAeSTfftdlxzLFoTuE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyz//yxGp/s0/IGVzibs1E3fo6iyoh/y4zvpgL4aLz6fR/3eTRV
	7UxnxA2fpDRA6Vwb6qPjyEhPFFDhFfLiaR9yAHcRh5fIuszuZXvi
X-Google-Smtp-Source: AGHT+IHOU2+ySwRRTK3i0lx33XAgq/AJ2L3rvoi6nlp3xljwaszM/3uWo8aDPwZ+GwdYToH/zG1bow==
X-Received: by 2002:a17:903:11c3:b0:203:a116:7953 with SMTP id d9443c01a7336-204def2d5a1mr3812525ad.10.1724694093270;
        Mon, 26 Aug 2024 10:41:33 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855665besm70057055ad.34.2024.08.26.10.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 10:41:32 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] nilfs2: use common implementation of file type
Date: Tue, 27 Aug 2024 02:41:09 +0900
Message-Id: <20240826174116.5008-2-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240826174116.5008-1-konishi.ryusuke@gmail.com>
References: <20240826174116.5008-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Huang Xiaojia <huangxiaojia2@huawei.com>

Deduplicate the nilfs2 file type conversion implementation.

Link: https://lkml.kernel.org/r/20240815013442.1220909-1-huangxiaojia2@huawei.com
Signed-off-by: Huang Xiaojia <huangxiaojia2@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
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

