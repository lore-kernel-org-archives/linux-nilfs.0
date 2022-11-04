From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 04/23] page-writeback: Convert write_cache_pages() to use
 filemap_get_folios_tag()
Date: Fri, 4 Nov 2022 20:06:49 +0000
Message-ID: <Y2Vw2UBkti7MeG5U@casper.infradead.org>
References: <20220901220138.182896-1-vishal.moola@gmail.com>
 <20220901220138.182896-5-vishal.moola@gmail.com>
 <20221018210152.GH2703033@dread.disaster.area>
 <Y2RAdUtJrOJmYU4L@fedora>
 <20221104003235.GZ2703033@dread.disaster.area>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=s2O/qvDFRXf6wsYKSZLjcNGb+D8yn522RgYWCb7F9IA=; b=GtnDjMYQ5z4Z0YK9fPQqghVAUu
        S1NnClGtXQ3weaDOyQ9V0+0Pia32moBZqAjUYqkInOBGfZeixA7s3fZHLaEqsaXw7xHFxvuj7Bk2D
        NGp2vaLcYpNUIXvducZ7V1dGW0tYCtdUikNkvwwd0nwwxQ2w6UAsvh2cvrULg6KAH8QmFp7WA2c2t
        AZc9EHn3KODznyd/NQ3mZ8pYJ2EjOwTOoAkuCzZ9oZmGEy5PBpIJLR/l0lQMr9fYyRC55QvSOvYxC
        AH/s8bS6XlEJM43lfJ6ozC36C89WNlhsRSaVoZT4F4UNLptNZsF/H6SfN7ucyrFXy4U6Q8jCS/It+
        hkGNj1Ng==;
Content-Disposition: inline
In-Reply-To: <20221104003235.GZ2703033@dread.disaster.area>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: Vishal Moola <vishal.moola@gmail.com>, linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, linux-mm@kvack.org

On Fri, Nov 04, 2022 at 11:32:35AM +1100, Dave Chinner wrote:
> At minimum, it needs to be documented, though I'd much prefer that
> we explicitly duplicate write_cache_pages() as write_cache_folios()
> with a callback that takes a folio and change the code to be fully
> multi-page folio safe. Then filesystems that support folios (and
> large folios) natively can be passed folios without going through
> this crappy "folio->page, page->folio" dance because the writepage
> APIs are unaware of multi-page folio constructs.

There are a lot of places which go through the folio->page->folio
dance, and this one wasn't even close to the top of my list.  That
said, it has a fairly small number of callers -- ext4, fuse, iomap,
mpage, nfs, orangefs.  So Vishal, this seems like a good project for you
to take on next -- convert write_cache_pages() to write_cache_folios()
and writepage_t to write_folio_t.
