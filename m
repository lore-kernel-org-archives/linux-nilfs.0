From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: add missing initialization of s_mode
Date: Sun,  9 May 2010 03:36:24 +0900
Message-ID: <1273343784-22709-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1273343784-22709-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1273343784-22709-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

A fmode_t argument is passed to kill_block_super() through s_mode
member of the super_block structure.  This is used to release the
block device with the same mode, however, nilfs does not set s_mode.

This modifies nilfs_get_sb function to properly initialize the s_mode
member.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 40eb231..7772e43 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1071,6 +1071,7 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 
 		/* New superblock instance created */
 		s->s_flags = flags;
+		s->s_mode = mode;
 		strlcpy(s->s_id, bdevname(sd.bdev, b), sizeof(s->s_id));
 		sb_set_blocksize(s, block_size(sd.bdev));
 
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
