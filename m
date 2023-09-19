From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 08/26] gfs2: Convert gfs2_write_buf_to_page() to use a folio
Date: Wed, 20 Sep 2023 00:32:12 +0200
Message-ID: <CAHc6FU5XnHsqXunoT5oVdupFE_NVuW_uyitZPLqgEzfUkr=V0g@mail.gmail.com>
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-9-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695162747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0x5XQwTZHDcZyZxqW3gmQpgHS2gIGGzK97rIzkAXl3Q=;
        b=feAAS7O1g6lGUrDRMBJUFVi4qbugbyNyRFrzIlOg9OIfjWicBCWg6eAL9KgD4DOskL1Ajf
        6+PsCQTwpQyd6WAKR8eyPvPMUhrVou6KNz5rj8bAtR3ohO9n1uRJebzUuSu6arXCCQMeg3
        4r9aPEw1co6HvKjIyhx96JOeUe488/k=
In-Reply-To: <20230919045135.3635437-9-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gfs2-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, ocfs2-devel-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pankaj Raghav <p.raghav-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

On Tue, Sep 19, 2023 at 7:00=E2=80=AFAM Matthew Wilcox (Oracle)
<willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> Remove several folio->page->folio conversions.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> ---
>  fs/gfs2/quota.c | 37 +++++++++++++++++++------------------
>  1 file changed, 19 insertions(+), 18 deletions(-)
>
> diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
> index 171b2713d2e5..0ee4865ebdca 100644
> --- a/fs/gfs2/quota.c
> +++ b/fs/gfs2/quota.c
> @@ -736,7 +736,7 @@ static int gfs2_write_buf_to_page(struct gfs2_sbd *sd=
p, unsigned long index,
>         struct gfs2_inode *ip =3D GFS2_I(sdp->sd_quota_inode);
>         struct inode *inode =3D &ip->i_inode;
>         struct address_space *mapping =3D inode->i_mapping;
> -       struct page *page;
> +       struct folio *folio;
>         struct buffer_head *bh;
>         u64 blk;
>         unsigned bsize =3D sdp->sd_sb.sb_bsize, bnum =3D 0, boff =3D 0;
> @@ -745,15 +745,15 @@ static int gfs2_write_buf_to_page(struct gfs2_sbd *=
sdp, unsigned long index,
>         blk =3D index << (PAGE_SHIFT - sdp->sd_sb.sb_bsize_shift);
>         boff =3D off % bsize;
>
> -       page =3D grab_cache_page(mapping, index);
> -       if (!page)
> -               return -ENOMEM;
> -       if (!page_has_buffers(page))
> -               create_empty_buffers(page, bsize, 0);
> +       folio =3D filemap_grab_folio(mapping, index);
> +       if (IS_ERR(folio))
> +               return PTR_ERR(folio);
> +       bh =3D folio_buffers(folio);
> +       if (!bh)
> +               bh =3D folio_create_empty_buffers(folio, bsize, 0);
>
> -       bh =3D page_buffers(page);
> -       for(;;) {
> -               /* Find the beginning block within the page */
> +       for (;;) {
> +               /* Find the beginning block within the folio */
>                 if (pg_off >=3D ((bnum * bsize) + bsize)) {
>                         bh =3D bh->b_this_page;
>                         bnum++;
> @@ -766,9 +766,10 @@ static int gfs2_write_buf_to_page(struct gfs2_sbd *s=
dp, unsigned long index,
>                                 goto unlock_out;
>                         /* If it's a newly allocated disk block, zero it =
*/
>                         if (buffer_new(bh))
> -                               zero_user(page, bnum * bsize, bh->b_size)=
;
> +                               folio_zero_range(folio, bnum * bsize,
> +                                               bh->b_size);
>                 }
> -               if (PageUptodate(page))
> +               if (folio_test_uptodate(folio))
>                         set_buffer_uptodate(bh);
>                 if (bh_read(bh, REQ_META | REQ_PRIO) < 0)
>                         goto unlock_out;
> @@ -784,17 +785,17 @@ static int gfs2_write_buf_to_page(struct gfs2_sbd *=
sdp, unsigned long index,
>                 break;
>         }
>
> -       /* Write to the page, now that we have setup the buffer(s) */
> -       memcpy_to_page(page, off, buf, bytes);
> -       flush_dcache_page(page);
> -       unlock_page(page);
> -       put_page(page);
> +       /* Write to the folio, now that we have setup the buffer(s) */
> +       memcpy_to_folio(folio, off, buf, bytes);
> +       flush_dcache_folio(folio);
> +       folio_unlock(folio);
> +       folio_put(folio);
>
>         return 0;
>
>  unlock_out:
> -       unlock_page(page);
> -       put_page(page);
> +       folio_unlock(folio);
> +       folio_put(folio);
>         return -EIO;
>  }
>
> --
> 2.40.1
>

Reviewed-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks,
Andreas

