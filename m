Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A949718C039;
	Thu,  9 Jan 2025 03:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736393308; cv=none; b=Ex84AZmWc3wUySBvpu5geY9+JNM2j+KM8MNM8aJytkMYM2i0ObZENd9eNsr4teeaZK9QXEuc/oBfF5ns6gH634dJI0jH+XhoMWXL9C0uxMww14CQcH934S7/SZxFYLuNgFd3O8mHcrU0hnvpL2q2DZjibWTHLPlnh9d8hS4v+dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736393308; c=relaxed/simple;
	bh=6dQxUNzSuilcgy9/j+F5ThC+2Fq5KDS+c6hIWRvlcaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJc45jxWHPuSsz1U0IybMwOFk8HGG+siTcAQ3pP7g68W/u78NDuqJILqT5K1C5zcZkvfF16p+a88qGK0z18CA6jvS/o4axAYsULx3Eji//9WQZR5TCJ2iTo/+nIntV9Khh3z0vX2n2RCPIC0/Ipcz8QUcYaVcEUd349rOkAOUUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VqAKP5zD; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VqAKP5zD"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2ee74291415so646687a91.3;
        Wed, 08 Jan 2025 19:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736393306; x=1736998106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xj+jkXlg8GgaeC3zx83MHGcdKZ6KPzSuLeeYhzZqUdg=;
        b=VqAKP5zDqWYsp1TfWH5UqRFZ7XXTQ8z/m2xAYk4Te8QK6cywS7QglMeO7uSIDt+sZw
         NZfSWDPyJlnG+8AXmlKBfraQcVfa+w0WfKiA7ORZhI52dOYLVcpA+ksgOSguws7bdet+
         SZCz22+BydPqE36Pkvobon+sjPWqstwzwCwoUi2/XTsTeM0SiUrQjZ+R9BXR9f7k6NPh
         1IqRgX26EPAk1rl78heN+MwU/mrqJUiH3A6VQ3ewc7+gjOGadf2PZK4X8dkO6NONIYup
         aK8hvH8ui5ItCF5KFqOL/q+YNuIO0r4L851/prT4B+vGp67HhveN0DwN/TyLNmVdTnQm
         Nskg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736393306; x=1736998106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xj+jkXlg8GgaeC3zx83MHGcdKZ6KPzSuLeeYhzZqUdg=;
        b=biW0uW2pj6r3ZJDJwtNRow4cjNdhDNwpLB4d928YO9yygG9Sq2VW533L3PPk+D6ajq
         +xDnNCHS1HkINxE5h14gL6hJT/mNT/USgBWifV3He5ptB1GjT0tEHPgbtvkdgkVFFuj8
         nSkLv0W1V0xUZP5Qm4Bw88uYxNkLGZDETIGTLcOkhniGiv5g9mFOlp+43hTaGme/G8Z7
         wOXYQ8izaCdaDQBv7U2U8ADiK0JG+ufKix0rfmvwEhhgQqisa79OiWSs1h6RFQEyDFCM
         BUF1PxjZNyuVdRecCO+WMuuFmWqhG1mzsFSdwUuvuvOsZtGjv3BNi2iwB07Dir+oghRL
         NxlA==
X-Forwarded-Encrypted: i=1; AJvYcCUSkZ8ZZXQNljUcmv4gZa6QO13qm0xwWFtltk750dk9agYO5LhAMLEG5REHApk9+tDFQHmcD+n/j15gR4A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDgN/BGhD9wyYjqtO26jdnAyNoVU7PVgMMCkB21iaRXJNb0XKA
	fB+fVSKkJiJy8DPauK0znGxMAN8R4Bp6XornRW0kD5Nuv5nUNNTP7Hj/eQ==
X-Gm-Gg: ASbGncuQAjv/E23fB9PWtSOyHag6kwzROSh1mU8UBgInGfi2Sy+CwgwOFHjRCSQumBh
	vU5+uERb04sPtW6ArnoCGfWVeoMWuAhMxHrjt0B/kcknlYf3sWnqUNJ422jlCNrB5q1DM8eicce
	L0aVjDCIWOZup1XeS+l4Www7oOIlPVK1OXFK7Q7EpSfcCq2oEJ+FP8YdR6uEuybPfDxvra0ai1L
	4a7eIUGyPHBMU13cZES2sieXDDU/8gOGMa111MmHS40LN4xogzBcOhtSll2LP9g/m9qvi6dVXJ+
	rROxLIJcc0F8Zs2zvbTg/3/N8N0G
X-Google-Smtp-Source: AGHT+IHbtPG3Yv1BGo9jnmDccwoQ6AaXae4yK3VkCe6/BnNaTuPLhLCNm9RYv+hvZC5phKMz4UyAYw==
X-Received: by 2002:a17:90a:c2c7:b0:2ee:ba84:5cac with SMTP id 98e67ed59e1d1-2f548ea5a01mr7956485a91.7.1736393305802;
        Wed, 08 Jan 2025 19:28:25 -0800 (PST)
