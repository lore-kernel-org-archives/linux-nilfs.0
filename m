From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: Remove an uninitialization warning in
 nilfs_btree_propagate_v()
Date: Fri, 02 Apr 2010 20:09:24 +0900 (JST)
Message-ID: <20100402.200924.67912456.ryusuke@osrg.net>
References: <20100402104039.GA9652@xhl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100402104039.GA9652@xhl>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 2 Apr 2010 18:40:39 +0800, Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> `make CONFIG_NILFS2_FS=m M=fs/nilfs2/` will give the following warnings:
> 
> fs/nilfs2/btree.c: In function ‘nilfs_btree_propagate’:
> fs/nilfs2/btree.c:1882: warning: ‘maxlevel’ may be used uninitialized in this function
> fs/nilfs2/btree.c:1882: note: ‘maxlevel’ was declared here
> 
> Set maxlevel = 0 to fix it.
> 
> Signed-off-by: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied, thanks.

Ryusuke Konishi

> ---
>  fs/nilfs2/btree.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> index 7cdd98b..76c38e3 100644
> --- a/fs/nilfs2/btree.c
> +++ b/fs/nilfs2/btree.c
> @@ -1879,7 +1879,7 @@ static int nilfs_btree_propagate_v(struct nilfs_btree *btree,
>  				   struct nilfs_btree_path *path,
>  				   int level, struct buffer_head *bh)
>  {
> -	int maxlevel, ret;
> +	int maxlevel = 0, ret;
>  	struct nilfs_btree_node *parent;
>  	struct inode *dat = nilfs_bmap_get_dat(&btree->bt_bmap);
>  	__u64 ptr;
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
