Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1D93EB7F4
	for <linux-nilfs@vger.kernel.org>; Sun,  4 Oct 2026 23:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791156912; cv=none; b=WscPAY+dEeZVWhU2UiJfPGKpEPSc1lWpbn+eo16cfVGMQS8aAks4iepjtMU9rJjR2bT0PuvJ2DyuoY5S280UpIM9pLpeC4NrWA1Mil/lAC19v567gMXLQf8f06mm8J+ZMwbWJS/dtjQmuYVh1lGXQet/qxmBGa2apz2UZHPl8h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791156912; c=relaxed/simple;
	bh=agn/G9mTJy0n8+UIRRMgHsHvHBt/hWBfv5LbPKPmUGo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uoXg2yQ8pbfOdYLeasGNmfZ6u+tXVcf3+yINIz36PI0Hi87raA61evI7hEnVL2pocuyjlySEfcnWEl49/Icnb5SDAMkr8jxhzjNp27qy88/1tUDisv4tv9Q8lFl9V1KsOwrjBRyvyi3rRsUU8L78w0uHu6Taf3eQQTlwkpXeCXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=skNbuxTx; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="skNbuxTx"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396ccafb751so411647a91.2
        for <linux-nilfs@vger.kernel.org>; Sun, 04 Oct 2026 16:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791156910; x=1791761710; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i3ss4x2XY1NtegOb+bi9AVH4a9A9wdpQ5aQv2P3PhMI=;
        b=skNbuxTxjfjT+e8OXvDAMjO2U6kkMBZGrdGBSEVNDEZjZIPbNp5SBT8jtN43DQI/rM
         5h80GjK0s3Luhqm5RzxtDAPMgNF/XbNZJ2mJXidBAEXXAb87g6tOnVjICqioXzBpzkdZ
         vKtVDB7vCn51mU8q6U/MnhoDOlqwIgJsdW3ihUKiehembyXHrBZsSbnbi0S5dw1EiMnl
         e1p/GsOcyYL4VUhrMOXAMeNhRi0ylKYGvEpBMy6LAguQx0h+hLgtS1plqpEMrfzysI4o
         AQwJAW3Ka634Bo0ggPRXG8cXmpbIqQeBBa350h7YC3npNq37BkV0JUKuHJct9r84Bnqk
         /1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791156910; x=1791761710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i3ss4x2XY1NtegOb+bi9AVH4a9A9wdpQ5aQv2P3PhMI=;
        b=QN9NKMwmcAbgkuZ7bAIWLgyVY7Ks/MYT/HFFQdfeOlwzTa+oJXXd/FTiPSaPak/3WP
         rl9NuWV040H5lmQ5XHDOMFa704FgfPgMc1B8YT173IjVtWQiuZqw3pOjpl69dxjNDLOl
         dEsahcdjJV+tU6LQZWNvGdTjjnTyw2JieZJx1y2UQE3AZ6gF3EjbahI6flM/gJ/BJepp
         8UWx7J5kzjSVeuWfC0ng9gSFTGYISrNT2feIwCpHMkS/l9UN4Zz2ffOBWLd4z/ymknr8
         Jgbx9ZgLVgoFGnyatXlgF8yBbaLcgkAIBZqAbTgTzCtoogKEeexE4SG3s7NO8PVMztLP
         6t+A==
X-Gm-Message-State: AFq9FYKHxedGFsxkRH0Sv7CfiL2XZXFC6wzPLP08/cA6VQhSkaNQhzAT
	8tFpsYyUKX/c2cd225sy1+aZS05hPGjAyZi0GVlrK/jtyuFVtbiPQUghEl84DKpi
X-Gm-Gg: AYBFou12qbJHcdXlT9RyB2vEi9mpDjr+OV8cdjnd4vUD/Hp+baIj9EWeoVw3g186bLJ
	zz9b5V3ivfAJKgYzepA5MEmJJRK/AXavh8rKhhesKWl74qa5umtzLMUdtaB6bRnpJLuXY6IrMVY
	En/oRLYaLm09lNgli8CL1KpVp2V2P9qs54l20O4/TQ+7oz7d6fKC42HM8uZk7pi7PW+Y1lO4hJp
	3A9IuHyckUuhwYKMOjJ7I2oPvL18XQRSqVbSOkOgnmuWBZ55ZyiLK1dqueMHsOsqdsjrj0OYOGr
	BTG5SA6w+XTxUhfKD0mFU9LEE5Gcp9Jk9n+bKeRfFcAHZtzAJeH5/w79wxRlgOQ2CpfwlFTAQAa
	bLTnx/rilsr3lkILW/DA1qY/p3LJIeMkxKMSoTpn4qrKOojMWVtlGtLgY+S4eX6gVmQ1jBLg+2D
	7+VMBGl7NArmbdBgqPh/pG4Ravd+dWqeZSwDTyv6oep7HX41WTJs+1Et67VPqjZ634ZZREYzK1t
	TYLR5iL2VJhqkq/LkS3bBpdbZOI3EhmHYJRUU6ixoU=
