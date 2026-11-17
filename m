Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794898288;
	b=4qMNd4pLs4XLf4En7MLGgBoruaWeCMCjdYejYQMK8Z+Nw36d66DAuE+EhLTXbMaxK4go
	 KHoxbQbUwKMHoU8TOk1cPofThqz6pJGEMC4fQzKqZbMTqgk1tGAQBcIe33Fhxet653eYj
	 FZHEqTFl8PTgaCPIyzwPtaaxpajcakHadttR/e5GNd7CDqWTG2kF/6+j6Db18u8BXnvpB
	 3aJaGQI6pyEKNBjr4T6ylbJRSchJ/Yu75cAc+WqfsT5fSyg74OazzGDuEpqMGyAGtPH/1
	 zftCYFL8QQSW38wW0TtsdknujxX60+pl81YWHj2PkyXMmj9vUiPK8ZaNcFqzqeVX7WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794898288;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Rk1FeQzJrhht2X1kLFkG63MCPIDEd8l5/+J4eSp8hlg=;
	b=O3l8Qb8hi6nmeZdHjaP7ZLEaNCyLE5bTHvNz+I+RC3CxUbv2HeZma5awOQ59GBLK3Sf3
	 zhUOk7bvLMb5mmP+5fAJ9qEr9ebT5Nq05eJfxtsQCWYXYN1/6uYSmicp00K7+/hPtUPoT
	 fmkYThkrZHt+0zYEF1/h5eKrMQhyWlediOvOPE0RSezsd81EZWBzWRq+ZsxY+TTK9ylhT
	 BZKBC/iPJ/P7DeJSF0mHW70D3mRzyTbiX7EZ3wJsQkbKoV/7VIUScAZhZOQOvxRuOP4Z6
	 4QGrDHYhyzozEqL6lYidvjLuCyGgLQI+ElsAJE/8BLpqtAx0+wchOTsJeYhVqcKzOfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rHLcVAlc;
	arc=none smtp.remote-ip=74.125.82.49
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC811606A31C
	for <linux-nilfs@vger.kernel.org>; Tue, 17 Nov 2026 06:51:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC811606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rHLcVAlc
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1a3c08d6928so5995041c88.0
        for <linux-nilfs@vger.kernel.org>; Mon, 16 Nov 2026 22:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794898287; x=1795503087; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Rk1FeQzJrhht2X1kLFkG63MCPIDEd8l5/+J4eSp8hlg=;
        b=rHLcVAlcz5VgIGeYPUZoTWIp0lXLEtc+z7YYIHJuJNRv0h3y9ODnxzr8NlSqrpUmIp
         JGVZnYMxTKCfBv9PcoP6cmGRv3q+fPfFtld5dkyb5pB24UbwWSroisGfsBQkN9b7JpDv
         vTOfJhZhPJtvgqwrd1Gpv18b4C+iqjsPNGBzFnZQ0ItBF0sgDE0CNMX0jJ0V/3IN8RVF
         ABaqw/CAyBLKvQqFbXyYnmOAZk2L+E4BuABEwWnQtsZt183dsQ8A5ZU8tizZSOrjb5ov
         /D8IoZiF+sxdXBFm93yFZ/BS/zncAPC2A40AOoE/RBIuDDhJObs6gNN5lWDAaGxMr6Al
         hdcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794898287; x=1795503087;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rk1FeQzJrhht2X1kLFkG63MCPIDEd8l5/+J4eSp8hlg=;
        b=LLEkCzLwsnM55Vzli9RZRB2Z4ApNCcxQYye0fxv3ZT1kfUDQ61elJXWctbHWWG68to
         1Zz9PTi1yK2ECDVZEW7jUqUmxQxN74VQ+hqVKzEOGzxUFrETm8cSmEG8FmVOyuVFeXmj
         e2J6KABwT0ssoklaai4PJM6+dLpUWEO1610GgoIDuf1aSPUm3IZ0PPXUSAC2pHNq276e
         EaPCrMEIhRJXf0611DepFcIQdtmRlDx/Rc6byEhAJ5EgckO5LwWAdCzy4N6KDYx/DyWt
         5b0rYfc8iMVAYMlhQTEZ/Bpl90Xg7GqnI6qolV0nrpX6SDU1n/uxc8jfxVqzrXl+gDfc
         sD2A==
X-Forwarded-Encrypted: i=1; AL+hErGT16tEkeDW7M49KKTAg0/953odgw1WlsVZS/O+TC6P2fbFaVbmcmzUR++2RuxxZngtOi0UR0zZQjs5zw==@vger.kernel.org
X-Gm-Message-State: APuU4Z9jcpdm4KOF4D/DFUBYCo68OYWqNw2n35rMDAeTI59joA15/nO/
	Tf56YayVESWbiGULRA5zgw99pFtayRAvdvt5kvGjV7kAmFeeX3lglzHO
