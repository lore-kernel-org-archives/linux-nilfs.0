From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: use default_groups in kobj_type
Date: Wed, 29 Dec 2021 01:52:15 +0900
Message-ID: <CAKFNMona12jPJMGveSHgVDks_EYd_ZAJ_gDRLZo=exyFD3Y8+g@mail.gmail.com>
References: <20211228144252.390554-1-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FIkiA0FD+7sqxfQ1GH6hzg05sbLrtvkdUl+v4CjNfos=;
        b=Oe20vn56LEkOO+MoKZbIQaUDYsK5R3BybpMDkx9mREZRbol6Iv/L8REHWWMUwPOZqZ
         Mmud9EbmIloELT+CxnKdVpNj7ZOZlDi2Myt0PHAtgOCUxP4Ps5TELmvdA+xB/uWHOaVO
         uEPX/hezMo3lt6WmW/l6HIdOk49LErvF5ayg8LL62ec6ayN2qaOc5tj/1bMc7XTSeQvs
         xCAdfjNRx7LJHjLGMnevqxH+I90V3DcjoS0hla4QnX3zXAZSFvrM6O9OBZlt9K7GFs+t
         m5aXRohUPFrwFksC+JpuGmZZYYo2VHpDYPvAbm3uZUIPpgtWNdFSHhVhe0viqwTmIFuQ
         Ipbw==
In-Reply-To: <20211228144252.390554-1-gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Dec 28, 2021 at 11:42 PM Greg Kroah-Hartman
<gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
>
> There are currently 2 ways to create a set of sysfs files for a
> kobj_type, through the default_attrs field, and the default_groups
> field.  Move the nilfs2 code to use default_groups field which has been
> the preferred way since aa30f47cf666 ("kobject: Add support for default
> attribute groups to kobj_type") so that we can soon get rid of the
> obsolete default_attrs field.
>
> Cc: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Looks good to me.
Please take it through your tree for your convenience, thanks.

Ryusuke Konishi
