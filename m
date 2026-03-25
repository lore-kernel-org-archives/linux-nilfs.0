Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053E327E049
	for <linux-nilfs@vger.kernel.org>; Wed, 25 Mar 2026 08:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774427750; cv=none; b=HX1rNUuLwGomBFsXwjIvA4KltvOhY8vDwj2aH0JHPRMn9CKOAfMlyRCuJbYRqkr+k859nUHvj89A65Kg9cRUFkEFA+3LFUaKJwn/qsLbuIIg3GMiFc+P8clQMaUDfHGkRE9PYO8vMle/YLjhH88xejKMDQVnzIelARji/YgazdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774427750; c=relaxed/simple;
	bh=6qSQFNasMVXYLMKeWajRh7qvwpK9h4LTtPHXhLG2LUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7DG6bryziZcSBGm8+d6PQPIxI9BPNr3qiWWvHJDeQs0k7GeAkYRzNa8o7wva+qSVJlbA2QdIIIj4/RGERqhzXtOpruywWwUcgjvmlDN+dxjKtG9HlkgNlajLb1c7BM98YvMmHVsGcWhoiMVkqRVEY4EjeZUDFykL8bQ9VdWKWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lAwNRiCE; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lAwNRiCE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774427736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gLHVcGA6er5h67mQoiXCJ11evQL+AyiM8toagc3fS+4=;
	b=lAwNRiCE9G0FzjrDkVebjugRuQLevJFSqm69htyi3B0ZmZwzr7VTGArAv9ddXyFVD4xUeS
	kOLawiwg+zYLdUQZ3zbct+AByviXoUGNMzDHXUnshDaeBU2keOpkAKiKUG0ibPZB0xVpPk
	LEeyYai0hYaCUwmgopwiVgbfY7F73k4=
From: Junjie Cao <junjie.cao@linux.dev>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Koji Sato <sato.koji@lab.ntt.co.jp>,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+98a040252119df0506f8@syzkaller.appspotmail.com,
	Junjie Cao <junjie.cao@linux.dev>
Subject: Re: [PATCH] nilfs2: fix missing continue after -ENOENT in nilfs_ioctl_mark_blocks_dirty()
Date: Wed, 25 Mar 2026 16:35:20 +0800
Message-ID: <20260325083520.501618-1-junjie.cao@linux.dev>
In-Reply-To: <CAKFNMo=Z2wsL5za0VUeYh23nodPusUCC9WasSeR5BHc6tEBu1A@mail.gmail.com>
References: <20260319091930.1088735-1-kartikey406@gmail.com> <CAKFNMo=Z2wsL5za0VUeYh23nodPusUCC9WasSeR5BHc6tEBu1A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Ryusuke,

On Sat, 21 Mar 2026 at 02:32:05 +0900, Ryusuke Konishi wrote:
> Since this implementation interacts with userland GC, I will check
> whether this is a simple missing 'continue' statement or if it was
> intentional.

Both downstream paths have asserted on (ret == -ENOENT) since the
original commit 7942b919f732 -- initially as BUG_ON, later softened
to WARN_ON by 1f5abe7e7dbc.  If -ENOENT were meant to reach those
paths, asserting on it would be contradictory.

The original code appears to rely on the dead-block check
(bd_blocknr != bd_oblocknr) to implicitly skip the -ENOENT case,
which breaks when bd_oblocknr is also 0.

This same fix also resolves a related syzbot report that hits the
same root cause through the level-0 path (nilfs_mdt_get_block)
rather than nilfs_bmap_mark.  I applied the patch on top of
current master (bbeb83d3182a) and tested it locally against that
report's C reproducer in QEMU -- the warning no longer triggers.

  https://syzkaller.appspot.com/bug?extid=466a45fcfb0562f5b9a0

For that related report, when the patch is picked up:

  Reported-by: syzbot+466a45fcfb0562f5b9a0@syzkaller.appspotmail.com
  Closes: https://syzkaller.appspot.com/bug?extid=466a45fcfb0562f5b9a0
  Tested-by: Junjie Cao <junjie.cao@linux.dev>
