From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] fs/nilfs2: Integer overflow in nilfs_ioctl_wrap_copy()
Date: Fri, 20 Dec 2013 12:23:28 +0400
Message-ID: <1387527808.4022.6.camel@slavad-ubuntu>
References: <1387525568-30025-1-git-send-email-fanwlexca@gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=5a++QDNU0V46Amh7xZ/PImgYcYXZMii72yO4rNLFsDc=;
	b=gKIr/3QKD+Xt6N2mceKRt1sOGwra2qYyQl6pEGTVxkHUK4lRNTmT67EOoZZphcpWg6JyL2abfNMcXYIqfSO3I3KVFp1gbWK1XtrnJIFeHLVMlkfvB+S36MIUdifmfB+O;
In-Reply-To: <1387525568-30025-1-git-send-email-fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 2013-12-20 at 15:46 +0800, Wenliang Fan wrote:
> The local variable 'pos' comes from userspace. If a large number was
> passed, there would be an integer overflow in the following line:
> 	pos += n;
> 

What about check before enter into the cycle? If you are talking about
possible huge number then you can receive huge number from userspace
before entering in the cycle.

Thanks,
Vyacheslav Dubeyko.

> Signed-off-by: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/nilfs2/ioctl.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index b44bdb2..b2bac9a 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -90,8 +90,13 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
>  		total += nr;
>  		if ((size_t)nr < n)
>  			break;
> -		if (pos == ppos)
> +		if (pos == ppos) {
> +			if (pos > ULONG_MAX - n) {
> +				ret = -EINVAL;
> +				break;
> +			}
>  			pos += n;
> +		}
>  	}
>  	argv->v_nmembs = total;
>  


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
