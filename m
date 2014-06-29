From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix issue with potential infinite loop in
 nilfs_mdt_get_block()
Date: Mon, 30 Jun 2014 03:33:45 +0900 (JST)
Message-ID: <20140630.033345.651115405791674896.konishi.ryusuke@lab.ntt.co.jp>
References: <1404049010.4139.17.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=t+PhuV8ryhHWWD23Pq5TOwKsGpu2LPbYbzJcDuydQ/4=;
        b=aq6ihtl9SpheJll3VcfLXTMas6GaYWdtWZGzolgwRXBVplUqqlhMBuH+q7B3JaIIZ7
         tGnn9tSRU4rnpd1HwccgzdvlOs8bLiWDBURAIVwWjajfdRzlRLrzwUrBMTfrM3bFuG9N
         DduT4GDaLmt7FwftnABGku00AFVhpG6FJ2y94cIzXZ4+F3lizlTXIIRLFmLokHw6ycBl
         obio46+1sV2LriyvbueYfAHcHXm/OeBnvFYnSOwgEbEvAYPGfg3XoaJIf+GVtg7g2lca
         yxNdZ753H9uFFV5SOKH03zNumjG3M18nXejTvD8XqhuKTd3EjIymiciTtqoiLimNOY/5
         szjg==
In-Reply-To: <1404049010.4139.17.camel@slavad-CELSIUS-H720>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Sun, 29 Jun 2014 17:36:50 +0400, Vyacheslav Dubeyko wrote:
> From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
> Subject: [PATCH] nilfs2: fix issue with potential infinite loop in nilfs_mdt_get_block()
> 
> Potentially, there are situations when nilfs_mdt_read_block() can
> return -ENOENT and nilfs_mdt_create_block() can return -EEXIST.

Did you actually see this situation happened ?

nilfs_mdt_read_block() returns -ENOENT only if nilfs_grab_buffer()
didn't find a buffer head on page cache and nilfs_bmap_lookup() hit
a hole block.

nilfs_mdt_create_block() returns -EEXIST only if nilfs_grab_buffer()
got a buffer head in uptodate state or nilfs_bmap_insert() failed due
to an existing block.

So, these usually don't happen at the same time.  What situation
do you suppose ?

This function is so primitive to easily change even though the retry
loop looks an interim implementation of an early date.  I would
understand what is going on and whole impact of the change.

> Such situation results in infinite loop inside nilfs_mdt_get_block()
> method. This patch fixes issue with potential infinite loop in
> nilfs_mdt_get_block() by means of uncomment limitation of read-create
> loop retries.

If this patch is applied, nilfs_mdt_get_block() can return -ENOENT
even for the case of create == true.  This is unexpected for caller
functions.  I think we should return proper error code which fits to
the exceptional situation that causes an infinite repetition (if it
actually happens).

Regards,
Ryusuke Konishi


> Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
> CC: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> ---
>  fs/nilfs2/mdt.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
> index c4dcd1d..d1e121f 100644
> --- a/fs/nilfs2/mdt.c
> +++ b/fs/nilfs2/mdt.c
> @@ -254,7 +254,7 @@ int nilfs_mdt_get_block(struct inode *inode, unsigned long blkoff, int create,
>  
>  	ret = nilfs_mdt_create_block(inode, blkoff, out_bh, init_block);
>  	if (unlikely(ret == -EEXIST)) {
> -		/* create = 0; */  /* limit read-create loop retries */
> +		create = 0;  /* limit read-create loop retries */
>  		goto retry;
>  	}
>  	return ret;
> -- 
> 1.7.9.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
