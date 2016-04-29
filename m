From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 07/11] nilfs2: get rid of nilfs_mdt_mark_block_dirty()
Date: Fri, 29 Apr 2016 22:15:43 +0900
Message-ID: <1461935747-10380-8-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1461935747-10380-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=r93VUy6m1ZcuHuUt+PRxMHyI92eTcGanqTupIWdYWuk=;
        b=B0RaybmeOM91suOzXmkh5WUVLufPrKQSJILYXtGZ/suKjUwmdk5eNFBtI/E3hip68E
         boFBNEeB9IzpbM9kI30SBwyk3zf5jz8vR230tIYrqifD/sUBcZzOpRsBpbdNP9TIAdPo
         yqARdOJubU+ZNCvZpVh+q/vs0MeXRG2TVgTwYhci0JWQDX6O4jo86k8bmf20A7PdpUnc
         Fz8RzHzZ03yMvTr2X8+wEbiwipmq6Jjlk6PAYu7D+fnqu5gpv6lUmMzs00n6jNJOpgMD
         DGB2gC2bfQmqGRTa9yXQw6aFGPwnLuXVVfrfUTYUVuGCCGxkKx76kyDDWIeYWHN4Y9E6
         ttnw==
In-Reply-To: <1461935747-10380-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

nilfs_mdt_mark_block_dirty() can be replaced with primary functions
like nilfs_mdt_get_block() and mark_buffer_dirty(), and it's used only
by nilfs_ioctl_mark_blocks_dirty().

This gets rid of the function to simplify the interface of metadata
file.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/ioctl.c | 11 ++++++++---
 fs/nilfs2/mdt.c   | 28 ----------------------------
 fs/nilfs2/mdt.h   |  1 -
 3 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index e865998..358b57e 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -779,6 +779,7 @@ static int nilfs_ioctl_mark_blocks_dirty(struct the_nilfs *nilfs,
 	size_t nmembs = argv->v_nmembs;
 	struct nilfs_bmap *bmap = NILFS_I(nilfs->ns_dat)->i_bmap;
 	struct nilfs_bdesc *bdescs = buf;
+	struct buffer_head *bh;
 	int ret, i;
 
 	for (i = 0; i < nmembs; i++) {
@@ -796,12 +797,16 @@ static int nilfs_ioctl_mark_blocks_dirty(struct the_nilfs *nilfs,
 			/* skip dead block */
 			continue;
 		if (bdescs[i].bd_level == 0) {
-			ret = nilfs_mdt_mark_block_dirty(nilfs->ns_dat,
-							 bdescs[i].bd_offset);
-			if (ret < 0) {
+			ret = nilfs_mdt_get_block(nilfs->ns_dat,
+						  bdescs[i].bd_offset,
+						  false, NULL, &bh);
+			if (unlikely(ret)) {
 				WARN_ON(ret == -ENOENT);
 				return ret;
 			}
+			mark_buffer_dirty(bh);
+			nilfs_mdt_mark_dirty(nilfs->ns_dat);
+			put_bh(bh);
 		} else {
 			ret = nilfs_bmap_mark(bmap, bdescs[i].bd_offset,
 					      bdescs[i].bd_level);
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 36fa941..c8fe584 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -389,34 +389,6 @@ int nilfs_mdt_forget_block(struct inode *inode, unsigned long block)
 	return ret;
 }
 
-/**
- * nilfs_mdt_mark_block_dirty - mark a block on the meta data file dirty.
- * @inode: inode of the meta data file
- * @block: block offset
- *
- * Return Value: On success, it returns 0. On error, the following negative
- * error code is returned.
- *
- * %-ENOMEM - Insufficient memory available.
- *
- * %-EIO - I/O error
- *
- * %-ENOENT - the specified block does not exist (hole block)
- */
-int nilfs_mdt_mark_block_dirty(struct inode *inode, unsigned long block)
-{
-	struct buffer_head *bh;
-	int err;
-
-	err = nilfs_mdt_read_block(inode, block, 0, &bh);
-	if (unlikely(err))
-		return err;
-	mark_buffer_dirty(bh);
-	nilfs_mdt_mark_dirty(inode);
-	brelse(bh);
-	return 0;
-}
-
 int nilfs_mdt_fetch_dirty(struct inode *inode)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index 54e3b7f..dc88907 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -79,7 +79,6 @@ int nilfs_mdt_find_block(struct inode *inode, unsigned long start,
 			 struct buffer_head **out_bh);
 int nilfs_mdt_delete_block(struct inode *, unsigned long);
 int nilfs_mdt_forget_block(struct inode *, unsigned long);
-int nilfs_mdt_mark_block_dirty(struct inode *, unsigned long);
 int nilfs_mdt_fetch_dirty(struct inode *);
 
 int nilfs_mdt_init(struct inode *inode, gfp_t gfp_mask, size_t objsz);
-- 
1.8.3.1

