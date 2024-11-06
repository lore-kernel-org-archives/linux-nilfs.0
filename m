Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083BE206519;
	Wed,  6 Nov 2024 16:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730909303; cv=none; b=F/jrFemh+YuMoVoV2GtUoCL/rYZm53YomCDcZhaFYEPPuF/4xdrUlXSh4gI+q4jzZJmj1MjadLnNq4jiI61sDskcK2IC6D4+B3XfHPgOzwL8xfl6flMQ6nIpUQlc67eCST8qBtWB4pO7aBDEaVaU9vCnzBOaw+cWRSDAS8l+oIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730909303; c=relaxed/simple;
	bh=d90JWD+BjriEsR681CJYMlvnTCcOpqSFEH3lU2GifNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiqH7RhDVCntBJYhfs4PG5d+cBoklr1aI4to19UHVoI+96ymMBA+6P5sb2Is/YvTwrxQm+yCRQ+OWjDW8nJ6n6q+FkjNxw3MmdXKbY2UwpDUqtjcTUz15u1eEFKmTo61OLTULi1eMI/CLB1u9vX6k57rMo7tVlY7aj/AOGXyLjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B+q0HOD3; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B+q0HOD3"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2e2b549799eso5272379a91.3;
        Wed, 06 Nov 2024 08:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730909301; x=1731514101; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jIOvivKbpD/NBWmyfn4+HdgmciRDbmMlOB0Yv5CEaO8=;
        b=B+q0HOD38Xq0dHUMng0xKkWJkrCGdQICF6BM1XTPcM59VkZwP8cg9PNDJocKhgN7DA
         IskqlutS+DtgUh2BbOccLMPiqVEAnJb+GsULCC2znpr6fGr1HLcLiefv7Qy7FQ08Yf3a
         hF07xqt6VFdO8mRRyHlLbOOlFK0BbuDI/dS0EkJ6c/oVmIPlHBKGYVkDKWhrXP1kzRPb
         mr4uiLwVe+2X7eKfvb7jU8M/4vn3BaUQcGJt2tMKFlGBo2VdDQBH4y3va4OlHGvSfnZx
         qOH2GOPlROTWiOtx4x2xJoRkTU7afQU1je3/KtbD7YLLugN1n93sLqezlt1MmGU0U4NQ
         InLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730909301; x=1731514101;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jIOvivKbpD/NBWmyfn4+HdgmciRDbmMlOB0Yv5CEaO8=;
        b=i2JCUV/DQ0TfOWPQmtlmlcuHvJE9MSDuylkplOdl72mHQ6b7U05md8Y8sXQydziBaG
         W/23NswZD/aHSONHZTATebuP4jecKWaNVpf1UwGIGSbG2+LUNTwaumbIKe4jSz520oFi
         zA6efZlc4oksL9KB9gigPN2UOv/vYnwp71PpGDKLXIZsqkA9mhnZUEkJ0PKsD5csfhR0
         rcjnARoYDt7rMBYzfLa88Rg/SDM27pwcungu6xfqdtKX9J3yMKSpgP4LgDmTcNAJFD+W
         j6Bx0V4bulUtcJyKu8OGjfiR8t9KyEn8R5HOkBagOCRPJtDRus/49bxnHcW2g1d3laV4
         sYww==
X-Forwarded-Encrypted: i=1; AJvYcCWxW159i4wf8EW2TiyXGew7NabC8ruIQAPbW8iDAZ9QpwRenroIvc+Kq9dTjip0wovWxJ5HdGAqgQi3ehY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHekHrQpEXR79pNv0u2hto+yr8StvPpRZb2sVoTXwPf/jyBF7b
	IHtNR7Q9+gBZlqFIdRNxIVqywadvQWhC2S9YgJAzLOgRtw6ZRoB8
X-Google-Smtp-Source: AGHT+IEpx8rXn18Ic91SBoJyuECHjf9HfGge35E+ERTSWaNN+0yVtsCK2ywFGR/PkRUwYPUfATkGNw==
X-Received: by 2002:a17:90b:53c5:b0:2e2:9077:a3b4 with SMTP id 98e67ed59e1d1-2e94c29d0f2mr27791267a91.7.1730909301462;
        Wed, 06 Nov 2024 08:08:21 -0800 (PST)
