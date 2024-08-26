Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B521991C9;
	Mon, 26 Aug 2024 17:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724694097; cv=none; b=TEdp0uNKBXYXl7LtTuHkcmPoSNtfbrjm/3keDCTP1xbugs6dm0P7QPZAtRs+WAfsXyQSpbCWaEcxyRsJaiLkRPAR2t+pKOSSeXi+I+w8mGcTsBPa7l2Tn/C/8yQgDucGdczjojmymHyakaBrMfIqgL2xTLrbn5mRIF/Tah0M9S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724694097; c=relaxed/simple;
	bh=2s+R3X+6d9hrFj0u7Wf5JEZyteFBCxrbQzEt/SyOWeE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VaNx+urzYgkh4nrlgafQsoOwLoRe1j04PHbQ13ZKyS79hTjjuO6a+HPQV+TlcjJDukZ22soVkvquFsFHJvBCgWekyOWv6OdpO43jH7RVyQy75GcJ4Fb7dco52gN2scKoMGJCeqUSRxQeS3UhtpOu1PIhgQwFudGWzkZh5XfSUxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ixyRpL2E; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ixyRpL2E"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2021c03c13aso34137975ad.1;
        Mon, 26 Aug 2024 10:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724694095; x=1725298895; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8fkI07GsRrIlEcuKQ1pK78Clu2EL4VeyO3HrgEkrrck=;
        b=ixyRpL2E4mvkKuG96VH5fvSy8YpTyFA3aypJyfBUXsoIIlYXi+FC8d82pQnK8kfjvr
         XAqmKkZ3UOefy0QgdlqZG0JkzExQfMVvrt6y3Jc2j5b28qMMGLsxQnOc3WHzM2V9t6F4
         reZFUOTBbnQmDOyNiZjG31hXAxGbDg5+gbANEq7G7StZAUep4rye8bFxPvuJ529YI8rc
         X8D8wugUeEslJzKMAF9X5c+/sqmD2+P9l8Zy5B8T2M9QLZnHuQaTaqr17mcBjRfUumNj
         LdlaqRYAYvN+73dqgSqm8NwO5vktefmNX5yv2IIK9C3tYDyrlFQWI4snPzU+lrUJtZAZ
         Dktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724694095; x=1725298895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8fkI07GsRrIlEcuKQ1pK78Clu2EL4VeyO3HrgEkrrck=;
        b=WkRnUMoZ2VEYZ/OUTj2/eA3i4W+moSW3dNkiHO2PmijNjQUxZNV3ZhUcluqoAcYku9
         r+3WYd/fBuJFszPLyt3rVoDHPKjndYbUx6MG4KjOnpVMPhbuweP9G3L42lGUU68eLybt
         4Y0hr5fy+GgjXf248cH1yuf8Q5p0I/MTNTzZ5d22Rj1e0tQlb9jw0GYHjYjTfSaAzKfe
         gNn8y/6eWBQEoTx06qJiUrLnlIcKTV63psir+REoqRUnrC5uGGqhXYMhqTiCiEY6kOkw
         HV/vqOXbBUx8qyttmymfHLPGC0iqidP3jAtBY8T+M33xNP9XPOpFDYX02LNLJWwJh28l
         /Jqw==
X-Forwarded-Encrypted: i=1; AJvYcCVD80MblBki9EI2P9oTl9hY+g3MU9BLM3A3qkzQd2ydB0/q52moIpQxhS8Th8LMtLZA9wKqZdtaepLR+KE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyerZMNG8Q//rRqtUFLWFQnc8hlIXIRJZ13zNlSrNQk5EZFij7L
	LvsbTgDWxZ8E9VNoRshxkjoWL1r6Wz3JXLgY/6TYb47dM23KYzbLwXCeQA==
X-Google-Smtp-Source: AGHT+IHTFfDs7jD0NoK45VdOAOpIUBuIgFY5mFUesDJ6HOkDaj9FmAAby+5Xabw0TJvKhSpLPPjqEA==
X-Received: by 2002:a17:902:d507:b0:1fb:5d71:20dd with SMTP id d9443c01a7336-204ddb87a51mr6478495ad.0.1724694095249;
        Mon, 26 Aug 2024 10:41:35 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855665besm70057055ad.34.2024.08.26.10.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 10:41:34 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] nilfs2: use the BITS_PER_LONG macro
Date: Tue, 27 Aug 2024 02:41:10 +0900
Message-Id: <20240826174116.5008-3-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240826174116.5008-1-konishi.ryusuke@gmail.com>
References: <20240826174116.5008-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The macros NILFS_BMAP_KEY_BIT and NILFS_BMAP_NEW_PTR_INIT calculate,
within their definitions, the number of bits in an unsigned long variable.
Use the BITS_PER_LONG macro to make them simpler.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/bmap.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index 5f8c8c552620..4656df392722 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -87,9 +87,8 @@ struct nilfs_bmap_operations {
 
 
 #define NILFS_BMAP_SIZE		(NILFS_INODE_BMAP_SIZE * sizeof(__le64))
-#define NILFS_BMAP_KEY_BIT	(sizeof(unsigned long) * 8 /* CHAR_BIT */)
-#define NILFS_BMAP_NEW_PTR_INIT	\
-	(1UL << (sizeof(unsigned long) * 8 /* CHAR_BIT */ - 1))
+#define NILFS_BMAP_KEY_BIT	BITS_PER_LONG
+#define NILFS_BMAP_NEW_PTR_INIT	(1UL << (BITS_PER_LONG - 1))
 
 static inline int nilfs_bmap_is_new_ptr(unsigned long ptr)
 {
-- 
2.34.1

