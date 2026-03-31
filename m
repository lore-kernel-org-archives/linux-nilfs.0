Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C021AAE28
	for <linux-nilfs@vger.kernel.org>; Tue, 31 Mar 2026 00:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774918059; cv=none; b=jcCGoSdn7tckJatzZCITvyYYca2XEpvv3t4AcqnPiOSgCQombFMel7UMV+kz0NGTUdKqIxP1+b4/3OK3AnIqciOm6TocS9LPHP92aS8dXo9LhYQjp7fbYvIdbu3ciGXNdM/bvbIKJXbiiQNuPgWSOtbuexT/JVbuPEsEThcCr4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774918059; c=relaxed/simple;
	bh=31hyAr5qnO2ZAn2FtMQYOOoqve3sNAartVoxJqMLyQU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n+wgrCrRoEKoTALYkEl+Y1Tgu2fzDfkpLOsXF6x9e3Sm7zfuM70MSYDJDns4xZx8SmbWGyH7s8fVs7pCXDmwUJlmjZrdypSXAftTLykyCA96hT2iNZkR8BQScQeKHEuKDUZRosH/WiiX+nlzZekzkFVOZ8TRNO88299oWvfD2fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mm2QM4jD; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mm2QM4jD"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35d94f4ee36so1469536a91.3
        for <linux-nilfs@vger.kernel.org>; Mon, 30 Mar 2026 17:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774918058; x=1775522858; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XEoCEuUEvibf+Zy7fuB4n/BRZrMvg04Um4zRjT0fesg=;
        b=Mm2QM4jDItawAOIyqN5cZGmj85Y4mSaRfM+yiRF8Zx+joNzHsSC38fhrHIUB6nh6+2
         VRWvzvt3Opp+01uL6/FiYgsqXEMGSTrcH5DV1Ejnkz5cHyzDAt/RhFhhqACLkM6mZ1ej
         1uamRIuxGyfEOtlctNQoqrf09B0PLxiSHS3FyWRxVZTpRSTeoBU2Z4e638syYaWdZqqP
         Ppeomrt9rVoe8uY7LdvWNjWOzT5pPIpVEEUKbfRf/TH5uMgubK7xTRyBqrLeSzq9r+w7
         iGxQX0vaE0afjpT4LGMud2KCr8NymKS9ueVyECKXY2GKLFl76PvVeecJyiLA87OQR6SL
         8+eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774918058; x=1775522858;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XEoCEuUEvibf+Zy7fuB4n/BRZrMvg04Um4zRjT0fesg=;
        b=Gs6uAB8tCElCYdfwYD9P9KLVY+1v5KnOALXPLB+e5bbp5xH6Uc9E+Qb+Mu9SYJzo0q
         m/kioMsovUPSLFBYZqf+lyUKlxpLEkxIdscLtIfw1lX0bwKgdBrT2j6iNBouwONPn04I
         2a8s7L5++JjWD9l3+LsnpbEQBn+YJL4bgy9xz9lpA7ANhPmTVINvXLWAI7GXgOxiXTPY
         5ACc4xjqmtDmLeCdSm1lPDEJZmMEedU7JFDjrs8BfE7qHoeBp1dTA6mjJL9B97K3pt/3
         jH35B+G3Bq5W+/a/hYXnXX2M3kSuOYs4UEJ36ShRB3YjQQsAwnahXIlJOjSNmShIm6jj
         vcfg==
X-Gm-Message-State: AOJu0YxM+2cv3CpR80s3ROxyVh49FrUCdur92hRj6o/bMGB4/2YNUM5/
	atOMxp9IO4RmNoZ/vRQAz9xGI8MWYfoj18Ck5gyVBZkIjyx2BSC53QEC
X-Gm-Gg: ATEYQzw11QaY+lZK8uucish803hG1vBoKqGsUlu/SA5lelyqRS4LlLJ8BgXI0IZKC0B
	YA/Rr/UlJZdHEM6wdMYI2YmeZ+zmda4ucLmxUM7duAHqkDNREFsBfBaK7AZh9JLxRyGdpMtvcrf
	QAgJHclJ05Yp9KhkTChJB3IdLWYCnyqjKmJ4wvL/yKHyDNvSIQgFrtk0loV9iCWkPUdK7+0Eh2c
	8Ls7Nv7yInlmQ2cs+APETJGXxgjbL59iqFkILDcUBne3M4XilX7lx8ZAE90jdsGNCd/YCCJLNuM
	eLGlcPxnygJs36WZDAEJkC+uudO5cRtekh4ZOPR9W1s4WTezMK8sEbRbjHzyyjl1C4MF5FKH50v
	MkLPzsLV9Gb57uUNKAPSnVcT3dXunp19f8Du19kwSQaNg0+CZ51zzvpSY2X22R3vYFEYG65+s0y
	qhXTAvUSMQHm8yg/hsE3iuPIoU/CTG72UMv2GI0oBrJf5YavDBkONbNBajfr6DLYjaUquRhsyCC
	VDnDkc=
X-Received: by 2002:a17:90b:5203:b0:35d:a62c:19de with SMTP id 98e67ed59e1d1-35da62c1f30mr5556813a91.1.1774918057781;
        Mon, 30 Mar 2026 17:47:37 -0700 (PDT)
Received: from carrot.home.local (i114-181-46-93.s41.a014.ap.plala.or.jp. [114.181.46.93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35d94d053f8sm8608583a91.2.2026.03.30.17.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 17:47:37 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Deepanshu Kartikey <kartikey406@gmail.com>
Subject: [PATCH] nilfs2: fix NULL i_assoc_inode dereference in nilfs_mdt_save_to_shadow_map
Date: Tue, 31 Mar 2026 09:47:21 +0900
Message-ID: <20260331004734.25792-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Deepanshu Kartikey <kartikey406@gmail.com>

The DAT inode's btree node cache (i_assoc_inode) is initialized lazily
during btree operations. However, nilfs_mdt_save_to_shadow_map()
assumes i_assoc_inode is already initialized when copying dirty pages
to the shadow map during GC.

If NILFS_IOCTL_CLEAN_SEGMENTS is called immediately after mount before
any btree operation has occurred on the DAT inode, i_assoc_inode is
NULL leading to a general protection fault.

Fix this by calling nilfs_attach_btree_node_cache() on the DAT inode
in nilfs_dat_read() at mount time, ensuring i_assoc_inode is always
initialized before any GC operation can use it.

Reported-by: syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4b4093b1f24ad789bf37
Tested-by: syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com
Fixes: e897be17a441 ("nilfs2: fix lockdep warnings in page operations for btree nodes")
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: stable@vger.kernel.org
---
Hi Viacheslav,

Please queue this patch first.

It fixes a potential NULL pointer dereference defect that could be
triggered (likely most cases are intentionally) via the GC ioctl.

Thanks,
Ryusuke Konishi

 fs/nilfs2/dat.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 674380837ab9..888dc1831c86 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -524,6 +524,9 @@ int nilfs_dat_read(struct super_block *sb, size_t entry_size,
 	if (err)
 		goto failed;
 
+	err = nilfs_attach_btree_node_cache(dat);
+	if (err)
+		goto failed;
 	err = nilfs_read_inode_common(dat, raw_inode);
 	if (err)
 		goto failed;
-- 
2.43.0

