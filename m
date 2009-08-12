From: Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] nilfs2: add more check routines in mount
	process
Date: Wed, 12 Aug 2009 14:17:59 +0800
Message-ID: <4A825E97.10605@gmail.com>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Cc: Zhang Qiang <qiang.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Zhu Yanhai <yanhai.zhu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

nilfs2: Add more safeguard routines and protections in mount process,
which also makes nilsf2 report consistency error messages when checkpoint
number is invalid.

Signed-off-by: Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nilfs2/cpfile.c |   11 ++++++++---
 fs/nilfs2/super.c  |    7 ++++++-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index aec942c..1c6cfb5 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -815,8 +815,10 @@ int nilfs_cpfile_is_snapshot(struct inode *cpfile, __u64 cno)
 	void *kaddr;
 	int ret;
 
-	if (cno == 0)
-		return -ENOENT; /* checkpoint number 0 is invalid */
+	/* CP number is invalid if it's zero or larger than the
+	largest	exist one.*/
+	if (cno == 0 || cno >= nilfs_mdt_cno(cpfile))
+		return -ENOENT;
 	down_read(&NILFS_MDT(cpfile)->mi_sem);
 
 	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &bh);
@@ -824,7 +826,10 @@ int nilfs_cpfile_is_snapshot(struct inode *cpfile, __u64 cno)
 		goto out;
 	kaddr = kmap_atomic(bh->b_page, KM_USER0);
 	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, bh, kaddr);
-	ret = nilfs_checkpoint_snapshot(cp);
+	if (nilfs_checkpoint_invalid(cp))
+		ret = -ENOENT;
+	else
+		ret = nilfs_checkpoint_snapshot(cp);
 	kunmap_atomic(kaddr, KM_USER0);
 	brelse(bh);
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 8e2ec43..b2ad589 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -814,10 +814,15 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 
 	if (sb->s_flags & MS_RDONLY) {
 		if (nilfs_test_opt(sbi, SNAPSHOT)) {
+			down_read(&nilfs->ns_segctor_sem);
 			err = nilfs_cpfile_is_snapshot(nilfs->ns_cpfile,
 						       sbi->s_snapshot_cno);
-			if (err < 0)
+			up_read(&nilfs->ns_segctor_sem);
+			if (err < 0) {
+				if (err == -ENOENT)
+					err = -EINVAL;
 				goto failed_sbi;
+			}
 			if (!err) {
 				printk(KERN_ERR
 				       "NILFS: The specified checkpoint is "
-- 
1.6.2.2
