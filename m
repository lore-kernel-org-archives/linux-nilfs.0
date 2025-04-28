Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BC2293B42;
	Mon, 28 Apr 2025 17:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745861900; cv=none; b=ei9ebNEaQE1rfJCduyq4Zy7W+ZTtym0rZZL03VfGqxFjudsj+tMEx0Y6lKUQQ/K5MGLBDFtC/PE8dSxajudmbziWXF3t3VXaSxm5H3qW16iGGheCbU1oMTuUVdfNTB0jVHHjXqsju54xDjaigfJ4EV55dKxIKDuISG12flVDSvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745861900; c=relaxed/simple;
	bh=sI4xUuynXlKJP1KBFDKfVHyeVUZVRtG+2X+Ansbw/8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmJCY8tirCRV296nia+r7jCsmMcx+RbgQWT6VG1jto5YHepO2ZqKJkUnpACZ4ABYElQczU8/ZzDVkR63IuPb6zSqLbpMGcV6SuipWVFi61YB0roAHB/ohlGXAty8eTbrXVR6TNMum76sAhJnJyoM4z4kX4Nu0sM3Z2QXmECoO5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NmFC5to0; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NmFC5to0"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7399a2dc13fso7285232b3a.2;
        Mon, 28 Apr 2025 10:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745861898; x=1746466698; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l7Lt6KZSsmnzKIBYRmaXbRG2SpwZRB7wlWIwgOvP2rA=;
        b=NmFC5to07cdxpim3XixkZAEXtPcTWqArzu2tduuftb88MloM7WmWfPzX/BCX58aYnG
         l8a8yy5ojItR/1w6OrpaKadUHhmZWJsAKwzTrfQkGgRdujH8rfRvr/ymPlgevuWbSAfT
         eNNkjmz63E8skeuPwv1aOKUIJMGM//ycUGX9zhJ/Nax1zMdlnFPA7PMbPqKXEUi2uJfK
         I1dwcXKtJ/JmqndycantjCUSkYdQb2VyItdBQpQEvMEMENxkIYfNFGTVSf/f33l6YdjI
         L0Lax1QswNW0Ku7UoSsUEmxBAN734nQglctW5bvnRUP7JpEvTR9sn3f0VXMZxHCcuER9
         5vpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745861898; x=1746466698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l7Lt6KZSsmnzKIBYRmaXbRG2SpwZRB7wlWIwgOvP2rA=;
        b=Kdw3DkVzmy2xekQwwNjoHLeldCqPP1iN/Dx/epwD9CK8U1hlPFoPKUwxjr0T9WR8us
         kXX4CdPBHDhexLFrfk5zQxyTNE1ziYj6YByKzAjvf8SIKssDlQn0nHx71WEKXJaTf5lS
         e7vqx4M+UsV70WgEKZ3OM4tDqxJvWFJFTzB7ONJLj9QxVfx46MzvRhcbPN02VhpZYT3v
         oWlR/cTFs2zLPXV35zaHlT3vZWTsC1rysRA9zcXcvHyiA6MXcHtCduKEbfqeazkBSRN5
         e4rsu8BEsie2UDgpipJTgZyveGL8Jguh2cTwK9NQYoh4FmwzM1syfo1SKn3bq8tP3Mgg
         7Ucw==
X-Forwarded-Encrypted: i=1; AJvYcCWHzcylJG3xG73PoEZj+wRcCWdBSRUJZiO9VIzDDLGGG88WhlOOZ7MPV1RynOTK5qcNuEkvu0GaGP0UIj4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwA0oTlb6QqasF7YTlU819UBNHh+4HaFBeTKocBIPx30z6MFndG
	Z/zh6Q1hfaT0S1GlFfn+72qzdYdjQeRJ88vEK+UHsQIt07YoZ5sK
X-Gm-Gg: ASbGncvwFOKPn+7U8I/huYrXQraDT1ktzx9nk/Tf4ny1pPhblksNJtXrITsMnkcv41j
	WGwANN/AUa6mOnchylzbVkXpA/BSxsanA1hNi56RijmQOYmiaE8Schk54bzIPM6H6U8La3GZIOk
	xqM+Idq1TSQJNTIuzRM7nXPb4IBgEiyKd1LZw/qIj4jew5w3Wrhiwvbcx4DPYeb9V20dk6bVvFd
	erVHGI13MIrZSmYIfhbsqwXmb4khj6hMzT90sJJO0xeN+xuBJyvnLsSoFtR3AdN3jNRr6lbduwv
	Mv0NDSDkMywMHzQjYCEyErCzJKcxD9sQ65ryENNPBEUGt88JgNWTY/xr7YtReuWiiK/reYLjLIK
	67p5zyj+ygokMkGQ=
X-Google-Smtp-Source: AGHT+IG8csLyo48iIbYmGd34kxg00zSICFz/9+kN9R5uWwKr/jcYTCBDG75dHKUM1lBTFYUSIwyJvA==
X-Received: by 2002:a05:6a00:3909:b0:736:34ff:be8 with SMTP id d2e1a72fcca58-73ff73bcf13mr14730691b3a.19.1745861898385;
        Mon, 28 Apr 2025 10:38:18 -0700 (PDT)
Received: from carrot.. (i223-218-150-204.s42.a014.ap.plala.or.jp. [223.218.150.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25a6ab27sm8314939b3a.110.2025.04.28.10.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 10:38:17 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 2/2] nilfs2: do not propagate ENOENT error from nilfs_btree_propagate()
Date: Tue, 29 Apr 2025 02:37:08 +0900
Message-ID: <20250428173808.6452-3-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250428173808.6452-1-konishi.ryusuke@gmail.com>
References: <20250428173808.6452-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for writing logs, in nilfs_btree_propagate(), which
makes parent and ancestor node blocks dirty starting from a modified
data block or b-tree node block, if the starting block does not belong
to the b-tree, i.e. is isolated, nilfs_btree_do_lookup() called within
the function fails with -ENOENT.

In this case, even though -ENOENT is an internal code, it is
propagated to the log writer via nilfs_bmap_propagate() and may be
erroneously returned to system calls such as fsync().

Fix this issue by changing the error code to -EINVAL in this case, and
having the bmap layer detect metadata corruption and convert the error
code appropriately.

Fixes: 1f5abe7e7dbc ("nilfs2: replace BUG_ON and BUG calls triggerable from ioctl")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/btree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 0d8f7fb15c2e..dd0c8e560ef6 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -2102,11 +2102,13 @@ static int nilfs_btree_propagate(struct nilfs_bmap *btree,
 
 	ret = nilfs_btree_do_lookup(btree, path, key, NULL, level + 1, 0);
 	if (ret < 0) {
-		if (unlikely(ret == -ENOENT))
+		if (unlikely(ret == -ENOENT)) {
 			nilfs_crit(btree->b_inode->i_sb,
 				   "writing node/leaf block does not appear in b-tree (ino=%lu) at key=%llu, level=%d",
 				   btree->b_inode->i_ino,
 				   (unsigned long long)key, level);
+			ret = -EINVAL;
+		}
 		goto out;
 	}
 
-- 
2.43.0

