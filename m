From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: fix segctor bug that causes file system corruption
Date: Thu,  9 Jan 2014 02:22:15 +0900
Message-ID: <1389201735-3739-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

There is a bug in the function nilfs_segctor_collect, which results in
active data being written to a segment, that is marked as clean. It is
possible, that this segment is selected for a later segment
construction, whereby the old data is overwritten.

The problem shows itself with the following kernel log message:

nilfs_sufile_do_cancel_free: segment 6533 must be clean

Usually a few hours later the file system gets corrupted:

NILFS: bad btree node (blocknr=8748107): level = 0, flags = 0x0,
nchildren = 0
NILFS error (device sdc1): nilfs_bmap_last_key: broken bmap
(inode number=114660)

The issue can be reproduced with a file system that is nearly full and
with the cleaner running, while some IO intensive task is running.
Although it is quite hard to reproduce.

This is what happens:

1. The cleaner starts the segment construction
2. nilfs_segctor_collect is called
3. sc_stage is on NILFS_ST_SUFILE and segments are freed
4. sc_stage is on NILFS_ST_DAT current segment is full
5. nilfs_segctor_extend_segments is called, which
   allocates a new segment
6. The new segment is one of the segments freed in step 3
7. nilfs_sufile_cancel_freev is called and produces an error message
8. Loop around and the collection starts again
9. sc_stage is on NILFS_ST_SUFILE and segments are freed
   including the newly allocated segment, which will contain active data
   and can be allocated at a later time
10. A few hours later another segment construction allocates the segment
    and causes file system corruption

This can be prevented by simply reordering the statements. If
nilfs_sufile_cancel_freev is called before nilfs_segctor_extend_segments
the freed segments are marked as dirty and cannot be allocated any more.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Reviewed-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Tested-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segment.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 9f6b486..a1a1916 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1440,17 +1440,19 @@ static int nilfs_segctor_collect(struct nilfs_sc_info *sci,
 
 		nilfs_clear_logs(&sci->sc_segbufs);
 
-		err = nilfs_segctor_extend_segments(sci, nilfs, nadd);
-		if (unlikely(err))
-			return err;
-
 		if (sci->sc_stage.flags & NILFS_CF_SUFREED) {
 			err = nilfs_sufile_cancel_freev(nilfs->ns_sufile,
 							sci->sc_freesegs,
 							sci->sc_nfreesegs,
 							NULL);
 			WARN_ON(err); /* do not happen */
+			sci->sc_stage.flags &= ~NILFS_CF_SUFREED;
 		}
+
+		err = nilfs_segctor_extend_segments(sci, nilfs, nadd);
+		if (unlikely(err))
+			return err;
+
 		nadd = min_t(int, nadd << 1, SC_MAX_SEGDELTA);
 		sci->sc_stage = prev_stage;
 	}
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
