From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] fs/nilfs2: Integer overflow in nilfs_ioctl_wrap_copy()
Date: Tue, 31 Dec 2013 10:45:04 +0400
Message-ID: <1388472304.3946.2.camel@slavad-ubuntu>
References: <1388411681-16584-1-git-send-email-fanwlexca@gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=kwcHpqkvvZ8VyfrZZbFqClJezRgqEJBiDsKdBioPR4Q=;
	b=DmyYF/g8XRfy4KfCC8wtx7LshR0db6nizpIO809Y3/+iJX/78+DUpRoXr0DD9ndO+6aOjFI7zbBSzYijCJgix8ti+IuALBtE6/1Jyh9cUIwzLDAlWYqDq28yo7RjV7ro;
In-Reply-To: <1388411681-16584-1-git-send-email-fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 2013-12-30 at 21:54 +0800, Wenliang Fan wrote:
> Check before entering into cycle and on every iteration.
> 
> The local variable 'pos' comes from userspace. If a large number was
> passed, there would be an integer overflow in the following line:
>         pos += n;
> 

Do you fix it by chance? Or do you implement something in NILFS2?

> Signed-off-by: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---

Reviewed-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
