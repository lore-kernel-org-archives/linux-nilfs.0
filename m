Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AkbRcCdp"
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCAC1727;
	Mon, 27 Nov 2023 06:30:54 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1cfb3ee8bc7so16408785ad.1;
        Mon, 27 Nov 2023 06:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701095454; x=1701700254; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tAEplWTuwzV3S4Z2ct3K3DPtCcwmnpKgJHolez0b9mo=;
        b=AkbRcCdpMnJz6h1t2matzBF5QSpTK3pmu9wyG7yHu4ncsw2vz/XBy7pWyXm/b9LjUu
         /TEImCkSFQ07sSQgQcB1SGGsBX6sD1YK1/ayNuhDTTpYQoVPV2ygz5wYf3ShvHLPrWO7
         P2BKcKjGVSBM4Noqaxe26jK9E0iP+LSsTNCAxgoxEbddjCURvvAoVkfVfqYzeQmSH8sW
         NI9B5m5gv5UK5GI4sCMdl+pGxQQxex3BuCViltDAMl1/wODHoAWwsnWqlI+gk9zhLJIJ
         3iqpSAhAFr5QyLNo0NxIps3PkI921YzegJ8FHqOHYMPvSWFuWDu6I+Hu0fewNBX1DiDU
         JUKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701095454; x=1701700254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tAEplWTuwzV3S4Z2ct3K3DPtCcwmnpKgJHolez0b9mo=;
        b=vSocXQ96ePbLad3ztrbMe8du0CfNVCOeYfR+zGXcqCyfYX2nVJs6q6xv9bNPXYFl4s
         EYS3ccHjEULPYXxLneFjU+R9D+cPN0J/uelTOdekF7VSFWXcBKJEyfKjHcI7swsuH6dZ
         M+8Ulih3lZCWTh6Wh5Wfih1OGBmpUFhiWK9rKcb9L5SzFGfICob9f7zc7YPh1Skt/Ymc
         n95o9KvZ1iPr6J48kepQ4XESpuqysFFxYQ46FLaScaQitPMfANx0AmBrBC4it9Vc+kPa
         sRfIVu18TyXvcmTbUWJZ5DJGDEFYEKcrXKU6lQ8ZfFvgG//1gS57yFlvVMCww6csZrm0
         TQuQ==
X-Gm-Message-State: AOJu0YwTeAJ+RmzGL5HBbB1bMWWWtOqVtE6p5RVl7Trs5x2y814tT3gu
	5H5yKeUZ3YRACP9/UxWXvUQ=
X-Google-Smtp-Source: AGHT+IGkuxW60EYL+gq1SIyBsyBmh6Q7OwG2p/ZfHDeGRvdPHXj7OfN95Big1qkF0cBkoYJ49tfBrg==
X-Received: by 2002:a17:902:dac8:b0:1cd:fce2:d702 with SMTP id q8-20020a170902dac800b001cdfce2d702mr15945223plx.15.1701095454348;
        Mon, 27 Nov 2023 06:30:54 -0800 (PST)
Received: from carrot.. (i60-34-119-11.s42.a014.ap.plala.or.jp. [60.34.119.11])
        by smtp.gmail.com with ESMTPSA id a5-20020a170902ee8500b001cf51972586sm8302784pld.292.2023.11.27.06.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 06:30:53 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 04/17] nilfs2: Remove page_address() from nilfs_add_link
Date: Mon, 27 Nov 2023 23:30:23 +0900
Message-Id: <20231127143036.2425-5-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231127143036.2425-1-konishi.ryusuke@gmail.com>
References: <20231127143036.2425-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

In preparation for removing kmap from directory handling, use
offset_in_page() to calculate 'from'.  Matches ext2.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 9c0513245a3b..73f135290288 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -493,7 +493,7 @@ int nilfs_add_link(struct dentry *dentry, struct inode *inode)
 	return -EINVAL;
 
 got_it:
-	from = (char *)de - (char *)page_address(page);
+	from = offset_in_page(de);
 	to = from + rec_len;
 	err = nilfs_prepare_chunk(page, from, to);
 	if (err)
-- 
2.34.1

