Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0E2204688;
	Fri, 10 Jan 2025 01:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736471250; cv=none; b=nuyKsH2QQZThSbs0FR6LdnytKthYJC6HxhUyddSzh+G3T3HF4URd47ilnsyZQjZIYy5nK2u8fSOgv4wmkWTcybEIHycv9B9HJbMBOlpbijBbZ1MK5N8MAjvYQYk5PfO4pnrndVNFryNTj2j6z0z5AvT9Qjn713VYNY9Pn163HNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736471250; c=relaxed/simple;
	bh=Vuzbb9b0/RVgkNoXGl0DdHm2sJbX4Ly2PcejX8w3lCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rj11Q9Nb8rnJGWWrl4GN+d1Bc/LOVVSOlFqUHHHCCSEA//eY9MaFNC1om+C+vgo76JmXLmEVbD3G/hqldL4BKvH8FPp1s3hHhSV2mysKnLeYvlXWb7/FuufsmgWmYxkl0Lyw2NoR89xDDiFM9nOE4HasyyNeZHewL+AaSgdtS68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SwRxLo0N; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SwRxLo0N"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21634338cfdso34465065ad.2;
        Thu, 09 Jan 2025 17:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736471247; x=1737076047; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2cMk0RgEMQ6q9ONC0S36gIY8rZpiqX9AbZN0DEHDcMM=;
        b=SwRxLo0NTtHJiD3eiHzaPWU+z31b5E182XaCjX6mkQzh87NeZ5mj1MvcHR+bSOy/fN
         f1KXL/DQl0MKaXOVs3S+yCAB6BCYdbqhck2ro+NmOBtBT9qgXkgroxjX/mEekdgpc+A7
         PrhCvWp6FbOb1FPnGOR0Hs48oeL4c8QebFqkWpkcfEPGkld/8sDvknWyrmwjH5Z3o5aX
         Us5gAvtrNtsRgVnl9KbKf6b4g+f2922zlD4Zn7xNXzUgy+nYBJvuWNEq7A7yRQ0rXc+x
         FOq/2XTlZfxlGZaiSRDyznrr4OxIxHs5BKoYbRLWXNdHD1g7Npbx0cNBZ4wQWFTq4XS3
         H+yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736471247; x=1737076047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2cMk0RgEMQ6q9ONC0S36gIY8rZpiqX9AbZN0DEHDcMM=;
        b=L6zYO8VODQAzp4i1ip4ewr8nRfH5LTmLgffIRCaJLPEeZ8PE5s0gaNqfGlEoOOubZP
         pMhmDlQCw+JikmA3kWxjgt/ChOiAbXyJnBRKIw/+0eQvLLQWGrvZeqWASV8IvZtB65S7
         sh9zL8ARneNRaTRCto3IFG7/2c3oyUf3q+9EQHZfsMCOeCvXkIVUuh8YSGk9x+h8w4J9
         HK5OiHflNYjEGQTMIjBajDZi/t1mk91efQ6sVEkkKLhzTJLYOKyCQqVnvw69I8sUOPms
         z2DqaigRrAzggjzpmcIIdAIcYw7qNgYQ272VtHWk/E+45wEwpHSf/jWVnxEHxnf3rAxE
         GXTw==
X-Forwarded-Encrypted: i=1; AJvYcCVpbXzRqPV/Oi64QXYUNQp17Lkw2hInNnJis5K0UHQjVQpa+e+eCUlUwEF8wphgSgplzY6As0HZiwqx81U=@vger.kernel.org, AJvYcCVvrYPHTt+/rHPXmE1Spy3XHn+VdKcmMboLQ/HfNwaHDy3rCpBG3f1ufHGICvs586ERdXp+mcuT/3Blf5M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCiZJK9yJxEwJ9Phdv9ALetYwwhymJ40Tze55bXoGaBk+GPbzW
	SQj08QqH/byCzY4afB8YF5BoQy+39nw8J1cc48sWmAaJXdUCBW/A
