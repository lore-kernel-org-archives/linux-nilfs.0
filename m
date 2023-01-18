From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 8/9] btrfs: handle a NULL folio in
 extent_range_redirty_for_io
Date: Wed, 18 Jan 2023 17:42:47 +0100
Message-ID: <20230118164247.GC7584@lst.de>
References: <20230118094329.9553-1-hch@lst.de> <20230118094329.9553-9-hch@lst.de> <Y8gZmTFB6vCivxsY@casper.infradead.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y8gZmTFB6vCivxsY-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 18, 2023 at 04:08:57PM +0000, Matthew Wilcox wrote:
> On Wed, Jan 18, 2023 at 10:43:28AM +0100, Christoph Hellwig wrote:
> > filemap_get_folio can return NULL, skip those cases.
> 
> Hmm, I'm not sure that's true.  We have one place that calls
> extent_range_redirty_for_io(), and it previously calls
> extent_range_clear_dirty_for_io() which has an explicit
> 
>                 BUG_ON(!page); /* Pages should be in the extent_io_tree */
> 
> so I'm going to say this one can't happen either.  I haven't delved far
> enough into btrfs to figure out why it can't happen.

I'll drop this patch for now.

