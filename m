From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 03/10] ext4: Convert mpage_release_unused_pages() to use
 filemap_get_folios()
Date: Wed, 8 Jun 2022 17:02:40 +0100
Message-ID: <YqDIIH2d7iu1o7D0@casper.infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-4-willy@infradead.org>
 <YqBXjjkRZsP8K8fO@infradead.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JYL5LzwJMvkTknN2K06oEaqVJPOmxsFkjiVJNTycVrw=; b=X+I1FhaXH6WS4+ZGaHmjXumtnF
        hSMv1wP/ojs80wam+20Lk7FXy18+7BcczL5HefwpYesKkTphZ1xvan83qkGvXvbh1X1hcfU4CYk+3
        a8IhuvNpYCyrYbi/279R8dZs9dPVbn7b0rkDGr1JfKpud+bH/f/7KCuDr0VrxNhUfV1UdTGe/Exrp
        bdjE400FzSvqmUVCnGHFO59IlhUWLZPlD33Eh4sWfaa45ILPYlUY7CwO2mDsrpL1ilaXKfGB/Kt0I
        tAKJeNKT5w2M4QSVh/EDJ92w5JF6VHLuksFN5sICMhG7SlEO5/KMmexF9zTbYI2fuNTkUefBjh9O4
        45XHM6Bw==;
Content-Disposition: inline
In-Reply-To: <YqBXjjkRZsP8K8fO-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jun 08, 2022 at 01:02:22AM -0700, Christoph Hellwig wrote:
> On Sun, Jun 05, 2022 at 08:38:47PM +0100, Matthew Wilcox (Oracle) wrote:
> > If the folio is large, it may overlap the beginning or end of the
> > unused range.  If it does, we need to avoid invalidating it.
> 
> It's never going to be larger for ext4, is it?  But either way,
> those precautions looks fine.

I don't want to say "never".  Today, it's not, but if ext4 ever does
gain support for large folios, then this is a precaution it will need
to take.  I'm trying not to leave traps when I do conversions.

> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
