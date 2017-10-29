From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH] nilfs-utils: Fix conflicting data buffer error
Date: Sun, 29 Oct 2017 15:10:52 +0100
Message-ID: <20171029141052.8521-1-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Under certain high concurrency loads, NILFS2 can produce a segment that
crashes the cleanerd process with a conflicting data buffer error. The
segment is perfectly valid and the file system is not corrupted.
However, the cleanerd process can no longer be started and the file
system will eventually fill up and cannot be used any more.

The reason for this crash is, that a single logical segment can contain
multiple partial segments. If a block is written in one partial segment
and then immediately overwritten in another partial segment, then these
blocks have the same inode number, checkpoint number and offset.
However, these three numbers are used by the kernel to uniquely
identify a block. If the cleaner tries to clean two blocks that point
to the exact same buffer_head in the kernel, it creates a conflicting
data buffer error.

The solution is to detect these blocks and treat them as dead blocks.
If vd_period.p_end is equal to the checkpoint number, it means that the
block was overwritten within the same logical segment. So it must be
dead, and there is another block with the same ino, cno, and offset,
which is alive.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 lib/gc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/lib/gc.c b/lib/gc.c
index 5e14443..9449352 100644
--- a/lib/gc.c
+++ b/lib/gc.c
@@ -433,6 +433,19 @@ static int nilfs_vdesc_is_live(const struct nilfs_vdesc *vdesc,
 		return vdesc->vd_period.p_end == NILFS_CNO_MAX;
 	}
 
+	if (vdesc->vd_period.p_end == vdesc->vd_cno) {
+		/*
+		 * This block was overwritten in the same logical segment, but
+		 * in a different partial segment. Probably because of
+		 * fdatasync() or a flush to disk.
+		 * Without this check, gc will cause buffer confliction error
+		 * if both partial segments are cleaned at the same time.
+		 * In that case there will be two vdesc with the same ino,
+		 * cno and offset.
+		 */
+		return 0;
+	}
+
 	if (vdesc->vd_period.p_end == NILFS_CNO_MAX ||
 	    vdesc->vd_period.p_end > protect)
 		return 1;
-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
