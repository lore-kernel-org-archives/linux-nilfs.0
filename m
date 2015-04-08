From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/2] nilfs2: use inode_set_flags() in nilfs_set_inode_flags()
Date: Wed,  8 Apr 2015 23:49:45 +0900
Message-ID: <1428504585-1111-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1428504585-1111-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=zka7YqHqDO1odJH13+MwwaspxCWdHPm3YjVPRv8ESBo=;
        b=j17RGBjS4YmLB4P44bWg0BMdBm0579g6uRIv3bIYOpLDBmE7/sDnFMLZ0UEipWYxX2
         Zj1x4Mphn4WUycONsLGP04gKA85QfTDMal2Mey+3xRrGylPJbxEXiQo2FkRJ/cq/Yi+6
         QigEFDxgOga6YOVF4T0REQ2QP7LFpc0bNfp93lyWeGXE51BqYEU1foU3p1z8Do00+5OG
         TjEWHgZ1OiV0iK3b/2IIwhH3oBUPA4o0DDK1ifgu+bRdz+zcKgf/om+tPfwhfpjgMbS8
         TtOXHoirAeH98TZofjAC46egJUlHZMoh2dfLrjNpa5k+HC1zYqr0lIP6bSqrv6nCjm0H
         8RLQ==
In-Reply-To: <1428504585-1111-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>

Use inode_set_flags() to atomically set i_flags instead of clearing
out the S_IMMUTABLE, S_APPEND, etc. flags and then setting them from
the FS_IMMUTABLE_FL, FS_APPEND_FL flags to avoid a race where an
immutable file has the immutable flag cleared for a brief window of
time.

This is a similar fix to commit 5f16f3225b06 ("ext4: atomically set
inode->i_flags in ext4_set_inode_flags()").

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
---
 fs/nilfs2/inode.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 0c28ccb..72c7fbf 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -443,19 +443,20 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 void nilfs_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = NILFS_I(inode)->i_flags;
+	unsigned int new_fl = 0;
 
-	inode->i_flags &= ~(S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME |
-			    S_DIRSYNC);
 	if (flags & FS_SYNC_FL)
-		inode->i_flags |= S_SYNC;
+		new_fl |= S_SYNC;
 	if (flags & FS_APPEND_FL)
-		inode->i_flags |= S_APPEND;
+		new_fl |= S_APPEND;
 	if (flags & FS_IMMUTABLE_FL)
-		inode->i_flags |= S_IMMUTABLE;
+		new_fl |= S_IMMUTABLE;
 	if (flags & FS_NOATIME_FL)
-		inode->i_flags |= S_NOATIME;
+		new_fl |= S_NOATIME;
 	if (flags & FS_DIRSYNC_FL)
-		inode->i_flags |= S_DIRSYNC;
+		new_fl |= S_DIRSYNC;
+	inode_set_flags(inode, new_fl, S_SYNC | S_APPEND | S_IMMUTABLE |
+			S_NOATIME | S_DIRSYNC);
 }
 
 int nilfs_read_inode_common(struct inode *inode,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
