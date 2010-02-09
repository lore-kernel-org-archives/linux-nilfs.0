From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/3] nilfs2: get rid of s_dirt flag use
Date: Wed, 10 Feb 2010 00:46:22 +0900
Message-ID: <1265730383-31290-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1265730383-31290-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1265730383-31290-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This replaces s_dirt flag use in nilfs with a new flag added on the
nilfs object.  The s_dirt flag was used to indicate if
sop->write_super() should be called, however the current version of
nilfs does not use the callback.  Thus, it can be replaced with the
own flag.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/segment.c   |   11 +++++------
 fs/nilfs2/super.c     |    4 ++--
 fs/nilfs2/the_nilfs.h |    2 ++
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index fa4abfc..c4fcdd1 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1937,8 +1937,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 {
 	struct nilfs_segment_buffer *segbuf;
 	struct page *bd_page = NULL, *fs_page = NULL;
-	struct nilfs_sb_info *sbi = sci->sc_sbi;
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = sci->sc_sbi->s_nilfs;
 	int update_sr = (sci->sc_super_root != NULL);
 
 	list_for_each_entry(segbuf, &sci->sc_write_logs, sb_list) {
@@ -2020,7 +2019,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 	if (update_sr) {
 		nilfs_set_last_segment(nilfs, segbuf->sb_pseg_start,
 				       segbuf->sb_sum.seg_seq, nilfs->ns_cno++);
-		sbi->s_super->s_dirt = 1;
+		set_nilfs_sb_dirty(nilfs);
 
 		clear_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags);
 		clear_bit(NILFS_SC_DIRTY, &sci->sc_flags);
@@ -2645,6 +2644,7 @@ static int nilfs_segctor_flush_mode(struct nilfs_sc_info *sci)
 static int nilfs_segctor_thread(void *arg)
 {
 	struct nilfs_sc_info *sci = (struct nilfs_sc_info *)arg;
+	struct the_nilfs *nilfs = sci->sc_sbi->s_nilfs;
 	struct timer_list timer;
 	int timeout = 0;
 
@@ -2690,7 +2690,6 @@ static int nilfs_segctor_thread(void *arg)
 	} else {
 		DEFINE_WAIT(wait);
 		int should_sleep = 1;
-		struct the_nilfs *nilfs;
 
 		prepare_to_wait(&sci->sc_wait_daemon, &wait,
 				TASK_INTERRUPTIBLE);
@@ -2711,8 +2710,8 @@ static int nilfs_segctor_thread(void *arg)
 		finish_wait(&sci->sc_wait_daemon, &wait);
 		timeout = ((sci->sc_state & NILFS_SEGCTOR_COMMIT) &&
 			   time_after_eq(jiffies, sci->sc_timer->expires));
-		nilfs = sci->sc_sbi->s_nilfs;
-		if (sci->sc_super->s_dirt && nilfs_sb_need_update(nilfs))
+
+		if (nilfs_sb_dirty(nilfs) && nilfs_sb_need_update(nilfs))
 			set_nilfs_discontinued(nilfs);
 	}
 	goto loop;
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index f068270..92579cc 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -298,7 +298,7 @@ int nilfs_commit_super(struct nilfs_sb_info *sbi, int dupsb)
 		memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
 		nilfs->ns_sbwtime[1] = t;
 	}
-	sbi->s_super->s_dirt = 0;
+	clear_nilfs_sb_dirty(nilfs);
 	return nilfs_sync_super(sbi, dupsb);
 }
 
@@ -342,7 +342,7 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
 		err = nilfs_construct_segment(sb);
 
 	down_write(&nilfs->ns_sem);
-	if (sb->s_dirt)
+	if (nilfs_sb_dirty(nilfs))
 		nilfs_commit_super(sbi, 1);
 	up_write(&nilfs->ns_sem);
 
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index fd057f8..e9795f1 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -38,6 +38,7 @@ enum {
 				   the latest checkpoint was loaded */
 	THE_NILFS_DISCONTINUED,	/* 'next' pointer chain has broken */
 	THE_NILFS_GC_RUNNING,	/* gc process is running */
+	THE_NILFS_SB_DIRTY,	/* super block is dirty */
 };
 
 /**
@@ -197,6 +198,7 @@ THE_NILFS_FNS(INIT, init)
 THE_NILFS_FNS(LOADED, loaded)
 THE_NILFS_FNS(DISCONTINUED, discontinued)
 THE_NILFS_FNS(GC_RUNNING, gc_running)
+THE_NILFS_FNS(SB_DIRTY, sb_dirty)
 
 /* Minimum interval of periodical update of superblocks (in seconds) */
 #define NILFS_SB_FREQ		10
-- 
1.6.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
