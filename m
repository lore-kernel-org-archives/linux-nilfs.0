From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCHv3] nilfs2: shorten freeze period due to GC in
	write operation
Date: Thu,  3 Sep 2009 22:24:17 +0900
Message-ID: <1251984257-4107-1-git-send-email-jir@unicus.jp>
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

This is a re-revised patch to shorten freeze period.
This version include a fix of the bug Konishi-san mentioned last time.

When GC is runnning, GC moves live block to difference segments.
Copying live blocks into memory is done in a transaction,
however it is not necessarily to be in the transaction.
This patch will get the nilfs_ioctl_move_blocks() out from
transaction lock and put it before the transaction.

I ran sysbench fileio test against nilfs partition.
I copied some DVD/CD images and created snapshot to create live blocks
before starting the benchmark.

Followings are summary of rc8 and rc8 w/ the patch of per-request statistics,
which is min/max and avg.  I ran each test three times and bellow is
average of those numers.

According to this benchmark result, average time is slightly degrated.
However, worstcase (max) result is significantly improved.
This can address a few seconds write freeze.

- random write per-request performance of rc8
 min   0.843ms
 max 680.406ms
 avg   3.050ms
- random write per-request performance of rc8 w/ this patch
 min   0.843ms -> 100.00%
 max 380.490ms ->  55.90%
 avg   3.233ms -> 106.00%

- sequential write per-request performance of rc8
 min   0.736ms
 max 774.343ms 
 avg   2.883ms 
- sequential write per-request performance of rc8 w/ this patch
 min   0.720ms ->  97.80%
 max  644.280ms->  83.20%
 avg   3.130ms -> 108.50%

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
 fs/nilfs2/ioctl.c     |   26 +++++++++++++++++++-------
 fs/nilfs2/the_nilfs.h |    2 ++
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 6ea5f87..6572ea4 100644
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
@@ -548,7 +542,25 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 		}
 	}
 
-	ret = nilfs_clean_segments(inode->i_sb, argv, kbufs);
+	/*
+	 * nilfs_ioctl_move_blocks() will call nilfs_gc_iget(),
+	 * which will operates an inode list without blocking.
+	 * To protect the list from concurrent operations,
+	 * nilfs_ioctl_move_blocks should be atomic operation.
+	 */
+	if (test_and_set_bit(THE_NILFS_GC_RUNNING, &nilfs->ns_flags)) {
+		ret = -EBUSY;
+		goto out_free;
+	}
+
+	ret = nilfs_ioctl_move_blocks(nilfs, &argv[0], kbufs[0]);
+	if (ret < 0)
+		printk(KERN_ERR "NILFS: GC failed during preparation: "
+			"cannot read source blocks: err=%d\n", ret);
+	else
+		ret = nilfs_clean_segments(inode->i_sb, argv, kbufs);
+
+	clear_nilfs_gc_running(nilfs);
 
  out_free:
 	while (--n >= 0)
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 1b9caaf..97ee569 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -37,6 +37,7 @@ enum {
 	THE_NILFS_LOADED,       /* Roll-back/roll-forward has done and
 				   the latest checkpoint was loaded */
 	THE_NILFS_DISCONTINUED,	/* 'next' pointer chain has broken */
+	THE_NILFS_GC_RUNNING,	/* gc process is running */
 };
 
 /**
@@ -197,6 +198,7 @@ static inline int nilfs_##name(struct the_nilfs *nilfs)			\
 THE_NILFS_FNS(INIT, init)
 THE_NILFS_FNS(LOADED, loaded)
 THE_NILFS_FNS(DISCONTINUED, discontinued)
+THE_NILFS_FNS(GC_RUNNING, gc_running)
 
 /* Minimum interval of periodical update of superblocks (in seconds) */
 #define NILFS_SB_FREQ		10
-- 
1.5.6.5
