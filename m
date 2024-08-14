Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B4E1AD9C2;
	Wed, 14 Aug 2024 10:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723630286; cv=none; b=aWBDehS7o5WB0bXtTFLr8j0r0CcXPma4PepdHAXwUI7KWvHg+T/4wc04Rx0p1BkPMKhgoH/16qvYsqYxkY9RSw/FdgN+wSgo93+HcBcBwolK4NuOleT1lMFfVJOODemsZ7DjLl7a3yBMuKfK7rsv43FwqD/5Ir4GRRPWHX9Gv7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723630286; c=relaxed/simple;
	bh=gjEWhU6xc7MgcXwDvwjZmLLupkYNrjmhcRovxp/YkOA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R+7lWv6pK4ciH4KSVRRPOnpLgfSVPE0srYuzNM6JVC/S4trC1Y09vjZ8szvbWB4yJum+RbgvFI4qPloAJS5OvYMYn75VD/9TrmkyhuPv6s4gCX3CoYUFsBTC1fWVrad9VQ/AueMt2CmXjB0x+EkVTM/3+MO6OqM45vXveqI6kqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S5A3ypO/; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S5A3ypO/"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1fd90c2fc68so45089465ad.1;
        Wed, 14 Aug 2024 03:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723630284; x=1724235084; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aLAWGueIDsUOOdrNlrNyvVXSsuDgnHJV/4WnHDRAVT4=;
        b=S5A3ypO/xTej60NMWFV2Lj1veEv1++uPSGIwQysGeGsbGtxoSgu1dUoM3MdBFdCElm
         AMkvmUkpuYRf3Et3QYftLNrzVi44ilGxT7wl2VnTrJAV95ZGnYtEGyd+iUsNq3ts1NoB
         EXfDKKIvwpodP6O6sAmXP0+aziQiq3dUUvEiqcnKhc92CILqiTTtpZnt9ox3cNmmcd9L
         N9gn8LZCIu2hCuwEBcpCVhzlF88b7JWBOWeMLKQHSSAQT4cXFoDLf+gd0E1ATN5NJsHn
         v0VjBhLSVhsvVwVdhQ/ecaLDqEmJ4SfyvPBkVA7QKcvunEsx8vo0tFaujy7npnN4G+IE
         uGCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723630284; x=1724235084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aLAWGueIDsUOOdrNlrNyvVXSsuDgnHJV/4WnHDRAVT4=;
        b=NTMrMd3YOoNmN96JryJj32WkfvEV9Nun6IRnO3al3sj9Nn3KvLcFwJSPU5cMnd6qIJ
         6yJOS3YSc6yOMhNRFSTle0WO9h6QRROo5WGkIMGSwayYOC2JFhJttDZHA7cPXZSyulm1
         btZuUbzzce0DRkqDo5X301+POleY82THwuaN849AI3X2IjuKvboDorjvuXZlh83iR15K
         r7mHVpc+aOPdam+aJYAwDoccu+2U2xXhVM0RsbefVO2xfZnYEea2affSNWT+gaJe1THh
         7T/1S3Ch1d5kKyg5p0JbvQwJlXNT4zIunTGOh/RetAMxznzuyL6Id1cueMHZfbwH3jg1
         VG9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUE37C85xldE202lF8r6gQ8g/s9fGmK/YW9Z/vcuSlR4nv+vKPOSQdidsnP3n5tQVpDFRleOMBraNHNh2k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlMTObtOvKAjA63WLiPkEvFCyJ/x0+guzRZVwqunZylywNgtPl
	j6MGS5oYA9NG8gesnEh1a7jhX82/i8HG/7dqmmGAZg2kLx68YvJXGWLRWQ==
