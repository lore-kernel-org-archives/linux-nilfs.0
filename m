From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 3/4] nilfs2: fix timing issue between rmcp and chcp ioctls
Date: Mon, 16 Jul 2012 10:05:25 +0900
Message-ID: <1342400726-30670-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1342400726-30670-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1342400726-30670-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

The checkpoint deletion ioctl (rmcp ioctl) has potential for breaking
snapshot because it is not fully exclusive with checkpoint mode change
ioctl (chcp ioctl).

The rmcp ioctl first tests if the specified checkpoint is a snapshot
or not within nilfs_cpfile_delete_checkpoint function, and then calls
nilfs_cpfile_delete_checkpoints function to actually invalidate the
checkpoint only if it's not a snapshot.  However, the checkpoint can
be changed into a snapshot by the chcp ioctl between these two
operations.  In that case, calling nilfs_cpfile_delete_checkpoints()
wrongly invalidates the snapshot, which leads to snapshot list
corruption and snapshot count mismatch.

This fixes the issue by changing nilfs_cpfile_delete_checkpoints() so
that it reconfirms the target checkpoints are snapshot or not.

This second check is exclusive with the chcp operation since
it is protected by an existing semaphore.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/cpfile.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index dab5c4c..deaa3d3 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -286,7 +286,7 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 	__u64 cno;
 	void *kaddr;
 	unsigned long tnicps;
-	int ret, ncps, nicps, count, i;
+	int ret, ncps, nicps, nss, count, i;
 
 	if (unlikely(start == 0 || start > end)) {
 		printk(KERN_ERR "%s: invalid range of checkpoint numbers: "
@@ -301,6 +301,7 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 	if (ret < 0)
 		goto out_sem;
 	tnicps = 0;
+	nss = 0;
 
 	for (cno = start; cno < end; cno += ncps) {
 		ncps = nilfs_cpfile_checkpoints_in_block(cpfile, cno, end);
@@ -318,8 +319,9 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 			cpfile, cno, cp_bh, kaddr);
 		nicps = 0;
 		for (i = 0; i < ncps; i++, cp = (void *)cp + cpsz) {
-			WARN_ON(nilfs_checkpoint_snapshot(cp));
-			if (!nilfs_checkpoint_invalid(cp)) {
+			if (nilfs_checkpoint_snapshot(cp)) {
+				nss++;
+			} else if (!nilfs_checkpoint_invalid(cp)) {
 				nilfs_checkpoint_set_invalid(cp);
 				nicps++;
 			}
@@ -364,6 +366,8 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 	}
 
 	brelse(header_bh);
+	if (nss > 0)
+		ret = -EBUSY;
 
  out_sem:
 	up_write(&NILFS_MDT(cpfile)->mi_sem);
-- 
1.7.9.3
