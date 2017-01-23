From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 2/2] nilfs2: use nilfs_btree_node_size()
Date: Mon, 23 Jan 2017 09:27:03 +0900 (JST)
Message-ID: <20170123.092703.673012155145743636.konishi.ryusuke@lab.ntt.co.jp>
References: <ebd4d1fb0aada6ed0bb1d2de21230c3b1fb148a9.1484896146.git.geliangtang@gmail.com>
        <ebd4d1fb0aada6ed0bb1d2de21230c3b1fb148a9.1484896146.git.geliangtang@gmail.com>
        <9739473c1af067900c2e54990fd06b7ef2e99d0f.1484896146.git.geliangtang@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jxnhngOtCBRJiWnp3XwoZeHn1/g6or07M3e8hu04lzc=;
        b=Hv8KQP7/ct5d9tJo4aOfqIKsXxYd1KmUVaAwHY1fB7lK3uhuFP2XU+//07nmD2O4vx
         xwSDBwSuQQQC1hzM+EvOJ981zpTDFiWsZtShUwS3fa+a/NBpoSpExTp19di5P1oy36cv
         IYxO6zD//FDIr/htHDyhJfyB3oAUtvS4PUWvU38HYonxLMLlweEJHXnFT1GFL7qBfhCz
         ooWfasHSLZxZ/AAnP8oXuy+ODFBPViSyBRBMpEVPSZG8nNXp4Gq6YKXALm4xwqhAs48l
         fHDtbmUBDcyv4ktN0+pgDGb2kwyb8Xul6lgWLTAUFYdOen62Ml4O9AXUP3fukq2aQXUS
         sVqw==
In-Reply-To: <9739473c1af067900c2e54990fd06b7ef2e99d0f.1484896146.git.geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 20 Jan 2017 22:34:58 +0800, Geliang Tang wrote:
> Use nilfs_btree_node_size() instead of open-coding.
> 
> Signed-off-by: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied, thanks.

Ryusuke Konishi

> ---
>  fs/nilfs2/btree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> index d75238a..06ffa13 100644
> --- a/fs/nilfs2/btree.c
> +++ b/fs/nilfs2/btree.c
> @@ -1870,7 +1870,7 @@ int nilfs_btree_convert_and_insert(struct nilfs_bmap *btree,
>  		di = &dreq;
>  		ni = NULL;
>  	} else if ((n + 1) <= NILFS_BTREE_NODE_NCHILDREN_MAX(
> -			   1 << btree->b_inode->i_blkbits)) {
> +			   nilfs_btree_node_size(btree))) {
>  		di = &dreq;
>  		ni = &nreq;
>  	} else {
> -- 
> 2.9.3
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
