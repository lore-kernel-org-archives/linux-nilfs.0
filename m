From: Jens Axboe <jaxboe-5c4llco8/ftWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix oops due to a bad aops initialization
Date: Wed, 30 Mar 2011 13:07:46 +0200
Message-ID: <4D930F02.4070409@fusionio.com>
References: <20110330.132555.158630340.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110330.132555.158630340.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2011-03-30 06:25, Ryusuke Konishi wrote:
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index 4d2a1ee..9d2dc6b 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -495,12 +495,14 @@ unsigned nilfs_page_count_clean_buffers(struct page *page,
>  void nilfs_mapping_init(struct address_space *mapping,
>  			struct backing_dev_info *bdi)
>  {
> +	static const struct address_space_operations empty_aops;
> +
>  	mapping->host = NULL;
>  	mapping->flags = 0;
>  	mapping_set_gfp_mask(mapping, GFP_NOFS);
>  	mapping->assoc_mapping = NULL;
>  	mapping->backing_dev_info = bdi;
> -	mapping->a_ops = NULL;
> +	mapping->a_ops = &empty_aops;
>  }

Hmm wait, inode init should set the mapping aops to an empty type
already. Does the OOPS go away if you just remove the mapping->a_ops =
NULL assignment?

-- 
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
