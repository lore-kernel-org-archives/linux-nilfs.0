From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: Fix reference count leak in nilfs_sysfs_create_snapshot_group.
Date: Thu, 28 May 2020 07:00:44 +0900
Message-ID: <CAKFNMomc1ek72NdROKZ9F-E9Dz=gW2kSrQtkQdL9Msn=+pJdpg@mail.gmail.com>
References: <20200527195532.28077-1-wu000273@umn.edu>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FJ7qs4KFV6ljkhIIkNMDHu8kqAaBL+nGojh30Ee94Vw=;
        b=olPcckYxJ+9VtkFPIRUwt6nqVH8yrrNm1Tao0uxDTsRCjUISFwdvp8AUEdnZXs0yak
         dRZHLc1NHWBikx/6E+144Zz2kA6sg0CyDmsLoN/k1b8zOrA7N5Kut8mOj1xF1Ca5kYrP
         XgjoEjJ9B2EUlRk5mFYZkLVQtFZ+RKmX0V/CXt2U/znHeeTpfzgomsYL1ztichiIUMNr
         LQbLNr5Oy5DoRkniO05pIAPXt+dODBuYcTmAdxUQCDsleVt1dP5+dZxqLcRsd35UVvzk
         gr+4FvFXobMMf93thp4PRpKs1GcObo+IzEIrotIL3OSFj9BruqS6fv513FBm/rJ/YGDf
         iRew==
In-Reply-To: <20200527195532.28077-1-wu000273-OJFnDUYgAso@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: kjlu-OJFnDUYgAso@public.gmane.org, wu000273-OJFnDUYgAso@public.gmane.org, Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Andrew,

Apply this, please.

Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, May 28, 2020 at 4:55 AM <wu000273-OJFnDUYgAso@public.gmane.org> wrote:
>
> From: Qiushi Wu <wu000273-OJFnDUYgAso@public.gmane.org>
>
> kobject_init_and_add() takes reference even when it fails.
> If this function returns an error, kobject_put() must be called to
> properly clean up the memory associated with the object. Previous
> commit "b8eb718348b8" fixed a similar problem.
>
> Fixes: a5a7332a291b ("nilfs2: add /sys/fs/nilfs2/<device>/mounted_snapshots/<snapshot>group")
> Signed-off-by: Qiushi Wu <wu000273-OJFnDUYgAso@public.gmane.org>
> ---
>  fs/nilfs2/sysfs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
> index e60be7bb55b0..b2517c5e773a 100644
> --- a/fs/nilfs2/sysfs.c
> +++ b/fs/nilfs2/sysfs.c
> @@ -209,8 +209,10 @@ int nilfs_sysfs_create_snapshot_group(struct nilfs_root *root)
>                                             "%llu", root->cno);
>         }
>
> -       if (err)
> +       if (err) {
> +               kobject_put(&root->snapshot_kobj);
>                 return err;
> +       }
>
>         return 0;
>  }
> --
> 2.17.1
>
