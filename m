Received: from exchange.fintech.ru (exchange.fintech.ru [195.54.195.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A3618FDDE;
	Wed, 15 Jan 2025 17:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.54.195.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736960916; cv=none; b=LrQ+hzBPP7BkZhYLUtcyH2XSbo9HFbygEgkPkjhwcdNg3KgA/XDROPcYMn7I8NmoCjzUTxMNMsFB55cKxu2zBBdAfx2bCIsJTHGJXsammfgtcogF4Bp0pswwl9kddqeVpKN0xk5HCvpEqClIn8mChKwYi6wZ/oO5G0Bhd57JETQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736960916; c=relaxed/simple;
	bh=iymsNcDcWLkQQVC9XD804Me7b0TnOXuib9UtaIrB9aU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TTaBfTybUPi1aQMgBxjKZbiyGkAD+dLz0fqdg0xlsjq+rns3dkMBrKl5VMlaY93+FJTU/fX4USWbtr0BMlS+toahE0bVP25XK3hLTBklY6GYYKoVXzr4/AHcKr9r8iYJ+xC9KgjOHzT0po1D+2v5sDwZe4STVuw7KZrEOkQDFGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fintech.ru; spf=pass smtp.mailfrom=fintech.ru; arc=none smtp.client-ip=195.54.195.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fintech.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fintech.ru
Received: from Ex16-01.fintech.ru (10.0.10.18) by exchange.fintech.ru
 (195.54.195.159) with Microsoft SMTP Server (TLS) id 14.3.498.0; Wed, 15 Jan
 2025 20:08:31 +0300
Received: from localhost (10.0.253.138) by Ex16-01.fintech.ru (10.0.10.18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Wed, 15 Jan
 2025 20:08:31 +0300
From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
CC: Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	<linux-nilfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<lvc-project@linuxtesting.org>
Subject: [PATCH] nilfs2: fix possible int overflows in nilfs_fiemap()
Date: Wed, 15 Jan 2025 09:08:18 -0800
Message-ID: <20250115170818.20177-1-n.zhandarovich@fintech.ru>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: Ex16-02.fintech.ru (10.0.10.19) To Ex16-01.fintech.ru
 (10.0.10.18)

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
---
 fs/nilfs2/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 23f3a75edd50..81abb58dcbd8 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -1188,7 +1188,7 @@ int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			if (size) {
 				if (phys && blkphy << blkbits == phys + size) {
 					/* The current extent goes on */
-					size += n << blkbits;
+					size += (u64)n << blkbits;
 				} else {
 					/* Terminate the current extent */
 					ret = fiemap_fill_next_extent(
@@ -1201,14 +1201,14 @@ int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
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
