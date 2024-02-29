Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80D774C0B
	for <linux-nilfs@vger.kernel.org>; Thu, 29 Feb 2024 21:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709240869; cv=none; b=VK+GY9raNM56ofJkJanVW8RZLO79zb8PtAo05UnUFvx2X96BnCXpiq6Wq1DHeVi3+m+HqdyoLjnxmlJwallhs+6YR6KHZl0i+kXH1k/b0JXg7Od/5yMUDtgj+ywDb7z8gYUwGkMOTXkvfBtCulot6/Wnp43IAkmxf4kPphkX7Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709240869; c=relaxed/simple;
	bh=P40kUziuLyokqt8ezOh5PiObVcgjV29/BsW4rgJQ09Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJ7ZUdbRhPUV8KAzVa2LJcV/xk6lJY2RH9K/puD4yWxgH764RbW8PEBjDkAnLxv3jxPL0hKs+YFACBaXoK5C0nHnXxVGWj4uHlkNNoKBo38Ty4wdcAK7c0aRuPO06dqli8m9usXr0Rr70M2kN8FGKb3TlOj2cPEuGRR2YBt2BLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=KVl0+JQc; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="KVl0+JQc"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a3d484a58f6so230475166b.3
        for <linux-nilfs@vger.kernel.org>; Thu, 29 Feb 2024 13:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1709240866; x=1709845666; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JdfXWZLLwYzD+iUoGVhhT8Bl6KEb0/kYlFIi77YTG+g=;
        b=KVl0+JQcBEFCdQ1RQiT9cs4oecfEay9r63aTFHSUa6vaecAjqHaY6ueRxQPHilJKkR
         DOdPPR8ZzjiNhvks2coaNEUz2hd0fA9mU2fH+l/+g5OL/psHBlZ9eUiyIWc4HXkVhsnn
         tHVt681jDxtXTTG81LlZ7CRDdlanhKYF1Iwvnc/e4SK/z3Fq5XBeuFItfKp9vxovElkF
         5LSp638tEj6i3zIkA05bk3nv9gOe2v18viMs82Ero/h8XtYm7UQx8nFK6pTO4xkNqc+q
         TH0gpOU+JNXV0M7+0T1hd2FikXM7vO1zEdOrwS/qLnQviUNOwEbUKw0dCgDVUj41pxae
         mEYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709240866; x=1709845666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JdfXWZLLwYzD+iUoGVhhT8Bl6KEb0/kYlFIi77YTG+g=;
        b=F+kAOE0pmkzGUYSZzSsvQamuVZ/BaN9jnvO6PaNnrEIOLWQr+Sq7q6Hrk7T/zUQW37
         nzY0tSefBYSuMX/NDOiRM7ZA9ZTBmGAOpyAmleAV3EtM3ZwgM84ItcD8lhRqoHDUA0RQ
         XcONP558JYr6c6FH8w0gvXXdAEaJZuTsHvH2Jh/cR3meBcZBojLH/7/WGYq9UqCP52vc
         iN7OyEQ8sAlLOd5vNp2xCEP6UDOvhQPlThB4mV7k8FRfYRZ2UgdiS5aOmqi43DgXSN1R
         akRkyC9Fp3xX7BXU970s/ptaH6vbUWdN9X6F1qZ4NW5VLy7XhWBN3jWqvgycj3iSUUrp
         a1ag==
X-Forwarded-Encrypted: i=1; AJvYcCWHIhsWbooRNC9hKwQ5rQA/+a8ur0DA4XiEK1VivH89ksZw1njr9c8EP1D/bDeakErscrBUx0iQ4W9Ju3dwmLTcxH+m1AKXdAQkTW4=
X-Gm-Message-State: AOJu0Yw8pfHIsnGAlOMe4em4/L52BH2Xzd4u/dSFKf2INMM7qu8dhJqe
	blUIlNiIv6keueeT44FGJcPT23PNYrztwFqcsRDBH6REdZbarn4lUq/o8Mo73SM=
X-Google-Smtp-Source: AGHT+IEdNq8FL3WIQtocjEY8iv1pn5uPjnjxy3oOJZ7eihaUljPVLdkjzHOlXeu5voZGbgrbGmC1gQ==
X-Received: by 2002:a17:906:1685:b0:a3f:1530:ab16 with SMTP id s5-20020a170906168500b00a3f1530ab16mr75240ejd.74.1709240866132;
        Thu, 29 Feb 2024 13:07:46 -0800 (PST)
Received: from fedora.fritz.box (aftr-82-135-80-35.dynamic.mnet-online.de. [82.135.80.35])
        by smtp.gmail.com with ESMTPSA id fj5-20020a1709069c8500b00a3e8c3fc3ffsm1045279ejc.10.2024.02.29.13.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 13:07:45 -0800 (PST)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: thorsten.blum@toblux.com
