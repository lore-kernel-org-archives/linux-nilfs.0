From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 1/1] nilfs2: remove unnecessary call to
 nilfs_construct_dsync_segment()
Date: Tue, 04 Nov 2014 23:34:58 +0900 (JST)
Message-ID: <20141104.233458.804333886341114381.konishi.ryusuke@lab.ntt.co.jp>
References: <1414861267-13103-1-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=7VZ0oGUPx+/eONkjywAxb8VNtYJRQiUQoF1UdrT7a6Y=;
        b=BdUxcl14y8gMQvdIqvPU2Gv/VCGExxIt4zh4wSVuxTfS713LR/S7AJK6DUInwTGUX6
         Hh4IKfCkKDivnBXRMMgeSfhCV9fgaXJkg8sM+6FikMwD/fz+84NRUIpceCbxtu5t0+wT
         6DgS58k3WNL8R6h07C+w/U+BqVvfx7/6t8rQ3MFcU4CUhJUxFQoAxAQseKE2VZOcZ8Kz
         3fnLMrmtJjkCKOZftDaspzdHLWRn/UFK3wYv9Zp68xcvr/0SEWWI09yRGso70JzaXVt1
         AGMYCkFajN4bhLGXcNoZ+szr4mjD8OtQbmCd/EbDV0Fol/WYXvAmJjmIUsV0jnaE8NEu
         vWKw==
In-Reply-To: <1414861267-13103-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Andreas,
On Sat,  1 Nov 2014 18:01:07 +0100, Andreas Rohner wrote:
> If some of the pages between start and end are dirty, then
> filemap_write_and_wait_range() calls nilfs_writepages() with WB_SYNC_ALL
> set in the writeback_control structure. This initiates the construction
> of a dsync segment via nilfs_construct_dsync_segment(). The problem is,
> that the construction of a dsync segment doesnt't remove the inode from
> die i_dirty list and doesn't clear the NILFS_I_DIRTY flag. So
> nilfs_inode_dirty() still returns true after
> nilfs_construct_dsync_segment() succeded. This leads to an
> unnecessary second call to nilfs_construct_dsync_segment() in
> nilfs_sync_file() if datasync is true.
> 
> This patch simply removes the second invokation of
> nilfs_construct_dsync_segment().
> 
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Thank you for posting this patch.

This optimization looks to become possible by the commit 02c24a821
"fs: push i_mutex and filemap_write_and_wait down into ->fsync()
handlers".  I haven't noticed that the change makes it possible to
simplify nilfs_sync_file() like this.

One my simple question is why you removed the call to
nilfs_construct_dsync_segment() instead of
filemap_write_and_wait_range().

If the datasync flag is false, nilfs_sync_file() first calls
nilfs_construct_dsync_segment() via

   filemap_write_and_wait_range()
     __filemap_fdatawrite_range(,, WB_SYNC_ALL)
       do_writepages()
          nilfs_writepages()
             nilfs_construct_dsync_segment()

and then calls nilfs_construct_segment().

Since each call to nilfs_construct_segment() or
nilfs_construct_dsync_segment() implies an IO completion wait, it
seems that this doubles the latency of fsync().

Do you really need to call filemap_write_and_wait_range() in
nilfs_sync_file() ?

Regards,
Ryusuke Konishi


> ---
>  fs/nilfs2/file.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
> index e9e3325..b12e0ab 100644
> --- a/fs/nilfs2/file.c
> +++ b/fs/nilfs2/file.c
> @@ -46,13 +46,9 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  		return err;
>  	mutex_lock(&inode->i_mutex);
>  
> -	if (nilfs_inode_dirty(inode)) {
> -		if (datasync)
> -			err = nilfs_construct_dsync_segment(inode->i_sb, inode,
> -							    0, LLONG_MAX);
> -		else
> -			err = nilfs_construct_segment(inode->i_sb);
> -	}
> +	if (!datasync && nilfs_inode_dirty(inode))
> +		err = nilfs_construct_segment(inode->i_sb);
> +
>  	mutex_unlock(&inode->i_mutex);
>  
>  	nilfs = inode->i_sb->s_fs_info;
> -- 
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
