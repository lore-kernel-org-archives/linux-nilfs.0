Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6453FD139
	for <linux-nilfs@vger.kernel.org>; Mon, 10 Aug 2026 17:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786384143; cv=none; b=AMmkb9l90bUfUORd792RDz5rt7xvqS9vVdZSY6evBkmlIBUhRQ68fK1XFWCzGMp4ZGkOha0IoWkm9OKXWM4EzaRSj0r2nhBNbIcyXi4Zs2t19d2kyWc+QpdRnlvsod+U9oxUb5cSVoFL0Mu/IefKOYLzoj18gyT/NZAjYSByfrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786384143; c=relaxed/simple;
	bh=l2WP9jK4NJUTg17Pf7vhJC4ZkPcmmWylStbJhvAYoCo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BezThs8lfce1tF0MXUCGW7IVLBD85M8qisIZOmQHcjtJSUvsbtESa785keIa7zYzwafAmji0VXRfpWStMBClou/iuwPqluXokaW21GMaE6lWhvuhgEMIz4RYpyLlslsRVBWDBeUp7qGYbnFk1xq9izeBNvmrgoCcEXZG8PZfPzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a6T6U8V8; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a6T6U8V8"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ceaf8a1265so34115845ad.2
        for <linux-nilfs@vger.kernel.org>; Mon, 10 Aug 2026 10:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786384141; x=1786988941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=O8C1Yzr46JnQ3hNdmp0axbzJX92c4EDQwWg5NpDaskA=;
        b=a6T6U8V85ywj3apkyjMvbnP0eq3oQ4k2FVxVHijq0ZvDfY6PflUhxk0kdKtUgbLsxr
         tnRu1CuGW5ZSxM5s3GiQyB7i4FByFUvtndtOyWqyyIA97Zy+fAzuoz/Sj9abGtbhaDSe
         B/uWCSqj1OOliwXEpHjxa99ll/yJC/Ob4T3QbGRXSIXShRQVsPOVydfYRVX5JhJYZRwz
         6euu7PZ8xNx0t+wgHuHYTm6AODdmb8NpJ2nf9FCM3u18wc2fJo4A+EYrX8nibqM7qm0C
         f+zGbFSnPMTMFs8Lkiz1A2KG22hKM3IvuY2N6rhsEMP94y26CLNOjX2D86n5VK+jhYYH
         1h+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786384141; x=1786988941;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O8C1Yzr46JnQ3hNdmp0axbzJX92c4EDQwWg5NpDaskA=;
        b=YG9lcn8LHqfmOTc0J4Yq6i6SqNfr0/56fBLa1neMsDmdcsHnbVZhTlewd35JI6vW+v
         3Aukv5ltftr1qP7mihb25row3E1bK+x3sK/akxI3wDIawc3RpY9hUBGh/1KGW+em1vy+
         elSsJCWLS55zWi2/UWdaaEIHKiVKgof12U4QwFTO1Pq1jeDc8wdrUDF0awwu/9mi0cFW
         RVrt1sfQZke7d0KyUtRdeLrqFC094aB8xnp2D86zWqtvWE/DFy4IuMzy1RQY1VxcaHb6
         LsuYMuGMuEtNMB192qMvSJSEKnkwm9fNMvuawK3d9r3RTSO7SfgE/acW8bwY0zfD9B60
         P7CQ==
X-Gm-Message-State: AOJu0Yx01mx9cBywJAYyORqj5i7APyMm3WFw6aVAVCFLQYTgtsYc/PFa
	5YjIz4atDGLKJXciQdMWFHmBRPAlmP0rf5fn6cRASVZUSPbCvLEoxUQI
X-Gm-Gg: AR+sD12INLfyGsrzb+2In7vCdJX25spAIKlAD6sQAi8Lw1FVkTnhnpyATbiio886zi+
	Dj8SjbDiJ2Wmh8hwH1tdCPYJ04w0Csg6d0hg8U+ofGlTnyAEGvgLrl5H1QT4Zl/P/lsdxXTpKkW
	9LO2mboxQUA1mgMIrWY9ZceWmmi12KLH46/nWlCxCbFHubuXW0DCXiKJaI5YXF5KMavQnUKB/wo
	w8Jn6JizktIuvW6jvEWNUk5CUjWg5U9T8tiDlrWwOkxT00aPkQ9ID3k+9S2Udic6S2kB7P1/8Kb
	J6CHJoDjIooLQrX/39mAAbatCC0eT+bwpkoJHpA8M7B0EoFTeR4L8A5LtXAgEH1r1xAolTYjj5V
	a9j3ZKAVRL1ND++jDUpxsk/zSjrrR5R7nhnekHnBRFD6PmeOk3VGlAVKkMvj9MovasMkXBKoKk3
	obewLx0xIKMAcUAFSxxM+P7ITbFGYIzzBydqoGfO+XlNw1GgFVStikagjYimio7/6h1ZYFaO38/
	BlyHk/4lrmzoNXhtoxSWh0WClGdHtJg
