From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs: avoid warning about unused variables
Date: Thu, 16 Jun 2016 07:05:32 +0900 (JST)
Message-ID: <20160616.070532.298289408681530745.konishi.ryusuke@lab.ntt.co.jp>
References: <20160615201945.3348205-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AurrZUqdjU6YV2OEp6whyqYNQwyJx6KzRgAkU0j6iJg=;
        b=O6H20ae5S2o7QcxdXzT9fu5TvRbxK43JwH6PmuWx3T6i3s+2C3yMBTIgiWZNiIkfS3
         AYbD3mIgJHge1aatzZmWy/ifNQW/D92ydoxynOXBHnWltBUmtm0D5zLKOx/ovqDQT+8y
         IwWXJmyonFmOFjDYNSUyGdiKQ1PJ1YlwWklxVLYnCI0NVhcCwUY2i7JEk2srz/goENSZ
         Ma0GZn9nszOH5aUR4cHxoSsUhb660h3AjJ3fIBMjrr2BkvF/HnuluLEgQD47dG+nmPfi
         HIk9437sR5NUvZ4QxH0n0kn/PD/FgE9zUb4j4wbwrKC2Idb+yj+S/RAIZ/S2fNgK+AF7
         jWuA==
In-Reply-To: <20160615201945.3348205-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 15 Jun 2016 22:19:41 +0200, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> The newly added nilfs_msg() infrastructure caused a warning in
> nilfs_clear_dirty_page() when it is disabled:
> 
> fs/nilfs2/page.c: In function 'nilfs_clear_dirty_page':
> fs/nilfs2/page.c:402:22: error: unused variable 'sb' [-Werror=unused-variable]
>   struct super_block *sb = inode->i_sb;
> 
> We can avoid the warning by adding a cast to void for the first
> argument of the macro.
> 
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> Fixes: aede53d223f0 ("nilfs2: replace nilfs_warning() with nilfs_msg()")

Thanks for the catch!

Regards,
Ryusuke Konishi


> ---
>  fs/nilfs2/nilfs.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
> index b7064faef217..46fbd4e00315 100644
> --- a/fs/nilfs2/nilfs.h
> +++ b/fs/nilfs2/nilfs.h
> @@ -317,7 +317,10 @@ void __nilfs_error(struct super_block *sb, const char *function,
>  #else
>  
>  #define nilfs_msg(sb, level, fmt, ...)					\
> -	no_printk(fmt, ##__VA_ARGS__)
> +	do {								\
> +		no_printk(fmt, ##__VA_ARGS__);				\
> +		(void)(sb);						\
> +	} while (0)
>  #define nilfs_error(sb, fmt, ...)					\
>  	do {								\
>  		no_printk(fmt, ##__VA_ARGS__);				\
> -- 
> 2.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
