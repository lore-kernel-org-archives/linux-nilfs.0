From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 1/3] nilfs2: fix misuse of a semaphore in sysfs code
Date: Mon, 13 Jun 2016 22:45:05 +0900
Message-ID: <1465825507-3407-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1465825507-3407-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=EahfJVBLTeva5u8wzKkEPToxFFbmDR558ckgotklh9A=;
        b=AXNEs/ezcU0E+FfJeQnAvB+Dj7zJDgJN79tj5qnYeU5Kw/KGxIKOcZhFz7ko5LXtBi
         FnLy4ygG8JnECq+N6G9O9FHUSRxbI3T+9K+cfKrBB32lcTvtZbxH2og7JmwejjQUvs8a
         3BoGi90Xmph28EIFHibfLANVADdH4BZ3zSjGG1hglJdSwJIN7cHf8UnolGmajx4wjfAn
         CVIPDr8/RaImLzEdiSIx1e0tXkzOpJZ15JjQoAaSqciuE1d/U/rQJ9O+3F9fk76F3Eyy
         7TezAr5muedssPUmt+c8Vxs4dWOMUkbNq2Qz9riklvju1pwDrYlHg5P/Nah+SlPrrTYv
         ql2Q==
In-Reply-To: <1465825507-3407-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Variables ns_seg_seq, ns_segnum, ns_nextnum, ns_pseg_offset, ns_cno,
ns_ctime, ns_nongc_ctime, and ns_ndirtyblks, are protected by
ns_segctor_sem, but ns_sem is wrongly used by the nilfs sysfs code
when reading these variables.  This fixes the misuse and clarifies
which semaphore protects them in the comment of the_nilfs struct.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/sysfs.c     | 44 ++++++++++++++++++++++----------------------
 fs/nilfs2/the_nilfs.h |  7 ++-----
 2 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 8e57bb9..490303e 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -326,9 +326,9 @@ nilfs_checkpoints_next_checkpoint_show(struct nilfs_checkpoints_attr *attr,
 {
 	__u64 cno;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	cno = nilfs->ns_cno;
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return snprintf(buf, PAGE_SIZE, "%llu\n", cno);
 }
@@ -511,9 +511,9 @@ nilfs_segctor_current_seg_sequence_show(struct nilfs_segctor_attr *attr,
 {
 	u64 seg_seq;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	seg_seq = nilfs->ns_seg_seq;
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return snprintf(buf, PAGE_SIZE, "%llu\n", seg_seq);
 }
@@ -525,9 +525,9 @@ nilfs_segctor_current_last_full_seg_show(struct nilfs_segctor_attr *attr,
 {
 	__u64 segnum;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	segnum = nilfs->ns_segnum;
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return snprintf(buf, PAGE_SIZE, "%llu\n", segnum);
 }
@@ -539,9 +539,9 @@ nilfs_segctor_next_full_seg_show(struct nilfs_segctor_attr *attr,
 {
 	__u64 nextnum;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	nextnum = nilfs->ns_nextnum;
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return snprintf(buf, PAGE_SIZE, "%llu\n", nextnum);
 }
@@ -553,9 +553,9 @@ nilfs_segctor_next_pseg_offset_show(struct nilfs_segctor_attr *attr,
 {
 	unsigned long pseg_offset;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	pseg_offset = nilfs->ns_pseg_offset;
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return snprintf(buf, PAGE_SIZE, "%lu\n", pseg_offset);
 }
@@ -567,9 +567,9 @@ nilfs_segctor_next_checkpoint_show(struct nilfs_segctor_attr *attr,
 {
 	__u64 cno;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	cno = nilfs->ns_cno;
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return snprintf(buf, PAGE_SIZE, "%llu\n", cno);
 }
@@ -581,9 +581,9 @@ nilfs_segctor_last_seg_write_time_show(struct nilfs_segctor_attr *attr,
 {
 	time_t ctime;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	ctime = nilfs->ns_ctime;
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return NILFS_SHOW_TIME(ctime, buf);
 }
@@ -595,9 +595,9 @@ nilfs_segctor_last_seg_write_time_secs_show(struct nilfs_segctor_attr *attr,
 {
 	time_t ctime;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	ctime = nilfs->ns_ctime;
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return snprintf(buf, PAGE_SIZE, "%llu\n", (unsigned long long)ctime);
 }
@@ -609,9 +609,9 @@ nilfs_segctor_last_nongc_write_time_show(struct nilfs_segctor_attr *attr,
 {
 	time_t nongc_ctime;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	nongc_ctime = nilfs->ns_nongc_ctime;
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return NILFS_SHOW_TIME(nongc_ctime, buf);
 }
@@ -623,9 +623,9 @@ nilfs_segctor_last_nongc_write_time_secs_show(struct nilfs_segctor_attr *attr,
 {
 	time_t nongc_ctime;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	nongc_ctime = nilfs->ns_nongc_ctime;
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return snprintf(buf, PAGE_SIZE, "%llu\n",
 			(unsigned long long)nongc_ctime);
@@ -638,9 +638,9 @@ nilfs_segctor_dirty_data_blocks_count_show(struct nilfs_segctor_attr *attr,
 {
 	u32 ndirtyblks;
 
-	down_read(&nilfs->ns_sem);
+	down_read(&nilfs->ns_segctor_sem);
 	ndirtyblks = atomic_read(&nilfs->ns_ndirtyblks);
-	up_read(&nilfs->ns_sem);
+	up_read(&nilfs->ns_segctor_sem);
 
 	return snprintf(buf, PAGE_SIZE, "%u\n", ndirtyblks);
 }
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 79d1421..b305c6f 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -122,11 +122,8 @@ struct the_nilfs {
 	unsigned int		ns_sb_update_freq;
 
 	/*
-	 * Following fields are dedicated to a writable FS-instance.
-	 * Except for the period seeking checkpoint, code outside the segment
-	 * constructor must lock a segment semaphore while accessing these
-	 * fields.
-	 * The writable FS-instance is sole during a lifetime of the_nilfs.
+	 * The following fields are updated by a writable FS-instance.
+	 * These fields are protected by ns_segctor_sem outside load_nilfs().
 	 */
 	u64			ns_seg_seq;
 	__u64			ns_segnum;
-- 
1.8.3.1

