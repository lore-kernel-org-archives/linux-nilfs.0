From: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix use-after-free bug in nilfs_mdt_destroy()
Date: Mon, 15 Aug 2022 19:27:09 +0100
Message-ID: <YvqP/f2P2YgIIO9U@ZenIV>
References: <20220815175114.23576-1-konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pQgnV2W+m6IHyd1sfXNyPuGcZpvyoD3dq7ndy9+1QWY=; b=nOms3/1Uq5YOF1bwlhQz39B/xq
        lhJn4Xz+bgO4S+tzCDXYpLB8VrlkUqBdIrbUt95mBrUHdr683sUAqzaa2EL8z+RDmYP2StzlwdOJ2
        dlu4xtB6GtZ7UapVk2WD/TlGptwIfUv0tciWlGulljYY9+Fcpo2ICJpMpb0BJvuXzzX0zDUpw9zyU
        KyGPgpkB3lZyjCE3mM8iw+OX+wUW/BWlIlrIvAWaQoFKHxiKHBkFWxJrLM4RNSV+3QMORX/AlleaD
        vpDR4/Jp7QyIvjl5gi8PPa6yPcN0ObjLRunLjv/8GqjUnNkTYLzal4MQ7zci7VkeymEdMAPpsPy07
        le8oCyVA==;
Content-Disposition: inline
In-Reply-To: <20220815175114.23576-1-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: Al Viro <viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jiacheng Xu <stitch-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>, Mudong Liang <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue, Aug 16, 2022 at 02:51:14AM +0900, Ryusuke Konishi wrote:
> In alloc_inode(), inode_init_always() could return -ENOMEM if
> security_inode_alloc() fails.  If this happens for nilfs2,
> nilfs_free_inode() is called without initializing inode->i_private and
> nilfs_free_inode() wrongly calls nilfs_mdt_destroy(), which frees
> uninitialized inode->i_private and can trigger a crash.
> 
> Fix this bug by initializing inode->i_private in nilfs_alloc_inode().
> 
> Link: https://lkml.kernel.org/r/CAFcO6XOcf1Jj2SeGt=jJV59wmhESeSKpfR0omdFRq+J9nD1vfQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
> Link: https://lkml.kernel.org/r/20211011030956.2459172-1-mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> Reported-by: butt3rflyh4ck <butterflyhuangxx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Reported-by: Hao Sun <sunhao.th-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Reported-by: Jiacheng Xu <stitch-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>
> Reported-by: Mudong Liang <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> ---
>  fs/nilfs2/super.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index ba108f915391..aca5614f1b44 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -159,6 +159,7 @@ struct inode *nilfs_alloc_inode(struct super_block *sb)
>  	ii->i_cno = 0;
>  	ii->i_assoc_inode = NULL;
>  	ii->i_bmap = &ii->i_bmap_data;
> +	ii->vfs_inode.i_private = NULL;
>  	return &ii->vfs_inode;
>  }

FWIW, I think it's better to deal with that in inode_init_always(), but
not just moving ->i_private initialization up - we ought to move
security_inode_alloc() to the very end.  No sense playing whack-a-mole
with further possible bugs of that sort...
