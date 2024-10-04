Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3631425634;
	Fri,  4 Oct 2024 03:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728013024; cv=none; b=FJgxcYrsWhgh3M9Ci9Yu5heLaqLiri0AHseUxGMdlKJSh3Wv5uRm5PKABlBVNlyctvocpUijD7d4zeiuDxSMcLoR440AjKMyAh2fU3AdiBD/Bvodg+EmMO6fXpERcRcF83JFtjio92NX/2yfxSrfzo48QWQJ+CH4gBe6CRzX6wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728013024; c=relaxed/simple;
	bh=oW4b3EvSyn6bepw4Y0R00dFFZFITs5yFoJWOgkvyNzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EeV/jF5aoW5UxoKSvamAYMMvXxwTPCPtAW2FPiuAcnpRluGZhy24FJcPhJWtaDIDTbc0F82+Tfz24psxoN1G64ajy+vzIdPJt5Tp/z0/ZX2wEjcVHUEyRvH44tejyaw35BUlFGGipAjgC7iq5x9NPMK7jcuobJq3/dPV8DyK76E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dv0rySX9; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dv0rySX9"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20b5affde14so12814185ad.3;
        Thu, 03 Oct 2024 20:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728013022; x=1728617822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=POyoxMylXx/CSfqjOxKP25qMOTpzg8rWRjeX6gOnqg8=;
        b=dv0rySX9Q4b969jgXXMamTEJb+xz+qE8VBCW00wFYGmPxUNoeWG2ceuTxjLq5+OFGU
         ZnPc3sHl6uOWu+1doyCYSgE1dnQwuRtwf6/+oLMZqZPtLS5L+eGGY4ALXmUmnxbvroZw
         kzd7vCPxz48kiMI1A84KueDwAd1LLlqozdGTBjjG2YArMz+udyQqVu6Ab2mCQgOgTD48
         WlsFhSimluhhHFCEpRILR4OAjc9X21WgYrEdgVjCsi2Oe+yNGe+nJF7FTfCLoHkflW03
         U8f8exEDYnux9AZHFp97O9IUP8OuUgJnE9cgX0x/wnm6BVRnPxKX7C01bwBVP/aF4pOF
         gYsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728013022; x=1728617822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=POyoxMylXx/CSfqjOxKP25qMOTpzg8rWRjeX6gOnqg8=;
        b=ZDKTbzvxHKCVc77U4040JiSQjXjUklz0UieRNX9BPhX6Nf80nVMPFI/tKHqAd4Iib+
         zeCuwhyNMIPfv0XkzP5v7DznxHQFyArdsYmM3wN8JzOd+b3kjBfJuI3X9W21JH/gRKt6
         52DSmeSN8UiCQMCPPJcq1P9ONgutKVMzTkJsBicgHqQjiR6KJxXsxjDo3dF7V6Fv/e6D
         CcurScxuTjAUGZSrYyVOLRPaYWCi3oz+EuaKcqlOQcpsa1j4m7PBWFYAk3NVdM9x+31+
         nre5vjFtsa2QfBAcX6qDoaDVtHRlE+Qzn1/yMV3ZgfArPjeGNR+qUHAaPIlE6lqOgFTt
         f5Ow==
X-Forwarded-Encrypted: i=1; AJvYcCV6vPBz4yYx5UgsW+lbsi2lLtqMXS5PeIuoa5/w2KWIYQ9+rYHS+S6Q4efFf3zoSEE2heHxXw+9PWbGHFk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKL6eqdHNEN4JfxpgPNE1jLvq7qaEq7ROFkr17nJzBr3XvMaG9
	pseCXzTvpAxKgLajiZlMAP3xvNGp+/J7UYCtC+B1A4CRczsglMGV
X-Google-Smtp-Source: AGHT+IFmuH+gMz679FaNSXu4HbP23rysetDoDIUxTajDlOArlSI7leWpb85K0CcNEPdzY1yn75etxQ==
X-Received: by 2002:a17:903:22d2:b0:20b:fd73:32bb with SMTP id d9443c01a7336-20bfdf80104mr20905635ad.2.1728013022241;
        Thu, 03 Oct 2024 20:37:02 -0700 (PDT)
