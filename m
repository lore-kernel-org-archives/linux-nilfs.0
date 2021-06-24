From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs2: remove redundant continue statement in a while-loop
Date: Fri, 25 Jun 2021 03:03:56 +0900
Message-ID: <CAKFNMomwWvymBdEwimc+6yN+5us_jzgG1jwL_O195Nb-rLy6Lw@mail.gmail.com>
References: <1624557664-17159-1-git-send-email-konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RwwTqy9WZmZQciKQh7A9H8bIJRJaZla64xhE8H4bFtQ=;
        b=baLYbSHdhLQ7dT6qyUtsUpHdvn3BMEqkmTKpRgcqyPPAvGdIgdR7x6HIEpR31P3jvQ
         WlecXxHrM0+wCrStLNePaxFjpF1JrdpHBg7eD2CSvZfSSWqMBHq2TX5MJ09yWuktpct1
         PITc65ekmSOg/nMRITmztBbJWeVyTAQCHX18frKKiTle2tXFMNjba370ZtMserCVSZv1
         RlbNxkh5o8SgNUC8xm6RkJDjePFh+QV8JDWFHm2RWvf/O9m/eFwkaw5wbompvxF8nCuw
         cImq6zIptgTzQa8xC1YyMaOQz1h8l3qcVYaK3/27zLLFnjEjeptcrtY0vw2yMv5jQBhK
         tbWA==
In-Reply-To: <1624557664-17159-1-git-send-email-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Andrew,

Please queue this for the next merge window.

Thank you,
Ryusuke Konishi

On Fri, Jun 25, 2021 at 3:01 AM Ryusuke Konishi
<konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>
> The continue statement at the end of the while-loop is redundant,
> remove it.
>
> Addresses-Coverity: ("Continue has no effect")
> Link: https://lkml.kernel.org/r/20210621100519.10257-1-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org
> Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/nilfs2/btree.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> index f42ab57201e7..ab9ec073330f 100644
> --- a/fs/nilfs2/btree.c
> +++ b/fs/nilfs2/btree.c
> @@ -738,7 +738,6 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *btree,
>                         if (ptr2 != ptr + cnt || ++cnt == maxblocks)
>                                 goto end;
>                         index++;
> -                       continue;
>                 }
>                 if (level == maxlevel)
>                         break;
> --
> 1.8.3.1
>
