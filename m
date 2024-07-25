Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779071CFBE;
	Thu, 25 Jul 2024 05:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721884784; cv=none; b=hHfXDlNf8R5KZpw2Gk9pGjsMqatWwltYFbnUc+52OHnSJy4L6pX0KwIbklBlQL8LDDCykotL8D4OvLwVMIR/o1dgKapT8hVqzBFws3/SBdp/Lo8hUiTzKmFserbmDrLdANO7J94RAv6sFj2NwPQRPBuiR3jW/VPm6Q0/gqV4OM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721884784; c=relaxed/simple;
	bh=NncW4L6PdVvfrj3ZRta644u1QAjSKzmizPmBl7z9ANg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mvYDaAM1a1OTCL9nrXJgX2EhGL1tSXNUZbjmxoSgMQUc4i3pXzjnLfsB2/gO6uktsdmSd4k4r6ui5XltI32ufBgioe4sz0HH4GpSXlr4SsNMgdPb/3XmH+xc5debV4MLgW2MKdwykpACJTf8yE28MZXKJ/n0Y0s/un8hz0exMw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IsG5Oj4y; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IsG5Oj4y"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1fd640a6454so4871295ad.3;
        Wed, 24 Jul 2024 22:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721884783; x=1722489583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VvZ7IruRoTugnhRcn5PUZFoQfC1d2Q5HsO81JSTscSc=;
        b=IsG5Oj4ylqBhlrQkQEXci0C2UTcF5iH0xdQ+e2KZEPnjztwwIE2KkTFcGkTCSOAmeR
         NZntZpi7QDRDcIe0PQRhPcXYP4abw1aOt54QrKXTwLGTdVI+SqbJGHXvqHmOcoyyY4GK
         G+YGrf/yUuovk/akdf3VwNuqLhuf1hDV/XeqLFc5VVFyaq9djIA/Yc45T9TMd3m9bSM7
         X3Vec7Gmpj/1IDeLXhbopCiFdq5DYwvzCpakRFWabGDGItUoxsnCRGMIsED8XRNjdUcS
         xv1PZt6enBf3/dDGpN6LSa7Hm3Bv5qs1Qf1hpGsm/I1IseAJHJynnhenjbfQo5aPYdUP
         J/rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721884783; x=1722489583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VvZ7IruRoTugnhRcn5PUZFoQfC1d2Q5HsO81JSTscSc=;
        b=TE+ftSXEKB/nXIlOL78CoUf7Rfi2WzGHKmyUYrmv8VeVtF/4zKVCIgUsVuu4NaNq7Q
         nGtL6Lu9gvJi67D77TrzDY4Z2S3NhGS0Jn5kaVkKJCV8d0lxL3W9/A015uXW3a2rB9b9
         lTMrjWOUsmfjA0sFyXZvrAoSJn5q+IDE/abP+6XHct930qLv986TVlPIGcQi2BsbGdyn
         S5oOo60FUVyXvqHXmEDKAqGYWmHjcTlp2jnjw6ixuU6FnMcpqkBbr2L0v8RfQJylFllC
         /MgznCd9Nzo+n27cjoGXrrmWzIjqCXHWiSkRtBoC+Mn0+32Sd3Jjh/H3woESTv1RkAP6
         XLlQ==
X-Forwarded-Encrypted: i=1; AJvYcCUh1hkTsR1WcHf8DG2bqf1AjqZQPJLnLMHqvsk5vkqya5eX+ushFd3w55xgt9CYnFQZsOluVRZSMDgGwvfN5/KKBVjyla2LklUlWnyn
X-Gm-Message-State: AOJu0Yy5bznQciDRL05iOoZF+ECnT/6fGaF8rrdp93m5MtCHSz4Vz2Pn
	Y5RnjcSUFu5dyCZZuBVTTA/eFV8z8KO5FG1luqAkhs7hqTJ7rK7T
