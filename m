From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] nilfs2: add reader's lock for cno in nilfs_ioctl_sync
Date: Sat, 20 Feb 2010 21:29:33 +0900 (JST)
Message-ID: <20100220.212933.52196046.ryusuke@osrg.net>
References: <87hbpc2nfu.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87hbpc2nfu.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Sat, 20 Feb 2010 19:47:49 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> Hi,
> 
> This adds reader's lock for the_nilfs->cno in nilfs_ioctl_sync, 
> for the_nilfs->cno should be proctected by segctor_sem when reading.
> 
> Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> ---
>  fs/nilfs2/ioctl.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index d6b2b83..32d5103 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -575,13 +575,17 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
>  {
>  	__u64 cno;
>  	int ret;
> +	struct the_nilfs *nilfs;
>  
>  	ret = nilfs_construct_segment(inode->i_sb);
>  	if (ret < 0)
>  		return ret;
>  
>  	if (argp != NULL) {
> -		cno = NILFS_SB(inode->i_sb)->s_nilfs->ns_cno - 1;
> +		nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
> +		down_read(&nilfs->ns_segctor_sem);
> +		cno = nilfs->ns_cno - 1;
> +		up_read(&nilfs->ns_segctor_sem);
>  		if (copy_to_user(argp, &cno, sizeof(cno)))
>  			return -EFAULT;
>  	}
> -- 
> 1.5.6.5

Right, this should be applied.

Thanks.

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
