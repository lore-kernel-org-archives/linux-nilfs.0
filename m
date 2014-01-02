From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] fs/nilfs2: Integer overflow in nilfs_ioctl_wrap_copy()
Date: Fri, 03 Jan 2014 04:28:00 +0900 (JST)
Message-ID: <20140103.042800.403465349.konishi.ryusuke@lab.ntt.co.jp>
References: <1388411681-16584-1-git-send-email-fanwlexca@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1388411681-16584-1-git-send-email-fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Wenliang,
On Mon, 30 Dec 2013 21:54:41 +0800, Wenliang Fan wrote:
> Check before entering into cycle and on every iteration.
> 
> The local variable 'pos' comes from userspace. If a large number was
> passed, there would be an integer overflow in the following line:
>         pos += n;
> 
> Signed-off-by: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/nilfs2/ioctl.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index b44bdb2..5f4be69 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -57,6 +57,9 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
>  	if (argv->v_size > PAGE_SIZE)
>  		return -EINVAL;
>  
> +	if (argv->v_index > ULONG_MAX - argv->v_nmembs)
> +		return -EINVAL;
> +

I think ~(__u64)0 should be used instead of ULONG_MAX because
argv->v_index and the variable pos are supposed to have 64-bit width
(that is __u64 for the current definition).  The value of ULONG_MAX is
architecture dependent.


>  	buf = (void *)__get_free_pages(GFP_NOFS, 0);
>  	if (unlikely(!buf))
>  		return -ENOMEM;
> @@ -90,8 +93,13 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
>  		total += nr;
>  		if ((size_t)nr < n)
>  			break;
> -		if (pos == ppos)
> +		if (pos == ppos) {
> +			if (pos > ULONG_MAX - n) {
> +				ret = -EINVAL;
> +				break;
> +			}

This check looks unnecessary because pos never becomes larger than
argv->v_index + argv->v_nmembs in the case that pos wasn't changed
from ppos, and therefore the first check is enough.


Regards,
Ryusuke Konishi


>  			pos += n;
> +		}
>  	}
>  	argv->v_nmembs = total;
>  
> -- 
> 1.8.5.rc1.28.g7061504
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
