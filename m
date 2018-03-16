From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v9 09/61] xarray: Replace exceptional entries
Date: Fri, 16 Mar 2018 12:06:04 -0700
Message-ID: <20180316190604.GF27498@bombadil.infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
 <20180313132639.17387-10-willy@infradead.org>
 <20180316185349.c4ebbwuzlhihec5f@destiny>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RA+CxjyVefq0tqAPZi6/eul5TLvIfvdFGHfK00ingsc=; b=otooHYdRSb53Nf8Agg0p3Qv+j
        Q9OctsliD6EWky8KfB3aQgkjA4I6An8BZ5V1VWv3RmurK8ofnNSnxLoqwK49VEHRtdqOuGC7TlwfA
        pI0GN5LLpcN3b94p2JCFQIeb2W7LTCjxZcEerwKeI6stn9Ziw7JZQxUM3ecWwXUl/m6WykJx2vxs4
        Oj/j0+fRlBMVBQguaQON78eWrQ6xsytITVowaRVHATp30ueEZ7uT1LxRozCNXvf6bwRo/qgroIhul
        8NL7k6CSCABMryEIIBqugvLcfoUtI4s6DH8tnwyHjJ/H8pojQ/zEtRy05/jbgzv1mJxZermmgo6yP
    
Content-Disposition: inline
In-Reply-To: <20180316185349.c4ebbwuzlhihec5f@destiny>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@toxicpanda.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

On Fri, Mar 16, 2018 at 02:53:50PM -0400, Josef Bacik wrote:
> On Tue, Mar 13, 2018 at 06:25:47AM -0700, Matthew Wilcox wrote:
> > @@ -453,18 +449,14 @@ int ida_get_new_above(struct ida *ida, int start, int *id)
> >  			new += bit;
> >  			if (new < 0)
> >  				return -ENOSPC;
> > -			if (ebit < BITS_PER_LONG) {
> > -				bitmap = (void *)((1UL << ebit) |
> > -						RADIX_TREE_EXCEPTIONAL_ENTRY);
> > -				radix_tree_iter_replace(root, &iter, slot,
> > -						bitmap);
> > -				*id = new;
> > -				return 0;
> > +			if (bit < BITS_PER_XA_VALUE) {
> > +				bitmap = xa_mk_value(1UL << bit);
> > +			} else {
> > +				bitmap = this_cpu_xchg(ida_bitmap, NULL);
> > +				if (!bitmap)
> > +					return -EAGAIN;
> > +				__set_bit(bit, bitmap->bitmap);
> >  			}
> > -			bitmap = this_cpu_xchg(ida_bitmap, NULL);
> > -			if (!bitmap)
> > -				return -EAGAIN;
> > -			__set_bit(bit, bitmap->bitmap);
> >  			radix_tree_iter_replace(root, &iter, slot, bitmap);
> >  		}
> >  
> 
> This threw me off a bit, but we do *id = new below.

Yep.  Fortunately, I have a test-suite for the IDA, so I'm relatively
sure this works.

> > @@ -495,9 +487,9 @@ void ida_remove(struct ida *ida, int id)
> >  		goto err;
> >  
> >  	bitmap = rcu_dereference_raw(*slot);
> > -	if (radix_tree_exception(bitmap)) {
> > +	if (xa_is_value(bitmap)) {
> >  		btmp = (unsigned long *)slot;
> > -		offset += RADIX_TREE_EXCEPTIONAL_SHIFT;
> > +		offset += 1; /* Intimate knowledge of the xa_data encoding */
> >  		if (offset >= BITS_PER_LONG)
> >  			goto err;
> >  	} else {
> 
> Ick.

I know.  I feel quite ashamed of this code.  I do have a rewrite to use
the XArray, but I didn't want to include it as part of *this* merge request.
And that rewrite decodes the value into an unsigned long, sets the bit,
reencodes it as an xa_value and stores it.

> > @@ -393,11 +393,11 @@ void ida_check_conv(void)
> >  	for (i = 0; i < 1000000; i++) {
> >  		int err = ida_get_new(&ida, &id);
> >  		if (err == -EAGAIN) {
> > -			assert((i % IDA_BITMAP_BITS) == (BITS_PER_LONG - 2));
> > +			assert((i % IDA_BITMAP_BITS) == (BITS_PER_LONG - 1));
> >  			assert(ida_pre_get(&ida, GFP_KERNEL));
> >  			err = ida_get_new(&ida, &id);
> >  		} else {
> > -			assert((i % IDA_BITMAP_BITS) != (BITS_PER_LONG - 2));
> > +			assert((i % IDA_BITMAP_BITS) != (BITS_PER_LONG - 1));
> 
> Can we just use BITS_PER_XA_VALUE here?

Yes!  I'll change that.

> Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks!
