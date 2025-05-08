Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706D013C3F2
	for <linux-nilfs@vger.kernel.org>; Thu,  8 May 2025 05:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746683387; cv=none; b=bJ2OJ3G1cCzSmWIURVu9fA8fMqO2wJ89YKtXYC38KwUiSqXOa382+0YV/TsygKGdnf0dVXrNMMlfV18ueQ/rkFFVmHUHQd0ehTD4sd1MhzIB2/xO6nVqHip8CdH2fTywU+jeeQSRkzsSbgP2a4wdULKFLNwOPAvGQfqHC5BfhPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746683387; c=relaxed/simple;
	bh=n3IeNy2+y5uYE0m3hRKLQrNi7a/vU1KlttVO1d3DiU4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=APUmKAlDgKON0Q2ZMqYJ7SbwusRYQ/DFYIZ29ElzeS/36lwknvEyGAc49ARcAvoaIzSU+1J8nCyHwhM+1VVNRxOLJMJ5CRZJMgNqWlvkN7qxc9ZuhsAynzvRRogEkOnmg7yw1WGZbl4WIunZgHVL0ZnUrLuvtCQvW6MMloL1Fs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Tk/Va5+5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Tk/Va5+5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=YEszs3CLlwf4c/39j2y7oDZeQwogTJWeoHfG4iUtL7c=; b=Tk/Va5+5eqc1sM50CEKU71P+88
	rNGZwS/DYKflZtq1b3ZD7DfkudTcdOVG4hvW7rGW25dSqORh8d4RiaRjueP0yPjGgq4vI7tZzzwcA
	I6mCyTYIQ9qMXT4AvYTJOcFmduyuugtzKm1cSRUcSfBEebk34RV1J6rWSwofOoCvAPP2erNXPtXNO
	Kf1Rg2cclWfp4orgqjAanB+LAQnH8PygzCaBAfUc7je52GJLmF25CqssaAFne22BIvTSYkPdRHiMC
	EA3xuw8RCUtRXUbOzw5Y9XxbHQCyw0Tcfd3ku5qSUutEoagbz4G4IIJLAUfZoLm0FqOVFSQskaUyu
	SS7a0ZOQ==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCu8b-0000000HOqe-41BL;
	Thu, 08 May 2025 05:49:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-nilfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: stop passing a writeback_control to swap/shmem writeout
Date: Thu,  8 May 2025 07:47:42 +0200
Message-ID: <20250508054938.15894-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series was intended to remove the last remaining users of
AOP_WRITEPAGE_ACTIVATE after my other pending patches removed the
rest, but spectacularly failed at that.

But instead it nicely improves the code, and removes two pointers
and a flag from struct writeback_control.

Note that the last patch needs this f2fs series to compile, so
it should probably be delayed until after -rc1:

https://lore.kernel.org/lkml/20250508051520.4169795-1-hch@lst.de/

Diffstat:
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    3 -
 drivers/gpu/drm/ttm/ttm_backup.c          |    9 ---
 fs/fuse/file.c                            |   11 ---
 fs/nfs/write.c                            |    2 
 fs/nilfs2/mdt.c                           |    2 
 fs/nilfs2/segment.c                       |   16 -----
 fs/nilfs2/segment.h                       |    1 
 include/linux/shmem_fs.h                  |    5 +
 include/linux/writeback.h                 |   11 ---
 include/trace/events/btrfs.h              |    7 --
 include/trace/events/writeback.h          |    8 --
 mm/page_io.c                              |   71 +++++++++++--------------
 mm/shmem.c                                |   17 ++----
 mm/swap.h                                 |    6 +-
 mm/vmscan.c                               |   84 +++++++++++++-----------------
 mm/zswap.c                                |    5 -
 16 files changed, 94 insertions(+), 164 deletions(-)
