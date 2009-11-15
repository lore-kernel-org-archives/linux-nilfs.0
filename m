From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 10/23] nilfs2: unfold
	nilfs_sufile_block_get_header function
Date: Sun, 15 Nov 2009 21:46:48 +0900
Message-ID: <1258289221-3827-11-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This unfolds the nilfs_sufile_block_get_header() function for
simplicity.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/sufile.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index b344f27..8834472 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -62,14 +62,6 @@ nilfs_sufile_segment_usages_in_block(const struct inode *sufile, __u64 curr,
 		     max - curr + 1);
 }
 
-static inline struct nilfs_sufile_header *
-nilfs_sufile_block_get_header(const struct inode *sufile,
-			      struct buffer_head *bh,
-			      void *kaddr)
-{
-	return kaddr + bh_offset(bh);
-}
-
 static struct nilfs_segment_usage *
 nilfs_sufile_block_get_segment_usage(const struct inode *sufile, __u64 segnum,
 				     struct buffer_head *bh, void *kaddr)
@@ -270,7 +262,7 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 	if (ret < 0)
 		goto out_sem;
 	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
-	header = nilfs_sufile_block_get_header(sufile, header_bh, kaddr);
+	header = kaddr + bh_offset(header_bh);
 	ncleansegs = le64_to_cpu(header->sh_ncleansegs);
 	last_alloc = le64_to_cpu(header->sh_last_alloc);
 	kunmap_atomic(kaddr, KM_USER0);
@@ -302,8 +294,7 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 			kunmap_atomic(kaddr, KM_USER0);
 
 			kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
-			header = nilfs_sufile_block_get_header(
-				sufile, header_bh, kaddr);
+			header = kaddr + bh_offset(header_bh);
 			le64_add_cpu(&header->sh_ncleansegs, -1);
 			le64_add_cpu(&header->sh_ndirtysegs, 1);
 			header->sh_last_alloc = cpu_to_le64(segnum);
@@ -515,7 +506,7 @@ int nilfs_sufile_get_stat(struct inode *sufile, struct nilfs_sustat *sustat)
 		goto out_sem;
 
 	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
-	header = nilfs_sufile_block_get_header(sufile, header_bh, kaddr);
+	header = kaddr + bh_offset(header_bh);
 	sustat->ss_nsegs = nilfs_sufile_get_nsegments(sufile);
 	sustat->ss_ncleansegs = le64_to_cpu(header->sh_ncleansegs);
 	sustat->ss_ndirtysegs = le64_to_cpu(header->sh_ndirtysegs);
-- 
1.6.3.4
