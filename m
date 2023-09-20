From: Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH 03/26] ext4: Convert to folio_create_empty_buffers
Date: Wed, 20 Sep 2023 12:00:11 +0200
Message-ID: <20230920100011.zpzagd35gjpn5gzu@localhost>
References: <20230919045135.3635437-1-willy@infradead.org>
        <20230919045135.3635437-4-willy@infradead.org>
        <CGME20230920100012eucas1p1f44530cfdd1ff8ed668bfe0c088d31ce@eucas1p1.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <reiserfs-devel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20230920100013euoutp019e35a00542dd22671143d96bfd6e2103~GkxGDa8iJ0504805048euoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1695204013;
        bh=JtBYsHN8h541EBRzlr1y0mzkDzP9gFTfHIXNRWvnYrs=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=a0rXS9PnsBLdcAai9TRqkGdfrEGllNHbHgiYLk7bd3A6pTWFBb8gx+laef0ZRAuGV
         9dbFEh1ZcT2rUKoh2c8kXxM/FJYs5OBNT1v9UmYQtDDfxaV9tmE7J0lVkL3Y67rf+L
         idzp0179QVhAN7/4t5jzIBZqyesURL/TSgQ1CM44=
Content-Disposition: inline
In-Reply-To: <20230919045135.3635437-4-willy@infradead.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org, p.raghav@samsung.com

On Tue, Sep 19, 2023 at 05:51:12AM +0100, Matthew Wilcox (Oracle) wrote:
> Remove an unnecessary folio->page->folio conversion and take advantage
> of the new return value from folio_create_empty_buffers().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/ext4/inode.c       | 14 +++++---------
>  fs/ext4/move_extent.c | 11 +++++------
>  2 files changed, 10 insertions(+), 15 deletions(-)
> 
I had a similar cleanup that I sent a while ago:
https://lore.kernel.org/linux-ext4/20230512125243.73696-1-p.raghav@samsung.com/

Looks good,
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
