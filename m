From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2] nilfs2: Fix reference count leak in nilfs_sysfs_create_device_group
Date: Thu, 28 May 2020 08:23:34 +0900
Message-ID: <CAKFNMokewQQnx9VyK1TpZx+o11UTmNoVsZ-eqFrRzXnYdP-NYg@mail.gmail.com>
References: <20200527230442.24228-1-wu000273@umn.edu>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wIVZxySUnBYIOh1u+axvWyg8nrJdsmWrI8rTFK6qLVg=;
        b=Qg5jBIOJ/fnN/Gke/Ow3JmBDV/gHExZTNzXoLEYshE5IPCFeaIyXdpSeewVt/pCERE
         QSy8ZFFHWMzfJ5mcOTathiF9yOLEHFX+Ib3VyDj3WORcpvTCUJ3SpvdVk5TU7NAcnsoW
         iDeHRty7UUBWQ78SUsxkvxadSzDLJX4ctgRVCjTbMh774Go9YfE5GtXADJsj3c+kUHSz
         L0uV0TAG0qejh3Hzz/Q8c8WW5K1Crr2ZcFSC30XUE01UzgI85Tb1VGKKmSokO5k2QDGR
         euSSu74G2kCqAykqTJv0cEAd5cAuVHbMbJP2Cfo/G8WVzhHSPKgypqe7I4jgJULBgUOg
         uOrw==
In-Reply-To: <20200527230442.24228-1-wu000273-OJFnDUYgAso@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kjlu-OJFnDUYgAso@public.gmane.org, Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>, wu000273-OJFnDUYgAso@public.gmane.org

Hi Andrew,

Please pick this up as well.

Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, May 28, 2020 at 8:04 AM <wu000273-OJFnDUYgAso@public.gmane.org> wrote:
>
> From: Qiushi Wu <wu000273-OJFnDUYgAso@public.gmane.org>
>
> kobject_init_and_add() takes reference even when it fails.
> In nilfs_sysfs_create_device_group(), the memory allocated by
> kobject_init_and_add() is not freed when kobject_init_and_add()
> fails. Fix this issue by calling kobject_put() to clean up the
> kobject.
>
> Fixes: da7141fb78db ("nilfs2: add /sys/fs/nilfs2/<device> group")
> Signed-off-by: Qiushi Wu <wu000273-OJFnDUYgAso@public.gmane.org>
> ---
>  V2: using kobject_put() to handle kobject_init_and_add() instead of
>  kobject_del().
>
>  fs/nilfs2/sysfs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
> index e60be7bb55b0..8416f915d118 100644
> --- a/fs/nilfs2/sysfs.c
> +++ b/fs/nilfs2/sysfs.c
> @@ -999,8 +999,10 @@ int nilfs_sysfs_create_device_group(struct super_block *sb)
>         init_completion(&nilfs->ns_dev_kobj_unregister);
>         err = kobject_init_and_add(&nilfs->ns_dev_kobj, &nilfs_dev_ktype, NULL,
>                                     "%s", sb->s_id);
> -       if (err)
> +       if (err) {
> +               kobject_put(&nilfs->ns_dev_kobj);
>                 goto free_dev_subgroups;
> +       }
>
>         err = nilfs_sysfs_create_mounted_snapshots_group(nilfs);
>         if (err)
> --
> 2.17.1
>
