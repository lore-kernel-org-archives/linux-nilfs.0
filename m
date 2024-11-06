Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BF31C1AD2;
	Wed,  6 Nov 2024 02:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730859119; cv=none; b=ChFiVRp2XYkPu5BxHXkuOLkM472QkfFuow0Dci10vllg1qodXTMFWwUV3cZ6iZg8dqHWcIG8lmzLEo0eLXl3KzMQzbECPvpFMQtRdmAfDVbP8hyQ5t2H0hRUF6+IsliSgD17dVcrQcQZ4YMK3kuQvsvya9S1yilNzgSd3c0PiRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730859119; c=relaxed/simple;
	bh=k+7E2zyJ87EO3wjKg5cLr9eOYD5s7vCJPX53WjPth+s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QMivHyBPNAX0mVwpUjD1hw/5TDEAnBVDYbYfE+hy6JJYy5AA+JHrUB+OUu5mQw8XtGAAf8AW4hi7/vUrba6HmxWmKzxioqCp+yvyU3j48mECuuc5HUJ3yJHaRw5cdNjwAkL2a1VSWM65y0ABTQYkk79Gzhh9gENhVyGWrthPo+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/k58Tsc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/k58Tsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE35AC4CECF;
	Wed,  6 Nov 2024 02:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730859119;
	bh=k+7E2zyJ87EO3wjKg5cLr9eOYD5s7vCJPX53WjPth+s=;
	h=From:To:Cc:Subject:Date:From;
	b=a/k58Tscz8s/EN/gtyBb9PkIhvem8dPidOA4WaI5GSWqNca4gRzPGIw/bxY6S7OAa
	 N/HoH4HOXFXAcxMSLTBx1WfuqC2/vEhzfobaxtnvGU1fq/XjwNG7P+HJscZzg9jo8c
	 +zR0hMH3CswnUStgzfK3yJYHPRZ4USMmOaoOMPFiNG5A6NwX5AkxuSR3FyAhwlWwVU
	 IeLXNyMFnZkKHaHBT67vKzv+kkewftWqma9d8xwdych49w3fcfMRFnDr1RalwbyVLh
	 uIu5JutiOoCt/17KBBK9i7q6MjVj5GZUC1d5zIT5UQT9OSbvKJhg//hMZjSEnWHjqW
	 +ewm3Eh4bIM1g==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	konishi.ryusuke@gmail.com
Cc: syzbot+d6ca2daf692c7a82f959@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: FAILED: Patch "nilfs2: fix kernel bug due to missing clearing of checked flag" failed to apply to v5.15-stable tree
Date: Tue,  5 Nov 2024 21:11:55 -0500
Message-ID: <20241106021156.182576-1-sashal@kernel.org>
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

The patch below does not apply to the v5.15-stable tree.
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




