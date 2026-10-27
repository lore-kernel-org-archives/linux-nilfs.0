Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793138313;
	b=MrVsAOfYhGtBuOnMiO1vIPbEyAW89vtcF5ToejZUO0j3fzgTNBoao2WgaYVlQop1x3Uc
	 hpYfjq4jK/W9AqmItwnHIne9NqAt+c/k6AyJxoOp/74kBMImlt4d2bU1Uv3tYfrlHWLsb
	 d5cV+cVGbs9Rn37yDVRwKTUkIuXX+ljH2gSiAFLvu/s50gVmL3qpWSE+1GUDAt5CggyxL
	 rekNgKgds7a160XIXqQYrGIJg55PuyXP2XOb2/UplxvbZUNGnuMfAn7t+KkY7W3XDE2G+
	 qp8gxqQLELpd5XpQ1j3MfONbBAR2K4dhV5OfEZ1WSRkXK3tRuELmMY5nPSdnPvaDPRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793138313;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fKH8lEROlToWUaFVk6HBGi+a3bbRsRUnkhgJ3/v+Ess=;
	b=YCaqMyxlP8Nncn9YGGaAlv8vspXgCp1TZk+gsb/kIfMCymGT/5i+vm0Ked5I4ZQWHqjJ
	 Rs2tcAsXmu5E6hWrf6TbLS2l5Pabblt8OjzjqhJTJ68XUaS8sUQuXo8jegFv2obD55w69
	 OmDzm6Ngbv9hmm2n0h7rM2rXVtojbK430SE6aj8jxJmqQqyiFsrx2IntcuVWBarEfmbgM
	 ruStS8ONUugguqCNxc6tEK7RfvRtL0rk5/qLse2ZP0RcEV7tYkFQsR9iKSxMng+z7cMn3
	 gFHvcFgeDb1en+bKIyUMCikngUuXfCn9WsALMwpA4/qUB6ojMJZcCTuRWX8V4OrnYqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Kktk5MvT;
	arc=none smtp.remote-ip=209.85.128.169
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FFD606A31A
	for <linux-nilfs@vger.kernel.org>; Tue, 27 Oct 2026 21:58:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4FFD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Kktk5MvT
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8b0d126f631so3073547b3.2
        for <linux-nilfs@vger.kernel.org>; Tue, 27 Oct 2026 14:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793138312; x=1793743112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fKH8lEROlToWUaFVk6HBGi+a3bbRsRUnkhgJ3/v+Ess=;
        b=Kktk5MvTTmooZ0Q3aCi26vX768BMQ/1m/1iozUmZR0IzIeWf2BuQjazLJfG3476g/r
         8kvrHa8KOzQV8RrLyDJ1RlEwNQ7Be2n0AY1iiRRdIvzRuc1oPn4B9jjY/M5c2//4SLMj
         USKthEZZWMli+0SNU4AVBbstq5kepiLkMHCLjcclCHsvypIYeFeeQS+wYw7Tchrd69SR
         Mqo4l3cOiuk8Ls1Fk9pOGcS/WnltZVnMA+jAYh1/nSwoFzCdA70wDWhzfkrisd+SUrQE
         6YLG1ywmQCVUi4C6A9d96MuXY2i6KxrufWZylWKs6C1OPJqhIo/CTS2nFacO58n+P2BA
         axtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793138312; x=1793743112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fKH8lEROlToWUaFVk6HBGi+a3bbRsRUnkhgJ3/v+Ess=;
        b=odM9cmcHhYgx1oQoALMhaYGvJMXhznPojZ6VvDhqezn6ouzG8Dm9wjSX7uzjEeXWq8
         BC9i49LepAxTIN4ydrCWrAbH9G+9XwDAfqwMVDrKV2Yc1LWPrEimnRUnDW0SNHAb9MgD
         3Rtg/ihXSiK5r5LiNTcsoR4xufxqNcN+r58qRcnzK3lwKcuwe44TNt+MKhyZ16W2qHrN
         0Cp7PBgXL9b2+5WprWpQyDysv23dM8uWn4IJU1vgYcMg5Wy/6lxQ5THiNkpx28bpyJxK
         dt13lnwmN9W7o8ioesUg6cqodhnKnpJpDyH04+FWfUhr7rGPan2/TZ2nCfxOkH0+Wcyv
         NvJA==
