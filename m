From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 09/23] nilfs2: hide nilfs_mdt_clear calls in
	nilfs_mdt_destroy
Date: Sun, 15 Nov 2009 21:46:47 +0900
Message-ID: <1258289221-3827-10-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This will hide a function call of nilfs_mdt_clear() in
nilfs_mdt_destroy().

This ensures nilfs_mdt_destroy() to do cleanup jobs included in
nilfs_mdt_clear().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/gcinode.c   |    1 -
 fs/nilfs2/mdt.c       |    7 +++++--
 fs/nilfs2/mdt.h       |    1 -
 fs/nilfs2/recovery.c  |    6 ------
 fs/nilfs2/super.c     |    1 -
 fs/nilfs2/the_nilfs.c |    4 ----
 6 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 32b04da..67d2099 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -266,7 +266,6 @@ struct inode *nilfs_gc_iget(struct the_nilfs *nilfs, ino_t ino, __u64 cno)
  */
 void nilfs_clear_gcinode(struct inode *inode)
 {
-	nilfs_mdt_clear(inode);
 	nilfs_mdt_destroy(inode);
 }
 
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 62074e8..3028e8f 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -553,14 +553,15 @@ void nilfs_mdt_set_shadow(struct inode *orig, struct inode *shadow)
 		&NILFS_I(orig)->i_btnode_cache;
 }
 
-void nilfs_mdt_clear(struct inode *inode)
+static void nilfs_mdt_clear(struct inode *inode)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 
 	invalidate_mapping_pages(inode->i_mapping, 0, -1);
 	truncate_inode_pages(inode->i_mapping, 0);
 
-	nilfs_bmap_clear(ii->i_bmap);
+	if (test_bit(NILFS_I_BMAP, &ii->i_state))
+		nilfs_bmap_clear(ii->i_bmap);
 	nilfs_btnode_cache_clear(&ii->i_btnode_cache);
 }
 
@@ -568,6 +569,8 @@ void nilfs_mdt_destroy(struct inode *inode)
 {
 	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
 
+	nilfs_mdt_clear(inode);
+
 	kfree(mdi->mi_bgl); /* kfree(NULL) is safe */
 	kfree(mdi);
 	nilfs_destroy_inode(inode);
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index cd2903a..c396b6c 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -79,7 +79,6 @@ struct inode *nilfs_mdt_new(struct the_nilfs *, struct super_block *, ino_t,
 struct inode *nilfs_mdt_new_common(struct the_nilfs *, struct super_block *,
 				   ino_t, gfp_t, size_t);
 void nilfs_mdt_destroy(struct inode *);
-void nilfs_mdt_clear(struct inode *);
 void nilfs_mdt_set_entry_size(struct inode *, unsigned, unsigned);
 void nilfs_mdt_set_shadow(struct inode *, struct inode *);
 
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 6dc8359..bcd386d 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -770,14 +770,8 @@ int nilfs_recover_logical_segments(struct the_nilfs *nilfs,
 		nilfs_finish_roll_forward(nilfs, sbi, ri);
 	}
 
-	nilfs_detach_checkpoint(sbi);
-	return 0;
-
  failed:
 	nilfs_detach_checkpoint(sbi);
-	nilfs_mdt_clear(nilfs->ns_cpfile);
-	nilfs_mdt_clear(nilfs->ns_sufile);
-	nilfs_mdt_clear(nilfs->ns_dat);
 	return err;
 }
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 05ae52a..f526169 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -407,7 +407,6 @@ void nilfs_detach_checkpoint(struct nilfs_sb_info *sbi)
 {
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 
-	nilfs_mdt_clear(sbi->s_ifile);
 	nilfs_mdt_destroy(sbi->s_ifile);
 	sbi->s_ifile = NULL;
 	down_write(&nilfs->ns_super_sem);
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index bc7760c..75095ed 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -146,13 +146,9 @@ void put_nilfs(struct the_nilfs *nilfs)
 
 	might_sleep();
 	if (nilfs_loaded(nilfs)) {
-		nilfs_mdt_clear(nilfs->ns_sufile);
 		nilfs_mdt_destroy(nilfs->ns_sufile);
-		nilfs_mdt_clear(nilfs->ns_cpfile);
 		nilfs_mdt_destroy(nilfs->ns_cpfile);
-		nilfs_mdt_clear(nilfs->ns_dat);
 		nilfs_mdt_destroy(nilfs->ns_dat);
-		/* XXX: how and when to clear nilfs->ns_gc_dat? */
 		nilfs_mdt_destroy(nilfs->ns_gc_dat);
 	}
 	if (nilfs_init(nilfs)) {
-- 
1.6.3.4
