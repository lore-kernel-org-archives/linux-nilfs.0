From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/2] fs/nilfs2: Integer overflow in
 nilfs_ioctl_wrap_copy()
Date: Mon, 30 Dec 2013 13:29:00 +0400
Message-ID: <1388395740.3988.34.camel@slavad-ubuntu>
References: <1388388554-9513-1-git-send-email-fanwlexca@gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=doER9IheAQV/ieAQGybiS2Z1Q6JUCdyypLSdAYyeEV8=;
	b=PppK9To0JLnKw+eM1TbUqlqj95GJaT/bjyRKzqSny3AIH6lsgyuqwoytRnDVDkyUd1wJE+Vm5kayp+PJJAaYmVH1SiWh1UbG66RM/LE1omj/BnKebVFDAlKiW29xg205;
In-Reply-To: <1388388554-9513-1-git-send-email-fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 2013-12-30 at 15:29 +0800, Wenliang Fan wrote:
> Check before entering into cycle.
> 
> The local variable 'pos' comes from userspace. If a large number was
> passed, there would be an integer overflow in the following line:
>         pos += n;
> 
> Signed-off-by: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/nilfs2/ioctl.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index b44bdb2..a260a98 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -65,6 +65,8 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
>  	ret = 0;
>  	total = 0;
>  	pos = argv->v_index;
> +	if (pos > ULONG_MAX - argv->v_nmembs)

I'd prefer to use brackets during condition checking. But it is only my
preferences.

> +		return -EINVAL;

I think that you have an issue in this code. It is called
__get_free_pages before your code (please, see
http://lxr.free-electrons.com/source/fs/nilfs2/ioctl.c#L60). But you
simply returns -EINVAL without free_pages() call. So, I think that it is
memory leak.

Thanks,
Vyacheslav Dubeyko.

>  	for (i = 0; i < argv->v_nmembs; i += n) {
>  		n = (argv->v_nmembs - i < maxmembs) ?
>  			argv->v_nmembs - i : maxmembs;


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
