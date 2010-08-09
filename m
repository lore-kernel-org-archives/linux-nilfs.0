From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: accept future revisions
Date: Tue, 10 Aug 2010 02:35:10 +0900
Message-ID: <1281375310-6110-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Compatibility of nilfs partitions is now managed with three feature
sets.  This changes old compatibility check with revision number so
that it can accept future revisions.

Note that we can stop support of experimental versions of nilfs that
doesn't know the feature sets by incrementing NILFS_CURRENT_REV.  We
don't have to do it soon, but it would be a possible option whenever
the need arises.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/the_nilfs.c     |    4 ++--
 include/linux/nilfs2_fs.h |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 37de1f0..a92b16f 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -467,8 +467,8 @@ static unsigned long long nilfs_max_size(unsigned int blkbits)
 static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
 				   struct nilfs_super_block *sbp)
 {
-	if (le32_to_cpu(sbp->s_rev_level) != NILFS_CURRENT_REV) {
-		printk(KERN_ERR "NILFS: revision mismatch "
+	if (le32_to_cpu(sbp->s_rev_level) < NILFS_MIN_SUPP_REV) {
+		printk(KERN_ERR "NILFS: unsupported revision "
 		       "(superblock rev.=%d.%d, current rev.=%d.%d). "
 		       "Please check the version of mkfs.nilfs.\n",
 		       le32_to_cpu(sbp->s_rev_level),
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index f5487b6..b07f5cd 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -229,6 +229,7 @@ struct nilfs_super_block {
  */
 #define NILFS_CURRENT_REV	2	/* current major revision */
 #define NILFS_MINOR_REV		0	/* minor revision */
+#define NILFS_MIN_SUPP_REV	2	/* minimum supported revision */
 
 /*
  * Feature set definitions
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
