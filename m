Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001703E0C69
	for <linux-nilfs@vger.kernel.org>; Fri, 10 Apr 2026 22:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775859000; cv=none; b=phjJK3PrzxDt0uOGKOU7n7h5w4bfr8oRKnhjQ9LqBNBAQTTj7Muz1FPYGoPpsesq6hQidSRWrnlQ35NmiLdxiVqasMtxhvPXRjvng0FWrSGtsGy3ywtwnhvWs6LjVlvmT/y/Qbx6MDCLX3Fy2HJJTFTlJb+joyqK3upUIqj1M1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775859000; c=relaxed/simple;
	bh=c+w0PHX2emHFrUDcE4HRgBY8dM0zYSZ9lqcyJPE9VJ4=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=nr7my+3yMvZ4P2M8O8fX8w+UAO1ELNJ5SjVhb45JS2KZAzuCGVRIpAo5bG/hnKcKyJFyxeuK32VaZfm/jyVQLhpSCSuVNNcHqKfjq3ErkA3LIPNbagNKmu8Vo/wHk/yHR6l/O+MA54BmdszTViSO7cLsA9MHL8yDkQDJ4XNzpfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=zTKxkG0d; arc=none smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="zTKxkG0d"
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6507a7d2eccso2655413d50.0
        for <linux-nilfs@vger.kernel.org>; Fri, 10 Apr 2026 15:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1775858997; x=1776463797; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt:date:cc
         :to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fQcMp0dTb2c9NR5jykKdSHnksmK+T1YUw6hYUqur2yI=;
        b=zTKxkG0dU5Qh1fTM+ozs/WuajxPAkI/ieLX7yf+sDrY/aS3otanvGl7vqvkLiNGby6
         jNQaGzIjjCchkZCx8uzz93JGpUtmLBgRB6N+UaOdscCOPiE1uWKDjlmvNaYDSNEkn0mS
         lnX3HzBmgfeVu+KNerkbj2cg/mY3JBMVC6uG4VgLaqTfExppOles+Yp6jwQq4mnL1uq2
         /FdX9w6sczWeCLRRJN9GRKuFR9Abyavskbvk4rOhZQsw1VXDqpGMNZFB5gAx/g6zCH50
         njtVNQwW/B1EMKGErEPrH5PbMTUIf+pzbIG1KjJ9ULR2iF281gN0FviI2Y6fbsYGHy5x
         8P7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775858997; x=1776463797;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt:date:cc
         :to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fQcMp0dTb2c9NR5jykKdSHnksmK+T1YUw6hYUqur2yI=;
        b=ayy7ZCDH2J2IPWzhFmeRPe6MGr71WOsXQNRFUN92Lzx6xHRkFEdhoWp9PflwOLcZTF
         ZqNa4RunS8YYw/N0qkZj7PDA3EzLpZZvIYtahGgB/28iU8iaoJ+HffKmnadAw56lKkRR
         /apcqhhJkNunHgrSB2hK0xLRWmc/aCDFHigM4xzNADY8KA8+nSDRq9Ok4Xdx798LH0In
         YSiMl16oBMmyjEawiQAg7A4QxEV1DSpY7VfE7r+q23LZNYOy1oAOd6CSiHiuqPSrV96b
         eKo67XCUUgn1Sdv7FGfG0C+ojzBTJs3Y+Mcz2gxHIFfzed8Kw1NEPVL4GU4FOwIIeoKw
         CLJA==
X-Gm-Message-State: AOJu0Yym8GSZwdtVSuZ6yhjnWmLHBnZzbTdIhveKrY+DGLnguNyUzEUt
	wt6dDpGVSt9fmIPHlAlOr4HFVc1+77oUMblfDqnQws5F0/eD/quRvvPzLtl7J44lMD1RsB87Hq6
	Uulxkaf8H7A==
