From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: [PATCH 3/3] nilfs2: stop using periodic write_super
	callback
Date: Fri, 17 Jul 2009 18:12:48 +0900
Message-ID: <1247821968-31232-4-git-send-email-jir@unicus.jp>
References: <1247821968-31232-1-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1247821968-31232-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
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

instead of periodic write_super callback,
commit super block in internal thread.

Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
---
 fs/nilfs2/segment.c |   12 +++++++++++-
 fs/nilfs2/super.c   |    2 +-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 8b5e477..fe25424 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2486,8 +2486,9 @@ static int nilfs_segctor_construct(struct nilfs_sc_info *sci,
 			atomic_set(&nilfs->ns_ndirtyblks, 0);
 		if (test_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags) &&
 		    nilfs_discontinued(nilfs)) {
+			u64 t = get_seconds();
 			down_write(&nilfs->ns_sem);
-			req->sb_err = nilfs_commit_super(sbi, 0);
+			req->sb_err = nilfs_commit_super(sbi, nilfs_update_alt_super(nilfs,t));
 			up_write(&nilfs->ns_sem);
 		}
 	}
@@ -2675,6 +2676,9 @@ static int nilfs_segctor_thread(void *arg)
 	} else {
 		DEFINE_WAIT(wait);
 		int should_sleep = 1;
+		u64 t;
+		struct nilfs_sb_info *sbi;
+	        struct the_nilfs *nilfs;
 
 		prepare_to_wait(&sci->sc_wait_daemon, &wait,
 				TASK_INTERRUPTIBLE);
@@ -2695,6 +2699,12 @@ static int nilfs_segctor_thread(void *arg)
 		finish_wait(&sci->sc_wait_daemon, &wait);
 		timeout = ((sci->sc_state & NILFS_SEGCTOR_COMMIT) &&
 			   time_after_eq(jiffies, sci->sc_timer->expires));
+		t = get_seconds();
+		sbi = sci->sc_sbi;
+	        nilfs = sbi->s_nilfs;
+		if(test_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags) && 
+	   	   nilfs_update_super(nilfs,t))
+			set_nilfs_discontinued(nilfs);
 	}
 	goto loop;
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 55a4359..00a2173 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -533,7 +533,7 @@ static struct super_operations nilfs_sops = {
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
