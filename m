From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/6] nilfs2: do not return io error for bio
	allocation failure
Date: Mon, 30 Nov 2009 22:30:41 +0900
Message-ID: <1259587845-3436-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1259587845-3436-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1259587845-3436-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
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

Previously, log writer had possibility to set an io error flag on
segments even in case of memory allocation failure.

This fixes the issue.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segbuf.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index e6d9e37..c71b689 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -374,7 +374,7 @@ int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
 		       struct nilfs_write_info *wi)
 {
 	struct buffer_head *bh;
-	int res, rw = WRITE;
+	int res = 0, rw = WRITE;
 
 	list_for_each_entry(bh, &segbuf->sb_segsum_buffers, b_assoc_buffers) {
 		res = nilfs_submit_bh(wi, bh, rw);
@@ -395,17 +395,10 @@ int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
 		 */
 		rw |= (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG);
 		res = nilfs_submit_seg_bio(wi, rw);
-		if (unlikely(res))
-			goto failed_bio;
 	}
 
-	res = 0;
- out:
-	return res;
-
  failed_bio:
-	atomic_inc(&wi->err);
-	goto out;
+	return res;
 }
 
 /**
-- 
1.6.3.4
