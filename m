From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCH:v2] nilfs2: tune write performance
Date: Thu, 13 Aug 2009 18:23:13 +0900
Message-ID: <1250155393-29046-1-git-send-email-jir@unicus.jp>
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
Cc: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

Hi,

This is a revised patch of write performance patch.

When GC is runnning, GC moves live block to difference segments.
Copying live blocks into memory is done in a transaction,
but it is not necessarily to be in the transaction.
This patch will get the nilfs_ioctl_move_blocks() out from
transaction lock and put it before the transaction.

This time, I ran sysbench fileio test against nilfs partition.
I copied some DVD/CD images and created snapshot to create live blocks
before starting the benchmark.

Followings are summary of rc5 and rc5 w/ the patch of per-request statistics,
which is min/max and avg.  I ran each test three times and bellow is
average of those numers.

According to this benchmark result, average time is slightly degrated.
However, worstcase (max) result is significantly improved.
This can address a few seconds write freeze.

- random write per-request performance of rc5
 min   0.856ms
 max 666.180ms
 avg   2.996ms
- random write per-request performance of rc5 w/ this patch
 min   0.850ms ->  99.20%
 max 381.083ms ->  57.20%
 avg   3.176ms -> 107.00%

- sequential write per-request performance of rc5
 min   0.740ms
 max 729.546ms 
 avg   2.870ms 
- sequential write per-request performance of rc5 w/ this patch
 min   0.720ms ->  97.20%
 max 566.023ms ->  77.50%
 avg   3.106ms -> 108.20%

-----8<-----8<-----nilfs_cleanerd.conf-----8<-----8<-----
protection_period       150
selection_policy        timestamp       # timestamp in ascend order
nsegments_per_clean     2
cleaning_interval       2
retry_interval          60
use_mmap
log_priority            info
-----8<-----8<-----nilfs_cleanerd.conf-----8<-----8<-----


Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/ioctl.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 6ea5f87..35cd0ff 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -442,12 +442,6 @@ int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
 	const char *msg;
 	int ret;
 
-	ret = nilfs_ioctl_move_blocks(nilfs, &argv[0], kbufs[0]);
-	if (ret < 0) {
-		msg = "cannot read source blocks";
-		goto failed;
-	}
-
 	ret = nilfs_ioctl_delete_checkpoints(nilfs, &argv[1], kbufs[1]);
 	if (ret < 0) {
 		/*
@@ -548,6 +542,14 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 		}
 	}
 
+	ret = nilfs_ioctl_move_blocks(nilfs, &argv[0], kbufs[0]);
+	if (ret < 0) {
+		nilfs_remove_all_gcinode(nilfs);
+		printk(KERN_ERR "NILFS: GC failed during preparation: "
+			"cannot read source blocks: err=%d\n", ret);
+		goto out_free;
+	}
+
 	ret = nilfs_clean_segments(inode->i_sb, argv, kbufs);
 
  out_free:
-- 
1.5.6.5
