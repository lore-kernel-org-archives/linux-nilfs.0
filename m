From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/23] page-writeback: Convert
 write_cache_pages() to use filemap_get_folios_tag()
Date: Fri, 4 Nov 2022 14:36:59 +1100
Message-ID: <20221104033659.GA2703033@dread.disaster.area>
References: <20220901220138.182896-1-vishal.moola@gmail.com>
 <20220901220138.182896-5-vishal.moola@gmail.com>
 <20221018210152.GH2703033@dread.disaster.area>
 <Y2RAdUtJrOJmYU4L@fedora>
 <20221104003235.GZ2703033@dread.disaster.area>
 <Y2R8rRr0ZdrlT32m@magnolia>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667533034;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=kCztCif6DGnUVPea69d1j6HBte1tInJ//NGbT2adCtA=;
	b=gqO+1Jo24oUvlZF3Ebcgb6r/htzR0aTyladMXKyLjgMlUgIjEyjFrSabU4570uhmwPCFkP
	7uULMs0ag054uLS5cs1OgRWt54uLji/thWgPpXJCEdUmrssyW+rFIG4KvMYqrIqjlJrjSP
	pgEG633xpH63XqPuoLZg9KHlxOHLJuE=
In-Reply-To: <Y2R8rRr0ZdrlT32m@magnolia>
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
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-cifs@vger.kernel.org, cluster-devel@redhat.com, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-f2fs-devel@lists.sourceforge.net, Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Thu, Nov 03, 2022 at 07:45:01PM -0700, Darrick J. Wong wrote:
> On Fri, Nov 04, 2022 at 11:32:35AM +1100, Dave Chinner wrote:
> > On Thu, Nov 03, 2022 at 03:28:05PM -0700, Vishal Moola wrote:
> > > On Wed, Oct 19, 2022 at 08:01:52AM +1100, Dave Chinner wrote:
> > > > On Thu, Sep 01, 2022 at 03:01:19PM -0700, Vishal Moola (Oracle) wrote:
> > > > > -			BUG_ON(PageWriteback(page));
> > > > > -			if (!clear_page_dirty_for_io(page))
> > > > > +			BUG_ON(folio_test_writeback(folio));
> > > > > +			if (!folio_clear_dirty_for_io(folio))
> > > > >  				goto continue_unlock;
> > > > >  
> > > > >  			trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
> > > > > -			error = (*writepage)(page, wbc, data);
> > > > > +			error = writepage(&folio->page, wbc, data);
> > > > 
> > > > Yet, IIUC, this treats all folios as if they are single page folios.
> > > > i.e. it passes the head page of a multi-page folio to a callback
> > > > that will treat it as a single PAGE_SIZE page, because that's all
> > > > the writepage callbacks are currently expected to be passed...
> > > > 
> > > > So won't this break writeback of dirty multipage folios?
> > > 
> > > Yes, it appears it would. But it wouldn't because its already 'broken'.
> > 
> > It is? Then why isn't XFS broken on existing kernels? Oh, we don't
> > know because it hasn't been tested?
> > 
> > Seriously - if this really is broken, and this patchset further
> > propagating the brokeness, then somebody needs to explain to me why
> > this is not corrupting data in XFS.
> 
> It looks like iomap_do_writepage finds the folio size correctly
> 
> 	end_pos = folio_pos(folio) + folio_size(folio);
> 
> and iomap_writpage_map will map out the correct number of blocks
> 
> 	unsigned nblocks = i_blocks_per_folio(inode, folio);
> 
> 	for (i = 0; i < nblocks && pos < end_pos; i++, pos += len) {
> 
> right?

Yup, that's how I read it, too.

But my recent experience with folios involved being repeatedly
burnt by edge case corruptions due to multipage folios showing up
when and where I least expected them.

Hence doing a 1:1 conversion of page based code to folio based code
and just assuming large folios will work without any testing seems
akin to playing russian roulette with loose cannons that have been
doused with napalm and then set on fire by an air-dropped barrel
bomb...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

