From: Pankaj Raghav <p.raghav-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 02/26] mpage: Convert map_buffer_to_folio() to
 folio_create_empty_buffers()
Date: Wed, 20 Sep 2023 11:54:45 +0200
Message-ID: <20230920095428.kxlv7gplxyy7wqpb@localhost>
References: <20230919045135.3635437-1-willy@infradead.org>
        <20230919045135.3635437-3-willy@infradead.org>
        <CGME20230920095447eucas1p2fee0541ad835331ff6b4c5143122c341@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20230920095448euoutp028dcd062e5ad186acb590747c722ca1c9~GksXXQtYH1388913889euoutp02l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1695203688;
        bh=FdSyQmvYuBWOq4bw3GT24G1UfEtiREjPwKS1idfELH8=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=Ec8Eu9Iotlyy+vzC6ecrgZzOSbmNawykSDCZ2cEBLkYqnG552ZivaqgvQmFroqojZ
         0apmrP10brCQuzJWbLuDqQ/m/OCs03Y9oTFH+rTTz7yeywA47UT5brzZRjGEVW2c2j
         kJ2e6On5KmXgwTHbwVh+Jh+mUcosu6Z+XJ+n2OoA=
Content-Disposition: inline
In-Reply-To: <20230919045135.3635437-3-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gfs2-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ntfs3-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, ocfs2-devel-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, p.raghav-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org

On Tue, Sep 19, 2023 at 05:51:11AM +0100, Matthew Wilcox (Oracle) wrote:
> Saves a folio->page->folio conversion.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> ---
>  fs/mpage.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
Looks good,
Reviewed-by: Pankaj Raghav <p.raghav-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