X-Forwarded-Encrypted: i=1; AKwUvByOFiYc0deKvukyMfvuKwoNwRYB0OBO9ORGWiMzqkxHzBUaBnKKgrBDWCl8WEVsiYH+tH5LFbsmQmSO5Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYJI0sLEykFS4dvb0MR37buWDmU3q5sj2n7PuYDQhe7EzQ77F6U1
	tunltyRXwu+JCpYr/IiDyc2OLnPG8e04BVi/v2IGQHSWKGgVlHNzLTVd
X-Gm-Gg: AYBFou0Xx4WnIGNQLlQRQSgsSgUaIGPDh+8+lEfBLRiEhF+kqTqEDjE37fggI/sHFUY
	fOXS6WEAlk8WPiCMrAevDkuCq9/Ak8cR8dVRm+MGfEvQ3lrzc9dUuQWpGT0Cn+KZhd0AWS3Z2hI
	QqX+wpalV4hutmK0BoC96WcXJQGhI63N4cdPh6/cOL22iFMtKcfVOTKC47yLVJTVUXRcSpw6wdn
	97l6ru2V5A+t1kvve2+THBgcYFfLeoKNVl3Bx2KCHS43Tk8Xwyjxdw5N8n0ncdP1A2SvZfmi2hH
	YwPe8eOLJvcuiJSxXcCZ5mZPoocaoqbmoHksJ4XTTr9dZJ6Hs7P3vW5ks4AnZsOvecg7RSfQscQ
	oICbffGgamofOff1ImgzxFEkJWDx458YH9TTYKgQjTd33x955eoeRL7iH5acp3Wd8e0eBaYfI8Z
	tIAzn4Xds7h7vCFXcQlE9PghBRhRaFXahuBuWTsgZobLmeQHyDb5NtW4KOHlojahfprlnRjsDbi
	wCEAk9WODbIOkzFOZIuRRWnD2EtX/WBQXpa7AzHTm6gdnp2/b767j5a8DE23Y7icbALWAO67LMJ
	6im3Eq7XhNf8fhGRXY2nzAjWN7yyHViT
X-Received: by 2002:a05:690c:7108:b0:8b0:7c36:4afc with SMTP id 00721157ae682-8b1b5e81826mr2719877b3.58.1793138311531;
        Tue, 27 Oct 2026 14:58:31 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:71::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b19e59400csm19360677b3.22.2026.10.27.14.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:58:30 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	bfoster@redhat.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	linux-nilfs@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>
Subject: [PATCH 0/5] iomap: remaining patches for iomap_iter_next conversion
Date: Tue, 27 Oct 2026 14:53:21 -0700
Message-ID: <20261027215326.2693300-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
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

Hi Christian,

This is a resend of the last 3 patches from the "iomap: convert to in-iter
iomap_next() model" patch series [1].

Those 3 patches are rebased on top of current mainline (commit 83f32c773255
("Merge tag 'erofs-for-7.4-rc1-2' ...")) in Linus's tree. They require two new
preparatory patches (patches 1 and 2 in this series), which are trivial
->iomap_next() conversions of the nilfs2 and fuse iomap code that was added
during this merge window. There were conflicts with "iomap: pass
iomap_iter_next_fn directly instead of struct iomap_ops" (patch 4 in this
series) during the rebase. These are resolved in the patch, which now also
converts the iomap users added this merge window (ext4 iomap buffered I/O,
exfat swap activation, nilfs2, and fuse ext_map). Jan's Acked-by and
Christoph's Reviewed-by on it predate these changes.

These patches are being sent out now in case anyone wants to look at the
preparatory patches or patch 4. This series applies cleanly to both current
mainline and next-20261027. If anything conflicts by the time you pick it up
at the end of the merge window, I'll rebase and resend.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20260729192737.3190206-1-joannelkoong@gmail.com/

