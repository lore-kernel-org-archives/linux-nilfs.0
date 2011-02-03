From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: optimize rec_len functions
Date: Fri,  4 Feb 2011 02:19:24 +0900
Message-ID: <1296753564-12835-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This is a similar change to those in ext2/ext3 codebase (commit
40a063f6691ce937 and a4ae3094869f18e2, respectively).

The addition of 64k block capability in the rec_len_from_disk and
rec_len_to_disk functions added a bit of math overhead which slows
down file create workloads needlessly when the architecture cannot
even support 64k blocks.  This will cut the corner.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/ioctl.c         |    1 +
 include/linux/nilfs2_fs.h |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index d89173e..5471eed 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -28,6 +28,7 @@
 #include <linux/vmalloc.h>
 #include <linux/compat.h>	/* compat_ptr() */
 #include <linux/mount.h>	/* mnt_want_write(), mnt_drop_write() */
+#include <linux/buffer_head.h>
 #include <linux/nilfs2_fs.h>
 #include "nilfs.h"
 #include "segment.h"
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index fdcd1bc..3a65e5a 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -326,17 +326,21 @@ static inline unsigned nilfs_rec_len_from_disk(__le16 dlen)
 {
 	unsigned len = le16_to_cpu(dlen);
 
+#if !defined(__KERNEL__) || (PAGE_CACHE_SIZE >= 65536)
 	if (len == NILFS_MAX_REC_LEN)
 		return 1 << 16;
+#endif
 	return len;
 }
 
 static inline __le16 nilfs_rec_len_to_disk(unsigned len)
 {
+#if !defined(__KERNEL__) || (PAGE_CACHE_SIZE >= 65536)
 	if (len == (1 << 16))
 		return cpu_to_le16(NILFS_MAX_REC_LEN);
 	else if (len > (1 << 16))
 		BUG();
+#endif
 	return cpu_to_le16(len);
 }
 
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
