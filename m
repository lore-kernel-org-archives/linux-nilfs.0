Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841F42FB969
	for <linux-nilfs@vger.kernel.org>; Tue, 31 Mar 2026 00:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917984; cv=none; b=VnP2CH/yYUrXycfOOmi0T72Uu+N1ZXdwKfHXD93Jjs7CdlQzwGYz4Oq7iDzNA/hHxc/mY+2Cgi5Pcnjf25ZWbdQdmprB0BzelhL6IwOrHGYE8VHviVcKrY90A4zzAL101V3rcxb6Klb7YEB1a5qqGoX5syfc/awzd/WcEmNV9Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917984; c=relaxed/simple;
	bh=szY4mNjBwA4sXA35aXtFtA1syL8zW/DsCNugR40jNoM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IUiLFPt10/LYeEI4p2ilXNBd7wPGVnvEfnXUa1qwpaduYZ9LfLuddPKewfMwkKByuvzS+UDO5YUmxztlZ8SuR3CcEoNpc8U7fCx+EWbkw2VKSjndcW0Eji3dLjG+leFugF4hNVj5esAsENpoVasTnwUMvvv/tfLLuQH9fOO0BWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ryMpQalb; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ryMpQalb"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c70bfef17a4so3716431a12.2
        for <linux-nilfs@vger.kernel.org>; Mon, 30 Mar 2026 17:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774917983; x=1775522783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LECHvJZc33MhPE+YpDHyc2MU3obeNqRtjSr6EjmaShM=;
        b=ryMpQalb/x2MBB8GNRBxdcZ7ac4hfMf2vYsp0dHrvlDktpvsXXygW09nJZ6E5B9aG3
         RTVGPdHQkCPjxYbpTILEAXoN879Nh4NqTrgi5L9Ynmwu9KlcMEX3PzsHjosQez74Pq/9
         mAUzXMVblVsMg/tSTPIXclfsieLGzskX+aH7irG5mhCFcYfbhzuCxfaMigjoAvwMdtyD
         WcMucRab+LF3k1Tz7AR4jQqxCfbmlyCtQ9JerXWBBAQm17dmI1RXHtjxMvGcguByqoY2
         WvBQOhNsEeW2mvmApEVVCEDr/YEtOqGtkapcry8pHU6eiieKmEUAk8s6OU/GpHDmbVtQ
         4HHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774917983; x=1775522783;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LECHvJZc33MhPE+YpDHyc2MU3obeNqRtjSr6EjmaShM=;
        b=SrQKfptLL/Y3/1iEdxz3wokKZBeaF1Tpilx9Kr9tqKEEEyFlnv/wJ+7UZVAOtgF4BR
         20lWY2rmvaQOf8hQm5y2+D5ED792jJ92pHD4baevQTMb+j7AV/qtmJTwbewOPYD4yBtU
         BLSrWfCjk9GjIIQjrFUPAZOACdoeFBUaIBX9W1cO5jwg0+DBRBcN8rBKQor4d+3Gd0TR
         ikKtolSRgEYGzZjBRR0oomrAnSh0i5cXDoiL0654JvhBSLo+o1HeqoHENWJO34//uwxA
         g+9fc9hwZIeKi/VNWOkVsTEvdJhzF42HAltOr+qBkiJ7xlEdXO2HPHfpXBd5OxrPApdY
         qCBQ==
X-Forwarded-Encrypted: i=1; AJvYcCV75/1osg5mKjaRaI15mz5/gcS8jab0LI2o8PtXLGpnjQ36tbaZxZW9tjcSNDboa7XItAy4D/O/VgbgOQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyFEhnrfhruVlxx0rlNdMuXTZxuJOe+H9MMfa9a4OeWZlgPhAHM
	M8duc10fQbpxOZRgNL/kJ3VibMzIHDcMpBduM/6D788VYNCB41Ay1U0f
