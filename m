Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D444274E09;
	Fri, 10 Jan 2025 01:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736471232; cv=none; b=STAbI8paKf6ARcmfioyTCXPYfYsNzJQ1ha+WT7XiRzRk9IrRyQuw9ASNOKZzvr5vT4vEIcVT/2dTNw1ElxJWR+G5kUqg03s65Wfe8u3pJkp091rWj49mcnXxltBo/yntSYSDHYTvAWjtlnNvOqVrP17e2yKsbGguROk5pVOQv8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736471232; c=relaxed/simple;
	bh=xQUq8MhMT1LaLYHT1nAu1A6AAxnGss5q9uyUzjvhh7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjvJP9Tc0s3Y4fJzsnIrHaPVTCGsX93AIdVX+thRjcaApWMaZTsONpcvaIgM7ZXKVf++1KFAMfHkmSXRxV+gqv9IXPwvXl0Sa8cTfwatKn7erV1LgryNcVNA2+w619PcbcZ7NAoZuKC6Cj1nffU8C4TBAOiSuha+lWeQY6fOIiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gTQu31T7; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gTQu31T7"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21628b3fe7dso25565875ad.3;
        Thu, 09 Jan 2025 17:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736471230; x=1737076030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KA+iLJ1yNlL+WXGc2SnFjLMt0vUUHN6+HjWIwM1Yiss=;
        b=gTQu31T7ZrC6pFA1DWvo2SZuOPYH0MhmoUeZuz0nGn4Gv6GaK/eY7ZgnkcWMuemE3T
         ES0lwgIimoUBMVHBXe/1j2Z+48bFcoK0haeKFwrtyWRrxU3nA2XnuatDWdlQMs9WzK3y
         b0ptcI/oeRL5WaX8V5vLpdd8M8XMvcHDbiAuNi7qKoFoW7MxPfPX1+zAnsg5JQ+Hz+2O
         mQ0z6pPOEvDj6wKyfRaocLMwM4n07kCQmOxsxxmHrVuYuY7Yzx3FwYooLnwd/6gav9IX
         G9zmR98tOqet3EGghPb40ptc+djrl0zk25rFppNzHwsaADbh6JPuKfjsfwO177/Eybhy
         Ud9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736471230; x=1737076030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KA+iLJ1yNlL+WXGc2SnFjLMt0vUUHN6+HjWIwM1Yiss=;
        b=IK8ndWiycr4U6Rh3kiBi3jDfNn9TxvH5L7OJhc+qDAl0sHF3Z4VLVbvRcG3VrQk7tt
         VPO7CZMhsb5Qj6FwAgEM9GCQxpSqwj5RfR8QwtHbFnEVVTKME0hyBfm627Yd21XPEFMN
         TPdxAVvpePwqSjRmoPHIs6CdXyes9e+FxPXKdd7i1aIMOSAYVJBnNjYhTAmi1vdwil4F
         1vimm4vbqWmLIJF0hIsYZ93yHGd8jce7fnwA+eLrTZM8hzT6t0NjMFMeb0sTPv+8FZLa
         yAsLWHgEuklDvgj0FVJcrGA7RRJav1GzNXoaXCFu89QBezKrraD22F0cDCYunFl+saH1
         GIfA==
X-Forwarded-Encrypted: i=1; AJvYcCUIUwVg4pGz6uNYzNSaCJn2Xa7mqgWtky5r0OsrRsCiRoXeVDBV7r1ud1C64ergN8pV3CvNrBJx+xHZFy0=@vger.kernel.org, AJvYcCVvJw6FAatiffdAuZPzToVN2OjaDwCuQUCUbX0vETEFnsl6tWsPSqHy0cA7LJhRtsv3OqwDFV8L0D28gg8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzqwz7HTG1HUpl2b2L1InvEp8PGFWjHDE+I2NIfzgI60I27/LCq
	N3GMIb4QSQPYcg4UfcuQhj8RLxsxbJKJc6hvsgE9zwkrwZwvZsXo
