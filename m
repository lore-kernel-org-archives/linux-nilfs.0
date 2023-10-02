From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 0/29] block: Make blkdev_get_by_*() return
	handle
Date: Mon, 2 Oct 2023 09:57:32 +0200
Message-ID: <20231002075732.4c5oslpabrmw3niz@quack3>
References: <20230818123232.2269-1-jack@suse.cz>
	<20230927-prahlen-reintreten-93706074e58d@brauner>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1696233452;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=HRtvvsbDRmaIGA2qlEwuFNnN4SG9to1RwhMyTnDS1Ek=;
	b=AelUG9FSlQyUcQTA9I9qRJmPzMA6mvk2OLx4Qv2PacqmgU2FkeI54uQfwuwk8GDISDrHf1
	K6okkr5Yua+jK8r2TTOukY7745vay4e4z1caiTsHAigkH18O5VWdMY9s+0PKMe8/Ta1ITc
	H4lySULw9TgNQsjwAFd513U/tj8Iifc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1696233452;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=HRtvvsbDRmaIGA2qlEwuFNnN4SG9to1RwhMyTnDS1Ek=;
	b=4yX5F6ZD5YaXQ1SgLuHClpbWfxc1xKg7esoSW59wSh/oO7HSeTROmd590v4TgEevJu81R5
	RAceDQWhH8NjA0AQ==
Content-Disposition: inline
In-Reply-To: <20230927-prahlen-reintreten-93706074e58d@brauner>
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
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dave Kleikamp <shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Joseph Qi <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, Gao Xiang <xiang-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christian Borntraeger <borntraeger-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sven Schnelle <svens-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Snitzer <snitzer-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joern Engel <joern-o6zPIXG8fmPj4SYmN/TMmA@public.gmane.org>, re

On Wed 27-09-23 18:21:19, Christian Brauner wrote:
> On Wed, 27 Sep 2023 11:34:07 +0200, Jan Kara wrote:
> > Create struct bdev_handle that contains all parameters that need to be
> > passed to blkdev_put() and provide bdev_open_* functions that return
> > this structure instead of plain bdev pointer. This will eventually allow
> > us to pass one more argument to blkdev_put() (renamed to bdev_release())
> > without too much hassle.
> > 
> > 
> > [...]
> 
> > to ease review / testing. Christian, can you pull the patches to your tree
> > to get some exposure in linux-next as well? Thanks!
> 
> Yep. So I did it slighly differently. I pulled in the btrfs prereqs and
> then applied your series on top of it so we get all the Link: tags right.
> I'm running tests right now. Please double-check.

Thanks for picking patches up! I've checked the branch and it looks good to
me. 

								Honza

> 
> ---
> 
> Applied to the vfs.super branch of the vfs/vfs.git tree.
> Patches in the vfs.super branch should appear in linux-next soon.
> 
> Please report any outstanding bugs that were missed during review in a
> new review to the original patch series allowing us to drop it.
> 
> It's encouraged to provide Acked-bys and Reviewed-bys even though the
> patch has now been applied. If possible patch trailers will be updated.
> 
> Note that commit hashes shown below are subject to change due to rebase,
> trailer updates or similar. If in doubt, please check the listed branch.
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> branch: vfs.super
> 
> [01/29] block: Provide bdev_open_* functions
>        https://git.kernel.org/vfs/vfs/c/b7c828aa0b3c
> [02/29] block: Use bdev_open_by_dev() in blkdev_open()
>         https://git.kernel.org/vfs/vfs/c/d4e36f27b45a
> [03/29] block: Use bdev_open_by_dev() in disk_scan_partitions() and blkdev_bszset()
>         https://git.kernel.org/vfs/vfs/c/5f9bd6764c7a
> [04/29] drdb: Convert to use bdev_open_by_path()
>         https://git.kernel.org/vfs/vfs/c/0220ca8e443d
> [05/29] pktcdvd: Convert to bdev_open_by_dev()
>         https://git.kernel.org/vfs/vfs/c/7af10b889789
> [06/29] rnbd-srv: Convert to use bdev_open_by_path()
>         https://git.kernel.org/vfs/vfs/c/3d27892a4be7
> [07/29] xen/blkback: Convert to bdev_open_by_dev()
>         https://git.kernel.org/vfs/vfs/c/26afb0ed10b3
> [08/29] zram: Convert to use bdev_open_by_dev()
>         https://git.kernel.org/vfs/vfs/c/efc8e3f4c6dc
> [09/29] bcache: Convert to bdev_open_by_path()
>         https://git.kernel.org/vfs/vfs/c/dc893f51d24a
> [10/29] dm: Convert to bdev_open_by_dev()
>         https://git.kernel.org/vfs/vfs/c/80c2267c6d07
> [11/29] md: Convert to bdev_open_by_dev()
>         https://git.kernel.org/vfs/vfs/c/15db36126ca6
> [12/29] mtd: block2mtd: Convert to bdev_open_by_dev/path()
>         https://git.kernel.org/vfs/vfs/c/4c27234bf3ce
> [13/29] nvmet: Convert to bdev_open_by_path()
>         https://git.kernel.org/vfs/vfs/c/70cffddcc300
> [14/29] s390/dasd: Convert to bdev_open_by_path()
>         https://git.kernel.org/vfs/vfs/c/5581d03457f8
> [15/29] scsi: target: Convert to bdev_open_by_path()
>         https://git.kernel.org/vfs/vfs/c/43de7d844d47
> [16/29] PM: hibernate: Convert to bdev_open_by_dev()
>         https://git.kernel.org/vfs/vfs/c/105ea4a2fd18
> [17/29] PM: hibernate: Drop unused snapshot_test argument
>         https://git.kernel.org/vfs/vfs/c/b589a66e3688
> [18/29] mm/swap: Convert to use bdev_open_by_dev()
>         https://git.kernel.org/vfs/vfs/c/615af8e29233
> [19/29] fs: Convert to bdev_open_by_dev()
>         https://git.kernel.org/vfs/vfs/c/5173192bcfe6
> [20/29] btrfs: Convert to bdev_open_by_path()
>         https://git.kernel.org/vfs/vfs/c/8cf64782764f
> [21/29] erofs: Convert to use bdev_open_by_path()
>         https://git.kernel.org/vfs/vfs/c/4d41880bf249
> [22/29] ext4: Convert to bdev_open_by_dev()
>         https://git.kernel.org/vfs/vfs/c/f7507612395e
> [23/29] f2fs: Convert to bdev_open_by_dev/path()
>         https://git.kernel.org/vfs/vfs/c/d9ff8e3b6498
> [24/29] jfs: Convert to bdev_open_by_dev()
>         https://git.kernel.org/vfs/vfs/c/459dc6376338
> [25/29] nfs/blocklayout: Convert to use bdev_open_by_dev/path()
>         https://git.kernel.org/vfs/vfs/c/5b1df9a40929
> [26/29] ocfs2: Convert to use bdev_open_by_dev()
>         https://git.kernel.org/vfs/vfs/c/b6b95acbd943
> [27/29] reiserfs: Convert to bdev_open_by_dev/path()
>         https://git.kernel.org/vfs/vfs/c/7e3615ff6119
> [28/29] xfs: Convert to bdev_open_by_path()
>         https://git.kernel.org/vfs/vfs/c/176ccb99e207
> [29/29] block: Remove blkdev_get_by_*() functions
>         https://git.kernel.org/vfs/vfs/c/953863a5a2ff
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
