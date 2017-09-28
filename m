From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH 09/15] nilfs2: Use pagevec_lookup_range_tag()
Date: Thu, 28 Sep 2017 10:40:50 +0900
Message-ID: <8960b327-5541-40ec-9966-ca4e43e8e9a0@lab.ntt.co.jp>
References: <20170927160334.29513-1-jack@suse.cz>
 <20170927160334.29513-10-jack@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170927160334.29513-10-jack@suse.cz>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-nilfs@vger.kernel.org


On 2017/09/28 1:03, Jan Kara wrote:
> We want only pages from given range in
> nilfs_lookup_dirty_data_buffers(). Use pagevec_lookup_range_tag()
> instead of pagevec_lookup_tag() and remove unnecessary code.
> 
> CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> CC: linux-nilfs@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>   fs/nilfs2/segment.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)

Nice patch. Thanks.

Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

> 
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 70ded52dc1dd..68e5769cef3b 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -711,18 +711,14 @@ static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
>   	pagevec_init(&pvec, 0);
>    repeat:
>   	if (unlikely(index > last) ||
> -	    !pagevec_lookup_tag(&pvec, mapping, &index, PAGECACHE_TAG_DIRTY,
> -				min_t(pgoff_t, last - index,
> -				      PAGEVEC_SIZE - 1) + 1))
> +	    !pagevec_lookup_range_tag(&pvec, mapping, &index, last,
> +				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE))
>   		return ndirties;
>   
>   	for (i = 0; i < pagevec_count(&pvec); i++) {
>   		struct buffer_head *bh, *head;
>   		struct page *page = pvec.pages[i];
>   
> -		if (unlikely(page->index > last))
> -			break;
> -
>   		lock_page(page);
>   		if (!page_has_buffers(page))
>   			create_empty_buffers(page, i_blocksize(inode), 0);
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
