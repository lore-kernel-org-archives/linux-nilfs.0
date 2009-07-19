From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 3/3] nilfs2: stop using periodic
 write_super callback
Date: Sun, 19 Jul 2009 20:48:17 +0900 (JST)
Message-ID: <20090719.204817.108427156.ryusuke@osrg.net>
References: <1247981182-14831-1-git-send-email-jir@unicus.jp>
	<1247981182-14831-4-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1247981182-14831-4-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
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

On Sun, 19 Jul 2009 14:26:22 +0900, Jiro SEKIBA wrote:
> This patch makes commiting super block in nilfs internal thread,
> instead of periodic write_super callback.
> 
> VFS layer calls ->write_super callback periodically.  However,
> it looks like that calling back is ommited when disk I/O is busy.
> And when cleanerd (nilfs GC) is runnig, disk I/O tend to be busy thus
> nilfs superblock is not synchronized as nilfs designed.
> 
> To avoid it, syncing superblock by nilfs thread instead of pdflush.
> 
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Thanks.

If you replaced nilfs_write_super() in nilfs_sync_super(), you can get
rid of nilfs_write_super() in this patch including the comments and
prototype declaration for it.

Here are a few additional comments on that condition.

> ---
>  fs/nilfs2/segment.c |   12 +++++++++++-
>  fs/nilfs2/super.c   |    2 +-
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 8b5e477..46f7a49 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2486,8 +2486,10 @@ static int nilfs_segctor_construct(struct nilfs_sc_info *sci,
>  			atomic_set(&nilfs->ns_ndirtyblks, 0);
>  		if (test_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags) &&
>  		    nilfs_discontinued(nilfs)) {
> +			u64 t = get_seconds();
>  			down_write(&nilfs->ns_sem);
> -			req->sb_err = nilfs_commit_super(sbi, 0);
> +			req->sb_err = nilfs_commit_super(sbi,
> +					nilfs_altsb_need_update(nilfs, t));
>  			up_write(&nilfs->ns_sem);

You can hide get_seconds() inside nilfs_sb_need_update() and
nilfs_altsb_need_update() especially if you will get rid of
nilfs_write_super().

>  		}
>  	}
> @@ -2675,6 +2677,9 @@ static int nilfs_segctor_thread(void *arg)
>  	} else {
>  		DEFINE_WAIT(wait);
>  		int should_sleep = 1;
> +		u64 t;
> +		struct nilfs_sb_info *sbi;
> +		struct the_nilfs *nilfs;
>  
>  		prepare_to_wait(&sci->sc_wait_daemon, &wait,
>  				TASK_INTERRUPTIBLE);
> @@ -2695,6 +2700,11 @@ static int nilfs_segctor_thread(void *arg)
>  		finish_wait(&sci->sc_wait_daemon, &wait);
>  		timeout = ((sci->sc_state & NILFS_SEGCTOR_COMMIT) &&
>  			   time_after_eq(jiffies, sci->sc_timer->expires));
> +		t = get_seconds();
> +		sbi = sci->sc_sbi;
> +		nilfs = sbi->s_nilfs;
> +		if (sci->sc_super->s_dirt && nilfs_sb_need_update(nilfs, t))
> +			set_nilfs_discontinued(nilfs);

ditto.

And the sbi local variable seems omissible.

>  	}
>  	goto loop;
>  
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index d85b360..a8c5875 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -534,7 +534,7 @@ static struct super_operations nilfs_sops = {
>  	/* .drop_inode	  = nilfs_drop_inode, */
>  	.delete_inode   = nilfs_delete_inode,
>  	.put_super      = nilfs_put_super,
> -	.write_super    = nilfs_write_super,
> +	/* .write_super    = nilfs_write_super, */
>  	.sync_fs        = nilfs_sync_fs,
>  	/* .write_super_lockfs */
>  	/* .unlockfs */
> -- 
> 1.5.6.5
> 

Thanks,
Ryusuke Konishi
