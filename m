From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: use checkpoint number instead of timestamp to select super block
Date: Sat,  1 May 2010 13:49:28 +0900
Message-ID: <1272689368-10335-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1272689368-10335-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1272689368-10335-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Nilfs maintains two super blocks, and selects the new one on mount
time if they both have valid checksums and their timestamps differ.

However, this has potential for mis-selection since the system clock
may be rewinded and the resolution of the timestamps is not high.

Usually this doesn't become an issue because both super blocks are
updated at the same time when the file system is unmounted.  Even if
the file system wasn't unmounted cleanly, the roll-forward recovery
will find the proper log which stores the latest super root.  Thus,
the issue can appear only if update of one super block fails and the
clock happens to be rewinded.

This fixes the issue by using checkpoint numbers instead of timestamps
to pick the super block storing the location of the latest log.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/the_nilfs.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 33871f7..a756168 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -486,11 +486,15 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
 		printk(KERN_WARNING
 		       "NILFS warning: unable to read secondary superblock\n");
 
+	/*
+	 * Compare two super blocks and set 1 in swp if the secondary
+	 * super block is valid and newer.  Otherwise, set 0 in swp.
+	 */
 	valid[0] = nilfs_valid_sb(sbp[0]);
 	valid[1] = nilfs_valid_sb(sbp[1]);
-	swp = valid[1] &&
-		(!valid[0] ||
-		 le64_to_cpu(sbp[1]->s_wtime) > le64_to_cpu(sbp[0]->s_wtime));
+	swp = valid[1] && (!valid[0] ||
+			   le64_to_cpu(sbp[1]->s_last_cno) >
+			   le64_to_cpu(sbp[0]->s_last_cno));
 
 	if (valid[swp] && nilfs_sb2_bad_offset(sbp[swp], sb2off)) {
 		brelse(sbh[1]);
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
