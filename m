Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA836146592
	for <linux-nilfs@vger.kernel.org>; Thu, 29 Aug 2024 07:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724915770; cv=none; b=bQ4iM4yV0vM07ORtUUXn7fY/9MMgROBMzdggkw89DbkPc5PnV0kyPKloAh0Dw2wwwID2mByNI20OqK5cjV4z7c3WmofvvUVaMOiUuyY578CNAL66boUJTCGQwAyza9Arjt+zj/bEkch5ehwSSEuTZCuBKwc61T5GqtTHmcHrono=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724915770; c=relaxed/simple;
	bh=8BPOSniWHrQvyGuJwHUdifQmH4rIEpBku5MkeNEdRyk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cOnHRSh3x28Mhif0yVL9mxYCnReHG1F6XbQzf+zt+yIjE4vnMz3KdTb7i6e18nXqqV8vaUXqUvCDawTcmh2CYyCpbPOxpWbjZRFfjU8Vsf/NCQVOQ8+fPEyJRUYkpm+msmL+nOvHkHAKgq3cjxNUHAxCuWTrES9tXRCSG5Xp8Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BKdnPUrZ; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BKdnPUrZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724915764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=i0xeUGCoMFjPpXS2CoMByWeQ2WkworfO2h9ojNKikDc=;
	b=BKdnPUrZ6noU8tgVCXevmJGCnRSxEavE+YxglUD1ePg89mqvsqLcft0uTmhFdNSotZVHTP
	2rgD509Se+g8J6h6yUoGIVCZ+rVvfi8ZDEDTryqW8CvytdVAH1yFvIMiEh2hXJRFRUs+UW
	KvzNn1syB2z0v4PWwSV0IHuhNrbeE1Q=
From: Kunwu Chan <kunwu.chan@linux.dev>
To: konishi.ryusuke@gmail.com
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH] nilfs2: Remove duplicate 'unlikely()' usage
Date: Thu, 29 Aug 2024 15:16:00 +0800
Message-ID: <20240829071600.30706-1-kunwu.chan@linux.dev>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Kunwu Chan <chentao@kylinos.cn>

nested unlikely() calls, IS_ERR already uses unlikely() internally

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
---
 fs/nilfs2/page.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 7797903e014e..9c0b7cddeaae 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -262,7 +262,7 @@ int nilfs_copy_dirty_pages(struct address_space *dmap,
 			NILFS_FOLIO_BUG(folio, "inconsistent dirty state");
 
 		dfolio = filemap_grab_folio(dmap, folio->index);
-		if (unlikely(IS_ERR(dfolio))) {
+		if (IS_ERR(dfolio)) {
 			/* No empty page is added to the page cache */
 			folio_unlock(folio);
 			err = PTR_ERR(dfolio);
-- 
2.41.0

