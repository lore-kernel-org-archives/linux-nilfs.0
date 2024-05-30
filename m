Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9075C186E57;
	Thu, 30 May 2024 14:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717078563; cv=none; b=LWq9d97fDDcP0O2whDJsmct8mCKMl8HFXgEzzWvC9AEJq3GLUZBYm5z4loeJsGip7fGQhsXXYDl6bODndUg1axBLHVy1FQSYd0Mx00U/O1paBIuZxCLdMADTTP1XKVRhP+7M9yJjetysxyz5D0OmO1wdssLhyngjkxNnHaLF37s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717078563; c=relaxed/simple;
	bh=eYDjkHMzZN4bT1iF4ma6alWdkJjbsBK42F15E8PeHMQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DQ42Hw46OOM5DjcSkBV8RBzBKaveKyF0+mSKHoKsCaZhv8AQHNyfkEAQlqxN0QVOj9dLw761f8EhkOkIF3mHZPVHbZv12azwaojcVxNZOf5S5vbwUCPx0BdA7R0bNn6zCPOrH65+hnTh0+22GbvsBhAHmFU+ejLhqdQqpaf2aZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UcUICF0W; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UcUICF0W"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1f47f07acd3so8377725ad.0;
        Thu, 30 May 2024 07:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717078562; x=1717683362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VMkhjE61Vc1NS7D/6XyyeGHdm9O21TTgPnUhmBGVGKE=;
        b=UcUICF0W+KUqWOod8EtQBCj1Cv6WzHVFqO1wZV5SgehyqUKAd+3neVLwUZeOuqUEKj
         jjex51rEPEYUe+7y/nsC9ZHntXR/7pbO+OiEkq4N58AQ3zT0/sZt9RWubRYHZq42Z6fQ
         daj6yRlGKqeMhOrDESl21If/0yXk+QusT3Cc3A6+u+23FiVIdVJ8As7NmxygEnFU+VVn
         mbB+Gd+Kd2p/wZj+tzv9Ep6564q9ATgpLBlAQR3bHkFDzNqLsduv1vIvKwanIsnPS/My
         T/hQuVUS5LPwQV9Db6gHC1xFPZmadE0G31yh0XuZzz4ZBBXMtqUCkyB6F6BMv/kjqKm5
         9sVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717078562; x=1717683362;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VMkhjE61Vc1NS7D/6XyyeGHdm9O21TTgPnUhmBGVGKE=;
        b=AqRKvlLpho29df/hM8dqXIE4laAhlhLWtu3qA/3wfVCbhFDD+K15ZP5wDWr3xbUNO/
         LAyY8pbFkMx9ixEkZXVFOVwI4IwK0kgX65gctVJD2JzDAf5nfIxn6/UQoTN/oCLU7+9P
         VCrtNjT/iAN+rV5fzZWV89pSQ285exkvcgWfHqh5XW5vy7YadPIsTeK1ZGED5UI6FDPY
         55l4Wwm6SQ4oFDpQ+JNy7LUHRZHnDIoG4DyTco3F27JZzQ4UV2OyI+/sXZWA1cCJG5wO
         xIR7S/rcTArfq021VZppZdB7S0qMrGCvsXLzlM+liNtF35CJMrTdbcL3TiSGhKdCmhgQ
         MGwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyPmo8I3iO6h1Aot9ArW5OZfFcVEIhmi6BjlflMTG1SvKQZhNFT/EyVgYFiB/A1AFRCOYuZNlzRbaeVgn6sOnrHSApopOB2NhWcCoe
X-Gm-Message-State: AOJu0YxTiVBHCNVte1yvbPwurWqmKwTVVA9zdLi7y/+BnEAxiBpg5FO6
	zfcr+umAocmKrC7BmZHyzyWBlR+F449ocNb2TUuB2eezVo9AHQvpTDsehw==
