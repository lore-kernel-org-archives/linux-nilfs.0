Received: from fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.57.120.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4221FECBA;
	Mon, 20 Oct 2025 12:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.57.120.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760963212; cv=none; b=XiInlTmrKhYQdtlHYnBNnCkyS2aNW7mb9j7DGuLUgjKZDoNvIKYpbtwrkyXKePfz/DXvShgTYVh7yUk/Mt+qprtjcNMlZYLv1NlVJbYLmKybrORBOfM6c2a9iafZBk3b+I+f7PdP/TLdXughdQGQDfAdOQtQPdg8pUGsbzXXVXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760963212; c=relaxed/simple;
	bh=Hrml92hO+sHgfm80c2Sv139C3pR2KNsFNCr8GaVC08M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pC28zdf9y5w8Ki6Dhn9zXlgE1AcLykQrqoqSQKrHdBG16EIPDNJpicU/cGefp+3sZGVvXxSyLsC7jTcAvjvau7K+AiWLZyCp58+ukg4BkmJ0nWk0KdxRk0vTWLgN7fu46JZ+VLYARymeZbPuUwsR/hrorlDV6L1VqBP5HpuBTyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=Glxaqv/J; arc=none smtp.client-ip=52.57.120.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="Glxaqv/J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1760963209; x=1792499209;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kx5jVyu5oZ3p0Hh+shYGjcsfkk0CaJ+y6g0ZOwv4/CM=;
  b=Glxaqv/J619u1fDLs5cK1mIv0HruYbQmGBCBQ9N3oHjxk2bndUK+C4XC
   EZnfGb+kAU473vE4vhKl9gqA3PRZUVlZYOUZcntnPX5YLAJCMqzra8IYa
   2/tVR5TySM8ZQgDJBjDk6gMI5m28ruv0IbD/drU3hz+yBZu1Ms0K5xYXR
   UC40iJjzCGm4C8/ivTy+1pNh/BUPK2K4BOlUFPbio5AYeRrBoQCaTIS/G
   C4haDkHZY7PAhk1FLwEe9UGroshhWrdZ/ggd0m0DAIcgDhJEJ6AHXb4l9
   RLwxP3eXxm8RWW5Dd+bTbok/v0wNwHWk3ULLJwRQo6JMG8TFmjMaaDLg6
   g==;
X-CSE-ConnectionGUID: cKLDWJtZTeawHgQ6jj7fGw==
X-CSE-MsgGUID: heQ2jjnfQTiOkX+6fHNqJA==
X-IronPort-AV: E=Sophos;i="6.19,242,1754956800"; 
   d="scan'208";a="3774967"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2025 12:26:37 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:3361]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.15.203:2525] with esmtp (Farcaster)
 id e782b80c-d46d-437f-92e9-d119d216c6f5; Mon, 20 Oct 2025 12:26:37 +0000 (UTC)
X-Farcaster-Flow-ID: e782b80c-d46d-437f-92e9-d119d216c6f5
Received: from EX19D013EUB004.ant.amazon.com (10.252.51.92) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 20 Oct 2025 12:26:30 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D013EUB004.ant.amazon.com (10.252.51.92) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Mon, 20 Oct 2025
 12:26:26 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <nagy@khwaternagy.com>, Ryusuke Konishi
	<konishi.ryusuke@gmail.com>,
	<syzbot+00f7f5b884b117ee6773@syzkaller.appspotmail.com>,
	<syzbot+f30591e72bfc24d4715b@syzkaller.appspotmail.com>, Andrew Morton
	<akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Luis Chamberlain
	<mcgrof@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-nilfs@vger.kernel.org>
Subject: [PATCH 6.6 2/2] nilfs2: fix deadlock warnings caused by lock dependency in init_nilfs()
Date: Mon, 20 Oct 2025 14:25:39 +0200
Message-ID: <20251020122541.7227-2-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251020122541.7227-1-mngyadam@amazon.de>
References: <20251020122541.7227-1-mngyadam@amazon.de>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D013EUB004.ant.amazon.com (10.252.51.92)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit fb881cd7604536b17a1927fb0533f9a6982ffcc5 upstream.

After commit c0e473a0d226 ("block: fix race between set_blocksize and read
paths") was merged, set_blocksize() called by sb_set_blocksize() now locks
the inode of the backing device file.  As a result of this change, syzbot
started reporting deadlock warnings due to a circular dependency involving
the semaphore "ns_sem" of the nilfs object, the inode lock of the backing
device file, and the locks that this inode lock is transitively dependent
on.

This is caused by a new lock dependency added by the above change, since
init_nilfs() calls sb_set_blocksize() in the lock section of "ns_sem".
However, these warnings are false positives because init_nilfs() is called
in the early stage of the mount operation and the filesystem has not yet
started.

The reason why "ns_sem" is locked in init_nilfs() was to avoid a race
condition in nilfs_fill_super() caused by sharing a nilfs object among
multiple filesystem instances (super block structures) in the early
implementation.  However, nilfs objects and super block structures have
long ago become one-to-one, and there is no longer any need to use the
semaphore there.

So, fix this issue by removing the use of the semaphore "ns_sem" in
init_nilfs().

Link: https://lkml.kernel.org/r/20250503053327.12294-1-konishi.ryusuke@gmail.com
Fixes: c0e473a0d226 ("block: fix race between set_blocksize and read paths")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+00f7f5b884b117ee6773@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=00f7f5b884b117ee6773
Tested-by: syzbot+00f7f5b884b117ee6773@syzkaller.appspotmail.com
Reported-by: syzbot+f30591e72bfc24d4715b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f30591e72bfc24d4715b
Tested-by: syzbot+f30591e72bfc24d4715b@syzkaller.appspotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
---
    Follow up fix.

 fs/nilfs2/the_nilfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index be41e26b782469..05fdbbc63e1f5f 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -680,8 +680,6 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 	int blocksize;
 	int err;
 
-	down_write(&nilfs->ns_sem);
-
 	blocksize = sb_min_blocksize(sb, NILFS_MIN_BLOCK_SIZE);
 	if (!blocksize) {
 		nilfs_err(sb, "unable to set blocksize");
@@ -757,7 +755,6 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 	set_nilfs_init(nilfs);
 	err = 0;
  out:
-	up_write(&nilfs->ns_sem);
 	return err;
 
  failed_sbh:
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

