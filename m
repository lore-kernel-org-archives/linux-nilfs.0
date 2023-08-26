From: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH v2 0/29] block: Make blkdev_get_by_*() return
	handle
Date: Sat, 26 Aug 2023 03:28:52 +0100
Message-ID: <20230826022852.GO3390869@ZenIV>
References: <20230810171429.31759-1-jack@suse.cz>
	<20230825015843.GB95084@ZenIV>
	<20230825134756.o3wpq6bogndukn53@quack3>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kRz17k12DLtH5ptlx3fiiancvtShyoQwDvuAAOUED4Y=;
	b=mPm/qZCa7MWW4zdrpIjhXYeIS6
	8cbIgOvCf/9Y6gIxhhuc7MbOClbX1o3H4gTlXLJmOpOyil1pufLmdD8oxm6VhlxB4x6C/OQmKz1OC
	9Sg7eN60e8HGn0pn/DtWEZ2zi7uHlJyyQNolWeGdXQEgqn78/62UYsbUB8gsUgOw68YkPTd36+fo0
	kPzizyM3mKJ55bukbV99w6F1Yx4exn0ELF0EHA2mn4TEClpd2hjjcTiwEbEGv+vsWkEq4IC7ejHjR
	rO8uE9/3ipL5VpLJjGdd7WJssIdQ5Tj/z+j2E3fQDWI0Qb9TMLDhfRhfBXk5sw2QK4rJI42xn3tDe
	SBJa1VHw==;
Content-Disposition: inline
In-Reply-To: <20230825134756.o3wpq6bogndukn53@quack3>
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
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Dave Kleikamp <shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Joseph Qi <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, Gao Xiang <xiang-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christian Borntraeger <borntraeger-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sven Schnelle <svens-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Snitzer <snitzer-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joern Engel <joern-o6zPIXG8fmPj4SYmN/TMmA@public.gmane.org>, reiserfs-devel-u79uwXL29TbrhsbdSgBK9A@public.gmane.org

On Fri, Aug 25, 2023 at 03:47:56PM +0200, Jan Kara wrote:

> I can see the appeal of not having to introduce the new bdev_handle type
> and just using struct file which unifies in-kernel and userspace block
> device opens. But I can see downsides too - the last fput() happening from
> task work makes me a bit nervous whether it will not break something
> somewhere with exclusive bdev opens. Getting from struct file to bdev is
> somewhat harder but I guess a helper like F_BDEV() would solve that just
> fine.
> 
> So besides my last fput() worry about I think this could work and would be
> probably a bit nicer than what I have. But before going and redoing the whole
> series let me gather some more feedback so that we don't go back and forth.
> Christoph, Christian, Jens, any opinion?

Redoing is not an issue - it can be done on top of your series just
as well.  Async behaviour of fput() might be, but...  need to look
through the actual users; for a lot of them it's perfectly fine.

FWIW, from a cursory look there appears to be a missing primitive: take
an opened bdev (or bdev_handle, with your variant, or opened file if we
go that way eventually) and claim it.

I mean, look at claim_swapfile() for example:
                p->bdev = blkdev_get_by_dev(inode->i_rdev,
                                   FMODE_READ | FMODE_WRITE | FMODE_EXCL, p);
                if (IS_ERR(p->bdev)) {
                        error = PTR_ERR(p->bdev);
                        p->bdev = NULL;
                        return error;
                }
                p->old_block_size = block_size(p->bdev);
                error = set_blocksize(p->bdev, PAGE_SIZE);
                if (error < 0)
                        return error;
we already have the file opened, and we keep it opened all the way until
the swapoff(2); here we have noticed that it's a block device and we
	* open the fucker again (by device number), this time claiming
it with our swap_info_struct as holder, to be closed at swapoff(2) time
(just before we close the file)
	* flip the block size to PAGE_SIZE, to be reverted at swapoff(2)
time That really looks like it ought to be
	* take the opened file, see that it's a block device
	* try to claim it with that holder
	* on success, flip the block size
with close_filp() in the swapoff(2) (or failure exit path in swapon(2))
doing what it would've done for an O_EXCL opened block device.
The only difference from O_EXCL userland open is that here we would
end up with holder pointing not to struct file in question, but to our
swap_info_struct.  It will do the right thing.

This extra open is entirely due to "well, we need to claim it and the
primitive that does that happens to be tied to opening"; feels rather
counter-intuitive.

For that matter, we could add an explicit "unclaim" primitive - might
be easier to follow.  That would add another example where that could
be used - in blkdev_bszset() we have an opened block device (it's an
ioctl, after all), we want to change block size and we *really* don't
want to have that happen under a mounted filesystem.  So if it's not
opened exclusive, we do a temporary exclusive open of own and act on
that instead.   Might as well go for a temporary claim...

BTW, what happens if two threads call ioctl(fd, BLKBSZSET, &n)
for the same descriptor that happens to have been opened O_EXCL?
Without O_EXCL they would've been unable to claim the sucker at the same
time - the holder we are using is the address of a function argument,
i.e. something that points to kernel stack of the caller.  Those would
conflict and we either get set_blocksize() calls fully serialized, or
one of the callers would eat -EBUSY.  Not so in "opened with O_EXCL"
case - they can very well overlap and IIRC set_blocksize() does *not*
expect that kind of crap...  It's all under CAP_SYS_ADMIN, so it's not
as if it was a meaningful security hole anyway, but it does look fishy.
