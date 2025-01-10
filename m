Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC081E0DDF;
	Fri, 10 Jan 2025 01:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736471241; cv=none; b=anQ+7ABU2TZjTdyayrzbSAHl7Ygwtc4M+L53UvQvXVf1x0oH7RMzYosMKD7N2cOE6JBHg9bPIa+6mmu7HhliSuyvBL4tlVzu6TMS43kKOYg3kjluclg0NLtz9WrQ4Zn1pHIkcKNFJYdo8V1zRg8cRgwzPRAClniOWKFR6xsts24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736471241; c=relaxed/simple;
	bh=Ol5aFL7nYAH5ScVbaWob6L/aDDgugl/X4d4FivlRLfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNaYNZKBvSSmpUikiENZgs33Oe5zUsJVVlcPB1O3gvUBJlwSrlqcA0pbaGIFJ9Z/ZPYZJ5JQ6Cr1cxtZEQpxuHls0d+z6gefIHKGL4LyEoQXLdqYD2RhaApNhXQvXcLGaL1k+DYt9VrInQr+JLAYnqF6/BASS8NtxzBCip3bDnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gZizAsZF; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gZizAsZF"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2161eb95317so23719355ad.1;
        Thu, 09 Jan 2025 17:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736471239; x=1737076039; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qE9bCvZVO2YRGAR2i+8snhjcm82HIoYnklQSubnjD1Y=;
        b=gZizAsZFDHClWS8WYfvzDYK1xZRH7paz0y900mY73IrFw1+2kE91oRAm9wASv9ahLM
         PCK3aeS6XI7Rc53bNORcuG04otaWt39GAATVGWdxnYC5UVMS9cuxPQfMqbuoRbt73M9a
         n2rhjtevfTsO460O2JuO195UeutQa+pb06nwHPiqu+5leUrUszIY80kRSNZJXVu02QYF
         GX1rGIgWYxc0gFlMEGt7LH7i1L7bSsYNlQsVKnSk3lV7Xx1J8SjldjqJjYytztb9Ib1L
         i4pH9MPVNIDQhcwm+wVfFt6HlWjsTxxdubq+Ag2AtL8i/MB/WsNjZ74VF9dBnPPG38Do
         t8yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736471239; x=1737076039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qE9bCvZVO2YRGAR2i+8snhjcm82HIoYnklQSubnjD1Y=;
        b=m18i0FLkrKSG0KUAJZj1QpmDd2gLIa9IdnYKEoVE0DO6JKTsnyxtYSR5wD65ndhZLk
         2JncaigLv/M1jYav1IP7uOreJ613jXt+dA7jJYpnrrdtq4vb9oXwp5P6eY5h7qXKqRz+
         FywUJJOFRyXKY+AAUxnlv7alJTegg+sNplxadjMQq0mCX4N2Tz5Pdiu7nOtF/AqpBOFF
         GfvLthL/LUWn1keVTtrnqez3t4ToLfIGNwW9YlXL7oSUyBockJRmNMtkoG5Y/tGFSAVP
         OD8G7/fm6+Ws3TbjPXvAYoM1DGiaJIofXi6MPtJz3867iyGFILwhF/+YAEPMMn0jHRrj
         Eu4Q==
X-Forwarded-Encrypted: i=1; AJvYcCVchN4Bq3lvTF0Y8+V9dlhteBuxw4GnQyi0QqrZBf9UDQMY2kanrDeqnFAMbswd50377sm0fYweqPDp4Fw=@vger.kernel.org, AJvYcCXEB+BGtTr/YnqFsRDWwdgUzDG+VOyfOaerVp5eUdEbDTaNIreqmvAWRFmdP6EGKK/4Q7W9wTBOXnHhvQ0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/D+ExR6lGBccchOPSza2H62JniL9puRHq9YE6JXUuoAMC517p
	imuj+Ftyf9zkI27uWjTiSTlpw8NaoKN+7TTDi98ozcI28IV16MSGFmcoxw==
X-Gm-Gg: ASbGncvn31ewYS4EByHMHuKOYYYIELdYsF5SjYBWwCt5APVwUQ0XxiRTeBexXyjUYA6
	BgW1USwrC1hrPc6OshwWOzugD2HaRa1PKWXtOtKMTpUoSjAGlitahWo+dL8xXTBi4mvcuYlXjVP
	iondmRq3qtIFeQNTZXwkFMeb3Ci6xczH9/DmZ4P6TUrs8S6hJeWgq3gpE7LbLto6PapzNe868gY
	P9pAE1A7EvFj8PzcLVa/nlLg6W0fn9Q3pPsKoJpsaXe93wr+P3UYhLUKieCRK62ORi7Urm5XGL1
	vXBI41log4aAjRWLQzkBFMzpA6k4
X-Google-Smtp-Source: AGHT+IGwSrXcwQnxAe+M1dqEKN9hw8l+JGkvH9Y4ARwEnjACLGXiUg67KUEU79X+YS28p+mp9a9uJg==
X-Received: by 2002:a17:902:d4c4:b0:215:5ea2:6543 with SMTP id d9443c01a7336-21a83f6400cmr135520795ad.28.1736471238630;
        Thu, 09 Jan 2025 17:07:18 -0800 (PST)
