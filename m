From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v14 00/74] Convert page cache to XArray
Date: Thu, 28 Jun 2018 01:39:09 -0700
Message-ID: <20180628083909.GA7646@bombadil.infradead.org>
References: <20180617020052.4759-1-willy@infradead.org>
 <20180619031257.GA12527@linux.intel.com>
 <20180619092230.GA1438@bombadil.infradead.org>
 <20180619164037.GA6679@linux.intel.com>
 <20180619171638.GE1438@bombadil.infradead.org>
 <20180627110529.GA19606@bombadil.infradead.org>
 <20180627194438.GA20774@linux.intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=pyJzunvr74w7FKUMDsnOI8piHo79VejrRDDM5YBU/5U=; b=j9EsLuZ6Ah3yNoemmmFzFYqs0
        OR7vY9x4pZ6OGrpHNLgbQ+nwLSOAO8y7XJOg11W+K+7jiOKap7+GqE4Cc/oQEwBoTv0GTv07Uq0K+
        1fo9QRCeBwxmrCD0kmWBCy4JDdVNbKWXAcn6Hv0xrvuQEakySr531GtJlSLPFyIpWAPsuRaLPdkMV
        5WzrIxUBM0WuQWib1dfkYcVdzcOhKZL75CJ02+fWqpICBqwyLdxfkD5ORD2A7KBSYbi1ME8TPMCsJ
        J+WGlTmPJLBJ5OkdfFoxq3MjNvbK/hqU5FmyAjs5S4OAk2tskNnUqj2G15gfw/r9hREu1bhJ7QxWl
    
Content-Disposition: inline
In-Reply-To: <20180627194438.GA20774@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, linux-f2fs-devel@lists.sourceforge.net

On Wed, Jun 27, 2018 at 01:44:38PM -0600, Ross Zwisler wrote:
> On Wed, Jun 27, 2018 at 04:05:29AM -0700, Matthew Wilcox wrote:
> > On Tue, Jun 19, 2018 at 10:16:38AM -0700, Matthew Wilcox wrote:
> > > I think I see a bug.  No idea if it's the one you're hitting ;-)
> > > 
> > > I had been intending to not use the 'entry' to decide whether we were
> > > waiting on a 2MB or 4kB page, but rather the xas.  I shelved that idea,
> > > but not before dropping the DAX_PMD flag being passed from the PMD
> > > pagefault caller.  So if I put that back ...
> > 
> > Did you get a chance to test this?
> 
> With this patch it doesn't deadlock, but the test dies with a SIGBUS and we
> hit a WARN_ON in the DAX code:
> 
> WARNING: CPU: 5 PID: 1678 at fs/dax.c:226 get_unlocked_entry+0xf7/0x120
> 
> I don't have a lot of time this week to debug further.  The quickest path to
> victory is probably for you to get this reproducing in your test setup.  Does
> XFS + DAX + generic/340 pass for you?

I won't be back in front of my test box until Tuesday, but that test
does work for me because I couldn't get your instructions to give me a
2MB aligned DAX setup.  I had to settle for 4k, so none of the 2MB stuff
has been tested properly.
