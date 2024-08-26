Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A16199259;
	Mon, 26 Aug 2024 17:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724694099; cv=none; b=mq513gAJmeqTyDLUjs5bijcuyzFm1a1lwqlHW5Uj9ik/pTL3nmgIYkf19lKmepDAcYzxDTaN3cClpBGR/+Q1RB5pj+r3mYkeeZJRop9fIjUd2FbJ3J2cApAEwILC7TYDL/7VSXiM3kvU/PonED8jQaq6LkEgF/4A4HN2JHmxDaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724694099; c=relaxed/simple;
	bh=IBpjGpT3+dfPMCbwZ8AstCshDNqRkTKGECu191f0TUw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ieM2VDenH9ThTLUmwTmKWF/KMPadkK3wpsHxTSkHshHb0uZZ02KMK4Gi6td3W2SA2ym4DRAUhEiCtDUnrlh5TSvwP/rf6MzFey/vzBvZd97WbyUdenzRt+2Qadvq1h4krPMN+ljARTeb3Xle5uiTd6aNQ1pMMrD7IwD97Rgena0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nrVolagg; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nrVolagg"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2021537a8e6so40664045ad.2;
        Mon, 26 Aug 2024 10:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724694098; x=1725298898; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uRKVjbw/gvzrgcStUudURUfM0z4wfapb4mMVAu16Gjc=;
        b=nrVolaggQ6/F0agtFRfpBvkzseUHSN/qeenrq8l634m4Tfgg1mJG4Pu1br/YL9evp+
         KsSvV77oYAl22A+bnCSY7F+3WuJhaC3E9FpOGpDrFvpvbcA6Vv36a5IIVBBCLx2qQjkO
         yY8kCHZBRNwdLflXMXuE1EE23Fm76lSTO1URYSuSsOTdjCZy8MtEwTF9HrM6Pb/lBToz
         V26z2KxGBe8OzQCKuCG5NCBrqmsykYK/LC4DYPT9AnC07T+7AwksICbfvl+I37OrY8jg
         ahMXzfLRc/Zm+4eSRhl0HE6F0c12/2Nfq3CO5AaLqt45WlZieaRWCXEGDnQCqqYwhBjv
         AecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724694098; x=1725298898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uRKVjbw/gvzrgcStUudURUfM0z4wfapb4mMVAu16Gjc=;
        b=S1aYAHqCnJaszjGJBgFFbEbAu4FiZ1688S2KvcEt8y0hFj453aI09O7QmCXLhHBKfJ
         +OO15GPeLxRi6RLRT77Y1TEfw9X8VhDlXWVUMXqcJXaPRw4MNuGN3+tUD3jDfgNUk1yt
         SPbVV7SIKBhiM97/iS5fTm0xjOkc/oF2o4LryXie6Sgcbp1Y9uYogkfhJLtbThRdUT2p
         iHpKBw99rWDGWPsIkR8Esz3bY7y1vln7sHjigsbVGwnc9OdBqls7QGzZudEXUq0a4HwT
         vMcxfCluIVoH8Z3hVCA6sc6sfJL3q/fpfrPBp02bYbVO+YLtdlN/LxlSOHfr9XR8ytlL
         DWEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUg+oLUApCwCJHfJK0+V8Q4iMGi6CnEzboYZ+BFORpRJPqxQr5NlBXR3xy7n1u/h/7d5E2ZO//kBqAd+SM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9cXN4CqfMnLt5FdXAYYCMNoSayEMr8o7Iw5w/Xw9UNMOCuYIy
	R5W9TQrsKWcfKON/KMnCJv3rvtEehTKAyx2eP5NkQKMUh9ywKR7XpxVkDg==
X-Google-Smtp-Source: AGHT+IFEvb3TP1BcRxf0l5w1dckNP9L9XzPXzTrmcJLSdKOctvuLxs13JO7cwZAADEJXClH14KivAQ==
X-Received: by 2002:a17:902:dacc:b0:202:cbf:2d4e with SMTP id d9443c01a7336-2039e554fe8mr120479895ad.64.1724694097345;
        Mon, 26 Aug 2024 10:41:37 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855665besm70057055ad.34.2024.08.26.10.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 10:41:36 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] nilfs2: separate inode type information from i_state field
Date: Tue, 27 Aug 2024 02:41:11 +0900
Message-Id: <20240826174116.5008-4-konishi.ryusuke@gmail.com>
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

In nilfs_iget_locked() and nilfs_ilookup(), which are used to find or
obtain nilfs2 inodes, the nilfs_iget_args structure used to identify
inodes has type information divided into multiple booleans, making
type determination complicated.

