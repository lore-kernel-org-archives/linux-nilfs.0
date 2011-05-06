From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs_cleanerd: fix move block errors with cpfile and
 sufile
Date: Fri, 06 May 2011 14:56:33 +0900 (JST)
Message-ID: <20110506.145633.179948942.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

This fixes another nilfs_ioctl_move_inode_block error
which may occur if setting protection period to a large value.

I noticed this error during tests of shrinking the filesystem with
nilfs-resize tool.


Ryusuke Konishi
---
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

nilfs_cleanerd: fix move block errors with cpfile and sufile

This fixes the following gc error related to cpfile and sufile:

 nilfs_ioctl_move_inode_block: conflicting data buffer: ino=4, cno=0,
 offset=0, blocknr=78648, vblocknr=62283

Blocks of cpfile and sufile should be judged live only if they are
latest, and should not depends on the protection period.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/cleanerd/cleanerd.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
index 45a0be0..138a444 100644
--- a/sbin/cleanerd/cleanerd.c
+++ b/sbin/cleanerd/cleanerd.c
@@ -748,6 +748,16 @@ static int nilfs_vdesc_is_live(const struct nilfs_vdesc *vdesc,
 	long low, high, index;
 	int s;
 
+	if (vdesc->vd_cno == 0) {
+		/*
+		 * live/dead judge for sufile and cpfile should not
+		 * depend on protection period and snapshots.  Without
+		 * this check, gc will cause buffer conflict error
+		 * because their checkpoint number is always zero.
+		 */
+		return vdesc->vd_period.p_end == NILFS_CNO_MAX;
+	}
+
 	if (vdesc->vd_period.p_end == NILFS_CNO_MAX ||
 	    vdesc->vd_period.p_end > protect)
 		return 1;
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
