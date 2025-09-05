Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE75E1FF1AD;
	Fri,  5 Sep 2025 19:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757100448; cv=none; b=hQbllRvGCbmqDFIT9YSIuDLcFaUGeOFO7lRIPGgcPlFh/lDTyf149CWOukBUSZI+StNVuDPnCj81xLoy94pcfWw4GxOKhkdQ//IQ1kho7Mc9Twx1Y/6hnijy5/TVeYQhxe/trArSed2h/jJZiy7ajq/rt2dXPBTQxI9pqPhaQdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757100448; c=relaxed/simple;
	bh=Vtr83F2L6kKubPifGwcdN/hY3XxdzmzMzf8d1wZU58o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KLhPzPaQFazmYsPNgEh6OC+rr8yog4iVhBSfRSR09jstYCDrpfI/aVgb1uCWEZZ6BdUhYyCucufHRURfZ9JxgE5ycL9HJixSeqCZU2WUnaKly81TnaL08cfbHppfEGHCyh0VhPW+t3qmh8qcgc+P5qzIktonstbqaJE+q2KLqx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZwWHb8IJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZwWHb8IJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21B2C4CEF1;
	Fri,  5 Sep 2025 19:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757100447;
	bh=Vtr83F2L6kKubPifGwcdN/hY3XxdzmzMzf8d1wZU58o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZwWHb8IJZJsXVV3zatK6netRu0wiIctVFVsH8k4ObZq2VtuCsIt7nhW45lpCzXNee
	 LPEx+VnosYbgUsaG3r2NMErJVcitSZP/ao1WJ1Fa0SfRLcbzIfeX9a2aKFlaxH+RFD
	 WCgCLoJuXoiJrcgthgOTVoFqe3jIg9Rqyrhe+DC2uJOMkxZr90BOUD9CWnvto39uDU
	 6g1iW9y7RgzWjptEASkzcdxrmsMRgBo1Zc5P3rwCKd8AJaA7Y/fJS+xoqOdgjYxrjC
	 wPtzuBhLRvQCXAtORPkArOUjtWnepb+M6VdcvXEYMAaV10/wqm/0/6cpb/S0vl/NPp
	 KClUeCDRJNmqA==
Date: Fri, 5 Sep 2025 12:27:22 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>,
	kernel test robot <oliver.sang@intel.com>,
	Borislav Petkov <bp@kernel.org>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, X86 ML <x86@kernel.org>,
	"Chang S. Bae" <chang.seok.bae@intel.com>,
	Sohil Mehta <sohil.mehta@intel.com>, linux-nilfs@vger.kernel.org
Subject: Re: [PATCH -v1 1/2] x86/microcode: Add microcode= cmdline parsing
Message-ID: <20250905192722.GA1274334@ax162>
References: <20250820135043.19048-2-bp@kernel.org>
 <202509021646.bc78d9ef-lkp@intel.com>
 <20250904113752.GDaLl6ELJRd3LZYBQl@fat_crate.local>
 <20250904232952.GA875818@ax162>
 <CAKFNMo=QxweJwTxf-ubYfmBVYBpNEennGLFLRxqhB+evre7zhw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKFNMo=QxweJwTxf-ubYfmBVYBpNEennGLFLRxqhB+evre7zhw@mail.gmail.com>

On Fri, Sep 05, 2025 at 10:17:26PM +0900, Ryusuke Konishi wrote:
> Thank you very much, Nathan, for sharing your detailed report and
> proposing a fix.
> 
> I actually performed a reproduction test in an environment with
> CONFIG_LTO_CLANG_THIN=y and confirmed that the CFI panic reoccurs, and
> that your patch fixes it.
> 
> I also followed your analysis of sysfs and concluded that it is
> correct and that your changes to the two
> nilfs_feature_{revision,README}_show() functions are necessary. I'll
> check whether these were necessary from the beginning or whether they
> became necessary later.
> 
> I'd like to send your proposed fixes upstream, but could you please
> send it to me and linux-nilfs in the form of a proper patch? (I'll
> need at least your SoB line).

Thanks for taking a look and confirming :) I have sent a patch with a
proper changelog along for you to take a look at.

https://lore.kernel.org/20250905-nilfs2-fix-features-cfi-violation-v1-1-b5d35136d813@kernel.org/

From what I can tell, this has always been wrong, hence that Fixes tag
but if you disagree, feel free to update it!

Cheers,
Nathan
