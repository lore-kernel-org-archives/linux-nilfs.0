From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH] nilfs2: remove redundant pointer sbufs
Date: Wed, 29 Dec 2021 02:37:53 +0900
Message-ID: <CAKFNMo=7eaneb6oeCECZ-p-N=ZuANtpZEsseBtx_pBumo2GW4g@mail.gmail.com>
References: <1640712476-15136-1-git-send-email-konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0iA2h+wer53P6FVdsWUB/3fyhSEZS9hzOIF1Qivilbk=;
        b=hw9yKAdgPw32JhUrnTtpeh7k8wj0alJVyY9un/DAdKvfPsIIQPUO1M/ZJtTHHKAGTL
         1udXmC1zDfiep2LU6yggAHy5QxESq3X63XJYIhqTbz8gjwEmJzevAETt42+WDqwG4/nQ
         qPTFKc/yhFKtd59prJsQZgOUAEAHvUMMTrxeaKQUjZx6Nkzxq7J3UhtiprV/NXTQ6dv7
         rvpjwDcToOfS29ZWdizzZifFuyiiRspP6TNvyKCDAQm8cofQ5qljoPbXbHbV9Pvogm9u
         roXY0cE90yagFRy45cKKAYOd72E60U/Xrm40aSJS/FM9NW3ZncVMkoFyHsG/RVyzrYkd
         Tz2Q==
In-Reply-To: <1640712476-15136-1-git-send-email-konishi.ryusuke@gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Hi Andrew,

Please queue this for the next merge window.

Thank you,
Ryusuke Konishi

On Wed, Dec 29, 2021 at 2:27 AM Ryusuke Konishi
<konishi.ryusuke@gmail.com> wrote:
>
> From: Colin Ian King <colin.i.king@gmail.com>
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
> Link: https://lkml.kernel.org/r/20211211180955.550380-1-colin.i.king@gmail.com
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
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
> 1.8.3.1
>
