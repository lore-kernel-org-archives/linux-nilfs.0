From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] fs: nilfs2: fix memory leak in nilfs_sysfs_create_device_group
Date: Fri, 21 Jan 2022 02:54:21 +0900
Message-ID: <CAKFNMo=orkfaAmgPEHvWQmb83PG4nURgv+eaS0BX5_iDbG5pDw@mail.gmail.com>
References: <20220120134415.57147-1-dzm91@hust.edu.cn> <0bc923d8-6565-69a3-c234-3789707efeb9@gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FbH6zkOi7dKvv5s46NOnhTsCXPGrtE83ptL2g2IOIGI=;
        b=kbpj99JhO2MgCD6lGdp2Pv4hZmrjw0Z+W9PYEVYv2RGTMOPUOuoHbe+9j+8OOZWRL2
         /srULlCME1O0jRBwACgDYcTc00Utp0V7tUzGYMquajQUpchIlY/+FOHgxQ+4Hby1yk6J
         toWL3RN7+AGdfnOr7Fem89VZdkM4LOk9h7jfYlrfA4ML5IRBJo+6yQcjw6a5kVZ8jhi9
         BJBe0g75AmvBnSoSZR7/InbTb/j7uvyBKDixSbyr3VmXTmpnMZSxYxe/FTKDO9HtSsV3
         ghDDCubGPKMDkhefuQ0dRVZpen6PQRNAOyk9eIMl8FKOXduXdruZ2UzDotmtYRKlYTBL
         xRYQ==
In-Reply-To: <0bc923d8-6565-69a3-c234-3789707efeb9-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dongliang Mu <dzm91-6lmH0oBJgSDM1kAEIRd3EQ@public.gmane.org>
Cc: Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

(added Nanyong Sun to CC)
Hi Dongliang,

On Thu, Jan 20, 2022 at 11:07 PM Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Hi Dongliang,
>
> On 1/20/22 16:44, Dongliang Mu wrote:
> > The preivous commit 8fd0c1b0647a ("nilfs2: fix memory leak in
> > nilfs_sysfs_delete_device_group") only handles the memory leak in the
> > nilfs_sysfs_delete_device_group. However, the similar memory leak still
> > occurs in the nilfs_sysfs_create_device_group.
> >
> > Fix it by adding kobject_del when
> > kobject_init_and_add succeeds, but one of the following calls fails.
> >
> > Fixes: 8fd0c1b0647a ("nilfs2: fix memory leak in nilfs_sysfs_delete_device_group")
>
> Why Fixes tag points to my commit? This issue was introduced before my patch
>

As Pavel pointed out, this patch is independent of his patch.
The following one ?

 5f5dec07aca7 ("nilfs2: fix memory leak in nilfs_sysfs_create_device_group")

> > Signed-off-by: Dongliang Mu <dzm91-6lmH0oBJgSDM1kAEIRd3EQ@public.gmane.org>
> > ---
> >   fs/nilfs2/sysfs.c | 5 ++++-
> >   1 file changed, 4 insertions(+), 1 deletion(-)

Can you describe what memory leak issue does this patch actually fix ?

It looks like kobject_put() can call __kobject_del() unless circular
references exist.

  kobject_put() -> kref_put() -> kobject_release() ->
kobject_cleanup() -> __kobject_del()

As explained in Documentation/core-api/kobject.rst,

  kobject_del() can be used to drop the reference to the parent object, if
  circular references are constructed.

But, at least, the parent object is NULL in this case.
I really want to understand what the real problem is.

Thanks,
Ryusuke Konishi

> >
> > diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
> > index 379d22e28ed6..0b2db2b499d5 100644
> > --- a/fs/nilfs2/sysfs.c
> > +++ b/fs/nilfs2/sysfs.c
> > @@ -995,7 +995,7 @@ int nilfs_sysfs_create_device_group(struct super_block *sb)
> >
> >       err = nilfs_sysfs_create_mounted_snapshots_group(nilfs);
> >       if (err)
> > -             goto cleanup_dev_kobject;
> > +             goto delete_dev_kobject;
> >
> >       err = nilfs_sysfs_create_checkpoints_group(nilfs);
> >       if (err)
> > @@ -1027,6 +1027,9 @@ int nilfs_sysfs_create_device_group(struct super_block *sb)
> >   delete_mounted_snapshots_group:
> >       nilfs_sysfs_delete_mounted_snapshots_group(nilfs);
> >
> > +delete_dev_kobject:
> > +     kobject_del(&nilfs->ns_dev_kobj);
> > +
> >   cleanup_dev_kobject:
> >       kobject_put(&nilfs->ns_dev_kobj);
> >       kfree(nilfs->ns_dev_subgroups);
> With regards,
> Pavel Skripkin
