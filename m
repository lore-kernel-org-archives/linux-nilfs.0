From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [patch] nilfs2: nilfs_iget_for_gc() returns ERR_PTR
Date: Tue, 23 Nov 2010 16:22:21 +0900 (JST)
Message-ID: <20101123.162221.51131187.ryusuke@osrg.net>
References: <20101123062602.GG1522@bicker>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101123062602.GG1522@bicker>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 23 Nov 2010 09:26:02 +0300, Dan Carpenter wrote:
> nilfs_iget_for_gc() returns an ERR_PTR() on failure and doesn't return
> NULL.
> 
> Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 3e90f86..5bf426f 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -349,8 +349,8 @@ static int nilfs_ioctl_move_blocks(struct super_block *sb,
>  		ino = vdesc->vd_ino;
>  		cno = vdesc->vd_cno;
>  		inode = nilfs_iget_for_gc(sb, ino, cno);
> -		if (unlikely(inode == NULL)) {
> -			ret = -ENOMEM;
> +		if (unlikely(IS_ERR(inode))) {
> +			ret = PTR_ERR(inode);
>  			goto failed;
>  		}
>  		do {

Good catch!

This looks an -rc1 regression brought about by replacement of the gc
iget function.

I will send this fix upstream.  Thank you.

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
