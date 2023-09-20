From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH 11/26] nilfs2: Convert nilfs_copy_page() to nilfs_copy_folio()
Date: Wed, 20 Sep 2023 14:47:53 +0900
Message-ID: <CAKFNMo=WOCiFU0SDFTczCqRPEk3_sH7bXEHaGEE390+ouAuapA@mail.gmail.com>
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-12-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <reiserfs-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695188890; x=1695793690; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5e3f4QzEJgcH/wzSbDI/gKJD4hMsGrXqzvw2fLNZQag=;
        b=UzFd3QYMtehCdgeNkvTn4rIvQVKMFQ/UvVVf4H6QmR8BgFdZfIY9gSoKwLHUqAaLRG
         3yFf/rq2wcv248xUP0jJ+gpZpugGXXn8nWxU0cdCacDRmYA5E2aLJIAZexhB2aCbmAM0
         7AO6bjwFjCdQTkrA8ixSn7M7G6bRu6pIlq2d82PhIQK4IV+YpTC7jkVVW6kQwAmA788b
         jd7NNovi+H233hSX5GiJCc72IQBo5pj0eSB9a1YuiN8XLyR9LOajzV1NTxc82Gm6p98g
         tG1HfvYCh2FqSrqw+Yw/yC9JHI/Di8evphmuEy0qzkmNnuooVraq8uA87GC5i/xgKCLb
         LQQg==
In-Reply-To: <20230919045135.3635437-12-willy@infradead.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>

On Tue, Sep 19, 2023 at 1:56=E2=80=AFPM Matthew Wilcox (Oracle) wrote:
>
> Both callers already have a folio, so pass it in and use it directly.
> Removes a lot of hidden calls to compound_head().
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/nilfs2/page.c | 50 +++++++++++++++++++++++++-----------------------
>  1 file changed, 26 insertions(+), 24 deletions(-)
>
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index 1c075bd906c9..696215d899bf 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -184,30 +184,32 @@ void nilfs_page_bug(struct page *page)
>  }
>
>  /**
> - * nilfs_copy_page -- copy the page with buffers
> - * @dst: destination page
> - * @src: source page
> - * @copy_dirty: flag whether to copy dirty states on the page's buffer h=
eads.
> + * nilfs_copy_folio -- copy the folio with buffers
> + * @dst: destination folio
> + * @src: source folio
> + * @copy_dirty: flag whether to copy dirty states on the folio's buffer =
heads.
>   *
> - * This function is for both data pages and btnode pages.  The dirty fla=
g
> - * should be treated by caller.  The page must not be under i/o.
> - * Both src and dst page must be locked
> + * This function is for both data folios and btnode folios.  The dirty f=
lag
> + * should be treated by caller.  The folio must not be under i/o.
> + * Both src and dst folio must be locked
>   */
> -static void nilfs_copy_page(struct page *dst, struct page *src, int copy=
_dirty)
> +static void nilfs_copy_folio(struct folio *dst, struct folio *src,
> +               bool copy_dirty)
>  {
>         struct buffer_head *dbh, *dbufs, *sbh;
>         unsigned long mask =3D NILFS_BUFFER_INHERENT_BITS;
>
> -       BUG_ON(PageWriteback(dst));
> +       BUG_ON(folio_test_writeback(dst));
>
> -       sbh =3D page_buffers(src);
> -       if (!page_has_buffers(dst))
> -               create_empty_buffers(dst, sbh->b_size, 0);
> +       sbh =3D folio_buffers(src);
> +       dbh =3D folio_buffers(dst);
> +       if (!dbh)
> +               dbh =3D folio_create_empty_buffers(dst, sbh->b_size, 0);
>
>         if (copy_dirty)
>                 mask |=3D BIT(BH_Dirty);
>
> -       dbh =3D dbufs =3D page_buffers(dst);
> +       dbufs =3D dbh;
>         do {
>                 lock_buffer(sbh);
>                 lock_buffer(dbh);
> @@ -218,16 +220,16 @@ static void nilfs_copy_page(struct page *dst, struc=
t page *src, int copy_dirty)
>                 dbh =3D dbh->b_this_page;
>         } while (dbh !=3D dbufs);
>
> -       copy_highpage(dst, src);
> +       folio_copy(dst, src);
>
> -       if (PageUptodate(src) && !PageUptodate(dst))
> -               SetPageUptodate(dst);
> -       else if (!PageUptodate(src) && PageUptodate(dst))
> -               ClearPageUptodate(dst);
> -       if (PageMappedToDisk(src) && !PageMappedToDisk(dst))
> -               SetPageMappedToDisk(dst);
> -       else if (!PageMappedToDisk(src) && PageMappedToDisk(dst))
> -               ClearPageMappedToDisk(dst);
> +       if (folio_test_uptodate(src) && !folio_test_uptodate(dst))
> +               folio_mark_uptodate(dst);
> +       else if (!folio_test_uptodate(src) && folio_test_uptodate(dst))
> +               folio_clear_uptodate(dst);
> +       if (folio_test_mappedtodisk(src) && !folio_test_mappedtodisk(dst)=
)
> +               folio_set_mappedtodisk(dst);
> +       else if (!folio_test_mappedtodisk(src) && folio_test_mappedtodisk=
(dst))
> +               folio_clear_mappedtodisk(dst);
>
>         do {
>                 unlock_buffer(sbh);
> @@ -269,7 +271,7 @@ int nilfs_copy_dirty_pages(struct address_space *dmap=
,
>                         NILFS_PAGE_BUG(&folio->page,
>                                        "found empty page in dat page cach=
e");
>
> -               nilfs_copy_page(&dfolio->page, &folio->page, 1);
> +               nilfs_copy_folio(dfolio, folio, true);
>                 filemap_dirty_folio(folio_mapping(dfolio), dfolio);
>
>                 folio_unlock(dfolio);
> @@ -314,7 +316,7 @@ void nilfs_copy_back_pages(struct address_space *dmap=
,
>                 if (!IS_ERR(dfolio)) {
>                         /* overwrite existing folio in the destination ca=
che */
>                         WARN_ON(folio_test_dirty(dfolio));
> -                       nilfs_copy_page(&dfolio->page, &folio->page, 0);
> +                       nilfs_copy_folio(dfolio, folio, false);
>                         folio_unlock(dfolio);
>                         folio_put(dfolio);
>                         /* Do we not need to remove folio from smap here?=
 */
> --
> 2.40.1
>

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Everything else looks fine if the folio_copy symbol is exported.

Thanks,
Ryusuke Konishi
