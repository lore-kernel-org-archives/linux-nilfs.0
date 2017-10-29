From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs-utils: Fix conflicting data buffer error
Date: Mon, 30 Oct 2017 01:00:44 +0900
Message-ID: <CAKFNMomK6G4omaf9nH=GX4rwEn4of15bpX7Yy6to7MY6D+BKKQ@mail.gmail.com>
References: <20171029141052.8521-1-andreas.rohner@gmx.net>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=2MsX0kY7VbNtNKsCySMIaVEMgHwJKBFKEH/qI3LFtJs=;
        b=II913QTjRaG2L4j0UwTfqbxY7IHsm2cmxXHhPSyIKWgihV8Cz+8j2eAYtJxYfXn2Lh
         LP0D5CQibYkPor5Z+d244SDw0UWAgXJsXksBGvp0Av+FUORYSq80PGbNSUYfjCMBqa6f
         IM+XJLR02ksVTK33pT+Yg/RXDvMF1odulUysBkMDoYnLldkXb0dT/owFZL9b6r9IJHnk
         JwtXVTfphr8fnX5akHvbPl70sRZOygh5Tvh9bMgleb6iGw5upmrW2+NH43WbFloCLZ05
         a3LR6Tdrpfrj5Uy55A+MZ6DQJv6ncwpJXujZIqohGotLKalTZlK+vOnE6Qh6jJQ8mBst
         G6Hg==
In-Reply-To: <20171029141052.8521-1-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

2017-10-29 23:10 GMT+09:00 Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>:
> Under certain high concurrency loads, NILFS2 can produce a segment that
> crashes the cleanerd process with a conflicting data buffer error. The
> segment is perfectly valid and the file system is not corrupted.
> However, the cleanerd process can no longer be started and the file
> system will eventually fill up and cannot be used any more.
>
> The reason for this crash is, that a single logical segment can contain
> multiple partial segments. If a block is written in one partial segment
> and then immediately overwritten in another partial segment, then these
> blocks have the same inode number, checkpoint number and offset.
> However, these three numbers are used by the kernel to uniquely
> identify a block. If the cleaner tries to clean two blocks that point
> to the exact same buffer_head in the kernel, it creates a conflicting
> data buffer error.
>
> The solution is to detect these blocks and treat them as dead blocks.
> If vd_period.p_end is equal to the checkpoint number, it means that the
> block was overwritten within the same logical segment. So it must be
> dead, and there is another block with the same ino, cno, and offset,
> which is alive.
>
> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Applied.  Thank you!

Ryusuke Konishi

> ---
>  lib/gc.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/lib/gc.c b/lib/gc.c
> index 5e14443..9449352 100644
> --- a/lib/gc.c
> +++ b/lib/gc.c
> @@ -433,6 +433,19 @@ static int nilfs_vdesc_is_live(const struct nilfs_vdesc *vdesc,
>                 return vdesc->vd_period.p_end == NILFS_CNO_MAX;
>         }
>
> +       if (vdesc->vd_period.p_end == vdesc->vd_cno) {
> +               /*
> +                * This block was overwritten in the same logical segment, but
> +                * in a different partial segment. Probably because of
> +                * fdatasync() or a flush to disk.
> +                * Without this check, gc will cause buffer confliction error
> +                * if both partial segments are cleaned at the same time.
> +                * In that case there will be two vdesc with the same ino,
> +                * cno and offset.
> +                */
> +               return 0;
> +       }
> +
>         if (vdesc->vd_period.p_end == NILFS_CNO_MAX ||
>             vdesc->vd_period.p_end > protect)
>                 return 1;
> --
> 2.14.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
