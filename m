Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5365534D4DE;
	Tue, 28 Jul 2026 03:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785210888; cv=none; b=bg6tIFXG16mfoCPFRfGMC2Z9CxhnsmjkRweu0yMG2gG5SRLN1s1wGpdaBBa5T8gMM3ysA6E4angbk6AfFwkuq7tZ6j19wGNkUBZGr+caJA30ow+B3NkpuJuGaafxrYnm0slxmdg2xCiNgqrDGh3Izb2GdQ0rG0Uzv3vpfotLNTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785210888; c=relaxed/simple;
	bh=SJQJi3Fs9mbMHvmUTMNF3R7eFnBtpk7PTKo+xlIZNZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PkDfYIDXYFuKrhb/d2gc+ritGum9MfGjYBfq1lCm0mlsIVlrwMzFHP/RwaTcTYWuU06JBII/uTKPwhzwbJDaaueUh5RK2CvX85783iveh/8/eEAIEHGnOgaMuCIgHniovxWTNYAg3a8h1JHzczgYiTHQSKkNCK6V/9MeAsWFEuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EDB2D68AFE; Tue, 28 Jul 2026 05:54:43 +0200 (CEST)
Date: Tue, 28 Jul 2026 05:54:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: konishi.ryusuke@gmail.com, hch@lst.de, linux-nilfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/2] nilfs2: convert O_DIRECT reads to iomap
Message-ID: <20260728035443.GB19245@lst.de>
References: <20260724222745.2107464-1-slava@dubeyko.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724222745.2107464-1-slava@dubeyko.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 24, 2026 at 03:27:43PM -0700, Viacheslav Dubeyko wrote:
> This series removes NILFS2 using of blockdev_direct_IO() by
> converting the O_DIRECT read path to iomap.

I think the important part here is that right now there are no
direct I/O writes in nilfs2, not that you only convert the read
path?

> NILFS2 is
> a log-structured, copy-on-write filesystem, which makes it
> a poor fit for a full iomap conversion. Newly allocated blocks
> are delay-allocated by nilfs_get_block() and only receive a real
> disk address when the segment constructor writes them out
> as part of a log.

That's just how zoned xfs and btrfs work.  In fact they only know
the disk address one the write returns, so even later.

Take a look at the IOMAP_F_ANON_WRITE flag used by xfs.  btrfs implements
a similar scheme, but hidden behind a few layers of cruft.

> The segment constructor walks buffer_head lists
> directly and is not integrated with the generic address_space
> writeback path.

This sounds like word-soup to me.

