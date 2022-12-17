From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH AUTOSEL 5.10 6/9] nilfs2: fix shift-out-of-bounds/overflow in nilfs_sb2_bad_offset()
Date: Sat, 17 Dec 2022 10:29:23 -0500
Message-ID: <20221217152927.99012-6-sashal@kernel.org>
References: <20221217152927.99012-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290979;
        bh=IphdAMJ66tqZu+zaLbnpmZ0S25J5Xgvanlbbpz8qojM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qUB30mAV81ycTYSJkfZlkPWN6vJtm9UFVkL61BdueYnkWWN8uQnJ5oF7XQwLh/42U
         jTd+CAytjZprPO++BsL893trvMJ8S06oCj0wdUMmNUb6sU7h54uMOym5jBYy9i8ber
         uJnuAv2uvhcDtedGkV50rhmoWl5CGDnU0061x0q43uFngp9w8+dOz6GdP7aKmLi5uM
         8zZ01xZWmGCgGCG8yTEdojCMrYA/BbBc3yQJuPMRI0ICrQtieHePAxwVbH06tWwst2
         qAyvZIyJoirK8wMI+pCmdQPTan5t+wgIZcRsHGIjw6jeQBHut8yARH1QDpy5sGxJEQ
         CSY+fedlgkmpA==
In-Reply-To: <20221217152927.99012-1-sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, syzbot+e91619dd4c11c4960706-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

[ Upstream commit 610a2a3d7d8be3537458a378ec69396a76c385b6 ]

Patch series "nilfs2: fix UBSAN shift-out-of-bounds warnings on mount
time".

The first patch fixes a bug reported by syzbot, and the second one fixes
the remaining bug of the same kind.  Although they are triggered by the
same super block data anomaly, I divided it into the above two because the
details of the issues and how to fix it are different.

Both are required to eliminate the shift-out-of-bounds issues at mount
time.

This patch (of 2):

If the block size exponent information written in an on-disk superblock is
corrupted, nilfs_sb2_bad_offset helper function can trigger
shift-out-of-bounds warning followed by a kernel panic (if panic_on_warn
is set):

 shift exponent 38983 is too large for 64-bit type 'unsigned long long'
 Call Trace:
  <TASK>
  __dump_stack lib/dump_stack.c:88 [inline]
  dump_stack_lvl+0x1b1/0x28e lib/dump_stack.c:106
  ubsan_epilogue lib/ubsan.c:151 [inline]
  __ubsan_handle_shift_out_of_bounds+0x33d/0x3b0 lib/ubsan.c:322
  nilfs_sb2_bad_offset fs/nilfs2/the_nilfs.c:449 [inline]
  nilfs_load_super_block+0xdf5/0xe00 fs/nilfs2/the_nilfs.c:523
  init_nilfs+0xb7/0x7d0 fs/nilfs2/the_nilfs.c:577
  nilfs_fill_super+0xb1/0x5d0 fs/nilfs2/super.c:1047
  nilfs_mount+0x613/0x9b0 fs/nilfs2/super.c:1317
  ...

In addition, since nilfs_sb2_bad_offset() performs multiplication without
considering the upper bound, the computation may overflow if the disk
layout parameters are not normal.

This fixes these issues by inserting preliminary sanity checks for those
parameters and by converting the comparison from one involving
multiplication and left bit-shifting to one using division and right
bit-shifting.

Link: https://lkml.kernel.org/r/20221027044306.42774-1-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Link: https://lkml.kernel.org/r/20221027044306.42774-2-konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: syzbot+e91619dd4c11c4960706-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Signed-off-by: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 fs/nilfs2/the_nilfs.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index ce103dd39b89..6e2ccdd79c89 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -13,6 +13,7 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/random.h>
+#include <linux/log2.h>
 #include <linux/crc32.h>
 #include "nilfs.h"
 #include "segment.h"
@@ -443,11 +444,33 @@ static int nilfs_valid_sb(struct nilfs_super_block *sbp)
 	return crc == le32_to_cpu(sbp->s_sum);
 }
 
-static int nilfs_sb2_bad_offset(struct nilfs_super_block *sbp, u64 offset)
+/**
+ * nilfs_sb2_bad_offset - check the location of the second superblock
+ * @sbp: superblock raw data buffer
+ * @offset: byte offset of second superblock calculated from device size
+ *
+ * nilfs_sb2_bad_offset() checks if the position on the second
+ * superblock is valid or not based on the filesystem parameters
+ * stored in @sbp.  If @offset points to a location within the segment
+ * area, or if the parameters themselves are not normal, it is
+ * determined to be invalid.
+ *
+ * Return Value: true if invalid, false if valid.
+ */
+static bool nilfs_sb2_bad_offset(struct nilfs_super_block *sbp, u64 offset)
 {
-	return offset < ((le64_to_cpu(sbp->s_nsegments) *
-			  le32_to_cpu(sbp->s_blocks_per_segment)) <<
-			 (le32_to_cpu(sbp->s_log_block_size) + 10));
+	unsigned int shift_bits = le32_to_cpu(sbp->s_log_block_size);
+	u32 blocks_per_segment = le32_to_cpu(sbp->s_blocks_per_segment);
+	u64 nsegments = le64_to_cpu(sbp->s_nsegments);
+	u64 index;
+
+	if (blocks_per_segment < NILFS_SEG_MIN_BLOCKS ||
+	    shift_bits > ilog2(NILFS_MAX_BLOCK_SIZE) - BLOCK_SIZE_BITS)
+		return true;
+
+	index = offset >> (shift_bits + BLOCK_SIZE_BITS);
+	do_div(index, blocks_per_segment);
+	return index < nsegments;
 }
 
 static void nilfs_release_super_block(struct the_nilfs *nilfs)
-- 
2.35.1

