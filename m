From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 27/32] nilfs2: Convert to use blkdev_get_handle_by_path()
Date: Fri, 21 Jul 2023 14:22:00 +0900
Message-ID: <CAKFNMok9dE4MBB6J9_OLQMxJ=BC+kroFRZF5yCxaO3Njxr8eGw@mail.gmail.com>
References: <20230629165206.383-1-jack@suse.cz> <20230704122224.16257-27-jack@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689916938; x=1690521738;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PUgA0BOBLvUnQGO4XUDe/mEntZbMH9oPKtQD8XsVYi8=;
        b=d8+XppcJafCOqVH33NrgT96K09WpKE2KW+PJCO9efl25W9oHVQgfYItaNLBEMkw7KT
         7mNZbyku3RGxhglXsCBnG3zQqKMNjRgWZMBGq5l/Yh0++2WQLTnC9U6Ua+iYuKfUGTDn
         c0Bw4c0MYdGX35YUtHc8cyEwVDtMIugmzr+fmEPXZhDsiW8mtn/lbc5LAH+RCP8BHS1m
         skWXKfdV6Ha5Eqdal5OnDNkCEy68JN2r6EPCp77aGn3PTJjdLVueEnsMxsuE3v9Eqhee
         SSNhz6lfsVo3rjeeud3YwCHmHcO+P8VroFe8Kz/hJJhdC5MidNes1b/jsIk8eXvIcfOM
         7jBQ==
In-Reply-To: <20230704122224.16257-27-jack-AlSwsSmVLrQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jul 4, 2023 at 9:24=E2=80=AFPM Jan Kara wrote:
>
> Convert nilfs2 to use blkdev_get_handle_by_path() and initialize the
> superblock with the handle.
>
> CC: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> ---
>  fs/nilfs2/super.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)

Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

You may revise this patch to reflect comments on the patch 1/32, but
the changes here look fine, and I have no objection to rewriting to
use bdev_handle.

Thanks,
Ryusuke Konishi




>
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 0ef8c71bde8e..0aba0daa06d2 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -1283,14 +1283,15 @@ static int nilfs_identify(char *data, struct nilf=
s_super_data *sd)
>
>  static int nilfs_set_bdev_super(struct super_block *s, void *data)
>  {
> -       s->s_bdev =3D data;
> +       s->s_bdev_handle =3D data;
> +       s->s_bdev =3D s->s_bdev_handle->bdev;
>         s->s_dev =3D s->s_bdev->bd_dev;
>         return 0;
>  }
>
>  static int nilfs_test_bdev_super(struct super_block *s, void *data)
>  {
> -       return (void *)s->s_bdev =3D=3D data;
> +       return s->s_bdev =3D=3D ((struct bdev_handle *)data)->bdev;
>  }
>
>  static struct dentry *
> @@ -1298,15 +1299,17 @@ nilfs_mount(struct file_system_type *fs_type, int=
 flags,
>              const char *dev_name, void *data)
>  {
>         struct nilfs_super_data sd;
> +       struct bdev_handle *bdev_handle;
>         struct super_block *s;
>         struct dentry *root_dentry;
>         int err, s_new =3D false;
>
> -       sd.bdev =3D blkdev_get_by_path(dev_name, sb_open_mode(flags), fs_=
type,
> -                                    NULL);
> -       if (IS_ERR(sd.bdev))
> -               return ERR_CAST(sd.bdev);
> +       bdev_handle =3D blkdev_get_handle_by_path(dev_name, sb_open_mode(=
flags),
> +                               fs_type, NULL);
> +       if (IS_ERR(bdev_handle))
> +               return ERR_CAST(bdev_handle);
>
> +       sd.bdev =3D bdev_handle->bdev;
>         sd.cno =3D 0;
>         sd.flags =3D flags;
>         if (nilfs_identify((char *)data, &sd)) {
> @@ -1326,7 +1329,7 @@ nilfs_mount(struct file_system_type *fs_type, int f=
lags,
>                 goto failed;
>         }
>         s =3D sget(fs_type, nilfs_test_bdev_super, nilfs_set_bdev_super, =
flags,
> -                sd.bdev);
> +                bdev_handle);
>         mutex_unlock(&sd.bdev->bd_fsfreeze_mutex);
>         if (IS_ERR(s)) {
>                 err =3D PTR_ERR(s);
> @@ -1374,7 +1377,7 @@ nilfs_mount(struct file_system_type *fs_type, int f=
lags,
>         }
>
>         if (!s_new)
> -               blkdev_put(sd.bdev, fs_type);
> +               blkdev_handle_put(bdev_handle);
>
>         return root_dentry;
>
> @@ -1383,7 +1386,7 @@ nilfs_mount(struct file_system_type *fs_type, int f=
lags,
>
>   failed:
>         if (!s_new)
> -               blkdev_put(sd.bdev, fs_type);
> +               blkdev_handle_put(bdev_handle);
>         return ERR_PTR(err);
>  }
>
> --
> 2.35.3
>
