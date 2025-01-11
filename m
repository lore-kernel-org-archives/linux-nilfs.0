Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA6B1AF0CB;
	Sat, 11 Jan 2025 14:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736606132; cv=none; b=b6AHLljM5stwGbXHRXLRNVyp6f2SUi/IUauinzTwdmu3Udx1Bqld3N6hATHWwomIfCLenuoLCzM/4tj3mD/ZvP5PJHljABfNUGh5zkb11+k5RbcJqNXN09AeqWXMsIWIbFQ2r2W54yMCE+E2crVePer0BzDM85ylzquarbwNQiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736606132; c=relaxed/simple;
	bh=poCTxwupH45gha+ZAqJswXD6i+uYF1J0jjqZucy6qlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyxyYIYe5vvz6JY+WbVOnzBeR5rPPvailUQXufefnKkSMHOPpCbQ3Zk6NNjt10JFXH6psO6tgJnm7bNN/a7wgEJgv3tr6q4Fttgrakha7Mx50TOpY1NSVkjmcSLYDooUu/Wo0RXvL1wgcUTUBKh7tQwJWtJj6KRQVX+ToT99Lks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=npGVJdsN; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="npGVJdsN"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2164b1f05caso51020945ad.3;
        Sat, 11 Jan 2025 06:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736606130; x=1737210930; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Dn46M+plxtAC0uoszoGd/SO9rhSI/AIAtTY5U8h4Us=;
        b=npGVJdsN21/z0db4ecxsTstGJRH80onGK81lTOVvFi+0s8uVuuC2uHnl3YijyLkQHh
         mRoFfWhLHFezjjQjmLaLvsyoU1tPX7u68PdV0Xa04nfQdhnT0lapiummUBvGT9EVqtIN
         XnXgwxaKSXe7ANn6EMxjmDen7VyVExflrpP2VBUdrKBH2zN2wqhQ7ihWo8Lhw7CZLS9k
         iQRo3AndxrMGYSfaxKoOqVYq2LbLDHp1HVBbtwh+VSva4UG7csbCdgJbd/CKijhqcGMk
         yLgJG6ZdvZJX2oIDLDR/sBZswXARlC55PQN5h0mC7Ip6hmFKocR6mdBOUUJRwOD4bel5
         l07Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736606130; x=1737210930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Dn46M+plxtAC0uoszoGd/SO9rhSI/AIAtTY5U8h4Us=;
        b=P9NWdvWfa0FOu7HZxKKIuC3ZrL/n2wIjgXAaE8rysxMpoFwuJ3d7EaPFZ78igRqVLv
         VmeWmj6Ghp/MiHp8gC8hfE+aqTJVeNXL3EgQ02cdvCJWlaK6eOMY03F82XUOhYou8d61
         OXmrxMgideHBq2mwxd1kQT4B5ej3AlPZ6c2dXWlm/OtMCsSycvfr+wISqAf1CGe1L0Cs
         TGzwT3D3B8UrtFM2ZSEGNc6vEotK66Xf6WmrJPdfHSaw8dGgNOOGA18Lb4j53QB5vFYz
         ihBrX3+3qx0EhGFeXtBPVsKemKJ3DxWSvYUrj9pdsGskRU4e7s3cxtcnrzu0961+YHn/
         vmnw==
X-Forwarded-Encrypted: i=1; AJvYcCW9qE2mwas5sfeRZ8mIjQPk1lKNIGNL3c6J9vpQDMOHf4xXLQXbkFGGPnyD2Ve4/zxdGL7NRmW//FHD4AM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHf0cILebEOJrkB4JWCHs+bB3zFZ1UdJ5sdSFfnkdA55d6gaif
	fxN27yu3gJccPhnmJEwEFJRnSng0jo/i1yEPxD1VAGvv/PylGVCP
X-Gm-Gg: ASbGncsoEMBBwBJ70UrxlOpyUeubpzg+K+pdlF3rDKuFMqoBTlxUUraA8Qir/V3meEA
	mZgZ2rEos4qQCvBQecKPgKwAKqFoW03Yf9FRTyNNMRxg1XidLrzE98iKQ+sy+iNhdL8FUl6MlRg
	lp+C7nRtoF0WN8j6PimSeGwGepGdzGtZfpp5BNhLGCNbXx2oy7gK/vBGivjfFIruCNUY4/F/pLU
	871JDvjp8a5nghudAHGNOzx4C/yToQ3HHf0+jjXhcvEySATfuCB2tnP47AyfpQYdLxoVSuLK6VX
	4HayXMOHhjuVC6P0Q3F2XIZXnXgr
