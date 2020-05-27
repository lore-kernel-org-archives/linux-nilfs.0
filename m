From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2] nilfs2: Fix reference count leak in nilfs_sysfs_create_device_group
Date: Thu, 28 May 2020 08:35:26 +0900
Message-ID: <CAKFNMon0KcoFXYOAPBGx0NbzvUTKMWmxkVQW8v9GM6=JMMNgwg@mail.gmail.com>
References: <20200527230442.24228-1-wu000273@umn.edu> <CAKFNMokewQQnx9VyK1TpZx+o11UTmNoVsZ-eqFrRzXnYdP-NYg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dhTO9C8pVsj5TXfFI7QbAfV6zOBGig3hgoqL4o5bXcs=;
        b=go7Cs1dHLxR4N4XqyAWX6emqwg31qx15uRNGZVlKcGEvDRK052lh0wY43jrs3goNSo
         QrjvemEO6QXFkuTjEZxqX5sjAFyaSLr5cXMR4ILZ3mTthCVUUokL67hisHns4gmSM+YP
         mFJ2qqQotfd80u13YmM6O2Di4K/ax68+z6P2vx5Nx7O0ceQhbbSqO92VHIbofHGtEo8b
         tJFYtTDu25u4B9X6AF6T3JorprSPpkMlrXCTcBky9E8RYCT+nR7ifd0kVPfx+kqqXHez
         6kFLVEPzjhcUVhqVZW1dDekms5YS/8cup48fWyEfPtPbTuW/IKwloq+uq/URXOzl/zsM
         bGzw==
In-Reply-To: <CAKFNMokewQQnx9VyK1TpZx+o11UTmNoVsZ-eqFrRzXnYdP-NYg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, wu000273-OJFnDUYgAso@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kjlu-OJFnDUYgAso@public.gmane.org, Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>

Hi Andrew,

This v2 patch was not CC'ed to you.   Could you please
pick it up from LKML?

Regards,
Ryusuke Konishi

On Thu, May 28, 2020 at 8:23 AM Ryusuke Konishi
<konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Hi Andrew,
>
> Please pick this up as well.
>
> Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> On Thu, May 28, 2020 at 8:04 AM <wu000273-OJFnDUYgAso@public.gmane.org> wrote:
> >
> > From: Qiushi Wu <wu000273-OJFnDUYgAso@public.gmane.org>
> >
> > kobject_init_and_add() takes reference even when it fails.
> > In nilfs_sysfs_create_device_group(), the memory allocated by
> > kobject_init_and_add() is not freed when kobject_init_and_add()
> > fails. Fix this issue by calling kobject_put() to clean up the
> > kobject.
> >
> > Fixes: da7141fb78db ("nilfs2: add /sys/fs/nilfs2/<device> group")
> > Signed-off-by: Qiushi Wu <wu000273-OJFnDUYgAso@public.gmane.org>
> > ---
> >  V2: using kobject_put() to handle kobject_init_and_add() instead of
> >  kobject_del().
> >
> >  fs/nilfs2/sysfs.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
> > index e60be7bb55b0..8416f915d118 100644
> > --- a/fs/nilfs2/sysfs.c
> > +++ b/fs/nilfs2/sysfs.c
> > @@ -999,8 +999,10 @@ int nilfs_sysfs_create_device_group(struct super_block *sb)
> >         init_completion(&nilfs->ns_dev_kobj_unregister);
> >         err = kobject_init_and_add(&nilfs->ns_dev_kobj, &nilfs_dev_ktype, NULL,
> >                                     "%s", sb->s_id);
> > -       if (err)
> > +       if (err) {
> > +               kobject_put(&nilfs->ns_dev_kobj);
> >                 goto free_dev_subgroups;
> > +       }
> >
> >         err = nilfs_sysfs_create_mounted_snapshots_group(nilfs);
> >         if (err)
> > --
> > 2.17.1
> >
