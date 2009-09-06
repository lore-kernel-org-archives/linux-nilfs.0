From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: [PATCH] nilfs2: always lookup disk block address
 before reading metadata block
Date: Sun, 06 Sep 2009 20:19:55 +0900 (JST)
Message-ID: <20090906.201955.132648852.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

This is a patch related to the filesystem corruption problem in nilfs.

I'm not sure if this will resolve the corruption problem in question,
but it fixes a potential problem that may cause corruption.

For the moment, I'll treat this as a 2.6.32 material unless this turns
out to make a difference for the problem.

Thanks,
Ryusuke Konishi

--
From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

The current metadata file code skips disk address lookup for its data
block if the buffer has a mapped flag.

This has a potential risk to cause read request to be performed
against the stale block address that GC moved, and it may lead to meta
data corruption.  The mapped flag is safe if the buffer has an
uptodate flag, otherwise it may prevent necessary update of disk
address in the next read.

This will avoid the potential problem by ensuring disk address lookup
before reading metadata block even for buffers with the mapped flag.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/mdt.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 2dfd477..642f775 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -103,15 +103,12 @@ static int nilfs_mdt_create_block(struct inode *inode, unsigned long block,
 		goto failed_unlock;
 
 	err = -EEXIST;
-	if (buffer_uptodate(bh) || buffer_mapped(bh))
+	if (buffer_uptodate(bh))
 		goto failed_bh;
-#if 0
-	/* The uptodate flag is not protected by the page lock, but
-	   the mapped flag is.  Thus, we don't have to wait the buffer. */
+
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
 		goto failed_bh;
-#endif
 
 	bh->b_bdev = nilfs->ns_bdev;
 	err = nilfs_mdt_insert_new_block(inode, block, bh, init_block);
@@ -162,17 +159,15 @@ nilfs_mdt_submit_block(struct inode *inode, unsigned long blkoff,
 		unlock_buffer(bh);
 		goto out;
 	}
-	if (!buffer_mapped(bh)) { /* unused buffer */
-		ret = nilfs_bmap_lookup(NILFS_I(inode)->i_bmap, blkoff,
-					&blknum);
-		if (unlikely(ret)) {
-			unlock_buffer(bh);
-			goto failed_bh;
-		}
-		bh->b_bdev = NILFS_MDT(inode)->mi_nilfs->ns_bdev;
-		bh->b_blocknr = blknum;
-		set_buffer_mapped(bh);
+
+	ret = nilfs_bmap_lookup(NILFS_I(inode)->i_bmap, blkoff, &blknum);
+	if (unlikely(ret)) {
+		unlock_buffer(bh);
+		goto failed_bh;
 	}
+	bh->b_bdev = NILFS_MDT(inode)->mi_nilfs->ns_bdev;
+	bh->b_blocknr = blknum;
+	set_buffer_mapped(bh);
 
 	bh->b_end_io = end_buffer_read_sync;
 	get_bh(bh);