X-Gm-Gg: ASbGnctzVcrScaIjxlKwL49aWOEYQNKQ/RQJi+L9XaFTZ0KdHLX8T4qf94jETSp8ZdS
	Ek74U81E4QyxQqfaEPINsiUXpxFAw9lz6kGAtdujVBlOmYZShie9tgrntlwod3S7q4oYWwSuTsN
	ll2qwcaKN/UQaj7g60SzWCTXUwlIC2riHwUalt+NLEUqNNvTexZvOcUOdbIr+D1jDcRcQIeXNdo
	pKEavYnAiYlEZdhc+OG5kcNbi6/5dgaLPvbg1O+QwM90wV6gtvtlsYQvEn8C7umXI/jNeywbu+l
	Uu36pGtYNM6eyH/EwJJ+q+dhwblE
X-Google-Smtp-Source: AGHT+IEYI14cXlUee+9vwY9ZmgADnH940URyIB/Uq0VfoY37Vp30BCptiUHM3yS7A5UwhApdbfuL+w==
X-Received: by 2002:a05:6a21:158b:b0:1e6:44b4:7ccf with SMTP id adf61e73a8af0-1e88d2fc609mr14699175637.37.1736471229997;
        Thu, 09 Jan 2025 17:07:09 -0800 (PST)
Received: from carrot.. (i114-186-237-30.s41.a014.ap.plala.or.jp. [114.186.237.30])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a31ddb9e4b4sm1862834a12.70.2025.01.09.17.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 17:07:08 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Brian G ." <gissf1@gmail.com>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH -v2 1/7] nilfs2: correct return value kernel-doc descriptions for ioctl functions
Date: Fri, 10 Jan 2025 10:01:44 +0900
Message-ID: <20250110010530.21872-2-konishi.ryusuke@gmail.com>
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

In the kernel-doc comments for functions, there are many cases where
the format of the return value description is inaccurate, such as
"Return Value: ...", which causes many warnings to be output when the
kernel-doc script is executed with the "-Wall" option.

This fixes such incorrectly formatted return value descriptions for
ioctl functions.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/ioctl.c | 233 +++++++++++++++++++---------------------------
 1 file changed, 96 insertions(+), 137 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index fa77f78df681..e877c97974a4 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -33,17 +33,14 @@
  * @dofunc: concrete function of get/set metadata info
  *
  * Description: nilfs_ioctl_wrap_copy() gets/sets metadata info by means of
- * calling dofunc() function on the basis of @argv argument.
- *
- * Return Value: On success, 0 is returned and requested metadata info
- * is copied into userspace. On error, one of the following
- * negative error codes is returned.
- *
- * %-EINVAL - Invalid arguments from userspace.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-EFAULT - Failure during execution of requested operation.
+ * calling dofunc() function on the basis of @argv argument.  If successful,
+ * the requested metadata information is copied to userspace memory.
+ *
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EFAULT	- Failure during execution of requested operation.
+ * * %-EINVAL	- Invalid arguments from userspace.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 				 struct nilfs_argv *argv, int dir,
@@ -190,13 +187,10 @@ static int nilfs_ioctl_getversion(struct inode *inode, void __user *argp)
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * %-EFAULT	- Failure during checkpoint mode changing.
+ * %-EPERM	- Operation not permitted.
  */
 static int nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
 				     unsigned int cmd, void __user *argp)
