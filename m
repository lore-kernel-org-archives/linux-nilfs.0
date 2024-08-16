Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788F6156F33;
	Fri, 16 Aug 2024 07:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723794230; cv=none; b=UPX4ty0u1IoHx5ttIevsxQ/X3U0OLPtHYe3Ws1jgknDeQFoMaVmwJQuHuYVyFfjG5F4r0pCSjYMb0zY7rfZnmO+Czo9nRC9KKO+g9ZNCqQU4Ceo7CeHJvSrdJkqASn6Oghi7f0TYUFWicgCYCbGy55c6evGkhLVv9ZP0Deuvin0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723794230; c=relaxed/simple;
	bh=UIbJ/uqoIosW5s1bUr03D7GTXRsDq9vJa4PH/arg0Gc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZThEXcn7tnmepnWllAD/vT79hiSLB/GkcOlv8V0/vQEH8ShWgqvVH4um+nfyDA4ux/vZWyc1RVgkTArlmu3DNN4DgU8+C/ASLM9PpTeW1qm75pX7t4AwrNeq2xUtCrmy4RfPhBLhb1aSwxOtq/0UYdky+zVpcjDjj8RlcAp41bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZS1y6Qi9; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZS1y6Qi9"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5c661e75ff6so1045517eaf.2;
        Fri, 16 Aug 2024 00:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723794227; x=1724399027; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bBKNk/g6wfoWgn/wh64t6+HoYfuxNxrmk+Ef10/o36c=;
        b=ZS1y6Qi9tf0SnldWxDKLKjIcwuO+0AjmDva2mlrLgBSco9scnkLuizxrgxUzoTYkIH
         RijNEyS30MYhWSV55vBCV6lQ4qjPKtdrZ3zB3DPoQqmSaYwtmeeULfZoG00HiL1mc6do
         MZVtgIPdD6PcSWCA4LyIMNpS2HQVjO4oVtNG6BVyplofHC31OY7IKte7giMdlQEtbpwE
         CnmlG192lsM+HuKIMgk6ZC5D7TU5hXK1whzlBAZIRe1YAqwdxrf8UZj8OxCvmuOgez9j
         JkeTfO9JqADJUCnE2+vx/4LFvAnyi7c13W2Am3abVeVp5/TNA7M+9iDwOt8FCeTEnqS2
         B6eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723794227; x=1724399027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bBKNk/g6wfoWgn/wh64t6+HoYfuxNxrmk+Ef10/o36c=;
        b=YnPKIWfQE+BRQ8kPCp4mtRsu+XZeRCgQTO1BIqjwrtXX8B/qqXvG+8czyf3JPu5UgP
         7Ti6A3cetEgaZlIehU6zVfvZoFq9KC48fWQFu1wVbX7EqV4udqobpn3uAupmtEiApa39
         lGs3y+a5Zw7NqAHQmsgrxNXaX2yzb6rnZduM/PR3SA7LOYwROXZRzQvclFzaa1eVuAm3
         s/g+h8BGCMP47fFhs4TWG+agMfTHuaolpp9CVM9TYDWGQZZB1gn14RWKfLR/pJa2XgDO
         LG8bGzJMZKvPdDm2SXxngAK/PATVbc15TuXoxiW6hwmwh9nu+vxY0jBU5dKJl/hW9Wes
         xouQ==
X-Forwarded-Encrypted: i=1; AJvYcCU//Pl2ONuQftOiK6+BBdrAsOwnf3c6PTokSbLgQKIwhRNDDN9PlpcIBeASxH4fgMAp0yAjlqW590XeaLTfqGavBC+yOEemj4WAbxje
X-Gm-Message-State: AOJu0Yz44UZk+NFPaKxU37H7nyJXOQlo+l/xMPFJERcP4AkJKCAOeeft
	elQwJCn+i8XBw16DXZV1J4pJ1Ny7la8yT5cl8T/jqhadJemNJIJEbHq9+Q==
X-Google-Smtp-Source: AGHT+IFKkqHOCa/az0OeWpg9uNiDJszkj/MhcvEctit2vifjwjrtZgD935GfaRGfWByBZDl4Aks+Ew==
X-Received: by 2002:a05:6870:1698:b0:261:6bc:9b8e with SMTP id 586e51a60fabf-2701c3f7b59mr2473932fac.26.1723794227398;
        Fri, 16 Aug 2024 00:43:47 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61e7c7asm2365971a12.45.2024.08.16.00.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 00:43:46 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] nilfs2: fix missing initial short descriptions of kernel-doc comments
