Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4194E373BEA;
	Thu, 25 Jun 2026 09:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782378883; cv=none; b=ekbvZbHj5U18d2ig/Pk42ME+EdiAok3ZsANJJ5rla625d+GnaAwR4j+tbBQEANWqfyNyrOXcEdF0NOwQ8eJkCNJC4dxQJm4I3NDT2q7pHDrO+zLh7QNEItQkUBIV8gom80uqquuDJWCx7G/AvTRDk/VJfrxOYpLyhKGgQqGeYlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782378883; c=relaxed/simple;
	bh=+69aFcUXySAdblrLkcO3yqt3uTrRoyIq9LaDphDhDc4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Iw/pQhixcO6N5wMrf90n7u4e1UMnTF9XutBDVNtEYmceuXBJA51fdvkrwEz7iE6tNG1P9Xzsv7qtSK8odJAQEeabWHCJ5MEwlMAXnS9PC2FAbGehixKdHCfTvCUnOY0uu+p/noxC3mL2tYxiSoa9LapE6Qq78srZf8COqFB6/zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=FN2jtZFD; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="FN2jtZFD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782378850;
	bh=YHNAOy0VzHIvQCP4D+lUxh8jknMtClDgPlVPVCqKoXc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=FN2jtZFDlYwHhl9JqY+88u3Zp2gTKrERKD8kw6tBWwegR15GQ8LD3E5EgS7mUHkGz
	 XqyL+GR7UGtRd331Yn7A86stx1AmzocsoV8PULQ/bPspZIxs5xQD7v3ibarw3wYA2/
	 EqhFGi20Z8KpfQwva5lnr3XSfPIQlz4UOMgTf8wg=
X-QQ-mid: esmtpsz17t1782378842t01e3b159
X-QQ-Originating-IP: c7SvtupGSCKJ+buRH/BqC2eqlWqsaPufSF00z5/PokI=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 25 Jun 2026 17:14:00 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17235849702624262944
From: wuyankun <wuyankun@uniontech.com>
To: syzbot+c37bed40868932d790e9@syzkaller.appspotmail.com
Cc: syzkaller-bugs@googlegroups.com,
	konishi.ryusuke@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-nilfs@vger.kernel.org,
	slava@dubeyko.com
Subject: [PATCH] nilfs2: prevent double insertion of b_assoc_buffers in dirty buffer lookup
Date: Thu, 25 Jun 2026 17:14:00 +0800
Message-Id: <20260625091400.270398-1-wuyankun@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <6a3c371b.80e5668d.5d0ef.0000.GAE@google.com>
References: <6a3c371b.80e5668d.5d0ef.0000.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: NoM9Uv2ejer3SZStiSU7G4jSvC49o1K9X25BtpEpA5PyBEFfxcfnkHYa
	JNWyuwSzL5PhPNNJ3oYqXYw5RdWGcocvhlzgcuOX851LIZiabvmmC4R8pO995I8NMjHd1Mt
	BmrmjGLgY4Gl/xxePtWbJ5lwCh04aM1N9M1SEpNFhe4vX1EoIriWNdl82tJUfeiLXKbgxfQ
	HpyH6MlFcoQscMkeCBEg+1rgljpUo06v6IqoeNdMmbT/h9v/Pi44rowe0lTL7yejlNXzQr2
	iE8ds61iy+NSDVeLfQQXFTZyIzHYUgMNqK+/L/8M902Adn9bX9lC9WTmfGXdyf9ngMuUU3F
	O3cWOfBe/1vXpRiUr8Qrk/gC25Nyx0MI6xhovZUsbzYnFeLl02ydpmWRsGkE+94VoD/4A6e
	AyrcwXD82nSXKIhuPPJqLCesc1oOai5s7q0FO5owGwbPrBuUewBa/oFOcG+EArymtA3z5mg
	iNvJ/a+MwJRYnE0W2Q+XOUpdPs/KU/Lg0QyW+n9N+/naYe1bRUtuTqtko541ZqrALM1yLb5
	hQiWpE9tWyDvjU7M8d4llHlzga+aVxgxUwCFRFG3nKslqyMjdSR7AGD0PuCEj/nf/twM1gx
	lapMOtcJQM5bIUiSqSL0owt8eg0vnfPaCBTlOq65PaQmtXtjZZnmX9ZV69yDUMoz2Qk9vHu
	kAmbbqkUBu7g9xNSTc3Rl/Wy0OIZDJfOM4ULhKxrCM26YG5o80AY+1cpq5LgV07VCHWdo5o
	HUfFbXTpWHUkihUmKbFLT1peWRm9zkdXDTuJ996QmSYTiHIsIFZWhCuhHXxw6UcC0BAYo0C
	RlontUhEZCtVPvstkV48vhix7HoO0dxJYU4uX5QNzKSqfDnqePP8XwhJTwJxsC5Dc3PIXFR
	0l0ogjhXjvHIZYkFJc2nSbcJyHlBHjvVmHqJxaKeNjYKKBbTcszq1BtF68bM/IGAeb6FHvf
	oJ5NqjtALJybse32McgztACVqydToZs9Wwxp4kcwZZjDFEak7R5N3yOqek477IVSMn52Zbz
	88pJGjDCoClCC7km3fKxtfOuZyrXHJtkVnh7hlZTLVs1pjX4+JOFDKK5Q38XF9FS6Q4grEq
	R5YXKcwZnE6b6LTKklwkEs=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

#syz test

syzbot reported list corruption caused by double list_add_tail() on
bh->b_assoc_buffers in nilfs_lookup_dirty_data_buffers().

A buffer_head can still be dirty and not under async write while already
linked on another association list. Add list state checks before enqueueing
in both data and node dirty buffer scanners to avoid re-adding already
linked nodes.

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