Simplify inode type determination by consolidating inode type
information into an unsigned integer represented by a comibination of
flags and by separating the type identification information for
on-memory inodes from the i_state member in the nilfs_inode_info
structure.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/inode.c   | 56 ++++++++++++---------------------------------
 fs/nilfs2/nilfs.h   | 15 +++++++++---
 fs/nilfs2/segment.c |  2 +-
 fs/nilfs2/super.c   |  1 +
 4 files changed, 28 insertions(+), 46 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index c39bc940e6f2..35f966cb4ece 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -28,17 +28,13 @@
  * @ino: inode number
  * @cno: checkpoint number
  * @root: pointer on NILFS root object (mounted checkpoint)
- * @for_gc: inode for GC flag
- * @for_btnc: inode for B-tree node cache flag
- * @for_shadow: inode for shadowed page cache flag
+ * @type: inode type
  */
 struct nilfs_iget_args {
 	u64 ino;
 	__u64 cno;
 	struct nilfs_root *root;
-	bool for_gc;
-	bool for_btnc;
-	bool for_shadow;
+	unsigned int type;
 };
 
 static int nilfs_iget_test(struct inode *inode, void *opaque);
@@ -315,8 +311,7 @@ static int nilfs_insert_inode_locked(struct inode *inode,
 				     unsigned long ino)
 {
 	struct nilfs_iget_args args = {
-		.ino = ino, .root = root, .cno = 0, .for_gc = false,
-		.for_btnc = false, .for_shadow = false
+		.ino = ino, .root = root, .cno = 0, .type = NILFS_I_TYPE_NORMAL
 	};
 
 	return insert_inode_locked4(inode, ino, nilfs_iget_test, &args);
@@ -343,6 +338,7 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	root = NILFS_I(dir)->i_root;
 	ii = NILFS_I(inode);
 	ii->i_state = BIT(NILFS_I_NEW);
+	ii->i_type = NILFS_I_TYPE_NORMAL;
 	ii->i_root = root;
 
 	err = nilfs_ifile_create_inode(root->ifile, &ino, &bh);
@@ -546,23 +542,10 @@ static int nilfs_iget_test(struct inode *inode, void *opaque)
 		return 0;
 
 	ii = NILFS_I(inode);
-	if (test_bit(NILFS_I_BTNC, &ii->i_state)) {
-		if (!args->for_btnc)
-			return 0;
-	} else if (args->for_btnc) {
+	if (ii->i_type != args->type)
 		return 0;
-	}
-	if (test_bit(NILFS_I_SHADOW, &ii->i_state)) {
-		if (!args->for_shadow)
-			return 0;
-	} else if (args->for_shadow) {
-		return 0;
-	}
 
-	if (!test_bit(NILFS_I_GCINODE, &ii->i_state))
-		return !args->for_gc;
-
-	return args->for_gc && args->cno == ii->i_cno;
+	return !(args->type & NILFS_I_TYPE_GC) || args->cno == ii->i_cno;
 }
 
 static int nilfs_iget_set(struct inode *inode, void *opaque)
@@ -572,15 +555,9 @@ static int nilfs_iget_set(struct inode *inode, void *opaque)
 	inode->i_ino = args->ino;
 	NILFS_I(inode)->i_cno = args->cno;
 	NILFS_I(inode)->i_root = args->root;
+	NILFS_I(inode)->i_type = args->type;
 	if (args->root && args->ino == NILFS_ROOT_INO)
 		nilfs_get_root(args->root);
-
-	if (args->for_gc)
-		NILFS_I(inode)->i_state = BIT(NILFS_I_GCINODE);
-	if (args->for_btnc)
-		NILFS_I(inode)->i_state |= BIT(NILFS_I_BTNC);
-	if (args->for_shadow)
-		NILFS_I(inode)->i_state |= BIT(NILFS_I_SHADOW);
 	return 0;
 }
 