X-Gm-Gg: ATEYQzwD+GdY2MnLeaenPIVY3L+9F0cVBbBbZHqECDwb/eCWH/G7kryWv5rcC/RFYau
	LpLtbpMEzXrS7RCQTUzDr49WUDq8+FAtZJc/mPIA+X3X37rT4MTBDOv3Jnn5NsHasJQePpFjs2T
	kCC6gxPmTq8wF6JSnpu87LLMUV4iOHvALwkF0A0XKoh8DtfWqynKP+vd00opHF5LfiXxFyzY8Fr
	+92cPvZbYbJhCT+bh1h8G+i1Ld2Y3LSOz/JcEAGpZiqDiCM5/2GJ8D8BUA/VoxuLeaJ7dNkcpja
	SQwTII6eBhmBN4F9Sl16+xJLoIq70/odLaz2YQnp813OynPvFUeXCPlfrDPBKNhIPyhYiWaY/IA
	3SaerPMb/DmG3tw8i5mSm47lKzfVOw6oyb7yJOZa2t1xboOVJx1g/SXF5H/aKk62VcATqSXYwo1
	fpklZ3tB6aJNJ0eTkt0lKLRyX+NXTNbwh4qcO8zlhkgOcRH5+zhVUDB6Whha9I/9/4+c0dGTfA1
	9g7MWqycCrNbxgukg==
X-Received: by 2002:a05:6a20:e292:b0:39b:9644:6e93 with SMTP id adf61e73a8af0-39c8787d577mr15747879637.6.1774917982785;
        Mon, 30 Mar 2026 17:46:22 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:913e:67a2:7555:d878])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c769179e31asm7240696a12.17.2026.03.30.17.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 17:46:22 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: konishi.ryusuke@gmail.com,
	slava@dubeyko.com
Cc: akpm@linux-foundation.org,
	sato.koji@lab.ntt.co.jp,
	linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	junjie.cao@linux.dev,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+98a040252119df0506f8@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>
Subject: [PATCH v2] nilfs2: reject zero bd_oblocknr in  nilfs_ioctl_mark_blocks_dirty()
Date: Tue, 31 Mar 2026 06:16:13 +0530
Message-ID: <20260331004614.385712-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nilfs_ioctl_mark_blocks_dirty() uses bd_oblocknr to detect dead blocks
by comparing it with the current block number bd_blocknr. If they differ,
the block is considered dead and skipped.

However, bd_oblocknr should never be 0 since block 0 stores the primary
superblock and is never a valid GC target block. A corrupted ioctl
request with bd_oblocknr set to 0 causes the comparison to incorrectly
match when the lookup returns -ENOENT and sets bd_blocknr to 0, bypassing
the dead block check and calling nilfs_bmap_mark() on a non-existent
block. This causes nilfs_btree_do_lookup() to return -ENOENT, triggering
the WARN_ON(ret == -ENOENT).

Fix this by rejecting ioctl requests with bd_oblocknr set to 0 at the
beginning of each iteration.

Changes in v2:
  - Instead of adding a continue statement after setting bd_blocknr to 0,
    reject the ioctl request with -EINVAL when bd_oblocknr is 0, as block
    0 stores the primary superblock and is never a valid GC target block.
    (Suggested by Ryusuke Konishi)

Fixes: 7942b919f732 ("nilfs2: ioctl operations")
Reported-by: syzbot+98a040252119df0506f8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=98a040252119df0506f8
Suggested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
---
 fs/nilfs2/ioctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index e17b8da66491..d25ba27b5203 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -736,6 +736,12 @@ static int nilfs_ioctl_mark_blocks_dirty(struct the_nilfs *nilfs,
 	int ret, i;
 
 	for (i = 0; i < nmembs; i++) {
+		/* bd_oblocknr must never be 0 as block 0
+		 * stores the primary superblock and is
+		 * never a valid GC target block
+		 */
+		if (unlikely(!bdescs[i].bd_oblocknr))
+			return -EINVAL;
 		/* XXX: use macro or inline func to check liveness */
 		ret = nilfs_bmap_lookup_at_level(bmap,
 						 bdescs[i].bd_offset,
-- 
2.43.0

