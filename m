From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] fs/nilfs2: fix misspellings using codespell tool
Date: Mon, 22 Mar 2021 22:53:31 +0900
Message-ID: <CAKFNMo=ME1jw3ZexLjP4MkU3AzHJebjiDB+WhZ_25CTYdm6C8g@mail.gmail.com>
References: <20210318113233.473329-1-liu.xuzhi@zte.com.cn>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jX+u5Il9FFhVYVkW7pqj87Zsgj9Bh++s3plZJeOI0WY=;
        b=hk+rgIeZOPySzG9QtpoGzMDEqiX2FMsNn4x3rUJDuDx5L2WaUSALAlEamYlUEaQlgb
         122ANDd3eRDzVT0Ts0BLOM7Kvva6Cm5e+WuyM/8bx8PYu7yjkDLnodqUYR9sy2KAdqkv
         4RC8BV3lJWIfECmh7BjSvJYNiX8+dwm2unJAYl+vj2Fe+yg9gMxTD3U6n2nTnj+gYJoK
         KCtJ+n7uFUIqqM1LMeXqUqXpO2oTFskbTdFqn2dOd4dFwGlcZOIBO0eJMp5nraY0wWWk
         7HekceiaqNoc/nduHmntKFQ/MaUqqOmdYumClqvAQhKhjZQlORZPCgMIW3AtqisExNpB
         /Adw==
In-Reply-To: <20210318113233.473329-1-liu.xuzhi-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: menglong8.dong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liu xuzhi <liu.xuzhi-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

Applied, thank you.

Ryusuke Konishi

On Thu, Mar 18, 2021 at 8:32 PM <menglong8.dong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> From: Liu xuzhi <liu.xuzhi-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
>
> Two typos are found out by codespell tool \
> in 2217th and 2254th lines of segment.c:
>
> $ codespell ./fs/nilfs2/
> ./segment.c:2217 :retured  ==> returned
> ./segment.c:2254: retured  ==> returned
>
> Fix two typos found by codespell.
>
> Signed-off-by: Liu xuzhi <liu.xuzhi-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> ---
>  fs/nilfs2/segment.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index cd4da9535aed..686c8ee7b29c 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -2214,7 +2214,7 @@ static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err)
>   * nilfs_construct_segment - construct a logical segment
>   * @sb: super block
>   *
> - * Return Value: On success, 0 is retured. On errors, one of the following
> + * Return Value: On success, 0 is returned. On errors, one of the following
>   * negative error code is returned.
>   *
>   * %-EROFS - Read only filesystem.
> @@ -2251,7 +2251,7 @@ int nilfs_construct_segment(struct super_block *sb)
>   * @start: start byte offset
>   * @end: end byte offset (inclusive)
>   *
> - * Return Value: On success, 0 is retured. On errors, one of the following
> + * Return Value: On success, 0 is returned. On errors, one of the following
>   * negative error code is returned.
>   *
>   * %-EROFS - Read only filesystem.
> --
> 2.25.1
>
