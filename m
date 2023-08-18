From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH] nilfs2: fix dereferencing freed memory
Date: Sat, 19 Aug 2023 00:45:29 +0900
Message-ID: <CAKFNMom=ZM+YBCr-5UcjxGZY9O75RpNM4O4UqDecZPOgMqtctg@mail.gmail.com>
References: <20230818092022.111054-1-mengferry@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692373545; x=1692978345;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ls3ALkFSoDTpx8/mKPc9zSMNgW/T408i4zWcAjGPcxI=;
        b=bYEC44XZGPKIlC2sahzxuEV7OW5jukbNbgWx+9uKGKJTg695W2EB17Yl9/a7bNIBNB
         SKrTi8magbWMOJjor4n+WEuvx/1dS6o/Zxd50OsZw0Dojjtp5N3CUR5G6l9W5Qu4rMtG
         +S+GZ8LOBJW9lvQYlfQIOEuFgQO6mnjyeQyoHRRoweRYIGRoLsqBU1V3fywp4ia4xiMs
         OlnYFEwEJV6Evd7ssYXQk2M2FYV3A5j9MIfywCc8qoOAXioSBAvdwxfE0KqfWXFA95kZ
         naAml3ihdI5Y6o6pv4lGQt1g9iuTxgu5WvAXCantNLYheyuGawTIJMPy+ey4+QxYHUuj
         YyMg==
In-Reply-To: <20230818092022.111054-1-mengferry@linux.alibaba.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Ferry Meng <mengferry@linux.alibaba.com>
Cc: linux-nilfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Fri, Aug 18, 2023 at 6:20=E2=80=AFPM Ferry Meng wrote:
>
> Fix smatch warning:
>
> fs/nilfs2/gcinode.c:103 nilfs_gccache_submit_read_data() error:
> dereferencing freed memory 'bh'
>
> Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
>
> diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
> index 48fe71d309cb..6319e825f317 100644
> --- a/fs/nilfs2/gcinode.c
> +++ b/fs/nilfs2/gcinode.c
> @@ -73,10 +73,8 @@ int nilfs_gccache_submit_read_data(struct inode *inode=
, sector_t blkoff,
>                 struct the_nilfs *nilfs =3D inode->i_sb->s_fs_info;
>
>                 err =3D nilfs_dat_translate(nilfs->ns_dat, vbn, &pbn);
> -               if (unlikely(err)) { /* -EIO, -ENOMEM, -ENOENT */
> -                       brelse(bh);
> +               if (unlikely(err)) /* -EIO, -ENOMEM, -ENOENT */
>                         goto failed;
> -               }
>         }
>
>         lock_buffer(bh);
> @@ -102,6 +100,8 @@ int nilfs_gccache_submit_read_data(struct inode *inod=
e, sector_t blkoff,
>   failed:
>         unlock_page(bh->b_page);
>         put_page(bh->b_page);
> +       if (err)
> +               brelse(bh);
>         return err;
>  }
>
> --
> 2.19.1.6.gb485710b
>

Ah, this is almost identical to the patch Pan Bian sent me earlier.
After a closer look, I'll pick up his patch instead with a
"Reported-by" tag of your name on it.

Anyway, thanks for your feedback.

Regards,
Ryusuke Konishi