Joanne Koong (5):
  nilfs2: convert iomap ops to ->iomap_next()
  fuse: convert ext_map iomap ops to ->iomap_next()
  iomap: remove ->iomap_begin()/->iomap_end() legacy path
  iomap: pass iomap_iter_next_fn directly instead of struct iomap_ops
  Documentation: iomap: update docs to reflect iomap_iter_next model

 Documentation/filesystems/iomap/design.rst    | 140 +++++++++++++-----
 .../filesystems/iomap/operations.rst          |  68 ++++-----
 Documentation/filesystems/iomap/porting.rst   |  16 +-
 block/fops.c                                  |  10 +-
 fs/btrfs/direct-io.c                          |   8 +-
 fs/dax.c                                      |  48 +++---
 fs/erofs/data.c                               |  28 ++--
 fs/erofs/internal.h                           |   3 +-
 fs/erofs/zmap.c                               |   7 +-
 fs/exfat/file.c                               |  14 +-
 fs/exfat/inode.c                              |   6 +-
 fs/exfat/iomap.c                              |  22 +--
 fs/exfat/iomap.h                              |   6 +-
 fs/ext2/ext2.h                                |   3 +-
 fs/ext2/file.c                                |   4 +-
 fs/ext2/inode.c                               |   9 +-
 fs/ext4/ext4.h                                |  10 +-
 fs/ext4/extents.c                             |   8 +-
 fs/ext4/file.c                                |  22 +--
 fs/ext4/inode.c                               |  58 +++-----
 fs/f2fs/data.c                                |   6 +-
 fs/f2fs/f2fs.h                                |   3 +-
 fs/f2fs/file.c                                |   4 +-
 fs/fuse/dax.c                                 |  10 +-
 fs/fuse/ext_map.c                             |  11 +-
 fs/fuse/file.c                                |  10 +-
 fs/fuse/virtio_fs.c                           |   3 +-
 fs/gfs2/aops.c                                |   6 +-
 fs/gfs2/bmap.c                                |   9 +-
 fs/gfs2/bmap.h                                |   2 +-
 fs/gfs2/file.c                                |   6 +-
 fs/gfs2/inode.c                               |   6 +-
 fs/hpfs/file.c                                |   6 +-
 fs/internal.h                                 |   1 -
 fs/iomap/buffered-io.c                        |  40 ++---
 fs/iomap/direct-io.c                          |   8 +-
 fs/iomap/fiemap.c                             |   8 +-
 fs/iomap/iter.c                               |  13 +-
 fs/iomap/seek.c                               |   8 +-
 fs/iomap/swapfile.c                           |   4 +-
 fs/iomap/trace.h                              |  12 +-
 fs/nilfs2/file.c                              |   2 +-
 fs/nilfs2/iomap.c                             |   4 +-
 fs/nilfs2/iomap.h                             |   4 +-
 fs/ntfs/aops.c                                |   6 +-
 fs/ntfs/file.c                                |  20 +--
 fs/ntfs/inode.c                               |   2 +-
 fs/ntfs/iomap.c                               |  42 ++----
 fs/ntfs/iomap.h                               |  10 +-
 fs/ntfs3/file.c                               |  16 +-
 fs/ntfs3/inode.c                              |  13 +-
 fs/ntfs3/ntfs_fs.h                            |   3 +-
 fs/remap_range.c                              |   6 +-
 fs/xfs/xfs_aops.c                             |   8 +-
 fs/xfs/xfs_file.c                             |  53 +++----
 fs/xfs/xfs_iomap.c                            |  55 ++-----
 fs/xfs/xfs_iomap.h                            |  16 +-
 fs/xfs/xfs_iops.c                             |   4 +-
 fs/xfs/xfs_reflink.c                          |   6 +-
 fs/zonefs/file.c                              |  22 +--
 include/linux/dax.h                           |  18 +--
 include/linux/fs.h                            |   7 +-
 include/linux/iomap.h                         |  66 +++++----
 63 files changed, 492 insertions(+), 557 deletions(-)

-- 
2.52.0

