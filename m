From: Pankaj Raghav <p.raghav-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 01/26] buffer: Make folio_create_empty_buffers() return
 a buffer_head
Date: Wed, 20 Sep 2023 11:39:50 +0200
Message-ID: <20230920093950.b6lyvcs2tz22po3y@localhost>
References: <20230919045135.3635437-1-willy@infradead.org>
        <20230919045135.3635437-2-willy@infradead.org>
        <CGME20230920093952eucas1p1f37c688dc553d6a85882cae29861a870@eucas1p1.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20230920093953euoutp0100f268fab0abcf5ee17d40836f7daba0~GkfWTxGwk1220212202euoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1695202793;
        bh=8FReEKvP2/9isPLe8nU44iPC4r0J6E6Ai2YqflXjyCw=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=uaT+CpPyHBwpdMTbYTG9qjqIoJ4UjIlkSvhYzSUimcVVo9AJql9kekFLgl5327hHh
         ygOlYrCF+RHeFYZ6AABShpEMUEqTaJanfheZ26NoUsEe7TmmlqriAXfYygmxVFdmXA
         HaefDCueGx1VstS842F9y1awIj3Ars2LP4C4JJyk=
Content-Disposition: inline
In-Reply-To: <20230919045135.3635437-2-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gfs2-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, ocfs2-devel-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, p.raghav-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org

On Tue, Sep 19, 2023 at 05:51:10AM +0100, Matthew Wilcox (Oracle) wrote:
> Almost all callers want to know the first BH that was allocated
> for this folio.  We already have that handy, so return it.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> ---
>  fs/buffer.c                 | 24 +++++++++++++-----------
>  include/linux/buffer_head.h |  4 ++--
>  2 files changed, 15 insertions(+), 13 deletions(-)
> 
Looks good,
Reviewed-by: Pankaj Raghav <p.raghav-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
