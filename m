Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5361991BB;
	Thu, 15 Aug 2024 07:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723707911; cv=none; b=TSkx/4prWHqU4odRRuRbuKUxLh8jrXAJHbMSEvUV4HSIgxylEjBjChPGGsCvN7lDp8zgHem21Q+h6OH2dKx+nvs9wvj9TZq5KALqw1gpYzpmf0lEmUvAHC6pkjrqmuPKDf/+Cyomb6+7V25ngFpjaLYkY79vskkRz8HGBTbVR+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723707911; c=relaxed/simple;
	bh=IDvYOCVCPbT/qeH11iEvMpxTuSmtxkTPmEqG9TXDLh8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A0v4hXOAaLpEYrDG524Iqw3K7FsoYsKJJIl4bAv76zizFNQESxFPV52gHZwWqU7xr7OLvbvBL9qNqElKgSMKYMqBrUsfby8NaBXwKUyUs4hk2HXvPLb/1JFtaWXR8bhyAtwsWhur6eiklix9b29rDTidBBFpHYNVBWxVRHKg2oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NLsGQcop; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NLsGQcop"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-70d199fb3dfso509620b3a.3;
        Thu, 15 Aug 2024 00:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723707909; x=1724312709; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l06nKOKRPIo9HloPx88hF5Lof023RSJ43kuiUzqTLDE=;
        b=NLsGQcopqInTAfsmVIN+OrSNpxcgqB7MsbS2VUMJVgGaGXBQXFdHa3MzN6b52DXLVh
         A+tUfWA9SCTRHxdSfHR81kVAhDqhpph9bWpJZOmuoFL0tplZJOzgbMgCQLbN3fcEl2qP
         bUvCK89yS0v0QG2AsSQuzDAB2eL+XbxwQZRLMtrV68srUZTFqDOv2vEjMWG4GLjgJ2Mn
         DypBkGPFgcBikSq6ZZar/XW1TGtExg+8IQ0ysx6XW3suL9QGv9urG6J2+zOGV+XD5pPq
         0zD0VXu5VF66xSrAoK8yAKXAt8/BWJ6q1K77OfziT6caHclikHpl9Wn7RPJWUmk1OSoE
         PnEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723707909; x=1724312709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l06nKOKRPIo9HloPx88hF5Lof023RSJ43kuiUzqTLDE=;
        b=fbmP9DsPuUCjDQwTMClak8Oik9JU1qaHUU1IgzP0GytVwLy0qfXZBak6zVzkyBwMbW
         0G7bsOntx4/B6KzTvz3HhWspKVF61PDmpPpznkJ/Ali2xvugjWRuHZBvZ0rnnF61/NPJ
         4+ijrhJDrhS6vF9o4wb4bv5QfmgljZvT9bTxMr3KeyIyAWkz9D+xRcw13b1WszakCHyG
         XnW9ZBf13EhblDaGkLRfInJX2GD5qK/ClujxHJPjoD80N/KQ8dwLvHcw18E52orhs5MW
         cqRqxrI7ki/i2iiEf1QqcvTYW7nU/TebtQ9y0Lo6OZk2f55v7e5CIX+Cb+If+sDqQE/R
         rmXw==
X-Forwarded-Encrypted: i=1; AJvYcCVXWbxYkcsJ8KVLVpJrzNrgT0r9fBeGNkMXPqIjCigTWgdFc1pIRp46E/1EkcoOWgv0unK4aMxzqH6v2tLG0Y0xkMzBf7nIxGql1kw4
X-Gm-Message-State: AOJu0YzS8XeWS2zptmkIuZmte5bC1NbWusxhqKd/TkkJlAAWYBJB2fFH
	D3EKnzYPetXMhN1sFtC2y/Q2ObMG55GKVsFhfgWqo8chknVBzmLOwaRtYg==
X-Google-Smtp-Source: AGHT+IHGNIWz3NPAKuxFCFBnV6PN4X0LYw6p9V1/mKoQgIG6Wk21ZTWjGkwb8gd0agiV5yzBDFvdfw==
X-Received: by 2002:a05:6a20:49a1:b0:1c8:ed18:b552 with SMTP id adf61e73a8af0-1c8ed18b57dmr4349601637.2.1723707909087;
        Thu, 15 Aug 2024 00:45:09 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127add721dsm584767b3a.42.2024.08.15.00.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 00:45:08 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] nilfs2: add support for FS_IOC_GETFSSYSFSPATH
Date: Thu, 15 Aug 2024 16:44:06 +0900
Message-Id: <20240815074408.5550-3-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240815074408.5550-1-konishi.ryusuke@gmail.com>
References: <20240815074408.5550-1-konishi.ryusuke@gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the standard helper super_set_sysfs_name_bdev() to give the sysfs
subpath of the filesystem for the FS_IOC_GETFSSYSFSPATH ioctl.

For nilfs2, it will output "nilfs2/<dev>".

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 167050b3ce7e..76e35e6773d1 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1065,6 +1065,7 @@ nilfs_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	super_set_uuid(sb, nilfs->ns_sbp[0]->s_uuid,
 		       sizeof(nilfs->ns_sbp[0]->s_uuid));
+	super_set_sysfs_name_bdev(sb);
 
 	cno = nilfs_last_cno(nilfs);
 	err = nilfs_attach_checkpoint(sb, cno, true, &fsroot);
-- 
2.34.1

