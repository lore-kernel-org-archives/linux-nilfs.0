Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3493ED13D
	for <linux-nilfs@vger.kernel.org>; Thu, 19 Mar 2026 16:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773937364; cv=none; b=lbomGPPeKim46euLrn/58VZcycUbiS4v5xuBFYyZExWJcIvDH3IwNjKwrzwv0HYfqzoUF8BQX3GAo0Agtj4bACgkH5TP4OJg2aSFSoJbwcGkys/sjM6/hVveb6sRkJwMi52zNAT2DpaMs14kwmkFWh5KOdOp7FxhzWmaUWRrEeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773937364; c=relaxed/simple;
	bh=BnVx0e4sHUG2CxvPexFEtjwoJjLDYgxZk+AFIqdD7Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EaaVaXLzC8mRth2wU3m8vlZ8Iykh8e1ob89G9x0cdviFepffgiZwASl628KlBKXPYOUcK2E9dbF3YtwkNlbOCylyLpDL3XOtoY50M0Xz/N/pliKG3KmRzbpTGLzGvariD9R/P0UDmg+LtgbQWRIO3bz+pZjtEgfYdsTYuv2ya6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Sbw8KOHG; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Sbw8KOHG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773937350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=t0iie7bEOScOeBpsKCJ5AujwIH+1zOg24zDax1kXgG8=;
	b=Sbw8KOHGrxkAxghoE5N85VkV9v+aCyn3VtHcG6hfcyyaG9cynsR9ECTZLAz/8kPzFd++ip
	q+kj8uzvgUWxHCDtNVzCvzpdNGgi7SdcJESNL14RtsREbP645eLlbRz6oaD4dVOBwsYXNA
	fzYzn1+7fhGSwiZrcmmAcb/ZD7thuqM=
From: Junjie Cao <junjie.cao@linux.dev>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+466a45fcfb0562f5b9a0@syzkaller.appspotmail.com,
	stable@vger.kernel.org,
	Junjie Cao <junjie.cao@linux.dev>
Subject: [PATCH] nilfs2: skip blocks with no bmap entry in nilfs_ioctl_mark_blocks_dirty()
Date: Fri, 20 Mar 2026 00:21:59 +0800
Message-ID: <20260319162159.302104-1-junjie.cao@linux.dev>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In nilfs_ioctl_mark_blocks_dirty(), called during garbage collection,
nilfs_bmap_lookup_at_level() may return -ENOENT when a block no longer
exists in the DAT bmap.  In that case the code sets bd_blocknr to 0 but
falls through to the liveness check that compares bd_blocknr against
bd_oblocknr.  If bd_oblocknr also happens to be 0, the descriptor is
incorrectly treated as live and the code attempts to get or mark the
non-existent block, triggering a WARN_ON.

Fix this by adding a continue statement so that a block descriptor is
immediately skipped when its bmap lookup returns -ENOENT, since there
is no block in the DAT to mark dirty.

Fixes: 7942b919f732 ("nilfs2: ioctl operations")
Reported-by: syzbot+466a45fcfb0562f5b9a0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=466a45fcfb0562f5b9a0
Cc: stable@vger.kernel.org
Signed-off-by: Junjie Cao <junjie.cao@linux.dev>
---
 fs/nilfs2/ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 1bfe8a2..d71a0a5 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -744,6 +744,7 @@ static int nilfs_ioctl_mark_blocks_dirty(struct the_nilfs *nilfs,
 		if (ret < 0) {
 			if (ret != -ENOENT)
 				return ret;
 			bdescs[i].bd_blocknr = 0;
+			continue;
 		}
 		if (bdescs[i].bd_blocknr != bdescs[i].bd_oblocknr)
 			/* skip dead block */
-- 
2.43.0
