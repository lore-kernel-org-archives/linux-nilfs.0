From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v2 0/1] nilfs2: add missing blkdev_issue_flush() to nilfs_sync_fs()
Date: Sun, 31 Aug 2014 17:47:12 +0200
Message-ID: <1409500033-30791-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Hi,

I have looked a bit more into the semantics of the various flags
concerning block device caching behaviour. According to
"Documentation/block/writeback_cache_control.txt" a call to
blkdev_issue_flush() is equivalent to an empty bio with the
REQ_FLUSH flag set. So there is no need to call blkdev_issue_flush()
after a call to nilfs_commit_super(). But if there is no need to write
the super block an additional call to blkdev_issue_flush() is necessary.

To avoid an overhead I introduced the THE_NILFS_FLUSHED flag, which is
cleared whenever new logs are written and set whenever the block device
is flushed. If the super block was written during segment construction
or in nilfs_sync_fs(), then blkdev_issue_flush() is not called.

I am pretty sure, that there are no race conditions, but maybe someone
should check that possibility before merging this.

br,
Andreas Rohner

v1->v2
 * Add new flag THE_NILFS_FLUSHED

Andreas Rohner (1):
  nilfs2: add missing blkdev_issue_flush() to nilfs_sync_fs()

 fs/nilfs2/file.c      | 3 ++-
 fs/nilfs2/ioctl.c     | 3 ++-
 fs/nilfs2/segment.c   | 2 ++
 fs/nilfs2/super.c     | 8 ++++++++
 fs/nilfs2/the_nilfs.h | 6 ++++++
 5 files changed, 20 insertions(+), 2 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
