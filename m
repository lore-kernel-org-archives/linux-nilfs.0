Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E691CF2A5;
	Wed,  6 Nov 2024 02:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730858988; cv=none; b=K3o/gfvNEeDGsjemPQr1vgwWUnKLLcS8kPlp2SX2wnv6a8iFmy+8BgqslQLLVLzGc/0hcLjBe+KU+62VCW6fmk2hvTOcTKThFmrrZMD47/Ghw/whmqDVteJV5fSoeXnLl/iK9W9K1/0rA7L9r2s/+cnMcE7xx4HXdX2fRDr3AjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730858988; c=relaxed/simple;
	bh=Ze3uZ+nIk5OMTMG/Q231NOFs4pQu+2SRKm8T9nCRF80=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=syPmlZbJG3jlQdOXFkGhGEfoC+j+1W+7gyoYqpJ4IyBY59riiBjceQMFOe5TXn97khNbQ4jedtu6NLr+EVFj6Rv/t8uZNOuORH1hVt7iW+2sBA9q2d/xy2kCFzK5a524JrxGooe31ibCy2jEwfW2J6MZBxlIcRSSxay6vpA7OLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qm+otMio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qm+otMio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0E5C4CECF;
	Wed,  6 Nov 2024 02:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730858988;
	bh=Ze3uZ+nIk5OMTMG/Q231NOFs4pQu+2SRKm8T9nCRF80=;
	h=From:To:Cc:Subject:Date:From;
	b=qm+otMioORvglZyvfAM7xxEejLhB09+arBTcHgKv6tcPZI1dX6p70N17dZcaAZTgR
	 p8J3Y6rBAw4hfO77P5OTobKXdDDvQK2mlUw0TQgeesTSY59li0zDWEeQf7hNYJgADA
	 jpn8Zjhusl+5iWSWDqAR1J3LLPkRtGWWtGHXoidQ/f2Jpvcgwti+dLMcsxXaAVEJtX
	 yIuCIYoE0rDXtyqJrnYKD43E6wkzaIFM2UjQM0g19iWjTO+m7t9xZ3z7MpHpHRVZTc
	 onyYHLUOsg3p7p5NFj2DS6fqgTGtvXy6OzSWsbLoj9umIrQCNtMB6Sw4Y99I99yOb8
	 Hv7ouYnGbQYpA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	konishi.ryusuke@gmail.com
Cc: syzbot+d6ca2daf692c7a82f959@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: FAILED: Patch "nilfs2: fix kernel bug due to missing clearing of checked flag" failed to apply to v6.6-stable tree
Date: Tue,  5 Nov 2024 21:09:45 -0500
Message-ID: <20241106020945.172057-1-sashal@kernel.org>
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

The patch below does not apply to the v6.6-stable tree.
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




