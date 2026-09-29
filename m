Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0194438495
	for <linux-nilfs@vger.kernel.org>; Tue, 29 Sep 2026 06:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790664007; cv=none; b=PfyGJfkUnTNU/SgL9sBfWXgpVDef+KcnIA+wgjIYJnOw+eL8lwfllC+ha/dSzwWloaNngqyhpFbOYBtjhXe4r+EBmZhKXbtqSpNOP7LE5u5EGEEPoXWXiJ7H2DA9oR34AutDc/M47tuYUwOsYUD7i08P9pQkfP3jg1YMBsesrPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790664007; c=relaxed/simple;
	bh=3JlunrHqyztrQ7veCfAYW9Rl4uPOoncjuByHdtlErUE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S9AEQvjQfzNzai4RXGBEtgiI5JppnWNrVAOYdw5ewpvpKMxRzoV0GUZhCxI5IgpKJVw9J9jvptC47onk9hG999NgMLDKzk+1XWVeASEW/YxHxGqFLBPR55Ws5FnB/ljpLFn6uwk1yxrCiqs8Zbc12c65b05aoJreNnqw1nHr2jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lYr0DAjR; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lYr0DAjR"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4c3304784so1567284a12.3
        for <linux-nilfs@vger.kernel.org>; Mon, 28 Sep 2026 23:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790664005; x=1791268805; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jLr4PANduPccDTasGNzv5CyT3BFD1OzFG5Iqu7l6FvA=;
        b=lYr0DAjRi9fS7On2eaBKNEquhJyGXhVkqr3o80+fTE0ZIlaCNewhS1sZfX7EB+4Vqc
         zyGhAalfveeYWYOGOvDmqCYBgvSB1UQzb/T7kBnH1eBiAtyMJNP6/7jICd+5JiXs7UHi
         M7kPI20uj77Pw+m8MwqcY2G1/mBtXzngRcjatoJW6q8Po17C4f2Sr3BogoPoMXTqPc8l
         Ha+FSqFD/lITDp8VADm+ohped3q6LGIAlZIEswVG9oBAFOggjm+lRc5IXxt5MRJN/Usr
         6R4NHC24QnQDru/DxtDV9yBnNv5i6UroTDbsetON/kMhV3fGEH08nTego0wvvfadZeuF
         XC/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790664005; x=1791268805;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jLr4PANduPccDTasGNzv5CyT3BFD1OzFG5Iqu7l6FvA=;
        b=E5i4ly1mJcvJwpnsc+If7foSj++KK0f8PMTUNJ9bURuJboQaEspsTGLZ1ny8QfOa2V
         nji4i1hugRuYBHL+MN1YfrbOoMJrMwMAfe55I7pHlE/VDifWUGJNMWFLm8/DAqhmACn8
         ln9ISlQss2QjQYJ7b2xLMBA9yJHNqzWwQsaSA3yiHR/9ct2YGD3nvMmlz7/Sre9+aeUp
         brC6yrPnTSo9wY7swrEd1k4rJQnsnr/MBOUy+pYQKmc0HKtZ1PTOCmCmHE21ZAO4YN6f
         fpG1RfeZjCWulw57bPcAqsl6DBOvB/GD2fPRsnAoP+TRucBA9noRKAgIO7x/IzDo7bmJ
         dyNw==
X-Gm-Message-State: AFq9FYKneJpF3nHzjMJXe3+tvyFv6zvhQI9ZEW1ibhBpM4zxI5vNGBXm
	X4qOfQ2JVvq/oJxyVt8IZXL8B9xpGc+wYQFJvQ+3AmqoNFZIFoNVNW/LmnFIJRFd
X-Gm-Gg: AYBFou1WFgk3ABi/GeNW5ywBkGwueDLsZ+4PiSP930dzMoiiUypx2m627mTO/3eFLX5
	OoWJ0WTz+glN0a9d0WxOmMzuHAWHtPHK/CFInNhXfZk3oY7L36EMgz9K3wk5n4TKtHWPui45jEw
	93WBM0qJmWtq0D+cl3AWSemlREcA/Kbv+iYo/WjmcnMDpb9pMsSaQ441e7QWHyi2Ewg+jqjAS4E
	P43IAAUPpz/HyEIE/5V7fAAzkFdlZvl9FFvSUw4373gES851icz42Nv1NdvfmUOzWxEdk2PezvM
	JRvHCIZaYlDXMxJBSo6++x19MCBmWVdIu02MsA8ui5M+k2SyLz5UFLrkP5VQgDURH3ngPBP/ac0
	81hOl9XxnZqhnVlU7sQNMo6+JQcKsi4jDd2jExQtYvnh8ofU/yUr3TfdRtPFuDAAvyEZ40SOm4X
	YpoFqdfIkaBDnCu0BboZea/wQ/iIRCo1+bFSEXygpFe6JXme2SyYC5FLC7J8L+PYwElZxSvE4Sb
	d1dXdwJcihXIOHsA6w7N8edapbYUdeWlKWV9gkpVbsN
X-Received: by 2002:a17:903:2443:b0:2df:5b4c:b0d2 with SMTP id d9443c01a7336-2df7dc366aemr125018755ad.43.1790664004972;
        Mon, 28 Sep 2026 23:40:04 -0700 (PDT)
Received: from carrot.home.local (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df90fbb1f2sm51874785ad.1.2026.09.28.23.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 23:40:04 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] nilfs2: clear dirty flag on bdev buffers on log write failure
Date: Tue, 29 Sep 2026 15:38:14 +0900
Message-ID: <20260929064001.94261-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the commit referenced in the Fixes tag stopped directly calling
inode_attach_wb(), a dirty flag is set on buffers (with
mark_buffer_dirty()) allocated to the backing device for segment
summaries and the super root block during log writes.

While this dirty flag is cleared upon a successful log write, it remains
uncleared if the log write fails.

Consequently, when a log write fails, these backing device buffers are
left in an inconsistent state where their uptodate flag and the dirty
flag of the containing page/folio are cleared, but the buffer's dirty
flag remains as stale garbage.

Particularly when the block size is smaller than the page size, if other
buffers on the same page/folio become dirty, this buffer unexpectedly
becomes a target for writeback again.  As a result, if the block is
later reused for other data or metadata, that contents risks being
corrupted.

Fix this issue by calling clear_buffer_dirty() for the backing device
buffers when aborting log writes in nilfs_abort_logs().

Fixes: 68142cb628f7 ("nilfs2: do not call inode_attach_wb() directly")
Cc: stable@vger.kernel.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Hi Viacheslav,

Please apply this bug fix.

This fixes an omitted clear of the dirty flag on backing device buffers,
which could cause an abnormal buffer state and potential block
overwriting data corruption.

Thanks,
Ryusuke Konishi

 fs/nilfs2/segment.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 829573cb6131..2f0e59847d02 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1829,6 +1829,7 @@ static void nilfs_abort_logs(struct list_head *logs, int err)
 	list_for_each_entry(segbuf, logs, sb_list) {
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
 				    b_assoc_buffers) {
+			clear_buffer_dirty(bh);
 			clear_buffer_uptodate(bh);
 			if (bh->b_folio != bd_folio) {
 				if (bd_folio)
@@ -1840,6 +1841,7 @@ static void nilfs_abort_logs(struct list_head *logs, int err)
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
 			if (bh == segbuf->sb_super_root) {
+				clear_buffer_dirty(bh);
 				clear_buffer_uptodate(bh);
 				if (bh->b_folio != bd_folio) {
 					folio_end_writeback(bd_folio);
-- 
2.53.0

