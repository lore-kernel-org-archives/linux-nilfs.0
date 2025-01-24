Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92F2224CC;
	Fri, 24 Jan 2025 22:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737757301; cv=none; b=kmEKOGRTTB6hH8rxt84Ol1CGjnSzH8KhmU4Irob960GZTWQ14TieBLFvlYghY52FYw9TGlU/5luYpw1c37QsmP5AgmqjKVfn4/v7uFRRDfUvGDQNf1d+Ey9pmHCqLfNP5+9dx+ZnGecVRLBWKhkCaLI3KWI7MArpPgcescOxOQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737757301; c=relaxed/simple;
	bh=DFHVtpm5WRlp6fk8/2L90OXAD00RGBbr6Aqyl2ZZc40=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tLFK9LsETTUINArJxNbekE5rDEbbad+RiEcT5DueZIcZZYMn78p1Mjlm8N1rAa8vn0Y69pWwSB9hOxfrxuQS4e3dOc6rHI3IEGORyQCvTn+P40uDMjujVj7ifGqU/P9jLFDCTQRo9WTisiPzMttMLybTvMScBhtWQacdAcl6ISw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jeUhXucb; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jeUhXucb"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2ee86a1a92dso3872301a91.1;
        Fri, 24 Jan 2025 14:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737757299; x=1738362099; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0uh1VYqMHEULRTRj+ZhwSgmFGNbcJjirINg2aG27/4=;
        b=jeUhXucbc30/FifU5TnLcBbV/j/m8GRbWJtZsFkHcc6zsRciD47BFJuoyKQ9Q9HZ/d
         YaS6A4czl6dFKhRkxXkY1nZg/p305E1waCE18OlwSLvARTwNlgp4XiHL4S05mbVGfxMC
         pMZTB71BmqHKPM4vA9oyKcsVwMtildPUf1uPICPnx2xCvvwA+QEqdPPTjN49aEliy9lu
         uhTYRMGmCyiPMfXsOhixt2//7DUT4S3VBenY1eCr5Cn8hVQHWM79kVJhmJN3gEFxIkrW
         2Dja7qvNryjuPwXoZXSsMjddhMUQPmrOEORIeZcn/MOFgb/PKiIfX6W6XnnZFxNjCzIe
         rO3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737757299; x=1738362099;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q0uh1VYqMHEULRTRj+ZhwSgmFGNbcJjirINg2aG27/4=;
        b=Yg5v9twuW/6kz/tArOGXjfDcGmQXqrSjYyFBwMVm++u34Vmnn3PrVleFcNsKHY1fVi
         gmE3nBGtmIBVxeYiWxIs7kmd57zXRm61TIw8qGPFmaLao9CkfIo2x2JylPk6Q+cDXgGg
         JUKIVOd2Knr+kGm8HL1JKiKb6CmPXF02jWDjRQ+Y3rfQfXz3UEGgyVXq+8XiwHEOVF2E
         UWxyqa13LlHpsbwJ9eLBUSvjf58/C0MG9DLqPKDsxwtoLjBH2r4y4Zt1PPjuLuQRtpGY
         S63vAMZ+tQLIlfg0gCZAA+y3Jj+v6CFk9xOmC5f6XXYfc/4Dh0HC5LIs2cr32qZjsDPI
         lH7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWteg/yIW+EXouFjchmXQ6jATaT2t8RT7UEMLwYjk9dOZdxtOg7DzJ+TbMWKtHdkBV2SvqoIFgc5LAxj8Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yytxq/agoWLV5/KdEbBFcb53z03K9BPx1S/c0sWHmgTCnNL7Yrg
	H+OimZ9TdSefEwNniuIKJ16BJfXZgQJYZ3468lLU4XvzJ7t8VyxmIwmMsQ==
X-Gm-Gg: ASbGncucT5l/RyzWaY5MXLKjply8SSUbjYVwYPtiKKgyIG5h9445G6Ba9Wa5h9VL6oW
	MDli165FjXGoOer2FqnmffDIMf09JHd9GLkQbRmsi9h0rS6OYiemJFvLG/yNv/PS8Al3PDBbDvT
	Lk4znBbR0zRHMl6N4raN1JYbI6zCe8JINfGVSAc+htiCqq4pjb5e0ThrDRS5MzQnbY/9RumWywK
	9msfgh2mJ2xvVKBskbZWA7hWVILZ+fBYF33zUJSR7SDnr3DtlOgioPKLtZSA7gAzrrt2z+Uxgal
	03j7o6SosckNSurqu0rVP127tA20LYRYoDGhk+1mmvMVHYmrkQ==
X-Google-Smtp-Source: AGHT+IFVZWZMdI3aYM18TpoNRTEz/h1aB6RIBzsS2uIz45fhqbeHyFCNb/O0pxd668nCHPC/zWpDEg==
X-Received: by 2002:a05:6a00:849:b0:725:f18a:da52 with SMTP id d2e1a72fcca58-72daf92a025mr48388418b3a.4.1737757298743;
        Fri, 24 Jan 2025 14:21:38 -0800 (PST)
Received: from carrot.. (i118-20-85-182.s41.a014.ap.plala.or.jp. [118.20.85.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a77c73dsm2468953b3a.140.2025.01.24.14.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2025 14:21:37 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Subject: [PATCH] nilfs2: fix possible int overflows in nilfs_fiemap()
Date: Sat, 25 Jan 2025 07:20:53 +0900
Message-ID: <20250124222133.5323-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

Since nilfs_bmap_lookup_contig() in nilfs_fiemap() calculates its
result by being prepared to go through potentially
maxblocks == INT_MAX blocks, the value in n may experience an
overflow caused by left shift of blkbits.

While it is extremely unlikely to occur, play it safe and cast right
hand expression to wider type to mitigate the issue.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 622daaff0a89 ("nilfs2: fiemap support")
Cc: stable@vger.kernel.org
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Hi Andrew, please apply this as a bug fix.

This fixes integer overflows in the fiemap ioctl that don't happen
with normal FS formats, but can happen in special circumstances where
the segment size is tuned to be extra large.

Thanks,
Ryusuke Konishi

 fs/nilfs2/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index e8015d24a82c..6613b8fcceb0 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -1186,7 +1186,7 @@ int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			if (size) {
 				if (phys && blkphy << blkbits == phys + size) {
 					/* The current extent goes on */
-					size += n << blkbits;
+					size += (u64)n << blkbits;
 				} else {
 					/* Terminate the current extent */
 					ret = fiemap_fill_next_extent(
@@ -1199,14 +1199,14 @@ int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 					flags = FIEMAP_EXTENT_MERGED;
 					logical = blkoff << blkbits;
 					phys = blkphy << blkbits;
-					size = n << blkbits;
+					size = (u64)n << blkbits;
 				}
 			} else {
 				/* Start a new extent */
 				flags = FIEMAP_EXTENT_MERGED;
 				logical = blkoff << blkbits;
 				phys = blkphy << blkbits;
-				size = n << blkbits;
+				size = (u64)n << blkbits;
 			}
 			blkoff += n;
 		}
-- 
2.43.0

