Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19150322DDA
	for <linux-nilfs@vger.kernel.org>; Tue, 23 Sep 2025 12:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758629470; cv=none; b=tfgK/foVcAFsHLo+hq52Mx4XeoKnvDX5QsCMqEoFor/WxmLz2rPSa6YRD3tkgwPw6E8pjfYyuz6aNqCZmqcQEJKG+OHbCmD5Jv0hNRRNzB7smCzCEQvx+9qRaAPe3pivXCuTnaZ/TsDot010rFG568PwAqAqJ8WX+R8q4a4Zpy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758629470; c=relaxed/simple;
	bh=pupVuKVSSsSH6WbeiLd/aEt9iE+EEzuwuV/NqzHt9L8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H3VPETwfFaN1Gb7ZsIj2izo/BpnZfwpITyhYb2EunyrEBqWkmEptW1Jtf6koJp8HTVXhvWkKQylwFnqpsZxGcNtxsvTGnAV9/KFMmQlL6xSrOVqGgPX29oXn1gFmE84AnPrwSiMVHiaFFUpAqG64dj6HS1Pq+YFpdP3F8t91DO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UOpCq16+; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UOpCq16+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758629454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EXG81w2yiTPmy42RDJc2BVgw2kG2Xq4jV9QbTgmImGE=;
	b=UOpCq16+RuIyyQrGJt6ecwmgMieSM42SrKkulNugtfl0+rrJ6OKw5OGcKTpq1UEUjiLBcA
	DXmCeCEHTTNWCvBhXltFPQFbmPd3fEykFdpPWB1Qi0YiXIBRhcSScIl/CR/33ybVrf6BNd
	HMlnDk1NajYxCPvF9y/6kC2PXJvXwms=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nilfs2: replace vmalloc + copy_from_user with vmemdup_user
Date: Tue, 23 Sep 2025 14:09:02 +0200
Message-ID: <20250923120902.1844458-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace vmalloc() followed by copy_from_user() with vmemdup_user() to
improve nilfs_ioctl_clean_segments() and nilfs_ioctl_set_suinfo(). Use
kvfree() to free the buffers created by vmemdup_user().

Use u64_to_user_ptr() instead of manually casting the pointers and
remove the obsolete 'out_free' label.

No functional changes intended.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/nilfs2/ioctl.c | 35 ++++++++++-------------------------
 1 file changed, 10 insertions(+), 25 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 3288c3b4be9e..e17b8da66491 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -49,7 +49,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 						   void *, size_t, size_t))
 {
 	void *buf;
-	void __user *base = (void __user *)(unsigned long)argv->v_base;
+	void __user *base = u64_to_user_ptr(argv->v_base);
 	size_t maxmembs, total, n;
 	ssize_t nr;
 	int ret, i;
@@ -836,7 +836,6 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 		sizeof(struct nilfs_bdesc),
 		sizeof(__u64),
 	};
-	void __user *base;
 	void *kbufs[5];
 	struct the_nilfs *nilfs;
 	size_t len, nsegs;
@@ -863,7 +862,7 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 	 * use kmalloc() for its buffer because the memory used for the
 	 * segment numbers is small enough.
 	 */
-	kbufs[4] = memdup_array_user((void __user *)(unsigned long)argv[4].v_base,
+	kbufs[4] = memdup_array_user(u64_to_user_ptr(argv[4].v_base),
 				     nsegs, sizeof(__u64));
 	if (IS_ERR(kbufs[4])) {
 		ret = PTR_ERR(kbufs[4]);
@@ -883,20 +882,14 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 			goto out_free;
 
 		len = argv[n].v_size * argv[n].v_nmembs;
-		base = (void __user *)(unsigned long)argv[n].v_base;
 		if (len == 0) {
 			kbufs[n] = NULL;
 			continue;
 		}
 
-		kbufs[n] = vmalloc(len);
-		if (!kbufs[n]) {
-			ret = -ENOMEM;
-			goto out_free;
-		}
-		if (copy_from_user(kbufs[n], base, len)) {
-			ret = -EFAULT;
-			vfree(kbufs[n]);
+		kbufs[n] = vmemdup_user(u64_to_user_ptr(argv[n].v_base), len);
+		if (IS_ERR(kbufs[n])) {
+			ret = PTR_ERR(kbufs[n]);
 			goto out_free;
 		}
 	}
@@ -928,7 +921,7 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 
 out_free:
 	while (--n >= 0)
-		vfree(kbufs[n]);
+		kvfree(kbufs[n]);
 	kfree(kbufs[4]);
 out:
 	mnt_drop_write_file(filp);
@@ -1181,7 +1174,6 @@ static int nilfs_ioctl_set_suinfo(struct inode *inode, struct file *filp,
 	struct nilfs_transaction_info ti;
 	struct nilfs_argv argv;
 	size_t len;
-	void __user *base;
 	void *kbuf;
 	int ret;
 
@@ -1212,18 +1204,12 @@ static int nilfs_ioctl_set_suinfo(struct inode *inode, struct file *filp,
 		goto out;
 	}
 
-	base = (void __user *)(unsigned long)argv.v_base;
-	kbuf = vmalloc(len);
-	if (!kbuf) {
-		ret = -ENOMEM;
+	kbuf = vmemdup_user(u64_to_user_ptr(argv.v_base), len);
+	if (IS_ERR(kbuf)) {
+		ret = PTR_ERR(kbuf);
 		goto out;
 	}
 
-	if (copy_from_user(kbuf, base, len)) {
-		ret = -EFAULT;
-		goto out_free;
-	}
-
 	nilfs_transaction_begin(inode->i_sb, &ti, 0);
 	ret = nilfs_sufile_set_suinfo(nilfs->ns_sufile, kbuf, argv.v_size,
 			argv.v_nmembs);
@@ -1232,8 +1218,7 @@ static int nilfs_ioctl_set_suinfo(struct inode *inode, struct file *filp,
 	else
 		nilfs_transaction_commit(inode->i_sb); /* never fails */
 
-out_free:
-	vfree(kbuf);
+	kvfree(kbuf);
 out:
 	mnt_drop_write_file(filp);
 	return ret;
-- 
2.51.0

