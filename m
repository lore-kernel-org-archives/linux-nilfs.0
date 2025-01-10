Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB851E25EC;
	Fri, 10 Jan 2025 01:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736471244; cv=none; b=V8Up7ptbccWxE3uM2Lpt6F4DyKf0yw16AYf4Af5Qa15f0YPcsEX3tnH+EMTeX+74g4/x8aTc52dW+xuqx/zcuYTiByO1VDFLL2lME1w7TbqU+giBsskXnXyT/gCQBR+wWbqVWZ9/2oAf4NvvKH72KzZJgHT1HTJA8foipmKqVwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736471244; c=relaxed/simple;
	bh=9wgSD72beH9k4Wr2RI8EFHjoo66MDpxNP7vtH+flAnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MeK8XTgKIcrLdoPGQ/lNQKT7BGTZogn6CJdBV9zybh3tBOIp/Coqf4o7D/AoBlsXIBmYoo5y3E30x/wN/1oxcinJS+XTFJJRjA1ItzHeU0a29Sne6WJTzIeiP4VQOkRpW55TG/eQEEcryvcnoGirgK4jY+fB7z+97s5tSbOz1p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AzvOC/9k; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AzvOC/9k"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2163dc5155fso26620925ad.0;
        Thu, 09 Jan 2025 17:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736471242; x=1737076042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vmPIVwpPEU0+VbvWkCG1xMY5UES1bgxyCYL77VStE1k=;
        b=AzvOC/9kafwRuzGMyctU3I/+V0W7eLAoedYtl4N08ZKrY6Lt6E/ZsBnvJzMd2jLe0g
         T4fnWEihOLQd6Z8UxktP2Dbv2uhey+RgQFoNZTCSCeaxE5SHfsX6sOQpIytMLm6v2zcQ
         X9oJfvcp4tlo8zrS78v8L1ckS2Mfupebt4hMaCn3bQNSltOg4KTpOF1Sp+YwP0waEFOt
         P8iiuTL+Z50p/PhchhMTarnGO6Qqei1iergAsHU8tC7aDGjryZEjfOx3tBvfG34BMbDA
         hiG05ijOgLCAa2YFZgVf5dEC4jFLjpClhDSl5NXn/OIl3Lzk8YnFqGhyklF2VhakOFm7
         BqIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736471242; x=1737076042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vmPIVwpPEU0+VbvWkCG1xMY5UES1bgxyCYL77VStE1k=;
        b=MORt9ivKQnAWEmo3bJ5WU1YnKhZe8irEQ0/nWz0K/CRbGtwiMDzs/hMxtQ4YuzQN/M
         GT6HVQ4X32ydauun1W2nw/a2FfJ6zqno8+Name1KGOmmEppZeXaCr0Rm6pW88tnes46H
         PJnZwWjwSpiWuYCJFLJJIGrEELe7iXPwB+NtobDOmA5m9MEfGW4xP36gNVlQv4W9Mpzc
         KFzNCQEEXCXS0genavGw5IizzIz9sOb5obVEJwXu0PMpyho659AZjZKJ/pMWfpZoWhNM
         hnmAoJgclIl48CKHyL0AZTxCeZvMUptIl4DV3XfvA0d2d5/BoEjOVp1MfSyLdL/XC5HJ
         Rz8Q==
X-Forwarded-Encrypted: i=1; AJvYcCV45PDuqAPi4M9CC0jAgSykv9V048IrfbolDYEcIx6TRuZSBtoL4W2Dt+lMjLhR3lfQWVhWfK0sCSOwEhs=@vger.kernel.org, AJvYcCVLNgrRNQKBIww3IYiQr61x1gtzX239Dd+G72XV2vrhmXr9xxIrvEilKeKX05RlJmUndJeFuU+ARWhZ+Eo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbZHS9jX/2Ag/RLAAYGtax8NIpiV42yJmCMZzQ/zlzMMMX2yTw
	Lh9v6uZwANTMXceDm1sdynsDobK5G8RkqIPuUASBc0NxI0jBtMUB
