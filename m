Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B0A4418CA
	for <linux-nilfs@vger.kernel.org>; Tue, 31 Mar 2026 17:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774979582; cv=none; b=LGQ/S3imPaXp9kaHANU+RJL/qhgIZuIyah8r0dUdBrPXo5DNNqksvyIxJ/15wTQofN3K2mKnmS/s/QWN/IIKmGSWEfHXUaTtBcOTnnuviDo6G9Z4VSWBJir2Sme1B5WT0sXNK2Za6Pd5itiCpLWXSwl2ZWHo71LgWN4JKG2nnEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774979582; c=relaxed/simple;
	bh=QAZXf4JkOAmC+Mx/SpSz0uAK8WAYsJWx1iucQR2ubXk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hF9APnCtjB26AlagIsvU/r63CSWKkgeQJ43TYZudun1T7WDMjlQ2C0Q5O1cSC3mbi+6AcCbioJGb9GrqYx40ORFfs4Odm0OQa7Ps9IVqByI5ATC9YveE0ykchySYeqJDMzhaEMpy8uiJ554Tuut51azgv1EuNmr8ePvxXQC2aRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jv800zfu; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jv800zfu"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35c124d2613so3849399a91.2
        for <linux-nilfs@vger.kernel.org>; Tue, 31 Mar 2026 10:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774979577; x=1775584377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fed1i3OKdyyPfPcS5zEZlT7I7sjgHB4UBU0/7zGF7T0=;
        b=jv800zfurZ+1e6mv2QGDc6ovb5dTzJqa++edh9NKNy1/7TO2aaBhDTKxAR1SgyiW3F
         ZHMhTIVm1ZiMNFec8NtKK6FarSMaBP5xLnlXhh1sq30oF76+/usycYe5f//+wZI8Zd34
         NZxTX1ruKFQiWH2i92tI2fJo47+qeJfMAvQ0Int8LtMyCrA3GSeXipdjbBlAQK2rGCOf
         /uz/DM0O8JRSidPzByoEn6/D6S3b3u7Ijbit61xaImkB02+TTBCpwbR9K6paTwfo/fDm
         EwZPxoEJgYyiVbxLXfvKLzK1c0Z0lBTVGFrBFSY0TvLltTDw4MShepSx4NtjCwLHxVp5
         o1eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774979577; x=1775584377;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fed1i3OKdyyPfPcS5zEZlT7I7sjgHB4UBU0/7zGF7T0=;
        b=A6fU9oR5bTbYVlCCS39CthiDRo2CAVz6nSbwr8evmSAcRGhjZML64/kazLVCLJvl5v
         0s+K5bRxrcPNPtcCmLnj7aFaVXYf6hxmz22h6gyabQLZASVjiCUK6jYvYIEXqcru27Le
         BH/UdxBYsTj/yZABQECG9MnM6ZXUqHTJ6SLULHTCgXZaZsjqXLZvkvJlCIj/LUn2VNLk
         1IupyO6iJQEoJtG19dAuadARrHqG/0Y8nddmC9uol7MeHO+Y3DMl2Bo0SgBqOF1s5/YV
         0NTedn9gLaWICepfk/YE2FGNXXwB5IOHWJX/snEVCKoKa9OPFqKQZwOL1pHbJ64lCuuB
         rB3A==
X-Gm-Message-State: AOJu0Yxy2xTtO47GlxgWGNxt9hndMMdLCPq8EXTIMSGevWo0epiiOIl2
	73b7qQ7D7MuhBaC2sfasYtvFn697dXqWu7IwTJsVw94ff2O/H3+XI3hx
