From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] nilfs2: fix possible recovery failure due
	to block creation without writer
Date: Tue,  5 May 2009 21:33:02 +0900
Message-ID: <1241526783-25671-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1241526783-25671-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1241526783-25671-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

Some function calls in nilfs_prepare_segment_for_recovery() may fail
because they can create blocks on meta data files without configuring
a writable FS-instance.  Concretely, nilfs_mdt_create_block() routine
of meta data files will fail in that case.

This fixes the problem by temporarily attaching a writable FS-instace
during the function is called.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/recovery.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 4fc081e..57afa9d 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -407,6 +407,7 @@ void nilfs_dispose_segment_list(struct list_head *head)
 }
 
 static int nilfs_prepare_segment_for_recovery(struct the_nilfs *nilfs,
+					      struct nilfs_sb_info *sbi,
 					      struct nilfs_recovery_info *ri)
 {
 	struct list_head *head = &ri->ri_used_segments;
@@ -421,6 +422,7 @@ static int nilfs_prepare_segment_for_recovery(struct the_nilfs *nilfs,
 	segnum[2] = ri->ri_segnum;
 	segnum[3] = ri->ri_nextnum;
 
+	nilfs_attach_writer(nilfs, sbi);
 	/*
 	 * Releasing the next segment of the latest super root.
 	 * The next segment is invalidated by this recovery.
@@ -459,10 +461,10 @@ static int nilfs_prepare_segment_for_recovery(struct the_nilfs *nilfs,
 	nilfs->ns_pseg_offset = 0;
 	nilfs->ns_seg_seq = ri->ri_seq + 2;
 	nilfs->ns_nextnum = nilfs->ns_segnum = segnum[0];
-	return 0;
 
  failed:
 	/* No need to recover sufile because it will be destroyed on error */
+	nilfs_detach_writer(nilfs, sbi);
 	return err;
 }
 
@@ -728,7 +730,7 @@ int nilfs_recover_logical_segments(struct the_nilfs *nilfs,
 		goto failed;
 
 	if (ri->ri_need_recovery == NILFS_RECOVERY_ROLLFORWARD_DONE) {
-		err = nilfs_prepare_segment_for_recovery(nilfs, ri);
+		err = nilfs_prepare_segment_for_recovery(nilfs, sbi, ri);
 		if (unlikely(err)) {
 			printk(KERN_ERR "NILFS: Error preparing segments for "
 			       "recovery.\n");
-- 
1.6.2
