From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] fs/nilfs2: Integer overflow in nilfs_ioctl_wrap_copy()
Date: Mon, 30 Dec 2013 10:40:07 +0400
Message-ID: <1388385607.3988.14.camel@slavad-ubuntu>
References: <1388197696-4648-1-git-send-email-fanwlexca@gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=0QMrxAxYxYwW6I7D3qbdmprTXD46XC9G3ZQYCV9y9sk=;
	b=UX78mHFLAdvi8BCDwQ4O2hsCPsO7SZHQRfqWN6q0XV6Nd/3eGaeAij7K0C5Br3yCvnPqGwAmJQQh8V3c2ib4iwhS2/RkiZERYODArMlONbCDjeAzvfCKnOsbIsEoXq6U;
In-Reply-To: <1388197696-4648-1-git-send-email-fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Sat, 2013-12-28 at 10:28 +0800, Wenliang Fan wrote:
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
> +		return -EINVAL;

I am slightly confused. Does this patch means that you refused previous
one? Or this patch is addition to the previous one?

You need to prepare next version of the patch or to prepare patch set
from two patches. And it makes sense to provide changelog of your work,
I think.

Thanks,
Vyacheslav Dubeyko.

>  	for (i = 0; i < argv->v_nmembs; i += n) {
>  		n = (argv->v_nmembs - i < maxmembs) ?
>  			argv->v_nmembs - i : maxmembs;


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
