Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399B14C96;
	Sun, 20 Oct 2024 04:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729400401; cv=none; b=BKMfDIU2JXgOITIdinqLz7Bj6LR61JN7D7RjHEBZf1JGg3aZecdlL2HMnfGkerhJZLeP/2+qkSW4SOCifKLKkVbQKKifuEK77bUViu7uXQMzWjXkyxVfHU+RFhxw1JqJrUtlIdIu7OuCn0r9xUhzH2V5uTIeP8w2bxk6gvjw/eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729400401; c=relaxed/simple;
	bh=SCGAtJlNNJS48DESWrlcIoyC7LdwlBt0R4p7ke/8yVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHLcjolBHU1d308FTpUVrJKrXLpdtRKwIvhd+LsiUShrBjVWOAs1JWFyyg5cTE8Mgv5bzD6rFlOOoapbOGcPGG7F+NOsw8VtSUbJRdLwodLivlqA+78Nqk8dE5YqKMdZgUi2QUaRUjkCgCztYi/GgU6BL00rL6Mg7h0h7LGuczg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RBo4HKYP; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RBo4HKYP"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2e2fb304e7dso2853907a91.1;
        Sat, 19 Oct 2024 21:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729400398; x=1730005198; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nUaXr9jyI82v7WCqHmTaJdfptWknWvRqcMeZwkWUzbY=;
        b=RBo4HKYPweXgVDVrDGr4UIdoIVxeZ58mpmt1C2sY6UVQX5iw1jibc0eULwh6M0pG+D
         O7IRPLBA0mPR/dhOYxdMTkksMV48upkDAYOOa/R0pLYlF1MypN7y7PymjnhiFLIIPGhQ
         R4LohmQri2YKcwwWUemmyh2E6g67LS2gKRKWMH6GyXbz30RhkghAKzvpAbsvFnb+eu/c
         dzMghIvY/nn+zv8QKJryXaawqam6Yy2yI8zc9aosA+9pfgdYd3nRjzFeAjRrTEPrutXb
         B8Z0wDtFI72WVXKGHsCxvx1VdsOvW4Vk2ckeItLdtP7aixc1BQ/1Ao0X6w1pouqrsz32
         h06g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729400398; x=1730005198;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nUaXr9jyI82v7WCqHmTaJdfptWknWvRqcMeZwkWUzbY=;
        b=gFhP4iTCEob/4R8hSm28HO4Dx839CMFEBk1lsRMpL4V0sv6lCSHFyYIvdy0m3G4gIc
         S57pC7YkToh0SFk54R80uelx8akMZ62q1lfRoBsONLk8Ox5CGNzxr4VAgW4DEiZ/xBcR
         KNfqVjDiij1+9MRB6FprNRS+StUWk0+5Wlv20S6lFglsGZQLR8a/OA8bLth8cSzr/98R
         GglMmsWUmGbhSWOdqLHOl6Ua1ptEf4MLHcJv8y72agQObv7z2ViVBwRUFV8ulW2Y+8cY
         JAre70teamM8EYqD/ZQBfQTwhnQ0JL7xfoysHEym3cjUqyOwU5vxA3sGd6RDTMRM8vqJ
         uNZg==
X-Forwarded-Encrypted: i=1; AJvYcCVr/BKw/ZhrblMaA1TVCVfxMV06Ko5W1Kd6NuFdTB4Abbwcpp6YwW8YOvemOuLPgdrPuUPnkcckMXVw+b0=@vger.kernel.org, AJvYcCXJ7PUoCE/3Tdmxxg2ZefcIs5z25nuVwoGOctTDdQ9mkxIxouYfnnII3L3LFViPNuFo+M8PeABGaV89KC0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoiF03bufrahSz+/3Mk3woMlzohW53wEUrvDgycRRWEtwWXRyd
	Yc4m5tRttvaTp85pyKPwMh67T4a2yb617Amu0G7U1jUY0MezDJKu
X-Google-Smtp-Source: AGHT+IGmY2dOGaZZNT1ol5gR380oL0yb8gm+JrSmSBRI7ACJExC/AnPnv9kLcOLqtCEKaQsXVgMRMw==
X-Received: by 2002:a17:90b:4b8c:b0:2e2:8995:dd10 with SMTP id 98e67ed59e1d1-2e5616dedabmr9199390a91.4.1729400398314;
        Sat, 19 Oct 2024 21:59:58 -0700 (PDT)
Received: from carrot.. (i118-19-49-33.s41.a014.ap.plala.or.jp. [118.19.49.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad512a98sm688779a91.52.2024.10.19.21.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 21:59:57 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: syzbot <syzbot+9ef37ac20608f4836256@syzkaller.appspotmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] nilfs2: fix potential deadlock with newly created symlinks
Date: Sun, 20 Oct 2024 13:51:28 +0900
Message-ID: <20241020050003.4308-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <67134033.050a0220.1e4b4d.001f.GAE@google.com>
References: <67134033.050a0220.1e4b4d.001f.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot reported that page_symlink(), called by nilfs_symlink(),
triggers memory reclamation involving the filesystem layer, which can
result in circular lock dependencies among the reader/writer semaphore
nilfs->ns_segctor_sem, s_writers percpu_rwsem (intwrite) and the
fs_reclaim pseudo lock.

This is because after commit 21fc61c73c39 ("don't put symlink bodies in
pagecache into highmem"), the gfp flags of the page cache for symbolic
links are overwritten to GFP_KERNEL via inode_nohighmem().

This is not a problem for symlinks read from the backing device,
because the __GFP_FS flag is dropped after inode_nohighmem() is called.
However, when a new symlink is created with nilfs_symlink(), the gfp
flags remain overwritten to GFP_KERNEL.  Then, memory allocation called
from page_symlink() etc. triggers memory reclamation including the FS
layer, which may call nilfs_evict_inode() or nilfs_dirty_inode().  And
these can cause a deadlock if they are called while
nilfs->ns_segctor_sem is held:

Fix this issue by dropping the __GFP_FS flag from the page cache GFP
flags of newly created symlinks in the same way that nilfs_new_inode()
and __nilfs_read_inode() do, as a workaround until we adopt nofs
allocation scope consistently or improve the locking constraints.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+9ef37ac20608f4836256@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9ef37ac20608f4836256
Fixes: 21fc61c73c39 ("don't put symlink bodies in pagecache into highmem")
Tested-by: syzbot+9ef37ac20608f4836256@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
---
Part of the syzbot address was missing in the recipient's addresses,
so I'll resend this to syzbot.

Please be careful when replying to the previous patch submission.

Ryusuke Konishi

 fs/nilfs2/namei.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 4905063790c5..9b108052d9f7 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -157,6 +157,9 @@ static int nilfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	/* slow symlink */
 	inode->i_op = &nilfs_symlink_inode_operations;
 	inode_nohighmem(inode);
+	mapping_set_gfp_mask(inode->i_mapping,
+			     mapping_gfp_constraint(inode->i_mapping,
+						    ~__GFP_FS));
 	inode->i_mapping->a_ops = &nilfs_aops;
 	err = page_symlink(inode, symname, l);
 	if (err)
-- 
2.43.0

