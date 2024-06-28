Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC72D2E5;
	Fri, 28 Jun 2024 16:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719593405; cv=none; b=K9OanpYrAHyLxpBWePCfPr1kKHLWurDhAFzJ12EDVNw0O8raUI20dwdFXdaOJ4z6aFAvG62PiX1XzNqPTkD3f2TNMucf6rthAw5iZgc8mBSFPYYIssKtTTHjYuj+F6tr6aAp6+40FCl/E1BDThn0KNcd9rESx2jgmdKQt+oBu4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719593405; c=relaxed/simple;
	bh=G8DqdW0trZFUQupStjt8vVkzmJRjh9xErUsIAV7fWGc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eooraNT5BzAlfnrajIHCwkQAL/yDxLuE8RAMj/fKtHViNG2lrurqH54qM2rSs6v8+ysgMWqaR5mGoep3enR5PDILi4rBuLzb5FpX4N9Rrvg72IG5WV36uydopen71yNaK3TpizPPlfxxbD9SKSS8/zf1VngLwrRaY5+6BJ4ddtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cjCVicOi; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cjCVicOi"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7067435d376so621635b3a.0;
        Fri, 28 Jun 2024 09:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719593403; x=1720198203; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Sai30B2m2oMAFo6GShhCdpzgtuTKYbcDM5PCHgdK/E=;
        b=cjCVicOiq7ys/CLxt+56boRgg6GAineGyvTnM+4frCcvPWB+LBVdKY4kUbekfh267T
         I983ZJ5FjShEt2IU8IL49sifXcYoi7YhDxU02E6pXBIr8nw4hSs4X0zq9OXi0ii9JXVI
         GXEGb6n8IHGFRSZcFAGX9d2UxlcExFuDVk4MS4sQ2lwZx7YT13xMZ5dITudJXkjbdj90
         hsvzEaHFW7dRZ8OSUyrCVS8r/EkYIE+T58wSXGXVIharTpB1jKEjnu7Z59kaCApEfmAI
         ewEEzSiz09CAi+i/lDd9/vlv3rt1KpIDnsd0HRP25JZ3tR5FZJ6sIHdLbP1EHQIwynjT
         PpZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719593403; x=1720198203;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Sai30B2m2oMAFo6GShhCdpzgtuTKYbcDM5PCHgdK/E=;
        b=gbxmbpAcYL1ZDOHlITm5K5V4jzsFPqYwoowu0KIl/7ge/YdT9pkxVuYCAMr2Jq3RZL
         8go5GzM/RH0vvxCtmsL9ZO8hpYADMicKz4E6yIEux8vB+ldyMpzagwNiBc6SuoJnAFJw
         qFArwvHGhiymLhSsEMcruDM6ayw6oOxk47Gz3gu5LX0SiYPcNm1fxD/xS12fNVffAf3A
         YAOzXiMxHNhmZ0HcZDQSkKj2N9H9Gj2gWfzTrSmwRMzop99g3RFaxbX7ZgIOaKDb9gQd
         ru4SDeoVz4ztNs7HuH5rfJ9unYrB++Xnnc9npgFfb+akDFs+wW7QpOqwBFh9iJ+ryuHe
         FzCg==
X-Forwarded-Encrypted: i=1; AJvYcCVXaZl6+V+e51sGLh9hSvxwrKIPVcdX7AKUpgeNbFX1VggranBYS3qt6oG2cNzl/EfvtqB0hPCj97wWX8ML2bartn4z90p4+g6Rlyse
X-Gm-Message-State: AOJu0YywSd4jnBepPZrtQ41UxiQpSnSpozlK73VwEazS/26MU4T1+F5e
	owK5zpkyx+wi9ntQKo8xCRBrlmLkvUbh8RN7GMMp1HkohtAlhtTt
X-Google-Smtp-Source: AGHT+IG7FBBAz50J+1PFvwI0HOFkFmVVr1ZgKD18MFU3u1JUmFFVaxoC3Ga0nwWFX4ys9XykVWm3pQ==
X-Received: by 2002:aa7:91d3:0:b0:706:5daf:efa5 with SMTP id d2e1a72fcca58-70851f55b1bmr2832674b3a.9.1719593403189;
        Fri, 28 Jun 2024 09:50:03 -0700 (PDT)
Received: from carrot.. (i114-180-52-104.s42.a014.ap.plala.or.jp. [114.180.52.104])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70804a95402sm1827690b3a.198.2024.06.28.09.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 09:50:02 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	syzbot <syzbot+d3abed1ad3d367fa2627@syzkaller.appspotmail.com>,
	syzkaller-bugs@googlegroups.com,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] nilfs2: fix kernel bug on rename operation of broken directory
Date: Sat, 29 Jun 2024 01:51:07 +0900
Message-Id: <20240628165107.9006-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <0000000000003002be06179e2f61@google.com>
References: <0000000000003002be06179e2f61@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot reported that in rename directory operation on broken directory
on nilfs2, __block_write_begin_int() called to prepare block write may
fail BUG_ON check for access exceeding the folio/page size.

This is because nilfs_dotdot(), which gets parent directory reference
entry ("..") of the directory to be moved or renamed, does not check
consistency enough, and may return location exceeding folio/page size
for broken directories.

Fix this issue by checking required directory entries ("." and "..")
in the first chunk of the directory in nilfs_dotdot().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+d3abed1ad3d367fa2627@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d3abed1ad3d367fa2627
Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: stable@vger.kernel.org
---
Hi Andrew, please apply this as a bug fix.

This fixes a potential kernel bug reported by syzbot regarding broken
directory rename operations.

Thanks,
Ryusuke Konishi

 fs/nilfs2/dir.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index dddfa604491a..4a29b0138d75 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -383,11 +383,39 @@ struct nilfs_dir_entry *nilfs_find_entry(struct inode *dir,
 
 struct nilfs_dir_entry *nilfs_dotdot(struct inode *dir, struct folio **foliop)
 {
-	struct nilfs_dir_entry *de = nilfs_get_folio(dir, 0, foliop);
+	struct folio *folio;
+	struct nilfs_dir_entry *de, *next_de;
+	size_t limit;
+	char *msg;
 
+	de = nilfs_get_folio(dir, 0, &folio);
 	if (IS_ERR(de))
 		return NULL;
-	return nilfs_next_entry(de);
+
+	limit = nilfs_last_byte(dir, 0);  /* is a multiple of chunk size */
+	if (unlikely(!limit || le64_to_cpu(de->inode) != dir->i_ino ||
+		     !nilfs_match(1, ".", de))) {
+		msg = "missing '.'";
+		goto fail;
+	}
+
+	next_de = nilfs_next_entry(de);
+	/*
+	 * If "next_de" has not reached the end of the chunk, there is
+	 * at least one more record.  Check whether it matches "..".
+	 */
+	if (unlikely((char *)next_de == (char *)de + nilfs_chunk_size(dir) ||
+		     !nilfs_match(2, "..", next_de))) {
+		msg = "missing '..'";
+		goto fail;
+	}
+	*foliop = folio;
+	return next_de;
+
+fail:
+	nilfs_error(dir->i_sb, "directory #%lu %s", dir->i_ino, msg);
+	folio_release_kmap(folio, de);
+	return NULL;
 }
 
 ino_t nilfs_inode_by_name(struct inode *dir, const struct qstr *qstr)
-- 
2.34.1