X-Google-Smtp-Source: AGHT+IHncuNc74TfFe4Ql+CLOymCt2oA5e2Wx4wpuJpKFtaqRkgkOkjw0olzpWf1tSjWsEUZYNOBgQ==
X-Received: by 2002:a17:902:ea07:b0:1f4:a6cb:db3d with SMTP id d9443c01a7336-1f61973ac5emr23204175ad.44.1717078561680;
        Thu, 30 May 2024 07:16:01 -0700 (PDT)
Received: from carrot.. (i223-217-95-32.s42.a014.ap.plala.or.jp. [223.217.95.32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c9d89b3sm118848285ad.292.2024.05.30.07.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 07:16:00 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nilfs2: fix potential kernel bug due to lack of writeback flag waiting
Date: Thu, 30 May 2024 23:15:56 +0900
Message-Id: <20240530141556.4411-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Destructive writes to a block device on which nilfs2 is mounted can
cause a kernel bug in the folio/page writeback start routine or
writeback end routine (__folio_start_writeback in the log below):

 kernel BUG at mm/page-writeback.c:3070!
 Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
 ...
 RIP: 0010:__folio_start_writeback+0xbaa/0x10e0
 Code: 25 ff 0f 00 00 0f 84 18 01 00 00 e8 40 ca c6 ff e9 17 f6 ff ff
  e8 36 ca c6 ff 4c 89 f7 48 c7 c6 80 c0 12 84 e8 e7 b3 0f 00 90 <0f>
  0b e8 1f ca c6 ff 4c 89 f7 48 c7 c6 a0 c6 12 84 e8 d0 b3 0f 00
 ...
 Call Trace:
  <TASK>
  nilfs_segctor_do_construct+0x4654/0x69d0 [nilfs2]
  nilfs_segctor_construct+0x181/0x6b0 [nilfs2]
  nilfs_segctor_thread+0x548/0x11c0 [nilfs2]
  kthread+0x2f0/0x390
  ret_from_fork+0x4b/0x80
  ret_from_fork_asm+0x1a/0x30
  </TASK>

This is because when the log writer starts a writeback for segment
summary blocks or a super root block that use the backing device's
page cache, it does not wait for the ongoing folio/page writeback,
resulting in an inconsistent writeback state.

Fix this issue by waiting for ongoing writebacks when putting
folios/pages on the backing device into writeback state.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: stable@vger.kernel.org
---
Andrew, please apply this as a bug fix.

This fixes a kernel bug that is reproducible in some destructive testing.

Thanks,
Ryusuke Konishi

 fs/nilfs2/segment.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 60d4f59f7665..6ea81f1d5094 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1652,6 +1652,7 @@ static void nilfs_segctor_prepare_write(struct nilfs_sc_info *sci)
 			if (bh->b_folio != bd_folio) {
 				if (bd_folio) {
 					folio_lock(bd_folio);
+					folio_wait_writeback(bd_folio);
 					folio_clear_dirty_for_io(bd_folio);
 					folio_start_writeback(bd_folio);
 					folio_unlock(bd_folio);
@@ -1665,6 +1666,7 @@ static void nilfs_segctor_prepare_write(struct nilfs_sc_info *sci)
 			if (bh == segbuf->sb_super_root) {
 				if (bh->b_folio != bd_folio) {
 					folio_lock(bd_folio);
+					folio_wait_writeback(bd_folio);
 					folio_clear_dirty_for_io(bd_folio);
 					folio_start_writeback(bd_folio);
 					folio_unlock(bd_folio);
@@ -1681,6 +1683,7 @@ static void nilfs_segctor_prepare_write(struct nilfs_sc_info *sci)
 	}
 	if (bd_folio) {
 		folio_lock(bd_folio);
+		folio_wait_writeback(bd_folio);
 		folio_clear_dirty_for_io(bd_folio);
 		folio_start_writeback(bd_folio);
 		folio_unlock(bd_folio);
-- 
2.34.1

