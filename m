From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: fix kernel oops in error case of
	nilfs_ioctl_move_blocks
Date: Sun,  8 Nov 2009 16:15:51 +0900
Message-ID: <1257664552-6234-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1257664552-6234-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1257664552-6234-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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
Cc: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>, Markus Trippelsdorf <markus-xp2qqqlHh3xzoYq+O6RWwA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This fixes a kernel oops reported by Markus Trippelsdorf in the email
titled "[NILFS users] kernel Oops while running nilfs_cleanerd".

The oops was caused by a bug of error path in
nilfs_ioctl_move_blocks() function, which was inlined in
nilfs_ioctl_clean_segments().

nilfs_ioctl_move_blocks checked duplication of blocks to be moved in
garbage collection.  But, the check must be done during
nilfs_ioctl_move_inode_block() to prevent list corruption among
buffers storing the target blocks.

To fix the kernel oops, this moves forward the duplication check
before the list insertion.

Reported-by: Markus Trippelsdorf <markus-xp2qqqlHh3xzoYq+O6RWwA@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/ioctl.c |   30 +++++++++++++-----------------
 1 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 6572ea4..89dd73e 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -297,7 +297,18 @@ static int nilfs_ioctl_move_inode_block(struct inode *inode,
 			       (unsigned long long)vdesc->vd_vblocknr);
 		return ret;
 	}
-	bh->b_private = vdesc;
+	if (unlikely(!list_empty(&bh->b_assoc_buffers))) {
+		printk(KERN_CRIT "%s: conflicting %s buffer: ino=%llu, "
+		       "cno=%llu, offset=%llu, blocknr=%llu, vblocknr=%llu\n",
+		       __func__, vdesc->vd_flags ? "node" : "data",
+		       (unsigned long long)vdesc->vd_ino,
+		       (unsigned long long)vdesc->vd_cno,
+		       (unsigned long long)vdesc->vd_offset,
+		       (unsigned long long)vdesc->vd_blocknr,
+		       (unsigned long long)vdesc->vd_vblocknr);
+		brelse(bh);
+		return -EEXIST;
+	}
 	list_add_tail(&bh->b_assoc_buffers, buffers);
 	return 0;
 }
@@ -335,24 +346,10 @@ static int nilfs_ioctl_move_blocks(struct the_nilfs *nilfs,
 	list_for_each_entry_safe(bh, n, &buffers, b_assoc_buffers) {
 		ret = nilfs_gccache_wait_and_mark_dirty(bh);
 		if (unlikely(ret < 0)) {
-			if (ret == -EEXIST) {
-				vdesc = bh->b_private;
-				printk(KERN_CRIT
-				       "%s: conflicting %s buffer: "
-				       "ino=%llu, cno=%llu, offset=%llu, "
-				       "blocknr=%llu, vblocknr=%llu\n",
-				       __func__,
-				       vdesc->vd_flags ? "node" : "data",
-				       (unsigned long long)vdesc->vd_ino,
-				       (unsigned long long)vdesc->vd_cno,
-				       (unsigned long long)vdesc->vd_offset,
-				       (unsigned long long)vdesc->vd_blocknr,
-				       (unsigned long long)vdesc->vd_vblocknr);
-			}
+			WARN_ON(ret == -EEXIST);
 			goto failed;
 		}
 		list_del_init(&bh->b_assoc_buffers);
-		bh->b_private = NULL;
 		brelse(bh);
 	}
 	return nmembs;
@@ -360,7 +357,6 @@ static int nilfs_ioctl_move_blocks(struct the_nilfs *nilfs,
  failed:
 	list_for_each_entry_safe(bh, n, &buffers, b_assoc_buffers) {
 		list_del_init(&bh->b_assoc_buffers);
-		bh->b_private = NULL;
 		brelse(bh);
 	}
 	return ret;
-- 
1.6.3.4
