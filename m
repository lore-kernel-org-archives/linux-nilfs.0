From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 0/7] Convert to filemap_get_folios_contig()
Date: Mon, 15 Aug 2022 21:17:23 +0100
Message-ID: <Yvqp05w5HOVQ9qLj@casper.infradead.org>
References: <20220815185452.37447-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HkdesMUoZ61tMBtJNUxc0TT34BYc4cdbeRZcIwePCUI=; b=Gc1ER7H2A6KFPOBzMzB0DAXCiO
        gtDR0SURShm2pT7GJzeB0PGkGb1o//myUl91rYDicg47L+TIsiPpH2h9Ck5ZrwQnZ7DD7nXLk4y9c
        BfCINCjdWhJxWz9Sg8GU1zl2PGcWJRInRXMCwQhumyreUkbq5sdcJD7CY0GPIaJGDGyUhpDzFeyuJ
        nijbOOwH0IS+r5G9YFs4U1WTjmoJpdXWiHoEe1n0UpiweIwhkXxDbWfEY4TOFh6SYNkjgSKrllX6f
        IlKBf7bIjHRcYArc9DwNosV1TRtvhlGsGnNvpzDFXOZn958KvyKiyLnUYKCTvoja5mNx5iJkqwhY4
        Adt9aplw==;
Content-Disposition: inline
In-Reply-To: <20220815185452.37447-1-vishal.moola@gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Mon, Aug 15, 2022 at 11:54:45AM -0700, Vishal Moola (Oracle) wrote:
> This patch series replaces find_get_pages_contig() with
> filemap_get_folios_contig(). I've run xfstests on btrfs. I've also
> tested the ramfs changes. I ran some xfstests on nilfs2, and its
> seemingly fine although more testing may be beneficial.

These all look good to me.  I'd like to see R-b tags from the various
fs maintainers, but I intend to add this series to the folio tree for
merging in 6.1.
