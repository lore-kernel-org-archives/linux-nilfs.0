Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE4323E331
	for <linux-nilfs@vger.kernel.org>; Thu,  8 May 2025 14:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746713016; cv=none; b=OTwRQPrRS0XVy2BNpQii87dt5JRFKc2KyXSaccxbzgDd0LV1lWysf/mECALfxg22rAzztydS3bS/Eex1Q+TRbGeGaWcQiABVNK2ymX7NyQHmYw1vLZx53GLEfoEZhqfTy+tXv6wO+vBfBykKWpITv+vD0TqfrJaGZZxn2CF+nf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746713016; c=relaxed/simple;
	bh=g2SqTx7T7ywJmqGHmfUrtItZ+tbHnaWkr3m4aYFHUDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k8NsqcG88akQzVbjsFAw8qU27TDjeG3pFr2P8KxHOg40OtU/9RLe6SGffBPFyUDG/D4uBCVFOzaW/lug9+2yv+NYQQEN2LTM7tp59c8OxL/xFqCsbiL8VY7F3c+lUf0r/TtHwz54F9CTaQ1DPBDb4MemMahfzr+Mlyjdawk2OTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1CDF067373; Thu,  8 May 2025 16:03:22 +0200 (CEST)
Date: Thu, 8 May 2025 16:03:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-nilfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/7] mm: stop passing a writeback_control structure to
 shmem_writeout
Message-ID: <20250508140321.GA31543@lst.de>
References: <20250508054938.15894-1-hch@lst.de> <20250508054938.15894-3-hch@lst.de> <aBywrEMTCKfT9BFo@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBywrEMTCKfT9BFo@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, May 08, 2025 at 02:25:00PM +0100, Matthew Wilcox wrote:
> This got me to look at why we need to keep wbc in __shmem_writeback().
> We only have it because folio_redirty_for_writepage() needs it.  And
> folio_redirty_for_writepage() only needs it because it updates
> pages_skipped.

in linux-next you also changed it to use writeback_iter, which needs
the wbc as well.  That probably as an improvement compared to the
previous version, but overall it still feels odd.

> I'm not quite sure if we can simply call filemap_dirty_folio() here
> or whether mapping_can_writeback() is true for shmem and we need to
> do all the other things -- in which case we could just change that one
> line to

shmem doesn't set up a bdi, so it should not be true.

