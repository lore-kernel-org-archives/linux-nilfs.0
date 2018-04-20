From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH v11 19/63] page cache: Convert page deletion to
 XArray
Date: Fri, 20 Apr 2018 07:00:57 -0500
Message-ID: <979c1602-42e3-349d-a5e4-d28de14112dd@suse.de>
References: <20180414141316.7167-1-willy@infradead.org>
 <20180414141316.7167-20-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
 MIME-Version:Date:Message-ID:References:Cc:To:Subject:From:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=CciXFGJNUiJQs1riv1+a0bwHQmPa981qbPbkq/W6c7U=; b=M2NPA5PaN8aW8AVdsmnFnXzi4k
 Et/5VW832c/gCopLjMC/W0hdf7vnk5tMkafwfmkJXRZHh+lcvt4AdAtoL9tRToqT0+/rssh3eOtyo
 QF19UoAKW0IiSOObxGgY7INRMRkyHrjTMIUvIc3Iygyp3PfKeRVw1SVBEASUGByQq4nM=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
 Message-ID:References:Cc:To:Subject:From:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=CciXFGJNUiJQs1riv1+a0bwHQmPa981qbPbkq/W6c7U=; b=EmzeP1BnXIrNDqWtI23WwF8+uT
 2nLXpl/h+Osmg5xUjVOiytazqriufVELvPQSx/fB42ktPnFyrpg+wqPqNHgTFLtSeAyu5eck99kSH
 zqpckzpOt5KuUc+jVRpcmBKWaE0uwZ9F2nlKA7K4SYESAGVwyU5ehD5yzdnky2xMij5U=;
In-Reply-To: <20180414141316.7167-20-willy@infradead.org>
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
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Mike Kravetz <mike.kravetz@oracle.com>



On 04/14/2018 09:12 AM, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> The code is slightly shorter and simpler.
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
> ---
>  mm/filemap.c | 30 ++++++++++++++----------------
>  1 file changed, 14 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 070b5e4527ac..4af06a1a9818 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -111,30 +111,28 @@
>   *   ->tasklist_lock            (memory_failure, collect_procs_ao)
>   */
>  
> -static void page_cache_tree_delete(struct address_space *mapping,
> +static void page_cache_delete(struct address_space *mapping,
>  				   struct page *page, void *shadow)
>  {
> -	int i, nr;
> +	XA_STATE(xas, &mapping->i_pages, page->index);
> +	unsigned int i, nr;
>  
> -	/* hugetlb pages are represented by one entry in the radix tree */
> +	mapping_set_update(&xas, mapping);
> +
> +	/* hugetlb pages are represented by a single entry in the xarray */
>  	nr = PageHuge(page) ? 1 : hpage_nr_pages(page);
>  
>  	VM_BUG_ON_PAGE(!PageLocked(page), page);
>  	VM_BUG_ON_PAGE(PageTail(page), page);
>  	VM_BUG_ON_PAGE(nr != 1 && shadow, page);
>  
> -	for (i = 0; i < nr; i++) {
> -		struct radix_tree_node *node;
> -		void **slot;
> -
> -		__radix_tree_lookup(&mapping->i_pages, page->index + i,
> -				    &node, &slot);
> -
> -		VM_BUG_ON_PAGE(!node && nr != 1, page);
> -
> -		radix_tree_clear_tags(&mapping->i_pages, node, slot);
> -		__radix_tree_replace(&mapping->i_pages, node, slot, shadow,
> -				workingset_lookup_update(mapping));
> +	i = nr;
> +repeat:
> +	xas_store(&xas, shadow);
> +	xas_init_tags(&xas);
> +	if (--i) {
> +		xas_next(&xas);
> +		goto repeat;
>  	}

Can this be converted into a do {} while (or even for) loop instead?
Loops are easier to read and understand in such a situation.

>  
>  	page->mapping = NULL;
> @@ -234,7 +232,7 @@ void __delete_from_page_cache(struct page *page, void *shadow)
>  	trace_mm_filemap_delete_from_page_cache(page);
>  
>  	unaccount_page_cache_page(mapping, page);
> -	page_cache_tree_delete(mapping, page, shadow);
> +	page_cache_delete(mapping, page, shadow);
>  }
>  
>  static void page_cache_free_page(struct address_space *mapping,
> 

-- 
Goldwyn



------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
