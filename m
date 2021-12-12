From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: remove redundant pointer sbufs
Date: Mon, 13 Dec 2021 00:51:34 +0900
Message-ID: <CAKFNMokO9CA6n2veR9JOg7CbzvgUc6rDMofOu2aiU+CDTTsjoA@mail.gmail.com>
References: <20211211180955.550380-1-colin.i.king@gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OsLzc8H+GZEt3KOwearXOutXvaRaNgkbn2EA2Jl4464=;
        b=KDWtFqtVrDLPXuAZeJTCfEBgi9b6C9o1WUBoeqQJPNll8R7RqeiIXYme+HYIcZwRl5
         xuiBKE8NCR5em7CAw6IkndCTXAstCwQwDzBHnzyR2+bKkxdL3rTBO0JnyVk5OEQ8J9tj
         GjVDBWW8opJY6wwkezB9q2uzoqh8+hPefxKDY+ZoNJ2Qk+nNWHA6krz23vfJYUGS82HD
         8fXGkmXQeES/Y3Rei1pRGx+5AZ41Wq9p9qaomIrLfBcjyQOT6kVyigmz8mPUdvhubsRr
         kcbM/HyNddgRUDB0ubswOMBYTHye6FBh27T3Ioe7RlstJw05zr2RXcImAnwe+39LJ+eR
         0zug==
In-Reply-To: <20211211180955.550380-1-colin.i.king-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Colin Ian King <colin.i.king-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sun, Dec 12, 2021 at 3:09 AM Colin Ian King <colin.i.king-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Pointer sbufs is being assigned a value but it's not being used
> later on. The pointer is redundant and can be removed. Cleans up
> scan-build static analysis warning:
>
> fs/nilfs2/page.c:203:8: warning: Although the value stored to 'sbufs'
> is used in the enclosing expression, the value is never actually read
> from 'sbufs' [deadcode.DeadStores]
>         sbh = sbufs = page_buffers(src);
>
> Signed-off-by: Colin Ian King <colin.i.king-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Looks good.
Will apply, thank you.

Ryusuke Konishi

> ---
>  fs/nilfs2/page.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index bc3e2cd4117f..063dd16d75b5 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -195,12 +195,12 @@ void nilfs_page_bug(struct page *page)
>   */
>  static void nilfs_copy_page(struct page *dst, struct page *src, int copy_dirty)
>  {
> -       struct buffer_head *dbh, *dbufs, *sbh, *sbufs;
> +       struct buffer_head *dbh, *dbufs, *sbh;
>         unsigned long mask = NILFS_BUFFER_INHERENT_BITS;
>
>         BUG_ON(PageWriteback(dst));
>
> -       sbh = sbufs = page_buffers(src);
> +       sbh = page_buffers(src);
>         if (!page_has_buffers(dst))
>                 create_empty_buffers(dst, sbh->b_size, 0);
>
> --
> 2.33.1
>
