From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] FS: nilfs2: potential integer overflow in
 nilfs_ioctl_clean_segments()
Date: Fri, 02 Dec 2011 00:33:12 +0900 (JST)
Message-ID: <20111202.003312.179955221.ryusuke@osrg.net>
References: <1322708399-26919-1-git-send-email-haogangchen@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1322708399-26919-1-git-send-email-haogangchen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: haogangchen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 30 Nov 2011 21:59:59 -0500, Haogang Chen wrote:
> There is a potential integer overflow in nilfs_ioctl_clean_segments().
> When a large argv[n].v_nmembs is passed from the userspace, the
> subsequent call to vmalloc() will allocate a buffer smaller than
> expected, which leads to out-of-bound access in
> nilfs_ioctl_move_blocks() and lfs_clean_segments().
> 
> The following check does not prevent the overflow because nsegs is also
> controlled by the userspace and could be very large.
> 
> 		if (argv[n].v_nmembs > nsegs * nilfs->ns_blocks_per_segment)
> 			goto out_free;
> 
> This patch clamps argv[n].v_nmembs to UINT_MAX / argv[n].v_size, and
> returns -EINVAL when overflow.
> 
> Signed-off-by: Haogang Chen <haogangchen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Ahh, that makes sense.

I will apply your patch.

Thanks,
Ryusuke Konishi

> ---
>  fs/nilfs2/ioctl.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 41d6743..b805df9 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -625,6 +625,9 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
>  		if (argv[n].v_nmembs > nsegs * nilfs->ns_blocks_per_segment)
>  			goto out_free;
>  
> +		if (argv[n].v_nmembs >= UINT_MAX / argv[n].v_size)
> +			goto out_free;
> +
>  		len = argv[n].v_size * argv[n].v_nmembs;
>  		base = (void __user *)(unsigned long)argv[n].v_base;
>  		if (len == 0) {
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
