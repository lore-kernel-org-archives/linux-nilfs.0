From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 03/10] ext4: Convert mpage_release_unused_pages() to use
 filemap_get_folios()
Date: Wed, 8 Jun 2022 20:55:06 -0700
Message-ID: <YqFvGgKTyGPxStkx@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
 <20220605193854.2371230-4-willy@infradead.org>
 <YqBXjjkRZsP8K8fO@infradead.org>
 <YqDIIH2d7iu1o7D0@casper.infradead.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0YPt1S1jhSTaWf/8ZoCL0bFChcDXSklVsTmgZM2rLiI=; b=Dl8JGvKpB6vphg8GJGusCTANit
        1GxyGnn679NvRWS0MV6dl/ia8FXbFkazmnr+IDjn5zzr3og7XZfjMLZjWL06OF3evRoMrBFjxFrsx
        Htg+vfwV+x7T9mmYPRX8P6cJKrK8y0bBndusBU0lXk/KdOK8xByq3REx/zxGsoZUuF/x5DHkNPje8
        NDEHhrWuv4dfciQdbKDCDBmbUI7HxHBS2K/veQeFd3r7wooBpR0eTx87J+TG8yrH1ANVnPBJkU+b9
        h1sAP8J3H9vbFRWHN3eOBnx3OSPTyjl+SZp0lSY+nu4GUzBF+V4Qw/fg17+wG32FZfTnYTo9p6g96
        gaHUWy6g==;
Content-Disposition: inline
In-Reply-To: <YqDIIH2d7iu1o7D0-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jun 08, 2022 at 05:02:40PM +0100, Matthew Wilcox wrote:
> On Wed, Jun 08, 2022 at 01:02:22AM -0700, Christoph Hellwig wrote:
> > On Sun, Jun 05, 2022 at 08:38:47PM +0100, Matthew Wilcox (Oracle) wrote:
> > > If the folio is large, it may overlap the beginning or end of the
> > > unused range.  If it does, we need to avoid invalidating it.
> > 
> > It's never going to be larger for ext4, is it?  But either way,
> > those precautions looks fine.
> 
> I don't want to say "never".  Today, it's not, but if ext4 ever does
> gain support for large folios, then this is a precaution it will need
> to take.  I'm trying not to leave traps when I do conversions.

FYI, this wasn't an objection to the patch, just a hint that the commit
log could spell this out a bit better.

