From: David Sterba <dsterba-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 4/7] btrfs: Convert process_page_range() to use
 filemap_get_folios_contig()
Date: Tue, 23 Aug 2022 22:38:25 +0200
Message-ID: <20220823203825.GT13489@twin.jikos.cz>
References: <20220816175246.42401-1-vishal.moola@gmail.com>
 <20220816175246.42401-5-vishal.moola@gmail.com>
Reply-To: dsterba-AlSwsSmVLrQ@public.gmane.org
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1661287419;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nvUii2Ere0iwPAZzLrUqcRoqaN33vJT3Za8FZvP1Oes=;
        b=nF/SYpX0baEzY/ugyPQ5L8m/l9RISUp24MncZFUB2HeyoHjj5+C1rsnQ0bpvcKftU+/8Ka
        vefiOQhXMOPer3UAUx1pWkowFjTm6itVCAjFzk+9YArJFRLGrzG6QaqSo/yXVhzE7FK6K6
        g4pLpbGi7xKbCuH5cUAQeLN71T2YMuQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1661287419;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nvUii2Ere0iwPAZzLrUqcRoqaN33vJT3Za8FZvP1Oes=;
        b=ZXjO/kDKQb8ICoMCdvjHznlofq/jGeDCXHPmbWtoIwgThYUGWCdKVZ6yF0G1TO2ScdvvY2
        g9jX6JO4KbtX/aDg==
Content-Disposition: inline
In-Reply-To: <20220816175246.42401-5-vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Vishal Moola (Oracle)" <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 16, 2022 at 10:52:43AM -0700, Vishal Moola (Oracle) wrote:
> Converted function to use folios throughout. This is in preparation for
> the removal of find_get_pages_contig(). Now also supports large folios.
> 
> Since we may receive more than nr_pages pages, nr_pages may underflow.
> Since nr_pages > 0 is equivalent to index <= end_index, we replaced it
> with this check instead.
> 
> Also minor comment renaming for consistency in subpage.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>

> --- a/fs/btrfs/tests/extent-io-tests.c
> +++ b/fs/btrfs/tests/extent-io-tests.c
> @@ -4,6 +4,7 @@
>   */
>  
>  #include <linux/pagemap.h>
> +#include <linux/pagevec.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <linux/sizes.h>
> @@ -20,39 +21,39 @@ static noinline int process_page_range(struct inode *inode, u64 start, u64 end,
>  				       unsigned long flags)
>  {
>  	int ret;
> -	struct page *pages[16];
> +	struct folio_batch fbatch;
>  	unsigned long index = start >> PAGE_SHIFT;
>  	unsigned long end_index = end >> PAGE_SHIFT;
> -	unsigned long nr_pages = end_index - index + 1;
>  	int i;
>  	int count = 0;
>  	int loops = 0;
>  
> -	while (nr_pages > 0) {
> -		ret = find_get_pages_contig(inode->i_mapping, index,
> -				     min_t(unsigned long, nr_pages,
> -				     ARRAY_SIZE(pages)), pages);
> +	folio_batch_init(&fbatch);
> +
> +	while (index <= end_index) {
> +		ret = filemap_get_folios_contig(inode->i_mapping, &index,
> +				end_index, &fbatch);
>  		for (i = 0; i < ret; i++) {
> +			struct folio *folio = fbatch.folios[i];

Add a newline please

>  			if (flags & PROCESS_TEST_LOCKED &&
> -			    !PageLocked(pages[i]))
> +			    !folio_test_locked(folio))
>  				count++;
> -			if (flags & PROCESS_UNLOCK && PageLocked(pages[i]))
> -				unlock_page(pages[i]);
> -			put_page(pages[i]);
> +			if (flags & PROCESS_UNLOCK && folio_test_locked(folio))
> +				folio_unlock(folio);
>  			if (flags & PROCESS_RELEASE)
> -				put_page(pages[i]);
> +				folio_put(folio);
>  		}
> -		nr_pages -= ret;
> -		index += ret;
> +		folio_batch_release(&fbatch);
>  		cond_resched();
>  		loops++;
>  		if (loops > 100000) {
>  			printk(KERN_ERR
> -		"stuck in a loop, start %llu, end %llu, nr_pages %lu, ret %d\n",
> -				start, end, nr_pages, ret);
> +		"stuck in a loop, start %llu, end %llu, ret %d\n",
> +				start, end, ret);
>  			break;
>  		}
>  	}
> +
>  	return count;
>  }
>  
> -- 
> 2.36.1
