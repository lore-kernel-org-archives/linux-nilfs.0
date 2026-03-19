Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F321339E167
	for <linux-nilfs@vger.kernel.org>; Thu, 19 Mar 2026 09:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911981; cv=none; b=pBWRgPm3SQldvqDHlZz5k8838JSaii6o3gF5CXE7ASvJnTNWSLoOBu8X7tEVPaV4UdeuvEJAR6GCRAig9eZ9Rm2GP0Ig+EKuE86LW7K9gHxjqHrSBVhYO4BziihFeZeOGpOumPBaHmH8eHyewaoRHIdSMrNavZvgife0ZEkPCgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911981; c=relaxed/simple;
	bh=fDKevgTBJUE73Uk1+tVrzYh1bpQ9qQqHkYDye6eSKjM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DTJP59py0O4P7tvuUOCWDsSjWZQEhAZu2d7C552E/97GpOPadmE34HHRHT2iCDYX0HffgrYMbvZQYg9/cLASHHvB6221zT57KA+3xMnAIb79LU68bdaqnxJ4PW4AU9DIwK54LyjZtyzsvrxAZSfli/k5Zp2WCQAYktNc8A/LkI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T90YAnY2; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T90YAnY2"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ad9f316d68so3316835ad.2
        for <linux-nilfs@vger.kernel.org>; Thu, 19 Mar 2026 02:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773911979; x=1774516779; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HR8u6FKYjwr6a00oYxjn2yVwYgx+XN6JPKinstUheyg=;
        b=T90YAnY2/8lIBI3mKvZQQnMJMPleGOkswFeRCSIa5YOiHliDsQ8rfwVJi5kr+osZKd
         wR0u8HUI8WV+sxzKJpL2wU5RXAQdUEbUKDEtW6zJ3SIfSNnX6wwYme+AhEvdAnPkYQ/A
         0yhP+sixPY52zgNvK7mRHJNdHMuJtbMO0RPR3vVMt5rC4JrFciVhRbdJDz5ljgKm85yS
         RYC9Zu5mubMueFzRicAVmcA1MV2ZOF7BLlVVgzZsS6Rg3X3u8EDAXAngnJzdWLzUhELq
         6Ow+ALEj78F5qjv+StumgaTF9MyG7Oe1mr/zIpdXf2iwj8JbllCruTC7mEz2vonkBMnd
         afYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773911979; x=1774516779;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HR8u6FKYjwr6a00oYxjn2yVwYgx+XN6JPKinstUheyg=;
        b=YdGrYxx00SdKvxeq0GSllPaor0LYOjSGObCvNyM9YsDoHl7HNowAWOZ5EiSO9AcmWU
         BFXs4O4JnKnWW4VjHSOyPiWFOO8jABH0mRWP+l+V+WqK3V1ZUAZAW3frlY1J8jz7YNqT
         uy7IBxXhZfsaD6brGkGnLxrqT0F3bGfmoDIqS77DdayxZ4uuORA9q5hYQsAIj0BR5JPK
         20wOBQrMo/AWQlCOBnA+b67Fcn/U0kIofqQJTSgS1zK7fdR9AU/BSOjp0XNBWphOySXJ
         bxNusMqZF3S+KZDwLqwBzURrKS+C8/Zh+6SlP58o9hgoBgCC6171TiRaoLVQMJnDBz4D
         ZxqA==
X-Forwarded-Encrypted: i=1; AJvYcCUVWDM8v95iXCxt07DD4ab/VdWujhcE7wO6wAGiQTtOWEtERQf/X1Ap7ms70i+sIBaBUcctoi203ASG/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxpc4ahUSqCFjiSInJ3Un0Y3AW/jPehhLd3jZgxCQgBJ0DxIqj0
	9Q/XI5l14k1y1O6ofuH5nmakap5AzaUMKCclcxZlU1a6RCGRpdmC7Fqn
X-Gm-Gg: ATEYQzzIwcletjw3A0kCmYiK48pdNTmNd8OFJrXOXSg6lxf1IjNt9LKlY2cTU7fMJi1
	GPDl0ZwEmtwL9vHh7o2ZKlZ17NB2BjomOygqvbm+kVT/uu8N/Fv7ObvgSbUxOY5UdR2uQcwl2qf
	poZ1TvJ8RS6sm8N3jMyRaDqnPn+vnhw9AqnMdrWsH04GvNxH6hhnrPRXh1pzpVkmvtEK7dOSppB
	VMzBjt7S3AjxTpYXOHb6fCr5gMHI3SRyOeZ4uKclr1JjUcyGWxyDcq5wBAFWdcw1sT/qggUsASF
	vu6v5py4QUO0Qe/8wHXq/xibCdiI7WTYBdP2EqtDW7GezWqF5L0egW2audDqlHMLktqMA640vBF
	h7JHxtCs5HBmt2YDMzPAJdtMvd/St3LaVVV/NX6psbcY2f6k080uZeksoDz55idJnK58fgPmbP6
	LpgGB1Z2UDnxYu9FJLtCHLYggW0rz5v4PDhb/a4FWNlri3F7AskshKalEh3RAkUdsy7yj1X3WHZ
	GIDqlI=
X-Received: by 2002:a17:902:f547:b0:2b0:7177:d5e5 with SMTP id d9443c01a7336-2b07177dc04mr49869815ad.43.1773911979219;
        Thu, 19 Mar 2026 02:19:39 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:2136:a371:9567:156f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e445075sm61786745ad.31.2026.03.19.02.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 02:19:38 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: konishi.ryusuke@gmail.com,
	slava@dubeyko.com
Cc: akpm@linux-foundation.org,
	sato.koji@lab.ntt.co.jp,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+98a040252119df0506f8@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>
Subject: [PATCH] nilfs2: fix missing continue after -ENOENT in nilfs_ioctl_mark_blocks_dirty()
Date: Thu, 19 Mar 2026 14:49:30 +0530
Message-ID: <20260319091930.1088735-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nilfs_ioctl_mark_blocks_dirty() calls nilfs_bmap_lookup_at_level() to
get the current block number of each block descriptor. When the lookup
returns -ENOENT, meaning the block does not exist, it sets bd_blocknr
to 0 and continues processing.

However, if bd_oblocknr is also 0, the subsequent check:

  if (bdescs[i].bd_blocknr != bdescs[i].bd_oblocknr)
          continue;

will not skip the block, and nilfs_bmap_mark() will be called on a
non-existent block. This causes nilfs_btree_do_lookup() to return
-ENOENT, triggering the WARN_ON(ret == -ENOENT).

Fix this by adding a continue statement after setting bd_blocknr to 0
when the lookup returns -ENOENT, so that dead blocks are always skipped
regardless of the value of bd_oblocknr.

Fixes: 7942b919f732 ("nilfs2: ioctl operations")
Reported-by: syzbot+98a040252119df0506f8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=98a040252119df0506f8
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
---
 fs/nilfs2/ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index e17b8da66491..1615a314f557 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -745,6 +745,7 @@ static int nilfs_ioctl_mark_blocks_dirty(struct the_nilfs *nilfs,
 			if (ret != -ENOENT)
 				return ret;
 			bdescs[i].bd_blocknr = 0;
+			continue;
 		}
 		if (bdescs[i].bd_blocknr != bdescs[i].bd_oblocknr)
 			/* skip dead block */
-- 
2.43.0