X-Gm-Gg: AeBDiev0CEU4bM4E8UNu6+s+iZIb38icwNac4oJPsjod1baeLeL7QTYSQrEmWLmxmnv
	brPquywHfTFUtbrCUR7mBlvgXKIrwTDxccW0XOSI/UQ6z3i6Lgd7N7S2VitJ6mSZYU09VbMg9hh
	wvb905CYOO6o7b4BPi2s+DvwcRC9zEnJISMQ4Nh7RSuPoX48THWuuEXoG0D9IiaxWigKtxTP/+b
	WU4T7P82KutWC7Tlwqx7GKX4WHeMA11AgxvAqMwoQdOxTnVyofSXvhuT4DnmTbZGkdP5MPpVgYc
	QTYXbSt7YsLADgcU3MlyrGZ5BTTQT6DfoMg2/UnZRL+057XHKHm26F2nAY4NgVZTM6Zh9g6owa4
	gY6UNds4qzU7SViWMK4hmbi2ST7CH7rtcQYAvUOHfHh8XCxLSBRoMEJGA4Hn3F9vXiUuUgGhN32
	+C+0cYXPD4FhtPsnYrIxP5ll/0VsH0YltJE+k7eSzFOzPUo25ujB0dMdaTBEEu/PFEgmuXbNUS1
	Sz6ESrCFyxCyoObWDUhZrpXifHbqRtG9/WqsRPQTxDjoWQtjIswpr+QOIFA
X-Received: by 2002:a05:690e:248f:b0:64c:97ae:2e75 with SMTP id 956f58d0204a3-65198c168c0mr3439933d50.69.1775858997021;
        Fri, 10 Apr 2026 15:09:57 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:cd6f:deb8:7bef:a487? ([2600:1700:6476:1430:cd6f:deb8:7bef:a487])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65197a6f42dsm1912522d50.6.2026.04.10.15.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 15:09:56 -0700 (PDT)
Message-ID: <527a5bdc86b866f96a9ceab4aae7180e12f74624.camel@dubeyko.com>
Subject: [GIT PULL] nilfs2 changes for 7.1-rc1
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: torvalds@linux-foundation.org
Cc: linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, konishi.ryusuke@gmail.com,
 Kartikey406@gmail.com, 	Slava.Dubeyko@ibm.com
Date: Fri, 10 Apr 2026 15:09:55 -0700
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello Linus,

This pull request contains fixes of syzbot reported issues in
NILFS2 functionality.

The DAT inode's btree node cache (i_assoc_inode) is initialized lazily
during btree operations. However, nilfs_mdt_save_to_shadow_map()
assumes i_assoc_inode is already initialized when copying dirty pages
to the shadow map during GC. If NILFS_IOCTL_CLEAN_SEGMENTS is called
immediately after mount before any btree operation has occurred on
the DAT inode, i_assoc_inode is NULL leading to a general protection
fault. Deepanshu Kartikey has fixed this by calling
nilfs_attach_btree_node_cache() on the DAT inode in nilfs_dat_read()
at mount time, ensuring i_assoc_inode is always initialized before
any GC operation can use it.

nilfs_ioctl_mark_blocks_dirty() uses bd_oblocknr to detect dead blocks
by comparing it with the current block number bd_blocknr. If they
differ, the block is considered dead and skipped. A corrupted ioctl
request with bd_oblocknr set to 0 causes the comparison to incorrectly
match when the lookup returns -ENOENT and sets bd_blocknr to 0,
bypassing the dead block check and calling nilfs_bmap_mark() on a non-
existent block. This causes nilfs_btree_do_lookup() to return -ENOENT,
triggering the WARN_ON(ret =3D=3D -ENOENT). Deepanshu Kartikey has fixed
this by rejecting ioctl requests with bd_oblocknr set to 0 at the
beginning of each iteration.

The following changes since commit
6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f:

  Linux 7.0-rc1 (2026-02-22 13:18:59 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vdubeyko/nilfs2.git
tags/nilfs2-v7.1-tag1

for you to fetch changes up to
be3e5d10643d3be1cbac9d9939f220a99253f980:

  nilfs2: reject zero bd_oblocknr in nilfs_ioctl_mark_blocks_dirty()
(2026-03-31 11:05:55 -0700)

----------------------------------------------------------------
nilfs2 updates for v7.1

- nilfs2: reject zero bd_oblocknr in nilfs_ioctl_mark_blocks_dirty()
- nilfs2: fix NULL i_assoc_inode dereference in
nilfs_mdt_save_to_shadow_map

----------------------------------------------------------------
Deepanshu Kartikey (2):
      nilfs2: fix NULL i_assoc_inode dereference in
nilfs_mdt_save_to_shadow_map
      nilfs2: reject zero bd_oblocknr in
nilfs_ioctl_mark_blocks_dirty()

 fs/nilfs2/dat.c   | 3 +++
 fs/nilfs2/ioctl.c | 6 ++++++
 2 files changed, 9 insertions(+)
