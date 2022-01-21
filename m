From: Dongliang Mu <mudongliangabcd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Fw:Re: [PATCH] fs: nilfs2: fix memory leak in nilfs sysfs create
 device group
Date: Fri, 21 Jan 2022 11:47:26 +0800
Message-ID: <CAD-N9QUqfq+0UeMjQALUmGpX5xgjS6=BXvsqcXQpJRzhB6hHLw@mail.gmail.com>
References: <3192BC90-D082-472B-B310-6E09A14A77C6@hust.edu.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9pfbFTwNFOqXDTrn460UZ4SRTCU9wK5Pp87Cp8WcchQ=;
        b=dnJghX5S5motNuQxvgJPOMnDkZD+vOuJ5IFIkIJpj0yUDXXoSJaohYJOzU9AH8ThJR
         3bm4L7ANXW2Z0gQDvx9O67UUJ3jFoAqJ4zr5OaTnyZfXVIzSlmHMoIuxGzLUvunIC6sG
         AHqZYkHhFKfVURa4oemNwl5tVB/TXnYG6avUOwJGjJJTW9lVPE2FccpUqBu2rmp46HSs
         PApICazBeoq40F/Twm5SRogT+s9FCqtIQS9txE1Z8JI6OweiGwZnCNw/fWd0TpfX6Q2w
         h1j/8oOkYYi5RBPcW/tUoaMjQ/OnUUW809hIkbADdbx+8Jjc5BURA8E6GecrcirwvAA6
         W6EA==
In-Reply-To: <3192BC90-D082-472B-B310-6E09A14A77C6-6lmH0oBJgSDM1kAEIRd3EQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Nanyong Sun <sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: =?UTF-8?B?5oWV5Yas5Lqu?= <dzm91-6lmH0oBJgSDM1kAEIRd3EQ@public.gmane.org>

>
> From=EF=BC=9A Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date=EF=BC=9A 01/21/2022 01:54
> To=EF=BC=9A Dongliang Mu <dzm91-6lmH0oBJgSDM1kAEIRd3EQ@public.gmane.org>
> Cc=EF=BC=9A Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =E3=80=81 Andrew Morton=
 <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> =E3=80=81 linux-nilfs <linux-nilfs-u79uwXL29TZUIDd8j+nm9g@public.gmane.org=
.org> =E3=80=81 LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> =E3=80=81 Nanyong Sun <=
sunnanyong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Subject=EF=BC=9A Re: [PATCH] fs: nilfs2: fix memory leak in nilfs_sysfs_c=
reate_device_group
> (added Nanyong Sun to CC)
> Hi Dongliang,
>
> On Thu, Jan 20, 2022 at 11:07 PM Pavel Skripkin <paskripkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
>
>
> Hi Dongliang,
>
> On 1/20/22 16:44, Dongliang Mu wrote:
>
> The preivous commit 8fd0c1b0647a ("nilfs2: fix memory leak in
> nilfs_sysfs_delete_device_group") only handles the memory leak in the
> nilfs_sysfs_delete_device_group. However, the similar memory leak still
> occurs in the nilfs_sysfs_create_device_group.
>
> Fix it by adding kobject_del when
> kobject_init_and_add succeeds, but one of the following calls fails.
>
> Fixes: 8fd0c1b0647a ("nilfs2: fix memory leak in nilfs_sysfs_delete_devic=
e_group")
>
>
> Why Fixes tag points to my commit? This issue was introduced before my pa=
tch
>
>
> As Pavel pointed out, this patch is independent of his patch.
> The following one ?

Hi Pavel,

This is an incorrect fixes tag. I need to dig more about `git log -p
fs/nilfs2/sysfs.c`.

I wonder if there are any automatic or semi-automatic ways to capture
this fixes tag. Or how do you guys identify the fixes tag?

>
> 5f5dec07aca7 ("nilfs2: fix memory leak in nilfs_sysfs_create_device_group=
")
>
> Signed-off-by: Dongliang Mu <dzm91-6lmH0oBJgSDM1kAEIRd3EQ@public.gmane.org>
> ---
> fs/nilfs2/sysfs.c | 5 ++++-
> 1 file changed, 4 insertions(+), 1 deletion(-)
>
>
> Can you describe what memory leak issue does this patch actually fix ?
>
> It looks like kobject_put() can call __kobject_del() unless circular
> references exist.
>
> kobject_put() -> kref_put() -> kobject_release() ->
> kobject_cleanup() -> __kobject_del()
>
> As explained in Documentation/core-api/kobject.rst,
>
> kobject_del() can be used to drop the reference to the parent object, if
> circular references are constructed.
>
> But, at least, the parent object is NULL in this case.
> I really want to understand what the real problem is.
>
> Thanks,
> Ryusuke Konishi

I know where my problem is. From the disconnect function, I think the
kobject_del and kobject_put are both necessary without checking the
documentation of kobjects.

Then I think the current error handling may miss kobject_del, and this
patch is generated.

As a result, I think we can ignore this patch. Sorry for my false alarm.

>
>
> diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
> index 379d22e28ed6..0b2db2b499d5 100644
> --- a/fs/nilfs2/sysfs.c
> +++ b/fs/nilfs2/sysfs.c
> @@ -995,7 +995,7 @@ int nilfs_sysfs_create_device_group(struct super_bloc=
k *sb)
>
> err =3D nilfs_sysfs_create_mounted_snapshots_group(nilfs);
> if (err)
> -             goto cleanup_dev_kobject;
> +             goto delete_dev_kobject;
>
> err =3D nilfs_sysfs_create_checkpoints_group(nilfs);
> if (err)
> @@ -1027,6 +1027,9 @@ int nilfs_sysfs_create_device_group(struct super_bl=
ock *sb)
> delete_mounted_snapshots_group:
> nilfs_sysfs_delete_mounted_snapshots_group(nilfs);
>
> +delete_dev_kobject:
> +     kobject_del(&nilfs->ns_dev_kobj);
> +
> cleanup_dev_kobject:
> kobject_put(&nilfs->ns_dev_kobj);
> kfree(nilfs->ns_dev_subgroups);
>
> With regards,
> Pavel Skripkin