X-Gm-Gg: ASbGncuvCiR73RvVgy9khJiTclSG8Ki7w3OC1hha01rLgiH8yfnk1EXbEg76hwTMe3t
	PZIjXezIhaZOqfBKXGoE2r2lzI5pPVuJt8x7wzUNlprFZ2KOwtbc//imKj/yD1LlUHIynggqI9E
	ZBLiy3YUBA+cFfsuFXUslQQWgtQBOphlDVRmxX2CpC6XOHl07Fj10frtqgPR2LSMe+BEcsa0Z7J
	P7ofP/nRcu8/9OMl0cDYwMPxfGeK2DMxpx4zOcxWG8kdROQ7ahw82HzZCexnujZz5ndVDMPzCp3
	hbUMnEZYUgI9u/3/RkT4S4/6VLJZ
X-Google-Smtp-Source: AGHT+IF7rWgG64Y9OUcdizPaYuwCOruANhUmMYVnfX8JmiWLBCVqTfubT1QYJwrxQPjESCGiljM0dQ==
X-Received: by 2002:a17:902:e545:b0:219:e4b0:4286 with SMTP id d9443c01a7336-21a83f7293bmr131671285ad.29.1736471241540;
        Thu, 09 Jan 2025 17:07:21 -0800 (PST)
Received: from carrot.. (i114-186-237-30.s41.a014.ap.plala.or.jp. [114.186.237.30])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a31ddb9e4b4sm1862834a12.70.2025.01.09.17.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 17:07:20 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Brian G ." <gissf1@gmail.com>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH -v2 5/7] nilfs2: correct return value kernel-doc descriptions for the rest
Date: Fri, 10 Jan 2025 10:01:48 +0900
Message-ID: <20250110010530.21872-6-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250110010530.21872-1-konishi.ryusuke@gmail.com>
References: <CAKFNMoksY6f5NtVwmn6K0K2QKTvdjq+s0FbdgLvHzS3YueKqYQ@mail.gmail.com>
 <20250110010530.21872-1-konishi.ryusuke@gmail.com>
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
 fs/nilfs2/gcinode.c   | 24 +++++++++-------------
 fs/nilfs2/inode.c     | 12 +++--------
 fs/nilfs2/recovery.c  | 32 +++++++++++------------------
 fs/nilfs2/segbuf.c    | 12 ++---------
 fs/nilfs2/segment.c   | 48 ++++++++++++++++---------------------------
 fs/nilfs2/the_nilfs.c | 12 +++++------
 6 files changed, 50 insertions(+), 90 deletions(-)

diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 2dbb15767df1..561c220799c7 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -46,14 +46,11 @@
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- The block specified with @pbn does not exist.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
 				   sector_t pbn, __u64 vbn,
@@ -114,12 +111,11 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
  * specified by @vbn to the GC pagecache.  @pbn can be supplied by the
  * caller to avoid translation of the disk block address.
  *
- * Return Value: On success, 0 is returned. On Error, one of the following
- * negative error code is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
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
index e43405bf521e..4063f084e75d 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -754,18 +754,13 @@ static void nilfs_abort_roll_forward(struct the_nilfs *nilfs)
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EINVAL		- Inconsistent filesystem state.
+ * * %-EIO		- I/O error.
+ * * %-ENOMEM		- Insufficient memory available.
+ * * %-ENOSPC		- No space left on device (only in a panic state).
+ * * %-ERESTARTSYS	- Interrupted.
  */
 int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
 			      struct super_block *sb,
@@ -830,14 +825,11 @@ int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
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
index 58a598b548fa..05c24b971464 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -191,12 +191,10 @@ static int nilfs_prepare_segment_lock(struct super_block *sb,
  * When @vacancy_check flag is set, this function will check the amount of
  * free space, and will wait for the GC to reclaim disk space if low capacity.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error code is returned.
- *
- * %-ENOMEM - Insufficient memory available.
- *
- * %-ENOSPC - No space left on device
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-ENOSPC	- No space left on device (if checking free space).
  */
 int nilfs_transaction_begin(struct super_block *sb,
 			    struct nilfs_transaction_info *ti,
@@ -2314,18 +2312,13 @@ static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err, bool force)
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO		- I/O error (including metadata corruption).
+ * * %-ENOMEM		- Insufficient memory available.
+ * * %-ENOSPC		- No space left on device (only in a panic state).
+ * * %-ERESTARTSYS	- Interrupted.
+ * * %-EROFS		- Read only filesystem.
  */
 int nilfs_construct_segment(struct super_block *sb)
 {
@@ -2349,18 +2342,13 @@ int nilfs_construct_segment(struct super_block *sb)
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
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

