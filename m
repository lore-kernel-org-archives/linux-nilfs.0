From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 9/9] mm: return an ERR_PTR from __filemap_get_folio
Date: Wed, 18 Jan 2023 17:42:08 +0100
Message-ID: <20230118164208.GA7584@lst.de>
References: <20230118094329.9553-1-hch@lst.de> <20230118094329.9553-10-hch@lst.de> <CAKFNMomcjvUSh-nS1MqptYdiT-1frRsmHgx2mHBBm_588kprrQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKFNMomcjvUSh-nS1MqptYdiT-1frRsmHgx2mHBBm_588kprrQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 18, 2023 at 09:39:08PM +0900, Ryusuke Konishi wrote:
> > Also pass through the error through the direct callers:
> 
> > filemap_get_folio, filemap_lock_folio filemap_grab_folio
> > and filemap_get_incore_folio.
> 
> As for the comments describing the return values of these callers,
> isn't it necessary to rewrite the value from NULL in case of errors ?

Yes, thanks for catching this.