X-Gm-Gg: AYBFou0bXFSGUVVD7FBn6l4QfcZOhmJQpLLgGGyWwLibb/B0zHzfQ691EUmg3jtJmLi
	giGpK3MAJRuzcyyjlq10tqB8sccmd5AblHwXWbWPFNWRuxb/WKkh50d4vQnJpj1HW7eo5WFtU2O
	+7beZbkXfhlH1GQuXhWmu+Po70A2uT7wGGdsYim/EpbjS66fIm9RQdN2fSxpzzYgIt5O7h8i29l
	ElhLTjDFJIUY0TxWeJa83+aFPCvINcxUUTxiVfB0Vv2sAjxWsNK5+vmL+cozB3GKZRGf1ZyD1Jy
	15UQnyvX0zEr3P0YShVwjwnSTcRBm4K+dtEJIOo5UWcJzkp54kMbW4o36ivZMO+iW7jLLmrCSv9
	+RTgpmOsRljl+nbsoxoYXeird+lkXSanZnGUcD5kniZ2HCwGk7TjIW1fy7n+PUdlUDk6ikbt7RI
	k+2tcYl4xFIGyRDVcL++ZiSeqLGV7nBmPD3bHif3/PEejNx5lHD1PZzwjmSwAY2Io4FR2e8XFLd
	ty2luNlzWYJ56eiye5fDe+mqNfu2nqQmZKlHRsXM9Cin7cxPc5gJ1PiTaGrqMRlq/d4S7P0r6Lw
	hQbCFeIx4eqyXXdeDvAZlm9vJx1fFRkEesNMeA0hoqUUJHsO0jr5eIw4B+xvE1oD
X-Received: by 2002:a05:7022:3a87:b0:1b2:5884:a020 with SMTP id a92af1059eb24-1b50302ac09mr12374737c88.6.1794898286701;
        Mon, 16 Nov 2026 22:51:26 -0800 (PST)
Received: from carrot.home.local (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379565d269asm44099255eec.23.2026.11.16.22.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 22:51:24 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Wang Jianjian <wangjianjian0@foxmail.com>,
	linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] nilfs2: atime support
Date: Tue, 17 Nov 2026 15:47:46 +0900
Message-ID: <20261117065122.41553-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Viacheslav,

Please queue the following two patches for persistent atime support in
nilfs2 for the next merge window.

This series builds upon your original patch [1], which Wang Jianjian
followed up on to address review comments and add compat_ro feature flag
support [2][3].  I have made minor modifications to those patches,
including filling in missing kernel-doc comments and adjusting the
commit messages (such as fixing the Co-developed-by tags).

To use this feature, install the updated nilfs-utils from the
'atime-support' branch of the development repository [4] (which will be
merged into the master branch once this patchset is queued), and either
format a new filesystem with the atime feature enabled:

  $ sudo mkfs -t nilfs2 -O atime /dev/<device>

or enable the feature flag on an existing filesystem image using
nilfs-tune:

  $ sudo nilfs-tune -O atime /dev/<device>

Once the atime feature flag is set, the filesystem can only be mounted
read-only on currently deployed kernels that lack support for it (until
the flag is cleared with "nilfs-tune -O ^atime /dev/<device>").  To
avoid confusing users, this feature will remain optional in mkfs.nilfs2
for the time being, though I plan to enable it by default in a future
release of nilfs-utils.

Note that when enabling the feature on an existing filesystem, inodes
written by older mkfs or kernels have their on-disk atime fields
initialized to 0, which will expose the epoch date (1970-01-01).
nilfs-tune warns about this when setting the flag, and image conversion
(such as copying mtime to atime) is not supported.

The series consists of two patches:

- Patch 1/2 introduces the read-only compat feature flag
  (NILFS_FEATURE_COMPAT_RO_ATIME) to manage on-disk format compatibility
  for atime support.
- Patch 2/2 reads atime from on-disk inodes when the compat_ro flag is
  enabled and stops unconditionally setting SB_NOATIME on the superblock,
  switching VFS behavior accordingly.

[1] https://lore.kernel.org/all/20260219204343.70117-1-slava@dubeyko.com
[2] https://lore.kernel.org/all/tencent_E3847A19056D4E914FACD269A3C77BAF0905@qq.com
[3] https://lore.kernel.org/all/tencent_F3CAF2061A8AE294D88513588FD3DE1F4806@qq.com
[4] https://github.com/nilfs-dev/nilfs-utils.git

Thanks,
Ryusuke Konishi


Viacheslav Dubeyko (1):
  nilfs2: introduce atime support

Wang Jianjian (1):
  nilfs2: add atime compat_ro feature

 fs/nilfs2/Kconfig                  |  2 +-
 fs/nilfs2/inode.c                  | 11 +++++++++--
 fs/nilfs2/nilfs.h                  |  4 ----
 fs/nilfs2/segment.c                |  2 --
 fs/nilfs2/super.c                  | 11 ++++++-----
 fs/nilfs2/the_nilfs.h              |  6 ++++++
 include/uapi/linux/nilfs2_ondisk.h | 12 +++++++-----
 7 files changed, 29 insertions(+), 19 deletions(-)

-- 
2.53.0

