Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578A11AE850;
	Sat, 11 Jan 2025 14:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736606129; cv=none; b=aqN4iCUJkHPTGvkHegLRwmYRMmfoKJLygLoJYVLRM7OAO9h0rXCrDHFztcn+lg+w85PmpZI8cw2ErPYHT9LYA14bUzm1VazsG3a3rwwwWwhRLUMO8VLwqTuHYQuFYe4M7gpBdW4vj8RWmzWjOefr5hzOTz+NQhZ0qrEF+0yCucs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736606129; c=relaxed/simple;
	bh=z7CbgPnGpmG4Yaff8NcIqZsdVeu++uQ08CNGCl0Hpb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STWZDoKrAqTDjrTWIDGaueEhKgrQF9FOU+zij0rJ4i8Z7+h1wopXECEB9VWAiTRE0G3km3weP6VQmD2lSTBVXgFLe9fpGYRuly7XOHA6wGcPuFSNoUcn4RzRGEKlvFMkf4M43+7NcHUYfN2IXnQyLj6AKYV77Zq6R/NYpR9FeJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jU2UHOeo; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jU2UHOeo"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-21654fdd5daso48612625ad.1;
        Sat, 11 Jan 2025 06:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736606127; x=1737210927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mYqCPMzNYFUXATythv2c24GmS61DdTwuyFMnmQh0SZE=;
        b=jU2UHOeo0Qibm1ocCc/M/RxdbihS2XzC/H7KpzsP9hDtMc8epHgbXV04nFsMZXsEY1
         HwpPMYVxH10tzKlNZtoriWPn1FsJXSTRC0pUT0NOOi6WDKD36zABTDYMuaftBwUy/+WD
         P7CoEois9Wi0dsPaqGLBqkSWUHW3TvY5m9rRHUtzARQ86xb32ajSrLb+eO9E350VFCVR
         bIga3nb7X/+fysq3UVOr4dTW6TII9qYYsUr2x2WWlvdeDZqoQY+dSK6r4TEXcw2fkpLi
         fJYhW3mRA9BufwJHzouDBHk3w3J5rWWuM8hIn9jRUMlfWfu71QsjGtxVEFuIQv24NPPl
         WBNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736606127; x=1737210927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mYqCPMzNYFUXATythv2c24GmS61DdTwuyFMnmQh0SZE=;
        b=RzCgJvQvbZ6tuNXD+5nNYBF6ZgdK6wO64V+urJkS2F5u5E7sfMx8jJ1mFz/C2tWwXp
         ax5I5HN5EI7CfDdlPXtNT2HoXMHGeTt6eIv4IkfRNS03yBITY7gpLLPJUvlejnBAT+sw
         QB2DFpRysfYbQoYTmW7c6Bp1FsFkSpD4vki/9xrUftPue+C7BkvHg9BXzr1fimArN0hx
         G0f1/22TTyzINiAo1QFjbIreABeln0d1AlEKnohfxidlvwf/hpHgTRn2L78lJ0Z4YDp/
         lyRCt7nfT+GD0JoTM3A3FqeA0XUg1oAQfmES118wXPzxjrtgPiC6g5eO99HJTSHOPnd7
         Xw2w==
X-Forwarded-Encrypted: i=1; AJvYcCXpoz0dDbNCf5T8/lm9zDeMon95oyMcy3Fuw6XrLfRVhhuPxQ2wKkCBI2ygQIFSkcWHGTRFX0pEXT/jT+w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtvEjbvCqAyyXYD3ZLEBAlptBUO+CRTx7EQPaFXy0WETKEwgtf
	a8wHVbVdYVy8jF2mBxgbnYREWzDdRojVbze1RgLIG89++DpzvgCd
X-Gm-Gg: ASbGncs+dBhV17dhWhGS2bAbG5pHwjvvzZwRiTRIUclUNHQyHU3PStPYfzJl4NgUG/e
	2jsZDRMdV6SrCroaiUAQNdzUl0qjC+kE/1nBX89rgCBFmf7B//o4Kt278Ql7xzMDpeBVZtJheH/
	1wdbziiVjtpLvc864+8I5yXDa4z8kH1u9eHmZA1B1ciMQc5RBrfMEjS2+Aga2BflKSXkzkUhVE+
	2zc2ZUkrpynNAXrI/DFsTc6wej46Dsh+SRBngTu1xLbx0UljNUxFCjWbcqtUo6iZZy4kd/4Ioua
	X79t9ar0tBKnI05EqNMh0m/biPbY
X-Google-Smtp-Source: AGHT+IEtvNSWsl8MXSLt/3uhysUXunQx08N3E5G2ZNksjlhrA3kOKKLPTJJLvdCMFdoQwBUTUaQUgg==
X-Received: by 2002:a05:6a21:339b:b0:1e0:bf98:42dc with SMTP id adf61e73a8af0-1e88d0bfa04mr24175849637.28.1736606127433;
        Sat, 11 Jan 2025 06:35:27 -0800 (PST)
Received: from carrot.. (i114-186-237-30.s41.a014.ap.plala.or.jp. [114.186.237.30])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72d40549322sm3095362b3a.8.2025.01.11.06.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2025 06:35:26 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	syzbot+1097e95f134f37d9395c@syzkaller.appspotmail.com,
	syzbot+32c3706ebf5d95046ea1@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] nilfs2: handle errors that nilfs_prepare_chunk() may return