X-Google-Smtp-Source: AGHT+IEid+OHAdDOYWZjA+JRK6ZuqZWBj6HAcKzUJUJRjbttA6qmltLJeF9yFoM8HUGzp2d90Hoicg==
X-Received: by 2002:a05:6a21:339b:b0:1e0:c432:32fe with SMTP id adf61e73a8af0-1e88cff3d1amr20813082637.26.1736606130509;
        Sat, 11 Jan 2025 06:35:30 -0800 (PST)
Received: from carrot.. (i114-186-237-30.s41.a014.ap.plala.or.jp. [114.186.237.30])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72d40549322sm3095362b3a.8.2025.01.11.06.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2025 06:35:29 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	syzbot+1097e95f134f37d9395c@syzkaller.appspotmail.com,
	syzbot+32c3706ebf5d95046ea1@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] nilfs2: do not update mtime of renamed directory that is not moved
Date: Sat, 11 Jan 2025 23:26:36 +0900
Message-ID: <20250111143518.7901-3-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250111143518.7901-1-konishi.ryusuke@gmail.com>
References: <678123bf.050a0220.216c54.000f.GAE@google.com>
 <20250111143518.7901-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A minor issue with nilfs_rename, originating from an old ext2
implementation, is that the mtime is updated even if the rename target
is a directory and it is renamed within the same directory, rather
than moved to a different directory.

In this case, the child directory being renamed does not change in any
way, so changing its mtime is unnecessary according to the
specification, and can unnecessarily confuse backup tools.

In ext2, this issue was fixed by commit 39fe7557b4d6 ("ext2: Do not
update mtime of a moved directory") and a few subsequent fixes, but it
remained in nilfs2.

Fix this issue by not calling nilfs_set_link(), which rewrites the
inode number of the directory entry that refers to the parent
directory, when the move target is a directory and the source and
destination are the same directory.

Here, the directory to be moved only needs to be read if the inode
number of the parent directory is rewritten with nilfs_set_link, so
also adjust the execution conditions of the preparation work to avoid
unnecessary directory reads.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/namei.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index e02fae6757f1..953fbd5f0851 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -370,6 +370,7 @@ static int nilfs_rename(struct mnt_idmap *idmap,
 	struct folio *old_folio;
 	struct nilfs_dir_entry *old_de;
 	struct nilfs_transaction_info ti;
+	bool old_is_dir = S_ISDIR(old_inode->i_mode);
 	int err;
 
 	if (flags & ~RENAME_NOREPLACE)
@@ -385,7 +386,7 @@ static int nilfs_rename(struct mnt_idmap *idmap,
 		goto out;
 	}
 
-	if (S_ISDIR(old_inode->i_mode)) {
+	if (old_is_dir && old_dir != new_dir) {
 		err = -EIO;
 		dir_de = nilfs_dotdot(old_inode, &dir_folio);
 		if (!dir_de)
@@ -397,7 +398,7 @@ static int nilfs_rename(struct mnt_idmap *idmap,
 		struct nilfs_dir_entry *new_de;
 
 		err = -ENOTEMPTY;
-		if (dir_de && !nilfs_empty_dir(new_inode))
+		if (old_is_dir && !nilfs_empty_dir(new_inode))
 			goto out_dir;
 
 		new_de = nilfs_find_entry(new_dir, &new_dentry->d_name,
@@ -412,7 +413,7 @@ static int nilfs_rename(struct mnt_idmap *idmap,
 			goto out_dir;
 		nilfs_mark_inode_dirty(new_dir);
 		inode_set_ctime_current(new_inode);
-		if (dir_de)
+		if (old_is_dir)
 			drop_nlink(new_inode);
 		drop_nlink(new_inode);
 		nilfs_mark_inode_dirty(new_inode);
@@ -420,7 +421,7 @@ static int nilfs_rename(struct mnt_idmap *idmap,
 		err = nilfs_add_link(new_dentry, old_inode);
 		if (err)
 			goto out_dir;
-		if (dir_de) {
+		if (old_is_dir) {
 			inc_nlink(new_dir);
 			nilfs_mark_inode_dirty(new_dir);
 		}
@@ -434,9 +435,10 @@ static int nilfs_rename(struct mnt_idmap *idmap,
 
 	err = nilfs_delete_entry(old_de, old_folio);
 	if (likely(!err)) {
-		if (dir_de) {
-			err = nilfs_set_link(old_inode, dir_de, dir_folio,
-					     new_dir);
+		if (old_is_dir) {
+			if (old_dir != new_dir)
+				err = nilfs_set_link(old_inode, dir_de,
+						     dir_folio, new_dir);
 			drop_nlink(old_dir);
 		}
 		nilfs_mark_inode_dirty(old_dir);
-- 
2.43.0