Received: from carrot.. (i114-186-237-30.s41.a014.ap.plala.or.jp. [114.186.237.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f55942eed5sm194963a91.27.2025.01.08.19.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 19:28:25 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] nilfs2: correct return value kernel-doc descriptions for the rest
Date: Thu,  9 Jan 2025 12:23:24 +0900
Message-ID: <20250109032846.10147-6-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250109032846.10147-1-konishi.ryusuke@gmail.com>
References: <20250109032846.10147-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar to the previous changes to fix return value descriptions, this
fixes the format of the return value descriptions of functions for the
rest.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/gcinode.c   | 22 ++++++++-------------
 fs/nilfs2/inode.c     | 12 +++---------
 fs/nilfs2/recovery.c  | 30 ++++++++++-------------------
 fs/nilfs2/segbuf.c    | 12 ++----------
 fs/nilfs2/segment.c   | 45 +++++++++++++++----------------------------
 fs/nilfs2/the_nilfs.c | 12 +++++-------
 6 files changed, 43 insertions(+), 90 deletions(-)

diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 2dbb15767df1..639998099824 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -46,14 +46,10 @@
  * specified by @pbn to the GC pagecache with the key @blkoff.
  * This function sets @vbn (@pbn if @vbn is zero) in b_blocknr of the buffer.
  *
- * Return Value: On success, 0 is returned. On Error, one of the following
- * negative error code is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - The block specified with @pbn does not exist.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- The block specified with @pbn does not exist.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
 				   sector_t pbn, __u64 vbn,
@@ -114,12 +110,10 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
  * specified by @vbn to the GC pagecache.  @pbn can be supplied by the
  * caller to avoid translation of the disk block address.
  *
- * Return Value: On success, 0 is returned. On Error, one of the following
- * negative error code is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- Invalid virtual block address.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_gccache_submit_read_node(struct inode *inode, sector_t pbn,
 				   __u64 vbn, struct buffer_head **out_bh)
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 23f3a75edd50..228bfffa5d22 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -598,10 +598,7 @@ struct inode *nilfs_iget_for_gc(struct super_block *sb, unsigned long ino,
  * or does nothing if the inode already has it.  This function allocates
  * an additional inode to maintain page cache of B-tree nodes one-on-one.
  *
- * Return Value: On success, 0 is returned. On errors, one of the following
- * negative error code is returned.
- *
- * %-ENOMEM - Insufficient memory available.
+ * Return: 0 on success, or %-ENOMEM if memory is insufficient.
  */
 int nilfs_attach_btree_node_cache(struct inode *inode)
 {
@@ -660,11 +657,8 @@ void nilfs_detach_btree_node_cache(struct inode *inode)
  * in one inode and the one for b-tree node pages is set up in the
  * other inode, which is attached to the former inode.
  *
- * Return Value: On success, a pointer to the inode for data pages is
- * returned. On errors, one of the following negative error code is returned
- * in a pointer type.
- *
- * %-ENOMEM - Insufficient memory available.
+ * Return: a pointer to the inode for data pages on success, or %-ENOMEM
+ * if memory is insufficient.
  */
 struct inode *nilfs_iget_for_shadow(struct inode *inode)
 {
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index e43405bf521e..bb708e6eb42a 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -754,18 +754,12 @@ static void nilfs_abort_roll_forward(struct the_nilfs *nilfs)
  * @sb: super block instance
  * @ri: pointer to a nilfs_recovery_info struct to store search results.
  *
- * Return Value: On success, 0 is returned.  On error, one of the following
- * negative error code is returned.
- *
- * %-EINVAL - Inconsistent filesystem state.
- *
- * %-EIO - I/O error
- *
- * %-ENOSPC - No space left on device (only in a panic state).
- *
- * %-ERESTARTSYS - Interrupted.
- *
- * %-ENOMEM - Insufficient memory available.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EINVAL		- Inconsistent filesystem state.
+ * * %-EIO		- I/O error.
+ * * %-ENOMEM		- Insufficient memory available.
+ * * %-ENOSPC		- No space left on device (only in a panic state).
+ * * %-ERESTARTSYS	- Interrupted.
  */
 int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
 			      struct super_block *sb,
@@ -830,14 +824,10 @@ int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
  * segment pointed by the superblock.  It sets up struct the_nilfs through
  * this search. It fills nilfs_recovery_info (ri) required for recovery.
  *
- * Return Value: On success, 0 is returned.  On error, one of the following
- * negative error code is returned.
- *
- * %-EINVAL - No valid segment found
- *
- * %-EIO - I/O error
- *
- * %-ENOMEM - Insufficient memory available.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EINVAL	- No valid segment found.
+ * * %-EIO	- I/O error.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_search_super_root(struct the_nilfs *nilfs,
 			    struct nilfs_recovery_info *ri)
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index e08cab03366b..a8bdf3d318ea 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -406,12 +406,7 @@ static int nilfs_segbuf_submit_bh(struct nilfs_segment_buffer *segbuf,
  * @segbuf: buffer storing a log to be written
  * @nilfs: nilfs object
  *
- * Return Value: On Success, 0 is returned. On Error, one of the following
- * negative error code is returned.
- *
- * %-EIO - I/O error
- *
- * %-ENOMEM - Insufficient memory available.
+ * Return: Always 0.
  */
 static int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
 			      struct the_nilfs *nilfs)
@@ -452,10 +447,7 @@ static int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
  * nilfs_segbuf_wait - wait for completion of requested BIOs
  * @segbuf: segment buffer
  *
- * Return Value: On Success, 0 is returned. On Error, one of the following
- * negative error code is returned.
- *
- * %-EIO - I/O error
+ * Return: 0 on success, or %-EIO if I/O error is detected.
  */
 static int nilfs_segbuf_wait(struct nilfs_segment_buffer *segbuf)
 {
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 58a598b548fa..0eef8d1d88e6 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -191,12 +191,9 @@ static int nilfs_prepare_segment_lock(struct super_block *sb,
  * When @vacancy_check flag is set, this function will check the amount of
  * free space, and will wait for the GC to reclaim disk space if low capacity.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error code is returned.
- *
- * %-ENOMEM - Insufficient memory available.
- *
- * %-ENOSPC - No space left on device
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-ENOSPC	- No space left on device (if checking free space).
  */
 int nilfs_transaction_begin(struct super_block *sb,
 			    struct nilfs_transaction_info *ti,
@@ -2314,18 +2311,12 @@ static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err, bool force)
  * nilfs_construct_segment - construct a logical segment
  * @sb: super block
  *
- * Return Value: On success, 0 is returned. On errors, one of the following
- * negative error code is returned.
- *
- * %-EROFS - Read only filesystem.
- *
- * %-EIO - I/O error
- *
- * %-ENOSPC - No space left on device (only in a panic state).
- *
- * %-ERESTARTSYS - Interrupted.
- *
- * %-ENOMEM - Insufficient memory available.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO		- I/O error (including metadata corruption).
+ * * %-ENOMEM		- Insufficient memory available.
+ * * %-ENOSPC		- No space left on device (only in a panic state).
+ * * %-ERESTARTSYS	- Interrupted.
+ * * %-EROFS		- Read only filesystem.
  */
 int nilfs_construct_segment(struct super_block *sb)
 {
@@ -2349,18 +2340,12 @@ int nilfs_construct_segment(struct super_block *sb)
  * @start: start byte offset
  * @end: end byte offset (inclusive)
  *
- * Return Value: On success, 0 is returned. On errors, one of the following
- * negative error code is returned.
- *
- * %-EROFS - Read only filesystem.
- *
- * %-EIO - I/O error
- *
- * %-ENOSPC - No space left on device (only in a panic state).
- *
- * %-ERESTARTSYS - Interrupted.
- *
- * %-ENOMEM - Insufficient memory available.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO		- I/O error (including metadata corruption).
+ * * %-ENOMEM		- Insufficient memory available.
+ * * %-ENOSPC		- No space left on device (only in a panic state).
+ * * %-ERESTARTSYS	- Interrupted.
+ * * %-EROFS		- Read only filesystem.
  */
 int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 				  loff_t start, loff_t end)
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index ac03fd3c330c..1bcaf85506d3 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -49,8 +49,8 @@ void nilfs_set_last_segment(struct the_nilfs *nilfs,
  * alloc_nilfs - allocate a nilfs object
  * @sb: super block instance
  *
- * Return Value: On success, pointer to the_nilfs is returned.
- * On error, NULL is returned.
+ * Return: a pointer to the allocated nilfs object on success, or NULL on
+ * failure.
  */
 struct the_nilfs *alloc_nilfs(struct super_block *sb)
 {
@@ -200,8 +200,7 @@ static int nilfs_store_log_cursor(struct the_nilfs *nilfs,
  * exponent information written in @sbp and stores it in @blocksize,
  * or aborts with an error message if it's too large.
  *
- * Return Value: On success, 0 is returned. If the block size is too
- * large, -EINVAL is returned.
+ * Return: 0 on success, or %-EINVAL if the block size is too large.
  */
 static int nilfs_get_blocksize(struct super_block *sb,
 			       struct nilfs_super_block *sbp, int *blocksize)
@@ -538,7 +537,7 @@ static int nilfs_valid_sb(struct nilfs_super_block *sbp)
  * area, or if the parameters themselves are not normal, it is
  * determined to be invalid.
  *
- * Return Value: true if invalid, false if valid.
+ * Return: true if invalid, false if valid.
  */
 static bool nilfs_sb2_bad_offset(struct nilfs_super_block *sbp, u64 offset)
 {
@@ -684,8 +683,7 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
  * reading the super block, getting disk layout information, initializing
  * shared fields in the_nilfs).
  *
- * Return Value: On success, 0 is returned. On error, a negative error
- * code is returned.
+ * Return: 0 on success, or a negative error code on failure.
  */
 int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 {
-- 
2.43.0

