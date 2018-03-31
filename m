From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v10 43/62] memfd: Convert shmem_tag_pins to
 XArray
Date: Fri, 30 Mar 2018 17:05:05 -0700
Message-ID: <39ea3393-c3d7-07c3-a072-344f3a65cef3@oracle.com>
References: <20180330034245.10462-1-willy@infradead.org>
 <20180330034245.10462-44-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
 MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=lEa6nvRJAiFgp7b35WZiw6qiVbrnOgagde60xGUwRQ0=; b=P0b+ECeL14isx82lWr59CTsgoE
 5xJWjFadfWFfUz5DeVSvIve9cLyqsngK8FzgpssLgfLDgYF9VgQa/ymtEf2npJ63CTZ4sr6CGsDHt
 VZpZCVvm0jS1jzKhAseZed6wYW6ERwD5YE9OwjErmE0EjsOCHdprWHfzzycGXAfhSb2w=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
 Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=lEa6nvRJAiFgp7b35WZiw6qiVbrnOgagde60xGUwRQ0=; b=aEqh5J972Jp9bpfbu7DP+BLe6+
 +RxXFbxUSIowjW5ESoSKkZI7h3V+FAEFB7/ZYmVrxD9+y1HzPFNYjC/OltT0SZsrW/PJqp+Lbs99p
 wiKnyIiKtYcJGVtAgAC2bvnWUOTq2fpXAFpeO15vPwqynpxHVS7tsvXhJR3FoGiiZtpI=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2017-10-26;
 bh=lEa6nvRJAiFgp7b35WZiw6qiVbrnOgagde60xGUwRQ0=;
 b=LX4hBoz2dsNzy5fORrJ4wRytGcYAgRNOY5NgQRk4sgSXKSJj+G4HKwbZaCdg1Ao9vEGf
 WyCfOBY9DzP2C4ZsQuoRyrHuwtTJav/s+zKYa/hiq/RPQ4L7xp+2r3Y9CxurFw8LG4DV
 I0wHdyTFMW4CodStsMrsdG3OuzPPIkKB8XwIPJgtEkOn3xevpuFpRyXjemwyDMEiWwv/
 nrFR/QLUT7JqEuCy1AEvDxONoDBIFcYZIzSFpRnDvvGrDfzBArPe2D3AJpzX2Zq+vMFp
 VbXA6ieEN8VqbBb53I4OGTFBfOqqdL24EoArfFtJxKk37l8sp232EXweOdIBf3OAxxyZ mQ== 
In-Reply-To: <20180330034245.10462-44-willy@infradead.org>
Content-Language: en-US
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

On 03/29/2018 08:42 PM, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> Simplify the locking by taking the spinlock while we walk the tree on
> the assumption that many acquires and releases of the lock will be
> worse than holding the lock for a (potentially) long time.

I see this change made in several of the patches and do not have a
specific issue with it.  As part of the XArray implementation you
have XA_CHECK_SCHED = 4096.   So, we drop locks and do a cond_resched
after XA_CHECK_SCHED iterations.  Just curious how you came up with
that number.  Apologies in advance if this was discussed in a previous
round of reviews.

> 
> We could replicate the same locking behaviour with the xarray, but would
> have to be careful that the xa_node wasn't RCU-freed under us before we
> took the lock.
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>

I did not do a detailed review of the XArray implementation.  Only looked
at the provided interfaces and their intended uses.  If the interfaces work
as specified, the changes here are fine.

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>

-- 
Mike Kravetz

> ---
>  mm/memfd.c | 43 ++++++++++++++++++-------------------------
>  1 file changed, 18 insertions(+), 25 deletions(-)
> 
> diff --git a/mm/memfd.c b/mm/memfd.c
> index 4cf7401cb09c..3b299d72df78 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -21,7 +21,7 @@
>  #include <uapi/linux/memfd.h>
>  
>  /*
> - * We need a tag: a new tag would expand every radix_tree_node by 8 bytes,
> + * We need a tag: a new tag would expand every xa_node by 8 bytes,
>   * so reuse a tag which we firmly believe is never set or cleared on shmem.
>   */
>  #define SHMEM_TAG_PINNED        PAGECACHE_TAG_TOWRITE
> @@ -29,35 +29,28 @@
>  
>  static void shmem_tag_pins(struct address_space *mapping)
>  {
> -	struct radix_tree_iter iter;
> -	void __rcu **slot;
> -	pgoff_t start;
> +	XA_STATE(xas, &mapping->i_pages, 0);
>  	struct page *page;
> +	unsigned int tagged = 0;
>  
>  	lru_add_drain();
> -	start = 0;
> -	rcu_read_lock();
> -
> -	radix_tree_for_each_slot(slot, &mapping->i_pages, &iter, start) {
> -		page = radix_tree_deref_slot(slot);
> -		if (!page || radix_tree_exception(page)) {
> -			if (radix_tree_deref_retry(page)) {
> -				slot = radix_tree_iter_retry(&iter);
> -				continue;
> -			}
> -		} else if (page_count(page) - page_mapcount(page) > 1) {
> -			xa_lock_irq(&mapping->i_pages);
> -			radix_tree_tag_set(&mapping->i_pages, iter.index,
> -					   SHMEM_TAG_PINNED);
> -			xa_unlock_irq(&mapping->i_pages);
> -		}
>  
> -		if (need_resched()) {
> -			slot = radix_tree_iter_resume(slot, &iter);
> -			cond_resched_rcu();
> -		}
> +	xas_lock_irq(&xas);
> +	xas_for_each(&xas, page, ULONG_MAX) {
> +		if (xa_is_value(page))
> +			continue;
> +		if (page_count(page) - page_mapcount(page) > 1)
> +			xas_set_tag(&xas, SHMEM_TAG_PINNED);
> +
> +		if (++tagged % XA_CHECK_SCHED)
> +			continue;
> +
> +		xas_pause(&xas);
> +		xas_unlock_irq(&xas);
> +		cond_resched();
> +		xas_lock_irq(&xas);
>  	}
> -	rcu_read_unlock();
> +	xas_unlock_irq(&xas);
>  }
>  
>  /*
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
