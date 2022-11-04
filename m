From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 04/23] page-writeback: Convert write_cache_pages() to use
 filemap_get_folios_tag()
Date: Fri, 4 Nov 2022 11:32:35 +1100
Message-ID: <20221104003235.GZ2703033@dread.disaster.area>
References: <20220901220138.182896-1-vishal.moola@gmail.com>
 <20220901220138.182896-5-vishal.moola@gmail.com>
 <20221018210152.GH2703033@dread.disaster.area>
 <Y2RAdUtJrOJmYU4L@fedora>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nqFWmWfUe3nfY/W1IhQtBrk1jdkAMC8SotBe5qoKInk=;
        b=59fd9mimgkb3jqAEBB6FDge8YWbKgQ9cCVLSYc0vbz/ITZ/+MWGUAhT+BfkD/WyOKR
         ZS72otyTGSBCMIn5KXHq3LY3eBVqj847EAys1SC/2LtlNG2ca/p3U0PFwYXe/Wnqkktr
         I3J8EoDvRfIbPMbLnYr+wIQ9y3cFpGyrA7PQRcteKx3oRqTR+RVUuWrOgzafCb1uOAwz
         nCRdmg7rcl4JIOC/F7kvcGFV4AMwfIgrEUm/9771CgvZ3C7eQT9zBQ3v6zbQ4HsMWHhf
         YC3gUQD3VRGl+O7/Jyi2szZ3xH6y79IvLO1d72Ja/0b7kFUBkMCtbZ/1nn2lxndqgNOT
         QynQ==
