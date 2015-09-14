From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 02/39] nilfs2: drop null test before destroy functions
Date: Mon, 14 Sep 2015 12:29:06 +0900 (JST)
Message-ID: <20150914.122906.1656489070901419863.konishi.ryusuke@lab.ntt.co.jp>
References: <1442146532-9100-1-git-send-email-Julia.Lawall@lip6.fr>
	<1442146532-9100-3-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=cpD5tjOFQ9wMdmCVOLTK5i0RTPNd+uLXCxNa490ftiI=;
        b=QQvvRm0m+GXSqF58ExnNYiV5GMb0JXIwtX69VEWH6m1rqrORnz48Yr5K0SV1u3natS
         jxPtmtnTmY0EuL1vL76Kw8X/V0ci/qU1pP++NHgA86SPONnBdxoR7GNfvS3fdaKuZlpY
         swlL1rqnQOSn+U50J4yAyl/uI5GMe2NQcDa3FRQp+zwyOJ6X/qYRCX5awVmM3CCBgs57
         8toIdNXc9AQywKQTce4DtGHUhvlYuEKuyhRoUvAp8AnS3rACSrCRWOk7yZXZTRrL4ddf
         B6T4y/hXwfuHOkjjZgV1DmTzv2XXJEL2SoyVEpxxzzuvwQY7oSkUVAdfwhqJN6oGJNvJ
         INpQ==
In-Reply-To: <1442146532-9100-3-git-send-email-Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
Cc: sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 13 Sep 2015 14:14:55 +0200, Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org> wrote:
> Remove unneeded NULL test.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@ expression x; @@
> -if (x != NULL)
>   \(kmem_cache_destroy\|mempool_destroy\|dma_pool_destroy\)(x);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>

Looks OK.  I'll queue this in my tree.

Thanks,
Ryusuke Konishi

> 
> ---
>  fs/nilfs2/super.c |   12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index f47585b..c69455a 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -1405,14 +1405,10 @@ static void nilfs_destroy_cachep(void)
>  	 */
>  	rcu_barrier();
>  
> -	if (nilfs_inode_cachep)
> -		kmem_cache_destroy(nilfs_inode_cachep);
> -	if (nilfs_transaction_cachep)
> -		kmem_cache_destroy(nilfs_transaction_cachep);
> -	if (nilfs_segbuf_cachep)
> -		kmem_cache_destroy(nilfs_segbuf_cachep);
> -	if (nilfs_btree_path_cache)
> -		kmem_cache_destroy(nilfs_btree_path_cache);
> +	kmem_cache_destroy(nilfs_inode_cachep);
> +	kmem_cache_destroy(nilfs_transaction_cachep);
> +	kmem_cache_destroy(nilfs_segbuf_cachep);
> +	kmem_cache_destroy(nilfs_btree_path_cache);
>  }
>  
>  static int __init nilfs_init_cachep(void)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
