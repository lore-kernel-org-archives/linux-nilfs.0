From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: suggest to use dump_stack() in nilfs_error()
 and nilfs_warning()
Date: Mon, 30 Jun 2014 04:01:59 +0900 (JST)
Message-ID: <20140630.040159.120185966358440318.konishi.ryusuke@lab.ntt.co.jp>
References: <1404050621.4139.19.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=DPJoRFVzil3NygfljFrGj6H6OvCtRFIe3FDTQeIffFw=;
        b=VlEg2iZr7/PVpaQrobrrfDBsc+3ylrRWM79Ksf+5EQ5kWyZwSFYqLKa26Om3YcZXWc
         A9iXfHRsyu6i2rS0HKaYisFovg7phkOlBojZowEs7IaLdnul+6PRYg081FC7HL+SJPZl
         1+cEFG4VBHKGA2uqRwO9/3Wt9ZsPP04vTat3FSQehtSMYLIgGo57fqb8UlZm3s1/vcb3
         rV0iELjH3qb+NbaPazLxpGy0pFziSBbrclXGuOcPudUeqhHW5JRdd4CDT0J7/SDYzrIJ
         a8J4ZjTHXdTup5xfeWWp3w5CCRTH0wikLpy7GjY/IiolxpTsjGLIHIx8J5h8gdJzpREm
         gJxQ==
In-Reply-To: <1404050621.4139.19.camel@slavad-CELSIUS-H720>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On Sun, 29 Jun 2014 18:03:41 +0400, Vyacheslav Dubeyko wrote:
> From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
> Subject: [PATCH] nilfs2: suggest to use dump_stack() in nilfs_error() and nilfs_warning()
> 
> This patch suggests to use dump_stack() call in nilfs_error() and
> nilfs_warning() for more clear understanding of different type of
> issues. As a result, end-users can report more informative
> descriptions of issues.
> 
> Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
> CC: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

NAK.

This patch makes error/warning routine of nilfs so verbose.

dump_stack() should be used for some critical situations or internal
inconsisent situtations, or for cases in which the identifying call
path of trouble is not easy.

I think it's not used for regular errors or warnings because they are
mostly identifiable.

In addition, "errors=panic" mount option is available for nilfs_error
to force stack dump.

Regards,
Ryusuke Konishi

> ---
>  fs/nilfs2/inode.c |    1 -
>  fs/nilfs2/super.c |    5 ++++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index 6252b17..745e96d 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -970,7 +970,6 @@ void nilfs_dirty_inode(struct inode *inode, int flags)
>  	if (is_bad_inode(inode)) {
>  		nilfs_warning(inode->i_sb, __func__,
>  			      "tried to mark bad_inode dirty. ignored.\n");
> -		dump_stack();
>  		return;
>  	}
>  	if (mdi) {
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 8c532b2..c6cd607 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -123,6 +123,8 @@ void nilfs_error(struct super_block *sb, const char *function,
>  
>  	va_end(args);
>  
> +	dump_stack();
> +
>  	if (!(sb->s_flags & MS_RDONLY)) {
>  		nilfs_set_error(sb);
>  
> @@ -152,8 +154,9 @@ void nilfs_warning(struct super_block *sb, const char *function,
>  	       sb->s_id, function, &vaf);
>  
>  	va_end(args);
> -}
>  
> +	dump_stack();
> +}
>  
>  struct inode *nilfs_alloc_inode(struct super_block *sb)
>  {
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
