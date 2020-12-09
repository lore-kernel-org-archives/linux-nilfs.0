From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH] fs/nilfs2: remove some unused macros to tame gcc
Date: Thu, 10 Dec 2020 07:27:59 +0900
Message-ID: <CAKFNMonJOj07r-0y6xaF0HX6VDSvCrVNfHDek7L3Ptaui0NXFA@mail.gmail.com>
References: <1607552733-24292-1-git-send-email-konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YGUyP4undF662USfUINJVzmZEb/C1zFli+cZwzjv7lk=;
        b=pjpADPoi+ct6oasFLUM/CCiwcgqcZWe20LDJbqso6UvfBLVuWCsZkWbsSimvXwHEi8
         gcw3mwSE6CCjmiypTCsJz1xAPD8h/yL2c7+G3ircJXUOBL6ZYy9ioFmoU5w//noi5kKM
         7wkSLUcVzv3/E1VMSIhCLS3skcl9ecJ0Yt5t69MJiP2yEAoonfXmiblveF3MVPE5OfT4
         11Cb7fUFd17DGRbcCvxcdAHF5KAcdqMFmQSBdvbovuabbEFHkcScASWVMR83P5iGwyUi
         faj/VzaMf0gZ4lhZd8VIFCdPR9Ln9Wvj0Le4RfBSjAxmjjGZR/Mm9kHQggvhJT5kTAbB
         1IMQ==
In-Reply-To: <1607552733-24292-1-git-send-email-konishi.ryusuke@gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Hi Andrew,

Please queue this, a gcc warning fix, for the next merge window.

Thanks,
Ryusuke Konishi

On Thu, Dec 10, 2020 at 7:25 AM Ryusuke Konishi
<konishi.ryusuke@gmail.com> wrote:
>
> From: Alex Shi <alex.shi@linux.alibaba.com>
>
> There some macros are unused and cause gcc warning. Remove them.
>
> fs/nilfs2/segment.c:137:0: warning: macro "nilfs_cnt32_gt" is not used
> [-Wunused-macros]
> fs/nilfs2/segment.c:144:0: warning: macro "nilfs_cnt32_le" is not used
> [-Wunused-macros]
> fs/nilfs2/segment.c:143:0: warning: macro "nilfs_cnt32_lt" is not used
> [-Wunused-macros]
>
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> ---
>  fs/nilfs2/segment.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index e3726aca28ed..cd4da9535aed 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -134,14 +134,9 @@ struct nilfs_sc_operations {
>  static void nilfs_segctor_do_immediate_flush(struct nilfs_sc_info *);
>  static void nilfs_dispose_list(struct the_nilfs *, struct list_head *, int);
>
> -#define nilfs_cnt32_gt(a, b)   \
> -       (typecheck(__u32, a) && typecheck(__u32, b) && \
> -        ((__s32)(b) - (__s32)(a) < 0))
>  #define nilfs_cnt32_ge(a, b)   \
>         (typecheck(__u32, a) && typecheck(__u32, b) && \
>          ((__s32)(a) - (__s32)(b) >= 0))
> -#define nilfs_cnt32_lt(a, b)  nilfs_cnt32_gt(b, a)
> -#define nilfs_cnt32_le(a, b)  nilfs_cnt32_ge(b, a)
>
>  static int nilfs_prepare_segment_lock(struct super_block *sb,
>                                       struct nilfs_transaction_info *ti)
> --
> 1.8.3.1
>
