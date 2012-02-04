From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: avoid overflowing segment numbers in
 nilfs_ioctl_clean_segments()
Date: Sat, 04 Feb 2012 12:13:02 +0900 (JST)
Message-ID: <20120204.121302.227986518.ryusuke@osrg.net>
References: <1328282767-13158-1-git-send-email-xi.wang@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328282767-13158-1-git-send-email-xi.wang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: xi.wang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, haogangchen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Fri,  3 Feb 2012 10:26:07 -0500, Xi Wang wrote:
> nsegs is read from userspace.  Limit its value and avoid overflowing
> nsegs * sizeof(__u64) in the subsequent call to memdup_user().
> 
> This patch complements 481fe17e973fb97aa3edf17c69557afe88d8334f.
> 
> Signed-off-by: Xi Wang <xi.wang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Haogang Chen <haogangchen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> ---
>  fs/nilfs2/ioctl.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

Acked-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>


Thank you for posting this fix.

Andrew, could you send this uptream in this cycle ?

Ryusuke Konishi

> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 8866496..2a70fce 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -603,6 +603,8 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
>  	nsegs = argv[4].v_nmembs;
>  	if (argv[4].v_size != argsz[4])
>  		goto out;
> +	if (nsegs > UINT_MAX / sizeof(__u64))
> +		goto out;
>  
>  	/*
>  	 * argv[4] points to segment numbers this ioctl cleans.  We
> -- 
> 1.7.5.4
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