Received: from carrot.. (i220-109-180-47.s41.a014.ap.plala.or.jp. [220.109.180.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20beeca14a6sm15976125ad.86.2024.10.03.20.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 20:37:01 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	syzbot <syzbot+8a192e8d090fa9a31135@syzkaller.appspotmail.com>,
	syzkaller-bugs@googlegroups.com,
	LKML <linux-kernel@vger.kernel.org>,
	Lizhi Xu <lizhi.xu@windriver.com>
Subject: [PATCH] nilfs2: propagate directory read errors from nilfs_find_entry()
Date: Fri,  4 Oct 2024 12:35:31 +0900
Message-ID: <20241004033640.6841-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <66f59678.050a0220.46d20.0001.GAE@google.com>
References: <66f59678.050a0220.46d20.0001.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot reported that a task hang occurs in vcs_open() during a fuzzing
test for nilfs2.

The root cause of this problem is that in nilfs_find_entry(), which
searches for directory entries, ignores errors when loading a
directory page/folio via nilfs_get_folio() fails.

If the filesystem images is corrupted, and the i_size of the directory
inode is large, and the directory page/folio is successfully read but
fails the sanity check, for example when it is zero-filled,
nilfs_check_folio() may continue to spit out error messages in bursts.

Fix this issue by propagating the error to the callers when loading a
page/folio fails in nilfs_find_entry().

The current interface of nilfs_find_entry() and its callers is
outdated and cannot propagate error codes such as -EIO and -ENOMEM
returned via nilfs_find_entry(), so fix it together.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: Lizhi Xu <lizhi.xu@windriver.com>
Closes: https://lkml.kernel.org/r/20240927013806.3577931-1-lizhi.xu@windriver.com
Reported-by: syzbot+8a192e8d090fa9a31135@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8a192e8d090fa9a31135
Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
Cc: stable@vger.kernel.org
---
Hi Andrew, please apply this as a bug fix.

This fixes a flaw in nilfs2's directory lookup error handling that was
the root cause of the vcs hang issue recently reported by syzbot.

Thanks,
Ryusuke Konishi

 fs/nilfs2/dir.c   | 48 ++++++++++++++++++++++++-----------------------
 fs/nilfs2/namei.c | 39 +++++++++++++++++++++++++-------------
 fs/nilfs2/nilfs.h |  2 +-
 3 files changed, 52 insertions(+), 37 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index fe5b1a30c509..a8602729586a 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -289,7 +289,7 @@ static int nilfs_readdir(struct file *file, struct dir_context *ctx)
  * The folio is mapped and unlocked.  When the caller is finished with
  * the entry, it should call folio_release_kmap().
  *
- * On failure, returns NULL and the caller should ignore foliop.
+ * On failure, returns an error pointer and the caller should ignore foliop.
  */
 struct nilfs_dir_entry *nilfs_find_entry(struct inode *dir,
 		const struct qstr *qstr, struct folio **foliop)
@@ -312,22 +312,24 @@ struct nilfs_dir_entry *nilfs_find_entry(struct inode *dir,
 	do {
 		char *kaddr = nilfs_get_folio(dir, n, foliop);
 
-		if (!IS_ERR(kaddr)) {
-			de = (struct nilfs_dir_entry *)kaddr;
-			kaddr += nilfs_last_byte(dir, n) - reclen;
-			while ((char *) de <= kaddr) {
-				if (de->rec_len == 0) {
-					nilfs_error(dir->i_sb,
-						"zero-length directory entry");
-					folio_release_kmap(*foliop, kaddr);
-					goto out;
-				}
-				if (nilfs_match(namelen, name, de))
-					goto found;
-				de = nilfs_next_entry(de);
+		if (IS_ERR(kaddr))
+			return ERR_CAST(kaddr);
+
+		de = (struct nilfs_dir_entry *)kaddr;
+		kaddr += nilfs_last_byte(dir, n) - reclen;
+		while ((char *)de <= kaddr) {
+			if (de->rec_len == 0) {
+				nilfs_error(dir->i_sb,
+					    "zero-length directory entry");
+				folio_release_kmap(*foliop, kaddr);
+				goto out;
 			}
-			folio_release_kmap(*foliop, kaddr);
+			if (nilfs_match(namelen, name, de))
+				goto found;
+			de = nilfs_next_entry(de);
 		}
+		folio_release_kmap(*foliop, kaddr);
+
 		if (++n >= npages)
 			n = 0;
 		/* next folio is past the blocks we've got */
@@ -340,7 +342,7 @@ struct nilfs_dir_entry *nilfs_find_entry(struct inode *dir,
 		}
 	} while (n != start);
 out:
-	return NULL;
+	return ERR_PTR(-ENOENT);
 
 found:
 	ei->i_dir_start_lookup = n;
@@ -384,18 +386,18 @@ struct nilfs_dir_entry *nilfs_dotdot(struct inode *dir, struct folio **foliop)
 	return NULL;
 }
 
-ino_t nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr)
+int nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr, ino_t *ino)
 {
-	ino_t res = 0;
 	struct nilfs_dir_entry *de;
 	struct folio *folio;
 
 	de = nilfs_find_entry(dir, qstr, &folio);
-	if (de) {
-		res = le64_to_cpu(de->inode);
-		folio_release_kmap(folio, de);
-	}
-	return res;
+	if (IS_ERR(de))
+		return PTR_ERR(de);
+
+	*ino = le64_to_cpu(de->inode);
+	folio_release_kmap(folio, de);
+	return 0;
 }
 
 void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index c950139db6ef..4905063790c5 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -55,12 +55,20 @@ nilfs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 {
 	struct inode *inode;
 	ino_t ino;
+	int res;
 
 	if (dentry->d_name.len > NILFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	ino = nilfs_inode_by_name(dir, &dentry->d_name);
-	inode = ino ? nilfs_iget(dir->i_sb, NILFS_I(dir)->i_root, ino) : NULL;
+	res = nilfs_inode_by_name(dir, &dentry->d_name, &ino);
+	if (res) {
+		if (res != -ENOENT)
+			return ERR_PTR(res);
+		inode = NULL;
+	} else {
+		inode = nilfs_iget(dir->i_sb, NILFS_I(dir)->i_root, ino);
+	}
+
 	return d_splice_alias(inode, dentry);
 }
 
@@ -263,10 +271,11 @@ static int nilfs_do_unlink(struct inode *dir, struct dentry *dentry)
 	struct folio *folio;
 	int err;
 
-	err = -ENOENT;
 	de = nilfs_find_entry(dir, &dentry->d_name, &folio);
-	if (!de)
+	if (IS_ERR(de)) {
+		err = PTR_ERR(de);
 		goto out;
+	}
 
 	inode = d_inode(dentry);
 	err = -EIO;
@@ -362,10 +371,11 @@ static int nilfs_rename(struct mnt_idmap *idmap,
 	if (unlikely(err))
 		return err;
 
-	err = -ENOENT;
 	old_de = nilfs_find_entry(old_dir, &old_dentry->d_name, &old_folio);
-	if (!old_de)
+	if (IS_ERR(old_de)) {
+		err = PTR_ERR(old_de);
 		goto out;
+	}
 
 	if (S_ISDIR(old_inode->i_mode)) {
 		err = -EIO;
@@ -382,10 +392,12 @@ static int nilfs_rename(struct mnt_idmap *idmap,
 		if (dir_de && !nilfs_empty_dir(new_inode))
 			goto out_dir;
 
-		err = -ENOENT;
-		new_de = nilfs_find_entry(new_dir, &new_dentry->d_name, &new_folio);
-		if (!new_de)
+		new_de = nilfs_find_entry(new_dir, &new_dentry->d_name,
+					  &new_folio);
+		if (IS_ERR(new_de)) {
+			err = PTR_ERR(new_de);
 			goto out_dir;
+		}
 		nilfs_set_link(new_dir, new_de, new_folio, old_inode);
 		folio_release_kmap(new_folio, new_de);
 		nilfs_mark_inode_dirty(new_dir);
@@ -440,12 +452,13 @@ static int nilfs_rename(struct mnt_idmap *idmap,
  */
 static struct dentry *nilfs_get_parent(struct dentry *child)
 {
-	unsigned long ino;
+	ino_t ino;
+	int res;
 	struct nilfs_root *root;
 
-	ino = nilfs_inode_by_name(d_inode(child), &dotdot_name);
-	if (!ino)
-		return ERR_PTR(-ENOENT);
+	res = nilfs_inode_by_name(d_inode(child), &dotdot_name, &ino);
+	if (res)
+		return ERR_PTR(res);
 
 	root = NILFS_I(d_inode(child))->i_root;
 
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index fb1c4c5bae7c..45d03826eaf1 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -254,7 +254,7 @@ static inline __u32 nilfs_mask_flags(umode_t mode, __u32 flags)
 
 /* dir.c */
 int nilfs_add_link(struct dentry *, struct inode *);
-ino_t nilfs_inode_by_name(struct inode *, const struct qstr *);
+int nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr, ino_t *ino);
 int nilfs_make_empty(struct inode *, struct inode *);
 struct nilfs_dir_entry *nilfs_find_entry(struct inode *, const struct qstr *,
 		struct folio **);
-- 
2.43.0

