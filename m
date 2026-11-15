Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794706574;
	b=DxoESoFrDEPM0bXqCWeM5KRijab1MCHRUhaOw0KZVYvzXdQ7oaLYKySvs5T6zw238s5f
	 fKYB1whbQdN0UmjEpXW7r2gNUPnjzomrXLGQVaxu4BZAOEtUhPtZYU+v25wnqtXgj2EGB
	 tmUUArmLEO7RLFuHdlIFYoQBoHWS+XEWZQNkLvDxO5Jii6xMnMMV2I3fV1fsMv2XdpS/r
	 pdLo9Aw0vtUNgxLwmIR+WnnZ4ifiQRmslArZngc+Wu4Wd8URA7bKrIzAbSrxLjS5M7qDU
	 cRmbX+8goL3/TDc0tphb4h5nNT5ioKZCvuuZa4C4v+gl6PZnD3vgQ9os+0Qwwk/XfTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794706574;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=92vbkXHQiMKc+ntZuQVcPOCyaPvxLMI1+R3Cgd8MhPQ=;
	b=uEqb2WuAgxRRrbJmKo+oH/h0MEc1Us/lyUXlarBlBHMFBaR+XCFX3NrvGdnDPmMmY2Qz
	 3DHMRM2eBcQUaHzr7qnxpl0+cKwZJ5Z+KJ1s5ycsqA5lsP2ktC3PMU7e5y8Sz6ioQb5i/
	 iBEOpTgMyJyALb9rLeUKroYVMFj00pZp0h8bY3+GrVUUfF88Ill1ZU0s5VFnIAgzjo6rl
	 c0JZtCJ7PW1cTxRiW8TJIU7gLAoUrjULo5Y/icOy7aKt2vFhGwv+O+BpI2l16/skhDb4i
	 Bfl1yBwlKY4uisXmHjXGovznf0B9TQJc48ixqfT1/hXJpEF47SQeMYWuYBb7UAcNXEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=foxmail.com;
	spf=pass smtp.mailfrom=foxmail.com;
	dkim=pass header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b="IWd+L+/s";
	arc=none smtp.remote-ip=203.205.221.210
Received: from out203-205-221-210.mail.qq.com (out203-205-221-210.mail.qq.com [203.205.221.210])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D41606A323
	for <linux-nilfs@vger.kernel.org>; Sun, 15 Nov 2026 01:36:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07D41606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=IWd+L+/s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1794706564;
	bh=92vbkXHQiMKc+ntZuQVcPOCyaPvxLMI1+R3Cgd8MhPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IWd+L+/sKuSMqrqVMAV0tE8r/75wUzYkytSDfbvDz6Wi4O5fY4GKa8vFy2ZLD/rNy
	 bcVcNzoyG7br08SJKaFXu+PXxOGLNknTMlgTNrPpldyA2I4JsKcWCTH515QbUxGuTm
	 SQ7GVOGkBWHOr5+n++GAev8bh0WhbPt6hwisgMOA=
Received: from localhost.localdomain ([2409:8a00:2545:bef4:c8bc:9cd1:4eaa:3])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 8FAB0A63; Sun, 15 Nov 2026 09:35:58 +0800
X-QQ-mid: xmsmtpt1794706562tgmdylmh2
Message-ID: <tencent_707010F5E5413437C5233177A7B91E8B3D07@qq.com>
X-QQ-XMAILINFO: NnYhxYSyuBnLvyDfFSxCSEFWF/DNIQa3VQyIpvWsytA4Dc8joUJULPf8sMkCxF
	 KMOIH0AdBadTYxvxF1bx7fikctux7pAXOCNnG0QTImPLVT7JjOHRx96V07me2d4y3oZUD7wAOdD4
	 nQcV/fALSduxpxde9HVlYmDzKdxpoMeYp7BW52NbyQq2stltRtboAjv4GxgUl+M2VfwlRansK9gQ
	 7DkHegc4XAthXyt3P19fX1lxkBt8/cKJVdP2C8UNVTvlSClT7CKdsbpUDbSrJGF+Td1xCekflaEa
	 Qzl6z2c49QKfgGwJv5xKvhc8qLO2DIOLb86b1s/E2CRQncAHyXUStvML9uPIX/fydKmxASHpP97M
	 G3YIl0NsNY0XQ1f7kniyN6t564EyCrsNbag8t19CMqAQcXVMO3MJuyOU1IL3CnWulaDxfjpXMYMl
	 OxMldg8dK31130NaayD7+YXFCaWmkjBjTyU15iomo6mwnDg728ZUL1ZgbPiv/PA/2iw6TuwatsOF
	 jKIqrt70Yx6qhv1tR5/G9kEm4nyma1bcUNpB5DSQHWBuXHL+ed5qxRuD7LJhgRAjYQwQaeJ0+2/g
	 DZcWwVGyRN+BJmtv30bzZlEIqBLd8Q1jAxY8GH8FpCEZxYUOhZPRePE5D0xP+DxSL8EhP/n5Tc6K
	 HIvAt/yU90K44FeRGhI5adRLZIhYoWe06SohPy3jJ32HUsGq4aLNK/XsPUAeXTnRzwXCThap72hT
	 qUG6tIiUCdERbp1FNGcjC8jFeGQwpcbVlJHWM99o6pUFKq76cSeJmpUi4b+x4sSyHs1qBstpHNMr
	 848AUJrcDj6N+gXUi4J212S3UmfeKtRq8/vNgKeAN7GUhqIq1kFZ5PDRvPSeVZ2BUTsHIUVAg+6Q
	 gBNEg5zqNX51JQv8JDXjs1TrukTZ4n7e8FNsyUwUzwwxra0mxFObzy9maNgZcwwPg47Ch6LaeU29
	 k7QviW0mHQBo2Liha8+7cwULTmyqXrygn7Vesn3agnr2x23HRjz0obxcF4pohHsE42gpPA+/1RvZ
	 RMdrRZOqFvT3xCDxzWPmV54qqsHiQAbAGqBRqro0modShfJGQog7zsvv4/YWKFATHC4hcaV1O7Ws
	 rYQQt70SyiiHcgdFy3z6k8rFyJO9EyxDLr3wrwBR3JuVhsdGOE0tA7eg1RwXKVtbESnX/b
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: Wang Jianjian <wangjianjian0@foxmail.com>
To: konishi.ryusuke@gmail.com,
	linux-nilfs@vger.kernel.org
Cc: Wang Jianjian <wangjianjian0@foxmail.com>
Subject: [PATCH 3/3] mkfs.nilfs2: add time to ok_feature
Date: Sun, 15 Nov 2026 09:36:00 +0800
X-OQ-MSGID: <20261115013600.123910-3-wangjianjian0@foxmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115013600.123910-1-wangjianjian0@foxmail.com>
References: <20261115013600.123910-1-wangjianjian0@foxmail.com>
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Wang Jianjian <wangjianjian0@foxmail.com>
---
 sbin/mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sbin/mkfs.c b/sbin/mkfs.c
index 05291d9..c4686eb 100644
--- a/sbin/mkfs.c
+++ b/sbin/mkfs.c
@@ -1023,7 +1023,7 @@ static const uint64_t ok_features[NILFS_MAX_FEATURE_TYPES] = {
 	/* Compat */
 	0,
 	/* Read-only compat */
-	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT,
+	NILFS_FEATURE_COMPAT_RO_BLOCK_COUNT | NILFS_FEATURE_COMPAT_RO_ATIME,
 	/* Incompat */
 	0
 };
-- 
2.47.3

