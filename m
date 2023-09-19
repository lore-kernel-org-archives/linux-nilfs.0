From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH 06/26] gfs2: Convert gfs2_getbuf() to folios
Date: Wed, 20 Sep 2023 00:34:41 +0200
Message-ID: <CAHc6FU6JasO3-8VaOm3MieLEn599OTKPnZC5BwkNUMqNoJ+meA@mail.gmail.com>
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-7-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695162895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eQus7xN9bGIDtrSXQ5yUpeC9VO6X9bRJrGYUnimnUlQ=;
        b=QERE7Qs0UVnfmtfFPWir107Hqwo0Z5Ln9+k4YvxkViI8bbDSjylQDLOkN26BOTbWBHM7lV
        +3JB+YzlaSBIlC564udIA9HaG4QF0D4z6391jlqxhnhx8gLL9Fb9JASe0WsLOx+K6Mz8uC
        8MnhdXTVLbC15VRqFhbBNPUDWIUjyXk=
In-Reply-To: <20230919045135.3635437-7-willy@infradead.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>

On Tue, Sep 19, 2023 at 7:00=E2=80=AFAM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
> Remove several folio->page->folio conversions.  Also use __GFP_NOFAIL
> instead of calling yield() and the new get_nth_bh().
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/gfs2/meta_io.c | 39 +++++++++++++++++----------------------
>  1 file changed, 17 insertions(+), 22 deletions(-)
>
> diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
> index 924361fa510b..f1fac1b45059 100644
> --- a/fs/gfs2/meta_io.c
> +++ b/fs/gfs2/meta_io.c
> @@ -115,7 +115,7 @@ struct buffer_head *gfs2_getbuf(struct gfs2_glock *gl=
, u64 blkno, int create)
>  {
>         struct address_space *mapping =3D gfs2_glock2aspace(gl);
>         struct gfs2_sbd *sdp =3D gl->gl_name.ln_sbd;
> -       struct page *page;
> +       struct folio *folio;
>         struct buffer_head *bh;
>         unsigned int shift;
>         unsigned long index;
> @@ -129,36 +129,31 @@ struct buffer_head *gfs2_getbuf(struct gfs2_glock *=
gl, u64 blkno, int create)
>         bufnum =3D blkno - (index << shift);  /* block buf index within p=
age */
>
>         if (create) {
> -               for (;;) {
> -                       page =3D grab_cache_page(mapping, index);
> -                       if (page)
> -                               break;
> -                       yield();
> -               }
> -               if (!page_has_buffers(page))
> -                       create_empty_buffers(page, sdp->sd_sb.sb_bsize, 0=
);
> +               folio =3D __filemap_get_folio(mapping, index,
> +                               FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
> +                               mapping_gfp_mask(mapping) | __GFP_NOFAIL)=
;
> +               bh =3D folio_buffers(folio);
> +               if (!bh)
> +                       bh =3D folio_create_empty_buffers(folio,
> +                               sdp->sd_sb.sb_bsize, 0);
>         } else {
> -               page =3D find_get_page_flags(mapping, index,
> -                                               FGP_LOCK|FGP_ACCESSED);
> -               if (!page)
> +               folio =3D __filemap_get_folio(mapping, index,
> +                               FGP_LOCK | FGP_ACCESSED, 0);
> +               if (IS_ERR(folio))
>                         return NULL;
> -               if (!page_has_buffers(page)) {
> -                       bh =3D NULL;
> -                       goto out_unlock;
> -               }
> +               bh =3D folio_buffers(folio);
>         }
>
> -       /* Locate header for our buffer within our page */
> -       for (bh =3D page_buffers(page); bufnum--; bh =3D bh->b_this_page)
> -               /* Do nothing */;
> -       get_bh(bh);
> +       if (!bh)
> +               goto out_unlock;
>
> +       bh =3D get_nth_bh(bh, bufnum);
>         if (!buffer_mapped(bh))
>                 map_bh(bh, sdp->sd_vfs, blkno);
>
>  out_unlock:
> -       unlock_page(page);
> -       put_page(page);
> +       folio_unlock(folio);
> +       folio_put(folio);
>
>         return bh;
>  }
> --
> 2.40.1
>

Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>

Thanks,
Andreas

