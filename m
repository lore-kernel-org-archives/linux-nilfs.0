From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 6/8] nilfs2: get rid of sc_sbi back pointer
Date: Wed,  9 Mar 2011 21:08:11 +0900
Message-ID: <1299672493-28544-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1299672493-28544-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1299672493-28544-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Removes sci->sc_sbi which is a back pointer to nilfs_sb_info struct
from log writer object (nilfs_sc_info).

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/segment.c |   29 ++++++++++++-----------------
 fs/nilfs2/segment.h |    2 --
 2 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index e3d1785..b14788e 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -772,7 +772,7 @@ static int nilfs_segctor_clean(struct nilfs_sc_info *sci)
 
 static int nilfs_segctor_confirm(struct nilfs_sc_info *sci)
 {
-	struct the_nilfs *nilfs = sci->sc_sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sci->sc_super)->s_nilfs;
 	int ret = 0;
 
 	if (nilfs_test_metadata_dirty(nilfs, sci->sc_root))
@@ -788,8 +788,7 @@ static int nilfs_segctor_confirm(struct nilfs_sc_info *sci)
 
 static void nilfs_segctor_clear_metadata_dirty(struct nilfs_sc_info *sci)
 {
-	struct nilfs_sb_info *sbi = sci->sc_sbi;
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sci->sc_super)->s_nilfs;
 
 	nilfs_mdt_clear_dirty(sci->sc_root->ifile);
 	nilfs_mdt_clear_dirty(nilfs->ns_cpfile);
@@ -799,7 +798,7 @@ static void nilfs_segctor_clear_metadata_dirty(struct nilfs_sc_info *sci)
 
 static int nilfs_segctor_create_checkpoint(struct nilfs_sc_info *sci)
 {
-	struct the_nilfs *nilfs = sci->sc_sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sci->sc_super)->s_nilfs;
 	struct buffer_head *bh_cp;
 	struct nilfs_checkpoint *raw_cp;
 	int err;
@@ -823,8 +822,7 @@ static int nilfs_segctor_create_checkpoint(struct nilfs_sc_info *sci)
 
 static int nilfs_segctor_fill_in_checkpoint(struct nilfs_sc_info *sci)
 {
-	struct nilfs_sb_info *sbi = sci->sc_sbi;
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sci->sc_super)->s_nilfs;
 	struct buffer_head *bh_cp;
 	struct nilfs_checkpoint *raw_cp;
 	int err;
@@ -1048,8 +1046,7 @@ static int nilfs_segctor_scan_file_dsync(struct nilfs_sc_info *sci,
 
 static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
 {
-	struct nilfs_sb_info *sbi = sci->sc_sbi;
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sci->sc_super)->s_nilfs;
 	struct list_head *head;
 	struct nilfs_inode_info *ii;
 	size_t ndone;
@@ -1858,7 +1855,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 {
 	struct nilfs_segment_buffer *segbuf;
 	struct page *bd_page = NULL, *fs_page = NULL;
-	struct the_nilfs *nilfs = sci->sc_sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sci->sc_super)->s_nilfs;
 	int update_sr = false;
 
 	list_for_each_entry(segbuf, &sci->sc_write_logs, sb_list) {
@@ -2029,8 +2026,7 @@ static void nilfs_segctor_drop_written_files(struct nilfs_sc_info *sci,
  */
 static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 {
-	struct nilfs_sb_info *sbi = sci->sc_sbi;
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sci->sc_super)->s_nilfs;
 	struct page *failed_page;
 	int err;
 
@@ -2388,7 +2384,7 @@ static void nilfs_segctor_notify(struct nilfs_sc_info *sci, int mode, int err)
  */
 static int nilfs_segctor_construct(struct nilfs_sc_info *sci, int mode)
 {
-	struct nilfs_sb_info *sbi = sci->sc_sbi;
+	struct nilfs_sb_info *sbi = NILFS_SB(sci->sc_super);
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 	struct nilfs_super_block **sbp;
 	int err = 0;
@@ -2501,7 +2497,7 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 
 static void nilfs_segctor_thread_construct(struct nilfs_sc_info *sci, int mode)
 {
-	struct nilfs_sb_info *sbi = sci->sc_sbi;
+	struct nilfs_sb_info *sbi = NILFS_SB(sci->sc_super);
 	struct nilfs_transaction_info ti;
 
 	nilfs_transaction_lock(sbi, &ti, 0);
@@ -2561,7 +2557,7 @@ static int nilfs_segctor_flush_mode(struct nilfs_sc_info *sci)
 static int nilfs_segctor_thread(void *arg)
 {
 	struct nilfs_sc_info *sci = (struct nilfs_sc_info *)arg;
-	struct the_nilfs *nilfs = sci->sc_sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sci->sc_super)->s_nilfs;
 	int timeout = 0;
 
 	sci->sc_timer.data = (unsigned long)current;
@@ -2682,7 +2678,6 @@ static struct nilfs_sc_info *nilfs_segctor_new(struct nilfs_sb_info *sbi,
 	if (!sci)
 		return NULL;
 
-	sci->sc_sbi = sbi;
 	sci->sc_super = sbi->s_super;
 
 	nilfs_get_root(root);
@@ -2717,7 +2712,7 @@ static void nilfs_segctor_write_out(struct nilfs_sc_info *sci)
 	/* The segctord thread was stopped and its timer was removed.
 	   But some tasks remain. */
 	do {
-		struct nilfs_sb_info *sbi = sci->sc_sbi;
+		struct nilfs_sb_info *sbi = NILFS_SB(sci->sc_super);
 		struct nilfs_transaction_info ti;
 
 		nilfs_transaction_lock(sbi, &ti, 0);
@@ -2737,7 +2732,7 @@ static void nilfs_segctor_write_out(struct nilfs_sc_info *sci)
  */
 static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 {
-	struct the_nilfs *nilfs = sci->sc_sbi->s_nilfs;
+	struct the_nilfs *nilfs = NILFS_SB(sci->sc_super)->s_nilfs;
 	int flag;
 
 	up_write(&nilfs->ns_segctor_sem);
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index cd8056e..9544aa9 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -88,7 +88,6 @@ struct nilfs_segsum_pointer {
 /**
  * struct nilfs_sc_info - Segment constructor information
  * @sc_super: Back pointer to super_block struct
- * @sc_sbi: Back pointer to nilfs_sb_info struct
  * @sc_root: root object of the current filesystem tree
  * @sc_nblk_inc: Block count of current generation
  * @sc_dirty_files: List of files to be written
@@ -131,7 +130,6 @@ struct nilfs_segsum_pointer {
  */
 struct nilfs_sc_info {
 	struct super_block     *sc_super;
-	struct nilfs_sb_info   *sc_sbi;
 	struct nilfs_root      *sc_root;
 
 	unsigned long		sc_nblk_inc;
-- 
1.7.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
