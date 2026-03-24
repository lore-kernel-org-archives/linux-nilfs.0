Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF6D3E51E5
	for <linux-nilfs@vger.kernel.org>; Tue, 24 Mar 2026 10:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774349184; cv=none; b=OAG8DjX9CudaBxwY9T93rFqZOzKzPneYvdADEiIRK/nRgJE9t9ZrljFNy16K3dELTWYbZnLmAb6pu4Awzl9/tSLjzaRtklQOlB6n8C3LY9nXc4rdnZneyw4tj9R0ZZXSCvbjaGNm2WMrSlzx9ls75+bMl23kQGC0XZMplKp/N2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774349184; c=relaxed/simple;
	bh=SJBtwzFKz9LTfTysUSrYLmnlMLb8HFshNQlslEZDK80=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GSafB8hVW7f9AOfQrnMrZX1keOVV/v6Rpz0YDHehKYWRyqVKHyTcD9BpemGOEptpQDTFmiJ79sq6M7JDgkS5M1+DidS9R5QTuXP44pObZo1sqVSWBc23RJQBcEzXn3Zdtmcrh+/DpVKLqrirssHW4FnxY0LTdK1hR4mZQP+9eOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Pjre0K3L; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Pjre0K3L"
Date: Tue, 24 Mar 2026 18:45:59 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774349177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pkji2R9FeYSO37ALO1T1nPzc7U9/qqFRpEEZ+KP4TMo=;
	b=Pjre0K3LzK/Qyz21BPAUqLbYtmUOzQtQQANe2NSwiOPDJV8R9z+7Em+65pX06FMMNgAAYJ
	SRpPC5fsnK1piPZpROLaIc6P4/xEAwh6MmDRFzBSuTxTz431WHIakUa6K0e3BlaZLTY3he
	FgPHuJ+M5WoqXfQDjC75W27kGiRv+O8=
Message-ID: <65f731a33b7f0f5e26bf288505694c9a.junjie.cao@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Junjie Cao <junjie.cao@linux.dev>
To: syzbot+466a45fcfb0562f5b9a0@syzkaller.appspotmail.com, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, syzkaller-bugs@googlegroups.com, Junjie Cao <junjie.cao@linux.dev>
Subject: Re: [syzbot] [nilfs?] WARNING in nilfs_ioctl_prepare_clean_segments
In-Reply-To: <69c08e14.050a0220.3bf4de.008f.GAE@google.com>
References: <69b8c9a9.a00a0220.3b25d1.002a.GAE@google.com> <69c08e14.050a0220.3bf4de.008f.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Please test the following patch.

From: Junjie Cao <junjie.cao@linux.dev>
Date: Thu, 19 Mar 2026 00:00:00 +0800
Subject: [PATCH] nilfs2: skip blocks with no bmap entry in
 nilfs_ioctl_mark_blocks_dirty()

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