Date: Fri, 16 Aug 2024 16:43:19 +0900
Message-Id: <20240816074319.3253-9-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240816074319.3253-1-konishi.ryusuke@gmail.com>
References: <20240816074319.3253-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update some kernel-doc comments that are missing the initial short
description and fix the following warnings output by the kernel-doc
script:

 fs/nilfs2/bmap.c:353: warning: missing initial short description on line:
  * nilfs_bmap_lookup_dirty_buffers -
 fs/nilfs2/cpfile.c:708: warning: missing initial short description on line:
  * nilfs_cpfile_delete_checkpoint -
 fs/nilfs2/cpfile.c:972: warning: missing initial short description on line:
  * nilfs_cpfile_is_snapshot -
 fs/nilfs2/dat.c:275: warning: missing initial short description on line:
  * nilfs_dat_mark_dirty -
 fs/nilfs2/sufile.c:844: warning: missing initial short description on line:
  * nilfs_sufile_get_suinfo -

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/bmap.c   |  2 +-
 fs/nilfs2/cpfile.c | 32 ++++++++++++++++----------------
 fs/nilfs2/dat.c    | 17 +++++++----------
 fs/nilfs2/sufile.c | 20 ++++++++------------
 4 files changed, 32 insertions(+), 39 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index cd14ea25968c..c9e8d9a7d820 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -349,7 +349,7 @@ int nilfs_bmap_propagate(struct nilfs_bmap *bmap, struct buffer_head *bh)
 }
 
 /**
- * nilfs_bmap_lookup_dirty_buffers -
+ * nilfs_bmap_lookup_dirty_buffers - collect dirty block buffers
  * @bmap: bmap
  * @listp: pointer to buffer head list
  */
diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 69a5cced1e84..9c8d531cffa7 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -704,9 +704,15 @@ ssize_t nilfs_cpfile_get_cpinfo(struct inode *cpfile, __u64 *cnop, int mode,
 }
 
 /**
- * nilfs_cpfile_delete_checkpoint -
- * @cpfile:
- * @cno:
+ * nilfs_cpfile_delete_checkpoint - delete a checkpoint
+ * @cpfile: checkpoint file inode
+ * @cno:    checkpoint number to delete
+ *
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EBUSY	- Checkpoint in use (snapshot specified).
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- No valid checkpoint found.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_cpfile_delete_checkpoint(struct inode *cpfile, __u64 cno)
 {
@@ -968,21 +974,15 @@ static int nilfs_cpfile_clear_snapshot(struct inode *cpfile, __u64 cno)
 }
 
 /**
- * nilfs_cpfile_is_snapshot -
+ * nilfs_cpfile_is_snapshot - determine if checkpoint is a snapshot
  * @cpfile: inode of checkpoint file
- * @cno: checkpoint number
- *
- * Description:
- *
- * Return Value: On success, 1 is returned if the checkpoint specified by
- * @cno is a snapshot, or 0 if not. On error, one of the following negative
- * error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * @cno:    checkpoint number
  *
- * %-ENOENT - No such checkpoint.
+ * Return: 1 if the checkpoint specified by @cno is a snapshot, 0 if not, or
+ * the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- No such checkpoint.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_cpfile_is_snapshot(struct inode *cpfile, __u64 cno)
 {
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index fc1caf63a42a..0bef662176a4 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -271,18 +271,15 @@ void nilfs_dat_abort_update(struct inode *dat,
 }
 
 /**
- * nilfs_dat_mark_dirty -
- * @dat: DAT file inode
+ * nilfs_dat_mark_dirty - mark the DAT block buffer containing the specified
+ *                        virtual block address entry as dirty
+ * @dat:      DAT file inode
  * @vblocknr: virtual block number
  *
- * Description:
- *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EINVAL	- Invalid DAT entry (internal code).
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_dat_mark_dirty(struct inode *dat, __u64 vblocknr)
 {
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 6748218be7c5..7bfc0860acee 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -840,21 +840,17 @@ int nilfs_sufile_resize(struct inode *sufile, __u64 newnsegs)
 }
 
 /**
- * nilfs_sufile_get_suinfo -
+ * nilfs_sufile_get_suinfo - get segment usage information
  * @sufile: inode of segment usage file
  * @segnum: segment number to start looking
- * @buf: array of suinfo
- * @sisz: byte size of suinfo
- * @nsi: size of suinfo array
+ * @buf:    array of suinfo
+ * @sisz:   byte size of suinfo
+ * @nsi:    size of suinfo array
  *
- * Description:
- *
- * Return Value: On success, 0 is returned and .... On error, one of the
- * following negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: Count of segment usage info items stored in the output buffer on
+ * success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
 				unsigned int sisz, size_t nsi)
-- 
2.34.1

