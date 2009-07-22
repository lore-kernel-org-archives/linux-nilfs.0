From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCH 3/3] nilfs2: stop using periodic write_super
	callback
Date: Wed, 22 Jul 2009 17:45:23 +0900
Message-ID: <1248252323-22959-4-git-send-email-jir@unicus.jp>
References: <1248252323-22959-1-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1248252323-22959-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
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

remove nilfs_write_super and commit super block in nilfs internal thread,
instead of periodic write_super callback.

VFS layer calls ->write_super callback periodically.  However,
it looks like that calling back is ommited when disk I/O is busy.
And when cleanerd (nilfs GC) is runnig, disk I/O tend to be busy thus
nilfs superblock is not synchronized as nilfs designed.

To avoid it, syncing superblock by nilfs thread instead of pdflush.

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/segment.c |    7 ++++++-
 fs/nilfs2/super.c   |   46 +---------------------------------------------
 2 files changed, 7 insertions(+), 46 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 8b5e477..0f110a1 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2487,7 +2487,8 @@ static int nilfs_segctor_construct(struct nilfs_sc_info *sci,
 		if (test_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags) &&
 		    nilfs_discontinued(nilfs)) {
 			down_write(&nilfs->ns_sem);
-			req->sb_err = nilfs_commit_super(sbi, 0);
+			req->sb_err = nilfs_commit_super(sbi,
+					nilfs_altsb_need_update(nilfs));
 			up_write(&nilfs->ns_sem);
 		}
 	}
@@ -2675,6 +2676,7 @@ static int nilfs_segctor_thread(void *arg)
 	} else {
 		DEFINE_WAIT(wait);
 		int should_sleep = 1;
+		struct the_nilfs *nilfs;
 
 		prepare_to_wait(&sci->sc_wait_daemon, &wait,
 				TASK_INTERRUPTIBLE);
@@ -2695,6 +2697,9 @@ static int nilfs_segctor_thread(void *arg)
 		finish_wait(&sci->sc_wait_daemon, &wait);
 		timeout = ((sci->sc_state & NILFS_SEGCTOR_COMMIT) &&
 			   time_after_eq(jiffies, sci->sc_timer->expires));
+		nilfs = sci->sc_sbi->s_nilfs;
+		if (sci->sc_super->s_dirt && nilfs_sb_need_update(nilfs))
+			set_nilfs_discontinued(nilfs);
 	}
 	goto loop;
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 02f7a76..bad0ce1 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -65,7 +65,6 @@ MODULE_DESCRIPTION("A New Implementation of the Log-structured Filesystem "
 		   "(NILFS)");
 MODULE_LICENSE("GPL");
 
-static void nilfs_write_super(struct super_block *sb);
 static int nilfs_remount(struct super_block *sb, int *flags, char *data);
 
 /**
@@ -333,49 +332,6 @@ static void nilfs_put_super(struct super_block *sb)
 	unlock_kernel();
 }
 
-/**
- * nilfs_write_super - write super block(s) of NILFS
- * @sb: super_block
- *
- * nilfs_write_super() gets a fs-dependent lock, writes super block(s), and
- * clears s_dirt.  This function is called in the section protected by
- * lock_super().
- *
- * The s_dirt flag is managed by each filesystem and we protect it by ns_sem
- * of the struct the_nilfs.  Lock order must be as follows:
- *
- *   1. lock_super()
- *   2.    down_write(&nilfs->ns_sem)
- *
- * Inside NILFS, locking ns_sem is enough to protect s_dirt and the buffer
- * of the super block (nilfs->ns_sbp[]).
- *
- * In most cases, VFS functions call lock_super() before calling these
- * methods.  So we must be careful not to bring on deadlocks when using
- * lock_super();  see generic_shutdown_super(), write_super(), and so on.
- *
- * Note that order of lock_kernel() and lock_super() depends on contexts
- * of VFS.  We should also note that lock_kernel() can be used in its
- * protective section and only the outermost one has an effect.
- */
-static void nilfs_write_super(struct super_block *sb)
-{
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
-	struct the_nilfs *nilfs = sbi->s_nilfs;
-
-	down_write(&nilfs->ns_sem);
-	if (!(sb->s_flags & MS_RDONLY)) {
-		if (!nilfs_discontinued(nilfs) &&
-		    !nilfs_sb_need_update(nilfs)) {
-			up_write(&nilfs->ns_sem);
-			return;
-		}
-		nilfs_commit_super(sbi, nilfs_altsb_need_update(nilfs));
-	}
-	sb->s_dirt = 0;
-	up_write(&nilfs->ns_sem);
-}
-
 static int nilfs_sync_fs(struct super_block *sb, int wait)
 {
 	int err = 0;
@@ -534,7 +490,7 @@ static struct super_operations nilfs_sops = {
 	/* .drop_inode	  = nilfs_drop_inode, */
 	.delete_inode   = nilfs_delete_inode,
 	.put_super      = nilfs_put_super,
-	.write_super    = nilfs_write_super,
+	/* .write_super    = nilfs_write_super, */
 	.sync_fs        = nilfs_sync_fs,
 	/* .write_super_lockfs */
 	/* .unlockfs */
-- 
1.5.6.5
