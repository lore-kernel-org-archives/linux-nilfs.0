Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE34364A0;
	Wed,  7 Aug 2024 23:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723072069; cv=none; b=P1VtqeKhSeN6En6655kDDl0c2NVDHA7My267xFbsdtarVI/Cu9uidhl2Ww3ZVC7z1BV1bm9EtMLpD+H4KcGpuaHnCBiI/7RKkSPt6Aleweo5qYui8EfQK1c7ip2DNpdHoybLet9vXTU9sjtqhuQPV22ox0DkmaYtlws4JEdQDvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723072069; c=relaxed/simple;
	bh=QFdGDo42xkMzLQ888Gr0OEbavqEArnt+H5CQVqXMwyQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jCpI2x1SYQYg1hF+Jyu66haKXU1RqZkv2Qgrbw/K4A+OFerJGhyP/3G9PhSO1wNWTFNTJ/TXHFCA8vQuxcUitDpm6FDsRRyj9apwMyTngpA6Msoj856nC7hzMeLeNGxD0rQj+FwJIX7rAoLJKE36LvmM+DuU8z4kaldwcfzaSCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EYrq3A7D; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EYrq3A7D"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2cb55418470so368300a91.1;
        Wed, 07 Aug 2024 16:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723072067; x=1723676867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rkMTCVGBwPmwmtxlY3yv9Iichvp/gtKA7mIwg9HUlL0=;
        b=EYrq3A7DilUKvSECLMqM7jWH8z6kfA9S9hbn0U26Fhlcr4YA/YXB5bVmTY2hCaENmY
         vAchdHjwLs8lozrchD/lPL68btgqWKHIqZg3K9mzhfnchpHOJUm/JkaXHbwn3z44wF8+
         AgBjm/0krLs63GMf6vAq/u66hcuEnQUAIYhBugY5RuNq3fAd57Erb98ejoXbcf77YoEu
         Fgmz/5UncWtcA0YkIl+wRQgLfei60F95wCQ6Kt/tTsspOcDZdRQOzlTa/+HFJvCp4ddu
         vtbX5+ooMhpRYsWW4TvFWgUFvfDLkX2+c3S8QWW3H44FDMu9lkgHcgDIB3QXFpdx3HqY
         9kIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723072067; x=1723676867;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rkMTCVGBwPmwmtxlY3yv9Iichvp/gtKA7mIwg9HUlL0=;
        b=Fruz28MUZp+UpnzJCsSbdOnLk8Ukjc/2ARdKjiUmApxbn15ykYkJCy9BjDZ0RumlAG
         nW9FDgNOLHcj/PUSINHOkM3AxP3StJMjiQwT5fS4JvM1QTlz91ai6SQxKICJhwOqnETo
         hbBei2g0gz87eZrxyIr2S5yDfCqsffSLIr/w/5VS3NKWlNAH5PYKfeO4flLmORy+FZ0K
         1ejWCj+uzGLHVLmakdvas+tv48BIL9yHU4mHfO4H69ir+IIiGVRJE87mLHzpMIwCq5kh
         Xm5np3hVj09C3lxfOIEWWT1m3cKnpZU9TmVWMisPciN91dXyImqH3gt/+6TiF/u01bSJ
         R56Q==
X-Forwarded-Encrypted: i=1; AJvYcCVGfNLDnjT6zFASsuNMnecSC2aSdNq7wMnMcJjHNJLzCsqMNL9w1hKghqponTG5bhbC2G6Scr/Ubf81dPiGKQp7lB+IVtg1v4KLHkzJ
X-Gm-Message-State: AOJu0Yyelqh+Ah3L31X8UXHL40tLIJ8W3HoyJuatkrBwrSC6DVhOMNnW
	/hAYJA07KIEKOl+9/wc3onDgycrCUKrsMgEYXYBEEq7tM6SIzTgJWHmJww==
X-Google-Smtp-Source: AGHT+IG/iDAQTfmE/m0J4jpOP5n3ZKSWdJ4Gq6ZyyfyI63IkOUdDgZav+BwtCtXquNtTmSipGd6GRw==
X-Received: by 2002:a17:90a:ea04:b0:2c9:9b65:af4d with SMTP id 98e67ed59e1d1-2d1c33705eemr140206a91.7.1723072066804;
        Wed, 07 Aug 2024 16:07:46 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d1b36da847sm2312080a91.32.2024.08.07.16.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 16:07:46 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nilfs2: fix state management in error path of log writing function
Date: Thu,  8 Aug 2024 08:07:42 +0900
Message-Id: <20240807230742.11151-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
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

Fix these issues by correcting the jump destination of the error
branch in nilfs_segctor_do_construct() and the condition for calling
nilfs_redirty_inodes(), which clears the NILFS_I_COLLECTED flag.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Fixes: a694291a6211 ("nilfs2: separate wait function from nilfs_segctor_write")
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: stable@vger.kernel.org
---
Hi Andrew, please apply this as a bug fix.

This fixes error path flaws of the log writing function that was
discovered during error injection testing, which could lead to a hang
due to the writeback flag not being cleared on folios, and potential
filesystem corruption due to missing blocks in the log after an error.

Thanks,
Ryusuke Konishi

 fs/nilfs2/segment.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 0ca3110d6386..8b3225bd08ed 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2056,7 +2056,7 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
 
 		err = nilfs_segctor_begin_construction(sci, nilfs);
 		if (unlikely(err))
-			goto out;
+			goto failed;
 
 		/* Update time stamp */
 		sci->sc_seg_ctime = ktime_get_real_seconds();
@@ -2120,10 +2120,9 @@ static int nilfs_segctor_do_construct(struct nilfs_sc_info *sci, int mode)
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

