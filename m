Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357251991D8;
	Wed,  4 Sep 2024 08:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725437660; cv=none; b=KuiOp2k67V1Juh3Jf0s9hZSDqWrUlNQBLfDBS2TUgzYUGtPZldju75FbR99mQPn8jCF9pVpY/0HRHI5klkms/SUDFsw3CSi/231SuDA49lJENyWmuKN7BuMFBB8RqFuMfXZxxS0guneLCArtK6JIFYB4Poudt2eXkU0grUfK/uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725437660; c=relaxed/simple;
	bh=YwNjJa5xi2XKN/BK4TeKc/GtmY63ziuJeNXrsp75ILE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmxXYx9HvcAkR4AJL3RvJNcDwzN+qCECUbT05LSeZ5mkRHx0uRQUs3+dpv0uyOXb1UpNzLfHTmXO2IJZVcInpZ8eCRDpZSa5Lm+ipBV7Cp7vQ4nzh3YKVFT1NqYCSJn12QyaRFXPUBS8f3p50j9/RFVbn9UtHG1FAKmRR2oSDgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m+cRSTlS; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m+cRSTlS"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2053525bd90so32532135ad.0;
        Wed, 04 Sep 2024 01:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725437658; x=1726042458; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iWtR2mmxgLu3yW5toSH/T3hQFipShqsAqPmOMv550xc=;
        b=m+cRSTlSBfFVwH5im0ASBsUc/zo+74/X/mxbi7kKyVHPEF1qXy5QQLQHSsW0DW34Lo
         8FGjWMCUO3nH5sRq4o0LKfwAL3ba/O3NltiJX4fmS0SsB91KzAX+g9/xQyDuseM5qzMQ
         yUvErF40BjeGIpaJ9PMhWljYkvxaI/MQIsjnThufNuc8TDSxfLcQ3ERxJWp34Vee7Qqv
         aE2TyzI6S3K7vJRPS3GFOaO4B0FDpHCz3cdEVp3oqNVdWBUFZmChTNGfpTmEBGRTHg4W
         PbY4FLa92WFCq1MUpPmgwgyP48+zjF5Ao5An0hsFBsrkuPKaROhxhT+L5X0EI104s/o2
         ocqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725437658; x=1726042458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iWtR2mmxgLu3yW5toSH/T3hQFipShqsAqPmOMv550xc=;
        b=bhM894e3ejhKXbqGU+lNYXSQUzuEFPFjEkT9p0DsLpLfzY+K8QlslqF6Yg5w3Kw4yj
         r2YQMOOgZ8/3ftlPvl1B0VTiKD2Y/tgOZKNKPdnPacbAX2RtcmZ3iYgAZtJwR00RlG37
         a0+WPS+kdFVrNSRXL/tE11YsMKIJhNytb5Ibi2JcDVaGbMs537EXxDu2komxm4T9K/4d
         kMSkbMa00xGZ1DYO5Tt7ui4dgCCrFP2MFBa5JqjRwAqsjs29QgQLwZbmBR++h/KDn0rq
         vFbc69ZZp/BTjPhX0K7XGcn9LphcLMHyTXo0ymNHFJi9o0CACmb7kzqkCR1kSVUSGu5y
         m+ZA==
X-Forwarded-Encrypted: i=1; AJvYcCVrbGRHX/LPrGw9bPE6PuAl18Pd1JG2XfQNxYWcPxSx39JGTWe5jLtaW9HNu09+Tx6t/u695GHAsNz1/FY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTdQ+igPYB2rVGwhhQjUsPPEhriiXCc9Eg0QlUMeqwgGowG6O+
	SNp4e3ZAlSL3flWsnUVpULPyIHEC7m8oE0MQxywVd322h/ZqBhEw
X-Google-Smtp-Source: AGHT+IHbcHWey0ex0wyHg53YEH/42MajEk4nJJXsvXJcGTPb6FfXnsthff5+jl/7B7VhGcWuz/Z1Dg==
X-Received: by 2002:a17:902:e74a:b0:202:371c:3312 with SMTP id d9443c01a7336-2054c249af4mr138285765ad.40.1725437658125;
        Wed, 04 Sep 2024 01:14:18 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea5832dsm8836485ad.237.2024.09.04.01.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 01:14:16 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	syzbot <syzbot+9bff4c7b992038a7409f@syzkaller.appspotmail.com>,
	syzkaller-bugs@googlegroups.com,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] nilfs2: fix potential oob read in nilfs_btree_check_delete()
Date: Wed,  4 Sep 2024 17:13:09 +0900
Message-ID: <20240904081401.16682-4-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240904081401.16682-1-konishi.ryusuke@gmail.com>
References: <000000000000b4cf9a062114d132@google.com>
 <20240904081401.16682-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function nilfs_btree_check_delete(), which checks whether
degeneration to direct mapping occurs before deleting a b-tree entry,
causes memory access outside the block buffer when retrieving the
maximum key if the root node has no entries.

This does not usually happen because b-tree mappings with 0 child
nodes are never created by mkfs.nilfs2 or nilfs2 itself.  However, it
can happen if the b-tree root node read from a device is configured
that way, so fix this potential issue by adding a check for that case.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Fixes: 17c76b0104e4 ("nilfs2: B-tree based block mapping")
---
 fs/nilfs2/btree.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index dedd3c480842..ef5061bb56da 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1659,13 +1659,16 @@ static int nilfs_btree_check_delete(struct nilfs_bmap *btree, __u64 key)
 	int nchildren, ret;
 
 	root = nilfs_btree_get_root(btree);
+	nchildren = nilfs_btree_node_get_nchildren(root);
+	if (unlikely(nchildren == 0))
+		return 0;
+
 	switch (nilfs_btree_height(btree)) {
 	case 2:
 		bh = NULL;
 		node = root;
 		break;
 	case 3:
-		nchildren = nilfs_btree_node_get_nchildren(root);
 		if (nchildren > 1)
 			return 0;
 		ptr = nilfs_btree_node_get_ptr(root, nchildren - 1,
@@ -1674,12 +1677,12 @@ static int nilfs_btree_check_delete(struct nilfs_bmap *btree, __u64 key)
 		if (ret < 0)
 			return ret;
 		node = (struct nilfs_btree_node *)bh->b_data;
+		nchildren = nilfs_btree_node_get_nchildren(node);
 		break;
 	default:
 		return 0;
 	}
 
-	nchildren = nilfs_btree_node_get_nchildren(node);
 	maxkey = nilfs_btree_node_get_key(node, nchildren - 1);
 	nextmaxkey = (nchildren > 1) ?
 		nilfs_btree_node_get_key(node, nchildren - 2) : 0;
-- 
2.43.0

