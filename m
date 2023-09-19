From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH 05/26] gfs2: Convert inode unstuffing to use a folio
Date: Wed, 20 Sep 2023 00:28:18 +0200
Message-ID: <CAHc6FU7S8pC7yZETf9y0j2c+BS2QSK0370WoDcw+AwxLUgfobA@mail.gmail.com>
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-6-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695162512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9cF5FIFh22usSjm39Z5xoUee1aW1ZyPpmGmyoy2xhnY=;
        b=gdjePfiLYaj5E1li0cfkqDNx92o4DRV/au1ym3/Lgjuoxw6HWP1bCmmbHYgjrb4M+mzBB3
        73R0j21Hp70T2FdNcD3Krsj9U4dOwA8aUpL5COTGRDPN0kHKGU2UKSFrIOn/3laJJaiHIM
        qHDLoVN551zwI6VAwZwDLA2ouxNyogU=
In-Reply-To: <20230919045135.3635437-6-willy@infradead.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>

On Tue, Sep 19, 2023 at 7:00=E2=80=AFAM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
> Use the folio APIs, removing numerous hidden calls to compound_head().
> Also remove the stale comment about the page being looked up if it's NULL=
.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/gfs2/bmap.c | 48 +++++++++++++++++++++++-------------------------
>  1 file changed, 23 insertions(+), 25 deletions(-)
>
> diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
> index ef7017fb6951..247d2c16593c 100644
> --- a/fs/gfs2/bmap.c
> +++ b/fs/gfs2/bmap.c
> @@ -43,53 +43,51 @@ struct metapath {
>  static int punch_hole(struct gfs2_inode *ip, u64 offset, u64 length);
>
>  /**
> - * gfs2_unstuffer_page - unstuff a stuffed inode into a block cached by =
a page
> + * gfs2_unstuffer_folio - unstuff a stuffed inode into a block cached by=
 a folio
>   * @ip: the inode
>   * @dibh: the dinode buffer
>   * @block: the block number that was allocated
> - * @page: The (optional) page. This is looked up if @page is NULL
> + * @folio: The folio.
>   *
>   * Returns: errno
>   */
> -
> -static int gfs2_unstuffer_page(struct gfs2_inode *ip, struct buffer_head=
 *dibh,
> -                              u64 block, struct page *page)
> +static int gfs2_unstuffer_folio(struct gfs2_inode *ip, struct buffer_hea=
d *dibh,
> +                              u64 block, struct folio *folio)
>  {
>         struct inode *inode =3D &ip->i_inode;
>
> -       if (!PageUptodate(page)) {
> -               void *kaddr =3D kmap(page);
> +       if (!folio_test_uptodate(folio)) {
> +               void *kaddr =3D kmap_local_folio(folio, 0);
>                 u64 dsize =3D i_size_read(inode);
>
>                 memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode), =
dsize);
> -               memset(kaddr + dsize, 0, PAGE_SIZE - dsize);
> -               kunmap(page);
> +               memset(kaddr + dsize, 0, folio_size(folio) - dsize);
> +               kunmap_local(kaddr);
>
> -               SetPageUptodate(page);
> +               folio_mark_uptodate(folio);
>         }
>
>         if (gfs2_is_jdata(ip)) {
> -               struct buffer_head *bh;
> +               struct buffer_head *bh =3D folio_buffers(folio);
>
> -               if (!page_has_buffers(page))
> -                       create_empty_buffers(page, BIT(inode->i_blkbits),
> -                                            BIT(BH_Uptodate));
> +               if (!bh)
> +                       bh =3D folio_create_empty_buffers(folio,
> +                               BIT(inode->i_blkbits), BIT(BH_Uptodate));
>
> -               bh =3D page_buffers(page);
>                 if (!buffer_mapped(bh))
>                         map_bh(bh, inode->i_sb, block);
>
>                 set_buffer_uptodate(bh);
>                 gfs2_trans_add_data(ip->i_gl, bh);
>         } else {
> -               set_page_dirty(page);
> +               folio_mark_dirty(folio);
>                 gfs2_ordered_add_inode(ip);
>         }
>
>         return 0;
>  }
>
> -static int __gfs2_unstuff_inode(struct gfs2_inode *ip, struct page *page=
)
> +static int __gfs2_unstuff_inode(struct gfs2_inode *ip, struct folio *fol=
io)
>  {
>         struct buffer_head *bh, *dibh;
>         struct gfs2_dinode *di;
> @@ -118,7 +116,7 @@ static int __gfs2_unstuff_inode(struct gfs2_inode *ip=
, struct page *page)
>                                               dibh, sizeof(struct gfs2_di=
node));
>                         brelse(bh);
>                 } else {
> -                       error =3D gfs2_unstuffer_page(ip, dibh, block, pa=
ge);
> +                       error =3D gfs2_unstuffer_folio(ip, dibh, block, f=
olio);
>                         if (error)
>                                 goto out_brelse;
>                 }
> @@ -157,17 +155,17 @@ static int __gfs2_unstuff_inode(struct gfs2_inode *=
ip, struct page *page)
>  int gfs2_unstuff_dinode(struct gfs2_inode *ip)
>  {
>         struct inode *inode =3D &ip->i_inode;
> -       struct page *page;
> +       struct folio *folio;
>         int error;
>
>         down_write(&ip->i_rw_mutex);
> -       page =3D grab_cache_page(inode->i_mapping, 0);
> -       error =3D -ENOMEM;
> -       if (!page)
> +       folio =3D filemap_grab_folio(inode->i_mapping, 0);
> +       error =3D PTR_ERR(folio);
> +       if (IS_ERR(folio))
>                 goto out;
> -       error =3D __gfs2_unstuff_inode(ip, page);
> -       unlock_page(page);
> -       put_page(page);
> +       error =3D __gfs2_unstuff_inode(ip, folio);
> +       folio_unlock(folio);
> +       folio_put(folio);
>  out:
>         up_write(&ip->i_rw_mutex);
>         return error;
> --
> 2.40.1
>

Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>

Thanks,
Andreas

