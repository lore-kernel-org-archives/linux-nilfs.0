From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 6/6] nilfs2: remove whitespaces before quoted newlines
Date: Sun, 14 Mar 2010 11:28:39 +0900
Message-ID: <1268533719-19454-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1268533719-19454-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1268533719-19454-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This kills the following checkpatch warnings:

 WARNING: unnecessary whitespace before a quoted newline
 #869: FILE: super.c:869:
 +     	           "remount to a different snapshot. \n",

 WARNING: unnecessary whitespace before a quoted newline
 #389: FILE: the_nilfs.c:389:
 +     	    printk(KERN_ERR "NILFS: too short segment. \n");

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c     |    2 +-
 fs/nilfs2/the_nilfs.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 896b463..0cdbc5e 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -866,7 +866,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	if ((*flags & MS_RDONLY) &&
 	    sbi->s_snapshot_cno != old_opts.snapshot_cno) {
 		printk(KERN_WARNING "NILFS (device %s): couldn't "
-		       "remount to a different snapshot. \n",
+		       "remount to a different snapshot.\n",
 		       sb->s_id);
 		err = -EINVAL;
 		goto restore_opts;
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 92733d5..33871f7 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -386,7 +386,7 @@ static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
 
 	nilfs->ns_blocks_per_segment = le32_to_cpu(sbp->s_blocks_per_segment);
 	if (nilfs->ns_blocks_per_segment < NILFS_SEG_MIN_BLOCKS) {
-		printk(KERN_ERR "NILFS: too short segment. \n");
+		printk(KERN_ERR "NILFS: too short segment.\n");
 		return -EINVAL;
 	}
 
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
