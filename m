From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] Remove inode_congested()
Date: Mon, 13 Dec 2021 04:22:38 +0000
Message-ID: <YbbKjjFzIzSBJWCn@casper.infradead.org>
References: <163936868317.23860.5037433897004720387.stgit@noble.brown>
 <163936886725.23860.2403757518009677424.stgit@noble.brown>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5VRRrXTMpMMR1uAghzgqAdj8BzkVpuZ2ziBLrA4cdV4=; b=hHj5tkQLGXVF896zpGXpvorbmT
        ZeNp5ygUrTrFdisSuEOLwfYTwId2s25Z+kFrAh3Bfx1sO+hUFUfSrBRebvk3bJTxx9sEBCxskN2+Y
        YDQqZ7RRTWE9uCsWeke+790cXmml4bZs/a0LTmVF3/gQrc8iamJ0JXAvd98bK97f9gl8c8ZUKOqV+
        UuUJxhBXa+r49x8eQpZAO5lumYIZqPGJui1b5Qo3Pbckxw/n4pKhbBDn8wLbe4UqP7zzgV48mCpul
        0RFjFslQkUFDt8dh8faKufMuXOMHQdVNgmhtRzXG2YUbE8ntdKOakzvG6/E8tW4zczFlIyKVbaG5o
        ZrimuKjw==;
Content-Disposition: inline
In-Reply-To: <163936886725.23860.2403757518009677424.stgit-KMjKAoDPBoBHWa5fdsenEw@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Dec 13, 2021 at 03:14:27PM +1100, NeilBrown wrote:
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index fb9584641ac7..540aa0ea67ff 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -989,17 +989,6 @@ static inline int is_page_cache_freeable(struct page *page)
>  	return page_count(page) - page_has_private(page) == 1 + page_cache_pins;
>  }
>  
> -static int may_write_to_inode(struct inode *inode)
> -{
> -	if (current->flags & PF_SWAPWRITE)
> -		return 1;
> -	if (!inode_write_congested(inode))
> -		return 1;
> -	if (inode_to_bdi(inode) == current->backing_dev_info)
> -		return 1;
> -	return 0;
> -}

Why is it safe to get rid of the PF_SWAPWRITE and current->backing_dev_info
checks?

> @@ -1158,8 +1147,6 @@ static pageout_t pageout(struct page *page, struct address_space *mapping)
>  	}
>  	if (mapping->a_ops->writepage == NULL)
>  		return PAGE_ACTIVATE;
> -	if (!may_write_to_inode(mapping->host))
> -		return PAGE_KEEP;
>  
>  	if (clear_page_dirty_for_io(page)) {
>  		int res;
