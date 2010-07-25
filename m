From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: reject filesystem with unsupported block size
Date: Mon, 26 Jul 2010 01:00:08 +0900
Message-ID: <1280073608-17772-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1280073608-17772-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280073608-17772-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This inserts sanity check that refuses to mount a filesystem with
unsupported block size.

Previously, kernel code of nilfs was looking only limitation of
devices though mkfs.nilfs2 limits the range of block sizes; there was
no check that prevents rec_len overflow with larger block sizes.

With this change, block sizes larger than 64KB or smaller than 1KB
will get rejected explicitly by kernel.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/the_nilfs.c     |    9 ++++++++-
 include/linux/nilfs2_fs.h |    6 ++++++
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index da67b56..37de1f0 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -671,7 +671,7 @@ int init_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi, char *data)
 		goto out;
 	}
 
-	blocksize = sb_min_blocksize(sb, BLOCK_SIZE);
+	blocksize = sb_min_blocksize(sb, NILFS_MIN_BLOCK_SIZE);
 	if (!blocksize) {
 		printk(KERN_ERR "NILFS: unable to set blocksize\n");
 		err = -EINVAL;
@@ -690,6 +690,13 @@ int init_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi, char *data)
 		goto failed_sbh;
 
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbp->s_log_block_size);
+	if (blocksize < NILFS_MIN_BLOCK_SIZE ||
+	    blocksize > NILFS_MAX_BLOCK_SIZE) {
+		printk(KERN_ERR "NILFS: couldn't mount because of unsupported "
+		       "filesystem blocksize %d\n", blocksize);
+		err = -EINVAL;
+		goto failed_sbh;
+	}
 	if (sb->s_blocksize != blocksize) {
 		int hw_blocksize = bdev_logical_block_size(sb->s_bdev);
 
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 970828a..f5487b6 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -287,6 +287,12 @@ struct nilfs_super_block {
 #define NILFS_NAME_LEN 255
 
 /*
+ * Block size limitations
+ */
+#define NILFS_MIN_BLOCK_SIZE		1024
+#define NILFS_MAX_BLOCK_SIZE		65536
+
+/*
  * The new version of the directory entry.  Since V0 structures are
  * stored in intel byte order, and the name_len field could never be
  * bigger than 255 chars, it's safe to reclaim the extra byte for the
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
