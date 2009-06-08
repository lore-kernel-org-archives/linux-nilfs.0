From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 6/6] nilfs2: issue discard request after
	cleaning segments
Date: Mon,  8 Jun 2009 15:07:19 +0900
Message-ID: <1244441239-20032-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1244441239-20032-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1244441239-20032-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

This adds a function to send discard requests for given array of
segment numbers, and calls the function when garbage collection
succeeded.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segment.c   |    3 +++
 fs/nilfs2/the_nilfs.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/the_nilfs.h |    3 +++
 3 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index aa97754..23e6014 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2569,6 +2569,9 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(sci->sc_interval);
 	}
+	if (nilfs_discard(nilfs))
+		nilfs_discard_segments(nilfs, sci->sc_freesegs,
+				       sci->sc_nfreesegs);
 
  out_unlock:
 	sci->sc_freesegs = NULL;
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index a4a692c..07352b3 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -634,6 +634,50 @@ int init_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi, char *data)
 	goto out;
 }
 
+void nilfs_discard_segments(struct the_nilfs *nilfs, __u64 *segnump,
+			    size_t nsegs)
+{
+	sector_t seg_start, seg_end;
+	sector_t start = 0, nblocks = 0;
+	unsigned int sects_per_block;
+	__u64 *sn;
+	int ret = 0;
+
+	sects_per_block = (1 << nilfs->ns_blocksize_bits) /
+		bdev_hardsect_size(nilfs->ns_bdev);
+	for (sn = segnump; sn < segnump + nsegs; sn++) {
+		nilfs_get_segment_range(nilfs, *sn, &seg_start, &seg_end);
+
+		if (!nblocks) {
+			start = seg_start;
+			nblocks = seg_end - seg_start + 1;
+		} else if (start + nblocks == seg_start) {
+			nblocks += seg_end - seg_start + 1;
+		} else {
+			ret = blkdev_issue_discard(nilfs->ns_bdev,
+						   start * sects_per_block,
+						   nblocks * sects_per_block,
+						   GFP_NOFS);
+			if (ret < 0)
+				goto failed;
+			nblocks = 0;
+		}
+	}
+	if (nblocks) {
+		ret = blkdev_issue_discard(nilfs->ns_bdev,
+					   start * sects_per_block,
+					   nblocks * sects_per_block,
+					   GFP_NOFS);
+		if (ret < 0)
+			goto failed;
+	}
+	return;
+ failed:
+	printk(KERN_WARNING "NILFS warning: error %d on discard request, "
+	       "turning discards off for the device\n", ret);
+	clear_nilfs_discard(nilfs);
+}
+
 int nilfs_count_free_blocks(struct the_nilfs *nilfs, sector_t *nblocks)
 {
 	struct inode *dat = nilfs_dat_inode(nilfs);
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 53fb1e6..6a1e40e 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -37,6 +37,7 @@ enum {
 	THE_NILFS_LOADED,       /* Roll-back/roll-forward has done and
 				   the latest checkpoint was loaded */
 	THE_NILFS_DISCONTINUED,	/* 'next' pointer chain has broken */
+	THE_NILFS_DISCARD,	/* discard operation on/off */
 };
 
 /**
@@ -195,6 +196,7 @@ static inline int nilfs_##name(struct the_nilfs *nilfs)			\
 THE_NILFS_FNS(INIT, init)
 THE_NILFS_FNS(LOADED, loaded)
 THE_NILFS_FNS(DISCONTINUED, discontinued)
+THE_NILFS_FNS(DISCARD, discard)
 
 /* Minimum interval of periodical update of superblocks (in seconds) */
 #define NILFS_SB_FREQ		10
@@ -205,6 +207,7 @@ struct the_nilfs *find_or_create_nilfs(struct block_device *);
 void put_nilfs(struct the_nilfs *);
 int init_nilfs(struct the_nilfs *, struct nilfs_sb_info *, char *);
 int load_nilfs(struct the_nilfs *, struct nilfs_sb_info *);
+void nilfs_discard_segments(struct the_nilfs *, __u64 *, size_t);
 int nilfs_count_free_blocks(struct the_nilfs *, sector_t *);
 struct nilfs_sb_info *nilfs_find_sbinfo(struct the_nilfs *, int, __u64);
 int nilfs_checkpoint_is_mounted(struct the_nilfs *, __u64, int);
-- 
1.6.2
