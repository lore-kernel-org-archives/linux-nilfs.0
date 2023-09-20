From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 10/26] nilfs2: Convert nilfs_grab_buffer() to use a folio
Date: Wed, 20 Sep 2023 13:13:45 +0900
Message-ID: <CAKFNMomBNvU-cRbrHMem8qPtLdfeO7VgKdSwxPixA1-vZMyDVg@mail.gmail.com>
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-11-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695183242; x=1695788042; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n0rt7w3e82POtgPKP1THsIMl2ekopUlVw4b9tDepiWE=;
        b=N1oBJ5Pk69IwRoTdPPZCfX9w3ms0bY00XHcPHEPZybptv3sEY3PN3e6Q8RAAaL8LEz
         vzIs7cljTd46Qs3L8ACG3gtSEkCn/ndQtUvrbJQt1q+Joe7zhMAWhlccpC9zI2/sTDHH
         AXebXcciG2wUzL41ekKy/OBrT4+hpe9Fr8qIFcSIB9Ccwh9VOO4q48Vq2C3tv3s1xIOJ
         uD4qys+Var6IChL2PXvwULFP/zDoa31jGQsfgMGOdySEyQrMo6yLWACr/P/xak9aGleV
         vKmkCLVHe58WjFC1Y+cJMA9p93e0FPYELvSLHNoI50ly97SaKVt1fIsSyXsSzmBOYd3/
         Z8Rg==
In-Reply-To: <20230919045135.3635437-11-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gfs2-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, ocfs2-devel-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pankaj Raghav <p.raghav-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

On Tue, Sep 19, 2023 at 7:20=E2=80=AFPM Matthew Wilcox (Oracle) wrote:
>
> Remove a number of folio->page->folio conversions.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> ---
>  fs/nilfs2/page.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index b4e54d079b7d..1c075bd906c9 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -25,19 +25,19 @@
>         (BIT(BH_Uptodate) | BIT(BH_Mapped) | BIT(BH_NILFS_Node) |       \
>          BIT(BH_NILFS_Volatile) | BIT(BH_NILFS_Checked))
>
> -static struct buffer_head *
> -__nilfs_get_page_block(struct page *page, unsigned long block, pgoff_t i=
ndex,
> -                      int blkbits, unsigned long b_state)
> +static struct buffer_head *__nilfs_get_folio_block(struct folio *folio,
> +               unsigned long block, pgoff_t index, int blkbits,
> +               unsigned long b_state)
>
>  {
>         unsigned long first_block;
> -       struct buffer_head *bh;
> +       struct buffer_head *bh =3D folio_buffers(folio);
>
> -       if (!page_has_buffers(page))
> -               create_empty_buffers(page, 1 << blkbits, b_state);
> +       if (!bh)
> +               bh =3D folio_create_empty_buffers(folio, 1 << blkbits, b_=
state);
>
>         first_block =3D (unsigned long)index << (PAGE_SHIFT - blkbits);
> -       bh =3D nilfs_page_get_nth_block(page, block - first_block);
> +       bh =3D get_nth_bh(bh, block - first_block);
>
>         touch_buffer(bh);
>         wait_on_buffer(bh);
> @@ -51,17 +51,17 @@ struct buffer_head *nilfs_grab_buffer(struct inode *i=
node,
>  {
>         int blkbits =3D inode->i_blkbits;
>         pgoff_t index =3D blkoff >> (PAGE_SHIFT - blkbits);
> -       struct page *page;
> +       struct folio *folio;
>         struct buffer_head *bh;
>
> -       page =3D grab_cache_page(mapping, index);
> -       if (unlikely(!page))
> +       folio =3D filemap_grab_folio(mapping, index);
> +       if (IS_ERR(folio))
>                 return NULL;
>
> -       bh =3D __nilfs_get_page_block(page, blkoff, index, blkbits, b_sta=
te);
> +       bh =3D __nilfs_get_folio_block(folio, blkoff, index, blkbits, b_s=
tate);
>         if (unlikely(!bh)) {
> -               unlock_page(page);
> -               put_page(page);
> +               folio_unlock(folio);
> +               folio_put(folio);
>                 return NULL;
>         }
>         return bh;
> --
> 2.40.1
>

Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Looks good to me.

Thanks,
Ryusuke Konishi
