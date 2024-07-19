Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55AF5CB8
	for <linux-nilfs@vger.kernel.org>; Fri, 19 Jul 2024 09:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721380356; cv=none; b=N/X45l0w3XdpCfWu5tQBW1uT4CLvEX5iyzrzlf6XKft4J7n77WwtojjFKiCRJyLbK905psD/Fq9r66yX99n6ddsH6LKSJ4S9JMYSb75GypStA3DhaFZ3f+AyF7fc8LQ3WAYkkUmor3uKiyEnVHOaOySSgg3o+LZsEO3r1F6XEDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721380356; c=relaxed/simple;
	bh=asB0fnGZ8IJPTxdI2Ori0S0B0jmTGiRzQVEajEXN+h0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pEbL3+Ec0Tf9Qy3Nqv8qMY+g783p6bDa8nn1tTK4LOV/q0+vm3Lvy/CKZ+OZYaRu0WHrOh5SKOJY6o3UP2qOkjEapkL0Tc/l0VW7o8mhTrOKDxCedzXpV2nn3s3Wlt+RESv2DWctkmgtFbxDGa0RZZb4Z81XaDpsF0OUoAdaJ30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WQP3X6s52zQmGL
	for <linux-nilfs@vger.kernel.org>; Fri, 19 Jul 2024 17:08:24 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 9734A18007C
	for <linux-nilfs@vger.kernel.org>; Fri, 19 Jul 2024 17:12:30 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 19 Jul
 2024 17:12:30 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <konishi.ryusuke@gmail.com>
CC: <linux-nilfs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH] nilfs2: support ->tmpfile()
Date: Fri, 19 Jul 2024 17:17:25 +0800
Message-ID: <20240719091725.1877001-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500022.china.huawei.com (7.185.36.66)

Add function nilfs2_tmpfile to support O_TMPFILE file creation.

tmpfile testcases(generic/(004,389,509,530,531) except
generic/389,530 (need acl and shutdown supported) now run/pass.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/nilfs2/namei.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index c950139db6ef..a36667d7a5e8 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -125,6 +125,36 @@ nilfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	return err;
 }
 
+static int nilfs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
+			struct file *file, umode_t mode)
+{
+	struct inode *inode;
+	struct nilfs_transaction_info ti;
+	int err;
+
+	err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
+	if (err)
+		return err;
+
+	inode = nilfs_new_inode(dir, mode);
+	err = PTR_ERR(inode);
+	if (!IS_ERR(inode)) {
+		inode->i_op = &nilfs_file_inode_operations;
+		inode->i_fop = &nilfs_file_operations;
+		inode->i_mapping->a_ops = &nilfs_aops;
+		nilfs_mark_inode_dirty(inode);
+		d_tmpfile(file, inode);
+		unlock_new_inode(inode);
+		err = 0;
+	}
+	if (!err)
+		err = nilfs_transaction_commit(dir->i_sb);
+	else
+		nilfs_transaction_abort(dir->i_sb);
+
+	return finish_open_simple(file, err);
+}
+
 static int nilfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 			 struct dentry *dentry, const char *symname)
 {
@@ -544,6 +574,7 @@ const struct inode_operations nilfs_dir_inode_operations = {
 	.mkdir		= nilfs_mkdir,
 	.rmdir		= nilfs_rmdir,
 	.mknod		= nilfs_mknod,
+	.tmpfile	= nilfs_tmpfile,
 	.rename		= nilfs_rename,
 	.setattr	= nilfs_setattr,
 	.permission	= nilfs_permission,
-- 
2.34.1

