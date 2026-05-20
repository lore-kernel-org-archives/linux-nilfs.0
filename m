Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E89434AB0B
	for <linux-nilfs@vger.kernel.org>; Wed, 20 May 2026 10:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779272169; cv=none; b=oqxUd9IDSY6wU2M1t8EgO1LGeo4YWHR+62fSXmwxh4SunqPSD9f9eVhPjnYiol4iVxu/l8mvQm/5mFb594fowtLLxzXKl+SyxjCjsHnHXncHpod9n8u0yT8W1T6IjvacpqNkKXciiKO8O7K4Xw5Y50P7sdq03wAatFYd+gJI74w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779272169; c=relaxed/simple;
	bh=yOwq5aoSFnjnN3Up3p5A2+W0ZtUmWYLdUCmFe7WlAws=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=REjuu6Zx72P4jNc8E+jPL0Mo4QcoQ8iUtNJOkze5oBUeDnxY1LYVaUjEAtliAZmWWAlJA7aTHRuK9S1+Tfge38cnEtYPwUdYWEhvSwMhFS8jcEwgMx2XZlxhNBZinWHRGSC5O1A7bqVIC+++yWED0tpNhqVAuLi5lm/nA5Ajyx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BY2Ovabh; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BY2Ovabh"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-36a35e4eefeso70946a91.1
        for <linux-nilfs@vger.kernel.org>; Wed, 20 May 2026 03:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779272163; x=1779876963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lDEM2k2NQQ7Lfsm22fLEr6Z5c9noFsO+7k3QetROgeA=;
        b=BY2OvabhVu5sA+7PAbozBdcAdj8GwU2Cgu8iJZe/iSdzN8U41SlCey3qcA9EN42PS3
         uQ0nZ/jp3OXxzBnn2MsW9zKCfHmzLtjfnVZvG5wkjqLC0K+RR7nJJgmggkEztasucAQB
         kIQu43ZU72IktCJlzz1fKsp6VbU82/73XlbxwR3j0Nx9mACex7q1lhWovv6nvaw+dIyK
         CLdfe3T+JeszkLIjw6+jlmeTZ9T9C/YDqL0LOZ4yEwJGe8RoPDHSQnaU7HEq3U3RR0QN
         MB74cHcVBiC5THGtVzmiJsFqMqMXdq5lA3m8nrdXqSxhaPEQf3wxVgF2HXxUP6HLMkpk
         zt6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779272163; x=1779876963;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lDEM2k2NQQ7Lfsm22fLEr6Z5c9noFsO+7k3QetROgeA=;
        b=Ab1zn4MYoBLR4oR/kkL1vdgm0NzBeYsyMAfq8gk6LCdvd866rDeMoxZ1Sia+N+XJO7
         37+a7Wmak4mebkcDWNSkczLm37Pb9niPWNZaK0vQ3qiaiEM9lHyBXpLu+Fe7QNVSEJCR
         SSsdKGWnLlrX5l7JT+lOpkC27QcLeWH4WBwd69Ktc4QbU5arYNXDUfxSs0wMwM2l5Beb
         Q6aE0OwXj00u0riCdjRzyyKL88ILz2Pja1bDaTp6D8xTOrSmN3Agq+R0hC8n5BNWWORs
         jMe0p6UAAu91Ji9QDIi3NYr6R5VL7/fZYlNM5REm4a5CBqv0kYgw/AIA5MsdQXhjbs9t
         ToAg==
X-Gm-Message-State: AOJu0Yzi7ISt+9oaZ139CqUcjacGofJ38a4bCs9Ll2II72AY5dRkLMw5
	OY2uzt/62zNgSRxkHigthX+WnlJb1g3cIuLJ5b758++safgou7llzI3llLVqeQ==
X-Gm-Gg: Acq92OGV7ArWYPXwbQU2MxnxIGomK6W0JTS4hztHmua5idqh5RYBYCDhCe02IzVPvHB
	JO/5xa55mTwYshi+5GzTC+WD8tD8NmfNm30lOsxYSeyt2tJOm++RGF9ARahBatm9MjmCgykp3Kd
	Q2kQcJh2VFTlEqP9TCYj9pGbtYxKUDBzWbkvHKcuCihD/jROaAvsUyJ7fXABCI3Ca+dXv80qnif
	QmV30LjfSGKwYxfJdDo1NK3ZWnL/0Jgv0l5eeWih9+t9FNIxBl8H94bqyErt9JnCNGyH1N+QIpH
	tb+NLp347E4agINxQrRH1IbMmqnijDET/Ieh6lSYRgj4ygeMZFMrD6XmhkiD3v8N8xi2HjKZ3WK
	hr/q2AIs+83/mvQu1NTocte53skF2IN4D4nc1T9pvwYx/gtAnDlj96ZZN9QRXY4KM/M/x3YI7Lk
	xRUCLerThdXvp1G5CZZxOfEDHkzssj6HLPNgFZ6olk/+YNr1LdCzKQm4W84Wc=
X-Received: by 2002:a17:90b:4b8c:b0:368:6159:980c with SMTP id 98e67ed59e1d1-36951b84f49mr23228425a91.20.1779272163166;
        Wed, 20 May 2026 03:16:03 -0700 (PDT)
Received: from carrot.devel.local (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36959fa9d84sm6453027a91.8.2026.05.20.03.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 03:16:02 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Hongling Zeng <zenghongling@kylinos.cn>
Subject: [PATCH] nilfs2: Fix return in nilfs_mkdir
Date: Wed, 20 May 2026 19:15:47 +0900
Message-ID: <20260520101600.19734-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hongling Zeng <zenghongling@kylinos.cn>

Return NULL instead of passing zero to ERR_PTR.
  Fixes smatch warning:
     - fs/nilfs2/namei.c:261 nilfs_mkdir() warn: passing zero to 'ERR_PTR'

Fixes: 88d5baf69082 ("Change inode_operations.mkdir to return struct dentry *")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Hi Viacheslav,

Please add this to the queue for the next cycle.

This is one of the fixes by Hongling Zeng, a patch that individually
corrects a semantic issue (which is harmless in execution) related to
the use of the ERR_PTR macro that arose from a recent VFS change.

Thanks,
Ryusuke Konishi

 fs/nilfs2/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 40ac679ec56e..e2fe95de3d71 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -258,7 +258,7 @@ static struct dentry *nilfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	else
 		nilfs_transaction_abort(dir->i_sb);
 
-	return ERR_PTR(err);
+	return err ? ERR_PTR(err) : NULL;
 
 out_fail:
 	drop_nlink(inode);
-- 
2.43.0