Content-Disposition: inline
In-Reply-To: <Y2RAdUtJrOJmYU4L@fedora>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vishal Moola <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Thu, Nov 03, 2022 at 03:28:05PM -0700, Vishal Moola wrote:
> On Wed, Oct 19, 2022 at 08:01:52AM +1100, Dave Chinner wrote:
> > On Thu, Sep 01, 2022 at 03:01:19PM -0700, Vishal Moola (Oracle) wrote:
> > > Converted function to use folios throughout. This is in preparation for
> > > the removal of find_get_pages_range_tag().
> > > 
> > > Signed-off-by: Vishal Moola (Oracle) <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > ---
> > >  mm/page-writeback.c | 44 +++++++++++++++++++++++---------------------
> > >  1 file changed, 23 insertions(+), 21 deletions(-)
> > > 
> > > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > > index 032a7bf8d259..087165357a5a 100644
> > > --- a/mm/page-writeback.c
> > > +++ b/mm/page-writeback.c
> > > @@ -2285,15 +2285,15 @@ int write_cache_pages(struct address_space *mapping,
> > >  	int ret = 0;
> > >  	int done = 0;
> > >  	int error;
> > > -	struct pagevec pvec;
> > > -	int nr_pages;
> > > +	struct folio_batch fbatch;
> > > +	int nr_folios;
> > >  	pgoff_t index;
> > >  	pgoff_t end;		/* Inclusive */
> > >  	pgoff_t done_index;
> > >  	int range_whole = 0;
> > >  	xa_mark_t tag;
> > >  
> > > -	pagevec_init(&pvec);
> > > +	folio_batch_init(&fbatch);
> > >  	if (wbc->range_cyclic) {
> > >  		index = mapping->writeback_index; /* prev offset */
> > >  		end = -1;
> > > @@ -2313,17 +2313,18 @@ int write_cache_pages(struct address_space *mapping,
> > >  	while (!done && (index <= end)) {
> > >  		int i;
> > >  
> > > -		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
> > > -				tag);
> > > -		if (nr_pages == 0)
> > > +		nr_folios = filemap_get_folios_tag(mapping, &index, end,
> > > +				tag, &fbatch);
> > 
> > This can find and return dirty multi-page folios if the filesystem
> > enables them in the mapping at instantiation time, right?
> 
> Yup, it will.
> 
> > > +
> > > +		if (nr_folios == 0)
> > >  			break;
> > >  
> > > -		for (i = 0; i < nr_pages; i++) {
> > > -			struct page *page = pvec.pages[i];
> > > +		for (i = 0; i < nr_folios; i++) {
> > > +			struct folio *folio = fbatch.folios[i];
> > >  
> > > -			done_index = page->index;
> > > +			done_index = folio->index;
> > >  
> > > -			lock_page(page);
> > > +			folio_lock(folio);
> > >  
> > >  			/*
> > >  			 * Page truncated or invalidated. We can freely skip it
> > > @@ -2333,30 +2334,30 @@ int write_cache_pages(struct address_space *mapping,
> > >  			 * even if there is now a new, dirty page at the same
> > >  			 * pagecache address.
> > >  			 */
> > > -			if (unlikely(page->mapping != mapping)) {
> > > +			if (unlikely(folio->mapping != mapping)) {
> > >  continue_unlock:
> > > -				unlock_page(page);
> > > +				folio_unlock(folio);
> > >  				continue;
> > >  			}
> > >  
> > > -			if (!PageDirty(page)) {
> > > +			if (!folio_test_dirty(folio)) {
> > >  				/* someone wrote it for us */
> > >  				goto continue_unlock;
> > >  			}
> > >  
> > > -			if (PageWriteback(page)) {
> > > +			if (folio_test_writeback(folio)) {
> > >  				if (wbc->sync_mode != WB_SYNC_NONE)
> > > -					wait_on_page_writeback(page);
> > > +					folio_wait_writeback(folio);
> > >  				else
> > >  					goto continue_unlock;
> > >  			}
> > >  
> > > -			BUG_ON(PageWriteback(page));
> > > -			if (!clear_page_dirty_for_io(page))
> > > +			BUG_ON(folio_test_writeback(folio));
> > > +			if (!folio_clear_dirty_for_io(folio))
> > >  				goto continue_unlock;
> > >  
> > >  			trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
> > > -			error = (*writepage)(page, wbc, data);
> > > +			error = writepage(&folio->page, wbc, data);
> > 
> > Yet, IIUC, this treats all folios as if they are single page folios.
> > i.e. it passes the head page of a multi-page folio to a callback
> > that will treat it as a single PAGE_SIZE page, because that's all
> > the writepage callbacks are currently expected to be passed...
> > 
> > So won't this break writeback of dirty multipage folios?
> 
> Yes, it appears it would. But it wouldn't because its already 'broken'.

It is? Then why isn't XFS broken on existing kernels? Oh, we don't
know because it hasn't been tested?

Seriously - if this really is broken, and this patchset further
propagating the brokeness, then somebody needs to explain to me why
this is not corrupting data in XFS.

I get it that page/folios are in transition, but passing a
multi-page folio page to an interface that expects a PAGE_SIZE
struct page is a pretty nasty landmine, regardless of how broken the
higher level iteration code already might be.

At minimum, it needs to be documented, though I'd much prefer that
we explicitly duplicate write_cache_pages() as write_cache_folios()
with a callback that takes a folio and change the code to be fully
multi-page folio safe. Then filesystems that support folios (and
large folios) natively can be passed folios without going through
this crappy "folio->page, page->folio" dance because the writepage
APIs are unaware of multi-page folio constructs.

Then you can convert the individual filesystems using
write_cache_pages() to call write_cache_folios() one at a time,
updating the filesystem callback to do the conversion from folio to
struct page and checking that it an order-0 page that it has been
handed....

> The current find_get_pages_range_tag() actually has the exact same
> issue. The current code to fill up the pages array is:
> 
> 		pages[ret] = &folio->page;
> 		if (++ret == nr_pages) {
> 			*index = folio->index + folio_nr_pages(folio);
> 			goto out;

"It's already broken so we can make it more broken" isn't an
acceptible answer....

> Its not great to leave it 'broken' but its something that isn't - or at
> least shouldn't be - creating any problems at present. And I believe Matthew
> has plans to address them at some point before they actually become problems?

You are modifying the interfaces and doing folio conversions that
expose and propagate the brokenness. The brokeness needs to be
either avoided or fixed and not propagated further. Doing the above
write_cache_folios() conversion avoids the propagating the
brokenness, adds runtime detection of brokenness, and provides the
right interface for writeback iteration of folios.

Fixing the generic writeback iterator properly is not much extra
work, and it sets the model for filesytsems that have copy-pasted
write_cache_pages() and then hacked it around for their own purposes
(e.g. ext4, btrfs) to follow.

-Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
