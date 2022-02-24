From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/fs: Remove redundant code
Date: Fri, 25 Feb 2022 02:30:40 +0900
Message-ID: <CAKFNMokx2Qk4jJx6s0vzseYRbfjejZwoDY3MnPODWhT7-_1K=g@mail.gmail.com>
References: <20220207103738.103661-1-jiapeng.chong@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YN3o5AHfbGVmbeaZUJjmbDqTCWv/jzMc3EILlut6Oww=;
        b=a1WdcUy4rP1D+h2JWaW3NZ7cj7mMuh72pwuxNzL9nm3dxxunfRyAUaKgFx/ynm5sJk
         Fb1eD1BUAyDPcJJIbAP+2TYtWC0umJJBRstjSjWNhhYYMgeLf9AwliKwI8oye4bFPRVX
         /cERCPKOAMd8igNl35lFYoXqAeAiEv5fxAii3NUBubgd4ffDG9xJuES8SyZbJbORPbyz
         Qu35wM6y4ILBESw64aV6Qg5yPH3fmmw3qsoMAUgp4NkVgt7qryVSYkLc7L3crqEnNA7H
         5wi2UDdYC8vTpVkeMgL3pw1bhWDOOFOU6OTN0oYLmJPHo1cqf+lmkaDhGf5CHGp25mPa
         avXw==
In-Reply-To: <20220207103738.103661-1-jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiapeng Chong <jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Hi Jiapeng,

On Mon, Feb 7, 2022 at 7:37 PM Jiapeng Chong
<jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
>
> Clean up the following smatch warning:
>
> fs/nilfs2/segbuf.c:358 nilfs_segbuf_submit_bio() warn: ignoring
> unreachable code.
>
> Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Signed-off-by: Jiapeng Chong <jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> ---
>  fs/nilfs2/segbuf.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
> index 9e5dd6324ea1..50d7e2e4daed 100644
> --- a/fs/nilfs2/segbuf.c
> +++ b/fs/nilfs2/segbuf.c
> @@ -341,7 +341,6 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
>                                    int mode_flags)
>  {
>         struct bio *bio = wi->bio;
> -       int err;
>
>         bio->bi_end_io = nilfs_end_bio_write;
>         bio->bi_private = segbuf;
> @@ -354,9 +353,6 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
>         wi->nr_vecs = min(wi->max_pages, wi->rest_blocks);
>         wi->start = wi->end;
>         return 0;
> -
> -       wi->bio = NULL;
> -       return err;
>  }

Sorry for my late reply.

I will send this to Andrew to report and fix the regression on the -mm
patch series.

I'd like to change the patch title to something like "nilfs2: Remove
redundant code"
since the "mm/fs" prefix does not properly represent what it applies to.
(this patch may be folded into the patch that is causing the warning)

Regards,
Ryusuke Konishi
