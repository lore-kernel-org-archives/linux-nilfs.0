From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH v2 0/29] block: Make blkdev_get_by_*() return
	handle
Date: Fri, 11 Aug 2023 13:04:31 +0200
Message-ID: <20230810171429.31759-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1691751905;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version: content-transfer-encoding:content-transfer-encoding;
	bh=5tRGa7YNpy5azfO2DILJGaxnHQqIrHRIuX4HPJpenrQ=;
	b=nS0o04Ko2eofWDhOvWx6o3T36EV25HqbUFvkN9WMKumyZo3DU5IiWgMskXfjyH4OXEiKYl
	IITYxvL5Q8pMKkFc8O6biwC3K3TxmcmnzVR3W1NQhsfgztirbY49kzZoor0HytOQKCBlyL
	GV3cB78+BIPaD5P0M4y2xB0Q495MkAo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1691751905;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version: content-transfer-encoding:content-transfer-encoding;
	bh=5tRGa7YNpy5azfO2DILJGaxnHQqIrHRIuX4HPJpenrQ=;
	b=PRu3LFGsOROMaty7jNH51X1wMClD6ZMlY5AdbxYnc0QwtMHxNWZ8s/wVfL1uImLDOQT/Rl
	cDHfO/YvLXNV1tAw==
X-Developer-Signature: v=1; a=openpgp-sha256; l=3218; i=jack-AlSwsSmVLrQ@public.gmane.org;
	h=from:subject:message-id;
	bh=8um6o7br1koHMcykRc7ml18Y2BSCm69vwpPmgjRXxkk=;
	b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBk1hW86qklK68Z0G139b8b61UzO/oV2Y6qvJg1uvDC
	+JKlEZuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZNYVvAAKCRCcnaoHP2RA2epoB/
	9Sgdf//aomv8tBKGEg1kRzItWS+CXbN/cjy5B6uL3IUWhEY6vxFg7DsN+znMmPFPOp7X1w/e2PExiA
	dGNvKiX2BNUyl6ZLFstCZUiXyzlig8pnDHrmrN4lbx3SIS3BHdNJ8igPArMWVDYXlZuosexzFn3fIW
	ELsTpVpNLZdp6BAxZg4925E1qscyN11eFDJecvW+IrpMA1nHR12Y/AX4zqXWcBT8MPUEiJD1Cnfxfa
	Leji+h3vOG0k2IQAyfN6R1cj/0POs0zJWvSVK9bZM8IYFIOHr+jpYHi0KEVh62q6NLoQxbMBVEzn9K
	JsmkBplP7UobjvtEWvfH0EwVENii9z
X-Developer-Key: i=jack-AlSwsSmVLrQ@public.gmane.org; a=openpgp;
	fpr=93C6099A142276A28BBE35D815BC833443038D8C
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
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Dave Kleikamp <shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Joseph Qi <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, Gao Xiang <xiang-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christian Borntraeger <borntraeger-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sven Schnelle <svens-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Snitzer <snitzer-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joern Engel <joern-o6zPIXG8fmPj4SYmN/TMmA@public.gmane.org>, re

Hello,

this is a v2 of the patch series which implements the idea of blkdev_get_by_*()
calls returning bdev_handle which is then passed to blkdev_put() [1]. This
makes the get and put calls for bdevs more obviously matching and allows us to
propagate context from get to put without having to modify all the users
(again!).  In particular I need to propagate used open flags to blkdev_put() to
be able count writeable opens and add support for blocking writes to mounted
block devices. I'll send that series separately.

The series is based on Christian's vfs tree as of yesterday as there is quite
some overlap. Patches have passed some reasonable testing - I've tested block
changes, md, dm, bcache, xfs, btrfs, ext4, swap. This obviously doesn't cover
everything so I'd like to ask respective maintainers to review / test their
changes. Thanks! I've pushed out the full branch to:

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git bdev_handle

to ease review / testing.

Changes since v1:
* Rebased on top of current vfs tree
* Renamed final functions to bdev_open_by_*() and bdev_release()
* Fixed detection of exclusive open in blkdev_ioctl() and blkdev_fallocate()
* Fixed swap conversion to properly reinitialize swap_info->bdev_handle
* Fixed xfs conversion to not oops with rtdev without logdev
* Couple other minor fixups

								Honza

[1] https://lore.kernel.org/all/ZJGNsVDhZx0Xgs2H-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org

CC: Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: Christian Borntraeger <borntraeger-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
CC: Coly Li <colyli-l3A5Bk7waGM@public.gmane.org
CC: "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: Dave Kleikamp <shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>
CC: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
CC: drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
CC: Gao Xiang <xiang-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: Jack Wang <jinpu.wang-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>
CC: Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
CC: Joern Engel <joern-o6zPIXG8fmPj4SYmN/TMmA@public.gmane.org>
CC: Joseph Qi <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
CC: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-erofs-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
CC: <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
CC: linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
CC: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
CC: linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
CC: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
CC: linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: "Md. Haris Iqbal" <haris.iqbal-vEVw2sk9H7kAvxtiuMwx3w@public.gmane.org>
CC: Mike Snitzer <snitzer-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
CC: reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
CC: Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: Sven Schnelle <svens-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
CC: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: Ted Tso <tytso-3s7WtUTddSA@public.gmane.org>
CC: Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>
CC: xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org

Previous versions:
Link: http://lore.kernel.org/r/20230629165206.383-1-jack-AlSwsSmVLrQ@public.gmane.org # v1
