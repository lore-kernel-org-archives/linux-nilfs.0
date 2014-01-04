From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2] fs/nilfs2: Integer overflow in nilfs_ioctl_wrap_copy()
Date: Sat, 4 Jan 2014 16:10:07 +0300
Message-ID: <73948D05-9012-4A6A-8C4C-46C6A11F6454@dubeyko.com>
References: <1388729454-30256-1-git-send-email-fanwlexca@gmail.com> <20140103161015.b354edd36176e4016840135b@linux-foundation.org> <20140104.180646.52171591.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=2bHU8ID44E0QGicmcZM53Rr1d0tQCm1XucG8hSh0Fis=;
	b=XL3GmYiUO/gXZJjo5IrqB60yQHKGNaAscebJ/G8CNM4I9TwCQr3yhuUyEUNNPmwcufzVB2A5nRHheJxELzhxO3cHI6kE5ceztDuJfVJyCCdqFdvBS5so8auOJn792Yxy;
In-Reply-To: <20140104.180646.52171591.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

On Jan 4, 2014, at 12:06 PM, Ryusuke Konishi wrote:

[snip]

> Sorry for the poor documentation of nilfs_argv struct and
> nilfs_ioctl_wrap_copy function.
> 

[snip]

> I modified the commit log and also added a few comment lines to
> clarify the address of the patch.  The modified patch is attached
> below.
> 

Maybe it makes sense to add comment for the function at whole too?
I suppose that description of the patch contains many useful details
about the method at whole.

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
