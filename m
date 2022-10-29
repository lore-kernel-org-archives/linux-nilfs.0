From: Chao Yu <chao@kernel.org>
Subject: Re: [f2fs-dev] [PATCH v3 11/23] f2fs: Convert f2fs_fsync_node_pages()
 to use filemap_get_folios_tag()
Date: Sat, 29 Oct 2022 12:46:19 +0800
Message-ID: <cee7fa24-5699-9777-d157-f03a8dd18a00@kernel.org>
References: <20221017202451.4951-1-vishal.moola@gmail.com>
 <20221017202451.4951-12-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <ceph-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667018781;
        bh=80lU3QpeiitIVawK91PHV+p4z43WIDD4Rouks6i2Gj8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=uStOgrQ+MB0RzqQUR2IfSfKEroJt+tBJ1eUXiuGJdVpHPU65B4Wndy12I7NwulNEH
         QLUNGsb9gPkhyPjLpOHxZest61y+4N8W4qWlHOMrKXoINg0FcDDDOjXxHaefByx+f/
         8kBWsq7LLWaUOqILmEqMSRc+s3mc9FckVC7dRltlA3gueYJyLaWQeeWS7ZpJzaVFRR
         3jqmb9wVl/FmxMezeNEb5Mt6NqqRQIo9nqBur1wO2lEpw78o6TPaG3b+pYYYWCgZiM
         1KYPHhw1mZSVn8629ziSH0yjYWEjxqX/XkcIejJBjvO5Ogm4Ov/+SG8x91NwiUvL6B
         J+nrTC2V/HxDA==
Content-Language: en-US
In-Reply-To: <20221017202451.4951-12-vishal.moola@gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On 2022/10/18 4:24, Vishal Moola (Oracle) wrote:
> Convert function to use a folio_batch instead of pagevec. This is in
> preparation for the removal of find_get_pages_range_tag().
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

Acked-by: Chao Yu <chao@kernel.org>

Thanks,

> ---
>   fs/f2fs/node.c | 19 ++++++++++---------
>   1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 983572f23896..e8b72336c096 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1728,12 +1728,12 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
>   			unsigned int *seq_id)
>   {
>   	pgoff_t index;
> -	struct pagevec pvec;
> +	struct folio_batch fbatch;
>   	int ret = 0;
>   	struct page *last_page = NULL;
>   	bool marked = false;
>   	nid_t ino = inode->i_ino;
> -	int nr_pages;
> +	int nr_folios;
>   	int nwritten = 0;
>   
>   	if (atomic) {
> @@ -1742,20 +1742,21 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
>   			return PTR_ERR_OR_ZERO(last_page);
>   	}
>   retry:
> -	pagevec_init(&pvec);
> +	folio_batch_init(&fbatch);
>   	index = 0;
>   
> -	while ((nr_pages = pagevec_lookup_tag(&pvec, NODE_MAPPING(sbi), &index,
> -				PAGECACHE_TAG_DIRTY))) {
> +	while ((nr_folios = filemap_get_folios_tag(NODE_MAPPING(sbi), &index,
> +					(pgoff_t)-1, PAGECACHE_TAG_DIRTY,
> +					&fbatch))) {
>   		int i;
>   
> -		for (i = 0; i < nr_pages; i++) {
> -			struct page *page = pvec.pages[i];
> +		for (i = 0; i < nr_folios; i++) {
> +			struct page *page = &fbatch.folios[i]->page;
>   			bool submitted = false;
>   
>   			if (unlikely(f2fs_cp_error(sbi))) {
>   				f2fs_put_page(last_page, 0);
> -				pagevec_release(&pvec);
> +				folio_batch_release(&fbatch);
>   				ret = -EIO;
>   				goto out;
>   			}
> @@ -1821,7 +1822,7 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
>   				break;
>   			}
>   		}
> -		pagevec_release(&pvec);
> +		folio_batch_release(&fbatch);
>   		cond_resched();
>   
>   		if (ret || marked)
