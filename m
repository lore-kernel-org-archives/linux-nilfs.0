From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH v5 0/1] nilfs2: add missing blkdev_issue_flush() to nilfs_sync_fs()
Date: Sat, 13 Sep 2014 15:55:55 +0200
Message-ID: <1410616556-25943-1-git-send-email-andreas.rohner@gmx.net>
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

To avoid an overhead I introduced the nilfs->ns_flushed_device flag, 
which is set to 0  whenever new logs are written and set to 1 whenever 
the block device is flushed. If the super block was written during 
segment construction or in nilfs_sync_fs(), then blkdev_issue_flush() is 
not called.

br,
Andreas Rohner

v4->v5 (review by Ryusuke Konishi)
 * Move device flushing logic into separate function
 * Fix invalid comment
 * Move clearing of the flag to nilfs_segctor_complete_write() and
   nilfs_construct_dsync_segment()

v3->v4 (review by Ryusuke Konishi)
 * Replace atomic_t with int for ns_flushed_device
 * Use smp_wmb() to guarantee correct ordering

v2->v3 (review of Ryusuke Konishi)
 * Use separate atomic flag for ns_flushed_device instead of a bit flag 
   in ns_flags
 * Use smp_mb__after_atomic() after setting ns_flushed_device

v1->v2
 * Add new flag THE_NILFS_FLUSHED

Andreas Rohner (1):
  nilfs2: add missing blkdev_issue_flush() to nilfs_sync_fs()

 fs/nilfs2/file.c      |  8 +++-----
 fs/nilfs2/ioctl.c     |  8 +++-----
 fs/nilfs2/segment.c   |  3 +++
 fs/nilfs2/super.c     |  6 ++++++
 fs/nilfs2/the_nilfs.h | 22 ++++++++++++++++++++++
 5 files changed, 37 insertions(+), 10 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
