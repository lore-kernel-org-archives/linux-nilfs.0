From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/1] nilfs2: fix device cache flush in nilfs_sync_fs()
Date: Sun, 14 Sep 2014 19:11:43 +0900
Message-ID: <1410689504-10032-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=xBHMvr5oXTYeE3MQ1fsJkkl1Ots+rUg/qOiFFvtCc7c=;
        b=x+GdUKay+J4MMqddS8I5qYUwyvOCpqIXn71SLyxI+0EAyo3XpfpTb+lQMAMDbizjTp
         PupAn0MbZyZ2zi7Uvz6EGpMPUrvRkEhdjF5qfgY8THy2yVPzBbaU4VSxbXiDzlbnS6Tc
         ZKThQo039M/2BQflEsBjDWab0lycX15kqdsEIwk/ehwyqREuS8RRgg9/F7ikKbnExuWk
         vdWy5F9T/MDHlQPz3X0RWkjjxFBqWSirpKBy1S5nyGBZJR9y6HnLFzGlWZdkqKpaJLEY
         H3yXyUH/vc1JUUIARPhNxYDyNVrrnOhQkQDAQqjOiN0Lhj2EsCEu/Z2KWYobmc5F9lAj
         crPg==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Hi Andrew,

Please add the following patch to the queue for the next merge window.

It ensures that nilfs_sync_fs() function sends a cache flush request
to the underlying device when required.  The current nilfs_sync_fs()
has a defect that it can skip the flush if only a small amount of data
is written.  The original cover letter can be seen at:

[1] http://marc.info/?l=linux-nilfs&m=141061909728506
    "[PATCH v6 0/1] nilfs2: add missing blkdev_issue_flush() to
    nilfs_sync_fs()"

Thanks,
Ryusuke Konishi
--
Andreas Rohner (1):
      nilfs2: add missing blkdev_issue_flush() to nilfs_sync_fs()

 fs/nilfs2/file.c      |    8 +++-----
 fs/nilfs2/ioctl.c     |    8 +++-----
 fs/nilfs2/segment.c   |    3 +++
 fs/nilfs2/super.c     |    6 ++++++
 fs/nilfs2/the_nilfs.h |   22 ++++++++++++++++++++++
 5 files changed, 37 insertions(+), 10 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
