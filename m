From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 08/10] vmscan: Add check_move_unevictable_folios()
Date: Wed, 8 Jun 2022 20:56:16 -0700
Message-ID: <YqFvYAlGGWW7ohTZ@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-9-willy@infradead.org>
 <YqBYxNPu3tLiN5kI@infradead.org>
 <YqDPIv5IgNHK/pJT@casper.infradead.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=k5NOE2/mOchRWcRvMdsOMX23IRbR4XjJRm5kjerQYfs=; b=UMDExU/q7tF8/mqWoSgLYxhOpC
        FkB/nDKRBlAlwMswJxYlpwOD+T9b3fHuzs5Xk9HKsw1RzKM18Nvzmz2zvtMnyPCsG0qy2kU/WHu9X
        mVccNPi9V87DFgmPksbjSq32mvZYh7FU9kikejkUfrcbqMujPYOK4OsnGEYmxwRBuH+8cz929MoC+
        J1L5P254VCbTHcr/3B4+pgfRdz1mWvdV10u33rtAMJjWsHP0HN5sU7QukTrtM4bSJeT0tiNaLZ0sf
        okORJ39zhtNOHmkrX4y3W5zWBlbmRyPPS8qKqjL4e2oY+q3FEDzI+tyRYIGUkaqgz1VdTJg+hKLV8
        s6Jccx+g==;
Content-Disposition: inline
In-Reply-To: <YqDPIv5IgNHK/pJT-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jun 08, 2022 at 05:32:34PM +0100, Matthew Wilcox wrote:
> On Wed, Jun 08, 2022 at 01:07:32AM -0700, Christoph Hellwig wrote:
> > On Sun, Jun 05, 2022 at 08:38:52PM +0100, Matthew Wilcox (Oracle) wrote:
> > > Change the guts of check_move_unevictable_pages() over to use folios
> > > and add check_move_unevictable_pages() as a wrapper.
> > 
> > The changes here look fine, but please also add patches for converting
> > the two callers (which looks mostly trivial to me).
> 
> I do want to get rid of pagevecs entirely, but that conversion isn't
> going to happen in time for the next merge window.  for_each_sgt_page()
> is a little intimidating.

for_each_sgt_page, just like other creative scatterlist abuse in the gpu
code is a beast.  But, instead of doing a for_each_sgt_page to add
pages to the pagevec and then do a loop over the pagevec to add to
the folio batch it should be pretty trivial to just cut out the
middle man.
