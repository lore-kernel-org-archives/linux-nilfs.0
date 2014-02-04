From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: add description of NILFS_IOCTL_SET_SUINFO ioctl
Date: Tue,  4 Feb 2014 10:50:00 +0900
Message-ID: <1391478600-7512-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Add description of NILFS_IOCTL_SET_SUINFO ioctl in
Documentation/filesystems/nilfs2.txt to make it up-to-date.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 Documentation/filesystems/nilfs2.txt |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/filesystems/nilfs2.txt b/Documentation/filesystems/nilfs2.txt
index 06887d4..8b887ae 100644
--- a/Documentation/filesystems/nilfs2.txt
+++ b/Documentation/filesystems/nilfs2.txt
@@ -111,6 +111,13 @@ Table of NILFS2 specific ioctls
 			        nilfs_resize utilities and by nilfs_cleanerd
 			        daemon.
 
+ NILFS_IOCTL_SET_SUINFO         Modify segment usage info of requested
+				segments. This ioctl is used by
+				nilfs_cleanerd daemon to skip unnecessary
+				cleaning operation of segments and reduce
+				performance penalty or wear of flash device
+				due to redundant move of in-use blocks.
+
  NILFS_IOCTL_GET_SUSTAT         Return segment usage statistics. This ioctl
 			        is used in lssu, nilfs_resize utilities and
 			        by nilfs_cleanerd daemon.
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
