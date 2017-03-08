From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v2 6/9] mm: set mapping error when launder_pages fails
Date: Wed, 08 Mar 2017 13:38:08 -0500
Message-ID: <1488998288.2802.25.camel@redhat.com>
References: <20170308162934.21989-1-jlayton@redhat.com>
	 <20170308162934.21989-7-jlayton@redhat.com>
	 <1488996103.3098.4.camel@primarydata.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1488996103.3098.4.camel@primarydata.com>
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Trond Myklebust <trondmy@primarydata.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "konishi.ryusuke@lab.ntt.co.jp" <konishi.ryusuke@lab.ntt.co.jp>, "neilb@suse.com" <neilb@suse.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "adilger@dilger.ca" <adilger@dilger.ca>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "openosd@gmail.com" <openosd@gmail.com>, "jack@suse.cz" <jack@suse.cz>

On Wed, 2017-03-08 at 18:01 +0000, Trond Myklebust wrote:
> On Wed, 2017-03-08 at 11:29 -0500, Jeff Layton wrote:
> > If launder_page fails, then we hit a problem writing back some inode
> > data. Ensure that we communicate that fact in a subsequent fsync
> > since
> > another task could still have it open for write.
> > 
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> >  mm/truncate.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/truncate.c b/mm/truncate.c
> > index 6263affdef88..29ae420a5bf9 100644
> > --- a/mm/truncate.c
> > +++ b/mm/truncate.c
> > @@ -594,11 +594,15 @@ invalidate_complete_page2(struct address_space
> > *mapping, struct page *page)
> >  
> >  static int do_launder_page(struct address_space *mapping, struct
> > page *page)
> >  {
> > +	int ret;
> > +
> >  	if (!PageDirty(page))
> >  		return 0;
> >  	if (page->mapping != mapping || mapping->a_ops->launder_page 
> > == NULL)
> >  		return 0;
> > -	return mapping->a_ops->launder_page(page);
> > +	ret = mapping->a_ops->launder_page(page);
> > +	mapping_set_error(mapping, ret);
> > +	return ret;
> >  }
> >  
> >  /**
> 
> No. At that layer, you don't know that this is a page error. In the NFS
> case, it could, for instance, just as well be a fatal signal.
> 

Ok...don't we have the same problem with writepage then? Most of the
writepage callers will set an error in the mapping if writepage returns
any sort of error? A fatal signal in that codepath could cause the same
problem, it seems. We don't dip into direct reclaim so much anymore, so
maybe signals aren't an issue there?

The alternative here would be to push this down into the callers. I
worry a bit though about getting this right across filesystems though.
It'd be preferable it if we could keep the mapping_set_error call in
generic VFS code instead, but if not then I'll just plan to do that.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
