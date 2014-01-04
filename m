From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v2] fs/nilfs2: Integer overflow in
 nilfs_ioctl_wrap_copy()
Date: Fri, 3 Jan 2014 16:10:15 -0800
Message-ID: <20140103161015.b354edd36176e4016840135b@linux-foundation.org>
References: <1388729454-30256-1-git-send-email-fanwlexca@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1388729454-30256-1-git-send-email-fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri,  3 Jan 2014 14:10:54 +0800 Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> v1->v2
> *Check on every iteration is removed because the check before cycle is enough.
> 
> Check before entering into cycle.
> 
> The local variable 'pos' comes from userspace. If a large number was
> passed, there would be an integer overflow in the following line:
>         pos += n;
> 
> Signed-off-by: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/nilfs2/ioctl.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index b44bdb2..231c945 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -57,6 +57,9 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
>  	if (argv->v_size > PAGE_SIZE)
>  		return -EINVAL;
>  
> +	if (argv->v_index > (~(__u64)0 - argv->v_nmembs))
> +		return -EINVAL;
> +
>  	buf = (void *)__get_free_pages(GFP_NOFS, 0);
>  	if (unlikely(!buf))
>  		return -ENOMEM;

Geeze, that function is really hard to understand.  The poor
documentation for nilfs_argv.v_index is hurting here.

Why doesn't this patch do

	if (argv->v_index >= argv->v_nmembs)
		return -EINVAL;

?

That's what one would *expect* to see, so something weird must be going
on?
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
