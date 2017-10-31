From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: remove inode->i_version initialization
Date: Tue, 31 Oct 2017 13:22:42 +0900 (JST)
Message-ID: <20171031.132242.2076528451559597103.konishi.ryusuke@lab.ntt.co.jp>
References: <20171030151702.8368-1-jlayton@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iHFzWiK3UQyAYJcMqwtIZlc+tU9X+lzfx6zQBQ4wu34=;
        b=YY9CkrixNSjXmhg2DE/gjEwq5+FUqLXPlZ2DfoVajRUHodVI05B2HHHnyrtQdx/hZU
         TwXHespzLMNXx/lcmVFQPzJI/VQGwp9N+d9VD9zi9iXpJhS60n0+CdFGbAq2RJXoZTqw
         p/4UCdJeaiDyJNLgP8LYiRHsBSq1qLHr39g79KIKbWSnTJofTAf00n/57tyIFxIvnL+f
         5J3qno2erQ7bf/zGWB9dQDc6c0hbnKIhzAbqZXHfjivkuT9LNzB06lGjO1UPHzDSzTtx
         VN6oRuJ7YmWv3QWQJiId38OzasIgf2+3armuyMqvohXUoZhbv+cW1+9xLaqFQde9UaIi
         g8Gw==
In-Reply-To: <20171030151702.8368-1-jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 30 Oct 2017 11:17:02 -0400, Jeff Layton wrote:
> From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> It's never used in nilfs2.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---

Applied, thank you.

Ryusuke Konishi

>  fs/nilfs2/super.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 4fc018dfcfae..3ce20cd44a20 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -160,7 +160,6 @@ struct inode *nilfs_alloc_inode(struct super_block *sb)
>  	ii->i_bh = NULL;
>  	ii->i_state = 0;
>  	ii->i_cno = 0;
> -	ii->vfs_inode.i_version = 1;
>  	nilfs_mapping_init(&ii->i_btnode_cache, &ii->vfs_inode);
>  	return &ii->vfs_inode;
>  }
> -- 
> 2.13.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
