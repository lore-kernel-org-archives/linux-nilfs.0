From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 0/29] block: Make blkdev_get_by_*() return
	handle
Date: Fri, 25 Aug 2023 15:47:56 +0200
Message-ID: <20230825134756.o3wpq6bogndukn53@quack3>
References: <20230810171429.31759-1-jack@suse.cz>
	<20230825015843.GB95084@ZenIV>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1692971277;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=BpzfsfMiRxmg30OdFnKzv1mOgTevyt5wkPNcyneGwG0=;
	b=uohLnKnqtpENx2vCia+CF25VunAvqKNxW8Gl/JZPjm2522sG0QzHP89CKm9gvg5uhIQmJN
	WBEcUX07tygEsfRFeW0MDCmmX2lneinhEWFdq+jYTgqP+tDCYKowqEsMW88igvW28lrojs
	hfcd/30g2Ie/qrM4mt7e3dhBm3c9V28=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1692971277;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=BpzfsfMiRxmg30OdFnKzv1mOgTevyt5wkPNcyneGwG0=;
	b=avw/hNX+TPhBa6q/Pyjq6dsHiVTX81moNODEW9+kRWtkr4cKF/cxPXXUPquXV79uoK0IL4
	nSbq/d/haJGtPRAQ==
Content-Disposition: inline
In-Reply-To: <20230825015843.GB95084@ZenIV>
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

On Fri 25-08-23 02:58:43, Al Viro wrote:
> On Fri, Aug 11, 2023 at 01:04:31PM +0200, Jan Kara wrote:
> > Hello,
> > 
> > this is a v2 of the patch series which implements the idea of blkdev_get_by_*()
> > calls returning bdev_handle which is then passed to blkdev_put() [1]. This
> > makes the get and put calls for bdevs more obviously matching and allows us to
> > propagate context from get to put without having to modify all the users
> > (again!).  In particular I need to propagate used open flags to blkdev_put() to
> > be able count writeable opens and add support for blocking writes to mounted
> > block devices. I'll send that series separately.
> > 
> > The series is based on Christian's vfs tree as of yesterday as there is quite
> > some overlap. Patches have passed some reasonable testing - I've tested block
> > changes, md, dm, bcache, xfs, btrfs, ext4, swap. This obviously doesn't cover
> > everything so I'd like to ask respective maintainers to review / test their
> > changes. Thanks! I've pushed out the full branch to:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git bdev_handle
> > 
> > to ease review / testing.
> 
> Hmm...  Completely Insane Idea(tm): how about turning that thing inside out and
> having your bdev_open_by... return an actual opened struct file?
> 
> After all, we do that for sockets and pipes just fine and that's a whole lot
> hotter area.
> 
> Suppose we leave blkdev_open()/blkdev_release() as-is.  No need to mess with
> what we have for normal opened files for block devices.  And have block_open_by_dev()
> that would find bdev, etc., same yours does and shove it into anon file.
> 
> Paired with plain fput() - no need to bother with new primitives for closing.
> With a helper returning I_BDEV(bdev_file_inode(file)) to get from those to bdev.
> 
> NOTE: I'm not suggesting replacing ->s_bdev with struct file * if we do that -
> we want that value cached, obviously.  Just store both...
> 
> Not saying it's a good idea, but... might be interesting to look into.
> Comments?

I can see the appeal of not having to introduce the new bdev_handle type
and just using struct file which unifies in-kernel and userspace block
device opens. But I can see downsides too - the last fput() happening from
task work makes me a bit nervous whether it will not break something
somewhere with exclusive bdev opens. Getting from struct file to bdev is
somewhat harder but I guess a helper like F_BDEV() would solve that just
fine.

So besides my last fput() worry about I think this could work and would be
probably a bit nicer than what I have. But before going and redoing the whole
series let me gather some more feedback so that we don't go back and forth.
Christoph, Christian, Jens, any opinion?

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
