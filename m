From: Eric Biggers <ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] nilfs2: only call unlock_new_inode() if I_NEW
Date: Sun, 28 Jun 2020 00:01:52 -0700
Message-ID: <20200628070152.820311-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593327770;
        bh=kfgopL0W3FtXqsVa/V5I6oQEZ9ZcW4URkZcEXEWUVKo=;
        h=From:To:Cc:Subject:Date:From;
        b=IYeU8A+Tvxs0WSfkv8jixPZMMpRMTIle7EdHOg6Tl5HgyFqfJAPx31xAACKxMxS2b
         OphWbGZwru9rEl9chZHBkKdd8Un94ahNMrfbRyr+nFMXcW/5wZ2PA7zERsy4UWjRQl
         qjoleNut6qzThofLcauuILWD4VHFr4jXiWlNTEEw=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

unlock_new_inode() is only meant to be called after a new inode has
already been inserted into the hash table.  But nilfs_new_inode() can
call it even before it has inserted the inode, triggering the WARNING in
unlock_new_inode().  Fix this by only calling unlock_new_inode() if the
inode has the I_NEW flag set, indicating that it's in the table.

Signed-off-by: Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 fs/nilfs2/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 28009ec54420..3318dd1350b2 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -388,7 +388,8 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 
  failed_after_creation:
 	clear_nlink(inode);
-	unlock_new_inode(inode);
+	if (inode->i_state & I_NEW)
+		unlock_new_inode(inode);
 	iput(inode);  /*
 		       * raw_inode will be deleted through
 		       * nilfs_evict_inode().
-- 
2.27.0

