Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB882F60CC;
	Thu, 25 Jun 2026 05:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782365282; cv=none; b=pwm5RnP1+M3fDZDQyJcRobENFJywaN/s0TZZgRIXG/p5mEFJ3SpTR48+MtoDuviYwGzer91Dm4NTulXNVCQSy+S6DIEqa3Ipds2cWF7PqWnJu9ckvsPvhW2+WVXoF09Gz1HWcTaPhVXhUn3Kh4FmMZj1vIo8J7yQZEaQ8NY5ML4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782365282; c=relaxed/simple;
	bh=yx2xSSebL2kDi8wFQ5wyICtP/W/c6IReecKeiVG+USM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pdz0oUYjtHPIdCEp4Fqq8gHUJtd1jIcMMjAozygNjc+H5OeDmBWutn83+rdZ6YUsm5U2v9oSf6TJSiRQI/dVbue/cLmo5xqezGuoGenmU6r9EYKZgpqyV9Nqy7TzKhpGrs4d3yxRm9fjEFtImRsyWdtUb8AqH9DfnXFjRRsYqzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=Zu3pH75v; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="Zu3pH75v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782365221;
	bh=xL+ZI1n+zrZCzD/gAd1Eaah64ySFkhNa1eYB6A9PJns=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=Zu3pH75vT3gRJRrfPssXlLdFvS5cL2DOb+p3BIKWUPdn3INzkwWL1D+MtsZQyNZVV
	 kEcXxZgrHhuhvzNeM9qsYVMvITZRo6TGPvrl8Rtca5Ec5/kQIxxJA4B86S1lLX57Ln
	 9gXjp+JhV6b9tvl+JYrzucazypEfQTsDrk4wl+HE=
X-QQ-mid: zesmtpgz6t1782365203t0a8c9468
X-QQ-Originating-IP: kcnXrezS6+FbU91fHR2K/g6E7ZfblFmnTeEWzgM+gR0=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 25 Jun 2026 13:26:42 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 8070513186128554390
EX-QQ-RecipientCnt: 7
From: wuyankun <wuyankun@uniontech.com>
To: konishi.ryusuke@gmail.com,
	slava@dubeyko.com
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+c37bed40868932d790e9@syzkaller.appspotmail.com,
	wuyankun@uniontech.com
Subject: [PATCH] nilfs2: prevent double insertion of b_assoc_buffers in dirty buffer lookup
Date: Thu, 25 Jun 2026 13:26:39 +0800
Message-Id: <20260625052639.241024-1-wuyankun@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: MsRmdYiYlAO2/ccPEdLtU5cetwLkzIUCTRVo/A162rVB7A8lcPJHmFnX
	DdBxwRWnMX5xRLd3N6EM3bUP/SBHao2nREWDP5fZk9Gf44LlMcFYqzzSDnIUUH7jTjiAjm6
	Z2JTadJjnm8vqFxQuG3EkCA/JnwrhhHmhejPtjxCZ8ok9qO/5AOTq/dfA3m3v/co4SUm+LI
	LkpLwfay/Qfsgid78V0JDket9tw1yC/t+egHxWgSf7fbUSIboVX8qBgyZwgdG+jOX8fYjud
	DSR7RmNfO/7C4gEjpv/uN9Zt0fdFHRbYUpAyT/S/emlAUUUHmq47VRYZdkOzTYjOFI/n94e
	oj2toSqedbUh4uwRBW4UkapwamqgkH0Y0r3QdFdcMD3gDxVlWL/wvpRQz4r8zomNgqOfn9H
	+djbxgm8I/80RpU7UbbOWuhlfVs1D+kjZvE8kmjal2M17a9tQ9NrRZIeeEK5ngWScjTrSWD
	DDo8dqZ9Zo16WRxpvkH/w0yPuDwdy6tgfexaJcres86zhMGdZUbyyLqQnnPD2S1U+0l0yUn
	SiPKQSXYjEPQ/M8ydPspRaNgF4IpbiKURbGXeAChad8cUUhq7wV191YIAcQhdkFjDGZgY27
	x1umNBCYZvfIwshw0168uvDNSeONneTsPWg0jglsoWH8wqc1kH81Ah69sSfIBpez6RW+TYP
	Cuo9fH+h7U4SboPcdJQ+ZuHXnNVBqW93gBuJhYapXh8NSmRm9a4JI+kcGJRDhbToOKyNq99
	Ykm3sOfutwS5U4KZbyihkCwlpRZMimjOXG/RYKNOOtcxOqJKgHIBqN6t1v4JnLFCTrpctuz
	TjiCSzQpZbqyy+BKXnnk2O/FEmB84fMGgn9sIiHZahBbA/y8WNjekqXgHx0J3qKDjulc3k8
	Uj6LFJDmktMb3U98pfkmExyy+dWqqikQftIvVkSzQrth0DfckS+iwKaEson75q6FrJTfMbD
	V1wgLBArSeHlErY3FxNuPUQZvSe4bJG9tJBfZBupX1Vnc21YinscJmv+5Q7RDht52tZEt4Y
	/qwkoFz6Jo2emkkDMl1lmNBpS+QNzaWtGtyR7sNpdzPCFUHUROcOC6Tc+KEt+MhXG1Nzvgf
	V5wGqMgv5rb8Um2u9yEMoK+NQxk7z1di6D7AMyDQb8XyPqeQfs8zp4=
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0

syzbot reported list corruption caused by double list_add_tail() on
bh->b_assoc_buffers in nilfs_lookup_dirty_data_buffers().

A buffer_head can still be dirty and not under async write while already
linked on another association list. Add list state checks before enqueueing
in both data and node dirty buffer scanners to avoid re-adding already
linked nodes.

Reported-by: syzbot+c37bed40868932d790e9@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=c37bed40868932d790e9
Signed-off-by: wuyankun <wuyankun@uniontech.com>
---
 fs/nilfs2/segment.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 1491a4d4b1e1..09202d155903 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -741,6 +741,8 @@ static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
 		do {
 			if (!buffer_dirty(bh) || buffer_async_write(bh))
 				continue;
+			if (!list_empty(&bh->b_assoc_buffers))
+				continue;
 			get_bh(bh);
 			list_add_tail(&bh->b_assoc_buffers, listp);
 			ndirties++;
@@ -779,7 +781,8 @@ static void nilfs_lookup_dirty_node_buffers(struct inode *inode,
 			bh = head = folio_buffers(fbatch.folios[i]);
 			do {
 				if (buffer_dirty(bh) &&
-						!buffer_async_write(bh)) {
+						!buffer_async_write(bh) &&
+						list_empty(&bh->b_assoc_buffers)) {
 					get_bh(bh);
 					list_add_tail(&bh->b_assoc_buffers,
 						      listp);
-- 
2.20.1

