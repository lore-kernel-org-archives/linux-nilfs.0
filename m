Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E57149C78;
	Fri, 16 Aug 2024 07:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723794225; cv=none; b=OkEQtO8qtmWfPvpUwOVlwg1JFs1mkI1CqvKX14hdGSpTzqw2NNGbwY+bFuId3kbJNu8En096ICD1iQJMqGDhq4//1Gn1xEwwC23XrpZKDWNX2KGe6C345bSYFw5ynNoAHLfu7cw6AZGU5D+vU1Cs1ofdisNB6SGceXJMq84pSdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723794225; c=relaxed/simple;
	bh=8LyhGFbg1RVPlDjb0DjIHDQvXGoTj8wHjgO2lZc1TDs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LkEWME+tE1ID8z2br3xLd2X5Ye0a10Mv52vtcG6A+15JkjkuYk8lFntd+ntgn8ZTmDbE4unlIYaOG4mFYgh+/LGvlVcWJLmXpvRRc6oJ8Q+C7QxIW73QehHiyjMuDfYCFLAHvGd90Q+H5+aLXUsIcm85twTq6Dj9U+9vTnDdxdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fQTWsPU6; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fQTWsPU6"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7093705c708so1725135a34.1;
        Fri, 16 Aug 2024 00:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723794223; x=1724399023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fNzlLWESxG/0bPC91zjV9bHsAzub7Pn/mV51bKr3ejI=;
        b=fQTWsPU6LT4kar3UPa23CaxJ16v81NZEC69yhyDY8ozazZcz3IfWNK+Z7nrYyxvNpe
         ykusC5PIfy54rRzQeVWGNI6HdV1mwJfBVru/yhGfujN+Y5IRyWHu/aMXcoSbmhg9HTmm
         aOd7poaTGdcrLiFLghA4J5cxjWga7Asdez0KCLMXjd34JF/kL9hc5M/xAS7QCww/41PF
         gAHaJkf3lqr5bv+cuMw5AODcR2fPrq8FtVUVhdkfWl32m9C5u9g+uTItzOzVoZER0IqO
         xHmAJRck32t/77UP4TMa+7B2Cq5NpJPYqiOyasZ3vrwBntlK9xNzQzpM/ok6zHyVwHhS
         wn6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723794223; x=1724399023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fNzlLWESxG/0bPC91zjV9bHsAzub7Pn/mV51bKr3ejI=;
        b=qA+ocr1DvdiSzb+WuIbP8E7WTjwmpfnKynXup1OhnMBy7wpokYC9rsz0E724AF0MBJ
         0vcZs/VzWYLgBRAE/pDaftpel9N0jpWNpVd6PiBtI/2w5oYm5VM+xBtsn79mbtFm1Lbl
         n83mrDmRoCjqxdL4NspOvYLnhuzh54zE6Pj5KjHa9u+r8j/7mY3YBCt2RvNJXn0M5GRL
         aSHRLF2KsPKD8zrSFvbTnNDqtg8Klvhe/i4JlqZ8zC2z5IkYTGMYvFq7sAF+Zf6WaG7A
         K2lVyn+sQ0MiDw5qh73JRA/W+v0n+fQl4Nhp0AONBeGR5558dbJZKokQ6N34iJuFxRsU
         zTxw==
X-Forwarded-Encrypted: i=1; AJvYcCX8oscEjrsY4hHKZ2X+idIPrBrFNeiSit0fQBX3RDG5asdfAxJQxKHG7wJ3ClpVIqG1LCxVZNtZLXjfabMhZ6NG0DcD3aZ8IBC+TE4G
X-Gm-Message-State: AOJu0Yy4LYLgbXVJkHzf7VfqIFjOhHAPSZ4Zg2L9BAzvaGbZOM1I6ZiA
	n5eO5NRpM/QEXapaK5DI0EnfIvBnsgZ+QQQJJ+BmwedbTLur2HtRaCVEsQ==
X-Google-Smtp-Source: AGHT+IEJpVnX9qqYY+I9fLmZoBi0WpcvZpotWxXq33gmbREdf7h+QlQ8gi/kOA8f2ZEMxephjWmb9w==
X-Received: by 2002:a05:6830:6308:b0:709:3150:1f2a with SMTP id 46e09a7af769-70cac8d3c3bmr2329761a34.34.1723794223004;
        Fri, 16 Aug 2024 00:43:43 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61e7c7asm2365971a12.45.2024.08.16.00.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 00:43:42 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] nilfs2: describe the members of nilfs_bmap_operations structure
Date: Fri, 16 Aug 2024 16:43:17 +0900
Message-Id: <20240816074319.3253-7-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240816074319.3253-1-konishi.ryusuke@gmail.com>
References: <20240816074319.3253-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing member variable descriptions in the kernel-doc comments
for the nilfs_bmap_operations structure, hiding the internal
operations with the "private:" tag.  This eliminates the following
warnings output by the kernel-doc script:

 fs/nilfs2/bmap.h:74: warning: Function parameter or struct member
  'bop_lookup' not described in 'nilfs_bmap_operations'
 fs/nilfs2/bmap.h:74: warning: Function parameter or struct member
  'bop_lookup_contig' not described in 'nilfs_bmap_operations'
 ...
 fs/nilfs2/bmap.h:74: warning: Function parameter or struct member
  'bop_gather_data' not described in 'nilfs_bmap_operations'

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/bmap.h | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index 608168a5cb88..5f8c8c552620 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -44,6 +44,19 @@ struct nilfs_bmap_stats {
 
 /**
  * struct nilfs_bmap_operations - bmap operation table
+ * @bop_lookup:               single block search operation
+ * @bop_lookup_contig:        consecutive block search operation
+ * @bop_insert:               block insertion operation
+ * @bop_delete:               block delete operation
+ * @bop_clear:                block mapping resource release operation
+ * @bop_propagate:            operation to propagate dirty state towards the
+ *                            mapping root
+ * @bop_lookup_dirty_buffers: operation to collect dirty block buffers
+ * @bop_assign:               disk block address assignment operation
+ * @bop_mark:                 operation to mark in-use blocks as dirty for
+ *                            relocation by GC
+ * @bop_seek_key:             find valid block key operation
+ * @bop_last_key:             find last valid block key operation
  */
 struct nilfs_bmap_operations {
 	int (*bop_lookup)(const struct nilfs_bmap *, __u64, int, __u64 *);
@@ -66,7 +79,7 @@ struct nilfs_bmap_operations {
 	int (*bop_seek_key)(const struct nilfs_bmap *, __u64, __u64 *);
 	int (*bop_last_key)(const struct nilfs_bmap *, __u64 *);
 
-	/* The following functions are internal use only. */
+	/* private: internal use only */
 	int (*bop_check_insert)(const struct nilfs_bmap *, __u64);
 	int (*bop_check_delete)(struct nilfs_bmap *, __u64);
 	int (*bop_gather_data)(struct nilfs_bmap *, __u64 *, __u64 *, int);
-- 
2.34.1

