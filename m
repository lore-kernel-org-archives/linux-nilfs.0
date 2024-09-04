Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EA61865E7;
	Wed,  4 Sep 2024 08:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725437653; cv=none; b=p3JWXhmHFAY43vxssJ0Cw+orVMYIUbkfWaUXDqkN+qje3ti5droIkdWQ/tydqA0jIC6t9bQA1yfSfUT24SelJ4A2PD3fXKMiqPba8msX0OGmMoX9AR+aje3AzdU11gdh0wEibXqhhy9j99xRZ8RVDdZW2w/PKMlqCjgft9sMRQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725437653; c=relaxed/simple;
	bh=zMGJdiSfLmXbb/VWHoXDxmssdo4mZPiGT41JDitryd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNDymBoG83iV/kSBAz9oIixg+a3BI6FiS+pX+oXCTDDoaCUTQhlPRq8akCHUZ7Z9fRgW5AIJffwmvSdqvsgtY8DZ4x1P1hPlaaje5mN0hFYCLVOqA5VpRcIGvN6ghCrkvbmQridDZGNEnsBeWUqF4YW5/m5TmQkAOC3OOYvvqWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TTWv76ks; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TTWv76ks"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2059112f0a7so23333355ad.3;
        Wed, 04 Sep 2024 01:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725437651; x=1726042451; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mnCgmF/lXJyYAZItC9G+NbMh+b+sySa8+ME8RzAPTQE=;
        b=TTWv76ks/VhOnhMFAihD5+xahkxGxHsD+mp5C76ifdjShYWObQVNIoe8EmIxu1lg1n
         rjOn/AWjt9CoW9f19r3jo+3r+40nuUNHwp6eh3okY8WHWoPseD07TSPzOz6oiO0csmi4
         XYU+txsQ6Itj4u/TqRKJpneWsTjgT/TkfavYx/7E8EY2Cm7tXy7xdqfpL5dA1cYub1IK
         /Tmom5Vs5Vdw6dLdyPa/39Jh8CbCNjeQ8+axxMrVVNyKMTzjPhFAB/d1SRhM3L4PLy+Q
         q7Of1wIc3gONdb+8yl96mDJqS4ymuqmc+4D4cRiEY145SOdiTC34AMjcUyH1/W9tp4LP
         tWLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725437651; x=1726042451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mnCgmF/lXJyYAZItC9G+NbMh+b+sySa8+ME8RzAPTQE=;
        b=dFraDJtxTrEfZfXaTxkVkqi7yFSL3mLAQH6DPhuWWJz3r6NnBEr2ITFGV/QhII7+PC
         9Xnqr1kGzYGp0S8MwQZqK9U4Dvk8EdJqSY+yh+4ZReH0cP+UO2A4xvs6sBCnPXcaa/WX
         yYBQUgm1RIsoG/z3w13schPHdOeEoInuFoBLdbkmu9bFPQ2X/bsQcVbCXiGkZK9bVpGC
         f748zb2PRdnfeMeZ2f4oz/3kMnaI/dH8nuaS20ocR0FYVr5PMuiAkQwzfRJVLrgmYvAv
         6zFnrk5WzlIO8EcIPElTAJCfCEd9KhPI3UNBmUq8/uRXGUiPPRacUThEIAHLpxuVWPv9
         yg9A==
X-Forwarded-Encrypted: i=1; AJvYcCWYVM4zOqiMLY20OnWrJQggvlCQcS1QH7KNzt9ArdlFUof0F9Werkhk+txY4ibM0f+T+yG2BNu7ZV2W9cg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpMriZCzLzjcyqYpAAJeNdj9bj5hJLIqGeLp+8D9vRH4Z3P3W2
	9JQgcJ2ohhbBHKh26e+I1mFRP4TIuJnGTwPM13joW7QGMkMxntzv
X-Google-Smtp-Source: AGHT+IGwz130RBhLmJu1S77cD14bnDhzCXN9XuFgJTyrxCdP6XYVx1dUW4auWO2BXOeKRPrkpi4zuQ==
X-Received: by 2002:a17:902:ce82:b0:205:4fb0:e0a3 with SMTP id d9443c01a7336-2054fb0e2d9mr125508005ad.41.1725437651268;
        Wed, 04 Sep 2024 01:14:11 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea5832dsm8836485ad.237.2024.09.04.01.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 01:14:09 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	syzbot <syzbot+9bff4c7b992038a7409f@syzkaller.appspotmail.com>,
	syzkaller-bugs@googlegroups.com,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] nilfs2: fix potential null-ptr-deref in nilfs_btree_insert()
Date: Wed,  4 Sep 2024 17:13:07 +0900
Message-ID: <20240904081401.16682-2-konishi.ryusuke@gmail.com>
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

If a b-tree is broken on the device, and the b-tree height is greater
than 2 (the level of the root node is greater than 1) even if the
number of child nodes of the b-tree root is 0, a NULL pointer
dereference occurs in nilfs_btree_prepare_insert(), which is called
from nilfs_btree_insert().

This is because, when the number of child nodes of the b-tree root is
0, nilfs_btree_do_lookup() does not set the block buffer head in any
of path[x].bp_bh, leaving it as the initial value of NULL, but if the
level of the b-tree root node is greater than 1,
nilfs_btree_get_nonroot_node(), which accesses the buffer memory of
path[x].bp_bh, is called.

Fix this issue by adding a check to nilfs_btree_root_broken(), which
performs sanity checks when reading the root node from the device, to
detect this inconsistency.

Thanks to Lizhi Xu for trying to solve the bug and clarifying the
cause early on.

Link: https://lkml.kernel.org/r/20240902084101.138971-1-lizhi.xu@windriver.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+9bff4c7b992038a7409f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9bff4c7b992038a7409f
Fixes: 17c76b0104e4 ("nilfs2: B-tree based block mapping")
---
 fs/nilfs2/btree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 862bdf23120e..d390b8ba00d4 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -381,7 +381,8 @@ static int nilfs_btree_root_broken(const struct nilfs_btree_node *node,
 	if (unlikely(level < NILFS_BTREE_LEVEL_NODE_MIN ||
 		     level >= NILFS_BTREE_LEVEL_MAX ||
 		     nchildren < 0 ||
-		     nchildren > NILFS_BTREE_ROOT_NCHILDREN_MAX)) {
+		     nchildren > NILFS_BTREE_ROOT_NCHILDREN_MAX ||
+		     (nchildren == 0 && level > NILFS_BTREE_LEVEL_NODE_MIN))) {
 		nilfs_crit(inode->i_sb,
 			   "bad btree root (ino=%lu): level = %d, flags = 0x%x, nchildren = %d",
 			   inode->i_ino, level, flags, nchildren);
-- 
2.43.0

