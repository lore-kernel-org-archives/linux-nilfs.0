Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499BA13D24D;
	Thu,  9 Jan 2025 03:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736393299; cv=none; b=ZwjwAjb3XPWNix22k4DKyhiJjQDQJsGA1yBhYBUkgG0+ysYFIKRoSXRpAO/Xf9lKgEmi6CzXv5PsT0fgvrF6Zwe4BbuKXHCWUzXwASh0yC01hoPDbSAlf83nx+m1hhPMZAQiGLlf8RSXc4wG4u4FX+uLQbDxeXaUnKMalQBcbyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736393299; c=relaxed/simple;
	bh=ryDfTMcbW522a/WW7Y4bzB7bwiIx2ByuYW/fQLQaj1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwscTjtETqJ8mMpNUIDCFvEtSuK6BIWx8FQiC7WyLkHHTsvZU1AgYMoKDwKJIHBEsnijbUWdjOBpCAtNVK2NANHrMRwOT5j2jtRQ5JPiByb5eacN+1Lkthulh0D10QR9MrLCupDNaDwJa0z4v3jjG6B3W55OPlSZPjoj5QXLKJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nEoF3E8C; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nEoF3E8C"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2ee74291415so646582a91.3;
        Wed, 08 Jan 2025 19:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736393296; x=1736998096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Akx0QHC5lpOEidPKLbiXZnArP0eNdRdOGsJ9JWNfnX8=;
        b=nEoF3E8ChWq6TESpLtg9FkgP09vhUsvDJ2SR91078OeDtFlhjQkN73kWsXB8X+MvDh
         xjpWZB8lWu1srB2HLSfQXrKBREBrG7Dy5nGM6/pK/4ryQHYFFYiZYaH/9YBVc3Sp84Nt
         7acjNJ4IjGBzQX683jWtDYAeKbFTeCP7UVvOz6UvnMbcrPkhcH1zutbgM7VY1VlYpnFA
         j48I0dnRiW1T17bg3MvPt9orb15FRv8pXMt8ew+tmBikXWr1hNZBwYiry4doWoQvh8Y0
         r5L3WF8zgema3Zblg2LQ1nw7D3C/UZjtIeKU5rY72NLQV2iIMGMtnKA0iYIlH9uU/HLw
         1coA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736393296; x=1736998096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Akx0QHC5lpOEidPKLbiXZnArP0eNdRdOGsJ9JWNfnX8=;
        b=JLwyIbP6KkaDY7bqNusuTOQCyKNFbdQxSCm+kBM1rctH7P9rt8+G6G/eeyhuKEizKP
         BTYcbyjiSnFVID6mrs9p0EsIiHV8XuIr/Vkw4ig6Nd6KHwFXJbOcOu6QCMamVpiVpvYq
         fq40maHu/Wks03FdMJdms6eJcpqYidHbatZTQGOjA8kRcbEH/i/IMZpwPoMm4up07jll
         uTFcGw1rnrIQXnAxo9aSC5AjnZGCvZCoqTrx5aMNC4HM/wr2yyfULJPrgp96cgGQMrUd
         W01Ubf1LhDidrhb0rwbVIntX7S17l47D9z9maF3v6/47OVjh5tp9nz+PbgSNPl4Fytgj
         GDpw==
X-Forwarded-Encrypted: i=1; AJvYcCWqnTw1ahAdDaNSSFu+NEPErIul4wel593S0bEYBexzgKQawSmLUyjTOw/j0vn+aioD9nQVhrOInfgMSLM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwMG5Z8Her9PaBGOC4Xs2LHHz+cuSMeBloyrZFqHCBkF+cBHAH
	Qp2njk7TGZreDgUIAv45ljggK9CFr/+rln/WmNp+/SKEM2MVq6NbV/iRRA==
