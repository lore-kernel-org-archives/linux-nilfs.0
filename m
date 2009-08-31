From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] nilfs2: shorten freeze period due to GC
 in write operation
Date: Mon, 31 Aug 2009 16:37:29 +0900 (JST)
Message-ID: <20090831.163729.22914775.ryusuke@osrg.net>
References: <1251536070-12052-1-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1251536070-12052-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org

Hi Sekiba-san,

On Sat, 29 Aug 2009 17:54:30 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> Hi,
> 
> This is a patch to shorten freeze period.
<snip> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 6ea5f87..2394353 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -442,12 +442,6 @@ int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
>  	const char *msg;
>  	int ret;
>  
> -	ret = nilfs_ioctl_move_blocks(nilfs, &argv[0], kbufs[0]);
> -	if (ret < 0) {
> -		msg = "cannot read source blocks";
> -		goto failed;
> -	}
> -
>  	ret = nilfs_ioctl_delete_checkpoints(nilfs, &argv[1], kbufs[1]);
>  	if (ret < 0) {
>  		/*
> @@ -521,6 +515,10 @@ static int nilfs_ioctl_clean_segmentsistruct inode5 einode, struct file *filp,
>  
>  	nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
>  
> +	if (nilfs_gc_running(nilfs))
> +		return -EBUSY;
> +	set_nilfs_gc_running(nilfs);
> +

Well, I have two comments here on this patch:

This check and the error return should be done before memory
allocation of kbufs[4] to avoid memory leak.

And, logically these bit operations must be atomic by use of
test_and_set_bit().  So, it should be like:

	if (test_and_set_bit(THE_NILFS_GC_RUNNING, &nilfs->ns_flags))
		return -EBUSY;

I think we don't have to expand THE_NILFS_FNS macro for this.

Could you revise the patch once more?

Thank you,
Ryusuke Konishi

>  	for (n = 0; n < 4; n++) {
>  		ret = -EINVAL;
>  		if (argv[n].v_size != argsz[n])
> @@ -548,12 +546,20 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
>  		}
>  	}
>  
> +	ret = nilfs_ioctl_move_blocks(nilfs, &argv[0], kbufs[0]);
> +	if (ret < 0) {
> +		printk(KERN_ERR "NILFS: GC failed during preparation: "
> +			"cannot read source blocks: err=%d\n", ret);
> +		goto out_free;
> +	}
> +
>  	ret = nilfs_clean_segments(inode->i_sb, argv, kbufs);
>  
>   out_free:
>  	while (--n >= 0)
>  		vfree(kbufs[n]);
>  	kfree(kbufs[4]);
> +	clear_nilfs_gc_running(nilfs);
>  	return ret;
>  }
>  
> diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
> index 1b9caaf..97ee569 100644
> --- a/fs/nilfs2/the_nilfs.h
> +++ b/fs/nilfs2/the_nilfs.h
> @@ -37,6 +37,7 @@ enum {
>  	THE_NILFS_LOADED,       /* Roll-back/roll-forward has done and
>  				   the latest checkpoint was loaded */
>  	THE_NILFS_DISCONTINUED,	/* 'next' pointer chain has broken */
> +	THE_NILFS_GC_RUNNING,	/* gc process is running */
>  };
>  
>  /**
> @@ -197,6 +198,7 @@ static inline int nilfs_##name(struct the_nilfs *nilfs)			\
>  THE_NILFS_FNS(INIT, init)
>  THE_NILFS_FNS(LOADED, loaded)
>  THE_NILFS_FNS(DISCONTINUED, discontinued)
> +THE_NILFS_FNS(GC_RUNNING, gc_running)
>  
>  /* Minimum interval of periodical update of superblocks (in seconds) */
>  #define NILFS_SB_FREQ		10
> -- 
> 1.5.6.5
> 
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
