From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 11/23] nilfs2: add local variable to cache the
	number of clean segments
Date: Sun, 15 Nov 2009 21:46:49 +0900
Message-ID: <1258289221-3827-12-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
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

This makes it possible for sufile to get the number of clean segments
faster.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/sufile.c |   53 ++++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 8834472..e9b4cec 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -31,6 +31,16 @@
 #include "sufile.h"
 
 
+struct nilfs_sufile_info {
+	struct nilfs_mdt_info mi;
+	unsigned long ncleansegs;
+};
+
+static inline struct nilfs_sufile_info *NILFS_SUI(struct inode *sufile)
+{
+	return (struct nilfs_sufile_info *)NILFS_MDT(sufile);
+}
+
 static inline unsigned long
 nilfs_sufile_segment_usages_per_block(const struct inode *sufile)
 {
@@ -300,6 +310,7 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 			header->sh_last_alloc = cpu_to_le64(segnum);
 			kunmap_atomic(kaddr, KM_USER0);
 
+			NILFS_SUI(sufile)->ncleansegs--;
 			nilfs_mdt_mark_buffer_dirty(header_bh);
 			nilfs_mdt_mark_buffer_dirty(su_bh);
 			nilfs_mdt_mark_dirty(sufile);
@@ -342,6 +353,8 @@ void nilfs_sufile_do_cancel_free(struct inode *sufile, __u64 segnum,
 	kunmap_atomic(kaddr, KM_USER0);
 
 	nilfs_sufile_mod_counter(header_bh, -1, 1);
+	NILFS_SUI(sufile)->ncleansegs--;
+
 	nilfs_mdt_mark_buffer_dirty(su_bh);
 	nilfs_mdt_mark_dirty(sufile);
 }
@@ -371,6 +384,8 @@ void nilfs_sufile_do_scrap(struct inode *sufile, __u64 segnum,
 	kunmap_atomic(kaddr, KM_USER0);
 
 	nilfs_sufile_mod_counter(header_bh, clean ? (u64)-1 : 0, dirty ? 0 : 1);
+	NILFS_SUI(sufile)->ncleansegs -= clean;
+
 	nilfs_mdt_mark_buffer_dirty(su_bh);
 	nilfs_mdt_mark_dirty(sufile);
 }
@@ -400,6 +415,8 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
 	nilfs_mdt_mark_buffer_dirty(su_bh);
 
 	nilfs_sufile_mod_counter(header_bh, 1, sudirty ? (u64)-1 : 0);
+	NILFS_SUI(sufile)->ncleansegs++;
+
 	nilfs_mdt_mark_dirty(sufile);
 }
 
@@ -541,13 +558,8 @@ int nilfs_sufile_get_stat(struct inode *sufile, struct nilfs_sustat *sustat)
  */
 int nilfs_sufile_get_ncleansegs(struct inode *sufile, unsigned long *nsegsp)
 {
-	struct nilfs_sustat sustat;
-	int ret;
-
-	ret = nilfs_sufile_get_stat(sufile, &sustat);
-	if (ret == 0)
-		*nsegsp = sustat.ss_ncleansegs;
-	return ret;
+	*nsegsp = NILFS_SUI(sufile)->ncleansegs;
+	return 0;
 }
 
 void nilfs_sufile_do_set_error(struct inode *sufile, __u64 segnum,
@@ -568,8 +580,10 @@ void nilfs_sufile_do_set_error(struct inode *sufile, __u64 segnum,
 	nilfs_segment_usage_set_error(su);
 	kunmap_atomic(kaddr, KM_USER0);
 
-	if (suclean)
+	if (suclean) {
 		nilfs_sufile_mod_counter(header_bh, -1, 0);
+		NILFS_SUI(sufile)->ncleansegs--;
+	}
 	nilfs_mdt_mark_buffer_dirty(su_bh);
 	nilfs_mdt_mark_dirty(sufile);
 }
@@ -656,7 +670,25 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
  */
 int nilfs_sufile_read(struct inode *sufile, struct nilfs_inode *raw_inode)
 {
-	return nilfs_read_inode_common(sufile, raw_inode);
+	struct nilfs_sufile_info *sui = NILFS_SUI(sufile);
+	struct buffer_head *header_bh;
+	struct nilfs_sufile_header *header;
+	void *kaddr;
+	int ret;
+
+	ret = nilfs_read_inode_common(sufile, raw_inode);
+	if (ret < 0)
+		return ret;
+
+	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
+	if (!ret) {
+		kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+		header = kaddr + bh_offset(header_bh);
+		sui->ncleansegs = le64_to_cpu(header->sh_ncleansegs);
+		kunmap_atomic(kaddr, KM_USER0);
+		brelse(header_bh);
+	}
+	return ret;
 }
 
 /**
@@ -668,7 +700,8 @@ struct inode *nilfs_sufile_new(struct the_nilfs *nilfs, size_t susize)
 {
 	struct inode *sufile;
 
-	sufile = nilfs_mdt_new(nilfs, NULL, NILFS_SUFILE_INO, 0);
+	sufile = nilfs_mdt_new(nilfs, NULL, NILFS_SUFILE_INO,
+			       sizeof(struct nilfs_sufile_info));
 	if (sufile)
 		nilfs_mdt_set_entry_size(sufile, susize,
 					 sizeof(struct nilfs_sufile_header));
-- 
1.6.3.4
