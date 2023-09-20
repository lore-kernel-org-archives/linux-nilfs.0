From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 15/26] nilfs2: Convert nilfs_lookup_dirty_data_buffers to
 use folio_create_empty_buffers
Date: Wed, 20 Sep 2023 19:01:20 +0900
Message-ID: <CAKFNMonL+TobLB6e6g0kKQsGY0-FP1fkQyuNQKqS8+B-QH4qig@mail.gmail.com>
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-16-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695204097; x=1695808897; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W2Sxc2lzUzNR93PpRUd+yVO8Zh7S3vyEBNQBpNy/0XM=;
        b=nAIewok8Jz4uPNzrk5L5OdNdqKLfqMiMI6qHZXaKSFvdbq123fGQyOYG0RXfm++m/1
         3JjCXqpoMC85ym+PhL2l/JMYVwA+zVNV2PBR/StsG66Sq3y/IMsGUVvt/+/uzqKI9A+6
         0Yi5B3KcgMhzNbalG9yQyYgQpM8vqsSRNORaE1cd3798JYRmEriwoOACwvPe4hNkyFNn
         /wFjqzn0C0JRWs7CLlOWNaBY8HXVWaE1Ju4aBSogR1+ed4dnxkJkzVmX1Ih29GFMtoue
         Ln80b+TeysRDKz/alh3/lA2ouGnSyMQDPP4AHG2FNN+CHEW/Scx+TlyZGqSmHK+LGg9S
         tvWg==
In-Reply-To: <20230919045135.3635437-16-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gfs2-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, ocfs2-devel-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pankaj Raghav <p.raghav-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

On Tue, Sep 19, 2023 at 3:47=E2=80=AFPM Matthew Wilcox (Oracle) wrote:
>
> This function was already using a folio, so this update to the new API
> removes a single folio->page->folio conversion.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> ---
>  fs/nilfs2/segment.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 7ec16879756e..94388fe83cf8 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -731,10 +731,9 @@ static size_t nilfs_lookup_dirty_data_buffers(struct=
 inode *inode,
>                         continue;
>                 }
>                 head =3D folio_buffers(folio);
> -               if (!head) {
> -                       create_empty_buffers(&folio->page, i_blocksize(in=
ode), 0);
> -                       head =3D folio_buffers(folio);
> -               }
> +               if (!head)
> +                       head =3D folio_create_empty_buffers(folio,
> +                                       i_blocksize(inode), 0);
>                 folio_unlock(folio);
>
>                 bh =3D head;
> --
> 2.40.1
>

Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Now, I've seen all the changes to nilfs2 including the last patch.
It's almost a direct conversion throughout, and I don't see any issues
with the nilfs2 part other than the build issue.

With all 26 patches applied, nilfs2 is running without problems in
actual machine tests including stress tests.

Thank you very much for your efforts.

Regards,
Ryusuke Konishi
