From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 3/3] nilfs2: change sc_timer from a pointer to an
 embedded one in struct nilfs_sc_info
Date: Sun, 11 Apr 2010 18:47:53 +0900 (JST)
Message-ID: <20100411.184753.57461532.ryusuke@osrg.net>
References: <20100411.114022.199103512.ryusuke@osrg.net>
	<20100411042931.GC10086@xhl>
	<20100411090815.GC11189@xhl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100411090815.GC11189@xhl>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 11 Apr 2010 17:08:15 +0800, Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From 031b50dd4bc3c94687c8e587672aff2ffeefee9b Mon Sep 17 00:00:00 2001
> From: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Sat, 10 Apr 2010 23:25:39 +0800
> Subject: [PATCH] nilfs2: change sc_timer from a pointer to an embedded one in struct nilfs_sc_info
> 
> In nilfs_segctor_thread(), timer is a local variable allocated on stack. Its
> address can't be set to sci->sc_timer and passed in several procedures.
> 
> It works now by chance, just because other procedures are called by
> nilfs_segctor_thread() directly or indirectly and the stack hasn't been
> deallocated yet.
> 
> Signed-off-by: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied, thanks you.

Ryusuke Konishi

> ---
>  fs/nilfs2/segment.c |   31 +++++++++++++------------------
>  fs/nilfs2/segment.h |    2 +-
>  2 files changed, 14 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 514620d..b523112 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2158,9 +2158,9 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
>  static void nilfs_segctor_start_timer(struct nilfs_sc_info *sci)
>  {
>  	spin_lock(&sci->sc_state_lock);
> -	if (sci->sc_timer && !(sci->sc_state & NILFS_SEGCTOR_COMMIT)) {
> -		sci->sc_timer->expires = jiffies + sci->sc_interval;
> -		add_timer(sci->sc_timer);
> +	if (!(sci->sc_state & NILFS_SEGCTOR_COMMIT)) {
> +		sci->sc_timer.expires = jiffies + sci->sc_interval;
> +		add_timer(&sci->sc_timer);
>  		sci->sc_state |= NILFS_SEGCTOR_COMMIT;
>  	}
>  	spin_unlock(&sci->sc_state_lock);
> @@ -2365,9 +2365,7 @@ static void nilfs_segctor_accept(struct nilfs_sc_info *sci)
>  	spin_lock(&sci->sc_state_lock);
>  	sci->sc_seq_accepted = sci->sc_seq_request;
>  	spin_unlock(&sci->sc_state_lock);
> -
> -	if (sci->sc_timer)
> -		del_timer_sync(sci->sc_timer);
> +	del_timer_sync(&sci->sc_timer);
>  }
>  
>  /**
> @@ -2393,9 +2391,9 @@ static void nilfs_segctor_notify(struct nilfs_sc_info *sci, int mode, int err)
>  			sci->sc_flush_request &= ~FLUSH_DAT_BIT;
>  
>  		/* re-enable timer if checkpoint creation was not done */
> -		if (sci->sc_timer && (sci->sc_state & NILFS_SEGCTOR_COMMIT) &&
> -		    time_before(jiffies, sci->sc_timer->expires))
> -			add_timer(sci->sc_timer);
> +		if ((sci->sc_state & NILFS_SEGCTOR_COMMIT) &&
> +		    time_before(jiffies, sci->sc_timer.expires))
> +			add_timer(&sci->sc_timer);
>  	}
>  	spin_unlock(&sci->sc_state_lock);
>  }
> @@ -2574,13 +2572,10 @@ static int nilfs_segctor_thread(void *arg)
>  {
>  	struct nilfs_sc_info *sci = (struct nilfs_sc_info *)arg;
>  	struct the_nilfs *nilfs = sci->sc_sbi->s_nilfs;
> -	struct timer_list timer;
>  	int timeout = 0;
>  
> -	init_timer(&timer);
> -	timer.data = (unsigned long)current;
> -	timer.function = nilfs_construction_timeout;
> -	sci->sc_timer = &timer;
> +	sci->sc_timer.data = (unsigned long)current;
> +	sci->sc_timer.function = nilfs_construction_timeout;
>  
>  	/* start sync. */
>  	sci->sc_task = current;
> @@ -2629,7 +2624,7 @@ static int nilfs_segctor_thread(void *arg)
>  			should_sleep = 0;
>  		else if (sci->sc_state & NILFS_SEGCTOR_COMMIT)
>  			should_sleep = time_before(jiffies,
> -						   sci->sc_timer->expires);
> +					sci->sc_timer.expires);
>  
>  		if (should_sleep) {
>  			spin_unlock(&sci->sc_state_lock);
> @@ -2638,7 +2633,7 @@ static int nilfs_segctor_thread(void *arg)
>  		}
>  		finish_wait(&sci->sc_wait_daemon, &wait);
>  		timeout = ((sci->sc_state & NILFS_SEGCTOR_COMMIT) &&
> -			   time_after_eq(jiffies, sci->sc_timer->expires));
> +			   time_after_eq(jiffies, sci->sc_timer.expires));
>  
>  		if (nilfs_sb_dirty(nilfs) && nilfs_sb_need_update(nilfs))
>  			set_nilfs_discontinued(nilfs);
> @@ -2647,8 +2642,6 @@ static int nilfs_segctor_thread(void *arg)
>  
>   end_thread:
>  	spin_unlock(&sci->sc_state_lock);
> -	del_timer_sync(sci->sc_timer);
> -	sci->sc_timer = NULL;
>  
>  	/* end sync. */
>  	sci->sc_task = NULL;
> @@ -2707,6 +2700,7 @@ static struct nilfs_sc_info *nilfs_segctor_new(struct nilfs_sb_info *sbi)
>  	INIT_LIST_HEAD(&sci->sc_write_logs);
>  	INIT_LIST_HEAD(&sci->sc_gc_inodes);
>  	INIT_LIST_HEAD(&sci->sc_copied_buffers);
> +	init_timer(&sci->sc_timer);
>  
>  	sci->sc_interval = HZ * NILFS_SC_DEFAULT_TIMEOUT;
>  	sci->sc_mjcp_freq = HZ * NILFS_SC_DEFAULT_SR_FREQ;
> @@ -2773,6 +2767,7 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
>  
>  	down_write(&sbi->s_nilfs->ns_segctor_sem);
>  
> +	del_timer_sync(&sci->sc_timer);
>  	kfree(sci);
>  }
>  
> diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
> index 7aca765..dca1423 100644
> --- a/fs/nilfs2/segment.h
> +++ b/fs/nilfs2/segment.h
> @@ -177,7 +177,7 @@ struct nilfs_sc_info {
>  	unsigned long		sc_lseg_stime;	/* in 1/HZ seconds */
>  	unsigned long		sc_watermark;
>  
> -	struct timer_list      *sc_timer;
> +	struct timer_list	sc_timer;
>  	struct task_struct     *sc_task;
>  };
>  
> -- 
> 1.6.3.3
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