Received: from carrot.. (i114-186-237-30.s41.a014.ap.plala.or.jp. [114.186.237.30])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a31ddb9e4b4sm1862834a12.70.2025.01.09.17.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 17:07:17 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Brian G ." <gissf1@gmail.com>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH -v2 4/7] nilfs2: correct return value kernel-doc descriptions for metadata files
Date: Fri, 10 Jan 2025 10:01:47 +0900
Message-ID: <20250110010530.21872-5-konishi.ryusuke@gmail.com>
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
fixes the format of the return value descriptions for metadata file
functions other than sufile.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/cpfile.c | 51 ++++++++++++++++-----------------------
 fs/nilfs2/dat.c    | 40 +++++++++++++------------------
 fs/nilfs2/ifile.c  | 32 +++++++++++--------------
 fs/nilfs2/mdt.c    | 59 +++++++++++++++++++++-------------------------
 4 files changed, 77 insertions(+), 105 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index c20207d7a989..a1c0c09f61e2 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -191,14 +191,11 @@ static inline int nilfs_cpfile_get_checkpoint_block(struct inode *cpfile,
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- no block exists in the range.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_cpfile_find_checkpoint_block(struct inode *cpfile,
 					      __u64 start_cno, __u64 end_cno,
@@ -447,14 +444,11 @@ int nilfs_cpfile_finalize_checkpoint(struct inode *cpfile, __u64 cno,
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EINVAL	- Invalid checkpoints.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 				    __u64 start,
@@ -1058,14 +1052,11 @@ int nilfs_cpfile_is_snapshot(struct inode *cpfile, __u64 cno)
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- No such checkpoint.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_cpfile_change_cpmode(struct inode *cpfile, __u64 cno, int mode)
 {
@@ -1097,14 +1088,12 @@ int nilfs_cpfile_change_cpmode(struct inode *cpfile, __u64 cno, int mode)
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_cpfile_get_stat(struct inode *cpfile, struct nilfs_cpstat *cpstat)
 {
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index e220dcb08aa6..c57445e62298 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -302,14 +302,11 @@ int nilfs_dat_mark_dirty(struct inode *dat, __u64 vblocknr)
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- The virtual block number have not been allocated.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_dat_freev(struct inode *dat, __u64 *vblocknrs, size_t nitems)
 {
@@ -325,12 +322,10 @@ int nilfs_dat_freev(struct inode *dat, __u64 *vblocknrs, size_t nitems)
  * Description: nilfs_dat_move() changes the block number associated with
  * @vblocknr to @blocknr.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_dat_move(struct inode *dat, __u64 vblocknr, sector_t blocknr)
 {
@@ -390,17 +385,14 @@ int nilfs_dat_move(struct inode *dat, __u64 vblocknr, sector_t blocknr)
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- A block number associated with @vblocknr does not exist.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_dat_translate(struct inode *dat, __u64 vblocknr, sector_t *blocknrp)
 {
diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index e7339eb3c08a..bae9d7d9a424 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -38,17 +38,16 @@ static inline struct nilfs_ifile_info *NILFS_IFILE_I(struct inode *ifile)
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-ENOSPC	- No inode left.
  */
 int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
 			     struct buffer_head **out_bh)
@@ -83,14 +82,11 @@ int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- Inode number unallocated.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_ifile_delete_inode(struct inode *ifile, ino_t ino)
 {
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 965b5ad1c0df..3f7510beebbb 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -226,20 +226,21 @@ static int nilfs_mdt_read_block(struct inode *inode, unsigned long block,
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- The specified block does not exist (hole block).
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-EROFS	- Read only filesystem (for create mode).
  */
 int nilfs_mdt_get_block(struct inode *inode, unsigned long blkoff, int create,
 			void (*init_block)(struct inode *,
@@ -275,14 +276,11 @@ int nilfs_mdt_get_block(struct inode *inode, unsigned long blkoff, int create,
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- No block was found in the range.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_mdt_find_block(struct inode *inode, unsigned long start,
 			 unsigned long end, unsigned long *blkoff,
@@ -321,12 +319,11 @@ int nilfs_mdt_find_block(struct inode *inode, unsigned long start,
  * @inode: inode of the meta data file
  * @block: block offset
  *
- * Return Value: On success, zero is returned.
- * On error, one of the following negative error code is returned.
- *
- * %-ENOMEM - Insufficient memory available.
- *
- * %-EIO - I/O error
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- Non-existent block.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_mdt_delete_block(struct inode *inode, unsigned long block)
 {
@@ -349,12 +346,10 @@ int nilfs_mdt_delete_block(struct inode *inode, unsigned long block)
  * nilfs_mdt_forget_block() clears a dirty flag of the specified buffer, and
  * tries to release the page including the buffer from a page cache.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error code is returned.
- *
- * %-EBUSY - page has an active buffer.
- *
- * %-ENOENT - page cache has no page addressed by the offset.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EBUSY	- Page has an active buffer.
+ * * %-ENOENT	- Page cache has no page addressed by the offset.
  */
 int nilfs_mdt_forget_block(struct inode *inode, unsigned long block)
 {
-- 
2.43.0

