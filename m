Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CF81898EA;
	Thu,  9 Jan 2025 03:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736393306; cv=none; b=K3MyG13Q7Wvz0T8j7N4Y4kN96QGRPOAxUNwAZidLfrkO+S2Xj16Q0kKHavyf6ZcWsnhAVf6zMJQZfgW4SFWnAIxOintdOVx+ag7QdvncuXoQqR8ld2WW7c7CD84G62MAW6iQLpHKQMbujzJ33x4ty5+9x7dzKBgPmLo25bCcWhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736393306; c=relaxed/simple;
	bh=V2bDMpH577fvk1ErBDdIJWu6KPtaFnenyKBoXZpaUHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qa+nB3Vp1TGTX1l3/G8exdKy9xbBchWx76AvMZ24XBuNq6gLb+zKXBL9D6AL/7Pyuqa5iU9HJz+zYC7rRPKCNkslOvwwTUJeJyJyan51qH1eyYxYlCKFORoj8iog1WVST/EGJKu4sKbz7dQibWj3REgIKZgXBRS48kHD1TfUBGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KwdX3EUp; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KwdX3EUp"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2ee86a1a92dso672188a91.1;
        Wed, 08 Jan 2025 19:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736393304; x=1736998104; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3VDl1xVCrvkEU4rkIcrxCMpEj6sIDtXziLLH3X845Do=;
        b=KwdX3EUpBmkflJOiryP0wpLk09HO40uR4TofB8vi3dd7FagAZTbCKxzunhzoUIBeTo
         i71Wh0v6eov6MrndUKxTv2D5c34CJOwyK8wTUX5a1UKPoIs4oWThTk03irRColcxFsLb
         dA5RV4brjbxXnIvHvn385sjXQlEqjtanYmn1Qwvzk7nJfweSxZgOO82Lo1OjU3Ado70S
         OWJ/EoY2JL6quOn7Bg7pf4q6dHO2ww8Yh6XOaE6p6xjUuAVaEKE8Clgc9ROdZ8iK2HTE
         9eKBSIGyY0P3M31LFBVIhHsqcdE3rOML8HEAfKhTP9OBqkMnwG/9S4hL0/zVmc0DVwZH
         11HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736393304; x=1736998104;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3VDl1xVCrvkEU4rkIcrxCMpEj6sIDtXziLLH3X845Do=;
        b=aesbdpyQzO80Kh34FcInGHyvs9KOY+5gTHMvoWMnsTHFYIRZZaBfT0Sq1j0bJe5ulP
         OjtAn2FSvLcOFPYcXCtzikd/LQ8y1jtES40kocVTzUbzk/tluhd1CcSgyegCcsBCA/kL
         5FM275IoZjXlQyIe560psYhnIRzc9J5FCCup71F67hHXbd6q1EBXmvImdKAoW0ckFiBI
         ueZS/ta/hSs7CCYPjis8lYhZMpxmqIE3sBw/jwtx5D0j4IlVuvXRWrTm7I/dOReXxz7p
         Ljx+L/sBxY5KAfS2ETicptjemiJ+7xXMr4kT7j2TVE5+yKe41Arvq1uRg1qbJUbn78li
         ZCBw==
X-Forwarded-Encrypted: i=1; AJvYcCVE6wY/8TpbZ8yFfKoF2YviEy5SuTYcTI5oojiBy11tgbN4wXIaS9uqS1pqjYwLMz3c0yAhjAHZGGl+/1Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzuSpNGKALvbPieg71xRCu6FR7WkK+diJcIGebhoqsXrpBWf6P1
	CJ0GvtOmGee5usfxB+WquuaP7nWDu8uNBGozo1W2x41V5PtFz3XxRcPHjA==
X-Gm-Gg: ASbGncveyExEok0f51fhI1EGFYSFRNo47zfV4mUQjf+mkP36F2c8sV18+3isvMKbzDj
	F27HXYdf5s0JGLdQH2VJZBB24JlT2k0Ie6kW81dNkV6n0sx/tz6BTPjygQ/b7EaCCBj+MEBHENZ
	vi2AUedpiTBGv2lU7SW1/sCcjVGrQOiHs6jCM2vIT30BPtv6IKH6IMoj94v+iKNvPjQaBekeIRz
	8TYYI0IyiE6qEWWBtoNH4FEzxZCeJa/CJBxQ6vtvqlKqr4WrG2AxoO9xAD4GPmqk3sAWXdcojFP
	VY+ouWR85YpCOg4ObhNO8AOGTEGL