X-Gm-Gg: ASbGncuGl1GPXWPrC2HeHYyU8bEdX/T2Hqc0CETqDG1dHm+Q21PKUcjiIoL7qr9Q/pz
	/CNvBCISQALc51P4YQhTU5jfQML1kBHNP9HSLd6ZC9jzaIVpcPJ1gn2XLnuKxaIlOKtU/RxNd5n
	MOSbo148RLeOXi4LuJkVOfBOopaJqFRft6mRqrUot3ZfRh2bL0p2tPGyAfGpRbv0taIvBO//RC/
	kJWMJbZeSYwmWYJ0rA0DyVYu1J47DyUHpNL9JfUo2FK+ixrLzXXzn3PlBuyEga0HPF3kqKcjVyb
	hb+ochic+tDQvwqzNWhaWjD54+Og
X-Google-Smtp-Source: AGHT+IFMAqFqUvHtWYbC1xwQgd+o53O4MVZ8rx3aft2LKvFZI8ziGHcLrR9o+t/ghEHs0KEvKnuSpw==
X-Received: by 2002:a05:6a20:c887:b0:1e1:932e:b348 with SMTP id adf61e73a8af0-1e88d306a82mr14461825637.41.1736471247432;
        Thu, 09 Jan 2025 17:07:27 -0800 (PST)
Received: from carrot.. (i114-186-237-30.s41.a014.ap.plala.or.jp. [114.186.237.30])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a31ddb9e4b4sm1862834a12.70.2025.01.09.17.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 17:07:26 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Brian G ." <gissf1@gmail.com>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH -v2 7/7] nilfs2: revise the return value description style for consistency.
Date: Fri, 10 Jan 2025 10:01:50 +0900
Message-ID: <20250110010530.21872-8-konishi.ryusuke@gmail.com>
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

Also for comments that do not cause kernel-doc warnings (those that
list multiple error codes), revise the return value description style
to match Brian G.'s suggestion of "..., or one of the following
negative error codes on failure:".

Link: https://lkml.kernel.org/r/CAAq45aNh1qV8P6XgDhKeNstT=PvcPUaCXsAF-f9rvmzznsZL5A@mail.gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/btnode.c  |  3 ++-
 fs/nilfs2/cpfile.c  | 16 ++++++++++------
 fs/nilfs2/dat.c     |  3 ++-
 fs/nilfs2/ifile.c   |  3 ++-
 fs/nilfs2/ioctl.c   |  3 ++-
 fs/nilfs2/segment.c |  6 ++++--
 fs/nilfs2/sufile.c  |  2 +-
 7 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 54a3fa0cf67e..568367129092 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -201,7 +201,8 @@ void nilfs_btnode_delete(struct buffer_head *bh)
  * Note that the current implementation does not support folio sizes larger
  * than the page size.
  *
- * Return: 0 on success, or the following negative error code on failure.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
  * * %-EIO	- I/O error (metadata corruption).
  * * %-ENOMEM	- Insufficient memory available.
  */
diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index aaab0ae90261..bcc7d76269ac 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -236,7 +236,8 @@ static inline int nilfs_cpfile_delete_checkpoint_block(struct inode *cpfile,
  * stores it to the inode file given by @ifile and the nilfs root object
  * given by @root.
  *
- * Return: 0 on success, or the following negative error code on failure.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
  * * %-EINVAL	- Invalid checkpoint.
  * * %-ENOMEM	- Insufficient memory available.
  * * %-EIO	- I/O error (including metadata corruption).
@@ -304,7 +305,8 @@ int nilfs_cpfile_read_checkpoint(struct inode *cpfile, __u64 cno,
  * In either case, the buffer of the block containing the checkpoint entry
  * and the cpfile inode are made dirty for inclusion in the write log.
  *
- * Return: 0 on success, or the following negative error code on failure.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
  * * %-ENOMEM	- Insufficient memory available.
  * * %-EIO	- I/O error (including metadata corruption).
  * * %-EROFS	- Read only filesystem
@@ -373,7 +375,8 @@ int nilfs_cpfile_create_checkpoint(struct inode *cpfile, __u64 cno)
  * cpfile with the data given by the arguments @root, @blkinc, @ctime, and
  * @minor.
  *
- * Return: 0 on success, or the following negative error code on failure.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
  * * %-ENOMEM	- Insufficient memory available.
  * * %-EIO	- I/O error (including metadata corruption).
  */
@@ -712,7 +715,7 @@ static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 *cnop,
  * number to continue searching.
  *
  * Return: Count of checkpoint info items stored in the output buffer on
- * success, or the following negative error code on failure.
+ * success, or one of the following negative error codes on failure:
  * * %-EINVAL	- Invalid checkpoint mode.
  * * %-ENOMEM	- Insufficient memory available.
  * * %-EIO	- I/O error (including metadata corruption).
@@ -737,7 +740,8 @@ ssize_t nilfs_cpfile_get_cpinfo(struct inode *cpfile, __u64 *cnop, int mode,
  * @cpfile: checkpoint file inode
  * @cno:    checkpoint number to delete
  *
- * Return: 0 on success, or the following negative error code on failure.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
  * * %-EBUSY	- Checkpoint in use (snapshot specified).
  * * %-EIO	- I/O error (including metadata corruption).
  * * %-ENOENT	- No valid checkpoint found.
@@ -1005,7 +1009,7 @@ static int nilfs_cpfile_clear_snapshot(struct inode *cpfile, __u64 cno)
  * @cno:    checkpoint number
  *
  * Return: 1 if the checkpoint specified by @cno is a snapshot, 0 if not, or
- * the following negative error code on failure.
+ * one of the following negative error codes on failure:
  * * %-EIO	- I/O error (including metadata corruption).
  * * %-ENOENT	- No such checkpoint.
  * * %-ENOMEM	- Insufficient memory available.
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index c5664035b3e3..c664daba56ae 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -276,7 +276,8 @@ void nilfs_dat_abort_update(struct inode *dat,
  * @dat:      DAT file inode
  * @vblocknr: virtual block number
  *
- * Return: 0 on success, or the following negative error code on failure.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
  * * %-EINVAL	- Invalid DAT entry (internal code).
  * * %-EIO	- I/O error (including metadata corruption).
  * * %-ENOMEM	- Insufficient memory available.
diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index e1e050dfbbc2..c4cd4a4dedd0 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -172,7 +172,8 @@ int nilfs_ifile_count_free_inodes(struct inode *ifile,
  * @cno: number of checkpoint entry to read
  * @inode_size: size of an inode
  *
- * Return: 0 on success, or the following negative error code on failure.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
  * * %-EINVAL	- Invalid checkpoint.
  * * %-ENOMEM	- Insufficient memory available.
  * * %-EIO	- I/O error (including metadata corruption).
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index e877c97974a4..a66d62a51f77 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -1268,7 +1268,8 @@ static int nilfs_ioctl_get_fslabel(struct super_block *sb, void __user *argp)
  * @filp: file object
  * @argp: pointer to userspace memory that contains the volume name
  *
- * Return: 0 on success, or the following negative error code on failure.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
  * * %-EFAULT	- Error copying input data.
  * * %-EINVAL	- Label length exceeds record size in superblock.
  * * %-EIO	- I/O error.
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 94f45281253c..3a202e51b360 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1122,7 +1122,8 @@ static int nilfs_segctor_scan_file_dsync(struct nilfs_sc_info *sci,
  * a super root block containing this sufile change is complete, and it can
  * be canceled with nilfs_sufile_cancel_freev() until then.
  *
- * Return: 0 on success, or the following negative error code on failure.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
  * * %-EINVAL	- Invalid segment number.
  * * %-EIO	- I/O error (including metadata corruption).
  * * %-ENOMEM	- Insufficient memory available.
@@ -2834,7 +2835,8 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
  * This allocates a log writer object, initializes it, and starts the
  * log writer.
  *
- * Return: 0 on success, or the following negative error code on failure.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
  * * %-EINTR	- Log writer thread creation failed due to interruption.
  * * %-ENOMEM	- Insufficient memory available.
  */
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 47d01255a8fb..330f269abedf 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -850,7 +850,7 @@ int nilfs_sufile_resize(struct inode *sufile, __u64 newnsegs)
  * @nsi:    size of suinfo array
  *
  * Return: Count of segment usage info items stored in the output buffer on
- * success, or the following negative error code on failure.
+ * success, or one of the following negative error codes on failure:
  * * %-EIO	- I/O error (including metadata corruption).
  * * %-ENOMEM	- Insufficient memory available.
  */
-- 
2.43.0