X-Received: by 2002:a17:902:fd88:b0:2ca:619f:9733 with SMTP id d9443c01a7336-2d30035b670mr38736395ad.17.1786384140737;
        Mon, 10 Aug 2026 10:49:00 -0700 (PDT)
Received: from carrot.taila25129.ts.net (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d14dbeeda6sm39180005ad.42.2026.08.10.10.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 10:48:59 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] nilfs2: standardize the inode number type to u64
Date: Tue, 11 Aug 2026 02:48:18 +0900
Message-ID: <20260810174857.74995-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Variables handling inode numbers - such as the 'i_ino' member of the
inode structure - have been converted to 'u64' within the kernel to
ensure consistency.  However, some parts of the nilfs2 implementation
still use 'ino_t' or 'unsigned long' - both of which are
architecture-dependent types - to handle inode numbers.

Replace those remaining instances of 'ino_t' or 'unsigned long' with
'u64'.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Hi Viacheslav,

Please apply this for the next cycle.

Following the treewide conversion of inode numbers to 64-bit, this
cleans up the remaining architecture-dependent types in the nilfs2
implementation, standardizing them to 'u64'.

Thanks,
Ryusuke Konishi

 fs/nilfs2/dir.c      | 11 +++++------
 fs/nilfs2/ifile.c    | 13 ++++++-------
 fs/nilfs2/ifile.h    | 10 ++++++----
 fs/nilfs2/inode.c    | 24 +++++++++++-------------
 fs/nilfs2/ioctl.c    |  2 +-
 fs/nilfs2/namei.c    |  6 +++---
 fs/nilfs2/nilfs.h    | 15 +++++++--------
 fs/nilfs2/page.c     |  9 ++++-----
 fs/nilfs2/recovery.c |  4 ++--
 fs/nilfs2/segment.c  |  2 +-
 10 files changed, 46 insertions(+), 50 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 3653db5cdb65..8b53802b6ebd 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -169,17 +169,16 @@ static bool nilfs_check_folio(struct folio *folio, char *kaddr)
 	error = "disallowed inode number";
 bad_entry:
 	nilfs_error(sb,
-		    "bad entry in directory #%llu: %s - offset=%lu, inode=%lu, rec_len=%zd, name_len=%d",
+		    "bad entry in directory #%llu: %s - offset=%lu, inode=%llu, rec_len=%zd, name_len=%d",
 		    dir->i_ino, error, (folio->index << PAGE_SHIFT) + offs,
-		    (unsigned long)le64_to_cpu(p->inode),
-		    rec_len, p->name_len);
+		    le64_to_cpu(p->inode), rec_len, p->name_len);
 	goto fail;
 Eend:
 	p = (struct nilfs_dir_entry *)(kaddr + offs);
 	nilfs_error(sb,
-		    "entry in directory #%llu spans the page boundary offset=%lu, inode=%lu",
+		    "entry in directory #%llu spans the page boundary offset=%lu, inode=%llu",
 		    dir->i_ino, (folio->index << PAGE_SHIFT) + offs,
-		    (unsigned long)le64_to_cpu(p->inode));
+		    le64_to_cpu(p->inode));
 fail:
 	return false;
 }
@@ -387,7 +386,7 @@ struct nilfs_dir_entry *nilfs_dotdot(struct inode *dir, struct folio **foliop)
 	return NULL;
 }
 
