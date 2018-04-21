From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v11 10/63] xarray: Add xa_for_each
Date: Fri, 20 Apr 2018 18:34:06 -0700
Message-ID: <20180421013406.GM10788@bombadil.infradead.org>
References: <20180414141316.7167-1-willy@infradead.org>
 <20180414141316.7167-11-willy@infradead.org>
 <35a3318d-69d7-a10c-1515-98ea6b59fb99@suse.de>
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
 bh=+g89yHxCOeGaxjKxFBpyB5IhNILwf/JZQlg0eo+22I8=; b=SPQXquPBPadKrDMjw4MYbiZp2L
 gJo20CjUZ5Rtwo0aV6qXA67nymxYe3xjwohgQnCdjH3MGncvbXfGsbO+/h8E+ws81jrr0uo4ZF4H+
 qA11GCoM/4tnbl0O7XBshsVjpeEEb+NDJlbYtS4S66pJqvRZe5runqG8dI3aP60KH33U=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=+g89yHxCOeGaxjKxFBpyB5IhNILwf/JZQlg0eo+22I8=; b=DR029+chYv1e8oNPWqXmUqgUNS
 9b6P5GoZVFihZJQv3reOtFPGS6j5ifT9MyJ1b2IbuiMC92j0V7Bc1phPHunKpDghnYtqo5qCsSzJA
 HiaejRiS33YwGiANFH+aYzZmFtHb/FivlOemX0ZxQIhdUI71Tvl7t3u2zrYcpqMLXRHw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=+g89yHxCOeGaxjKxFBpyB5IhNILwf/JZQlg0eo+22I8=; b=tDrhYLUXruhpiZhNw0QzzMTui
 Jw3o43k4K+Jumm0XGJ9No1pkZsKnBRwmGASNayx2wEPHNRqR0Li7SIrFYsR6/7tzpMOn7PX3SCxgt
 22GzPvTlcqZITVcy5t6BexkB2KcdIo2JNVxU1Rmfy8CICtY0lyuH5hxqap4I6P3ff6h8m4X3m4Xcp
 Wc3uO8+h0cmve9V2HLgUPqqu//xYnXK3VXQDTbNCMwq1fj1/Y3s/DhPPmu2E2lmuhsj33Z/IljkxU
 rvB/ZWhfiF7jaSlhB76rd3UgECx16U9bh53B3WzVtD7F0T/dsUlnAZ2CXMIC7TzbvJcrGlQQClBLP
 lt2Yhd8rQ==;
Content-Disposition: inline
In-Reply-To: <35a3318d-69d7-a10c-1515-98ea6b59fb99@suse.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, linux-mm@kvack.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Mike Kravetz <mike.kravetz@oracle.com>

On Fri, Apr 20, 2018 at 07:00:47AM -0500, Goldwyn Rodrigues wrote:
> > +/**
> > + * xas_for_each_tag() - Iterate over a range of an XArray
> > + * @xas: XArray operation state.
> > + * @entry: Entry retrieved from array.
> > + * @max: Maximum index to retrieve from array.
> > + * @tag: Tag to search for.
> > + *
> > + * The loop body will be executed for each tagged entry in the xarray
> > + * between the current xas position and @max.  @entry will be set to
> > + * the entry retrieved from the xarray.  It is safe to delete entries
> > + * from the array in the loop body.  You should hold either the RCU lock
> > + * or the xa_lock while iterating.  If you need to drop the lock, call
> > + * xas_pause() first.
> > + */
> > +#define xas_for_each_tag(xas, entry, max, tag) \
> > +	for (entry = xas_find_tag(xas, max, tag); entry; \
> > +	     entry = xas_next_tag(xas, max, tag))
> > +
> 
> This function name sounds like you are performing the operation for each
> tag.
> 
> Can it be called xas_for_each_tagged() or xas_tag_for_each() instead?

I hadn't thought of that interpretation.  Yes, that makes sense.
Should we also rename xas_find_tag -> xas_find_tagged and xas_next_tag
-> xas_next_tagged?

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
