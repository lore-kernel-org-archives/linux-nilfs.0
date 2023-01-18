From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/9] shmem: remove
 shmem_get_partial_folio
Date: Wed, 18 Jan 2023 08:57:05 -0500
Message-ID: <Y8f6sShghKuFim5E@bfoster>
References: <20230118094329.9553-1-hch@lst.de>
 <20230118094329.9553-5-hch@lst.de>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674050175;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=mFihkpDInrgSgklnLUMioicNGhqhAH1TgcOQOASzKX8=;
	b=gvLqO7uWT7YpQhvfPKNIqr15wU/uxUBl6v8pKqiQBhvbnwHq0Ob6m1veZ1GEERmND2kLYQ
	Y3ZcqayKkZllmhkkN5liotcMJcmDMMtdOgGYuZmVl1vPIq7YToE9L9a3O2ZKYHVS6/4KUj
	tUfvEDcpaGuelJEHfuUDVYXYu4/ISX0=
In-Reply-To: <20230118094329.9553-5-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Wed, Jan 18, 2023 at 10:43:24AM +0100, Christoph Hellwig wrote:
> Add a new SGP_FIND mode for shmem_get_partial_folio that works like
> SGP_READ, but does not check i_size.  Use that instead of open coding
> the page cache lookup in shmem_get_partial_folio.  Note that this is
> a behavior change in that it reads in swap cache entries for offsets
> outside i_size, possibly causing a little bit of extra work.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/shmem_fs.h |  1 +
>  mm/shmem.c               | 46 ++++++++++++----------------------------
>  2 files changed, 15 insertions(+), 32 deletions(-)
> 
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index d09d54be4ffd99..7ba160ac066e5e 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -105,6 +105,7 @@ enum sgp_type {
>  	SGP_CACHE,	/* don't exceed i_size, may allocate page */
>  	SGP_WRITE,	/* may exceed i_size, may allocate !Uptodate page */
>  	SGP_FALLOC,	/* like SGP_WRITE, but make existing page Uptodate */
> +	SGP_FIND,	/* like SGP_READ, but also read outside i_size */
>  };
>  
>  int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio **foliop,
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 9e1015cbad29f9..e9500fea43a8dc 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -877,27 +877,6 @@ void shmem_unlock_mapping(struct address_space *mapping)
>  	}
>  }
>  
> -static struct folio *shmem_get_partial_folio(struct inode *inode, pgoff_t index)
> -{
> -	struct folio *folio;
> -
> -	/*
> -	 * At first avoid shmem_get_folio(,,,SGP_READ): that fails
> -	 * beyond i_size, and reports fallocated pages as holes.
> -	 */
> -	folio = __filemap_get_folio(inode->i_mapping, index,
> -					FGP_ENTRY | FGP_LOCK, 0);

This all seems reasonable to me at a glance, FWIW, but I am a little
curious why this wouldn't split up into two changes. I.e., switch this
over to filemap_get_entry() to minimally remove the FGP_ENTRY dependency
without a behavior change, then (perhaps after the next patch) introduce
SGP_FIND in a separate patch. That makes it easier to review and
potentially undo if it happens to pose a problem in the future. Hm?

Brian

> -	if (!xa_is_value(folio))
> -		return folio;
> -	/*
> -	 * But read a page back from swap if any of it is within i_size
> -	 * (although in some cases this is just a waste of time).
> -	 */
> -	folio = NULL;
> -	shmem_get_folio(inode, index, &folio, SGP_READ);
> -	return folio;
> -}
> -
>  /*
>   * Remove range of pages and swap entries from page cache, and free them.
>   * If !unfalloc, truncate or punch hole; if unfalloc, undo failed fallocate.
> @@ -957,7 +936,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
>  		goto whole_folios;
>  
>  	same_folio = (lstart >> PAGE_SHIFT) == (lend >> PAGE_SHIFT);
> -	folio = shmem_get_partial_folio(inode, lstart >> PAGE_SHIFT);
> +	folio = NULL;
> +	shmem_get_folio(inode, lstart >> PAGE_SHIFT, &folio, SGP_FIND);
>  	if (folio) {
>  		same_folio = lend < folio_pos(folio) + folio_size(folio);
>  		folio_mark_dirty(folio);
> @@ -971,14 +951,16 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
>  		folio = NULL;
>  	}
>  
> -	if (!same_folio)
> -		folio = shmem_get_partial_folio(inode, lend >> PAGE_SHIFT);
> -	if (folio) {
> -		folio_mark_dirty(folio);
> -		if (!truncate_inode_partial_folio(folio, lstart, lend))
> -			end = folio->index;
> -		folio_unlock(folio);
> -		folio_put(folio);
> +	if (!same_folio) {
> +		folio = NULL;
> +		shmem_get_folio(inode, lend >> PAGE_SHIFT, &folio, SGP_FIND);
> +		if (folio) {
> +			folio_mark_dirty(folio);
> +			if (!truncate_inode_partial_folio(folio, lstart, lend))
> +				end = folio->index;
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
>  	}
>  
>  whole_folios:
> @@ -1900,7 +1882,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>  		if (folio_test_uptodate(folio))
>  			goto out;
>  		/* fallocated folio */
> -		if (sgp != SGP_READ)
> +		if (sgp != SGP_READ && sgp != SGP_FIND)
>  			goto clear;
>  		folio_unlock(folio);
>  		folio_put(folio);
> @@ -1911,7 +1893,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>  	 * SGP_NOALLOC: fail on hole, with NULL folio, letting caller fail.
>  	 */
>  	*foliop = NULL;
> -	if (sgp == SGP_READ)
> +	if (sgp == SGP_READ || sgp == SGP_FIND)
>  		return 0;
>  	if (sgp == SGP_NOALLOC)
>  		return -ENOENT;
> -- 
> 2.39.0
> 
> 

