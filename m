Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B8718C32C;
	Fri, 10 Jan 2025 01:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736471238; cv=none; b=GU0WZwobmubW5rjgTXgdNuxPYE18shf/Ef5bdev5CFGxn21qm30N+owjpOu0jc4AOB1d9+1mPTmvHtJQgk63WM2E4uWegQ5IoU8qN3m5a5nshX38xCMxvXHsu4xH5G1MsvCsy+aZ491aLkWlinkTqge6m60I8isLg2i+7ImNh8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736471238; c=relaxed/simple;
	bh=aKyeu4rI+00+ayanwOPY+VrfUU/9Uag9jgQ/b4PCH8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9k2u4SM0A2faXf7ehesdQKvu+of+K1v3uR3mqsQLQXRnHJSlugX4VaY4xogPqscqnlVt0p0F5loka7NDdvWt+kAuM455F/6brrwzeeC7SPxE6ApO1BuYlRm8/iUiidGdpzcHdnVO7rXu42IfDtB4uS+6QkojhPnSLY+pFNSbOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TyWOPWO1; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TyWOPWO1"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-21675fd60feso32946805ad.2;
        Thu, 09 Jan 2025 17:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736471236; x=1737076036; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5XP5CTnb40QDwTYfDMXS6o0H0ocSd8d6zbqRLEzRmIw=;
        b=TyWOPWO1neiycirVDADG56TdsFLDQKYGIVGaKPzAtoJzeubh1oiowqikauO450jgSU
         GZmFXBL+jOLfxn8mUZ1wJdXUzylu4fLuCpbG6/5Tshz6cD4JkYCnhLhW+SlZe/+OwWAO
         UB3Qw6GuK8fiOn2c676xRCuTGEhDCeawee7ztS6lxjlbEFmWVHGbzYZDT+AV60m4f7lu
         uHxPow1ag4BqsKZXcRx3I686CcF0zb2H7nOwV8/jf1EHaiQ4b+GJd+p2g0NGdaDdSuP9
         qL/jEWYbGKkp0NdbCQLOrBOgVDAo+xDXN0dAYI1LipB7PXFPkjZsogOvwJy5qiZZFQSH
         yaeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736471236; x=1737076036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5XP5CTnb40QDwTYfDMXS6o0H0ocSd8d6zbqRLEzRmIw=;
        b=PmwoQQDbCBOFQHvqR6Z8ergitQQweyLgPOXQeZ9O3v666wYuDeS0iWccQUaZrZML4+
         rxU9x6lWXGTt/LvbDvZ7APjB/C4VwMa9ou5yjvpSutiJKGusWSFwjwCJ3/PF20ZE+dnM
         Jg56o2puqIX0wcePv8oM9v/KdhA9tOeVO2rsJbanXosBTRLsobBmHCaSXNV6xmMOrBOB
         PZnpvoNp53wsZAbhfvCrWKTbgW79olcz6arHdJfSP4PkE8t+nQ3KNfmaj9RPSuDMn3gG
         wayeTlWaaOkx4sO7r9JWNv785PUbPPio7eq9Bz5nmrh+605b/nPadxu/51/pcNd5qE1S
         2YwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVs9CSWTt6D60n9S7ZNxtTy5RuLE65OWN/F9/P13JmB4ebZC0ZwgranZ+H96rTLo/qEtayLccbHSq7AbWg=@vger.kernel.org, AJvYcCXTFbTdMhL25hmsJA7Q1Xp+82HexMuZGI9MD4s1pON3AADiLYj8Lg41taM7EDMlzdzbFKK1yvlvLxkuDoo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDXLV95+aQvUlwfzTpKFXda9YCf/fs+2FYKI1iK7bSVHwkcO9K
	GfPRn2AnDdTsFl6vMSZ0uwfWH+uAHF+lxP3+IKzvhVguykl59GMl