X-Google-Smtp-Source: AGHT+IE1W9vlv5cTDvfKfPE2MmjcO5HX4XHFpMNeB8GE2t8QIGrwsyKSkCgTWqqWj4E5HxK0kqnUxg==
X-Received: by 2002:a17:90b:3a0e:b0:2ee:e113:815d with SMTP id 98e67ed59e1d1-2f548e98373mr8364022a91.8.1736393303390;
        Wed, 08 Jan 2025 19:28:23 -0800 (PST)
Received: from carrot.. (i114-186-237-30.s41.a014.ap.plala.or.jp. [114.186.237.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f55942eed5sm194963a91.27.2025.01.08.19.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 19:28:22 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] nilfs2: correct return value kernel-doc descriptions for metadata files
Date: Thu,  9 Jan 2025 12:23:23 +0900
Message-ID: <20250109032846.10147-5-konishi.ryusuke@gmail.com>
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
fixes the format of the return value descriptions for metadata file
functions other than sufile.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/cpfile.c | 47 ++++++++++++++-------------------------
 fs/nilfs2/dat.c    | 37 +++++++++++--------------------
 fs/nilfs2/ifile.c  | 30 ++++++++++---------------
 fs/nilfs2/mdt.c    | 55 +++++++++++++++++++---------------------------
 4 files changed, 64 insertions(+), 105 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index c20207d7a989..6fb9a8743fe2 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -191,14 +191,10 @@ static inline int nilfs_cpfile_get_checkpoint_block(struct inode *cpfile,
  * @cnop: place to store the next checkpoint number
  * @bhp: place to store a pointer to buffer_head struct
  *
- * Return Value: On success, it returns 0. On error, the following negative
- * error code is returned.
- *
- * %-ENOMEM - Insufficient memory available.
- *
- * %-EIO - I/O error
- *
- * %-ENOENT - no block exists in the range.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- no block exists in the range.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_cpfile_find_checkpoint_block(struct inode *cpfile,
 					      __u64 start_cno, __u64 end_cno,
@@ -447,14 +443,10 @@ int nilfs_cpfile_finalize_checkpoint(struct inode *cpfile, __u64 cno,
  * the period from @start to @end, excluding @end itself. The checkpoints
  * which have been already deleted are ignored.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-EINVAL - invalid checkpoints.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EINVAL	- Invalid checkpoints.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 				    __u64 start,
@@ -1058,14 +1050,10 @@ int nilfs_cpfile_is_snapshot(struct inode *cpfile, __u64 cno)
  * Description: nilfs_change_cpmode() changes the mode of the checkpoint
  * specified by @cno. The mode @mode is NILFS_CHECKPOINT or NILFS_SNAPSHOT.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - No such checkpoint.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- No such checkpoint.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_cpfile_change_cpmode(struct inode *cpfile, __u64 cno, int mode)
 {
@@ -1097,14 +1085,11 @@ int nilfs_cpfile_change_cpmode(struct inode *cpfile, __u64 cno, int mode)
  * @cpstat: pointer to a structure of checkpoint statistics
  *
  * Description: nilfs_cpfile_get_stat() returns information about checkpoints.
+ * The checkpoint statistics are stored in the location pointed to by @cpstat.
  *
- * Return Value: On success, 0 is returned, and checkpoints information is
- * stored in the place pointed by @cpstat. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_cpfile_get_stat(struct inode *cpfile, struct nilfs_cpstat *cpstat)
 {
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index e220dcb08aa6..fc5dd28e7baa 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -302,14 +302,10 @@ int nilfs_dat_mark_dirty(struct inode *dat, __u64 vblocknr)
  * Description: nilfs_dat_freev() frees the virtual block numbers specified by
  * @vblocknrs and @nitems.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - The virtual block number have not been allocated.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- The virtual block number have not been allocated.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_dat_freev(struct inode *dat, __u64 *vblocknrs, size_t nitems)
 {
@@ -325,12 +321,9 @@ int nilfs_dat_freev(struct inode *dat, __u64 *vblocknrs, size_t nitems)
  * Description: nilfs_dat_move() changes the block number associated with
  * @vblocknr to @blocknr.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_dat_move(struct inode *dat, __u64 vblocknr, sector_t blocknr)
 {
@@ -390,17 +383,13 @@ int nilfs_dat_move(struct inode *dat, __u64 vblocknr, sector_t blocknr)
  * @blocknrp: pointer to a block number
  *
  * Description: nilfs_dat_translate() maps the virtual block number @vblocknr
- * to the corresponding block number.
- *
- * Return Value: On success, 0 is returned and the block number associated
- * with @vblocknr is stored in the place pointed by @blocknrp. On error, one
- * of the following negative error codes is returned.
- *
- * %-EIO - I/O error.
+ * to the corresponding block number.  The block number associated with
+ * @vblocknr is stored in the place pointed to by @blocknrp.
  *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - A block number associated with @vblocknr does not exist.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- A block number associated with @vblocknr does not exist.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_dat_translate(struct inode *dat, __u64 vblocknr, sector_t *blocknrp)
 {
diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index e7339eb3c08a..cd38ba05a655 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -38,17 +38,15 @@ static inline struct nilfs_ifile_info *NILFS_IFILE_I(struct inode *ifile)
  * @out_ino: pointer to a variable to store inode number
  * @out_bh: buffer_head contains newly allocated disk inode
  *
- * Return Value: On success, 0 is returned and the newly allocated inode
- * number is stored in the place pointed by @ino, and buffer_head pointer
- * that contains newly allocated disk inode structure is stored in the
- * place pointed by @out_bh
- * On error, one of the following negative error codes is returned.
+ * nilfs_ifile_create_inode() allocates a new inode in the ifile metadata
+ * file and stores the inode number in the variable pointed to by @out_ino,
+ * as well as storing the ifile's buffer with the disk inode in the location
+ * pointed to by @out_bh.
  *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOSPC - No inode left.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-ENOSPC	- No inode left.
  */
 int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
 			     struct buffer_head **out_bh)
@@ -83,14 +81,10 @@ int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
  * @ifile: ifile inode
  * @ino: inode number
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - The inode number @ino have not been allocated.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- Inode number unallocated.
  */
 int nilfs_ifile_delete_inode(struct inode *ifile, ino_t ino)
 {
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 965b5ad1c0df..06bc534c7dbe 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -226,20 +226,20 @@ static int nilfs_mdt_read_block(struct inode *inode, unsigned long block,
  * @out_bh: output of a pointer to the buffer_head
  *
  * nilfs_mdt_get_block() looks up the specified buffer and tries to create
- * a new buffer if @create is not zero.  On success, the returned buffer is
- * assured to be either existing or formatted using a buffer lock on success.
- * @out_bh is substituted only when zero is returned.
+ * a new buffer if @create is not zero.  If (and only if) this function
+ * succeeds, it stores a pointer to the retrieved buffer head in the location
+ * pointed to by @out_bh.
  *
- * Return Value: On success, it returns 0. On error, the following negative
- * error code is returned.
+ * The retrieved buffer may be either an existing one or a newly allocated one.
+ * For a newly created buffer, if the callback function argument @init_block
+ * is non-NULL, the callback will be called with the buffer locked to format
+ * the block.
  *
- * %-ENOMEM - Insufficient memory available.
- *
- * %-EIO - I/O error
- *
- * %-ENOENT - the specified block does not exist (hole block)
- *
- * %-EROFS - Read only filesystem (for create mode)
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- The specified block does not exist (hole block).
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-EROFS	- Read only filesystem (for create mode).
  */
 int nilfs_mdt_get_block(struct inode *inode, unsigned long blkoff, int create,
 			void (*init_block)(struct inode *,
@@ -275,14 +275,10 @@ int nilfs_mdt_get_block(struct inode *inode, unsigned long blkoff, int create,
  * @out_bh, and block offset to @blkoff, respectively.  @out_bh and
  * @blkoff are substituted only when zero is returned.
  *
- * Return Value: On success, it returns 0. On error, the following negative
- * error code is returned.
- *
- * %-ENOMEM - Insufficient memory available.
- *
- * %-EIO - I/O error
- *
- * %-ENOENT - no block was found in the range
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- No block was found in the range.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_mdt_find_block(struct inode *inode, unsigned long start,
 			 unsigned long end, unsigned long *blkoff,
@@ -321,12 +317,10 @@ int nilfs_mdt_find_block(struct inode *inode, unsigned long start,
  * @inode: inode of the meta data file
  * @block: block offset
  *
- * Return Value: On success, zero is returned.
- * On error, one of the following negative error code is returned.
- *
- * %-ENOMEM - Insufficient memory available.
- *
- * %-EIO - I/O error
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- Non-existent block.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_mdt_delete_block(struct inode *inode, unsigned long block)
 {
@@ -349,12 +343,9 @@ int nilfs_mdt_delete_block(struct inode *inode, unsigned long block)
  * nilfs_mdt_forget_block() clears a dirty flag of the specified buffer, and
  * tries to release the page including the buffer from a page cache.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error code is returned.
- *
- * %-EBUSY - page has an active buffer.
- *
- * %-ENOENT - page cache has no page addressed by the offset.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EBUSY	- Page has an active buffer.
+ * * %-ENOENT	- Page cache has no page addressed by the offset.
  */
 int nilfs_mdt_forget_block(struct inode *inode, unsigned long block)
 {
-- 
2.43.0