X-Gm-Gg: ATEYQzzsOFcORZILC7RzAtTXI8uamjn9gD424N6ktqQmc8z5nqPQDQXHjToU5FmoLhU
	WLQ322nAu9vydYf2TTga/ep1nyPH2AY834VrGG4q1YJLVlmXBVWmRi7M/YLjkxSsJOeEN2mKB6u
	lcS6+BWXOuA4z3L4hxvsMUse3vBH0VwCC+lh+iujEdKRCC5cw1LpdR4txTJn+IF67zlbC36SEFz
	OkMy3gnv96naHPnvLnjfB6jgOQ5AXixp39CAgJqWc18DpCXlKO3AZO0M+OCgrU4eKwrfnGjeXwX
	jwOTVY7lVmraEtMrW3e7IIIuDOrRqRlOVaC4UlgC5c69HlvgNgCZOjAJcS69i+3MgdWDZ0+oaAn
	A0XAvnx9/Gh+1Nfka0+BT4tyua+hK3Jf9m44des1/a9Ck+Dn94k2tgec8nsjnc9ct11vBRfozec
	NFTgmmBHDPD3LgZJ7Af7WUFHQtv14/bwKAuEjgL6Z1Ln+Py07O9b5rH1MPSi7+QnWVIH/n7zxua
	Hp+GBw=
X-Received: by 2002:a17:903:1ca:b0:2b0:624f:8edc with SMTP id d9443c01a7336-2b269aba73dmr1339905ad.12.1774979577486;
        Tue, 31 Mar 2026 10:52:57 -0700 (PDT)
Received: from carrot.home.local (i114-181-46-93.s41.a014.ap.plala.or.jp. [114.181.46.93])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24265e7basm163211155ad.21.2026.03.31.10.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 10:52:56 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Junjie Cao <junjie.cao@linux.dev>
Subject: [PATCH] nilfs2: reject zero bd_oblocknr in nilfs_ioctl_mark_blocks_dirty()
Date: Wed,  1 Apr 2026 02:52:09 +0900
Message-ID: <20260331175253.32329-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Deepanshu Kartikey <kartikey406@gmail.com>

nilfs_ioctl_mark_blocks_dirty() uses bd_oblocknr to detect dead blocks
by comparing it with the current block number bd_blocknr. If they differ,
the block is considered dead and skipped.

However, bd_oblocknr should never be 0 since block 0 typically stores the
primary superblock and is never a valid GC target block. A corrupted ioctl
request with bd_oblocknr set to 0 causes the comparison to incorrectly
match when the lookup returns -ENOENT and sets bd_blocknr to 0, bypassing
the dead block check and calling nilfs_bmap_mark() on a non-existent
block. This causes nilfs_btree_do_lookup() to return -ENOENT, triggering
the WARN_ON(ret == -ENOENT).

Fix this by rejecting ioctl requests with bd_oblocknr set to 0 at the
beginning of each iteration.

[ryusuke: slightly modified the commit message and comments for accuracy]

Fixes: 7942b919f732 ("nilfs2: ioctl operations")
Reported-by: syzbot+98a040252119df0506f8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=98a040252119df0506f8
Suggested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
Reported-by: syzbot+466a45fcfb0562f5b9a0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=466a45fcfb0562f5b9a0
Cc: Junjie Cao <junjie.cao@linux.dev>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Hi Viacheslav,

Please add this to the queue for the next cycle.  This fixes assertion
failures that can occur with broken GC ioctl calls recently discovered
by syzbot.

Thanks,
Ryusuke Konishi

 fs/nilfs2/ioctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index e17b8da66491..e0a606643e87 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -736,6 +736,12 @@ static int nilfs_ioctl_mark_blocks_dirty(struct the_nilfs *nilfs,
 	int ret, i;
 
 	for (i = 0; i < nmembs; i++) {
+		/*
+		 * bd_oblocknr must never be 0 as block 0
+		 * is never a valid GC target block
+		 */
+		if (unlikely(!bdescs[i].bd_oblocknr))
+			return -EINVAL;
 		/* XXX: use macro or inline func to check liveness */
 		ret = nilfs_bmap_lookup_at_level(bmap,
 						 bdescs[i].bd_offset,
-- 
2.43.0