X-Gm-Gg: ASbGnctAJ6NahqjZ+OtcRbfu5dfvTYKFcLROkdJ5owrA+xJfUK+k4onUqv4QKVqf1E9
	ogOkOMexQ26lN2GtsjyhIA+XqBGhKAstRPOtLNIr78Deo3ZEgckCS9AFYXMI4LYA6OTlmmYv4jC
	SQzkTb6SmFAJk90Lc9V5BJ5Us1lt2gxaMl9eQ0h3vJsNB+3KZtQlZDtqaDKQkwLROMGJOp6gMYy
	Qk7Lq9nMVlMMW4BcoRymiQwbDgWVT7wR7dXwLKylqMLYbiUaH4FLp1n/rFyOqr+iSXfcvvkMwq7
	2VNhi9uLM206EVfPdQXymX8X7Y/H
X-Google-Smtp-Source: AGHT+IECVmz7MNyKEPlVrkw4GzVJVhSsGQYRJYp9ro0iLFl4zVoTPROaBnirVW1SZHx7OOKUeS4W7Q==
X-Received: by 2002:a17:90b:37ce:b0:2ee:dd9b:e3e8 with SMTP id 98e67ed59e1d1-2f548ea5390mr8429718a91.8.1736393296002;
        Wed, 08 Jan 2025 19:28:16 -0800 (PST)
Received: from carrot.. (i114-186-237-30.s41.a014.ap.plala.or.jp. [114.186.237.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f55942eed5sm194963a91.27.2025.01.08.19.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 19:28:15 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] nilfs2: correct return value kernel-doc descriptions for ioctl functions
Date: Thu,  9 Jan 2025 12:23:20 +0900
Message-ID: <20250109032846.10147-2-konishi.ryusuke@gmail.com>
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

In the kernel-doc comments for functions, there are many cases where
the format of the return value description is inaccurate, such as
"Return Value: ...", which causes many warnings to be output when the
kernel-doc script is executed with the "-Wall" option.

This fixes such incorrectly formatted return value descriptions for
ioctl functions.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/ioctl.c | 220 ++++++++++++++++++----------------------------
 1 file changed, 84 insertions(+), 136 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index fa77f78df681..f7bcc95847bb 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -33,17 +33,13 @@
  * @dofunc: concrete function of get/set metadata info
  *
  * Description: nilfs_ioctl_wrap_copy() gets/sets metadata info by means of
- * calling dofunc() function on the basis of @argv argument.
+ * calling dofunc() function on the basis of @argv argument.  If successful,
+ * the requested metadata information is copied to userspace memory.
  *
- * Return Value: On success, 0 is returned and requested metadata info
- * is copied into userspace. On error, one of the following
- * negative error codes is returned.
- *
- * %-EINVAL - Invalid arguments from userspace.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-EFAULT - Failure during execution of requested operation.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EFAULT	- Failure during execution of requested operation.
+ * * %-EINVAL	- Invalid arguments from userspace.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 				 struct nilfs_argv *argv, int dir,
@@ -190,13 +186,9 @@ static int nilfs_ioctl_getversion(struct inode *inode, void __user *argp)
  * given checkpoint between checkpoint and snapshot state. This ioctl
  * is used in chcp and mkcp utilities.
  *
- * Return Value: On success, 0 is returned and mode of a checkpoint is
- * changed. On error, one of the following negative error codes
- * is returned.
- *
- * %-EPERM - Operation not permitted.
- *
- * %-EFAULT - Failure during checkpoint mode changing.
+ * Return: 0 on success, or the following negative error code on failure.
+ * %-EFAULT	- Failure during checkpoint mode changing.
+ * %-EPERM	- Operation not permitted.
  */
 static int nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
 				     unsigned int cmd, void __user *argp)
@@ -244,13 +236,9 @@ static int nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
  * checkpoint from NILFS2 file system. This ioctl is used in rmcp
  * utility.
  *
