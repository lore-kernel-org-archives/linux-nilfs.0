From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] nilfs2: fix false warning saying one of two super blocks is broken
Date: Sun, 15 Aug 2010 21:54:57 +0900
Message-ID: <1281876897-17810-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

After applying commit b2ac86e1, the following message got appeared
after unclean shutdown:

> NILFS warning: broken superblock. using spare superblock.

This turns out to be a false message due to the change which updates
two super blocks alternately.  The secondary super block now can be
selected if it's newer than the primary one.

This kills the false warning by suppressing it if another super block
is not actually broken.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/the_nilfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 37de1f0..6af1c00 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -608,11 +608,11 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
 		return -EINVAL;
 	}
 
-	if (swp) {
+	if (!valid[!swp])
 		printk(KERN_WARNING "NILFS warning: broken superblock. "
 		       "using spare superblock.\n");
+	if (swp)
 		nilfs_swap_super_block(nilfs);
-	}
 
 	nilfs->ns_sbwcount = 0;
 	nilfs->ns_sbwtime = le64_to_cpu(sbp[0]->s_wtime);
-- 
1.6.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
