From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v11 53/63] dax: Rename some functions
Date: Tue, 22 May 2018 15:39:55 -0600
Message-ID: <20180522213955.GB12733@linux.intel.com>
References: <20180414141316.7167-1-willy@infradead.org>
 <20180414141316.7167-54-willy@infradead.org>
 <20180521044236.GC27043@linux.intel.com>
 <20180521101139.GA20878@bombadil.infradead.org>
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
 bh=xSRiAmcLCY+0PQurp8pLReeLefGweVHbQSSa8Xb5r5c=; b=M4ZN19p5vk+mRI1EI/BMFXzrLG
 i8OtzP9qKH2e2so982SuqzguTvS+xwv8g2dDCLxabWFy8dIwThGLnMZMlprJ++N4TtNlfbAnl0Paa
 oz67aRau1zyVe1COEmA9iefsiPHvStFJTH++69rxHGLe0dfzk2pKjASfmVVE7dtGjkGc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=xSRiAmcLCY+0PQurp8pLReeLefGweVHbQSSa8Xb5r5c=; b=bR1fkiv66WNb+qG6kdUNdeoCFw
 9opvOx1DLoIBhMpeDFUSeDs96yZQiCvhw7ynddBYFHwEkvQgFf1ceL41EfYr78RNSzBkkXashM+df
 Vpo6qjTKZCBghZ320gsk5EuxSFRm/ie1dx+X7GZ8x//wUiWAi39zudvg/UdyvBeaiyc4=;
Content-Disposition: inline
In-Reply-To: <20180521101139.GA20878@bombadil.infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, linux-mm@kvack.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>

On Mon, May 21, 2018 at 03:11:39AM -0700, Matthew Wilcox wrote:
> On Sun, May 20, 2018 at 10:42:36PM -0600, Ross Zwisler wrote:

> > > @@ -1519,15 +1517,14 @@ int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
> > >  }
> > >  EXPORT_SYMBOL_GPL(dax_iomap_fault);
> > >  
> > > -/**
> > > +/*
> > 
> > Let's leave the double ** so that the function is picked up properly by
> > the documentation system, and so it's consistent with the rest of the
> > functions.
> 
> This function is static.  I think it's worth keeping the documentation,
> but making it part of the exported kernel API documentation is confusing.

Ah, fair enough.

> By the way, nothing at all in fs/dax.c is picked up by the documentation
> system today.  We should probably fix that ... did you want to look at it
> or shall I propose a patch to anchor it somewhere?

If you have time for it that would be awesome.

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
