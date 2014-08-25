From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 0/1] add missing blkdev_issue_flush() to nilfs_sync_fs()
Date: Mon, 25 Aug 2014 11:30:17 +0200
Message-ID: <1408959018-10570-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Hi,

I do not know, if this patch is really necessary or not. I am not an 
expert in how the BARRIER flag should be interpreted. So this patch is 
more like a question, than a fix for any real bug.

Looking over the code I noticed, that nilfs_sync_file() gets called by 
the fsync() syscall and it basically constructs a new partial segment 
and calls blkdev_issue_flush().

nilfs_ioctl_sync(), which is used by the cleaner, also essentially works 
the same way. It writes all the dirty files to disk and calls 
blkdev_issue_flush().

nilfs_sync_fs() also writes out all the dirty files, but there is no 
blkdev_issue_flush() at the end. At first I thought, that 
nilfs_commit_super() may flush the block device anyway and therefore no 
additional flush is necessary, but nilfs_sb_dirty(nilfs) is only set to 
true if a new segment is started. So in the following scenario data 
could be lost despite a call to sync():

1. Write out less data than a full segment
2. Call sync()
3. nilfs_sb_dirty() is false and nilfs_commit_super() is NOT called
4. Cut power to the device
5. Data loss

As I stated above, I am not sure if this is really necessary. Maybe I 
have overlooked something obvious.

br,
Andreas Rohner


Andreas Rohner (1):
  nilfs2: add missing blkdev_issue_flush() to nilfs_sync_fs()

 fs/nilfs2/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