-int nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr, ino_t *ino)
+int nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr, u64 *ino)
 {
 	struct nilfs_dir_entry *de;
 	struct folio *folio;
diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index 99eb8a59009e..c99e1e6356ae 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -49,7 +49,7 @@ static inline struct nilfs_ifile_info *NILFS_IFILE_I(struct inode *ifile)
  * * %-ENOMEM	- Insufficient memory available.
  * * %-ENOSPC	- No inode left.
  */
-int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
+int nilfs_ifile_create_inode(struct inode *ifile, u64 *out_ino,
 			     struct buffer_head **out_bh)
 {
 	struct nilfs_palloc_req req;
@@ -72,7 +72,7 @@ int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
 	nilfs_palloc_commit_alloc_entry(ifile, &req);
 	mark_buffer_dirty(req.pr_entry_bh);
 	nilfs_mdt_mark_dirty(ifile);
-	*out_ino = (ino_t)req.pr_entry_nr;
+	*out_ino = req.pr_entry_nr;
 	*out_bh = req.pr_entry_bh;
 	return 0;
 }
@@ -88,7 +88,7 @@ int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
  * * %-ENOENT	- Inode number unallocated.
  * * %-ENOMEM	- Insufficient memory available.
  */
-int nilfs_ifile_delete_inode(struct inode *ifile, ino_t ino)
+int nilfs_ifile_delete_inode(struct inode *ifile, u64 ino)
 {
 	struct nilfs_palloc_req req = {
 		.pr_entry_nr = ino, .pr_entry_bh = NULL
@@ -123,21 +123,20 @@ int nilfs_ifile_delete_inode(struct inode *ifile, ino_t ino)
 	return 0;
 }
 
-int nilfs_ifile_get_inode_block(struct inode *ifile, ino_t ino,
+int nilfs_ifile_get_inode_block(struct inode *ifile, u64 ino,
 				struct buffer_head **out_bh)
 {
 	struct super_block *sb = ifile->i_sb;
 	int err;
 
 	if (unlikely(!NILFS_VALID_INODE(sb, ino))) {
-		nilfs_error(sb, "bad inode number: %lu", (unsigned long)ino);
+		nilfs_error(sb, "bad inode number: %llu", ino);
 		return -EINVAL;
 	}
 
 	err = nilfs_palloc_get_entry_block(ifile, ino, 0, out_bh);
 	if (unlikely(err))
-		nilfs_warn(sb, "error %d reading inode: ino=%lu",
-			   err, (unsigned long)ino);
+		nilfs_warn(sb, "error %d reading inode: ino=%llu", err, ino);
 	return err;
 }
 
diff --git a/fs/nilfs2/ifile.h b/fs/nilfs2/ifile.h
index 5d116a566d9e..d38a46f5ae41 100644
--- a/fs/nilfs2/ifile.h
+++ b/fs/nilfs2/ifile.h
@@ -19,7 +19,7 @@
 
 
 static inline struct nilfs_inode *
-nilfs_ifile_map_inode(struct inode *ifile, ino_t ino, struct buffer_head *ibh)
+nilfs_ifile_map_inode(struct inode *ifile, u64 ino, struct buffer_head *ibh)
 {
 	size_t __offset_in_folio = nilfs_palloc_entry_offset(ifile, ino, ibh);
 
@@ -31,9 +31,11 @@ static inline void nilfs_ifile_unmap_inode(struct nilfs_inode *raw_inode)
 	kunmap_local(raw_inode);
 }
 
-int nilfs_ifile_create_inode(struct inode *, ino_t *, struct buffer_head **);
-int nilfs_ifile_delete_inode(struct inode *, ino_t);
-int nilfs_ifile_get_inode_block(struct inode *, ino_t, struct buffer_head **);
+int nilfs_ifile_create_inode(struct inode *ifile, u64 *out_ino,
+			struct buffer_head **out_bh);
+int nilfs_ifile_delete_inode(struct inode *ifile, u64 ino);
+int nilfs_ifile_get_inode_block(struct inode *ifile, u64 ino,
+				struct buffer_head **out_bh);
 
 int nilfs_ifile_count_free_inodes(struct inode *, u64 *, u64 *);
 
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 51f7e125a311..34e6096069ad 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -287,8 +287,7 @@ const struct address_space_operations nilfs_buffer_cache_aops = {
 };
 
 static int nilfs_insert_inode_locked(struct inode *inode,
-				     struct nilfs_root *root,
-				     unsigned long ino)
+				struct nilfs_root *root, u64 ino)
 {
 	struct nilfs_iget_args args = {
 		.ino = ino, .root = root, .cno = 0, .type = NILFS_I_TYPE_NORMAL
@@ -305,7 +304,7 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	struct nilfs_root *root;
 	struct buffer_head *bh;
 	int err = -ENOMEM;
-	ino_t ino;
+	u64 ino;
 
 	inode = new_inode(sb);
 	if (unlikely(!inode))
@@ -443,7 +442,7 @@ int nilfs_read_inode_common(struct inode *inode,
 }
 
 static int __nilfs_read_inode(struct super_block *sb,
-			      struct nilfs_root *root, unsigned long ino,
+			      struct nilfs_root *root, u64 ino,
 			      struct inode *inode)
 {
 	struct the_nilfs *nilfs = sb->s_fs_info;
@@ -482,8 +481,8 @@ static int __nilfs_read_inode(struct super_block *sb,
 			huge_decode_dev(le64_to_cpu(raw_inode->i_device_code)));
 	} else {
 		nilfs_error(sb,
-			    "invalid file type bits in mode 0%o for inode %lu",
-			    inode->i_mode, ino);
+			"invalid file type bits in mode 0%o for inode %llu",
+			inode->i_mode, ino);
 		err = -EIO;
 		goto failed_unmap;
 	}
@@ -533,7 +532,7 @@ static int nilfs_iget_set(struct inode *inode, void *opaque)
 }
 
 struct inode *nilfs_ilookup(struct super_block *sb, struct nilfs_root *root,
-			    unsigned long ino)
+			    u64 ino)
 {
 	struct nilfs_iget_args args = {
 		.ino = ino, .root = root, .cno = 0, .type = NILFS_I_TYPE_NORMAL
@@ -542,8 +541,8 @@ struct inode *nilfs_ilookup(struct super_block *sb, struct nilfs_root *root,
 	return ilookup5(sb, ino, nilfs_iget_test, &args);
 }
 
-struct inode *nilfs_iget_locked(struct super_block *sb, struct nilfs_root *root,
-				unsigned long ino)
+struct inode *nilfs_iget_locked(struct super_block *sb,
+				struct nilfs_root *root, u64 ino)
 {
 	struct nilfs_iget_args args = {
 		.ino = ino, .root = root, .cno = 0, .type = NILFS_I_TYPE_NORMAL
@@ -553,7 +552,7 @@ struct inode *nilfs_iget_locked(struct super_block *sb, struct nilfs_root *root,
 }
 
 struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root *root,
-			 unsigned long ino)
+			 u64 ino)
 {
 	struct inode *inode;
 	int err;
@@ -579,8 +578,7 @@ struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root *root,
 	return inode;
 }
 
-struct inode *nilfs_iget_for_gc(struct super_block *sb, unsigned long ino,
-				__u64 cno)
+struct inode *nilfs_iget_for_gc(struct super_block *sb, u64 ino, __u64 cno)
 {
 	struct nilfs_iget_args args = {
 		.ino = ino, .root = NULL, .cno = cno, .type = NILFS_I_TYPE_GC
@@ -740,7 +738,7 @@ void nilfs_write_inode_common(struct inode *inode,
 
 void nilfs_update_inode(struct inode *inode, struct buffer_head *ibh, int flags)
 {
-	ino_t ino = inode->i_ino;
+	u64 ino = inode->i_ino;
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 	struct inode *ifile = ii->i_root->ifile;
 	struct nilfs_inode *raw_inode;
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 0957316e58b8..01a04080ef70 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -612,7 +612,7 @@ static int nilfs_ioctl_move_blocks(struct super_block *sb,
 	struct nilfs_vdesc *vdesc;
 	struct buffer_head *bh, *n;
 	LIST_HEAD(buffers);
-	ino_t ino;
+	u64 ino;
 	__u64 cno;
 	int i, ret;
 
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index e2fe95de3d71..6a482da7c682 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -54,7 +54,7 @@ static struct dentry *
 nilfs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 {
 	struct inode *inode;
-	ino_t ino;
+	u64 ino;
 	int res;
 
 	if (dentry->d_name.len > NILFS_NAME_LEN)
@@ -69,7 +69,7 @@ nilfs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 		inode = nilfs_iget(dir->i_sb, NILFS_I(dir)->i_root, ino);
 		if (inode == ERR_PTR(-ESTALE)) {
 			nilfs_error(dir->i_sb,
-					"deleted inode referenced: %lu", ino);
+				"deleted inode referenced: %llu", ino);
 			return ERR_PTR(-EIO);
 		}
 	}
@@ -463,7 +463,7 @@ static int nilfs_rename(struct mnt_idmap *idmap,
  */
 static struct dentry *nilfs_get_parent(struct dentry *child)
 {
-	ino_t ino;
+	u64 ino;
 	int res;
 	struct nilfs_root *root;
 
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index b7e3d91b6243..4fc42d3787a4 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -144,7 +144,7 @@ enum {
 	 ((ino) < NILFS_USER_INO && (NILFS_SYS_INO_BITS & BIT(ino))))
 
 #define NILFS_PRIVATE_INODE(ino) ({					\
-	ino_t __ino = (ino);						\
+	u64 __ino = (ino);						\
 	((__ino) < NILFS_USER_INO && (__ino) != NILFS_ROOT_INO &&	\
 	 (__ino) != NILFS_SKETCH_INO); })
 
@@ -255,7 +255,7 @@ static inline __u32 nilfs_mask_flags(umode_t mode, __u32 flags)
 
 /* dir.c */
 int nilfs_add_link(struct dentry *, struct inode *);
-int nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr, ino_t *ino);
+int nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr, u64 *ino);
 int nilfs_make_empty(struct inode *, struct inode *);
 struct nilfs_dir_entry *nilfs_find_entry(struct inode *, const struct qstr *,
 		struct folio **);
@@ -287,13 +287,12 @@ extern int nilfs_read_inode_common(struct inode *, struct nilfs_inode *);
 void nilfs_write_inode_common(struct inode *inode,
 			      struct nilfs_inode *raw_inode);
 struct inode *nilfs_ilookup(struct super_block *sb, struct nilfs_root *root,
-			    unsigned long ino);
-struct inode *nilfs_iget_locked(struct super_block *sb, struct nilfs_root *root,
-				unsigned long ino);
+			    u64 ino);
+struct inode *nilfs_iget_locked(struct super_block *sb,
+				struct nilfs_root *root, u64 ino);
 struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root *root,
-			 unsigned long ino);
-extern struct inode *nilfs_iget_for_gc(struct super_block *sb,
-				       unsigned long ino, __u64 cno);
+			 u64 ino);
+struct inode *nilfs_iget_for_gc(struct super_block *sb, u64 ino, __u64 cno);
 int nilfs_attach_btree_node_cache(struct inode *inode);
 void nilfs_detach_btree_node_cache(struct inode *inode);
 struct inode *nilfs_iget_for_shadow(struct inode *inode);
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 1d00bce21c37..cf4f1c6798f5 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -154,7 +154,7 @@ void nilfs_folio_bug(struct folio *folio)
 {
 	struct buffer_head *bh, *head;
 	struct address_space *m;
-	unsigned long ino;
+	u64 ino;
 
 	if (unlikely(!folio)) {
 		printk(KERN_CRIT "NILFS_FOLIO_BUG(NULL)\n");
@@ -164,10 +164,9 @@ void nilfs_folio_bug(struct folio *folio)
 	m = folio->mapping;
 	ino = m ? m->host->i_ino : 0;
 
-	printk(KERN_CRIT "NILFS_FOLIO_BUG(%p): cnt=%d index#=%llu flags=0x%lx "
-	       "mapping=%p ino=%lu\n",
-	       folio, folio_ref_count(folio),
-	       (unsigned long long)folio->index, folio->flags.f, m, ino);
+	printk(KERN_CRIT "NILFS_FOLIO_BUG(%p): cnt=%d index#=%lu flags=0x%lx  mapping=%p ino=%llu\n",
+		folio, folio_ref_count(folio), folio->index, folio->flags.f,
+		m, ino);
 
 	head = folio_buffers(folio);
 	if (head) {
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 4d5a6aa5214c..45fb37215669 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -34,7 +34,7 @@ enum {
 
 /* work structure for recovery */
 struct nilfs_recovery_block {
-	ino_t ino;		/*
+	u64 ino;		/*
 				 * Inode number of the file that this block
 				 * belongs to
 				 */
@@ -333,7 +333,7 @@ static int nilfs_scan_dsync_log(struct the_nilfs *nilfs, sector_t start_blocknr,
 	unsigned int offset;
 	u32 nfinfo, sumbytes;
 	sector_t blocknr;
-	ino_t ino;
+	u64 ino;
 	int err = -EIO;
 
 	nfinfo = le32_to_cpu(sum->ss_nfinfo);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 5896fdae5669..829573cb6131 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1610,7 +1610,7 @@ nilfs_segctor_update_payload_blocknr(struct nilfs_sc_info *sci,
 	struct nilfs_finfo *finfo = NULL;
 	union nilfs_binfo binfo;
 	struct buffer_head *bh, *bh_org;
-	ino_t ino = 0;
+	u64 ino = 0;
 	int err = 0;
 
 	if (!nfinfo)
-- 
2.43.0

