Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D39440099E
	for <linux-nilfs@vger.kernel.org>; Mon, 10 Aug 2026 14:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786371704; cv=none; b=la1jEAkJbbboKrfPzfNjeH2mvV3EkRxfHM+lBMpT1vYIh3GvGFBiQ33PzNaOxMIYQPkNAi3+LJ98o6iveav8g+z7atJ/zNAQU8zJIFj9uOJaV1Odnf97n0Lq7gFefZ5GG1ATKyu7MGR2Z5l5/955TDQhQNXsB3+MyWvIsVSG0Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786371704; c=relaxed/simple;
	bh=iGbQwBbiwYKpV2l+z6aMYGZpPBCSkgJqWqsLkmoFmnI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Rd+tCqCYMiJAW6qJaoxUoBxw82tsxrBFk5C+kazyl5xoODKSwGbRIVrMgNzRaINZDT3GCpFqqpCX7eMyHCEeEgmWTjsB37aD3eVaTHJgiFv2+MLyCfJBhQAYz42SqpWLZdYwBMAwRhchx9y0iz+dgoUI3KGRgWoIj3e0kYf+aU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LMs9/rZU; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LMs9/rZU"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-383cb94f742so2024996a91.3
        for <linux-nilfs@vger.kernel.org>; Mon, 10 Aug 2026 07:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786371689; x=1786976489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jqiy8nmJjB3QSTB7FCM6fB8hERTHwuBy5zOEE7SD5kI=;
        b=LMs9/rZUzjIwfh0Cn+0nlmDVKkIeabOF4NixhGLWEILFbTIFIHVb4AOTZ4371KyZ15
         tTa9Q/46W7GNRuwuepsU29PRJxnfRnG7kh5nEBTDnTuhm9XH2hgbDoUvFa8s25e0Nh6e
         n0/WpEpovW3BfxEUECY68BY7hsfX6wzYXjFWX7eGKg617EwPrgqcwaci6MiqXj/xQrJG
         VmDGdsPSDvMqy9SY6CHp0+vepYw2AWcpWAFizm2BBipX4mjpCJYLLH/mdZqhSgN9Hapw
         49P1EJIYLPEhgWsl4P8A4kLB7jHSYlACLW6L75OasLmIY3H/WxdNnuYV3ps2gVhIek+n
         o/yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786371689; x=1786976489;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jqiy8nmJjB3QSTB7FCM6fB8hERTHwuBy5zOEE7SD5kI=;
        b=mvdifuh5HKR+h6D+nm3yRfTSJg8Z6kGoeLQsZxCQ8naEvmJPBNAfNuwbWGHOUfJJWl
         i7Pmt4xCJXrxGHfHGPIuovyDqTw5oXrkqj5KFxSFiFSkqzZKfKzxYPSlPIY1ECenDL2k
         7Xa8PWpVtBY3em8VrTQoH+gqtJFKOGeB79BfX9/CKzGls81oP/bK3Kyf2/S7MJf27aWP
         wglyHzTXq+Tw6vNSbu72jlmq0BcnsETBioM5VWZe7YsToEfn4S81JYLZVW6S4w3OB/st
         59UNNypESZ3M/FRhgnzoGry9sNe+7EQTnqyr7IK0EMepGkUbYS2TUsFYDgoBpzMXIQ7m
         qNkw==
X-Forwarded-Encrypted: i=1; AHgh+Ro5Gr8N7wpz2AY/MqKySDDUYGTFZQH2aqXOJAzxwHEJG5GmhrY7tTMyRnY56nPbTodQjsUltGf28GTsCg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyeut8kSxDtjEMaO82ye5tWuqqMJk6Yb8PGSSkrRst8wFFEi4o0
	wInEiqq+6NoR/jPcr4H17IxKofbo8NcqHF8cCd6kknX7GNcV4l/2gOts
