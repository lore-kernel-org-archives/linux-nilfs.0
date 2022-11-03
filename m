From: Vishal Moola <vishal.moola@gmail.com>
Subject: Re: [PATCH 04/23] page-writeback: Convert
 write_cache_pages() to use filemap_get_folios_tag()
Date: Thu, 3 Nov 2022 15:28:05 -0700
Message-ID: <Y2RAdUtJrOJmYU4L@fedora>
References: <20220901220138.182896-1-vishal.moola@gmail.com>
 <20220901220138.182896-5-vishal.moola@gmail.com>
 <20221018210152.GH2703033@dread.disaster.area>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667514497;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=04TfsshirPxCNoji6KR6vQQ5/+Nqz1IUHQcJvZJx5NI=;
	b=S/leTcdROKnI9UrVFh2tXNvKE8o5x71taPsghGLM+iiuNTXQCAo9+j/MkZqO1K76kAt06f
	eTdlk2dhsavXLNqf0wG1WwsGBrlvscVI6jmqWgFMm/pzL8OcaVbEzII3OjbOzV+czt8JQo
	9j7XRjlONTC/pdtLAl20ysxckhFTybw=
In-Reply-To: <20221018210152.GH2703033@dread.disaster.area>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/cluster-devel>, 
 <mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/cluster-devel/>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/cluster-devel>,
 <mailto:cluster-devel-request@redhat.com?subject=subscribe>
Errors-To: cluster-devel-bounces@redhat.com
Sender: "Cluster-devel" <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Wed, Oct 19, 2022 at 08:01:52AM +1100, Dave Chinner wrote:
> On Thu, Sep 01, 2022 at 03:01:19PM -0700, Vishal Moola (Oracle) wrote:
> > Converted function to use folios throughout. This is in preparation for
> > the removal of find_get_pages_range_tag().
> > 
> > Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> > ---
> >  mm/page-writeback.c | 44 +++++++++++++++++++++++---------------------
> >  1 file changed, 23 insertions(+), 21 deletions(-)
> > 
> > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > index 032a7bf8d259..087165357a5a 100644
> > --- a/mm/page-writeback.c
> > +++ b/mm/page-writeback.c
> > @@ -2285,15 +2285,15 @@ int write_cache_pages(struct address_space *mapping,
> >  	int ret = 0;
> >  	int done = 0;
> >  	int error;
> > -	struct pagevec pvec;
> > -	int nr_pages;
> > +	struct folio_batch fbatch;
> > +	int nr_folios;
> >  	pgoff_t index;
> >  	pgoff_t end;		/* Inclusive */
> >  	pgoff_t done_index;
> >  	int range_whole = 0;
> >  	xa_mark_t tag;
> >  
> > -	pagevec_init(&pvec);
> > +	folio_batch_init(&fbatch);
> >  	if (wbc->range_cyclic) {
> >  		index = mapping->writeback_index; /* prev offset */
> >  		end = -1;
> > @@ -2313,17 +2313,18 @@ int write_cache_pages(struct address_space *mapping,
> >  	while (!done && (index <= end)) {
> >  		int i;
> >  
> > -		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
> > -				tag);
> > -		if (nr_pages == 0)
> > +		nr_folios = filemap_get_folios_tag(mapping, &index, end,
> > +				tag, &fbatch);
> 
> This can find and return dirty multi-page folios if the filesystem
> enables them in the mapping at instantiation time, right?

Yup, it will.

> > +
> > +		if (nr_folios == 0)
> >  			break;
> >  
> > -		for (i = 0; i < nr_pages; i++) {
> > -			struct page *page = pvec.pages[i];
> > +		for (i = 0; i < nr_folios; i++) {
> > +			struct folio *folio = fbatch.folios[i];
> >  
> > -			done_index = page->index;
> > +			done_index = folio->index;
> >  
> > -			lock_page(page);
> > +			folio_lock(folio);
> >  
> >  			/*
> >  			 * Page truncated or invalidated. We can freely skip it
> > @@ -2333,30 +2334,30 @@ int write_cache_pages(struct address_space *mapping,
> >  			 * even if there is now a new, dirty page at the same
> >  			 * pagecache address.
> >  			 */
> > -			if (unlikely(page->mapping != mapping)) {
> > +			if (unlikely(folio->mapping != mapping)) {
> >  continue_unlock:
> > -				unlock_page(page);
> > +				folio_unlock(folio);
> >  				continue;
> >  			}
> >  
> > -			if (!PageDirty(page)) {
> > +			if (!folio_test_dirty(folio)) {
> >  				/* someone wrote it for us */
> >  				goto continue_unlock;
> >  			}
> >  
> > -			if (PageWriteback(page)) {
> > +			if (folio_test_writeback(folio)) {
> >  				if (wbc->sync_mode != WB_SYNC_NONE)
> > -					wait_on_page_writeback(page);
> > +					folio_wait_writeback(folio);
> >  				else
> >  					goto continue_unlock;
> >  			}
> >  
> > -			BUG_ON(PageWriteback(page));
> > -			if (!clear_page_dirty_for_io(page))
> > +			BUG_ON(folio_test_writeback(folio));
> > +			if (!folio_clear_dirty_for_io(folio))
> >  				goto continue_unlock;
> >  
> >  			trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
> > -			error = (*writepage)(page, wbc, data);
> > +			error = writepage(&folio->page, wbc, data);
> 
> Yet, IIUC, this treats all folios as if they are single page folios.
> i.e. it passes the head page of a multi-page folio to a callback
> that will treat it as a single PAGE_SIZE page, because that's all
> the writepage callbacks are currently expected to be passed...
> 
> So won't this break writeback of dirty multipage folios?

Yes, it appears it would. But it wouldn't because its already 'broken'.

The current find_get_pages_range_tag() actually has the exact same
issue. The current code to fill up the pages array is:

		pages[ret] = &folio->page;
		if (++ret == nr_pages) {
			*index = folio->index + folio_nr_pages(folio);
			goto out;

which behaves the same way as the issue you pointed out (both break
large folios). When I spoke to Matthew about this earlier, we decided
to go ahead with replacing the function and leave it up to the callers
to fix/handle large folios when the filesystem gets to it.

Its not great to leave it 'broken' but its something that isn't - or at
least shouldn't be - creating any problems at present. And I believe Matthew
has plans to address them at some point before they actually become problems?

