From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCHv2] nilfs2: shorten freeze period due to GC
 in write operation
Date: Fri, 04 Sep 2009 14:54:13 +0900 (JST)
Message-ID: <20090904.145413.104783154.ryusuke@osrg.net>
References: <1251872990-18330-1-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1251872990-18330-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
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

Hi,
On Wed,  2 Sep 2009 15:29:50 +0900, Jiro SEKIBA wrote:
> Hi,
> 
> This is a revised patch to shorten freeze period.
> This version includes fixes of the bugs Konishi-san mentioned.
> 
> When GC is runnning, GC moves live block to difference segments.
> Copying live blocks into memory is done in a transaction,
> but it is not necessarily to be in the transaction.
> This patch will get the nilfs_ioctl_move_blocks() out from
> transaction lock and put it before the transaction.
> 
> I ran sysbench fileio test against nilfs partition.
> I copied some DVD/CD images and created snapshot to create live blocks
> before starting the benchmark.
> 
> Followings are summary of rc8 and rc8 w/ the patch of per-request statistics,
> which is min/max and avg.  I ran each test three times and bellow is
> average of those numers.
> 
> According to this benchmark result, average time is slightly degrated.
> However, worstcase (max) result is significantly improved.
> This can address a few seconds write freeze.
> 
> - random write per-request performance of rc8
>  min   0.843ms
>  max 680.406ms
>  avg   3.050ms
> - random write per-request performance of rc8 w/ this patch
>  min   0.830ms ->  98.40%
>  max 366.870ms ->  53.90%
>  avg   3.170ms -> 103.90%
> 
> - sequential write per-request performance of rc8
>  min   0.736ms
>  max 774.343ms 
>  avg   2.883ms 
> - sequential write per-request performance of rc8 w/ this patch
>  min   0.726ms -> 100.50%
>  max  695.976ms->  72.80%
>  avg   3.110ms -> 107.80%
> 
> -----8<-----8<-----nilfs_cleanerd.conf-----8<-----8<-----
> protection_period       150
> selection_policy        timestamp       # timestamp in ascend order
> nsegments_per_clean     2
> cleaning_interval       2
> retry_interval          60
> use_mmap
> log_priority            info
> -----8<-----8<-----nilfs_cleanerd.conf-----8<-----8<-----
> 
> 
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> ---
>  fs/nilfs2/ioctl.c     |   22 ++++++++++++++--------
>  fs/nilfs2/the_nilfs.h |    2 ++
>  2 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 6ea5f87..cc6ec4b 100644
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
> @@ -509,6 +503,12 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
>  	nsegs = argv[4].v_nmembs;
>  	if (argv[4].v_size != argsz[4])
>  		return -EINVAL;
> +
> +	nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
> +
> +	if (test_and_set_bit(THE_NILFS_GC_RUNNING, &nilfs->ns_flags))
> +		return -EBUSY;
> +
>  	/*
>  	 * argv[4] points to segment numbers this ioctl cleans.  We
>  	 * use kmalloc() for its buffer because memory used for the
> @@ -519,8 +519,6 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
>  	if (IS_ERR(kbufs[4]))
>  		return PTR_ERR(kbufs[4]);
>  
> -	nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
> -
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

Thank you very much for the patient effort.

I've just replaced this patch in the -for-next branch.

Thanks,
Ryusuke Konishi
