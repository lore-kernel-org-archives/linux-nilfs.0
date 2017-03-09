From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v2 3/9] mm: clear any AS_* errors when returning error
 on any fsync or close
Date: Wed, 08 Mar 2017 19:10:15 -0500
Message-ID: <1489018215.6107.4.camel@redhat.com>
References: <20170308162934.21989-1-jlayton@redhat.com>
	 <20170308162934.21989-4-jlayton@redhat.com>
	 <8760jjv4ww.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <8760jjv4ww.fsf@notabene.neil.brown.name>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: NeilBrown <neilb@suse.com>, viro@zeniv.linux.org.uk, akpm@linux-foundation.org
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, ross.zwisler@linux.intel.com, jack@suse.cz, openosd@gmail.com, adilger@dilger.ca, James.Bottomley@HansenPartnership.com

On Thu, 2017-03-09 at 08:23 +1100, NeilBrown wrote:
> On Thu, Mar 09 2017, Jeff Layton wrote:
> 
> > Currently we don't clear the address space error when there is a -EIO
> > error on fsynci, due to writeback initiation failure. If writes fail
> > with -EIO and the mapping is flagged with an AS_EIO or AS_ENOSPC error,
> > then we can end up returning errors on two fsync calls, even when a
> > write between them succeeded (or there was no write).
> > 
> > Ensure that we also clear out any mapping errors when initiating
> > writeback fails with -EIO in filemap_write_and_wait and
> > filemap_write_and_wait_range.
> 
> This change appears to assume that filemap_write_and_wait* is only
> called from fsync() (or similar) and the return status is always
> checked.
> 
> A __must_check annotation might be helpful.
> 

Yes, good idea.

> It would catch v9_fs_file_lock(), afs_setattr() and others.
> 

Ouch -- good catch.

Actually, those look like bugs in the code as it exists today. If some
background page writeback fails, but no write initiation fails on that
call, then those callers are discarding errors that should have been
reported at fsync.

> While I think your change is probably heading in the right direction,
> there seem to be some loose ends still.
> 

Yes...I probably should be prefacing all of these patches with [RFC] at
this point.

I think I'm starting to grasp the problem (and its scope), but we might
have to think about how to approach this more strategically. Given that
we have this wrong in so many places, I think that probably means that
the interfaces we have make it easy to do so. I need to consider how to
correct that.

> 
> 
> > 
> > Suggested-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> >  mm/filemap.c | 20 ++++++++++++++++++--
> >  1 file changed, 18 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 1694623a6289..fc123b9833e1 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -488,7 +488,7 @@ EXPORT_SYMBOL(filemap_fdatawait);
> >  
> >  int filemap_write_and_wait(struct address_space *mapping)
> >  {
> > -	int err = 0;
> > +	int err;
> >  
> >  	if ((!dax_mapping(mapping) && mapping->nrpages) ||
> >  	    (dax_mapping(mapping) && mapping->nrexceptional)) {
> > @@ -499,10 +499,18 @@ int filemap_write_and_wait(struct address_space *mapping)
> >  		 * But the -EIO is special case, it may indicate the worst
> >  		 * thing (e.g. bug) happened, so we avoid waiting for it.
> >  		 */
> > -		if (err != -EIO) {
> > +		if (likely(err != -EIO)) {
> >  			int err2 = filemap_fdatawait(mapping);
> >  			if (!err)
> >  				err = err2;
> > +		} else {
> > +			/*
> > +			 * Clear the error in the address space since we're
> > +			 * returning an error here. -EIO takes precedence over
> > +			 * everything else though, so we can just discard
> > +			 * the return here.
> > +			 */
> > +			filemap_check_errors(mapping);
> >  		}
> >  	} else {
> >  		err = filemap_check_errors(mapping);
> > @@ -537,6 +545,14 @@ int filemap_write_and_wait_range(struct address_space *mapping,
> >  						lstart, lend);
> >  			if (!err)
> >  				err = err2;
> > +		} else {
> > +			/*
> > +			 * Clear the error in the address space since we're
> > +			 * returning an error here. -EIO takes precedence over
> > +			 * everything else though, so we can just discard
> > +			 * the return here.
> > +			 */
> > +			filemap_check_errors(mapping);
> >  		}
> >  	} else {
> >  		err = filemap_check_errors(mapping);
> > -- 
> > 2.9.3

-- 
Jeff Layton <jlayton@redhat.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