@@ -588,8 +565,7 @@ struct inode *nilfs_ilookup(struct super_block *sb, struct nilfs_root *root,
 			    unsigned long ino)
 {
 	struct nilfs_iget_args args = {
-		.ino = ino, .root = root, .cno = 0, .for_gc = false,
-		.for_btnc = false, .for_shadow = false
+		.ino = ino, .root = root, .cno = 0, .type = NILFS_I_TYPE_NORMAL
 	};
 
 	return ilookup5(sb, ino, nilfs_iget_test, &args);
@@ -599,8 +575,7 @@ struct inode *nilfs_iget_locked(struct super_block *sb, struct nilfs_root *root,
 				unsigned long ino)
 {
 	struct nilfs_iget_args args = {
-		.ino = ino, .root = root, .cno = 0, .for_gc = false,
-		.for_btnc = false, .for_shadow = false
+		.ino = ino, .root = root, .cno = 0, .type = NILFS_I_TYPE_NORMAL
 	};
 
 	return iget5_locked(sb, ino, nilfs_iget_test, nilfs_iget_set, &args);
@@ -631,8 +606,7 @@ struct inode *nilfs_iget_for_gc(struct super_block *sb, unsigned long ino,
 				__u64 cno)
 {
 	struct nilfs_iget_args args = {
-		.ino = ino, .root = NULL, .cno = cno, .for_gc = true,
-		.for_btnc = false, .for_shadow = false
+		.ino = ino, .root = NULL, .cno = cno, .type = NILFS_I_TYPE_GC
 	};
 	struct inode *inode;
 	int err;
@@ -677,9 +651,7 @@ int nilfs_attach_btree_node_cache(struct inode *inode)
 	args.ino = inode->i_ino;
 	args.root = ii->i_root;
 	args.cno = ii->i_cno;
-	args.for_gc = test_bit(NILFS_I_GCINODE, &ii->i_state) != 0;
-	args.for_btnc = true;
-	args.for_shadow = test_bit(NILFS_I_SHADOW, &ii->i_state) != 0;
+	args.type = ii->i_type | NILFS_I_TYPE_BTNC;
 
 	btnc_inode = iget5_locked(inode->i_sb, inode->i_ino, nilfs_iget_test,
 				  nilfs_iget_set, &args);
@@ -733,8 +705,8 @@ void nilfs_detach_btree_node_cache(struct inode *inode)
 struct inode *nilfs_iget_for_shadow(struct inode *inode)
 {
 	struct nilfs_iget_args args = {
-		.ino = inode->i_ino, .root = NULL, .cno = 0, .for_gc = false,
-		.for_btnc = false, .for_shadow = true
+		.ino = inode->i_ino, .root = NULL, .cno = 0,
+		.type = NILFS_I_TYPE_SHADOW
 	};
 	struct inode *s_inode;
 	int err;
@@ -900,7 +872,7 @@ static void nilfs_clear_inode(struct inode *inode)
 	if (test_bit(NILFS_I_BMAP, &ii->i_state))
 		nilfs_bmap_clear(ii->i_bmap);
 
-	if (!test_bit(NILFS_I_BTNC, &ii->i_state))
+	if (!(ii->i_type & NILFS_I_TYPE_BTNC))
 		nilfs_detach_btree_node_cache(inode);
 
 	if (ii->i_root && inode->i_ino == NILFS_ROOT_INO)
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 3097490b6621..fb1c4c5bae7c 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -22,6 +22,7 @@
 /**
  * struct nilfs_inode_info - nilfs inode data in memory
  * @i_flags: inode flags
+ * @i_type: inode type (combination of flags that inidicate usage)
  * @i_state: dynamic state flags
  * @i_bmap: pointer on i_bmap_data
  * @i_bmap_data: raw block mapping
@@ -37,6 +38,7 @@
  */
 struct nilfs_inode_info {
 	__u32 i_flags;
+	unsigned int i_type;
 	unsigned long  i_state;		/* Dynamic state flags */
 	struct nilfs_bmap *i_bmap;
 	struct nilfs_bmap i_bmap_data;
@@ -90,9 +92,16 @@ enum {
 	NILFS_I_UPDATED,		/* The file has been written back */
 	NILFS_I_INODE_SYNC,		/* dsync is not allowed for inode */
 	NILFS_I_BMAP,			/* has bmap and btnode_cache */
-	NILFS_I_GCINODE,		/* inode for GC, on memory only */
-	NILFS_I_BTNC,			/* inode for btree node cache */
-	NILFS_I_SHADOW,			/* inode for shadowed page cache */
+};
+
+/*
+ * Flags to identify the usage of on-memory inodes (i_type)
+ */
+enum {
+	NILFS_I_TYPE_NORMAL =	0,
+	NILFS_I_TYPE_GC =	0x0001,	/* For data caching during GC */
+	NILFS_I_TYPE_BTNC =	0x0002,	/* For btree node cache */
+	NILFS_I_TYPE_SHADOW =	0x0004,	/* For shadowed page cache */
 };
 
 /*
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 765d55333a13..206066ce6d00 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -519,7 +519,7 @@ static void nilfs_segctor_end_finfo(struct nilfs_sc_info *sci,
 
 	ii = NILFS_I(inode);
 
-	if (test_bit(NILFS_I_GCINODE, &ii->i_state))
+	if (ii->i_type & NILFS_I_TYPE_GC)
 		cno = ii->i_cno;
 	else if (NILFS_ROOT_METADATA_FILE(inode->i_ino))
 		cno = 0;
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 8eb8dbc9f51c..eca79cca3803 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -160,6 +160,7 @@ struct inode *nilfs_alloc_inode(struct super_block *sb)
 		return NULL;
 	ii->i_bh = NULL;
 	ii->i_state = 0;
+	ii->i_type = 0;
 	ii->i_cno = 0;
 	ii->i_assoc_inode = NULL;
 	ii->i_bmap = &ii->i_bmap_data;
-- 
2.34.1

