From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH] nilfs2: fix potential use after free
Date: Mon, 03 Dec 2018 18:10:51 +0900 (JST)
Message-ID: <20181203.181051.1348099310050315226.konishi.ryusuke@lab.ntt.co.jp>
References: <1543201709-53191-1-git-send-email-bianpan2016@163.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ET+v1lzht47p7Ea8q9aJOOOusSYukUsS1WfvO9DhXZ8=;
        b=CUfExPYxnTrJ8sESNBEWQbpwMuSGPFuEp9UNLK39UC6BJv8islcBUmKcrrQXHz2q7L
         2RrWE7nwhhW0zu7S7+JsOPtPyHXRe4x//JEb9QtUQRuF9KOgaF/bF7jpMRv1yKzJbNy1
         kl1eBnVZDPrOCXRHNcMros+ZpOAcd3kEdbiUzHBNAwW/pzrWjCr+oPB1HHi2Q2qPNYtg
         4jAa0fBixgqIvfL1avwuUb7qw2ZZIHDApX3b8EOEQVD23AHVJ+WMeB0m8P9QErrOOTHw
         Dd3w0tXVp5oY+0PAx1lTFJR+vvwLLBYDmSBSRgtGOJgLwh/+cn48j7/H5ThxfvqqasSZ
         lz5A==
In-Reply-To: <1543201709-53191-1-git-send-email-bianpan2016@163.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Pan Bian <bianpan2016@163.com>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org

Hi, Pan Bian

Thank you for feeding back this patch.
I reviewed this and am thinking this must be sent to upstream.

Did you see any kernel oops on this bug ?

Regards,
Ryusuke Konishi

On Mon, 26 Nov 2018 11:08:29 +0800, Pan Bian <bianpan2016@163.com> wrote:
> brelse(bh) is called to drop the reference count of bh when the call
> to nilfs_dat_translate fails. If the reference count hits 0, bh may be
> freed. However, bh->b_page is unlocked and put after that, which may
> result in a use-after-free bug. This patch moves the release operation
> after unlocking and putting the page.
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  fs/nilfs2/gcinode.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
> index aa3c328..a24bb29 100644
> --- a/fs/nilfs2/gcinode.c
> +++ b/fs/nilfs2/gcinode.c
> @@ -73,10 +73,8 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
>  		struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
>  
>  		err = nilfs_dat_translate(nilfs->ns_dat, vbn, &pbn);
> -		if (unlikely(err)) { /* -EIO, -ENOMEM, -ENOENT */
> -			brelse(bh);
> +		if (unlikely(err)) /* -EIO, -ENOMEM, -ENOENT */
>  			goto failed;
> -		}
>  	}
>  
>  	lock_buffer(bh);
> @@ -102,6 +100,8 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
>   failed:
>  	unlock_page(bh->b_page);
>  	put_page(bh->b_page);
> +	if (unlikely(err))
> +		brelse(bh);
>  	return err;
>  }
>  
> -- 
> 2.7.4
> 
> 