X-Google-Smtp-Source: AGHT+IH7op9jGbqgu3P5dAykUiyOnDA14qmQdGG2a27kC3SiANwUfE6+Qp+drcev42LFgEiMUK/zcQ==
X-Received: by 2002:a17:90a:c48:b0:2c7:e46e:f8b7 with SMTP id 98e67ed59e1d1-2cf23772d29mr2034531a91.4.1721884782573;
        Wed, 24 Jul 2024 22:19:42 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cdb73b32a5sm2621448a91.15.2024.07.24.22.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 22:19:41 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot <syzbot+89cc4f2324ed37988b60@syzkaller.appspotmail.com>,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] nilfs2: handle inconsistent state in nilfs_btnode_create_block()
Date: Thu, 25 Jul 2024 14:20:07 +0900
Message-Id: <20240725052007.4562-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <000000000000cb6fca061af0462e@google.com>
References: <000000000000cb6fca061af0462e@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot reported that a buffer state inconsistency was detected in
nilfs_btnode_create_block(), triggering a kernel bug.

It is not appropriate to treat this inconsistency as a bug; it can
occur if the argument block address (the buffer index of the newly
created block) is a virtual block number and has been reallocated due
to corruption of the bitmap used to manage its allocation state.

So, modify nilfs_btnode_create_block() and its callers to treat it as
a possible filesystem error, rather than triggering a kernel bug.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+89cc4f2324ed37988b60@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=89cc4f2324ed37988b60
Fixes: a60be987d45d ("nilfs2: B-tree node cache")
Cc: stable@vger.kernel.org
---
Andrew, please apply this as a bug fix.

This fixes one syzbot-reported issue where a kernel bug could be
triggered on corrupted file system images.

Thanks,
Ryusuke Konishi

 fs/nilfs2/btnode.c | 25 ++++++++++++++++++++-----
 fs/nilfs2/btree.c  |  4 ++--
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 0131d83b912d..c034080c334b 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -51,12 +51,21 @@ nilfs_btnode_create_block(struct address_space *btnc, __u64 blocknr)
 
 	bh = nilfs_grab_buffer(inode, btnc, blocknr, BIT(BH_NILFS_Node));
 	if (unlikely(!bh))
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	if (unlikely(buffer_mapped(bh) || buffer_uptodate(bh) ||
 		     buffer_dirty(bh))) {
-		brelse(bh);
-		BUG();
+		/*
+		 * The block buffer at the specified new address was already
+		 * in use.  This can happen if it is a virtual block number
+		 * and has been reallocated due to corruption of the bitmap
+		 * used to manage its allocation state (if not, the buffer
+		 * clearing of an abandoned b-tree node is missing somewhere).
+		 */
+		nilfs_error(inode->i_sb,
+			    "state inconsistency probably due to duplicate use of b-tree node block address %llu (ino=%lu)",
+			    (unsigned long long)blocknr, inode->i_ino);
+		goto failed;
 	}
 	memset(bh->b_data, 0, i_blocksize(inode));
 	bh->b_bdev = inode->i_sb->s_bdev;
@@ -67,6 +76,12 @@ nilfs_btnode_create_block(struct address_space *btnc, __u64 blocknr)
 	folio_unlock(bh->b_folio);
 	folio_put(bh->b_folio);
 	return bh;
+
+failed:
+	folio_unlock(bh->b_folio);
+	folio_put(bh->b_folio);
+	brelse(bh);
+	return ERR_PTR(-EIO);
 }
 
 int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
@@ -217,8 +232,8 @@ int nilfs_btnode_prepare_change_key(struct address_space *btnc,
 	}
 
 	nbh = nilfs_btnode_create_block(btnc, newkey);
-	if (!nbh)
-		return -ENOMEM;
+	if (IS_ERR(nbh))
+		return PTR_ERR(nbh);
 
 	BUG_ON(nbh == obh);
 	ctxt->newbh = nbh;
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index a139970e4804..862bdf23120e 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -63,8 +63,8 @@ static int nilfs_btree_get_new_block(const struct nilfs_bmap *btree,
 	struct buffer_head *bh;
 
 	bh = nilfs_btnode_create_block(btnc, ptr);
-	if (!bh)
-		return -ENOMEM;
+	if (IS_ERR(bh))
+		return PTR_ERR(bh);
 
 	set_buffer_nilfs_volatile(bh);
 	*bhp = bh;
-- 
2.34.1

