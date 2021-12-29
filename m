From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] nilfs2: use default_groups in kobj_type
Date: Wed, 29 Dec 2021 09:34:10 +0100
Message-ID: <YcwdgkuScucp7ELG@kroah.com>
References: <20211228144252.390554-1-gregkh@linuxfoundation.org>
 <CAKFNMona12jPJMGveSHgVDks_EYd_ZAJ_gDRLZo=exyFD3Y8+g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640766857;
        bh=3YYTIhgtu9x2zEKV9hLL4n5kqGn91yi/zx7hbmucWnY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b9fhPAsFNDjc2j+nMQEzEvora6eV8/CASo2FFxz4GjgIDiU8aVbdZkjQwqt7N3VHp
         AJyN/fqklP4LJ6Xb7mZYD01xObrP2lJ6EI5kv3u4371C/ZyP3p2E0iqpshcPxfaP5j
         s0HRmkB1Ay3I6C5Jpbn2LFLuPUEYBF2wVh4AjA3Q=
Content-Disposition: inline
In-Reply-To: <CAKFNMona12jPJMGveSHgVDks_EYd_ZAJ_gDRLZo=exyFD3Y8+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Dec 29, 2021 at 01:52:15AM +0900, Ryusuke Konishi wrote:
> On Tue, Dec 28, 2021 at 11:42 PM Greg Kroah-Hartman
> <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> >
> > There are currently 2 ways to create a set of sysfs files for a
> > kobj_type, through the default_attrs field, and the default_groups
> > field.  Move the nilfs2 code to use default_groups field which has been
> > the preferred way since aa30f47cf666 ("kobject: Add support for default
> > attribute groups to kobj_type") so that we can soon get rid of the
> > obsolete default_attrs field.
> >
> > Cc: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> 
> Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Looks good to me.
> Please take it through your tree for your convenience, thanks.

Will do, thanks!

greg k-h
