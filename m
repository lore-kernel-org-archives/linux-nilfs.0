From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCHv2 2/5] nilfs2: mark S_NOATIME on inodes only if NOATIME attribute is set
Date: Fri,  4 Feb 2011 00:20:11 +0900
Message-ID: <1296746414-11444-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1296746414-11444-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296746414-11444-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

At present, nilfs marks S_NOATIME flag on all inodes.  This restricts
nilfs_set_inode_flags function so that it marks S_NOATIME only if a
given inode has an FS_NOATIME_FL flag.

Although nilfs does not support atime yet, touch_atime() still safely
returns on IS_NOATIME check since MS_NOATIME is always set on sb.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/inode.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index b97bcfc..2db4e92 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -365,9 +365,7 @@ void nilfs_set_inode_flags(struct inode *inode)
 		inode->i_flags |= S_APPEND;
 	if (flags & FS_IMMUTABLE_FL)
 		inode->i_flags |= S_IMMUTABLE;
-#ifndef NILFS_ATIME_DISABLE
 	if (flags & FS_NOATIME_FL)
-#endif
 		inode->i_flags |= S_NOATIME;
 	if (flags & FS_DIRSYNC_FL)
 		inode->i_flags |= S_DIRSYNC;
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
