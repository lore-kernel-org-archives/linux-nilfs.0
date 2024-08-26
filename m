Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7221F199E98;
	Mon, 26 Aug 2024 17:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724694103; cv=none; b=CZQmNUsiwt025jVKPJ3F9hQbw3q/Rd5KLd1aiPQjyYoXovIPyAxo148oiJ5RY/zhMDrTMNLvW5wExl3Be4VX3Fjuy8p99IyJsBNuMeyQAwE4UwXINWFMWvmeIi3ExUEW1wL6Nnu+if3c0urdHjU483rQR50+R72T7ywAEZYZtvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724694103; c=relaxed/simple;
	bh=6zSzFZFe3h3eDhLBMdxRCjldoMTaVeuNKbeAxFerYFM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Jy4s6vJn3/HCQmTFSd1sL/WRrnGVS9eYICBLjY6dJRx7JYuDFChtMhWb1adBgQkoM5lTinkm8gHaJtWxzzvDPkFCzYyP0o2rR3zHozlnoXnLs+kgyg1cT0ocHRJQJdx3UM3H6ziJUgZmlWUhDBumDWacxu87TXaEh7w1YibDJzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g+6DJzEw; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g+6DJzEw"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-201ee6b084bso38508605ad.2;
        Mon, 26 Aug 2024 10:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724694102; x=1725298902; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4mDuiAC/qu6w0a6uIXp9njoo4Dr+YYWiFR0sSENdoEE=;
        b=g+6DJzEwpssJzwmQ5tps0j6xJX1FYwlAz3MuPhV1pnIfRq1OvMtb+IH06pb4eQkoKU
         IXKZTnP0b6pXscyk3gVj2kE3/CmVvIrlZyCXSLkFceGiI474f9UigXN/b0l4SpxLTBof
         pPqb5l5jz7mG/vwbpqs+yWBMm7gS719GAqnD0At0HoYIRVI+LmQk7hpAZ1a8irZp0mxk
         RN+t+V0T9LmkMI37iqfrrTmMzVoQrp9+7rikxPwvGIboxJ9A5iyFaq7JoXWp5DiUmc8w
         lOD/Qn1SfCbg77slZlepar2OGFnFOASJJ592XZVRn/Scf1xsA2ZafNBxPKJi2QwYzf1O
         WK2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724694102; x=1725298902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4mDuiAC/qu6w0a6uIXp9njoo4Dr+YYWiFR0sSENdoEE=;
        b=YNW3AQgIE06HBs9N7omzJ9EXvgMNh0TFQm0sXUddreJLRIQ9lQ3yCRheNq5mxjZMxt
         5OfWJtSoDEz+gg2CtU/RkazwdbUEKeWsmjSiKgQ1GvmamO13Wr36D9KiGv5dlEU0J1rI
         oPdxkK5WWOOXTQNAECK+wk3hMdl8hOXTBPHbq2BIa7OYL+N8Ri4sFWiARqvaN7mPSPwI
         Q+59SCwwvm9TYCyI783paJUsUgbe7q6QjFyuuHH26IHmSkF8mBu/cp461yMPa+yMAE5J
         JIg8z5Lx6xc81w57iBqZBqBwh5DFqV/v4DLCcsCFrW1l+nIMtRQzJubGNQeh/lkIBh7t
         Js4A==
X-Forwarded-Encrypted: i=1; AJvYcCWfSn/gqQ3ByMS6ArI0860XW/boT4CBOwn/mEg8Lsv1TgrapvYBSQt43ekoSdJy3fgUcY4jc+6MySuTA1k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxiovXZ+AbKWa6UWJzEajtuoYtMhFs1VI3WxDnLYvzfWBGcvhT
	JU51asXB4HBC9G3fBOETt1ZTNd2aVQHBZ5RrGxlBrIgPk3JyK4PZ
X-Google-Smtp-Source: AGHT+IFQsvLgChmY/9YM/SfmKmalDY6bnJ6mGedeMf7oyl3XF5pZSBBSTYNl1jM6mDoQyb4RKdoPwQ==
X-Received: by 2002:a17:902:9892:b0:202:49ea:b6f4 with SMTP id d9443c01a7336-204df4853f0mr2460755ad.37.1724694101522;
        Mon, 26 Aug 2024 10:41:41 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855665besm70057055ad.34.2024.08.26.10.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 10:41:40 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] nilfs2: do not repair reserved inode bitmap in nilfs_new_inode()
Date: Tue, 27 Aug 2024 02:41:13 +0900
Message-Id: <20240826174116.5008-6-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240826174116.5008-1-konishi.ryusuke@gmail.com>
References: <20240826174116.5008-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After commit 93aef9eda1ce ("nilfs2: fix incorrect inode allocation
from reserved inodes") is applied, the inode number returned by
nilfs_ifile_create_inode() is guaranteed to always be greater than or
equal to NILFS_USER_INO, so if the inode number is a reserved inode
number (less than NILFS_USER_INO), the code to repair the bitmap
immediately following it is no longer executed.  So, delete it.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/inode.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 3c4a0577bc71..3742baec4920 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -345,19 +345,6 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	if (unlikely(err))
 		goto failed_ifile_create_inode;
 	/* reference count of i_bh inherits from nilfs_mdt_read_block() */
-
-	if (unlikely(ino < NILFS_USER_INO)) {
-		nilfs_warn(sb,
-			   "inode bitmap is inconsistent for reserved inodes");
-		do {
-			brelse(bh);
-			err = nilfs_ifile_create_inode(root->ifile, &ino, &bh);
-			if (unlikely(err))
-				goto failed_ifile_create_inode;
-		} while (ino < NILFS_USER_INO);
-
-		nilfs_info(sb, "repaired inode bitmap for reserved inodes");
-	}
 	ii->i_bh = bh;
 
 	atomic64_inc(&root->inodes_count);
-- 
2.34.1

