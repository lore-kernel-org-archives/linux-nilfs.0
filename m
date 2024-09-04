Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BAD1990DD;
	Wed,  4 Sep 2024 08:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725437656; cv=none; b=jksPFq/XcUnsh7kB0zVnZd7MqcTnb/Sr2Aqrs0ipZNtkk5QdlC1bNKF68UPbV3wLKokm5nz2TiZYglsU+Fr4NIh9V85r64Glg7CLBBIyCDwX4yPhq9Qde4wy+46tO/bXUdAfcFHROL7Iyz/gTFfDxoRgJf7EfM6PEOaXJ9YI1qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725437656; c=relaxed/simple;
	bh=QB0+ZygBpaO9VbdZ31kZaEGP4j7nJUqUXS2cOhC2TLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2TUvP8Czp44966i8UkacHMnzIO+n16Ocps26Gx1UKWRJ/02ikFWdASZCeUrYTz2Aa8pIj2alWTj2KUm5AoRW3lxX470EUfCAttd4Hd5aF7xYAdBKmZwPBz6ZzKaAtd01IdG2wLoGGWuxOzqlopObIAJj6f1tXcZHsOQPVkI4PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C/4RsUfG; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C/4RsUfG"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7d4f85766f0so1008366a12.2;
        Wed, 04 Sep 2024 01:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725437654; x=1726042454; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cQFld60h6LdVlrl/yTUQ1xklQxHsZil+Jfy5e8vhEAs=;
        b=C/4RsUfGwtD6Zbb1zvJckSC0jezPw3M9GRl1Aef0mSMn12HFpLRjvdI85/74qrOHaw
         Lz6zvSjH60+nAI9ZVb4xdZCoQPGYeQPCB8wn6T7RZiy478ke6UMTqb5Ds7q3rWhv/HcC
         Yn/odKy39Wqunh0yFsNu0hmme1VDUC9iCpfjkd8K98qMOZMG6/4gmn6Wrwq1dFvFqCHO
         VJ9alm+4xN9S+K9DmUR8RoFOZ/kVx0YuYxFhjDV1GRnfX3eAJcKGTl5xCJYyV9rXsKwi
         EuyzABRVn9RaE/xBOZy7SOpkfVITduslcGmdUhDiqu51T28p75Ms3xQUy71aIcNWFJI0
         hHpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725437654; x=1726042454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cQFld60h6LdVlrl/yTUQ1xklQxHsZil+Jfy5e8vhEAs=;
        b=ImavMggBD7E6zzep6m9FdejWINZpoh6LvApeCWgxnWIQtEysX4U2RfhuDA1SlgGj/N
         uZreilNnrzE6tlVTp6s8f8V1u3GlJ+rktyFRXV51EXkhJbS/M2DxCV/gX0PVBbbCHRIy
         EL8sxTnC/EPvN9zgs3Ptuq8/Tc6l9L3dw1bS1/PL+JFQ40cCcSgQ2Jln60hBIjhizmVZ
         J/XVlAcTay39g6skYRwTu9ztR6AccBSvBIM0iKRDXnH/7TlB6IrndVr/zs78c/Xq+ljH
         Fay3bfntoat5C7+fHTkHBWYaMRc1tbEj7oVAtOWzvn7cW/+0myALFZ2HarAmdD3U4v8L
         yNZw==
X-Forwarded-Encrypted: i=1; AJvYcCUyfbnPmJ4I59nXF7372jPnvUzVctWo9V06UzTQFmpkgImBDVQysM1fp3kKP4DcWMSMqx1QUiSOak7QgSc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1DxAzfDPQtElf0XYCA1H5lgNqtaMdg+Qs38iAy2LzuxHqKo/S
	CoXAgVBAAdyVtSI15jd+BN2cZakmU4hjMt2iMeb7Jo5btXN2mpUh
X-Google-Smtp-Source: AGHT+IHSOA1DXNa8RithznHkqua/xgL4yKBtGUr+aXuAzM8swf/Svf58MFFS/ddP6MVMTT8D0r73uA==
X-Received: by 2002:a17:903:1cf:b0:206:9640:e751 with SMTP id d9443c01a7336-2069640ed91mr48240675ad.3.1725437654464;
        Wed, 04 Sep 2024 01:14:14 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea5832dsm8836485ad.237.2024.09.04.01.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 01:14:12 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	syzbot <syzbot+9bff4c7b992038a7409f@syzkaller.appspotmail.com>,
	syzkaller-bugs@googlegroups.com,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] nilfs2: determine empty node blocks as corrupted
Date: Wed,  4 Sep 2024 17:13:08 +0900
Message-ID: <20240904081401.16682-3-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240904081401.16682-1-konishi.ryusuke@gmail.com>
References: <000000000000b4cf9a062114d132@google.com>
 <20240904081401.16682-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Due to the nature of b-trees, nilfs2 itself and admin tools such as
mkfs.nilfs2 will never create an intermediate b-tree node block with 0
child nodes, nor will they delete (key, pointer)-entries that would
result in such a state.  However, it is possible that a b-tree node
block is corrupted on the backing device and is read with 0 child
nodes.

Because operation is not guaranteed if the number of child nodes is 0
for intermediate node blocks other than the root node, modify
nilfs_btree_node_broken(), which performs sanity checks when reading a
b-tree node block, so that such cases will be judged as metadata
corruption.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Fixes: 17c76b0104e4 ("nilfs2: B-tree based block mapping")
---
 fs/nilfs2/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index d390b8ba00d4..dedd3c480842 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -350,7 +350,7 @@ static int nilfs_btree_node_broken(const struct nilfs_btree_node *node,
 	if (unlikely(level < NILFS_BTREE_LEVEL_NODE_MIN ||
 		     level >= NILFS_BTREE_LEVEL_MAX ||
 		     (flags & NILFS_BTREE_NODE_ROOT) ||
-		     nchildren < 0 ||
+		     nchildren <= 0 ||
 		     nchildren > NILFS_BTREE_NODE_NCHILDREN_MAX(size))) {
 		nilfs_crit(inode->i_sb,
 			   "bad btree node (ino=%lu, blocknr=%llu): level = %d, flags = 0x%x, nchildren = %d",
-- 
2.43.0

