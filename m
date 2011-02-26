From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/2] nilfs-utils: do not count used blocks for dat and cpfile and sufile
Date: Sun, 27 Feb 2011 01:48:17 +0900
Message-ID: <1298738897-13480-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1298738897-13480-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1298738897-13480-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

The number of used blocks by DAT file, cpfile, and sufile changes
independently of those of checkpoints.  So, we stop including the
block count of those meta data files in block count of a checkpoint.

Note that the block count of ifile is still included in the block
count.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 sbin/mkfs/mkfs.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index 0eeb859..0c3ff4e 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -173,7 +173,6 @@ struct nilfs_segment_info {
 	struct nilfs_file_info files[MAX_FILES];
 
 	unsigned        nvblocknrs;
-	unsigned        nblocks_used;
 	/* + super root (1 block)*/
 };
 
@@ -533,7 +532,6 @@ static void fix_disk_layout(struct nilfs_disk_info *di)
 		struct nilfs_segment_info *si = &di->seginfo[i];
 		blocknr_t blocknr = si->start + si->nblk_sum;
 
-		si->nblocks_used = (di->nblocks_used += si->nblocks);
 		si->nblocks += si->nblk_sum + 1 /* summary and super root */;
 		if (si->nblocks > di->blocks_per_segment)
 			too_small_segment(di->blocks_per_segment, si->nblocks);
@@ -545,6 +543,11 @@ static void fix_disk_layout(struct nilfs_disk_info *di)
 				continue;
 			fi->start = blocknr;
 			blocknr += fi->nblocks;
+
+			if (fi->ino != NILFS_DAT_INO &&
+			    fi->ino != NILFS_SUFILE_INO &&
+			    fi->ino != NILFS_CPFILE_INO)
+				di->nblocks_used += fi->nblocks;
 		}
 		if (di->nblocks_to_write < si->start + si->nblocks)
 			di->nblocks_to_write = si->start + si->nblocks;
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
