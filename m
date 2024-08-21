Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F311B78FB;
	Wed, 21 Aug 2024 15:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724255200; cv=none; b=bviQSqsD/6fBo3sES5/v9R/5bOGSRP7YY9zChfmfEntAlQjJixh1dstB8FTXPMEKYbHyLqV+IM0tdZGPHPyz9Wy3R2hfP0gNLldiXWKTT3Q8nsTbt6yUbLqITXN7kmzTEoS4lStnU2CkrJooEW0Wh2xLJ8xWkizyR0MVEO7RUJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724255200; c=relaxed/simple;
	bh=dyHwrmDque8X9gPKXwTCf9t+4xdKw1IeaYWHDDK6ZNs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eFC4OdALYnZ8c2RMiYSV78Wi41sho7dMjcfzuS8VC1+8tEkYD8LBAfj12W/fALaWMSFKgj3yevHocgww49abqqFt8HPDSKSSVhugSnsBhYsHCGJso2Tsb+86FryvXhe6okS07aCF2AelrfZVl3fMzFHGai8O3KpEuogqn85XcWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z7DliZKU; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z7DliZKU"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-7c1324be8easo706314a12.1;
        Wed, 21 Aug 2024 08:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724255198; x=1724859998; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=okyjJddQCAR4b4zTRnWTqLOmAFuejt6oQ+YBSC01fX4=;
        b=Z7DliZKU4vlcZtcRYkQnSOVH07t9v8WWyGwWV5TKMLPYDP03ki3GsXZfmh3zN64M2o
         HmrdvGyJ3miIGih7M9r88NyIlaDXjtAZfAeFPUSVdbC8cbFWQ+Kxx4Vg3ynLRQ9jhhwN
         Ofjf6C7ssM7idhMoq2qzbFr2Ydb9zQmGNxwqNitYvl5oAhq9zRdxKAqCPp62SUuv3Ilq
         E7fLY4d9O9PKOc9BTw5nwKgws3AfTNOoJZ2fkjFqoWhTM+B9nit0N5hDNw5onsXPMOKH
         Zgwr3GIHWQ80Uq0gpRPzQBEC75AavLLPLR3n6nZUXTG/n+eVYHlS7CrqAKAwwbcZI7hm
         saMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724255198; x=1724859998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=okyjJddQCAR4b4zTRnWTqLOmAFuejt6oQ+YBSC01fX4=;
        b=w9bcZGWlF4txU/ojty18sQrFq53P/witoXjsit7K4RbIRhMP183r9ALYJ3KYJCgXyp
         luMBEnoAs/6wLOg2F/HWTUY/dfvBWjiUtaqVDIm2P0GA0sNd8eBHmeXy7QV3t279JAiN
         JcDuS5X+MTxOsQIlx4UUAalHoPcsAhjVaUtKEcdn96UxRDCfeIZJ8AN4CFbwgPjdpw9D
         lxtowo1cFrSZg/msjK5KIAabuxR4VBOVLW0MYzP423g7RSL2X/7MkWtI79b2+yBsqb2T
         mXWOOWQxtpFWDFKOmM/vw0gKoTlOIkWdgqyWtcLsPiX7/xN3tikoPMAW3uKBOyMzn/lM
         i2cA==
X-Forwarded-Encrypted: i=1; AJvYcCXKWRiQy0X1iO/XM1rA/As+gbRtKnKJaN16/5I5PRMnqYeTMobIAHxHrpWXl3jbyeFJbklQgB+HnrY9eco=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCIgqlr/zoapztNJ0QHlVxShqf74oVO01HdGEeRZ1+WF8vCmjj
	dxylQntdXxBr5196sjhvVDItIgMkd2e8DONC7whe2fibUE4hnnlZ
X-Google-Smtp-Source: AGHT+IGUe+42oaOCNfh33/iFC6htXHjHsWlSmbUzbWJNwInYx75OQd4Yv66ZzH9SsfOWE1yQ2RbblQ==
X-Received: by 2002:a17:90b:4c8f:b0:2d3:c084:9d93 with SMTP id 98e67ed59e1d1-2d60a9c68b7mr60493a91.14.1724255198148;
        Wed, 21 Aug 2024 08:46:38 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d5eba2e538sm2021098a91.17.2024.08.21.08.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 08:46:37 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] nilfs2: do not propagate ENOENT error from sufile during recovery
Date: Thu, 22 Aug 2024 00:46:25 +0900
Message-Id: <20240821154627.11848-4-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240821154627.11848-1-konishi.ryusuke@gmail.com>
References: <20240821154627.11848-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nilfs_sufile_free() returns the error code -ENOENT when the block
where the segment usage should be placed does not exist (hole block
case), but this error should not be propagated upwards to the mount
system call.

In nilfs_prepare_segment_for_recovery(), one of the recovery steps
during mount, nilfs_sufile_free() is used and may return -ENOENT as
is, so in that case return -EINVAL instead.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/recovery.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 61e25a980f73..cd364cd26a97 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -433,8 +433,17 @@ static int nilfs_prepare_segment_for_recovery(struct the_nilfs *nilfs,
 	 * The next segment is invalidated by this recovery.
 	 */
 	err = nilfs_sufile_free(sufile, segnum[1]);
-	if (unlikely(err))
+	if (unlikely(err)) {
+		if (err == -ENOENT) {
+			nilfs_err(sb,
+				  "checkpoint log inconsistency at block %llu (segment %llu): next segment %llu is unallocated",
+				  (unsigned long long)nilfs->ns_last_pseg,
+				  (unsigned long long)nilfs->ns_segnum,
+				  (unsigned long long)segnum[1]);
+			err = -EINVAL;
+		}
 		goto failed;
+	}
 
 	for (i = 1; i < 4; i++) {
 		err = nilfs_segment_list_add(head, segnum[i]);
-- 
2.34.1

