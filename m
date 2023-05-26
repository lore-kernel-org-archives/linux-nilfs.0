From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: reject devices with insufficient block count
Date: Fri, 26 May 2023 11:13:32 +0900
Message-ID: <20230526021332.3431-1-konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685067217; x=1687659217;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QSOPIG+RVxNo5vuZ8u1mK3wQtN0fLH9sHRFk/xhggWM=;
        b=fWeyP/8nk9xU/iNM5QXfW7bydffNvcJsXC8JYMMKylO6va0zhO/DV8A9umLRlFKojx
         2k3zjZsFNoKCV7q7n7iQ1ebl8rnbr84jaEhJR4dnOvdBt/ohZyiCfwf3OuqyDyA1d0Se
         dBaIeofXNexP2+vnK1kI6iXZhBpeChTfcemI7Olc01psaRbP7yFGhhI6t3o2CJHAFOJo
         5/g4jVO12rpPfKlA3F/vQUMn2v1idL50K1gi/Ew/mDIXZXtbBEUou1787rxHODaJClNF
         jjQFH7vllLxmWEMSXRqKzXSs+QnRJprMOMz4GwxqpFdf0nUEd9QDWEK5pZVwK8YVrqOL
         ykKA==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot <syzbot+7d50f1e54a12ba3aeae2-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The current sanity check for nilfs2 geometry information lacks checks for
the number of segments stored in superblocks, so even for device images
that have been destructively truncated or have an unusually high number
of segments, the mount operation may succeed.

This causes out-of-bounds block I/O on file system block reads or log
writes to the segments, the latter in particular causing
"a_ops->writepages" to repeatedly fail, resulting in sync_inodes_sb()
to hang.

Fix this issue by checking the number of segments stored in the
superblock and avoiding mounting devices that can cause out-of-bounds
accesses.  To eliminate the possibility of overflow when calculating the
number of blocks required for the device from the number of segments,
this also adds a helper function to calculate the upper bound on the
number of segments and inserts a check using it.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: syzbot+7d50f1e54a12ba3aeae2-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Link: https://syzkaller.appspot.com/bug?extid=7d50f1e54a12ba3aeae2
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 fs/nilfs2/the_nilfs.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 2894152a6b25..0f0667957c81 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -405,6 +405,18 @@ unsigned long nilfs_nrsvsegs(struct the_nilfs *nilfs, unsigned long nsegs)
 				  100));
 }
 
+/**
+ * nilfs_max_segment_count - calculate the maximum number of segments
+ * @nilfs: nilfs object
+ */
+static u64 nilfs_max_segment_count(struct the_nilfs *nilfs)
+{
+	u64 max_count = U64_MAX;
+
+	do_div(max_count, nilfs->ns_blocks_per_segment);
+	return min_t(u64, max_count, ULONG_MAX);
+}
+
 void nilfs_set_nsegments(struct the_nilfs *nilfs, unsigned long nsegs)
 {
 	nilfs->ns_nsegments = nsegs;
@@ -414,6 +426,8 @@ void nilfs_set_nsegments(struct the_nilfs *nilfs, unsigned long nsegs)
 static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
 				   struct nilfs_super_block *sbp)
 {
+	u64 nsegments, nblocks;
+
 	if (le32_to_cpu(sbp->s_rev_level) < NILFS_MIN_SUPP_REV) {
 		nilfs_err(nilfs->ns_sb,
 			  "unsupported revision (superblock rev.=%d.%d, current rev.=%d.%d). Please check the version of mkfs.nilfs(2).",
@@ -457,7 +471,34 @@ static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
 		return -EINVAL;
 	}
 
-	nilfs_set_nsegments(nilfs, le64_to_cpu(sbp->s_nsegments));
+	nsegments = le64_to_cpu(sbp->s_nsegments);
+	if (nsegments > nilfs_max_segment_count(nilfs)) {
+		nilfs_err(nilfs->ns_sb,
+			  "segment count %llu exceeds upper limit (%llu segments)",
+			  (unsigned long long)nsegments,
+			  (unsigned long long)nilfs_max_segment_count(nilfs));
+		return -EINVAL;
+	}
+
+	nblocks = sb_bdev_nr_blocks(nilfs->ns_sb);
+	if (nblocks) {
+		u64 min_block_count = nsegments * nilfs->ns_blocks_per_segment;
+		/*
+		 * To avoid failing to mount early device images without a
+		 * second superblock, exclude that block count from the
+		 * "min_block_count" calculation.
+		 */
+
+		if (nblocks < min_block_count) {
+			nilfs_err(nilfs->ns_sb,
+				  "total number of segment blocks %llu exceeds device size (%llu blocks)",
+				  (unsigned long long)min_block_count,
+				  (unsigned long long)nblocks);
+			return -EINVAL;
+		}
+	}
+
+	nilfs_set_nsegments(nilfs, nsegments);
 	nilfs->ns_crc_seed = le32_to_cpu(sbp->s_crc_seed);
 	return 0;
 }
-- 
2.34.1