- * Return Value: On success, 0 is returned and a checkpoint is
- * removed. On error, one of the following negative error codes
- * is returned.
- *
- * %-EPERM - Operation not permitted.
- *
- * %-EFAULT - Failure during checkpoint removing.
+ * Return: 0 on success, or the following negative error code on failure.
+ * %-EFAULT	- Failure during checkpoint removing.
+ * %-EPERM	- Operation not permitted.
  */
 static int
 nilfs_ioctl_delete_checkpoint(struct inode *inode, struct file *filp,
@@ -296,7 +284,7 @@ nilfs_ioctl_delete_checkpoint(struct inode *inode, struct file *filp,
  * requested checkpoints. The NILFS_IOCTL_GET_CPINFO ioctl is used in
  * lscp utility and by nilfs_cleanerd daemon.
  *
- * Return value: count of nilfs_cpinfo structures in output buffer.
+ * Return: count of nilfs_cpinfo structures in output buffer.
  */
 static ssize_t
 nilfs_ioctl_do_get_cpinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
@@ -320,17 +308,13 @@ nilfs_ioctl_do_get_cpinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
  *
  * Description: nilfs_ioctl_get_cpstat() returns information about checkpoints.
  * The NILFS_IOCTL_GET_CPSTAT ioctl is used by lscp, rmcp utilities
- * and by nilfs_cleanerd daemon.
- *
- * Return Value: On success, 0 is returned, and checkpoints information is
- * copied into userspace pointer @argp. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
+ * and by nilfs_cleanerd daemon.  The checkpoint statistics are copied to
+ * the userspace memory pointed to by @argp.
  *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-EFAULT - Failure during getting checkpoints statistics.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EFAULT	- Failure during getting checkpoints statistics.
+ * * %-EIO	- I/O error.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_ioctl_get_cpstat(struct inode *inode, struct file *filp,
 				  unsigned int cmd, void __user *argp)
@@ -363,7 +347,8 @@ static int nilfs_ioctl_get_cpstat(struct inode *inode, struct file *filp,
  * info about requested segments. The NILFS_IOCTL_GET_SUINFO ioctl is used
  * in lssu, nilfs_resize utilities and by nilfs_cleanerd daemon.
  *
- * Return value: count of nilfs_suinfo structures in output buffer.
+ * Return: Count of nilfs_suinfo structures in output buffer on success,
+ * or a negative error code on failure.
  */
 static ssize_t
 nilfs_ioctl_do_get_suinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
@@ -387,17 +372,13 @@ nilfs_ioctl_do_get_suinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
  *
  * Description: nilfs_ioctl_get_sustat() returns segment usage statistics.
  * The NILFS_IOCTL_GET_SUSTAT ioctl is used in lssu, nilfs_resize utilities
- * and by nilfs_cleanerd daemon.
- *
- * Return Value: On success, 0 is returned, and segment usage information is
- * copied into userspace pointer @argp. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * and by nilfs_cleanerd daemon.  The requested segment usage information is
+ * copied to the userspace memory pointed to by @argp.
  *
- * %-EFAULT - Failure during getting segment usage statistics.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EFAULT	- Failure during getting segment usage statistics.
+ * * %-EIO	- I/O error.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_ioctl_get_sustat(struct inode *inode, struct file *filp,
 				  unsigned int cmd, void __user *argp)
@@ -430,7 +411,8 @@ static int nilfs_ioctl_get_sustat(struct inode *inode, struct file *filp,
  * on virtual block addresses. The NILFS_IOCTL_GET_VINFO ioctl is used
  * by nilfs_cleanerd daemon.
  *
- * Return value: count of nilfs_vinfo structures in output buffer.
+ * Return: Count of nilfs_vinfo structures in output buffer on success, or
+ * a negative error code on failure.
  */
 static ssize_t
 nilfs_ioctl_do_get_vinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
@@ -457,7 +439,8 @@ nilfs_ioctl_do_get_vinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
  * about descriptors of disk block numbers. The NILFS_IOCTL_GET_BDESCS ioctl
  * is used by nilfs_cleanerd daemon.
  *
- * Return value: count of nilfs_bdescs structures in output buffer.
+ * Return: Count of nilfs_bdescs structures in output buffer on succes, or
+ * a negative error code on failure.
  */
 static ssize_t
 nilfs_ioctl_do_get_bdescs(struct the_nilfs *nilfs, __u64 *posp, int flags,
@@ -494,19 +477,14 @@ nilfs_ioctl_do_get_bdescs(struct the_nilfs *nilfs, __u64 *posp, int flags,
  *
  * Description: nilfs_ioctl_do_get_bdescs() function returns information
  * about descriptors of disk block numbers. The NILFS_IOCTL_GET_BDESCS ioctl
- * is used by nilfs_cleanerd daemon.
- *
- * Return Value: On success, 0 is returned, and disk block descriptors are
- * copied into userspace pointer @argp. On error, one of the following
- * negative error codes is returned.
- *
- * %-EINVAL - Invalid arguments from userspace.
+ * is used by nilfs_cleanerd daemon.  If successful, disk block descriptors
+ * are copied to userspace pointer @argp.
  *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-EFAULT - Failure during getting disk block descriptors.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EFAULT	- Failure during getting dick block descriptors.
+ * * %-EINVAL	- Invalid arguments from userspace.
+ * * %-EIO	- I/O error.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_ioctl_get_bdescs(struct inode *inode, struct file *filp,
 				  unsigned int cmd, void __user *argp)
@@ -540,16 +518,11 @@ static int nilfs_ioctl_get_bdescs(struct inode *inode, struct file *filp,
  * Description: nilfs_ioctl_move_inode_block() function registers data/node
  * buffer in the GC pagecache and submit read request.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - Requested block doesn't exist.
- *
- * %-EEXIST - Blocks conflict is detected.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EEXIST	- Block conflict detected.
+ * * %-EIO	- I/O error.
+ * * %-ENOENT	- Requested block doesn't exist.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_ioctl_move_inode_block(struct inode *inode,
 					struct nilfs_vdesc *vdesc,
@@ -604,8 +577,8 @@ static int nilfs_ioctl_move_inode_block(struct inode *inode,
  * blocks that garbage collector specified with the array of nilfs_vdesc
  * structures and stores them into page caches of GC inodes.
  *
- * Return Value: Number of processed nilfs_vdesc structures or
- * error code, otherwise.
+ * Return: Number of processed nilfs_vdesc structures on success, or
+ * a negative error code on failure.
  */
 static int nilfs_ioctl_move_blocks(struct super_block *sb,
 				   struct nilfs_argv *argv, void *buf)
@@ -682,14 +655,11 @@ static int nilfs_ioctl_move_blocks(struct super_block *sb,
  * in the period from p_start to p_end, excluding p_end itself. The checkpoints
  * which have been already deleted are ignored.
  *
- * Return Value: Number of processed nilfs_period structures or
- * error code, otherwise.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-EINVAL - invalid checkpoints.
+ * Return: Number of processed nilfs_period structures on success, or the
+ * following negative error code on failure.
+ * * %-EINVAL	- invalid checkpoints.
+ * * %-EIO	- I/O error.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_ioctl_delete_checkpoints(struct the_nilfs *nilfs,
 					  struct nilfs_argv *argv, void *buf)
@@ -717,14 +687,11 @@ static int nilfs_ioctl_delete_checkpoints(struct the_nilfs *nilfs,
  * Description: nilfs_ioctl_free_vblocknrs() function frees
  * the virtual block numbers specified by @buf and @argv->v_nmembs.
  *
- * Return Value: Number of processed virtual block numbers or
- * error code, otherwise.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - The virtual block number have not been allocated.
+ * Return: Number of processed virtual block numbers on success, or
+ * the following error code on failure.
+ * * %-EIO	- I/O error.
+ * * %-ENOENT	- Unallocated virtual block number.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_ioctl_free_vblocknrs(struct the_nilfs *nilfs,
 				      struct nilfs_argv *argv, void *buf)
@@ -746,14 +713,11 @@ static int nilfs_ioctl_free_vblocknrs(struct the_nilfs *nilfs,
  * Description: nilfs_ioctl_mark_blocks_dirty() function marks
  * metadata file or data blocks as dirty.
  *
- * Return Value: Number of processed block descriptors or
- * error code, otherwise.
- *
- * %-ENOMEM - Insufficient memory available.
- *
- * %-EIO - I/O error
- *
- * %-ENOENT - the specified block does not exist (hole block)
+ * Return: Number of processed block descriptors on success, or the following
+ * negative error code on failure.
+ * * %-EIO	- I/O error.
+ * * %-ENOENT	- Non-existent block (hole block).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_ioctl_mark_blocks_dirty(struct the_nilfs *nilfs,
 					 struct nilfs_argv *argv, void *buf)
@@ -852,7 +816,7 @@ int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
  * from userspace. The NILFS_IOCTL_CLEAN_SEGMENTS ioctl is used by
  * nilfs_cleanerd daemon.
  *
- * Return Value: On success, 0 is returned or error code, otherwise.
+ * Return: 0 on success, or a negative error code on failure.
  */
 static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 				      unsigned int cmd, void __user *argp)
@@ -976,20 +940,13 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
  * and metadata are written out to the device when it successfully
  * returned.
  *
- * Return Value: On success, 0 is retured. On errors, one of the following
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
- *
- * %-EFAULT - Failure during execution of requested operation.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EFAULT		- Failure during execution of requested operation.
+ * * %-EIO		- I/O error.
+ * * %-ENOMEM		- Insufficient memory available.
+ * * %-ENOSPC		- No space left on device (only in a panic state).
+ * * %-ERESTARTSYS	- Interrupted.
+ * * %-EROFS		- Read only filesystem.
  */
 static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
 			    unsigned int cmd, void __user *argp)
@@ -1023,7 +980,7 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
  * @filp: file object
  * @argp: pointer on argument from userspace
  *
- * Return Value: On success, 0 is returned or error code, otherwise.
+ * Return: 0 on success, or a negative error code on failure.
  */
 static int nilfs_ioctl_resize(struct inode *inode, struct file *filp,
 			      void __user *argp)
@@ -1059,7 +1016,7 @@ static int nilfs_ioctl_resize(struct inode *inode, struct file *filp,
  * checks the arguments from userspace and calls nilfs_sufile_trim_fs, which
  * performs the actual trim operation.
  *
- * Return Value: On success, 0 is returned or negative error code, otherwise.
+ * Return: 0 on success, or a negative error code on failure.
  */
 static int nilfs_ioctl_trim_fs(struct inode *inode, void __user *argp)
 {
@@ -1101,7 +1058,7 @@ static int nilfs_ioctl_trim_fs(struct inode *inode, void __user *argp)
  * of segments in bytes and upper limit of segments in bytes.
  * The NILFS_IOCTL_SET_ALLOC_RANGE is used by nilfs_resize utility.
  *
- * Return Value: On success, 0 is returned or error code, otherwise.
+ * Return: 0 on success, or a negative error code on failure.
  */
 static int nilfs_ioctl_set_alloc_range(struct inode *inode, void __user *argp)
 {
@@ -1152,17 +1109,14 @@ static int nilfs_ioctl_set_alloc_range(struct inode *inode, void __user *argp)
  * @dofunc: concrete function of getting metadata info
  *
  * Description: nilfs_ioctl_get_info() gets metadata info by means of
- * calling dofunc() function.
- *
- * Return Value: On success, 0 is returned and requested metadata info
- * is copied into userspace. On error, one of the following
- * negative error codes is returned.
+ * calling dofunc() function.  The requested metadata information is copied
+ * to userspace memory @argp.
  *
- * %-EINVAL - Invalid arguments from userspace.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-EFAULT - Failure during execution of requested operation.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EFAULT	- Failure during execution of requested operation.
+ * * %-EINVAL	- Invalid arguments from userspace.
+ * * %-EIO	- I/O error.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
 				unsigned int cmd, void __user *argp,
@@ -1202,18 +1156,12 @@ static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
  * encapsulated in nilfs_argv and updates the segment usage info
  * according to the flags in nilfs_suinfo_update.
  *
- * Return Value: On success, 0 is returned. On error, one of the
- * following negative error codes is returned.
- *
- * %-EPERM - Not enough permissions
- *
- * %-EFAULT - Error copying input data
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-EINVAL - Invalid values in input (segment number, flags or nblocks)
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EEXIST	- Block conflict detected.
+ * * %-EFAULT	- Error copying input data.
+ * * %-EINVAL	- Invalid values in input (segment number, flags or nblocks).
+ * * %-EIO	- I/O error.
+ * * %-EPERM	- Not enough permissions.
  */
 static int nilfs_ioctl_set_suinfo(struct inode *inode, struct file *filp,
 				unsigned int cmd, void __user *argp)
-- 
2.43.0

