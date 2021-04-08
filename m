From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] fs/nilfs2: fix misspellings using codespell tool
Date: Thu, 8 Apr 2021 15:47:10 +0900
Message-ID: <CAKFNMo=Pd-fkOKrm3ZQgL6jA2iN2NJxwh5mo8nyTGiJq71U7UA@mail.gmail.com>
References: <1617864087-8198-1-git-send-email-konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nphmCcntRGma7inIbTUmWNDHxfjKITyrJ8Vf6cW0g1U=;
        b=lHsCNTqq0wjqAGuzBK0ezoBsFkOj0C2h4k8mqESzURrJy7j81Vw2SZW47yEOqpPMsy
         RxyQQwIvXRm1+QuuqkeWIoOpgxoTSRPSlk1WJnbGx0gVfftUhFA2BZqb1XrcGlN5UEFr
         7Zd31Ifcxe0Tg85PtbTR2dXYjnnrPMkM0BzntpsBMMPghQsIo5Kl5GT/RFYYTwJVQhsN
         dFGdrfmc3n/bz1qx2PKqWcWmZ7U6bx/+ULPOa/YulS2Xsb8KdP/umONq2DCC+rtiUiyS
         BbHd258esJRUUbNsfyJW5XNZVMitqo1aTcNABxEpsMxc5nxSPnh6o3sQ9/vPXJ4CoS2A
         B+kg==
In-Reply-To: <1617864087-8198-1-git-send-email-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Andrew,

Please queue this typo fix for the next merge window.

Thank you,
Ryusuke Konishi

On Thu, Apr 8, 2021 at 3:41 PM Ryusuke Konishi
<konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
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
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
> 1.8.3.1
>
