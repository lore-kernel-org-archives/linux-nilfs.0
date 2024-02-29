Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA777CF05
	for <linux-nilfs@vger.kernel.org>; Thu, 29 Feb 2024 12:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709209145; cv=none; b=AZAi78aWJLnklzYo8KhpKdlX3FJ+S4BbHH2EhgYki4Z1gTo6XYKSw3nq3ZuwoscWNuIV2VHNdGwY0ZBbLXA7HGoN2GEvjqjcgTvTzoAAli4Xmxo2ky1HTc0hNU7P7bkiF9A3UjS9wLqojjzcTfnh7/2doH/UdmGSOaol2eSl8gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709209145; c=relaxed/simple;
	bh=ob9I68XwHPK2eYEM0MtrNgpwmwAN/WdbqJzDEKS2+i8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kdy/bMQMcP9ez4WFxNaDz16LAo2Zp53RgyCiLO2f4Q+DHJOBLZjcm7MY0EkbPrZoVa+Ed2dtVi279z31YFrcaxQF7cHXh2o3GqREb7AfQoVedXjj+vR7emScyr0nVBC3PUME+CMsuAc1MJwaTrjk3N7OAp3J9YZLpvSm+2+DPUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=YPQZvCho; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="YPQZvCho"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a28a6cef709so133245166b.1
        for <linux-nilfs@vger.kernel.org>; Thu, 29 Feb 2024 04:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1709209142; x=1709813942; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CK/gyhWcnx3ozsMFB9IWH6XZsidf01J5WrD6CcF2Cpk=;
        b=YPQZvChopeY9iFwuo+s48f4HVQ9CKnfYQCIZgELkj334wmHYIa8L1G150L3OhACbrA
         f5EszpFYTRKuNXuaMPaTM3xYGsmKm/71bjMuUo+Dxxdbt8UzAtRuBn0bV1pBm+MvzjoE
         yr2jjOyAR9seg4Cn5eXubaztErGFbQlS2FvlW/F852VnqCuc6xApmAhlD0x3VZnErZEc
         CamXHbHmj53Nrpeka3SD6fquFODbv8IXEXnd9eCI0tD4bLBNjziptU/UqVbLZDhh1iCS
         U8aGNiZSJl0/597qrfO4Ax7IZ54tsioY4FOkXRVtaqHMz2Oh5HMEXgvKDJj+PAlcIOpX
         eTrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709209142; x=1709813942;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CK/gyhWcnx3ozsMFB9IWH6XZsidf01J5WrD6CcF2Cpk=;
        b=b1HURIbjcr0jUD3i00xmWyULvDkKzQwCGcDMoYoiCK2Ea2FJb7JH+6zD+ToUQO8qDG
         HwUT2jazM768CZvx2jbAWhBY+vjVnlo0HFAkRET6ORwCa3N0z6fsW4g89UUqJKRQtdIS
         E0atKs5A1dfJw2Rgpke6LdynYzhqiBEpsBkDGt63e81cb5FmGERR8+unLQHkKyKJHjUY
         1tTz5SYF2ly2+ExCvN5pcKu2x62IUpW++iHszX6K92xQ7YLI4TnXO2sB9cY7CdJC4LIN
         wTlgUCferPIXsR9KE2T7tkE6nj2hcQI9RiBt6tu67GacmfVtlkRq4SU/QmySajHJO1fy
         MqKQ==
X-Gm-Message-State: AOJu0YyjXCYgI5FKVszELHFgN05qgFZNDRYSApK6NPiZ9mpBho+/KTMZ
	Jgeo3cnaNN9Q0Nz/9HMVXVp/rL2jlzl9EwWtw82SVi1MRU73BrYuHgmxWCSjaw3A8mIqot0wG4D
	aIY7ssg==
X-Google-Smtp-Source: AGHT+IF6pa9RCtJLn2UJSZqPkK7BUg0kISl2l4MpvEHaWBWsTVgXcg8Nrgt3oGsfmrlMYsK5JbqVOQ==
X-Received: by 2002:a17:906:f6d2:b0:a44:415d:fa3b with SMTP id jo18-20020a170906f6d200b00a44415dfa3bmr1229733ejb.6.1709209142367;
        Thu, 29 Feb 2024 04:19:02 -0800 (PST)
Received: from fedora.fritz.box (aftr-82-135-80-35.dynamic.mnet-online.de. [82.135.80.35])
        by smtp.gmail.com with ESMTPSA id vi10-20020a170907d40a00b00a445db55f39sm161039ejc.156.2024.02.29.04.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 04:19:02 -0800 (PST)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] nilfs2: Use div64_ul() instead of do_div()
Date: Thu, 29 Feb 2024 13:16:50 +0100
Message-ID: <20240229121650.33983-1-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes Coccinelle/coccicheck warning reported by do_div.cocci.

Compared to do_div(), div64_ul() does not implicitly cast the divisor and
does not unnecessarily calculate the remainder.

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 fs/nilfs2/cpfile.c | 2 +-
 fs/nilfs2/dat.c    | 2 +-
 fs/nilfs2/ioctl.c  | 4 ++--
 fs/nilfs2/sufile.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 39136637f715..bafbdca1a17d 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -28,7 +28,7 @@ nilfs_cpfile_get_blkoff(const struct inode *cpfile, __u64 cno)
 {
 	__u64 tcno = cno + NILFS_MDT(cpfile)->mi_first_entry_offset - 1;
 
-	do_div(tcno, nilfs_cpfile_checkpoints_per_block(cpfile));
+	tcno = div64_ul(tcno, nilfs_cpfile_checkpoints_per_block(cpfile));
 	return (unsigned long)tcno;
 }
 
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 9cf6ba58f585..df5324b0c0cd 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -460,7 +460,7 @@ ssize_t nilfs_dat_get_vinfo(struct inode *dat, void *buf, unsigned int visz,
 		kaddr = kmap_atomic(entry_bh->b_page);
 		/* last virtual block number in this block */
 		first = vinfo->vi_vblocknr;
-		do_div(first, entries_per_block);
+		first = div64_ul(first, entries_per_block);
 		first *= entries_per_block;
 		last = first + entries_per_block - 1;
 		for (j = i, n = 0;
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index cfb6aca5ec38..f1a01c191cf5 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -1111,7 +1111,7 @@ static int nilfs_ioctl_set_alloc_range(struct inode *inode, void __user *argp)
 	segbytes = nilfs->ns_blocks_per_segment * nilfs->ns_blocksize;
 
 	minseg = range[0] + segbytes - 1;
-	do_div(minseg, segbytes);
+	minseg = div64_ul(minseg, segbytes);
 
 	if (range[1] < 4096)
 		goto out;
@@ -1120,7 +1120,7 @@ static int nilfs_ioctl_set_alloc_range(struct inode *inode, void __user *argp)
 	if (maxseg < segbytes)
 		goto out;
 
-	do_div(maxseg, segbytes);
+	maxseg = div64_ul(maxseg, segbytes);
 	maxseg--;
 
 	ret = nilfs_sufile_set_alloc_range(nilfs->ns_sufile, minseg, maxseg);
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 0a8119456c21..c02b523d9c7e 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -48,7 +48,7 @@ nilfs_sufile_get_blkoff(const struct inode *sufile, __u64 segnum)
 {
 	__u64 t = segnum + NILFS_MDT(sufile)->mi_first_entry_offset;
 
-	do_div(t, nilfs_sufile_segment_usages_per_block(sufile));
+	t = div64_ul(t, nilfs_sufile_segment_usages_per_block(sufile));
 	return (unsigned long)t;
 }
 
-- 
2.44.0