Date: Sat, 11 Jan 2025 23:26:35 +0900
Message-ID: <20250111143518.7901-2-konishi.ryusuke@gmail.com>
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

The directory manipulation routines nilfs_set_link() and
nilfs_delete_entry() rewrite the directory entry in the folio/page
previously read by nilfs_find_entry(), so error handling is omitted on
the assumption that nilfs_prepare_chunk(), which prepares the buffer
for rewriting, will always succeed for these.  And if an error is
returned, it triggers the legacy BUG_ON() checks in each routine.

This assumption is wrong, as proven by syzbot: the buffer layer called
by nilfs_prepare_chunk() may call nilfs_get_block() if necessary,
which may fail due to metadata corruption or other reasons.  This has
been there all along, but improved sanity checks and error handling
may have made it more reproducible in fuzzing tests.

Fix this issue by adding missing error paths in nilfs_set_link(),
nilfs_delete_entry(), and their caller nilfs_rename().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+32c3706ebf5d95046ea1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=32c3706ebf5d95046ea1
Reported-by: syzbot+1097e95f134f37d9395c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1097e95f134f37d9395c
Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
---
 fs/nilfs2/dir.c   | 13 ++++++++++---
 fs/nilfs2/namei.c | 29 +++++++++++++++--------------
 fs/nilfs2/nilfs.h |  4 ++--
 3 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 0a3aea6c416b..9b7f8e9655a2 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -400,7 +400,7 @@ int nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr, ino_t *ino)
 	return 0;
 }
 
-void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
+int nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
 		    struct folio *folio, struct inode *inode)
 {
 	size_t from = offset_in_folio(folio, de);
@@ -410,11 +410,15 @@ void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
 
 	folio_lock(folio);
 	err = nilfs_prepare_chunk(folio, from, to);
-	BUG_ON(err);
+	if (unlikely(err)) {
+		folio_unlock(folio);
+		return err;
+	}
 	de->inode = cpu_to_le64(inode->i_ino);
 	de->file_type = fs_umode_to_ftype(inode->i_mode);
 	nilfs_commit_chunk(folio, mapping, from, to);
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
+	return 0;
 }
 
 /*
@@ -543,7 +547,10 @@ int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct folio *folio)
 		from = (char *)pde - kaddr;
 	folio_lock(folio);
 	err = nilfs_prepare_chunk(folio, from, to);
-	BUG_ON(err);
+	if (unlikely(err)) {
+		folio_unlock(folio);
+		goto out;
+	}
 	if (pde)
 		pde->rec_len = nilfs_rec_len_to_disk(to - from);
 	dir->inode = 0;
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 1d836a5540f3..e02fae6757f1 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -406,8 +406,10 @@ static int nilfs_rename(struct mnt_idmap *idmap,
 			err = PTR_ERR(new_de);
 			goto out_dir;
 		}
-		nilfs_set_link(new_dir, new_de, new_folio, old_inode);
+		err = nilfs_set_link(new_dir, new_de, new_folio, old_inode);
 		folio_release_kmap(new_folio, new_de);
+		if (unlikely(err))
+			goto out_dir;
 		nilfs_mark_inode_dirty(new_dir);
 		inode_set_ctime_current(new_inode);
 		if (dir_de)
@@ -430,28 +432,27 @@ static int nilfs_rename(struct mnt_idmap *idmap,
 	 */
 	inode_set_ctime_current(old_inode);
 
-	nilfs_delete_entry(old_de, old_folio);
-
-	if (dir_de) {
-		nilfs_set_link(old_inode, dir_de, dir_folio, new_dir);
-		folio_release_kmap(dir_folio, dir_de);
-		drop_nlink(old_dir);
+	err = nilfs_delete_entry(old_de, old_folio);
+	if (likely(!err)) {
+		if (dir_de) {
+			err = nilfs_set_link(old_inode, dir_de, dir_folio,
+					     new_dir);
+			drop_nlink(old_dir);
+		}
+		nilfs_mark_inode_dirty(old_dir);
 	}
-	folio_release_kmap(old_folio, old_de);
-
-	nilfs_mark_inode_dirty(old_dir);
 	nilfs_mark_inode_dirty(old_inode);
 
-	err = nilfs_transaction_commit(old_dir->i_sb);
-	return err;
-
 out_dir:
 	if (dir_de)
 		folio_release_kmap(dir_folio, dir_de);
 out_old:
 	folio_release_kmap(old_folio, old_de);
 out:
-	nilfs_transaction_abort(old_dir->i_sb);
+	if (likely(!err))
+		err = nilfs_transaction_commit(old_dir->i_sb);
+	else
+		nilfs_transaction_abort(old_dir->i_sb);
 	return err;
 }
 
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index dff241c53fc5..cb6ed54accd7 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -261,8 +261,8 @@ struct nilfs_dir_entry *nilfs_find_entry(struct inode *, const struct qstr *,
 int nilfs_delete_entry(struct nilfs_dir_entry *, struct folio *);
 int nilfs_empty_dir(struct inode *);
 struct nilfs_dir_entry *nilfs_dotdot(struct inode *, struct folio **);
-void nilfs_set_link(struct inode *, struct nilfs_dir_entry *,
-			   struct folio *, struct inode *);
+int nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
+		   struct folio *folio, struct inode *inode);
 
 /* file.c */
 extern int nilfs_sync_file(struct file *, loff_t, loff_t, int);
-- 
2.43.0

