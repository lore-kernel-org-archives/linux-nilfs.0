From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 14/26] nilfs2: Remove nilfs_page_get_nth_block
Date: Wed, 20 Sep 2023 17:15:04 +0900
Message-ID: <CAKFNMo=uGWNL5pe7JK7-GBKR1L6tsxmtRH5+p4mPrri=CeJXUw@mail.gmail.com>
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-15-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695197720; x=1695802520; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zJxfyTLNGZAN0qgRxWWT6/oteEKQT8o70eVgdNPEM/Q=;
        b=W3K/TtSTcbvKR+NvbcejazPc9kT8dK63WflJYDO+b4vA7ff2tb+wPc+mlanVsMtx4y
         cWd1rdr79v4ZqozAM4ryKxJYvJgznzK/C5XmD7OgTtly/vesk4Mq8MjeXpQUG2K69fAQ
         Fqa4V60XBOQ2/R7W6qsNtCx1mRG4q000I0Z7GcD9Q8iqFZ0bOnPUEy38j83TKNTbQwtQ
         nPBQOUO/O9NNS67uGIJggCeVYdt5DKhm66Cv262kUYKHwQ5hBJ8mHmS4nl5c78Yoox9Q
         IB777So51vxiXB/ivTL9uNPUeTidvII4VDgfxAwhU83/PHJXQRvnm+GrvVINZ5fagUge
         CWIA==
In-Reply-To: <20230919045135.3635437-15-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gfs2-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, ocfs2-devel-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pankaj Raghav <p.raghav-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

On Tue, Sep 19, 2023 at 3:47=E2=80=AFPM Matthew Wilcox (Oracle) wrote:
>
> All users have now been converted to get_nth_block().
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> ---
>  fs/nilfs2/page.h | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
> index 344d71942d36..d249ea1cefff 100644
> --- a/fs/nilfs2/page.h
> +++ b/fs/nilfs2/page.h
> @@ -52,10 +52,4 @@ unsigned long nilfs_find_uncommitted_extent(struct ino=
de *inode,
>  #define NILFS_PAGE_BUG(page, m, a...) \
>         do { nilfs_page_bug(page); BUG(); } while (0)
>
> -static inline struct buffer_head *
> -nilfs_page_get_nth_block(struct page *page, unsigned int count)
> -{
> -       return get_nth_bh(page_buffers(page), count);
> -}
> -
>  #endif /* _NILFS_PAGE_H */
> --
> 2.40.1
>

Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks,
Ryusuke Konishi