@@ -244,13 +238,10 @@ static int nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * %-EFAULT	- Failure during checkpoint removing.
+ * %-EPERM	- Operation not permitted.
  */
 static int
 nilfs_ioctl_delete_checkpoint(struct inode *inode, struct file *filp,
@@ -296,7 +287,7 @@ nilfs_ioctl_delete_checkpoint(struct inode *inode, struct file *filp,
  * requested checkpoints. The NILFS_IOCTL_GET_CPINFO ioctl is used in
  * lscp utility and by nilfs_cleanerd daemon.
  *
- * Return value: count of nilfs_cpinfo structures in output buffer.
+ * Return: Count of nilfs_cpinfo structures in output buffer.
  */
 static ssize_t
 nilfs_ioctl_do_get_cpinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
@@ -320,17 +311,14 @@ nilfs_ioctl_do_get_cpinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
  *
  * Description: nilfs_ioctl_get_cpstat() returns information about checkpoints.
  * The NILFS_IOCTL_GET_CPSTAT ioctl is used by lscp, rmcp utilities
- * and by nilfs_cleanerd daemon.
+ * and by nilfs_cleanerd daemon.  The checkpoint statistics are copied to
+ * the userspace memory pointed to by @argp.
  *
- * Return Value: On success, 0 is returned, and checkpoints information is
- * copied into userspace pointer @argp. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-EFAULT - Failure during getting checkpoints statistics.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EFAULT	- Failure during getting checkpoints statistics.
+ * * %-EIO	- I/O error.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_ioctl_get_cpstat(struct inode *inode, struct file *filp,
 				  unsigned int cmd, void __user *argp)
@@ -363,7 +351,8 @@ static int nilfs_ioctl_get_cpstat(struct inode *inode, struct file *filp,
  * info about requested segments. The NILFS_IOCTL_GET_SUINFO ioctl is used
  * in lssu, nilfs_resize utilities and by nilfs_cleanerd daemon.
  *
- * Return value: count of nilfs_suinfo structures in output buffer.
+ * Return: Count of nilfs_suinfo structures in output buffer on success,
+ * or a negative error code on failure.
  */
 static ssize_t
 nilfs_ioctl_do_get_suinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
@@ -387,17 +376,14 @@ nilfs_ioctl_do_get_suinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EFAULT	- Failure during getting segment usage statistics.
+ * * %-EIO	- I/O error.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_ioctl_get_sustat(struct inode *inode, struct file *filp,
 				  unsigned int cmd, void __user *argp)
@@ -430,7 +416,8 @@ static int nilfs_ioctl_get_sustat(struct inode *inode, struct file *filp,
  * on virtual block addresses. The NILFS_IOCTL_GET_VINFO ioctl is used
  * by nilfs_cleanerd daemon.
  *
- * Return value: count of nilfs_vinfo structures in output buffer.
+ * Return: Count of nilfs_vinfo structures in output buffer on success, or
+ * a negative error code on failure.
  */
 static ssize_t
 nilfs_ioctl_do_get_vinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
@@ -457,7 +444,8 @@ nilfs_ioctl_do_get_vinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
  * about descriptors of disk block numbers. The NILFS_IOCTL_GET_BDESCS ioctl
  * is used by nilfs_cleanerd daemon.
  *
- * Return value: count of nilfs_bdescs structures in output buffer.
+ * Return: Count of nilfs_bdescs structures in output buffer on success, or
+ * a negative error code on failure.
  */
 static ssize_t
 nilfs_ioctl_do_get_bdescs(struct the_nilfs *nilfs, __u64 *posp, int flags,
@@ -494,19 +482,15 @@ nilfs_ioctl_do_get_bdescs(struct the_nilfs *nilfs, __u64 *posp, int flags,
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EFAULT	- Failure during getting disk block descriptors.
+ * * %-EINVAL	- Invalid arguments from userspace.
+ * * %-EIO	- I/O error.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_ioctl_get_bdescs(struct inode *inode, struct file *filp,
 				  unsigned int cmd, void __user *argp)
@@ -540,16 +524,12 @@ static int nilfs_ioctl_get_bdescs(struct inode *inode, struct file *filp,
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EEXIST	- Block conflict detected.
+ * * %-EIO	- I/O error.
+ * * %-ENOENT	- Requested block doesn't exist.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_ioctl_move_inode_block(struct inode *inode,
 					struct nilfs_vdesc *vdesc,
@@ -604,8 +584,8 @@ static int nilfs_ioctl_move_inode_block(struct inode *inode,
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
@@ -682,14 +662,11 @@ static int nilfs_ioctl_move_blocks(struct super_block *sb,
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
+ * Return: Number of processed nilfs_period structures on success, or one of
+ * the following negative error codes on failure:
+ * * %-EINVAL	- invalid checkpoints.
+ * * %-EIO	- I/O error.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_ioctl_delete_checkpoints(struct the_nilfs *nilfs,
 					  struct nilfs_argv *argv, void *buf)
@@ -717,14 +694,11 @@ static int nilfs_ioctl_delete_checkpoints(struct the_nilfs *nilfs,
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
+ * Return: Number of processed virtual block numbers on success, or one of the
+ * following negative error codes on failure:
+ * * %-EIO	- I/O error.
+ * * %-ENOENT	- Unallocated virtual block number.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_ioctl_free_vblocknrs(struct the_nilfs *nilfs,
 				      struct nilfs_argv *argv, void *buf)
@@ -746,14 +720,11 @@ static int nilfs_ioctl_free_vblocknrs(struct the_nilfs *nilfs,
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
+ * Return: Number of processed block descriptors on success, or one of the
+ * following negative error codes on failure:
+ * * %-EIO	- I/O error.
+ * * %-ENOENT	- Non-existent block (hole block).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_ioctl_mark_blocks_dirty(struct the_nilfs *nilfs,
 					 struct nilfs_argv *argv, void *buf)
@@ -852,7 +823,7 @@ int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
  * from userspace. The NILFS_IOCTL_CLEAN_SEGMENTS ioctl is used by
  * nilfs_cleanerd daemon.
  *
- * Return Value: On success, 0 is returned or error code, otherwise.
+ * Return: 0 on success, or a negative error code on failure.
  */
 static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 				      unsigned int cmd, void __user *argp)
@@ -976,20 +947,14 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EFAULT		- Failure during execution of requested operation.
+ * * %-EIO		- I/O error.
+ * * %-ENOMEM		- Insufficient memory available.
+ * * %-ENOSPC		- No space left on device (only in a panic state).
+ * * %-ERESTARTSYS	- Interrupted.
+ * * %-EROFS		- Read only filesystem.
  */
 static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
 			    unsigned int cmd, void __user *argp)
@@ -1023,7 +988,7 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
  * @filp: file object
  * @argp: pointer on argument from userspace
  *
- * Return Value: On success, 0 is returned or error code, otherwise.
+ * Return: 0 on success, or a negative error code on failure.
  */
 static int nilfs_ioctl_resize(struct inode *inode, struct file *filp,
 			      void __user *argp)
@@ -1059,7 +1024,7 @@ static int nilfs_ioctl_resize(struct inode *inode, struct file *filp,
  * checks the arguments from userspace and calls nilfs_sufile_trim_fs, which
  * performs the actual trim operation.
  *
- * Return Value: On success, 0 is returned or negative error code, otherwise.
+ * Return: 0 on success, or a negative error code on failure.
  */
 static int nilfs_ioctl_trim_fs(struct inode *inode, void __user *argp)
 {
@@ -1101,7 +1066,7 @@ static int nilfs_ioctl_trim_fs(struct inode *inode, void __user *argp)
  * of segments in bytes and upper limit of segments in bytes.
  * The NILFS_IOCTL_SET_ALLOC_RANGE is used by nilfs_resize utility.
  *
- * Return Value: On success, 0 is returned or error code, otherwise.
+ * Return: 0 on success, or a negative error code on failure.
  */
 static int nilfs_ioctl_set_alloc_range(struct inode *inode, void __user *argp)
 {
@@ -1152,17 +1117,15 @@ static int nilfs_ioctl_set_alloc_range(struct inode *inode, void __user *argp)
  * @dofunc: concrete function of getting metadata info
  *
  * Description: nilfs_ioctl_get_info() gets metadata info by means of
- * calling dofunc() function.
+ * calling dofunc() function.  The requested metadata information is copied
+ * to userspace memory @argp.
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EFAULT	- Failure during execution of requested operation.
+ * * %-EINVAL	- Invalid arguments from userspace.
+ * * %-EIO	- I/O error.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
 				unsigned int cmd, void __user *argp,
@@ -1202,18 +1165,14 @@ static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EEXIST	- Block conflict detected.
+ * * %-EFAULT	- Error copying input data.
+ * * %-EINVAL	- Invalid values in input (segment number, flags or nblocks).
+ * * %-EIO	- I/O error.
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-EPERM	- Not enough permissions.
  */
 static int nilfs_ioctl_set_suinfo(struct inode *inode, struct file *filp,
 				unsigned int cmd, void __user *argp)
-- 
2.43.0

