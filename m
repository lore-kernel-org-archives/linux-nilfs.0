From: Keith Busch <kbusch-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 11/29] btrfs: use bdev_nr_sectors instead of open coding
 it
Date: Wed, 13 Oct 2021 19:44:38 -0700
Message-ID: <20211014024438.GG1594461@dhcp-10-100-145-180.wdc.com>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-12-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634179482;
        bh=It2mkzx6TjfzrxKa1z+glKX99V3LF5sLjb+XStt8Wuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mzz6lXM/GRSQKnipiuaTPceCHZUCG+Zwebj9V2e3D3u8BDYOSVlhmPweg8g6YiI8d
         r+FzG9sPVr+Hk4H2lOIBtjdINIDEutvPeEs53/z+5bq+4EPnsRZGELeTPAvwoMl5bY
         D5WR/vTtqwKDBMa4OMVf2PvJL0TBX8SE4EyM+00T66l6gCQbaCkFBvjZHr4BqEXJ5u
         yuO9zeVQIl48uQmyOc9Be0MLM+3GoQiZYDItlKL+q86y0ZlJKAGDhfO7K6kMaufy3f
         D7Hd7Q0saLd9aej/pORbgOIvPmwFjh+idyJi5NYgYOFIwSmTP7R1qlYbeAyhEajjn0
         kkbqUUfNjdm3A==
Content-Disposition: inline
In-Reply-To: <20211013051042.1065752-12-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, OGAWA Hirofumi <hirofumi-UIVanBePwB70ZhReMnHkpc8NsWr+9BEh@public.gmane.org>, Dave Kleikamp <shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Anton Altaparmakov <anton-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>, Konstantin Komarov <almaz.alexandrovich-m5I1DM4ARimttCpgsWEBFlaTQe2KTcn/@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Phillip Lougher <phillip-Y7wUz+saRi+tmTQ+vhA3Yw@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY@public.gmane.org

On Wed, Oct 13, 2021 at 07:10:24AM +0200, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.

Just IMO, this patch looks like it wants a new bdev_nr_bytes() helper
instead of using the double shifting sectors back to bytes.
