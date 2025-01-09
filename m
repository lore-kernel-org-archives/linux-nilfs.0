Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D285318132A;
	Thu,  9 Jan 2025 03:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736393303; cv=none; b=YFk/XX6kilNxGWZrfZDdCjvvhFBCM8SehzZcxABrgLD8kg231g1eVdpWhnS6Oxo/OXroK9yf3Uavia74amJf/D0MdEYxCWioLSBTMkY4+qQ16mPfHkpt6GRwrmnfI0c0S71Xf42kGKL05gSa4/IL6swtfkCMGwUaiVEedCsiK+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736393303; c=relaxed/simple;
	bh=TE4BGf1b3nrjf92JVAMZXm76IUR/co+kngALIO2Vsx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGkW0V7eO1d1erxt6KRaHXp5Ba716rDsY3cdBzJrDYDvIYEoSD1pOIva7aT+CRhKR0ElMzlAlTvxcgfEiCiipgK6De0qK8rDo3I7N3Tcupij9EnXIzvsEJo6NgWfgGsI4Z/bLvovdqHhqz5HFWfksNIacl4+n0GzHPcq+JK3lYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DElWa6xs; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DElWa6xs"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2ee67e9287fso813365a91.0;
        Wed, 08 Jan 2025 19:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736393301; x=1736998101; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HGL7WGrqr6eMyNJ4UIgqhdrm86SmggbTmX9qpzq+ui0=;
        b=DElWa6xsEDMfjL2bTLLXZWmpzgSky6dYI5u+kvWOKqyTLSC259xNhAL1BRgYTYYHJJ
         wF8odarfUh2FXcOI/2UbrywBOiwbMaHiYl8t1Q/7SGNR06AuRlIYK9jv/0K56GC8+79l
         5rIOnKlsd7MSFgHrH3uqFS9no36lbjkZ8TyWmFi2sBOuYKMODy6/PvDM4IQel62xIRtA
         oBZonJbTz49OKEqjaXDyl6tI2yQLK3mmp72fxHJDHc7Hs7nbCJSuwpeEyYUSa7raLWup
         Sp/FbtYpP/5EH2bbCW7yOBjrRy/nYV2MoxeTJ8wkrS/8h/WxWOxnCQPt03kNbl01Dx17
         mmQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736393301; x=1736998101;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HGL7WGrqr6eMyNJ4UIgqhdrm86SmggbTmX9qpzq+ui0=;
        b=KXDFGiHDFbyPyljolZphC7VQyNURoP9EeFYjhEeoiG3JF0CvQhWsydqNaBrcU3eTgK
         Ru3xgZZun8UUkFf4SuwXgrqBsFSO1ets18l6cONqKLAiBhyFn6l4r72/YY2b83FD7tnI
         jUxoziEaHJoIMFXTYTVDNUDTYwlRTCrHk82iHvAI8GipoELbVkajg4ESTfe9kw6Luahm
         U1qm2ik7vNu1oR37jayX47e708nlxzblyFFLZnscaYShg8hYm0WvPRdszTA1AhzRLheA
         py1C+h2tebtInwHEPsAhl1hUyAJvUUm7SOdzF9kPN5g9EbzObXoNAeASapJAXeINMdz/
         EMXg==
X-Forwarded-Encrypted: i=1; AJvYcCV6np+EAJE2S3LZ8QgdiFqFVIVH57xqdF74UbyilaZ4U0dxwbgFBVRAV85zba3oktEwFI1cPbQRkmtq8cE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKoZzsJjEhJSt7mYni74XhmCSS9ZC9Z333F1PBtM3dGLr3c9q9
	J24CGilYUB04pmYFWK0j/ym4BGXcz/mn4LCTWTrPM/X6iUUl35p3SnqBGg==
X-Gm-Gg: ASbGncuNMrDseNPWtIVXZBOcH7ZAJBAqenv1y5ak29h4fKxnb/RQc2bjUpjVaqsOc8a
	F0a3AbLGs/ybhaZslpLFmdiKxtI2RoZuGP5ea5vR+v42R+BV488TA/Ja4oKMUiC3MjYQ+XnVU4t
	H68w5dAwV994nkEux7aqEvI2DK4NsuUK+nAeU/n2XqUiMVcceYwN46ytSybe4VA9Q0yr28ZyJyB
	wE7IX3kwiYsVlCFB53MmuPIAdd1phGzb77eY9RQNdw2XXK5b57trjQu/3beOoQ42kkQEnDIXRFe
	CkSH7XNyvptvLtddB6E5xwdjTp4C
X-Google-Smtp-Source: AGHT+IGb7NDXfiepNwFcUlOgylATLw3pWG+t3coTuYSYQlijfodVK9bByLsALPLG0+jwBe1wmv7pDg==
X-Received: by 2002:a17:90b:4ed0:b0:2ee:6736:8512 with SMTP id 98e67ed59e1d1-2f548eb3229mr9599157a91.12.1736393300866;
        Wed, 08 Jan 2025 19:28:20 -0800 (PST)
