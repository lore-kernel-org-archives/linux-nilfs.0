From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 3/3] nilfs2: clean up get/put function of a
	segment usage
Date: Wed, 18 Nov 2009 19:12:51 +0900
Message-ID: <1258539171-30188-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1258539171-30188-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1258539171-30188-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

This eliminates obsolete nilfs_get_sufile_get_segment_usage() and
nilfs_set_sufile_segment_usage() from sufile.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/sufile.c |   72 ----------------------------------------------------
 fs/nilfs2/sufile.h |    5 ---
 2 files changed, 0 insertions(+), 77 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 3eed998..b6c36d0 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -430,78 +430,6 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
 }
 
 /**
- * nilfs_sufile_get_segment_usage - get a segment usage
- * @sufile: inode of segment usage file
- * @segnum: segment number
- * @sup: pointer to segment usage
- * @bhp: pointer to buffer head
- *
- * Description: nilfs_sufile_get_segment_usage() acquires the segment usage
- * specified by @segnum.
- *
- * Return Value: On success, 0 is returned, and the segment usage and the
- * buffer head of the buffer on which the segment usage is located are stored
- * in the place pointed by @sup and @bhp, respectively. On error, one of the
- * following negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-EINVAL - Invalid segment usage number.
- */
-int nilfs_sufile_get_segment_usage(struct inode *sufile, __u64 segnum,
-				   struct nilfs_segment_usage **sup,
-				   struct buffer_head **bhp)
-{
-	struct buffer_head *bh;
-	struct nilfs_segment_usage *su;
-	void *kaddr;
-	int ret;
-
-	/* segnum is 0 origin */
-	if (segnum >= nilfs_sufile_get_nsegments(sufile))
-		return -EINVAL;
-	down_write(&NILFS_MDT(sufile)->mi_sem);
-	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 1, &bh);
-	if (ret < 0)
-		goto out_sem;
-	kaddr = kmap(bh->b_page);
-	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
-	if (nilfs_segment_usage_error(su)) {
-		kunmap(bh->b_page);
-		brelse(bh);
-		ret = -EINVAL;
-		goto out_sem;
-	}
-
-	if (sup != NULL)
-		*sup = su;
-	*bhp = bh;
-
- out_sem:
-	up_write(&NILFS_MDT(sufile)->mi_sem);
-	return ret;
-}
-
-/**
- * nilfs_sufile_put_segment_usage - put a segment usage
- * @sufile: inode of segment usage file
- * @segnum: segment number
- * @bh: buffer head
- *
- * Description: nilfs_sufile_put_segment_usage() releases the segment usage
- * specified by @segnum. @bh must be the buffer head which have been returned
- * by a previous call to nilfs_sufile_get_segment_usage() with @segnum.
- */
-void nilfs_sufile_put_segment_usage(struct inode *sufile, __u64 segnum,
-				    struct buffer_head *bh)
-{
-	kunmap(bh->b_page);
-	brelse(bh);
-}
-
-/**
  * nilfs_sufile_mark_dirty - mark the buffer having a segment usage dirty
  * @sufile: inode of segment usage file
  * @segnum: segment number
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index e1186bf..15163b8 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -37,11 +37,6 @@ static inline unsigned long nilfs_sufile_get_nsegments(struct inode *sufile)
 unsigned long nilfs_sufile_get_ncleansegs(struct inode *sufile);
 
 int nilfs_sufile_alloc(struct inode *, __u64 *);
-int nilfs_sufile_get_segment_usage(struct inode *, __u64,
-				   struct nilfs_segment_usage **,
-				   struct buffer_head **);
-void nilfs_sufile_put_segment_usage(struct inode *, __u64,
-				    struct buffer_head *);
 int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum);
 int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
 				   unsigned long nblocks, time_t modtime);
-- 
1.6.3.4
