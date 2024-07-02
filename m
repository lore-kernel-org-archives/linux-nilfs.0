Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECFF158DD1;
	Tue,  2 Jul 2024 18:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719945319; cv=none; b=fMJPGxgOoT/wZYgCWe81Tv9vQIy4u7PkMugaEAXaDDfH4XJxSagHAkaUGborlTb6RgU3Zaiqg3cAbVkt9nexW9cMEDcKtJU88l3swGDmZwAwZs48Ha/cDBOl+gcUELBKU9bXGHaU0ZeDbTvRnN//N8aNfu53tvG/G3AwE08zypo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719945319; c=relaxed/simple;
	bh=hfIC1dzJV63i9JqhLxmmJQ/kZj/j1H5fSz75DC+4KPg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CAId858S1lgsO+g05NBlmyZ8asQ5xjVath6b0XpSBtAxPsQJ0VxgFkZBSwegX6LH/ePZWxjvrxdMunpy+M5L4JSycj7qvLPD1sipngJkxgm233E1gwPiFuJIYL9suybDtGtJJs/SNNXp359+rIdnk7GXpB6Pf/MzYdzXesb67d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cc5wEaS9; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cc5wEaS9"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-5c21f1bb810so2233175eaf.3;
        Tue, 02 Jul 2024 11:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719945317; x=1720550117; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yfZkAgkKDLiBxWm1TW/R5w6toVXsLssVKJzooYjVeFU=;
        b=cc5wEaS9r8JVN4g3NhCMA2i3bhTVOpp6ZpFwbw0i6QN+aHt528v4Q7YVfWewYLzNme
         yQbxVIoCZbL6bMSWMlLQXGEub2DfmWl/34GtcQzBHB22IOTmCwVmhlcMDLXiQXXiwr07
         eIVFfsxUi3uIEkYquLScq4FyCbqFw8pWr3aMddwYAviDZLJ1EhbmdRhr/Yr6ffUKIIob
         0SzvCWuUPu+7DPa+EtUUVgZ/OiHvlW8WamU+OZk6XsDxcHS8xpq+RNX41PIWYKJ6HIRS
         7NFvMqvQMo6KFpataFeXy/A0DALSS+5g85ElB+9V4AaAAcyN7Q7CgExQ5WAjdlSNmQ7d
         jgCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719945317; x=1720550117;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yfZkAgkKDLiBxWm1TW/R5w6toVXsLssVKJzooYjVeFU=;
        b=SrgIP8yeEgVJXsrkCcLQ5HBx78d7fbBMP6QjJVCfvN3d+FSJOrzUsVoYz1JIDTgnj0
         cbBx7b6NOebokI6RRXs/FceDjKXYs9ru9yrZuP8/x7UnTJmACn1s5kFVGfV7ShSP3tau
         4o7up5vwOwxNtO+kOVBe5pTdl3ZPhqKGnOJBnlLOBJ1sguWYGutP+jMwhqn7mxbVhgTn
         onpkzUmwMYw8rgRAJZ1p3BxTDsR609Kfta7add1ubh6Pz0CJUS6z+6Ztj3Ka0C85Sp3L
         aZMJ6Plcw+cBB0lVinBOp1vud7BVV0/nK8KAPh3u1Q2+K8aUib+WalcV30g43C/XsIYH
         PTpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUloAkk2uSSA0rByqM3NyHC9MLTT26hQNDwpBmvOacAMH5x/kvyE57ViCQBU4TMHbapDhWxmf1a0ObM3TKCQzHZ81RrrFp/xoyq0spj
X-Gm-Message-State: AOJu0YxD9GQo2y8DwG+/vtF07eR4tqwwjg/bOphJcM4FVDUrI7D/WNqU
	KjzE9BPTSOv2LSuidF0i5G4dLpMYsPHPrqY4eOG3dwxa1emc5zWudzwdTA==
X-Google-Smtp-Source: AGHT+IE/WyiWOTZIbsPlEwk63c0ctcPKh6b12hMqtcAT/Al/ih5/llZ1LW1U9YiwvhL5kCccrh7LHA==
X-Received: by 2002:a05:6358:70f:b0:199:28ad:1447 with SMTP id e5c5f4694b2df-1a6acc6e5c3mr922190555d.10.1719945317317;
        Tue, 02 Jul 2024 11:35:17 -0700 (PDT)
Received: from carrot.. (i114-180-52-104.s42.a014.ap.plala.or.jp. [114.180.52.104])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c6c7f6db9sm6918090a12.72.2024.07.02.11.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 11:35:16 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nilfs2: avoid undefined behavior in nilfs_cnt32_ge macro
Date: Wed,  3 Jul 2024 03:35:12 +0900
Message-Id: <20240702183512.6390-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

According to the C standard 3.4.3p3, the result of signed integer
overflow is undefined.  The macro nilfs_cnt32_ge(), which compares two
sequence numbers, uses signed integer subtraction that can overflow,
and therefore the result of the calculation may differ from what is
expected due to undefined behavior in different environments.

Similar to an earlier change to the jiffies-related comparison macros
in commit 5a581b367b5d ("jiffies: Avoid undefined behavior from signed
overflow"), avoid this potential issue by changing the definition of
the macro to perform the subtraction as unsigned integers, then cast
the result to a signed integer for comparison.

Link: https://lkml.kernel.org/r/20130727225828.GA11864@linux.vnet.ibm.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
---
Andrew, please add this to the queue for the next cycle.

This fixes a potential issue with undefined behavior on signed integer
overflow.

Thanks,
Ryusuke Konishi

 fs/nilfs2/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 36e0bb38e1aa..0ca3110d6386 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -136,7 +136,7 @@ static void nilfs_dispose_list(struct the_nilfs *, struct list_head *, int);
 
 #define nilfs_cnt32_ge(a, b)   \
 	(typecheck(__u32, a) && typecheck(__u32, b) && \
-	 ((__s32)(a) - (__s32)(b) >= 0))
+	 ((__s32)((a) - (b)) >= 0))
 
 static int nilfs_prepare_segment_lock(struct super_block *sb,
 				      struct nilfs_transaction_info *ti)
-- 
2.34.1

