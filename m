From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH 13/26] nilfs2: Convert nilfs_mdt_get_frozen_buffer to use
 a folio
Date: Wed, 20 Sep 2023 17:07:20 +0900
Message-ID: <CAKFNMokMe_QOPuLXsvUJf2+qZLUyi7Z_JFAKvh853N6ZV3yGyA@mail.gmail.com>
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-14-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <reiserfs-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695197256; x=1695802056; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9cH5sDHtnVKWCV3iCYyvX8z8Hs3DAvkXrfeXQp9YY8c=;
        b=OuiXP01hUoxoUzTLFPVW9oPxBvpT1XOogxeSwwAtspy6pdhyj/s/LGbvpfopL3k8gu
         khWOuehEHcZZcs6IC2Js3rZ5utcZLHy2Lwstt3u/C03KYU4BvPjRTKjxFcutYQrYyM9C
         Q8drta0kRjN15QsKwa+1SNvq/zOybu8pANgEZtJ8dVd4htx8KD5n5P433SLYcr3jknuZ
         9fnZEXvQozYw8ZKfykMzp9EocW+pBgxtfsSlmVw57SNRmN5cAqSgWNiXg4jaYY2VCi7J
         ECJdl/Vzfs2XQQjYfyHNfeazrMe7EMVMgp2RpEYN1oLl0YYe2w8n71ku0p/e7Hgu7tUp
         +C3A==
In-Reply-To: <20230919045135.3635437-14-willy@infradead.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>

On Tue, Sep 19, 2023 at 6:25=E2=80=AFPM Matthew Wilcox (Oracle) wrote:
>
> Remove a number of folio->page->folio conversions.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/nilfs2/mdt.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
> index 11b7cf4acc92..7b754e6494d7 100644
> --- a/fs/nilfs2/mdt.c
> +++ b/fs/nilfs2/mdt.c
> @@ -592,17 +592,19 @@ nilfs_mdt_get_frozen_buffer(struct inode *inode, st=
ruct buffer_head *bh)
>  {
>         struct nilfs_shadow_map *shadow =3D NILFS_MDT(inode)->mi_shadow;
>         struct buffer_head *bh_frozen =3D NULL;
> -       struct page *page;
> +       struct folio *folio;
>         int n;
>
> -       page =3D find_lock_page(shadow->inode->i_mapping, bh->b_folio->in=
dex);
> -       if (page) {
> -               if (page_has_buffers(page)) {
> +       folio =3D filemap_lock_folio(shadow->inode->i_mapping,
> +                       bh->b_folio->index);
> +       if (!IS_ERR(folio)) {
> +               bh_frozen =3D folio_buffers(folio);
> +               if (bh_frozen) {
>                         n =3D bh_offset(bh) >> inode->i_blkbits;
> -                       bh_frozen =3D nilfs_page_get_nth_block(page, n);
> +                       bh_frozen =3D get_nth_bh(bh_frozen, n);
>                 }
> -               unlock_page(page);
> -               put_page(page);
> +               folio_unlock(folio);
> +               folio_put(folio);
>         }
>         return bh_frozen;
>  }
> --
> 2.40.1
>

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Looks good to me.

Thanks,
Ryusuke Konishi
