From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/3] nilfs2: use BIT() macro
Date: Mon, 13 Jun 2016 22:45:06 +0900
Message-ID: <1465825507-3407-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1465825507-3407-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=7wT0aZOeQ2YhC2MZmPppSvX7ljJ7Zq6yK2xttgHujbA=;
        b=xreb1T5xPx2qRbFea5tSx45haT7UftXZoZF9/Rj3oxbU3rV3Yz1XGBPtMVzvW/TFEK
         0Ql9dhIGS0pIwbn1bifDp8iaaPOXL7lADr/UcNOFvK4NAV0MVDCfbScUuH9E+OiTM2Uu
         5eSOv40RVFA5UiHZDcI+yWz2CWr50T8s+YRRPpjjtJQ9GyT5yVnisqTL2yXc/to9P67Y
         cIXTw+fJHAlWIfQH0b0Bp45hr1OVk8Nh3sluvfiUIQXx0wxsZgU1NXlGLKZ1n1/9P3B7
         j7A19wW3lfrCwyDu0XtZdGe0vFQIFLIMaIF1i+Z2hHFKzypIt2/j2MDVm8nnUrFIyg8P
         U7uA==
In-Reply-To: <1465825507-3407-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Replace bit shifts by BIT macro for clarity.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/btnode.c  |  4 ++--
 fs/nilfs2/inode.c   |  4 ++--
 fs/nilfs2/nilfs.h   | 15 +++++++--------
 fs/nilfs2/page.c    | 26 +++++++++++++-------------
 fs/nilfs2/segment.c | 14 +++++++-------
 fs/nilfs2/sufile.c  | 12 ++++++------
 6 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 0576033..7641cc8 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -41,7 +41,7 @@ nilfs_btnode_create_block(struct address_space *btnc, __u64 blocknr)
 	struct inode *inode = NILFS_BTNC_I(btnc);
 	struct buffer_head *bh;
 
-	bh = nilfs_grab_buffer(inode, btnc, blocknr, 1 << BH_NILFS_Node);
+	bh = nilfs_grab_buffer(inode, btnc, blocknr, BIT(BH_NILFS_Node));
 	if (unlikely(!bh))
 		return NULL;
 
@@ -70,7 +70,7 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 	struct page *page;
 	int err;
 
-	bh = nilfs_grab_buffer(inode, btnc, blocknr, 1 << BH_NILFS_Node);
+	bh = nilfs_grab_buffer(inode, btnc, blocknr, BIT(BH_NILFS_Node));
 	if (unlikely(!bh))
 		return -ENOMEM;
 
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index b286b35..af04f55 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -356,7 +356,7 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 
 	root = NILFS_I(dir)->i_root;
 	ii = NILFS_I(inode);
-	ii->i_state = 1 << NILFS_I_NEW;
+	ii->i_state = BIT(NILFS_I_NEW);
 	ii->i_root = root;
 
 	err = nilfs_ifile_create_inode(root->ifile, &ino, &ii->i_bh);
