From: Ryusuke Konishi <konishi.ryusukelab.ntt.co.jp-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix a wrong type conversion in nilfs_ioctl()
Date: Wed, 31 Mar 2010 16:58:35 +0900 (JST)
Message-ID: <20100331.165835.212698315.ryusuke@osrg.net>
References: <20100331074100.GA11787@xhl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100331074100.GA11787@xhl>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 31 Mar 2010 15:41:00 +0800, Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> (void * __user *) should be (void __user *)
> 
> Signed-off-by: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied.  Thank you.

Ryusuke Konishi

> ---
>  fs/nilfs2/ioctl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 313d0a2..c446017 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -648,7 +648,7 @@ static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
>  long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  {
>  	struct inode *inode = filp->f_dentry->d_inode;
> -	void __user *argp = (void * __user *)arg;
> +	void __user *argp = (void __user *)arg;
>  
>  	switch (cmd) {
>  	case NILFS_IOCTL_CHANGE_CPMODE:
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