X-Received: by 2002:a17:90b:17c1:b0:3a8:13d6:f740 with SMTP id 98e67ed59e1d1-3a813d7aa24mr202013a91.22.1791156909970;
        Sun, 04 Oct 2026 16:35:09 -0700 (PDT)
Received: from carrot.taila25129.ts.net (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78daef465sm8810002a91.1.2026.10.04.16.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 16:35:09 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] nilfs2: simplify nilfs_mdt_writeback()
Date: Mon,  5 Oct 2026 08:31:06 +0900
Message-ID: <20261004233506.20802-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The writepages() callback for metadata files, nilfs_mdt_writeback(),
calls nilfs_mdt_write_folio() for each dirty folio via writeback_iter(),
where read-only superblock checks, folio dirty state clearing on error,
and triggering of the log writer via nilfs_construct_segment() are
performed.  This helper function is used nowhere else.

Executing these operations per folio is inefficient:

- Checking if the filesystem has fallen back to read-only mode is
  repeated redundantly.

- Calling nilfs_construct_segment() inside the per-folio loop causes
  redundant log writer invocations for a single sync request, where only
  the first invocation performs actual log writing.

Unfold nilfs_mdt_write_folio() into nilfs_mdt_writeback() and consolidate
these operations at the function level.  The read-only check is moved to
the top of nilfs_mdt_writeback(), replacing per-folio
nilfs_clear_folio_dirty() calls with a single nilfs_clear_dirty_pages()
call to discard dirty pages across the mapping at once.  Additionally,
nilfs_construct_segment() is invoked once when 'sync_mode' is WB_SYNC_ALL
and the mapping is tagged dirty.

With these operations consolidated outside the loop, the remaining
per-folio actions (calling folio_redirty_for_writepage() on already
dirty folios and unlocking them) serve no purpose, so the folio iteration
itself is removed.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Viacheslav,

Please add this to the queue for the next cycle.

This refactors the metadata file writeback callback function,
restructuring an inefficient legacy function organization rooted in
the era of aops->writepage() to align with aops->writepages().

Thanks,
Ryusuke Konishi

 fs/nilfs2/mdt.c | 40 +++++++++++-----------------------------
 1 file changed, 11 insertions(+), 29 deletions(-)

diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index b50c88b65183..77dc2be2ce65 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -391,51 +391,33 @@ int nilfs_mdt_fetch_dirty(struct inode *inode)
 	return test_bit(NILFS_I_DIRTY, &ii->i_state);
 }
 
-static int nilfs_mdt_write_folio(struct folio *folio,
+static int nilfs_mdt_writeback(struct address_space *mapping,
 		struct writeback_control *wbc)
 {
-	struct inode *inode = folio->mapping->host;
-	struct super_block *sb;
+	struct inode *inode = mapping->host;
 	int err = 0;
 
-	if (inode && sb_rdonly(inode->i_sb)) {
+	if (!inode)
+		return 0;
+
+	if (sb_rdonly(inode->i_sb)) {
 		/*
 		 * It means that filesystem was remounted in read-only
 		 * mode because of error or metadata corruption. But we
 		 * have dirty folios that try to be flushed in background.
-		 * So, here we simply discard this dirty folio.
+		 * So, here we simply discard these dirty folios.
 		 */
-		nilfs_clear_folio_dirty(folio, false);
-		folio_unlock(folio);
+		nilfs_clear_dirty_pages(mapping, false);
 		return -EROFS;
 	}
 
-	folio_redirty_for_writepage(wbc, folio);
-	folio_unlock(folio);
-
-	if (!inode)
-		return 0;
-
-	sb = inode->i_sb;
-
-	if (wbc->sync_mode == WB_SYNC_ALL)
-		err = nilfs_construct_segment(sb);
+	if (wbc->sync_mode == WB_SYNC_ALL &&
+		mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
+		err = nilfs_construct_segment(inode->i_sb);
 
 	return err;
 }
 
-static int nilfs_mdt_writeback(struct address_space *mapping,
-		struct writeback_control *wbc)
-{
-	struct folio *folio = NULL;
-	int error;
-
-	while ((folio = writeback_iter(mapping, wbc, folio, &error)))
-		error = nilfs_mdt_write_folio(folio, wbc);
-
-	return error;
-}
-
 static const struct address_space_operations def_mdt_aops = {
 	.dirty_folio		= block_dirty_folio,
 	.invalidate_folio	= block_invalidate_folio,
-- 
2.53.0

