From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: fix potential use after free in nilfs_gccache_submit_read_data()
Date: Thu, 21 Sep 2023 23:17:31 +0900
Message-ID: <20230921141731.10073-1-konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695315941; x=1695920741; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=njolLyWGYw3vA9Xc4YsCkH7k9TvdmzjireB5CtmLsDw=;
        b=fWXNmgQB8Eogrhj3SP+0GjBqEWe8MePSWeXlfjTVTtyfmzybRkY0RLsLX3xWccU+b2
         Js2H5IMM6rqicMx/DuZYtuSp1arLlJkTkNYj2/7mXmF58gTF4xSxpExGhUunJVcz7YDH
         L77ljqBJ3pk64rtDNU6nKYSl2AS0GXurwFd76w9OTdsRcA0Jme7xcpogHVnPv2SnLhTm
         s5Ppg9AVr1Q6L9zOq4XruXlt+0W9Iy4f5e3hr3+1kguSxi/FMopzHbdSK1RwI4CT8iX6
         pU/Qxzdyf1JZU2rL+9U6Qs20kWlQ7pwyIiZP1uiNrxEpqaaAW4QE7gLCOZVYdNU+OJCi
         f51A==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>

In nilfs_gccache_submit_read_data(), brelse(bh) is called to drop the
reference count of bh when the call to nilfs_dat_translate() fails.  If
the reference count hits 0 and its owner page gets unlocked, bh may be
freed.  However, bh->b_page is dereferenced to put the page after that,
which may result in a use-after-free bug.  This patch moves the release
operation after unlocking and putting the page.

NOTE: The function in question is only called in GC, and in combination
with current userland tools, address translation using DAT does not occur
in that function, so the code path that causes this issue will not be
executed.  However, it is possible to run that code path by intentionally
modifying the userland GC library or by calling the GC ioctl directly.

Link: https://lkml.kernel.org/r/1543201709-53191-1-git-send-email-bianpan2016-9Onoh4P/yGk@public.gmane.org
Signed-off-by: Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
Reported-by: Ferry Meng <mengferry-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Closes: https://lkml.kernel.org/r/20230818092022.111054-1-mengferry-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org
Fixes: a3d93f709e89 ("nilfs2: block cache for garbage collection")
[konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org: NOTE added to the commit log]
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
fs/nilfs2/gcinode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 48fe71d309cb..8beb2730929d 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -73,10 +73,8 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
 		struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 
 		err = nilfs_dat_translate(nilfs->ns_dat, vbn, &pbn);
-		if (unlikely(err)) { /* -EIO, -ENOMEM, -ENOENT */
-			brelse(bh);
+		if (unlikely(err)) /* -EIO, -ENOMEM, -ENOENT */
 			goto failed;
-		}
 	}
 
 	lock_buffer(bh);
@@ -102,6 +100,8 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
  failed:
 	unlock_page(bh->b_page);
 	put_page(bh->b_page);
+	if (unlikely(err))
+		brelse(bh);
 	return err;
 }
 
-- 
2.34.1

