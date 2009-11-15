From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 13/23] nilfs2: avoid readahead on metadata
	file for create mode
Date: Sun, 15 Nov 2009 21:46:51 +0900
Message-ID: <1258289221-3827-14-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1258289221-3827-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1258289221-3827-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This turns off readhead action of metadata file if nilfs_mdt_get_block
function was called with a create flag.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/mdt.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 3028e8f..948b1f8 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -186,7 +186,7 @@ nilfs_mdt_submit_block(struct inode *inode, unsigned long blkoff,
 }
 
 static int nilfs_mdt_read_block(struct inode *inode, unsigned long block,
-				struct buffer_head **out_bh)
+				int readahead, struct buffer_head **out_bh)
 {
 	struct buffer_head *first_bh, *bh;
 	unsigned long blkoff;
@@ -200,16 +200,18 @@ static int nilfs_mdt_read_block(struct inode *inode, unsigned long block,
 	if (unlikely(err))
 		goto failed;
 
-	blkoff = block + 1;
-	for (i = 0; i < nr_ra_blocks; i++, blkoff++) {
-		err = nilfs_mdt_submit_block(inode, blkoff, READA, &bh);
-		if (likely(!err || err == -EEXIST))
-			brelse(bh);
-		else if (err != -EBUSY)
-			break; /* abort readahead if bmap lookup failed */
-
-		if (!buffer_locked(first_bh))
-			goto out_no_wait;
+	if (readahead) {
+		blkoff = block + 1;
+		for (i = 0; i < nr_ra_blocks; i++, blkoff++) {
+			err = nilfs_mdt_submit_block(inode, blkoff, READA, &bh);
+			if (likely(!err || err == -EEXIST))
+				brelse(bh);
+			else if (err != -EBUSY)
+				break;
+				/* abort readahead if bmap lookup failed */
+			if (!buffer_locked(first_bh))
+				goto out_no_wait;
+		}
 	}
 
 	wait_on_buffer(first_bh);
@@ -263,7 +265,7 @@ int nilfs_mdt_get_block(struct inode *inode, unsigned long blkoff, int create,
 
 	/* Should be rewritten with merging nilfs_mdt_read_block() */
  retry:
-	ret = nilfs_mdt_read_block(inode, blkoff, out_bh);
+	ret = nilfs_mdt_read_block(inode, blkoff, !create, out_bh);
 	if (!create || ret != -ENOENT)
 		return ret;
 
@@ -371,7 +373,7 @@ int nilfs_mdt_mark_block_dirty(struct inode *inode, unsigned long block)
 	struct buffer_head *bh;
 	int err;
 
-	err = nilfs_mdt_read_block(inode, block, &bh);
+	err = nilfs_mdt_read_block(inode, block, 0, &bh);
 	if (unlikely(err))
 		return err;
 	nilfs_mark_buffer_dirty(bh);
-- 
1.6.3.4
