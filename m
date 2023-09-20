From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 09/26] nilfs2: Convert nilfs_mdt_freeze_buffer to use a folio
Date: Wed, 20 Sep 2023 12:42:51 +0900
Message-ID: <CAKFNMokgW2Js5RUpLujf72C+vpMmJbLM=0OfDpD6MvGwLWFphw@mail.gmail.com>
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-10-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695181388; x=1695786188; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ngNBnUvO+0NVI0ss84Zb16ZvzrZCajcq442dwEgXZM=;
        b=g+3/Erv4hFKcuCv2O7BRAjQ/Sf5qNufTwuCHO9aZUPwz5wkniiYT5IFjWhmXgPAN8q
         684QC4tmy7nWrWUXjQzDY5ejXdA1KuGrHAMlUDa8J+xGEdI2KwwZ5TZBSuoa39M3vfbi
         RHzcyFl6765pSpCIPY0p09rQfEWtYwh/DI1JbABtM4cY0v5vNH7ToFbUJHw2Fn2Gyey3
         eb1/iFoFEpEkgoXxv1br7LhWwzxMbZKx9nMCtTHPROqYOpYOjXk3xMHHq9h6BqWzA97y
         M4RKms9pEfdtoNhCrIncJrMslBrnDDDS9aSOiKCAkr56NcLKzts2W7HJRHZ9VZo+sETk
         1OsQ==
In-Reply-To: <20230919045135.3635437-10-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gfs2-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, ocfs2-devel-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pankaj Raghav <p.raghav-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

On Tue, Sep 19, 2023 at 6:09=E2=80=AFPM Matthew Wilcox (Oracle) wrote:
>
> Remove a number of folio->page->folio conversions.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> ---
>  fs/nilfs2/mdt.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
> index 19c8158605ed..db2260d6e44d 100644
> --- a/fs/nilfs2/mdt.c
> +++ b/fs/nilfs2/mdt.c
> @@ -560,17 +560,19 @@ int nilfs_mdt_freeze_buffer(struct inode *inode, st=
ruct buffer_head *bh)
>  {
>         struct nilfs_shadow_map *shadow =3D NILFS_MDT(inode)->mi_shadow;
>         struct buffer_head *bh_frozen;
> -       struct page *page;
> +       struct folio *folio;
>         int blkbits =3D inode->i_blkbits;
>
> -       page =3D grab_cache_page(shadow->inode->i_mapping, bh->b_folio->i=
ndex);
> -       if (!page)
> -               return -ENOMEM;
> +       folio =3D filemap_grab_folio(shadow->inode->i_mapping,
> +                       bh->b_folio->index);
> +       if (IS_ERR(folio))
> +               return PTR_ERR(folio);
>
> -       if (!page_has_buffers(page))
> -               create_empty_buffers(page, 1 << blkbits, 0);
> +       bh_frozen =3D folio_buffers(folio);
> +       if (!bh_frozen)
> +               bh_frozen =3D folio_create_empty_buffers(folio, 1 << blkb=
its, 0);
>
> -       bh_frozen =3D nilfs_page_get_nth_block(page, bh_offset(bh) >> blk=
bits);
> +       bh_frozen =3D get_nth_bh(bh_frozen, bh_offset(bh) >> blkbits);
>
>         if (!buffer_uptodate(bh_frozen))
>                 nilfs_copy_buffer(bh_frozen, bh);
> @@ -582,8 +584,8 @@ int nilfs_mdt_freeze_buffer(struct inode *inode, stru=
ct buffer_head *bh)
>                 brelse(bh_frozen); /* already frozen */
>         }
>
> -       unlock_page(page);
> -       put_page(page);
> +       folio_unlock(folio);
> +       folio_put(folio);
>         return 0;
>  }
>
> --
> 2.40.1
>

Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Looks good to me.

Thanks,
Ryusuke Konishi
