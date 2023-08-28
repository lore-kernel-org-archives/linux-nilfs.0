From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 0/29] block: Make blkdev_get_by_*() return
	handle
Date: Mon, 28 Aug 2023 07:27:36 -0700
Message-ID: <ZOyu2FX7Fmzj6JJz@infradead.org>
References: <20230810171429.31759-1-jack@suse.cz>
	<20230825015843.GB95084@ZenIV>
	<20230825134756.o3wpq6bogndukn53@quack3>
	<20230826022852.GO3390869@ZenIV>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309;
	h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uSnxqZdcrAYLPJPn0DfMY9X2iPdkTMayza8iox8Bem8=;
	b=rbTi8dih1WwPPGr+ioF2zSIKKN
	0mmMd7Mf6Y5CF6A3xbL6k1rG0Eq5PWNYD84YkTP/PYD6I8n7fwj9JtPf3x5xfflk7Of9PmT6yVoWg
	jDUfTlhnUqF1ibZ6C9C5Qp1FAcJBPSA1UYGVoKPgYhWBRS4hFyN/qulLfky0u5g5JfBjJuWo9rAVd
	OmVBPYeBaMmY44rW3+ehZ8vQr36snspggxlo5N+wQ2MnsZOlSw7LhANyJrm+6WDGYJ2q3IlcmhpsD
	alE6KXAxYfEVAogHtFQTNBnQoXb84wJ9x/IDWMwjf/34MizydIM1onWP9QQVyidEc4XNREZoED++f
	uj07NLVA==;
Content-Disposition: inline
In-Reply-To: <20230826022852.GO3390869@ZenIV>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Dave Kleikamp <shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Joseph Qi <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, Gao Xiang <xiang-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christian Borntraeger <borntraeger-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sven Schnelle <svens-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Snitzer <snitzer-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joern Engel <joern-o6zPIXG8fmPj4SYmN/TMmA@public.gmane.org>, re

On Sat, Aug 26, 2023 at 03:28:52AM +0100, Al Viro wrote:
> I mean, look at claim_swapfile() for example:
>                 p->bdev = blkdev_get_by_dev(inode->i_rdev,
>                                    FMODE_READ | FMODE_WRITE | FMODE_EXCL, p);
>                 if (IS_ERR(p->bdev)) {
>                         error = PTR_ERR(p->bdev);
>                         p->bdev = NULL;
>                         return error;
>                 }
>                 p->old_block_size = block_size(p->bdev);
>                 error = set_blocksize(p->bdev, PAGE_SIZE);
>                 if (error < 0)
>                         return error;
> we already have the file opened, and we keep it opened all the way until
> the swapoff(2); here we have noticed that it's a block device and we
> 	* open the fucker again (by device number), this time claiming
> it with our swap_info_struct as holder, to be closed at swapoff(2) time
> (just before we close the file)

Note that some drivers look at FMODE_EXCL/BLK_OPEN_EXCL in ->open.
These are probably bogus and maybe we want to kill them, but that will
need an audit first.

> BTW, what happens if two threads call ioctl(fd, BLKBSZSET, &n)
> for the same descriptor that happens to have been opened O_EXCL?
> Without O_EXCL they would've been unable to claim the sucker at the same
> time - the holder we are using is the address of a function argument,
> i.e. something that points to kernel stack of the caller.  Those would
> conflict and we either get set_blocksize() calls fully serialized, or
> one of the callers would eat -EBUSY.  Not so in "opened with O_EXCL"
> case - they can very well overlap and IIRC set_blocksize() does *not*
> expect that kind of crap...  It's all under CAP_SYS_ADMIN, so it's not
> as if it was a meaningful security hole anyway, but it does look fishy.

The user get to keep the pieces..  BLKBSZSET is kinda bogus anyway
as the soft blocksize only matters for buffer_head-like I/O, and
there only for file systems.  Not idea why anyone would set it manually.
