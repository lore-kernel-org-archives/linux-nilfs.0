From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] nilfs2: use i_blocksize()
Date: Mon, 23 Jan 2017 10:28:56 +0900 (JST)
Message-ID: <20170123.102856.1031133549844815930.konishi.ryusuke@lab.ntt.co.jp>
References: <ebd4d1fb0aada6ed0bb1d2de21230c3b1fb148a9.1484896146.git.geliangtang@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OgCwEUstFX8EXYeqeZbF3acQ1IaxOo4q0LqBpjDdrPE=;
        b=LDpCEofFja+1pFgNuHsv3CFXHaiz6Vlmgk5Q8lLsrFQcLQQWgPELOEYwc6d9NSYHoi
         4gm9X+utICSfhlr51qwxzkITqJtnjeIZaCFgwhbV89OEnwievtiviop3JUtjIn+TDsr7
         ncqsTqPZhaU84BxqXIHG8wf+2Q5QjKZYnHl9n3IduZj0wVgQwwPLAgKyL+rXqBhocpC0
         IOW/YI8h2WAixGR9+jMrejI8szBdb1KzkAA0220GpiXwXH3402rwRj/ihN0NzHI7SA41
         pAhF3ApG8WkRT1LR/RmkEloNfPPKUSmhImS/bKe5PXVZ9qwwdu/XKhoBTKL2/7LW9MF9
         J2GA==
In-Reply-To: <ebd4d1fb0aada6ed0bb1d2de21230c3b1fb148a9.1484896146.git.geliangtang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Geliang Tang <geliangtang@gmail.com>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 20 Jan 2017 22:34:57 +0800, Geliang Tang wrote:
> Since i_blocksize() helper has been defined in fs.h, use it instead
> of open-coding.
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

i_blocksize() doesn't exist in the mainline kernel.

This needs another patch titled "fs: add i_blocksize()" which I found
in the latest -mm tree.

I will send this to the -mm tree along with this dependency.

Regards,
Ryusuke Konishi

> ---
>  fs/nilfs2/alloc.c | 2 +-
>  fs/nilfs2/btree.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
> index 2c90e28..03b8ba9 100644
> --- a/fs/nilfs2/alloc.c
> +++ b/fs/nilfs2/alloc.c
> @@ -34,7 +34,7 @@
>  static inline unsigned long
>  nilfs_palloc_groups_per_desc_block(const struct inode *inode)
>  {
> -	return (1UL << inode->i_blkbits) /
> +	return i_blocksize(inode) /
>  		sizeof(struct nilfs_palloc_group_desc);
>  }
>  
> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> index 2e315f9..d75238a 100644
> --- a/fs/nilfs2/btree.c
> +++ b/fs/nilfs2/btree.c
> @@ -119,7 +119,7 @@ nilfs_btree_node_set_nchildren(struct nilfs_btree_node *node, int nchildren)
>  
>  static int nilfs_btree_node_size(const struct nilfs_bmap *btree)
>  {
> -	return 1 << btree->b_inode->i_blkbits;
> +	return i_blocksize(btree->b_inode);
>  }
>  
>  static int nilfs_btree_nchildren_per_block(const struct nilfs_bmap *btree)
> -- 
> 2.9.3
> 
