Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457153AE70A;
	Wed, 29 Jul 2026 06:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785306547; cv=none; b=Z0E5H9xXgwvVk/EGTTL1T1IQh4th9ZnySWEVk4WUHLXujPdDpq/PgeD/hftNhv+xYlXejC3sKBJ6x3mIEM3ySJkzl1zs94gFDZb1/pY6mVJ14kg4RMC+MPsJhF8jSINi/FF9MdnZrcxPXKYYTQU0V0oTTjj39eHdKj4fAumV+Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785306547; c=relaxed/simple;
	bh=rF+GzOSw8EFUCKSqS/4zhrPe+0mnO5nbBEaYITmKeUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wpq00P0eUMdqa/Ff8eVg9l1JjkqyrVm3zcS8ROq3KaPRBrqCUuyqGMr3oU5Mu4Qp7vbejMWxfKq/OPVTUvQ+/Ep+FQsxBXHpkncsO/CRuZwiVKAHQWs+KCxBPLWojG3m+snA0I1S3jhvd2llMb+wTCkG8wgEGgUYHSvjiG3t+gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8467E68AFE; Wed, 29 Jul 2026 08:28:52 +0200 (CEST)
Date: Wed, 29 Jul 2026 08:28:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@lst.de>, konishi.ryusuke@gmail.com,
	linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/2] nilfs2: convert O_DIRECT reads to iomap
Message-ID: <20260729062852.GA8833@lst.de>
References: <20260724222745.2107464-1-slava@dubeyko.com> <20260728035443.GB19245@lst.de> <ec87fd45a7ec19dcddd0720a1634abd442a181d8.camel@dubeyko.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec87fd45a7ec19dcddd0720a1634abd442a181d8.camel@dubeyko.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 28, 2026 at 04:19:05PM -0700, Viacheslav Dubeyko wrote:
> Are you suggesting to re-write the commit message?

Yes.  Just mention that you only converts reads because the existing
code only supports reads.

