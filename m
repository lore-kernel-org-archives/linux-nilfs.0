Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD2818DF62;
	Mon, 28 Apr 2025 17:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745861898; cv=none; b=S4byf3oORzAAXk+IGq+HoHVVJQsNDxmDSbZmmW17NwuVGtaJpN74iIHO185n6eIG5JoaYW3pim3spQu4Qhdu+97IhOTP5fSDI7s1Q5E4kOvqMhxmSlLzzQlqLv88vJFBGOZq9W7tPbUtaEOIUzaETlJ+7rID0tmBlurodsLS+/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745861898; c=relaxed/simple;
	bh=TuERlnKAcq6aKYV43DtbB38elqfv6EeBHFAroGOU9iY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbaipgoh7Y2bJZ1Jlwn0oZgcUNGyC+2rPGZh/APVP1DaTsvCxnsO7IE+zP8HS2XHkpz2WK1Kbl4yCM+9agw48HLrXCCB7qbBHyC9xo2wIJZSzsvRT+fp6h/B/JXT1wLtl7EO1RzzQNy2WxZA50u73S9hcr3qjv4rCtStV3SjcBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dHIx91LS; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dHIx91LS"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-736c062b1f5so4319689b3a.0;
        Mon, 28 Apr 2025 10:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745861896; x=1746466696; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D0O6SG1ua8/ep96NLpn5/Uk7r6MYyN69nj8yxNKNgOQ=;
        b=dHIx91LSbgKLUFydfRbvqnSgd9Sm3jNo8p+pPmnTxUGeYvtFIXjUNHY2/13leh5KgM
         Jvmx88P5C8wcuT2cubFiIbtJynhrIe6nthimFlVEH+6cYYJseW2bp+a9+YNLC7b/k/hW
         +bCKT4X8UJsT7hHf6pAyA8kaaFc7dK5w22BXWFQy/b1bFmJ3/FH+FCaXqKauyPvZj4Hh
         c7kkYhfJePD17kw4XricInkRBBuvQaYQM1whqIl5v29rrlFtcsDHAhkGq22me18XSkaO
         clDwatCyXVnp3nYN5WJZHNiHC5RwWvCwDP1QCAoBQRIQV5c3kU/JtwZr8hU/K4nRAZKb
         DXpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745861896; x=1746466696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D0O6SG1ua8/ep96NLpn5/Uk7r6MYyN69nj8yxNKNgOQ=;
        b=biVYU/WUogByeOOL5+WyIdxs9/6q+PlXipJVWcoo1XVyHEL6da31nU9LZ8//GvxVYt
         immFUUek28UX3XqpIu/eucgH9qCggIk18pL23nGZw67/0BAGEENPyQwV63yHx/oT2LNZ
         0Z8PAn/eO9bHvdNes2b591w/68fNE2cz5yowPPADG4Ec4GOJzcTNVWaMTGp0UbYT25Rt
         m71Ao+UbcWUNpibGQax/ar0KdNFmnQdPnAtZD76MSop26nPwz9YDUGHviPyYle6Lp2n9
         jQc3TAcJiW/0VNiq+fBtAwe62g7/i0daux8TX0+PtXonC3Hniy1CoNHWGRLugoEcWWQC
         o/dA==
X-Forwarded-Encrypted: i=1; AJvYcCVo5eOtAvemdxoDfTvaM+PoDbFfEyHvKdJFZCVvmGNy8KPk9puXkCzqfbeAV5j9PNP2AHyhhxd8utaYZRI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdwG8F6fIrPikwx2VNTehniSNDZ8+WNnCbBKd5SkFgkgXAW/AY
	0GN5WU6KaqN1kGrjpUtKOz9wDAdA/kPeFXE9cahLh7k9rYfKgMcY
X-Gm-Gg: ASbGnctJ+xMdP4CIfpi31qfrfU/rBfLyKTD/ps8/egu6qb6pzxZOIAboeKVAtGAmjNp
	DgVuKgszvP4fnmcqyE/M8RCXUYbN5fD8JPzy+oTtQ8ctLHPhfC7Mqpq+AbvbpWvLo9llxEI6DtY
	eNxN32ypaH6pScaSJMhoLmgwOgyZLMQGXCxESmlaHrpNDOuYX9/tV7zx5Ow9cmMXYzSIvfdjZlB
	E0UcGsKIJ81TknmWr7ztixI5nuNb0S2aMY+UVJHS7eX4eZ7kLC9aifkJBjvpz+cYfX4fPX5FIdF
	TFfeFLgAJcahLjsaC28+TNeuhIxG0jLyvJq3Qd8rNQEPWH/7SsLCQJ7H6IU4Q20tPw/WVoV2TZp
	OFhrCUX45Ffrw7H8=
X-Google-Smtp-Source: AGHT+IF/D7orJzXpoAV5N1bXuZjZUle4V0/QTec3m0KHnn3AZL1qLkAl7wTt9bk+sMnfNBDPNOanBA==
X-Received: by 2002:a05:6a00:4613:b0:739:3f55:b23f with SMTP id d2e1a72fcca58-7402716b8ebmr918062b3a.14.1745861896138;
        Mon, 28 Apr 2025 10:38:16 -0700 (PDT)
Received: from carrot.. (i223-218-150-204.s42.a014.ap.plala.or.jp. [223.218.150.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25a6ab27sm8314939b3a.110.2025.04.28.10.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 10:38:15 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 1/2] nilfs2: Add pointer check for nilfs_direct_propagate()
Date: Tue, 29 Apr 2025 02:37:07 +0900
Message-ID: <20250428173808.6452-2-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250428173808.6452-1-konishi.ryusuke@gmail.com>
References: <20250428173808.6452-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wentao Liang <vulab@iscas.ac.cn>

In nilfs_direct_propagate(), the printer get from nilfs_direct_get_ptr()
need to be checked to ensure it is not an invalid pointer.

If the pointer value obtained by nilfs_direct_get_ptr() is
NILFS_BMAP_INVALID_PTR, means that the metadata (in this case,
i_bmap in the nilfs_inode_info struct) that should point to the data
block at the buffer head of the argument is corrupted and the data
block is orphaned, meaning that the file system has lost consistency.

Add a value check and return -EINVAL when it is an invalid pointer.

Fixes: 36a580eb489f ("nilfs2: direct block mapping")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/direct.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 893ab36824cc..2d8dc6b35b54 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -273,6 +273,9 @@ static int nilfs_direct_propagate(struct nilfs_bmap *bmap,
 	dat = nilfs_bmap_get_dat(bmap);
 	key = nilfs_bmap_data_get_key(bmap, bh);
 	ptr = nilfs_direct_get_ptr(bmap, key);
+	if (ptr == NILFS_BMAP_INVALID_PTR)
+		return -EINVAL;
+
 	if (!buffer_nilfs_volatile(bh)) {
 		oldreq.pr_entry_nr = ptr;
 		newreq.pr_entry_nr = ptr;
-- 
2.43.0

