From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v10 43/62] memfd: Convert shmem_tag_pins to
 XArray
Date: Fri, 30 Mar 2018 19:11:11 -0700
Message-ID: <20180331021111.GB13332@bombadil.infradead.org>
References: <20180330034245.10462-1-willy@infradead.org>
 <20180330034245.10462-44-willy@infradead.org>
 <39ea3393-c3d7-07c3-a072-344f3a65cef3@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=E8sDXbkEBVbYe9TyTzTg978dkfM+glDhRF47sT8EiqM=; b=bQLFpWWuTokm4FxoT2Ee+AFngQ
 Fx5XYzqP2XqenjTlOCiPa0UB/nxCOKugotUJzpW6Zswgl7C3iq2vhyeCrq9wEvCfpX5OFeP/Ajzxr
 liVe10rK3dlxKjVVDvXKNwuXqPOXKJ2vtuDsBrNlsTnophWQdqEtFLQ2ZK8QPhlhroH4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=E8sDXbkEBVbYe9TyTzTg978dkfM+glDhRF47sT8EiqM=; b=cXGW7/FsAe1BXwfDLcbk9/8Rqx
 9oM3Wns7Sp1utsNocM9mluLymaYLW3t3VdLK+kADV7FebYlaj00dHmGizG8u+ntA9OIywXFJY4NUG
 uSel4gClT7sGzdDV48FeOnWWYOukf4jemykwthnwleBG/3aAc/fDs4mqsdsiwMISy7TA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=E8sDXbkEBVbYe9TyTzTg978dkfM+glDhRF47sT8EiqM=; b=S5NZ1ZtdHmebOdDyBAxo93ZcK
 Un8oMwyNLXRUMJc6KW54gWKOfdaMSj98RAfw3aROYIolmHzUKCto1yelGJOKgzDb2sgq9fwhtFvFr
 ocespYEKjejAsHkK4L2W7h8MsSJcJxO1LdsJEaW+YJt12/BHwJ00+Zx2XCyrFEyOUd6JGRj+jOTrb
 BCI44r1C7ocyUq+BuOXP33pgLhdA8UUqLDAnUnyQUXtx9HX9ZoZcsM7V/B8pethJAmJE5rleyp5Uz
 I0zjFLBfHTXVrUVYKTrS6ogJH1KwBWcwhR9JptExG4P8SWoWiLBXpU5tCMEeW/LcYwuCff17kftXV
 MLnFQMdvw==;
Content-Disposition: inline
In-Reply-To: <39ea3393-c3d7-07c3-a072-344f3a65cef3@oracle.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Mike Kravetz <mike.kravetz@oracle.com>
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, linux-mm@kvack.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Fri, Mar 30, 2018 at 05:05:05PM -0700, Mike Kravetz wrote:
> On 03/29/2018 08:42 PM, Matthew Wilcox wrote:
> > From: Matthew Wilcox <mawilcox@microsoft.com>
> > 
> > Simplify the locking by taking the spinlock while we walk the tree on
> > the assumption that many acquires and releases of the lock will be
> > worse than holding the lock for a (potentially) long time.
> 
> I see this change made in several of the patches and do not have a
> specific issue with it.  As part of the XArray implementation you
> have XA_CHECK_SCHED = 4096.   So, we drop locks and do a cond_resched
> after XA_CHECK_SCHED iterations.  Just curious how you came up with
> that number.  Apologies in advance if this was discussed in a previous
> round of reviews.

It comes from two places, the current implementations of
tag_pages_for_writeback() and find_swap_entry().  I have no idea if it's
the optimal number for anybody, but it's the only number that anyone
was using.  I'll have no problem if somebody suggests we tweak the number
in the future.

> I did not do a detailed review of the XArray implementation.  Only looked
> at the provided interfaces and their intended uses.  If the interfaces work
> as specified, the changes here are fine.
> 
> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>

That is all I can ask for, and it's the most valuable thing.  Thanks,
Mike!

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
