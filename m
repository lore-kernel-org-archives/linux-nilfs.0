Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50931E5720;
	Wed,  6 Nov 2024 02:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730859174; cv=none; b=QBeVJodFyDc2Rr1ctpcB9RkhkIRp6wTXshBQWmphFYwRIlksv6Tec/aU/aeJJQaQ9Az65O2zTVtCrc7xWufJILujZcEMX/UvVD3WfrN5j3CBU77YrsP8jlLMFYF4i4eDvRJCjd0zYdAP9rFmbZ0u0BD130XN4Awgcr2nuJx52q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730859174; c=relaxed/simple;
	bh=iz+aLTin03k74co6kq4ysfP5cYZkTNEZjC4ejTM5EHY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=si/2eKi0EV4+GhC7YSdsytH/s2xbY3xT53jsDe1hvA6/HIzQklYvwwPpA1gndPxb8gHfaW+keaysJgOs+wdWVUeDOe9ijo0ki/IQ0BmE/P0yHSykIiaNJaYhUBar4f0qANuJYCi9KqtarxMrw8UkFc9ihKROmeKKXMMz+Bq6wFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SbsjF0Ur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SbsjF0Ur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0D1C4CECF;
	Wed,  6 Nov 2024 02:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730859174;
	bh=iz+aLTin03k74co6kq4ysfP5cYZkTNEZjC4ejTM5EHY=;
	h=From:To:Cc:Subject:Date:From;
	b=SbsjF0UrETGVny+ykfhfdAnyDF+GxBpIS3+T1nJQNQ2AeKqeGq6wlvlrmeKWSwJFH
	 NFP8/8aZLMJFg2CgtEnvFJp6a6pwa3WaoLYzt+Qpw9yrSzpCHK/LCl7zFCQwGPmWVc
	 vk2QSHT3OEVxKvfUwggqp+YitIukXhY89fiyVrrGQCqBIFnQYQvJqM0YELFya7tH4R
	 rDhPEj4zlQtYIMApl4CdoBXLzb4JTS9G3cmgrew1JrjMo+0PGpFevNfw6GBkPIj7k4
	 5zNvMeL2c1sMyEGJXuhRcJ0s6a/Rj0T6U0iWiBErLd3TzePtmXT2Y2/rRCx4zoHl9X
	 Mc7mxamzJqKng==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	konishi.ryusuke@gmail.com
Cc: syzbot+d6ca2daf692c7a82f959@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: FAILED: Patch "nilfs2: fix kernel bug due to missing clearing of checked flag" failed to apply to v5.10-stable tree
Date: Tue,  5 Nov 2024 21:12:51 -0500
Message-ID: <20241106021251.183211-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the v5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 41e192ad2779cae0102879612dfe46726e4396aa Mon Sep 17 00:00:00 2001
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 18 Oct 2024 04:33:10 +0900
Subject: [PATCH] nilfs2: fix kernel bug due to missing clearing of checked
 flag

Syzbot reported that in directory operations after nilfs2 detects
filesystem corruption and degrades to read-only,
__block_write_begin_int(), which is called to prepare block writes, may
fail the BUG_ON check for accesses exceeding the folio/page size,
triggering a kernel bug.

This was found to be because the "checked" flag of a page/folio was not
cleared when it was discarded by nilfs2's own routine, which causes the
sanity check of directory entries to be skipped when the directory
page/folio is reloaded.  So, fix that.

This was necessary when the use of nilfs2's own page discard routine was
applied to more than just metadata files.

Link: https://lkml.kernel.org/r/20241017193359.5051-1-konishi.ryusuke@gmail.com
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+d6ca2daf692c7a82f959@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d6ca2daf692c7a82f959
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/nilfs2/page.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 5436eb0424bd1..10def4b559956 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -401,6 +401,7 @@ void nilfs_clear_folio_dirty(struct folio *folio)
 
 	folio_clear_uptodate(folio);
 	folio_clear_mappedtodisk(folio);
+	folio_clear_checked(folio);
 
 	head = folio_buffers(folio);
 	if (head) {
-- 
2.43.0