Received: from carrot.. (i114-186-237-30.s41.a014.ap.plala.or.jp. [114.186.237.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f55942eed5sm194963a91.27.2025.01.08.19.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 19:28:20 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] nilfs2: correct return value kernel-doc descriptions for sufile
Date: Thu,  9 Jan 2025 12:23:22 +0900
Message-ID: <20250109032846.10147-4-konishi.ryusuke@gmail.com>
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
fixes the format of the return value descriptions of functions for
sufile-related functions, eliminating a dozen warnings emitted by the
kernel-doc script.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/sufile.c | 96 ++++++++++++++++------------------------------
 fs/nilfs2/sufile.h | 15 +++-----
 2 files changed, 38 insertions(+), 73 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index d3ecc813d633..92a301487a93 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -155,17 +155,12 @@ unsigned long nilfs_sufile_get_ncleansegs(struct inode *sufile)
  * of successfully modified segments from the head is stored in the
  * place @ndone points to.
  *
- * Return Value: On success, zero is returned.  On error, one of the
- * following negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - Given segment usage is in hole block (may be returned if
- *            @create is zero)
- *
- * %-EINVAL - Invalid segment usage number
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EINVAL	- Invalid segment usage number
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- Given segment usage is in hole block (may be returned if
+ *		  @create is zero)
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_sufile_updatev(struct inode *sufile, __u64 *segnumv, size_t nsegs,
 			 int create, size_t *ndone,
@@ -272,10 +267,7 @@ int nilfs_sufile_update(struct inode *sufile, __u64 segnum, int create,
  * @start: minimum segment number of allocatable region (inclusive)
  * @end: maximum segment number of allocatable region (inclusive)
  *
- * Return Value: On success, 0 is returned.  On error, one of the
- * following negative error codes is returned.
- *
- * %-ERANGE - invalid segment region
+ * Return: 0 on success, or %-ERANGE if segment range is invalid.
  */
 int nilfs_sufile_set_alloc_range(struct inode *sufile, __u64 start, __u64 end)
 {
@@ -300,17 +292,13 @@ int nilfs_sufile_set_alloc_range(struct inode *sufile, __u64 start, __u64 end)
  * @sufile: inode of segment usage file
  * @segnump: pointer to segment number
  *
- * Description: nilfs_sufile_alloc() allocates a clean segment.
- *
- * Return Value: On success, 0 is returned and the segment number of the
- * allocated segment is stored in the place pointed by @segnump. On error, one
- * of the following negative error codes is returned.
- *
- * %-EIO - I/O error.
+ * Description: nilfs_sufile_alloc() allocates a clean segment, and stores
+ * its segment number in the place pointed to by @segnump.
  *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOSPC - No clean segment left.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-ENOSPC	- No clean segment left.
  */
 int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 {
@@ -610,16 +598,12 @@ int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
  * @sufile: inode of segment usage file
  * @sustat: pointer to a structure of segment usage statistics
  *
- * Description: nilfs_sufile_get_stat() returns information about segment
- * usage.
- *
- * Return Value: On success, 0 is returned, and segment usage information is
- * stored in the place pointed by @sustat. On error, one of the following
- * negative error codes is returned.
+ * Description: nilfs_sufile_get_stat() retrieves segment usage statistics
+ * and stores them in the location pointed to by @sustat.
  *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_sufile_get_stat(struct inode *sufile, struct nilfs_sustat *sustat)
 {
@@ -683,16 +667,11 @@ void nilfs_sufile_do_set_error(struct inode *sufile, __u64 segnum,
  * @start: start segment number (inclusive)
  * @end: end segment number (inclusive)
  *
- * Return Value: On success, 0 is returned.  On error, one of the
- * following negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-EINVAL - Invalid number of segments specified
- *
- * %-EBUSY - Dirty or active segments are present in the range
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EBUSY	- Dirty or active segments are present in the range.
+ * * %-EINVAL	- Invalid number of segments specified.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_sufile_truncate_range(struct inode *sufile,
 				       __u64 start, __u64 end)
@@ -787,16 +766,11 @@ static int nilfs_sufile_truncate_range(struct inode *sufile,
  * @sufile: inode of segment usage file
  * @newnsegs: new number of segments
  *
- * Return Value: On success, 0 is returned.  On error, one of the
- * following negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOSPC - Enough free space is not left for shrinking
- *
- * %-EBUSY - Dirty or active segments exist in the region to be truncated
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EBUSY	- Dirty or active segments exist in the region to be truncated.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-ENOSPC	- Enough free space is not left for shrinking.
  */
 int nilfs_sufile_resize(struct inode *sufile, __u64 newnsegs)
 {
@@ -939,14 +913,10 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
  * segment usage accordingly. Only the fields indicated by the sup_flags
  * are updated.
  *
- * Return Value: On success, 0 is returned. On error, one of the
- * following negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-EINVAL - Invalid values in input (segment number, flags or nblocks)
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EINVAL	- Invalid values in input (segment number, flags or nblocks).
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
 				unsigned int supsz, size_t nsup)
@@ -1073,7 +1043,7 @@ ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
  * and start+len is rounded down. For each clean segment blkdev_issue_discard
  * function is invoked.
  *
- * Return Value: On success, 0 is returned or negative error code, otherwise.
+ * Return: 0 on success, or a negative error code on failure.
  */
 int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range)
 {
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index 8e8a1a5a0402..6b39e8d97ce9 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -95,8 +95,7 @@ static inline int nilfs_sufile_freev(struct inode *sufile, __u64 *segnumv,
  * @nsegs: size of @segnumv array
  * @ndone: place to store the number of cancelled segments
  *
- * Return Value: On success, 0 is returned. On error, a negative error codes
- * is returned.
+ * Return: 0 on success, or a negative error code on failure.
  */
 static inline int nilfs_sufile_cancel_freev(struct inode *sufile,
 					    __u64 *segnumv, size_t nsegs,
@@ -114,14 +113,10 @@ static inline int nilfs_sufile_cancel_freev(struct inode *sufile,
  * Description: nilfs_sufile_set_error() marks the segment specified by
  * @segnum as erroneous. The error segment will never be used again.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error codes is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-EINVAL - Invalid segment usage number.
+ * Return: 0 on success, or the following negative error code on failure.
+ * * %-EINVAL	- Invalid segment usage number.
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-EIO	- I/O error (including metadata corruption).
  */
 static inline int nilfs_sufile_set_error(struct inode *sufile, __u64 segnum)
 {
-- 
2.43.0

