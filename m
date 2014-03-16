From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 1/4] nilfs-utils: remove reliance on sui_nblocks to read segment
Date: Sun, 16 Mar 2014 11:49:15 +0100
Message-ID: <36b7f57861b69c7fdb9d9e54a21df6f5c7f21061.1394966935.git.andreas.rohner@gmx.net>
References: <cover.1394966728.git.andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1394966728.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Since sui_nblocks is reused to represent the number of live blocks in a
segment it cannot be used any more to mark the end of the segment.
Instead the sequence number of the partial segments is checked. The
sequence number of partial segments should all be the same. The usual
CRC checks should be enough to reliably determine the end of a segment.

Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
---
 include/nilfs.h | 1 +
 lib/gc.c        | 5 ++---
 lib/nilfs.c     | 4 +++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/nilfs.h b/include/nilfs.h
index fab8ff2..05cfe3b 100644
--- a/include/nilfs.h
+++ b/include/nilfs.h
@@ -185,6 +185,7 @@ struct nilfs_psegment {
 	size_t p_maxblocks;
 	size_t p_blksize;
 	__u32 p_seed;
+	__u64 p_seq;
 };
 
 /**
diff --git a/lib/gc.c b/lib/gc.c
index 453acf2..a165a5c 100644
--- a/lib/gc.c
+++ b/lib/gc.c
@@ -273,9 +273,8 @@ static ssize_t nilfs_acc_blocks(struct nilfs *nilfs,
 				return -1;
 			continue;
 		}
-		ret = nilfs_acc_blocks_segment(
-			nilfs, segnums[i], segment, si.sui_nblocks,
-			vdescv, bdescv);
+		ret = nilfs_acc_blocks_segment(nilfs, segnums[i], segment,
+			nilfs_get_blocks_per_segment(nilfs), vdescv, bdescv);
 		if (nilfs_put_segment(nilfs, segment) < 0 || ret < 0)
 			return -1;
 		i++;
diff --git a/lib/nilfs.c b/lib/nilfs.c
index 65bf7d5..e8f5c96 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -900,7 +900,8 @@ static int nilfs_psegment_is_valid(const struct nilfs_psegment *pseg)
 {
 	int offset;
 
-	if (le32_to_cpu(pseg->p_segsum->ss_magic) != NILFS_SEGSUM_MAGIC)
+	if (le32_to_cpu(pseg->p_segsum->ss_magic) != NILFS_SEGSUM_MAGIC ||
+			le64_to_cpu(pseg->p_segsum->ss_seq) != pseg->p_seq)
 		return 0;
 
 	offset = sizeof(pseg->p_segsum->ss_datasum) +
@@ -928,6 +929,7 @@ void nilfs_psegment_init(struct nilfs_psegment *pseg, __u64 segnum,
 	pseg->p_seed = le32_to_cpu(nilfs->n_sb->s_crc_seed);
 
 	pseg->p_segsum = seg + blkoff * pseg->p_blksize;
+	pseg->p_seq = le64_to_cpu(pseg->p_segsum->ss_seq);
 	pseg->p_blocknr = pseg->p_segblocknr;
 }
 
-- 
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