X-Gm-Gg: AR+sD11sLHCUzNBtIQ/YCyQJN9je4oLcSElZnCO600lCq7iQFBe/VfzRByOL1GAmyRX
	Y9n7VvtUZuHjWKUQeYT8k5zQ0M2412VMN378OM5sZjHo0Zj3KD2JtW2MR6A5iLsdkYrbq02QxnP
	rHxiEIi1dUZGaPcqP/uwh+1o15G2VOjPvrS4yxUwcnbGafA7wAoNxNdYYmO7mqmXtpuXuPia35q
	/qK5REcHsgQcSO4Vs1lhvSJrop8YaknmsqfjBpazweaTqzeyQzkjKiM7kyRJtZXavOz7nZ03JMY
	sH52VM2dVdcyWJDkWJTY3hB6QPvZxpYpwELfz7OuVST5M/cDXn5zVnxlRT9WB189+m2i6KfXDqN
	2vGI0mU2xt72zTqbBW4974TWPbndoutmpsyJvw9+Q37acKKKipBG1pwLw9gR1D86Rb92oKrCXL8
	SO23yBrzXcyN46bub2cAAwGV4cHX4gBItnQ/GGRBwsEOc1u5TppqD8orw+ulhyZBlE8to7akib8
	lT1xQFs1cw+O+kkorIl26tZ
X-Received: by 2002:a05:6300:218d:b0:3c3:7e9c:e292 with SMTP id adf61e73a8af0-3cc1a33a8bcmr2317062637.25.1786371688968;
        Mon, 10 Aug 2026 07:21:28 -0700 (PDT)
Received: from carrot.devel.local (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe8f199cfasm4346129a12.6.2026.08.10.07.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:21:28 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Wang Jianjian <wangjianjian3@huawei.com>,
	linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	syzbot+158be45e4d99232e1900@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] nilfs2: enhance btree node keys check
Date: Mon, 10 Aug 2026 23:20:52 +0900
Message-ID: <20260810142125.60264-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wang Jianjian <wangjianjian3@huawei.com>

syzbot reported a warning on nilfs_btree_assign:
WARNING: fs/nilfs2/btree.c:2302 at nilfs_btree_assign+0x983/0xbe0 fs/nilfs2/btree.c:2302,

Analysis found that a corrupted file has the following btree layout:
Level2(key/ptr): [ 256/15 ]
Level1(key/ptr): [ 0/8, 1/9, 0/10, 3/11, 4/12, 5/13, 6/14,
                   139637976727559/16, 0/17 ]

The test truncated the file to 2 bytes, which partially zeroes the first
block and adds the file to the dirty list. When the segment constructor
writes it and assigns a new blocknr for the index block, it searches the
btree with key=0 and min level=2, and apparently returns -ENOENT.

Therefore, we should perform more checks on the btree nodes and return
early.

[ryusuke: split long lines in btree.c to satisfy checkpatch and
 improved the error message format for clarity]

Reported-by: syzbot+158be45e4d99232e1900@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=158be45e4d99232e1900
Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
Fixes: 17c76b0104e4 ("nilfs2: B-tree based block mapping")
Cc: <stable+noautosel@kernel.org> # Warning suppression primarily
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Hi Viacheslav,

Please apply this for the next cycle.

This introduces a check for sorted keys when reading btree node blocks
into the cache, preventing unexpected errors during the block number
assignment phase in log writing caused by key order inconsistencies,
as well as the kernel warnings reported by syzbot.

Thanks,
Ryusuke Konishi

 fs/nilfs2/btree.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 64bac66af25b..6b8332e8c0db 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -341,7 +341,8 @@ static int nilfs_btree_node_broken(const struct nilfs_btree_node *node,
 				   sector_t blocknr)
 {
 	int level, flags, nchildren;
-	int ret = 0;
+	__u64 key, prev_key;
+	int i;
 
 	level = nilfs_btree_node_get_level(node);
 	flags = nilfs_btree_node_get_flags(node);
@@ -356,9 +357,21 @@ static int nilfs_btree_node_broken(const struct nilfs_btree_node *node,
 			   "bad btree node (ino=%llu, blocknr=%llu): level = %d, flags = 0x%x, nchildren = %d",
 			   inode->i_ino, (unsigned long long)blocknr, level,
 			   flags, nchildren);
-		ret = 1;
+		return 1;
 	}
-	return ret;
+
+	for (i = 1, prev_key = nilfs_btree_node_get_key(node, 0);
+	     i < nchildren; i++, prev_key = key) {
+		key = nilfs_btree_node_get_key(node, i);
+		if (unlikely(key <= prev_key)) {
+			nilfs_crit(inode->i_sb,
+				"bad btree node (ino=%llu, blocknr=%llu): unsorted keys at index %d (%llu) and %d (%llu)",
+				inode->i_ino, (unsigned long long)blocknr,
+				i - 1, prev_key, i, key);
+			return 1;
+		}
+	}
+	return 0;
 }
 
 /**
-- 
2.43.0

