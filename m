From: Chao Yu <chao@kernel.org>
Subject: Re: [f2fs-dev] [PATCH v3 12/23] f2fs: Convert
 f2fs_flush_inline_data() to use filemap_get_folios_tag()
Date: Sat, 29 Oct 2022 12:47:05 +0800
Message-ID: <04bf9d52-e12d-f11b-558e-a6b358e4b564@kernel.org>
References: <20221017202451.4951-1-vishal.moola@gmail.com>
 <20221017202451.4951-13-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667018828;
        bh=30H2uNbMFKcPAqFuShUf03uMolLK4p541xhuBs+CXnI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=gfP7Tdy8pIqM0v1DJqaGNtauH+2lb48dJX1fYQaIymUJ+CLtqqb7q9wwRAcGy2DSs
         BdOmbwNbY5OZr2xEEYKKwU2aU+9GuTOSo4R6ns36zTSUIcjAcfVL/VlZzpDeZpKME8
         JwsNjTbmlK+V7B2zgQZey1WW23pzhAP58MPZ23igfVckJhNckDLUxy6puVSkrGCoRK
         f7eGMud7OL+mzoMFyvpYEH0blFGHNsjz3+hc1IYbpOYbQAJIjaOJ/GfqfVcPe35zvS
         TRnDS1nX8jY4iti+jV9+pW0OWxMZ12yvdyJjPO1eQOSLk6K/9vEZaUEfj2WxQfgeHF
         1akF8W1Dj6/Qg==
Content-Language: en-US
In-Reply-To: <20221017202451.4951-13-vishal.moola@gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On 2022/10/18 4:24, Vishal Moola (Oracle) wrote:
> Convert function to use a folio_batch instead of pagevec. This is in
> preparation for the removal of find_get_pages_tag().
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

Acked-by: Chao Yu <chao@kernel.org>

Thanks,

> ---
>   fs/f2fs/node.c | 17 +++++++++--------
>   1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index e8b72336c096..a2f477cc48c7 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1887,17 +1887,18 @@ static bool flush_dirty_inode(struct page *page)
>   void f2fs_flush_inline_data(struct f2fs_sb_info *sbi)
>   {
>   	pgoff_t index = 0;
> -	struct pagevec pvec;
> -	int nr_pages;
> +	struct folio_batch fbatch;
> +	int nr_folios;
>   
> -	pagevec_init(&pvec);
> +	folio_batch_init(&fbatch);
>   
> -	while ((nr_pages = pagevec_lookup_tag(&pvec,
> -			NODE_MAPPING(sbi), &index, PAGECACHE_TAG_DIRTY))) {
> +	while ((nr_folios = filemap_get_folios_tag(NODE_MAPPING(sbi), &index,
> +					(pgoff_t)-1, PAGECACHE_TAG_DIRTY,
> +					&fbatch))) {
>   		int i;
>   
> -		for (i = 0; i < nr_pages; i++) {
> -			struct page *page = pvec.pages[i];
> +		for (i = 0; i < nr_folios; i++) {
> +			struct page *page = &fbatch.folios[i]->page;
>   
>   			if (!IS_DNODE(page))
>   				continue;
> @@ -1924,7 +1925,7 @@ void f2fs_flush_inline_data(struct f2fs_sb_info *sbi)
>   			}
>   			unlock_page(page);
>   		}
> -		pagevec_release(&pvec);
> +		folio_batch_release(&fbatch);
>   		cond_resched();
>   	}
>   }
