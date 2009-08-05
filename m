From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] nilfs2: tune write performance
Date: Thu, 06 Aug 2009 03:54:05 +0900 (JST)
Message-ID: <20090806.035405.08300632.ryusuke@osrg.net>
References: <1249483023-21088-1-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1249483023-21088-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
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

Hi!
On Wed,  5 Aug 2009 23:37:03 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> Hi,
> 
> This is a candidate patch to improve write performance.
> 
> When GC is runnning, GC moves live block to difference segments.
> Moving live blocks to different segment is done in a transaction,
> but it is not necessarily to be in the transaction.
> This patch will get the nilfs_ioctl_move_blocks() out from
> transaction lock and put it before the transaction.
> 
> Here are the bonnie++ bench mark results against rc5.
> I used sata disk so performace difference is not big.
> So I modified nilfs_cleanerd.conf to ensure lock will be long enough.
> 
> I ran "bonnie++ -b" three times in each environment.
> Create clean nilfs2 partition each time before test run.
> 
> Results
> - write performance of rc5
>  * Char|17472.333 K/sec
>  * Block|30748.000 K/sec
>  * Rewrite|18506.000 K/sec
> 
> - write performance of the patched rc5
>  * Char|17961.000 K/sec -> 102.700%
>  * Block|30987.666 K/sec -> 100.700%
>  * Rewrite|18775.666 K/sec -> 101.400%

Thank you for the patch.

I think this patch can mitigate freeze-time of writes due to GC, but
this benchmark seems not to be suited for measuring the effect.
Particularly, GC fires only once per five seconds with the following
config, and this may limit the efficacy in this kind of integrative
test.

Is it possible to compare single write time hit GC with the time not
hit GC ?

I will check correctness of the patch.

Thanks,
Ryusuke Konishi

> Here are the nilfs_cleanerd.conf and raw data.
> -------8<---------8<---------nilfs_cleanerd.conf---------8<---------8<-------
> protection_period    150
> selection_policy    timestamp    # timestamp in ascend order
> nsegments_per_clean    10
> cleaning_interval    5
> retry_interval        60
> use_mmap
> log_priority        info
> -------8<---------8<---------nilfs_cleanerd.conf---------8<---------8<-------
> ---------8<---------8<---------rc5---------8<---------8<---------
> Version 1.03d       ------Sequential Output------ --Sequential Input- --Random-
>                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
> foras           10G 17404  22 30751   5 18519   3 33855  38 45560   4  47.3   0
>                     ------Sequential Create------ --------Random Create--------
>                     -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
>               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
>                  16   103   1 +++++ +++   255   0   251   4 +++++ +++   223   1
> foras,10G,17404,22,30751,5,18519,3,33855,38,45560,4,47.3,0,16,103,1,+++++,+++,255,0,251,4,+++++,+++,223,1
> Version 1.03d       ------Sequential Output------ --Sequential Input- --Random-
>                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
> foras           10G 17561  22 30781   5 18412   3 33973  38 46063   3  46.6   0
>                     ------Sequential Create------ --------Random Create--------
>                     -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
>               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
>                  16   102   1 +++++ +++   237   0   244   3 +++++ +++   222   1
> foras,10G,17561,22,30781,5,18412,3,33973,38,46063,3,46.6,0,16,102,1,+++++,+++,237,0,244,3,+++++,+++,222,1
> Version 1.03d       ------Sequential Output------ --Sequential Input- --Random-
>                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
> foras           10G 17452  22 30712   5 18587   3 34071  38 45479   4  50.6   0
>                     ------Sequential Create------ --------Random Create--------
>                     -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
>               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
>                  16   102   1 +++++ +++   238   0   252   4 +++++ +++   222   1
> foras,10G,17452,22,30712,5,18587,3,34071,38,45479,4,50.6,0,16,102,1,+++++,+++,238,0,252,4,+++++,+++,222,1
> ---------8<---------8<---------rc5---------8<---------8<---------
> ---------8<---------8<---------patch---------8<---------8<---------
> Version 1.03d       ------Sequential Output------ --Sequential Input- --Random-
>                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
> foras           10G 18004  22 31375   5 19110   3 33755  38 45224   4  97.1   0
>                     ------Sequential Create------ --------Random Create--------
>                     -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
>               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
>                  16    99   1 +++++ +++   223   0   231   3 +++++ +++   209   1
> foras,10G,18004,22,31375,5,19110,3,33755,38,45224,4,97.1,0,16,99,1,+++++,+++,223,0,231,3,+++++,+++,209,1
> Version 1.03d       ------Sequential Output------ --Sequential Input- --Random-
>                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
> foras           10G 17866  22 30673   5 18619   3 33923  38 45878   4  55.3   0
>                     ------Sequential Create------ --------Random Create--------
>                     -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
>               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
>                  16    97   1 +++++ +++   211   0   224   3 +++++ +++   203   1
> foras,10G,17866,22,30673,5,18619,3,33923,38,45878,4,55.3,0,16,97,1,+++++,+++,211,0,224,3,+++++,+++,203,1
> Version 1.03d       ------Sequential Output------ --Sequential Input- --Random-
>                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
> foras           10G 18013  22 30915   5 18598   3 33879  38 44957   4  47.5   0
>                     ------Sequential Create------ --------Random Create--------
>                     -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
>               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
>                  16    99   1 +++++ +++   255   0   253   4 +++++ +++   226   1
> foras,10G,18013,22,30915,5,18598,3,33879,38,44957,4,47.5,0,16,99,1,+++++,+++,255,0,253,4,+++++,+++,226,1
> ---------8<---------8<---------patch---------8<---------8<---------
> 
>  fs/nilfs2/ioctl.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> ---
>  fs/nilfs2/ioctl.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 6ea5f87..83a885c 100644
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
> @@ -548,6 +542,12 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
>  		}
>  	}
>  
> +	ret = nilfs_ioctl_move_blocks(nilfs, &argv[0], kbufs[0]);
> +	if (ret < 0) {
> +		printk(KERN_ERR "NILFS: GC failed during preparation: cannot read source blocks: err=%d\n", ret);
> +		goto out_free;
> +	}
> +
>  	ret = nilfs_clean_segments(inode->i_sb, argv, kbufs);
>  
>   out_free:
> -- 
> 1.5.6.5
