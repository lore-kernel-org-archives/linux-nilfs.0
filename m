Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844A24B1E44
	for <linux-nilfs@vger.kernel.org>; Fri, 16 May 2025 04:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747371363; cv=none; b=MUGPvPy6sXAFwYfDGxsZXFKu2yGgaIEjze/Jz/xt/KdTnbJGCqNlirtdhozPbIZXHXe+gnmrFFCoNpKYhQ06rNmXy/+1hiLaJ1Zz9Vi/iU+e37UQ7WGRqmQB88EEXqBxlsf/aSNlHkonZ1Ls5IMS/vrRkT/Q41fl8nTn2XVHXRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747371363; c=relaxed/simple;
	bh=EVo5oIMfwuTEiW19Py6GpgnfBH4M0Wl4SqVTfwKjmvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PdKs13/mfasz5MOGY4HufhEAoh1o89E5/Hijv6cetNae4YU8I3XIeHwxUTVC2fLXSjvj5kTpyLxmlS38U54B7V1zX8ttrD2j54PZvSxB1VhE3/BCveXxxX3r6PaPWcgcgq6xNREcY4ZO5h6jsW2aAnepSsth7WthUHC/tTjjwJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6BA3F68AA6; Fri, 16 May 2025 06:55:55 +0200 (CEST)
Date: Fri, 16 May 2025 06:55:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-nilfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 6/7] nilfs2: remove wbc->for_reclaim handling
Message-ID: <20250516045554.GA13127@lst.de>
References: <20250508054938.15894-1-hch@lst.de> <20250508054938.15894-7-hch@lst.de> <CAKFNMo=nQ7e99ubGmB_9myjSmHxmUJ+XEoknRGF=fMuzJZMPNg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKFNMo=nQ7e99ubGmB_9myjSmHxmUJ+XEoknRGF=fMuzJZMPNg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, May 09, 2025 at 01:16:36AM +0900, Ryusuke Konishi wrote:
> > Since commit 013a07052a1a ("nilfs2: convert metadata aops from writepage
> > to writepages"), nilfs_mdt_write_folio can't be called from reclaim
> > context any more.  Remove the code keyed of the wbc->for_rename flag,
> > which is now only set for writing out swap or shmem pages inside the
> > swap code, but never passed to file systems.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Yes, the parts removed in this patch look like dead code now.
> 
> So far, no issues have been detected with the previous conversion, but
> even if it turns out that something has changed in that conversion and
> needs to be fixed, I have no objection to this cleanup.  Feel free to
> add:

Can you queue this up in the nilfs2 tree as it's independent of the
previous patches in the series, and the last one can't go in until
all dependencies have been merged anyway?

