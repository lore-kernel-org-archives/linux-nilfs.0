Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB6C3612E3
	for <linux-nilfs@vger.kernel.org>; Fri, 17 Jul 2026 16:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784307419; cv=none; b=e5XRRaDJg4kSpEvBRTsu7rkPqgzaGO/kXX327HMhZrCjHXdqszgeolYRznQ2arwPzfeZecXG+k1Im49V/4l7lJN3E+jSyzPQwLCjNAaCeTnu0h7DdFXwOGT265RKIAOiAbazUsNgelU+Ras4J2UYPWeKeDE6UZv/d0tkR9kEp7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784307419; c=relaxed/simple;
	bh=RscQNZstiVa4MqUFlplLktroQovjFGkf+cEGG8/lA7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hkM0ZSbo/xNbRyv1h5I3srWoc2tU0Bm6ZN7bshwU3fF9OnWcMG69BHjoR4qAubuibWYgcyEJweysqBeUin0MH7blN9y2hanVl2SZrDjDlKlyQlinNO6PqXxMv/eGKMIfyCizmlytrQd5Qx/c89FeunHLQkJgH39EBA1XXz0zkaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O32VQYe5; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O32VQYe5"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ceaf8a1265so76085895ad.2
        for <linux-nilfs@vger.kernel.org>; Fri, 17 Jul 2026 09:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784307417; x=1784912217; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=630Nymhk79OC7oRXP5aVD/h9vdOnis4FUjXTJXEAOQ8=;
        b=O32VQYe5QbE6Bi3XVyhiJSTCMVzBzlypPDB/a98KwaKwkt4uSFi412DJf7RXdvLAEg
         VzoDvofg899tKPBGKpP2dOfd1jYGNDSuvJoRSuHKOG/jaBd+WnMtqptB5i1WOrHzjNRs
         Ffwus2M9/+vjolmc0ee3JBRG0idwpUTG4h2avEd8UYR+ls40TLdj31UhVlmJBiKyTkB7
         1kMWYWaFHbOetLhyM4u5CtquY80nJKnoxAEhMNu+jkGSYDVyxRsb+fQAhYFL4z7/N4Nj
         /m/nAtSz0qCw4SgEVZZG8UkHiJoFeITUmKYK693pVKuXbIY3Ybzye1izuI8e3Lqortwc
         4+kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784307417; x=1784912217;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=630Nymhk79OC7oRXP5aVD/h9vdOnis4FUjXTJXEAOQ8=;
        b=ST4grID/m4HxO6lnhk+1BmzkNc/WjLooEhXd3kMpezfOnzCLRQBiRmaebqE3x0X7GU
         dt+szqNyXeyDjIZ/nobSnCc+tgBUMOEhDZnvmjzVukJIsk7VOY3ard0S3BwJY4lvNnOP
         U4+zMLHycfDxp2SIhvUa2tcnSl7a4Lxp8vP81V3SkIiJLfCf5+sbtPXePoXprvcAvyvW
         +kNm0WAgnMogk8x6fsae3k87704YUIEm1k/eFEfZytYlAYZRuHP+5QPJFJiN2g/4EsBZ
         /z05054DqWXDVA5mS5ND9C8ei6oFRhXr4NbeMOst/FJARvnHNYjYIdTLG7GOR9Bhk97g
         qzzg==
X-Gm-Message-State: AOJu0Yz34JlnokO3JXLyjnvEIorT2WJ7t1jZmlOKxOAckGV5Cua7J/z/
	MdcbFkCzrcOOipvvi0w6G1sL4b7KtA8IH/KdJf0yqlz6Vpk1unvsdvxi5FkaBA==
X-Gm-Gg: AfdE7clPOAZtmmQeGn9Oy4bKQ1w4YRFK3r4kBkIVKFzJTUt3C1v7od8XTad/MFtlj/J
	CtfgnJqwL93TPk45k3+TjUkgpIV5GTxkn7GXrhxbgPW26OqAenMtfMd5PTPBEGi56qIw5nkQUvV
	m+Hj7jIGt2J8l/sy9fziiUkkgSlWJPxS6j60qlkyQPJDdyA4mfyfIL/e8Tke11SlL/vn6iSvkSe
	MPR/ajvqbKimNW1SiHXqAHX/Dw/5ws7rFw5klUU26sPK0IXNnEO4Rx1LF1RVx5a8owdxO5SCz9F
	ud2ZtGtJS/NoO1VENQrda62zZ53yU/LDSe8eXlkbg4UFChL0rQZ9lJXfrXw1kHDAGGWikt8w9pQ
	smV1kuS/5ogiQDQHTkzQVvvsJ7YwRwFSH0fL34z3dWJV89oY7PQTl3hhkvCuxP/9tYZWKptaJoF
	70l9J2JX30/7iKHXdVzr429NEbX+S+38h5FeVC65mhW5dn8gf0/jv5N6Ip
X-Received: by 2002:a17:903:2c47:b0:2c9:cf41:adf9 with SMTP id d9443c01a7336-2cf34a822c8mr38902835ad.47.1784307417400;
        Fri, 17 Jul 2026 09:56:57 -0700 (PDT)
Received: from carrot.taila25129.ts.net (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf3448fb2csm15269625ad.12.2026.07.17.09.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 09:56:56 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	David Lee <david.lee@trailofbits.com>
Subject: [PATCH] nilfs2: prevent out-of-bounds read in super root block parsing
Date: Sat, 18 Jul 2026 01:56:21 +0900
Message-ID: <20260717165654.151990-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Lee <david.lee@trailofbits.com>

super-root inode metadata size is trusted before nilfs_read_inode_common().

Reject super-root inode sizes whose computed on-disk footprint exceeds the
filesystem block size. This prevents malformed filesystem images from
making nilfs_read_inode_common() read past the end of the super-root block.

[ryusuke: clarify the commit title]

Fixes: 8a9d2191e9f4 ("nilfs2: operations for the_nilfs core object")
Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: Codex:gpt-5.5
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Hi Viacheslav,

please apply this for the next cycle.

As described, this prevents out-of-bounds memory access that could
occur with a tampered file system image.

Thanks,
Ryusuke Konishi

 fs/nilfs2/the_nilfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 7b23e373a106..f3805e7aabeb 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -461,6 +461,12 @@ static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
 			  nilfs->ns_inode_size);
 		return -EINVAL;
 	}
+	if (NILFS_SR_BYTES(nilfs->ns_inode_size) > nilfs->ns_blocksize) {
+		nilfs_err(nilfs->ns_sb,
+			  "too large inode size for super root: %d bytes",
+			  nilfs->ns_inode_size);
+		return -EINVAL;
+	}
 
 	nilfs->ns_first_ino = le32_to_cpu(sbp->s_first_ino);
 	if (nilfs->ns_first_ino < NILFS_USER_INO) {
-- 
2.43.0