@@ -555,7 +555,7 @@ static int nilfs_iget_set(struct inode *inode, void *opaque)
 
 	inode->i_ino = args->ino;
 	if (args->for_gc) {
-		NILFS_I(inode)->i_state = 1 << NILFS_I_GCINODE;
+		NILFS_I(inode)->i_state = BIT(NILFS_I_GCINODE);
 		NILFS_I(inode)->i_cno = args->cno;
 		NILFS_I(inode)->i_root = NULL;
 	} else {
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index b7064fae..c6b6960 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -119,20 +119,19 @@ enum {
 /*
  * Macros to check inode numbers
  */
-#define NILFS_MDT_INO_BITS   \
-	((unsigned int)(1 << NILFS_DAT_INO | 1 << NILFS_CPFILE_INO |	\
-			1 << NILFS_SUFILE_INO | 1 << NILFS_IFILE_INO |	\
-			1 << NILFS_ATIME_INO | 1 << NILFS_SKETCH_INO))
+#define NILFS_MDT_INO_BITS						\
+	(BIT(NILFS_DAT_INO) | BIT(NILFS_CPFILE_INO) |			\
+	 BIT(NILFS_SUFILE_INO) | BIT(NILFS_IFILE_INO) |			\
+	 BIT(NILFS_ATIME_INO) | BIT(NILFS_SKETCH_INO))
 
-#define NILFS_SYS_INO_BITS   \
-	((unsigned int)(1 << NILFS_ROOT_INO) | NILFS_MDT_INO_BITS)
+#define NILFS_SYS_INO_BITS (BIT(NILFS_ROOT_INO) | NILFS_MDT_INO_BITS)
 
 #define NILFS_FIRST_INO(sb) (((struct the_nilfs *)sb->s_fs_info)->ns_first_ino)
 
 #define NILFS_MDT_INODE(sb, ino) \
-	((ino) < NILFS_FIRST_INO(sb) && (NILFS_MDT_INO_BITS & (1 << (ino))))
+	((ino) < NILFS_FIRST_INO(sb) && (NILFS_MDT_INO_BITS & BIT(ino)))
 #define NILFS_VALID_INODE(sb, ino) \
-	((ino) >= NILFS_FIRST_INO(sb) || (NILFS_SYS_INO_BITS & (1 << (ino))))
+	((ino) >= NILFS_FIRST_INO(sb) || (NILFS_SYS_INO_BITS & BIT(ino)))
 
 /**
  * struct nilfs_transaction_info: context information for synchronization
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index eaccf12..f11a3ad 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -30,9 +30,9 @@
 #include "mdt.h"
 
 
-#define NILFS_BUFFER_INHERENT_BITS  \
-	((1UL << BH_Uptodate) | (1UL << BH_Mapped) | (1UL << BH_NILFS_Node) | \
-	 (1UL << BH_NILFS_Volatile) | (1UL << BH_NILFS_Checked))
+#define NILFS_BUFFER_INHERENT_BITS					\
+	(BIT(BH_Uptodate) | BIT(BH_Mapped) | BIT(BH_NILFS_Node) |	\
+	 BIT(BH_NILFS_Volatile) | BIT(BH_NILFS_Checked))
 
 static struct buffer_head *
 __nilfs_get_page_block(struct page *page, unsigned long block, pgoff_t index,
@@ -85,9 +85,9 @@ void nilfs_forget_buffer(struct buffer_head *bh)
 {
 	struct page *page = bh->b_page;
 	const unsigned long clear_bits =
-		(1 << BH_Uptodate | 1 << BH_Dirty | 1 << BH_Mapped |
-		 1 << BH_Async_Write | 1 << BH_NILFS_Volatile |
-		 1 << BH_NILFS_Checked | 1 << BH_NILFS_Redirected);
+		(BIT(BH_Uptodate) | BIT(BH_Dirty) | BIT(BH_Mapped) |
+		 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
+		 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected));
 
 	lock_buffer(bh);
 	set_mask_bits(&bh->b_state, clear_bits, 0);
@@ -124,17 +124,17 @@ void nilfs_copy_buffer(struct buffer_head *dbh, struct buffer_head *sbh)
 	dbh->b_bdev = sbh->b_bdev;
 
 	bh = dbh;
-	bits = sbh->b_state & ((1UL << BH_Uptodate) | (1UL << BH_Mapped));
+	bits = sbh->b_state & (BIT(BH_Uptodate) | BIT(BH_Mapped));
 	while ((bh = bh->b_this_page) != dbh) {
 		lock_buffer(bh);
 		bits &= bh->b_state;
 		unlock_buffer(bh);
 	}
-	if (bits & (1UL << BH_Uptodate))
+	if (bits & BIT(BH_Uptodate))
 		SetPageUptodate(dpage);
 	else
 		ClearPageUptodate(dpage);
-	if (bits & (1UL << BH_Mapped))
+	if (bits & BIT(BH_Mapped))
 		SetPageMappedToDisk(dpage);
 	else
 		ClearPageMappedToDisk(dpage);
@@ -215,7 +215,7 @@ static void nilfs_copy_page(struct page *dst, struct page *src, int copy_dirty)
 		create_empty_buffers(dst, sbh->b_size, 0);
 
 	if (copy_dirty)
-		mask |= (1UL << BH_Dirty);
+		mask |= BIT(BH_Dirty);
 
 	dbh = dbufs = page_buffers(dst);
 	do {
@@ -414,9 +414,9 @@ void nilfs_clear_dirty_page(struct page *page, bool silent)
 	if (page_has_buffers(page)) {
 		struct buffer_head *bh, *head;
 		const unsigned long clear_bits =
-			(1 << BH_Uptodate | 1 << BH_Dirty | 1 << BH_Mapped |
-			 1 << BH_Async_Write | 1 << BH_NILFS_Volatile |
-			 1 << BH_NILFS_Checked | 1 << BH_NILFS_Redirected);
+			(BIT(BH_Uptodate) | BIT(BH_Dirty) | BIT(BH_Mapped) |
+			 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
+			 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected));
 
 		bh = head = page_buffers(page);
 		do {
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 5a97282..bedcae2 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1858,11 +1858,11 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 		 */
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
-			const unsigned long set_bits = (1 << BH_Uptodate);
+			const unsigned long set_bits = BIT(BH_Uptodate);
 			const unsigned long clear_bits =
-				(1 << BH_Dirty | 1 << BH_Async_Write |
-				 1 << BH_Delay | 1 << BH_NILFS_Volatile |
-				 1 << BH_NILFS_Redirected);
+				(BIT(BH_Dirty) | BIT(BH_Async_Write) |
+				 BIT(BH_Delay) | BIT(BH_NILFS_Volatile) |
+				 BIT(BH_NILFS_Redirected));
 
 			set_mask_bits(&bh->b_state, clear_bits, set_bits);
 			if (bh == segbuf->sb_super_root) {
@@ -2132,10 +2132,10 @@ static void nilfs_segctor_start_timer(struct nilfs_sc_info *sci)
 static void nilfs_segctor_do_flush(struct nilfs_sc_info *sci, int bn)
 {
 	spin_lock(&sci->sc_state_lock);
-	if (!(sci->sc_flush_request & (1 << bn))) {
+	if (!(sci->sc_flush_request & BIT(bn))) {
 		unsigned long prev_req = sci->sc_flush_request;
 
-		sci->sc_flush_request |= (1 << bn);
+		sci->sc_flush_request |= BIT(bn);
 		if (!prev_req)
 			wake_up(&sci->sc_wait_daemon);
 	}
@@ -2319,7 +2319,7 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 }
 
 #define FLUSH_FILE_BIT	(0x1) /* data file only */
-#define FLUSH_DAT_BIT	(1 << NILFS_DAT_INO) /* DAT only */
+#define FLUSH_DAT_BIT	BIT(NILFS_DAT_INO) /* DAT only */
 
 /**
  * nilfs_segctor_accept - record accepted sequence count of log-write requests
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 5b495c4..12d11de 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -446,7 +446,7 @@ void nilfs_sufile_do_scrap(struct inode *sufile, __u64 segnum,
 
 	kaddr = kmap_atomic(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
-	if (su->su_flags == cpu_to_le32(1UL << NILFS_SEGMENT_USAGE_DIRTY) &&
+	if (su->su_flags == cpu_to_le32(BIT(NILFS_SEGMENT_USAGE_DIRTY)) &&
 	    su->su_nblocks == cpu_to_le32(0)) {
 		kunmap_atomic(kaddr);
 		return;
@@ -457,7 +457,7 @@ void nilfs_sufile_do_scrap(struct inode *sufile, __u64 segnum,
 	/* make the segment garbage */
 	su->su_lastmod = cpu_to_le64(0);
 	su->su_nblocks = cpu_to_le32(0);
-	su->su_flags = cpu_to_le32(1UL << NILFS_SEGMENT_USAGE_DIRTY);
+	su->su_flags = cpu_to_le32(BIT(NILFS_SEGMENT_USAGE_DIRTY));
 	kunmap_atomic(kaddr);
 
 	nilfs_sufile_mod_counter(header_bh, clean ? (u64)-1 : 0, dirty ? 0 : 1);
@@ -695,7 +695,7 @@ static int nilfs_sufile_truncate_range(struct inode *sufile,
 		su2 = su;
 		for (j = 0; j < n; j++, su = (void *)su + susz) {
 			if ((le32_to_cpu(su->su_flags) &
-			     ~(1UL << NILFS_SEGMENT_USAGE_ERROR)) ||
+			     ~BIT(NILFS_SEGMENT_USAGE_ERROR)) ||
 			    nilfs_segment_is_active(nilfs, segnum + j)) {
 				ret = -EBUSY;
 				kunmap_atomic(kaddr);
@@ -862,10 +862,10 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
 			si->sui_lastmod = le64_to_cpu(su->su_lastmod);
 			si->sui_nblocks = le32_to_cpu(su->su_nblocks);
 			si->sui_flags = le32_to_cpu(su->su_flags) &
-				~(1UL << NILFS_SEGMENT_USAGE_ACTIVE);
+				~BIT(NILFS_SEGMENT_USAGE_ACTIVE);
 			if (nilfs_segment_is_active(nilfs, segnum + j))
 				si->sui_flags |=
-					(1UL << NILFS_SEGMENT_USAGE_ACTIVE);
+					BIT(NILFS_SEGMENT_USAGE_ACTIVE);
 		}
 		kunmap_atomic(kaddr);
 		brelse(su_bh);
@@ -953,7 +953,7 @@ ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
 			 * disk.
 			 */
 			sup->sup_sui.sui_flags &=
-					~(1UL << NILFS_SEGMENT_USAGE_ACTIVE);
+					~BIT(NILFS_SEGMENT_USAGE_ACTIVE);
 
 			cleansi = nilfs_suinfo_clean(&sup->sup_sui);
 			cleansu = nilfs_segment_usage_clean(su);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
