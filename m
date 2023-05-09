From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: fix use-after-free bug of nilfs_root in nilfs_evict_inode()
Date: Wed, 10 May 2023 00:29:56 +0900
Message-ID: <20230509152956.8313-1-konishi.ryusuke@gmail.com>
References: <00000000000099e5ac05fb1c3b85@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683646201; x=1686238201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IQP5RmhoA0Bn4VTuliIuZoGARX235KvX0CQ2pSlL4VE=;
        b=Ky+3UC8yvYNW4dMgABGgVl/Fpyy+4QXbHzMp04GgL5wPxGzSMJIpqqXqL7dtyttYfQ
         K72dnBATABy/0hZLK2Nb2NpY0X2sYIWOK30ZUhkXQDWf600l+R6xQWN8THuOpY1UY2Ib
         6cNQZpHhR8bDQThrP6KrG7OeJXbZLnlfOplC2PBpcrBARIHh3ZP7uScdE4m3qPJWVWPX
         4sVpGA7dZa40CHugC3oi5NrKCZdsxCX4loOj+I3DK6NfpCTI/La7nbqjLmdcu1Vk1YW2
         CgfD6eAp4kKIOvgTFDfac9aKYKF/1HegsrsX9GLSl4IeAiIbr/rI6BcnGt18nX7Umg8X
         ITcg==
In-Reply-To: <00000000000099e5ac05fb1c3b85-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot <syzbot+78d4495558999f55d1da-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

During unmount process of nilfs2, nothing holds nilfs_root structure after
nilfs2 detaches its writer in nilfs_detach_log_writer().  However, since
nilfs_evict_inode() uses nilfs_root for some cleanup operations, it may
cause use-after-free read if inodes are left in "garbage_list" and
released by nilfs_dispose_list() at the end of nilfs_detach_log_writer().

Fix this issue by modifying nilfs_evict_inode() to only clear inode
without additional metadata changes that use nilfs_root if the file system
is degraded to read-only or the writer is detached.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: syzbot+78d4495558999f55d1da-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Closes: https://lkml.kernel.org/r/00000000000099e5ac05fb1c3b85-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Tested-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 fs/nilfs2/inode.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 1310d2d5feb3..a8ce522ac747 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -917,6 +917,7 @@ void nilfs_evict_inode(struct inode *inode)
 	struct nilfs_transaction_info ti;
 	struct super_block *sb = inode->i_sb;
 	struct nilfs_inode_info *ii = NILFS_I(inode);
+	struct the_nilfs *nilfs;
 	int ret;
 
 	if (inode->i_nlink || !ii->i_root || unlikely(is_bad_inode(inode))) {
@@ -929,6 +930,23 @@ void nilfs_evict_inode(struct inode *inode)
 
 	truncate_inode_pages_final(&inode->i_data);
 
+	nilfs = sb->s_fs_info;
+	if (unlikely(sb_rdonly(sb) || !nilfs->ns_writer)) {
+		/*
+		 * If this inode is about to be disposed after the file system
+		 * has been degraded to read-only due to file system corruption
+		 * or after the writer has been detached, do not make any
+		 * changes that cause writes, just clear it.
+		 * Do this check after read-locking ns_segctor_sem by
+		 * nilfs_transaction_begin() in order to avoid a race with
+		 * the writer detach operation.
+		 */
+		clear_inode(inode);
+		nilfs_clear_inode(inode);
+		nilfs_transaction_abort(sb);
+		return;
+	}
+
 	/* TODO: some of the following operations may fail.  */
 	nilfs_truncate_bmap(ii, 0);
 	nilfs_mark_inode_dirty(inode);
-- 
2.34.1