Cc: konishi.ryusuke@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-nilfs@vger.kernel.org
Subject: [PATCH v2] nilfs2: Use div64_ul() instead of do_div()
Date: Thu, 29 Feb 2024 22:04:57 +0100
Message-ID: <20240229210456.63234-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <BFEA2A31-3147-49EF-A9BE-592C90E783DD@toblux.com>
References: <BFEA2A31-3147-49EF-A9BE-592C90E783DD@toblux.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes Coccinelle/coccicheck warnings reported by do_div.cocci.

Compared to do_div(), div64_ul() does not implicitly cast the divisor and
does not unnecessarily calculate the remainder.

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 fs/nilfs2/cpfile.c    | 2 +-
 fs/nilfs2/dat.c       | 2 +-
 fs/nilfs2/ioctl.c     | 4 ++--
 fs/nilfs2/sufile.c    | 2 +-
 fs/nilfs2/super.c     | 2 +-
 fs/nilfs2/the_nilfs.c | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 39136637f715..bafbdca1a17d 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -28,7 +28,7 @@ nilfs_cpfile_get_blkoff(const struct inode *cpfile, __u64 cno)
 {
 	__u64 tcno = cno + NILFS_MDT(cpfile)->mi_first_entry_offset - 1;
 
-	do_div(tcno, nilfs_cpfile_checkpoints_per_block(cpfile));
+	tcno = div64_ul(tcno, nilfs_cpfile_checkpoints_per_block(cpfile));
 	return (unsigned long)tcno;
 }
 
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 9cf6ba58f585..df5324b0c0cd 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -460,7 +460,7 @@ ssize_t nilfs_dat_get_vinfo(struct inode *dat, void *buf, unsigned int visz,
 		kaddr = kmap_atomic(entry_bh->b_page);
 		/* last virtual block number in this block */
 		first = vinfo->vi_vblocknr;
-		do_div(first, entries_per_block);
+		first = div64_ul(first, entries_per_block);
 		first *= entries_per_block;
 		last = first + entries_per_block - 1;
 		for (j = i, n = 0;
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index cfb6aca5ec38..f1a01c191cf5 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -1111,7 +1111,7 @@ static int nilfs_ioctl_set_alloc_range(struct inode *inode, void __user *argp)
 	segbytes = nilfs->ns_blocks_per_segment * nilfs->ns_blocksize;
 
 	minseg = range[0] + segbytes - 1;
-	do_div(minseg, segbytes);
+	minseg = div64_ul(minseg, segbytes);
 
 	if (range[1] < 4096)
 		goto out;
@@ -1120,7 +1120,7 @@ static int nilfs_ioctl_set_alloc_range(struct inode *inode, void __user *argp)
 	if (maxseg < segbytes)
 		goto out;
 
-	do_div(maxseg, segbytes);
+	maxseg = div64_ul(maxseg, segbytes);
 	maxseg--;
 
 	ret = nilfs_sufile_set_alloc_range(nilfs->ns_sufile, minseg, maxseg);
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 0a8119456c21..c02b523d9c7e 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -48,7 +48,7 @@ nilfs_sufile_get_blkoff(const struct inode *sufile, __u64 segnum)
 {
 	__u64 t = segnum + NILFS_MDT(sufile)->mi_first_entry_offset;
 
-	do_div(t, nilfs_sufile_segment_usages_per_block(sufile));
+	t = div64_ul(t, nilfs_sufile_segment_usages_per_block(sufile));
 	return (unsigned long)t;
 }
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index df8674173b22..fc19ccfe555c 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -448,7 +448,7 @@ int nilfs_resize_fs(struct super_block *sb, __u64 newsize)
 
 	sb2off = NILFS_SB2_OFFSET_BYTES(newsize);
 	newnsegs = sb2off >> nilfs->ns_blocksize_bits;
-	do_div(newnsegs, nilfs->ns_blocks_per_segment);
+	newnsegs = div64_ul(newnsegs, nilfs->ns_blocks_per_segment);
 
 	ret = nilfs_sufile_resize(nilfs->ns_sufile, newnsegs);
 	up_write(&nilfs->ns_segctor_sem);
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 71400496ed36..2ae2c1bbf6d1 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -413,7 +413,7 @@ static u64 nilfs_max_segment_count(struct the_nilfs *nilfs)
 {
 	u64 max_count = U64_MAX;
 
-	do_div(max_count, nilfs->ns_blocks_per_segment);
+	max_count = div64_ul(max_count, nilfs->ns_blocks_per_segment);
 	return min_t(u64, max_count, ULONG_MAX);
 }
 
-- 
2.44.0

