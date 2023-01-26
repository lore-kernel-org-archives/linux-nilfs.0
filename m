From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 7/7] mm: return an ERR_PTR from __filemap_get_folio
Date: Fri, 27 Jan 2023 02:24:29 +0900
Message-ID: <CAKFNMonfM+=1vbqKgS3feW7Xyh=P6UdDu0RrnOYQrb+WhN+_Vw@mail.gmail.com>
References: <20230121065755.1140136-1-hch@lst.de> <20230121065755.1140136-8-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qHlmTunQ49C1Dpyk77Z4C3k4Cau4j+Xb//Hx9WL7A8k=;
        b=FcVVUD0R+CepEE82KTwR5p856vdMWJsT8H3faHwVqVudmDdIF4Lcfrg/SHWvuzVpWF
         KA1kLRC9qaFiYMLpexmhNHDdgVJLefzkTqzrfB096e/Nh7scJpPIASgZfXzCCsgbBObo
         BTqxf3peJlRY1R6MhO6OJbfFx0Fc5aAcwVL0v0vA9EkBPvf6OfaJbVZgOVqaqXDtAmd+
         bLwYoW1Us2QDe+hiDLMCAN7ceajba131vdEy/eZtQwB7bSeqLgQdh+6Q6+S2vwIvhii5
         yyOMBLagGZW37aZdWToQMqAEtPdoBK0EhksXhUNvoEWT6160ijCRlx0xf8Wmnr7UcnYZ
         WzAQ==
In-Reply-To: <20230121065755.1140136-8-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jan 21, 2023 at 3:59 PM Christoph Hellwig wrote:
>
> Instead of returning NULL for all errors, distinguish between:
>
>  - no entry found and not asked to allocated (-ENOENT)
>  - failed to allocate memory (-ENOMEM)
>  - would block (-EAGAIN)
>
> so that callers don't have to guess the error based on the passed
> in flags.
>
> Also pass through the error through the direct callers:
> filemap_get_folio, filemap_lock_folio filemap_grab_folio
> and filemap_get_incore_folio.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---

For

>  fs/nilfs2/page.c         |  6 +++---

Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks,
Ryusuke Konishi