X-Gm-Gg: ASbGncuvW7IwRSvcQOYmj5QH9Txld/VUmTV2aY2k4xvfj8fIC1P3TCn0n79a68qu5nr
	0m6z5VRv95NhctEcTfDQEd0hxScCxlrTwuiXPAiQXYUtc5xIzPlAtt8AVvNtCCkas27u9do8Gzv
	VOYJxw1o/f9NhTJsGbGVnmd49JyUveV7KCURLLKCIuli0ivkpqSD9h5nx0AiG9ArBBMoO4Ohv5C
	7qcadxj4o3RSkxPsWWsC/kX/cgs03xfUudmzLv649NbcA906EU8oGnkvNUtOzID3M7gHSVUg9AG
	0JmWohNxScQh5jq+mzR10xqgUKTg
X-Google-Smtp-Source: AGHT+IG63Yu3XG2ke+4oHod3stNkUTBHwRBUZu9hFZN5/1Ff5UxNFOlP33yb2I9STesmrVTNcd0kCA==
X-Received: by 2002:a17:902:d2d2:b0:216:393b:23e9 with SMTP id d9443c01a7336-21a83f57208mr123287865ad.20.1736471235797;
        Thu, 09 Jan 2025 17:07:15 -0800 (PST)
Received: from carrot.. (i114-186-237-30.s41.a014.ap.plala.or.jp. [114.186.237.30])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a31ddb9e4b4sm1862834a12.70.2025.01.09.17.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 17:07:14 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Brian G ." <gissf1@gmail.com>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH -v2 3/7] nilfs2: correct return value kernel-doc descriptions for sufile
Date: Fri, 10 Jan 2025 10:01:46 +0900
Message-ID: <20250110010530.21872-4-konishi.ryusuke@gmail.com>
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
fixes the format of the return value descriptions of functions for
sufile-related functions, eliminating a dozen warnings emitted by the
kernel-doc script.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/sufile.c | 102 +++++++++++++++++----------------------------
 fs/nilfs2/sufile.h |  16 +++----
 2 files changed, 45 insertions(+), 73 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index d3ecc813d633..623d417a54eb 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -155,17 +155,13 @@ unsigned long nilfs_sufile_get_ncleansegs(struct inode *sufile)
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EINVAL	- Invalid segment usage number
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- Given segment usage is in hole block (may be returned if
+ *		  @create is zero)
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_sufile_updatev(struct inode *sufile, __u64 *segnumv, size_t nsegs,
 			 int create, size_t *ndone,
@@ -272,10 +268,7 @@ int nilfs_sufile_update(struct inode *sufile, __u64 segnum, int create,
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
@@ -300,17 +293,14 @@ int nilfs_sufile_set_alloc_range(struct inode *sufile, __u64 start, __u64 end)
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-ENOSPC	- No clean segment left.
  */
 int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 {
@@ -610,16 +600,13 @@ int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_sufile_get_stat(struct inode *sufile, struct nilfs_sustat *sustat)
 {
@@ -683,16 +670,12 @@ void nilfs_sufile_do_set_error(struct inode *sufile, __u64 segnum,
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EBUSY	- Dirty or active segments are present in the range.
+ * * %-EINVAL	- Invalid number of segments specified.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static int nilfs_sufile_truncate_range(struct inode *sufile,
 				       __u64 start, __u64 end)
@@ -787,16 +770,12 @@ static int nilfs_sufile_truncate_range(struct inode *sufile,
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EBUSY	- Dirty or active segments exist in the region to be truncated.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-ENOSPC	- Enough free space is not left for shrinking.
  */
 int nilfs_sufile_resize(struct inode *sufile, __u64 newnsegs)
 {
@@ -939,14 +918,11 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EINVAL	- Invalid values in input (segment number, flags or nblocks).
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
 				unsigned int supsz, size_t nsup)
@@ -1073,7 +1049,7 @@ ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
  * and start+len is rounded down. For each clean segment blkdev_issue_discard
  * function is invoked.
  *
- * Return Value: On success, 0 is returned or negative error code, otherwise.
+ * Return: 0 on success, or a negative error code on failure.
  */
 int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range)
 {
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index 8e8a1a5a0402..127ab01a47ea 100644
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
@@ -114,14 +113,11 @@ static inline int nilfs_sufile_cancel_freev(struct inode *sufile,
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
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EINVAL	- Invalid segment usage number.
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOMEM	- Insufficient memory available.
  */
 static inline int nilfs_sufile_set_error(struct inode *sufile, __u64 segnum)
 {
-- 
2.43.0

