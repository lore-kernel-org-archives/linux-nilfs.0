From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 1/3] nilfs2: remove nilfs_segctor_init() in segment.c
Date: Sun, 11 Apr 2010 02:57:15 +0900 (JST)
Message-ID: <20100411.025715.33555818.ryusuke@osrg.net>
References: <20100410161543.GA9213@xhl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100410161543.GA9213@xhl>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Sun, 11 Apr 2010 00:15:43 +0800, Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi KONISHI Ryusuke,
> 
> Three new patches based on nilfs2/for-next branch. New code has been built and
> loaded successfully, and also passed a light-weight reads and writes test.
> 
> Thanks,
> Li Hong

Ok, I'll look into each of them.

> ---------------------------- cut here --------------------------
> 
> From 2c622d0f59782321204bf1fde7eea4a593cc6b65 Mon Sep 17 00:00:00 2001
> From: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Sat, 10 Apr 2010 21:57:11 +0800
> Subject: [PATCH 1/3] nilfs2: remove nilfs_segctor_init() in segment.c
> 
> There are only two lines of code in nilfs_segctor_init(). From a logic design
> view, the first line 'sci->sc_seq_done = sci->sc_seq_request;' should be put in
> nilfs_segctor_new(). Even in nilfs_segctor_new(), this initialization is
> needless because sci is kzalloc-ed. So nilfs_segctor_init() is only a wrap call
> to nilfs_segctor_start_thread(). This removes an indirect call overhead.
> 
> Signed-off-by: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Looks no problem.

The reason why nilfs_segctor_init is present in that manner is
historical (just for your information. You don't have to mention this
reason).

I think you don't have to mention the indirect call overhead because
it's only triggered in the level of mount/unmount/remount and gcc will
inline it in the caller.

Thanks,
Ryusuke Konishi

> ---
>  fs/nilfs2/segment.c |    9 +--------
>  1 files changed, 1 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index f235fc0..514620d 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2684,13 +2684,6 @@ static void nilfs_segctor_kill_thread(struct nilfs_sc_info *sci)
>  	}
>  }
>  
> -static int nilfs_segctor_init(struct nilfs_sc_info *sci)
> -{
> -	sci->sc_seq_done = sci->sc_seq_request;
> -
> -	return nilfs_segctor_start_thread(sci);
> -}
> -
>  /*
>   * Setup & clean-up functions
>   */
> @@ -2814,7 +2807,7 @@ int nilfs_attach_segment_constructor(struct nilfs_sb_info *sbi)
>  		return -ENOMEM;
>  
>  	nilfs_attach_writer(nilfs, sbi);
> -	err = nilfs_segctor_init(NILFS_SC(sbi));
> +	err = nilfs_segctor_start_thread(NILFS_SC(sbi));
>  	if (err) {
>  		nilfs_detach_writer(nilfs, sbi);
>  		kfree(sbi->s_sc_info);
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
