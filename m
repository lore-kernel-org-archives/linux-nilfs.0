From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: return an ERR_PTR from __filemap_get_folio v2
Date: Sun, 22 Jan 2023 08:20:06 +0100
Message-ID: <20230122072006.GA3654@lst.de>
References: <20230121065755.1140136-1-hch@lst.de> <20230121170641.121f4224a0e8304765bb4738@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230121170641.121f4224a0e8304765bb4738-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jan 21, 2023 at 05:06:41PM -0800, Andrew Morton wrote:
> This patchset doesn't apply to fs/btrfs/ because linux-next contains
> this 6+ month-old commit:

Hmm.  It was literally written against linux-next as of last morning,
which does not have that commit.
