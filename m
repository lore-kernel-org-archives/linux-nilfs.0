From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 12/23] nilfs2: get rid of snapshot mount flag
Date: Tue, 14 Sep 2010 00:37:13 +0900
Message-ID: <1284392244-27100-13-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1284392244-27100-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1284392244-27100-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This flag is a fake used to distinguish type of super block instance.
And, it got obsolete by the unification of sb.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 include/linux/nilfs2_fs.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index e30bde6..788bfb4 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -147,7 +147,6 @@ struct nilfs_super_root {
 #define NILFS_MOUNT_ERRORS_CONT		0x0010  /* Continue on errors */
 #define NILFS_MOUNT_ERRORS_RO		0x0020  /* Remount fs ro on errors */
 #define NILFS_MOUNT_ERRORS_PANIC	0x0040  /* Panic on errors */
-#define NILFS_MOUNT_SNAPSHOT		0x0080  /* Snapshot flag */
 #define NILFS_MOUNT_BARRIER		0x1000  /* Use block barriers */
 #define NILFS_MOUNT_STRICT_ORDER	0x2000  /* Apply strict in-order
 						   semantics also for data */
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
