From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 04/26] buffer: Add get_nth_bh()
Date: Wed, 20 Sep 2023 12:40:06 +0900
Message-ID: <CAKFNMonYFYCXnJTkM+MQbDCfTWV19v+acYZwHs-W4NuBBHE7Tg@mail.gmail.com>
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-5-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695181223; x=1695786023; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pbsTDv/vdTgo0XJKb9aBetBXttLdsN9uZRk25mtVFgs=;
        b=kz9uGzclLEKXiK8jGnVi4hO0X9fmmd9lNpXxOv9ixEy5GdXZgRYrQ3Jhm4udhbR+cz
         zkLlxLHBB2jvbcvY2QIhRBc6LMyn0tiYvqeUq4Wy3xy8ePVf3NrSzVWoZB73PcrMti+Q
         z1VPVW87pMGxtWeCFY7pW1o/FmH2Vs9kgbmC6jcun3SMfhuGZFCGRgHgO0LoIBxqXdun
         M6HR94J6UxHpxr+rZ31HXAg/gESNm1z25qgpwGD7Z+0jWNYMldnAtGqwacN1B/ufZ46U
         AYeygJ9aO+aC9PQj2cNUtx8gkmmstjQVahNZvpqtlHzh3EQjTg4fmcQWKdeyUMXSffm2
         yCbg==
In-Reply-To: <20230919045135.3635437-5-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gfs2-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, ocfs2-devel-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pankaj Raghav <p.raghav-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

On Tue, Sep 19, 2023 at 4:20=E2=80=AFPM Matthew Wilcox (Oracle) wrote:
>
> Extract this useful helper from nilfs_page_get_nth_block()
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> ---
>  fs/nilfs2/page.h            |  7 +------
>  include/linux/buffer_head.h | 22 ++++++++++++++++++++++
>  2 files changed, 23 insertions(+), 6 deletions(-)
>
> diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
> index 21ddcdd4d63e..344d71942d36 100644
> --- a/fs/nilfs2/page.h
> +++ b/fs/nilfs2/page.h
> @@ -55,12 +55,7 @@ unsigned long nilfs_find_uncommitted_extent(struct ino=
de *inode,
>  static inline struct buffer_head *
>  nilfs_page_get_nth_block(struct page *page, unsigned int count)
>  {
> -       struct buffer_head *bh =3D page_buffers(page);
> -
> -       while (count-- > 0)
> -               bh =3D bh->b_this_page;
> -       get_bh(bh);
> -       return bh;
> +       return get_nth_bh(page_buffers(page), count);
>  }
>
>  #endif /* _NILFS_PAGE_H */
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index 1001244a8941..9fc615ee17fd 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -457,6 +457,28 @@ __bread(struct block_device *bdev, sector_t block, u=
nsigned size)
>         return __bread_gfp(bdev, block, size, __GFP_MOVABLE);
>  }
>
> +/**
> + * get_nth_bh - Get a reference on the n'th buffer after this one.
> + * @bh: The buffer to start counting from.
> + * @count: How many buffers to skip.
> + *
> + * This is primarily useful for finding the nth buffer in a folio; in
> + * that case you pass the head buffer and the byte offset in the folio
> + * divided by the block size.  It can be used for other purposes, but
> + * it will wrap at the end of the folio rather than returning NULL or
> + * proceeding to the next folio for you.
> + *
> + * Return: The requested buffer with an elevated refcount.
> + */
> +static inline struct buffer_head *get_nth_bh(struct buffer_head *bh,
> +               unsigned int count)
> +{
> +       while (count--)
> +               bh =3D bh->b_this_page;
> +       get_bh(bh);
> +       return bh;
> +}
> +
>  bool block_dirty_folio(struct address_space *mapping, struct folio *foli=
o);
>
>  #ifdef CONFIG_BUFFER_HEAD
> --
> 2.40.1
>

Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Looks good to me.

Thanks,
Ryusuke Konishi
