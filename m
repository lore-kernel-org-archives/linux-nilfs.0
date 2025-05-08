Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089DB223DC4
	for <linux-nilfs@vger.kernel.org>; Thu,  8 May 2025 13:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746710706; cv=none; b=WAWEqPgHdqb/gmppWem0v/Jmp2KjQwLoCdPA1IuMDTM00sUkc6B5jGDOjklxUd5mPR3P/nY4ZJ9Sry4yvu3jZY0yNCpDfIoJqtU5FrRLimr4WHxlI6JyXjWdzSRn0MLTGQ6w4SEuzsWHhe5axbyc9vpZ2vE4+VwolAe0F53F9BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746710706; c=relaxed/simple;
	bh=c2vs1wK3l21ck0fboR7AT+wzJq8lrtIdVpR5NNfrVJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W7leFhyfl8V5NCNhdlmQfv0FQjWpKJ6hgHPi8uyiGTxFX8zi3N6hHzoHFY7M3Uzl5cXzo818lSXCKLuhOfFb/Lvw5i2iWmMveQ8aF3fNqIEmAHeYJSJ9F56i9jMEHdKhMyjENhGfFqSpHiMBtP3Zg3WiqOW1fss2wr+gP0IFeMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pwAdO6FN; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pwAdO6FN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9G6E+hztJRVGdCzLStdxjGwsf1EF2F4N77r9fp2nRGk=; b=pwAdO6FNFf9VIYte0IQ8oXrKSX
	NZjg0ZGL6LzVDWK0vURB5I+i7keyfaFLJE5sSvOgPxGk0fU5+dhZ69sC7fXxFMzEOFt3g3p7N10KT
	ZWImDrmKbDOoGFfoymgNQCtUXiyc1Dh3+EiKV5BJG8tLID2+pLE+a72BPzAdzi/pw0X+jtjjW/7r6
	1JZFQqRDMYDMWBDQ/b/vBIpVvF3Azvb57lqoTGUio3/DBjf1Ohia6tDfmRraCqaUIs6OGaryDCvp6
	XlBkaacEDUSA3G2LsdHHJhT9fbxpjzUQ22k49Qz+Nw8Ywp9XczSh9JakV5IsedAi8oHshLezrABDs
	ey0qIVdw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uD1FE-00000000YR8-2Zfv;
	Thu, 08 May 2025 13:25:00 +0000
Date: Thu, 8 May 2025 14:25:00 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-nilfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/7] mm: stop passing a writeback_control structure to
 shmem_writeout
Message-ID: <aBywrEMTCKfT9BFo@casper.infradead.org>
References: <20250508054938.15894-1-hch@lst.de>
 <20250508054938.15894-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250508054938.15894-3-hch@lst.de>

On Thu, May 08, 2025 at 07:47:44AM +0200, Christoph Hellwig wrote:
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> @@ -318,7 +318,7 @@ void __shmem_writeback(size_t size, struct address_space *mapping)
>  		if (folio_mapped(folio))
>  			folio_redirty_for_writepage(&wbc, folio);
>  		else
> -			error = shmem_writeout(folio, &wbc);
> +			error = shmem_writeout(folio, NULL, NULL);
>  	}
>  }

This got me to look at why we need to keep wbc in __shmem_writeback().
We only have it because folio_redirty_for_writepage() needs it.  And
folio_redirty_for_writepage() only needs it because it updates
pages_skipped.

I'm not quite sure if we can simply call filemap_dirty_folio() here
or whether mapping_can_writeback() is true for shmem and we need to
do all the other things -- in which case we could just change that one
line to

	if (wbc)
		wbc->pages_skipped += nr;

and then pass NULL to folio_redirty_for_writepage() and delete the
wbc on the stack.

