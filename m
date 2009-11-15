From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 12/23] nilfs2: simplify
	nilfs_sufile_get_ncleansegs function
Date: Sun, 15 Nov 2009 21:46:50 +0900
Message-ID: <1258289221-3827-13-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

Previously, this function took an status code to return possible error
codes.  The ("nilfs2: add local variable to cache the number of clean
segments") patch removed the possibility to return errors.

So, this simplifies the function definition to make it directly return
the number of clean segments.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/sufile.c    |   31 +++++++++----------------------
 fs/nilfs2/sufile.h    |    3 ++-
 fs/nilfs2/the_nilfs.c |   25 +++++++++----------------
 3 files changed, 20 insertions(+), 39 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index e9b4cec..5f18aca 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -112,6 +112,15 @@ static void nilfs_sufile_mod_counter(struct buffer_head *header_bh,
 }
 
 /**
+ * nilfs_sufile_get_ncleansegs - return the number of clean segments
+ * @sufile: inode of segment usage file
+ */
+unsigned long nilfs_sufile_get_ncleansegs(struct inode *sufile)
+{
+	return NILFS_SUI(sufile)->ncleansegs;
+}
+
+/**
  * nilfs_sufile_updatev - modify multiple segment usages at a time
  * @sufile: inode of segment usage file
  * @segnumv: array of segment numbers
@@ -540,28 +549,6 @@ int nilfs_sufile_get_stat(struct inode *sufile, struct nilfs_sustat *sustat)
 	return ret;
 }
 
-/**
- * nilfs_sufile_get_ncleansegs - get the number of clean segments
- * @sufile: inode of segment usage file
- * @nsegsp: pointer to the number of clean segments
- *
- * Description: nilfs_sufile_get_ncleansegs() acquires the number of clean
- * segments.
- *
- * Return Value: On success, 0 is returned and the number of clean segments is
- * stored in the place pointed by @nsegsp. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- */
-int nilfs_sufile_get_ncleansegs(struct inode *sufile, unsigned long *nsegsp)
-{
-	*nsegsp = NILFS_SUI(sufile)->ncleansegs;
-	return 0;
-}
-
 void nilfs_sufile_do_set_error(struct inode *sufile, __u64 segnum,
 			       struct buffer_head *header_bh,
 			       struct buffer_head *su_bh)
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index b303a80..c339ad5 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -34,6 +34,8 @@ static inline unsigned long nilfs_sufile_get_nsegments(struct inode *sufile)
 	return NILFS_MDT(sufile)->mi_nilfs->ns_nsegments;
 }
 
+unsigned long nilfs_sufile_get_ncleansegs(struct inode *sufile);
+
 int nilfs_sufile_alloc(struct inode *, __u64 *);
 int nilfs_sufile_get_segment_usage(struct inode *, __u64,
 				   struct nilfs_segment_usage **,
@@ -41,7 +43,6 @@ int nilfs_sufile_get_segment_usage(struct inode *, __u64,
 void nilfs_sufile_put_segment_usage(struct inode *, __u64,
 				    struct buffer_head *);
 int nilfs_sufile_get_stat(struct inode *, struct nilfs_sustat *);
-int nilfs_sufile_get_ncleansegs(struct inode *, unsigned long *);
 ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, void *, unsigned,
 				size_t);
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 75095ed..4d4d35c 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -612,30 +612,23 @@ int nilfs_count_free_blocks(struct the_nilfs *nilfs, sector_t *nblocks)
 {
 	struct inode *dat = nilfs_dat_inode(nilfs);
 	unsigned long ncleansegs;
-	int err;
 
 	down_read(&NILFS_MDT(dat)->mi_sem);	/* XXX */
-	err = nilfs_sufile_get_ncleansegs(nilfs->ns_sufile, &ncleansegs);
+	ncleansegs = nilfs_sufile_get_ncleansegs(nilfs->ns_sufile);
 	up_read(&NILFS_MDT(dat)->mi_sem);	/* XXX */
-	if (likely(!err))
-		*nblocks = (sector_t)ncleansegs * nilfs->ns_blocks_per_segment;
-	return err;
+	*nblocks = (sector_t)ncleansegs * nilfs->ns_blocks_per_segment;
+	return 0;
 }
 
 int nilfs_near_disk_full(struct the_nilfs *nilfs)
 {
-	struct inode *sufile = nilfs->ns_sufile;
 	unsigned long ncleansegs, nincsegs;
-	int ret;
 
-	ret = nilfs_sufile_get_ncleansegs(sufile, &ncleansegs);
-	if (likely(!ret)) {
-		nincsegs = atomic_read(&nilfs->ns_ndirtyblks) /
-			nilfs->ns_blocks_per_segment + 1;
-		if (ncleansegs <= nilfs->ns_nrsvsegs + nincsegs)
-			ret++;
-	}
-	return ret;
+	ncleansegs = nilfs_sufile_get_ncleansegs(nilfs->ns_sufile);
+	nincsegs = atomic_read(&nilfs->ns_ndirtyblks) /
+		nilfs->ns_blocks_per_segment + 1;
+
+	return ncleansegs <= nilfs->ns_nrsvsegs + nincsegs;
 }
 
 /**
-- 
1.6.3.4
