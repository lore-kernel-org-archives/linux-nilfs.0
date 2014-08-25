From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 1/1] nilfs2: add missing blkdev_issue_flush() to nilfs_sync_fs()
Date: Mon, 25 Aug 2014 11:30:18 +0200
Message-ID: <1408959018-10570-2-git-send-email-andreas.rohner@gmx.net>
References: <1408959018-10570-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408959018-10570-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

This patch adds a call to blkdev_issue_flush() to nilfs_sync_fs(), which
is the nilfs implementation of the sync() syscall. If the BARRIER
mount option is set, both the nilfs implementation of fsync() and nilfs'
custom ioctl version of sync() used by the cleaner, use
blkdev_issue_flush() to guarantee that the data is written to the
underlying device. To get the same behaviour and guarantees for the
sync() syscall, blkdev_issue_flush() should also be called in
nilfs_sync_fs().

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 fs/nilfs2/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 228f5bd..1f21e81 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -514,6 +514,12 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
 	}
 	up_write(&nilfs->ns_sem);
 
+	if (wait && !err && nilfs_test_opt(nilfs, BARRIER)) {
+		err = blkdev_issue_flush(sb->s_bdev, GFP_KERNEL, NULL);
+		if (err != -EIO)
+			err = 0;
+	}
+
 	return err;
 }
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
