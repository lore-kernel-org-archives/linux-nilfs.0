From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: add missing endian conversion on super block magic number
Date: Sat,  1 May 2010 13:49:27 +0900
Message-ID: <1272689368-10335-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This adds missing endian conversions in comparision of the magic
number of super blocks.  It was coincidence that prior versions didn't
incur problems; the upper byte of the magic number happened to be
equal to the lower byte.  But, semantically it's wrong to depend on
this.

This won't change anything else nor suffer any compatibility issues.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 51f3802..f6cff39 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -242,8 +242,8 @@ int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
 	int err;
 
 	/* nilfs->sem must be locked by the caller. */
-	if (sbp[0]->s_magic != NILFS_SUPER_MAGIC) {
-		if (sbp[1] && sbp[1]->s_magic == NILFS_SUPER_MAGIC)
+	if (sbp[0]->s_magic != cpu_to_le16(NILFS_SUPER_MAGIC)) {
+		if (sbp[1] && sbp[1]->s_magic == cpu_to_le16(NILFS_SUPER_MAGIC))
 			nilfs_swap_super_block(nilfs);
 		else {
 			printk(KERN_CRIT "NILFS: superblock broke on dev %s\n",
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
