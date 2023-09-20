From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH 12/26] nilfs2: Convert nilfs_mdt_forget_block() to use a folio
Date: Wed, 20 Sep 2023 16:25:55 +0900
Message-ID: <CAKFNMokf=ucSpitwt2sF-nBPJPfL02MmorwXvdcw_h1zEoB7BA@mail.gmail.com>
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-13-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <reiserfs-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695194771; x=1695799571; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LQu/iPxRaWTK1rhHGERjdyj3zLGL4cZdjE4RNeJI6UE=;
        b=SeeO1Ae4kypzSNScnVBvW0bI2L1St02MQMW3+P9z20ybKAUp92VZdCNVVWRDNmn+TC
         ZXPEEHhMQmHsSw5fxpbm+9k6D2GeUnKhpBkwKBAULcGGg9b/QPmrhpnIfOeAJwpsfXiM
         hS0bXZhsCXyAOyBThHhJ0FBAREF8zfCbxYqChTGQsEWnvzqGRLtGYSlZrba+UjGDTvM1
         EQvZmYCOz8FI3Zdn41QAPJnbHlCqiQBcn5lln0FfgEIzAlwvExnlwno0ig3qqakGOe5i
         c4uK6z7C4D2/MuLTvIurodQiDlX0BvSVCpn+99qMjJMTCla8nNP+tstVgGkN+Y1RZ/Uj
         jj4g==
In-Reply-To: <20230919045135.3635437-13-willy@infradead.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>

On Tue, Sep 19, 2023 at 3:04=E2=80=AFPM Matthew Wilcox (Oracle) wrote:
>
> Remove a number of folio->page->folio conversions.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/nilfs2/mdt.c | 30 ++++++++++++++----------------
>  1 file changed, 14 insertions(+), 16 deletions(-)
>
> diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
> index db2260d6e44d..11b7cf4acc92 100644
> --- a/fs/nilfs2/mdt.c
> +++ b/fs/nilfs2/mdt.c
> @@ -356,30 +356,28 @@ int nilfs_mdt_delete_block(struct inode *inode, uns=
igned long block)
>   */
>  int nilfs_mdt_forget_block(struct inode *inode, unsigned long block)
>  {
> -       pgoff_t index =3D (pgoff_t)block >>
> -               (PAGE_SHIFT - inode->i_blkbits);
> -       struct page *page;
> -       unsigned long first_block;
> +       pgoff_t index =3D block >> (PAGE_SHIFT - inode->i_blkbits);
> +       struct folio *folio;
> +       struct buffer_head *bh;
>         int ret =3D 0;
>         int still_dirty;
>
> -       page =3D find_lock_page(inode->i_mapping, index);
> -       if (!page)
> +       folio =3D filemap_lock_folio(inode->i_mapping, index);
> +       if (IS_ERR(folio))
>                 return -ENOENT;
>
> -       wait_on_page_writeback(page);
> +       folio_wait_writeback(folio);
>
> -       first_block =3D (unsigned long)index <<
> -               (PAGE_SHIFT - inode->i_blkbits);
> -       if (page_has_buffers(page)) {
> -               struct buffer_head *bh;
> -
> -               bh =3D nilfs_page_get_nth_block(page, block - first_block=
);
> +       bh =3D folio_buffers(folio);
> +       if (bh) {
> +               unsigned long first_block =3D index <<
> +                               (PAGE_SHIFT - inode->i_blkbits);
> +               bh =3D get_nth_bh(bh, block - first_block);
>                 nilfs_forget_buffer(bh);
>         }
> -       still_dirty =3D PageDirty(page);
> -       unlock_page(page);
> -       put_page(page);
> +       still_dirty =3D folio_test_dirty(folio);
> +       folio_unlock(folio);
> +       folio_put(folio);
>
>         if (still_dirty ||
>             invalidate_inode_pages2_range(inode->i_mapping, index, index)=
 !=3D 0)
> --
> 2.40.1
>

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Looks good to me.

Thanks,
Ryusuke Konishi
