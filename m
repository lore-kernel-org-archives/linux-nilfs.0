From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: return an ERR_PTR from __filemap_get_folio v2
Date: Thu, 30 Mar 2023 01:56:15 +0200
Message-ID: <20230329235615.GA2012@lst.de>
References: <20230121065755.1140136-1-hch@lst.de> <20230328160433.4f3dc32b480239bce9e2f9ef@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230328160433.4f3dc32b480239bce9e2f9ef-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 28, 2023 at 04:04:33PM -0700, Andrew Morton wrote:
> > Note that the shmem patches in here are non-trivial and need some
> > careful review and testing.
> 
> How are we going with the review and testing.  I assume that
> we're now OK on the runtime testing front, but do you feel that
> review has been adequate?

Yes, I think we're fine, mostly due to Hugh.  I'm a little sad about
the simplification / descoping from him, but at least we get the main
objective done.  Maybe at some point we can do another pass at
cleaning up the shmem page finding/reading mess.
