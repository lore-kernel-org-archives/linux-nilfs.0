From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: Fix reference count leak in nilfs_sysfs_create_device_group
Date: Thu, 28 May 2020 07:21:21 +0900
Message-ID: <CAKFNMom3X-M-4x5X+TaxvZw9AzdFKOhSZu6BcKK1CU9fCasjng@mail.gmail.com>
References: <20200527200933.31135-1-wu000273@umn.edu>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PzzLRzAW0nQP8h/XDQSb0USxXb11km0BANKGPPnjAFo=;
        b=QgVfy4DuSqx4yjM69aMxy3euvPCdQ5TZLa/0/nEH7Yb5x3POW/isiHy/znghOdKZFK
         KYGPALjH2n+7Fc9t09/FkP95+ZRV99w+N7jSsGzEOHURa2Jq4+yohVb6U57qOFUsrNyM
         McICiIIxPIK+b2pHFRoc0AN81YRjxkJ/ooPSWVyF1ZG5veySbhuQogCwY9C4Y4rCw7ZC
         6jcH+QqjlgPrmHwaFX2iFS3sJspoyW2y/8JVXXbTWCg7aeC+tqOmR+GK6oJfbFilxBQ+
         DAbZw9HMi0P0V4ycF4P+FTHw+UjTIj8mx5jejg3Q5wyNW7knx0xVqpiPDnJ6Qn/hUGit
         IHvA==
In-Reply-To: <20200527200933.31135-1-wu000273-OJFnDUYgAso@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: wu000273-OJFnDUYgAso@public.gmane.org
Cc: kjlu-OJFnDUYgAso@public.gmane.org, Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Qiushi Wu,

Can we call kobject_del() instead of kobject_put() when
kobject_init_and_add() failed ?
If it's unclear, I think we should fix this by
    calling kobject_put() when kobject_init_and_add() fails, and
    goto free_dev_subgroups.

Regards,

On Thu, May 28, 2020 at 5:10 AM <wu000273-OJFnDUYgAso@public.gmane.org> wrote:
>
> From: Qiushi Wu <wu000273-OJFnDUYgAso@public.gmane.org>
>
> kobject_init_and_add() takes reference even when it fails.
> In nilfs_sysfs_create_device_group(), the memory allocated by
> kobject_init_and_add() is not freed when kobject_init_and_add()
> fails. Thus replace the jump target "free_dev_subgroups" by
> "cleanup_dev_kobject".
>
> Fixes: da7141fb78db ("nilfs2: add /sys/fs/nilfs2/<device> group")
> Signed-off-by: Qiushi Wu <wu000273-OJFnDUYgAso@public.gmane.org>
> ---
>  fs/nilfs2/sysfs.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
> index e60be7bb55b0..4a74756d52fe 100644
> --- a/fs/nilfs2/sysfs.c
> +++ b/fs/nilfs2/sysfs.c
> @@ -1000,7 +1000,7 @@ int nilfs_sysfs_create_device_group(struct super_block *sb)
>         err = kobject_init_and_add(&nilfs->ns_dev_kobj, &nilfs_dev_ktype, NULL,
>                                     "%s", sb->s_id);
>         if (err)
> -               goto free_dev_subgroups;
> +               goto cleanup_dev_kobject;
>
>         err = nilfs_sysfs_create_mounted_snapshots_group(nilfs);
>         if (err)
> @@ -1038,8 +1038,6 @@ int nilfs_sysfs_create_device_group(struct super_block *sb)
>
>  cleanup_dev_kobject:
>         kobject_del(&nilfs->ns_dev_kobj);
> -
> -free_dev_subgroups:
>         kfree(nilfs->ns_dev_subgroups);
>
>  failed_create_device_group:
> --
> 2.17.1
>