X-Google-Smtp-Source: AGHT+IGyHQkBaeuzoQq+yG2Xx4lrOpTKcgb1mWV7lBLwXoia5IzAszLLilkcWUB8ouu9TLawUjUlNA==
X-Received: by 2002:a17:902:cece:b0:1fb:37fa:fedb with SMTP id d9443c01a7336-201d639379emr30058505ad.10.1723630284235;
        Wed, 14 Aug 2024 03:11:24 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201cd1b486csm26656485ad.206.2024.08.14.03.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 03:11:23 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] nilfs2: fix state management in error path of log writing function
Date: Wed, 14 Aug 2024 19:11:19 +0900
Message-Id: <20240814101119.4070-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240807230742.11151-1-konishi.ryusuke@gmail.com>
References: <20240807230742.11151-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After commit a694291a6211 ("nilfs2: separate wait function from
nilfs_segctor_write") was applied, the log writing function
nilfs_segctor_do_construct() was able to issue I/O requests
continuously even if user data blocks were split into multiple logs
across segments, but two potential flaws were introduced in its error
handling.

First, if nilfs_segctor_begin_construction() fails while creating the
second or subsequent logs, the log writing function returns without
calling nilfs_segctor_abort_construction(), so the writeback flag set
on pages/folios will remain uncleared.  This causes page cache
operations to hang waiting for the writeback flag.  For example,
truncate_inode_pages_final(), which is called via nilfs_evict_inode()
when an inode is evicted from memory, will hang.

Second, the NILFS_I_COLLECTED flag set on normal inodes remain
uncleared.  As a result, if the next log write involves checkpoint
creation, that's fine, but if a partial log write is performed that
does not, inodes with NILFS_I_COLLECTED set are erroneously removed
from the "sc_dirty_files" list, and their data and b-tree blocks may
not be written to the device, corrupting the block mapping.

Fix these issues by uniformly calling
nilfs_segctor_abort_construction() on failure of each step in the loop
in nilfs_segctor_do_construct(), having it clean up logs and segment
usages according to progress, and correcting the conditions for
calling nilfs_redirty_inodes() to ensure that the NILFS_I_COLLECTED
flag is cleared.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Fixes: a694291a6211 ("nilfs2: separate wait function from nilfs_segctor_write")
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: stable@vger.kernel.org
---
Andrew, please apply this as a bug fix instead of the one dropped
recently.

This fixes error path flaws of the log writing function, which could
lead to a hang due to the writeback flag not being cleared on folios,
and potential filesystem corruption due to missing blocks in the log
after an error.

v1->v2: fixed a regression that caused unexpected cleanup when
        handling an error at a stage where no logs were ready.

Thanks,
Ryusuke Konishi

 fs/nilfs2/segment.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 0ca3110d6386..871ec35ea8e8 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1812,6 +1812,9 @@ static void nilfs_segctor_abort_construction(struct nilfs_sc_info *sci,
 	nilfs_abort_logs(&logs, ret ? : err);
 
 	list_splice_tail_init(&sci->sc_segbufs, &logs);
+	if (list_empty(&logs))
+		return; /* if the first segment buffer preparation failed */
+
 	nilfs_cancel_segusage(&logs, nilfs->ns_sufile);
 	nilfs_free_incomplete_logs(&logs, nilfs);
 
@@ -2056,7 +2059,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 
 		err = nilfs_segctor_begin_construction(sci, nilfs);
 		if (unlikely(err))
-			goto out;
+			goto failed;
 
 		/* Update time stamp */
 		sci->sc_seg_ctime = ktime_get_real_seconds();
@@ -2120,10 +2123,9 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 	return err;
 
  failed_to_write:
-	if (sci->sc_stage.flags & NILFS_CF_IFILE_STARTED)
-		nilfs_redirty_inodes(&sci->sc_dirty_files);
-
  failed:
+	if (mode == SC_LSEG_SR && nilfs_sc_cstage_get(sci) >= NILFS_ST_IFILE)
+		nilfs_redirty_inodes(&sci->sc_dirty_files);
 	if (nilfs_doing_gc())
 		nilfs_redirty_inodes(&sci->sc_gc_inodes);
 	nilfs_segctor_abort_construction(sci, nilfs, err);
-- 
2.34.1