Received: from carrot.. (i114-180-55-233.s42.a014.ap.plala.or.jp. [114.180.55.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e99a4f9ef0sm1715476a91.3.2024.11.06.08.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 08:08:20 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot <syzbot+9982fb8d18eba905abe2@syzkaller.appspotmail.com>,
	syzkaller-bugs@googlegroups.com,
	bugreport@valiantsec.com
Subject: [PATCH 2/2] nilfs2: fix null-ptr-deref in block_dirty_buffer tracepoint
Date: Thu,  7 Nov 2024 01:07:33 +0900
Message-ID: <20241106160811.3316-3-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241106160811.3316-1-konishi.ryusuke@gmail.com>
References: <672270b5.050a0220.3c8d68.052a.GAE@google.com>
 <20241106160811.3316-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When using the "block:block_dirty_buffer" tracepoint,
mark_buffer_dirty() may cause a NULL pointer dereference, or a general
protection fault when KASAN is enabled.

This happens because, since the tracepoint was added in
mark_buffer_dirty(), it references the dev_t member bh->b_bdev->bd_dev
regardless of whether the buffer head has a pointer to a block_device
structure.

In the current implementation, nilfs_grab_buffer(), which grabs a buffer
to read (or create) a block of metadata, including b-tree node blocks,
does not set the block device, but instead does so only if the buffer is
not in the "uptodate" state for each of its caller block reading
functions.  However, if the uptodate flag is set on a folio/page, and
the buffer heads are detached from it by try_to_free_buffers(), and new
buffer heads are then attached by create_empty_buffers(), the uptodate
flag may be restored to each buffer without the block device being set
to bh->b_bdev, and mark_buffer_dirty() may be called later in that
state, resulting in the bug mentioned above.

Fix this issue by making nilfs_grab_buffer() always set the block device
of the super block structure to the buffer head, regardless of the state
of the buffer's uptodate flag.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Fixes: 5305cb830834 ("block: add block_{touch|dirty}_buffer tracepoint")
Cc: stable@vger.kernel.org
---
 fs/nilfs2/btnode.c  | 2 --
 fs/nilfs2/gcinode.c | 4 +---
 fs/nilfs2/mdt.c     | 1 -
 fs/nilfs2/page.c    | 1 +
 4 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 57b4af5ad646..501ad7be5174 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -68,7 +68,6 @@ nilfs_btnode_create_block(struct address_space *btnc, __u64 blocknr)
 		goto failed;
 	}
 	memset(bh->b_data, 0, i_blocksize(inode));
-	bh->b_bdev = inode->i_sb->s_bdev;
 	bh->b_blocknr = blocknr;
 	set_buffer_mapped(bh);
 	set_buffer_uptodate(bh);
@@ -133,7 +132,6 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 		goto found;
 	}
 	set_buffer_mapped(bh);
-	bh->b_bdev = inode->i_sb->s_bdev;
 	bh->b_blocknr = pblocknr; /* set block address for read */
 	bh->b_end_io = end_buffer_read_sync;
 	get_bh(bh);
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 1c9ae36a03ab..ace22253fed0 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -83,10 +83,8 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
 		goto out;
 	}
 
-	if (!buffer_mapped(bh)) {
-		bh->b_bdev = inode->i_sb->s_bdev;
+	if (!buffer_mapped(bh))
 		set_buffer_mapped(bh);
-	}
 	bh->b_blocknr = pbn;
 	bh->b_end_io = end_buffer_read_sync;
 	get_bh(bh);
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 432181cfb0b5..965b5ad1c0df 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -92,7 +92,6 @@ static int nilfs_mdt_create_block(struct inode *inode, unsigned long block,
 	if (buffer_uptodate(bh))
 		goto failed_bh;
 
-	bh->b_bdev = sb->s_bdev;
 	err = nilfs_mdt_insert_new_block(inode, block, bh, init_block);
 	if (likely(!err)) {
 		get_bh(bh);
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index bdc4b152f6e9..bd86447d2edf 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -63,6 +63,7 @@ struct buffer_head *nilfs_grab_buffer(struct inode *inode,
 		folio_put(folio);
 		return NULL;
 	}
+	bh->b_bdev = inode->i_sb->s_bdev;
 	return bh;
 }
 
-- 
2.43.0

