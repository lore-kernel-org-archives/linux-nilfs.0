Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72831AF4FE;
	Wed, 21 Aug 2024 15:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724255196; cv=none; b=ml7737fOXz1ltuxysXjfBFEj4MBFoYAoPoJXjCeVss2Y9GLQngtuUyJMOzf4MhWt7jvN29/mL7+2GUQQyyCTsahKpCsSXjJEg5tZPl4BVaanqhrX0NjbB8NPV2DJRS4ctfKGeqR0KmOkss9gcBczvnl6J5HRz17kNpnmyz3D9e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724255196; c=relaxed/simple;
	bh=YEuexXYRq212bkgPvXGZNVwB2SCy8yMz7BKsaigyPJc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ul85alht4uvoIklzbzXq7n4Vws4t7vEgwFq8m0F+C/zSe5s+RNrT9gd0MF/80BMhE8uaPi2MqRLwde+Gz82qawtxnkj8KQoNNnWWJUF/F1vw2C8aJviOuqKRmToBS+Zw6Vjb1itleUvV0FY2vXVQ1zLl5ydGfoYkj691qxaNStY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AmmKOth0; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AmmKOth0"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2d3dc25b1b5so4207619a91.2;
        Wed, 21 Aug 2024 08:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724255194; x=1724859994; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hXEADUMbFCm+qoMwaOJN5HYjEhgKzPiQK8CXPKHHYyI=;
        b=AmmKOth0RJfd1h6LHG9GxCgHjNgSjZV7oCkf/9jAZ5oML71EHSw3+hH/OCRxoIZ90v
         Z1U7d1MZsJEyNLVJbNJM10KG4ZNZG5U6NNB5Sc60CRGVl4euo+/9QqXE61aA/z9/uaZg
         aKoHZ0qLJOylDhwkp9X2SR4evgQYgVme/s7RoCJ8vRDq29GE066l6Vl+KbE/uVuEzBiD
         eSOvjoe206cqzcVuYxuFyWoTy7BW41XqhIPGKL4G+BgsORCrnsamgQvnpEd82QPrsPt7
         0Sw2ZPo0g43T8hMi85toXA8IbnxfaC4bFJewM9kYE6jrS4HZShOtSCY/MUDUzj/ecOhv
         cpfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724255194; x=1724859994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hXEADUMbFCm+qoMwaOJN5HYjEhgKzPiQK8CXPKHHYyI=;
        b=aX055geX4hzv0PTMX7d5cjIkTi8VxOj4eEndmHdZmHdi8KyAimEiipTJPW/uW3skCQ
         zmt7WsCBf0BF5PaU40U+H39DXx2wbhEEIU+/8qaojZaMKtSOu6iAua1OnLEzillIWPAV
         Q4hOjoXNheHnqoMxQyk/DvDZODgfg7xkk4qRWbTyVvnoM+7ZrifKcyMA6PcvJrmiztnD
         alcdJNQ6INpDB6O0LGKfwFDkvdDLW5S82HV55B7hTfGM8hupkAD8nJq6i5Cv1kr0BN1h
         t+RaFliy9Ptx6nj1oO2buN0CuS89enQhkb0nLrbpXsraOx8qto1AhFK6yrX01WIljd3Q
         bTDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnucQ5BiehBjlUuEUZ/LFMIu1rFIEST8YEmmXd8r+EDF5uzJ6OZrdD270EJgHLOui0GGa8p7W0dnmOtQc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpFWoMt5YgNDxbQ/7NmVYo5hPWkqp0RksZusPKLRspf0g3wDB/
	TsR0qbI+sKmH7pVB17WRvmXrVHYJxsaPt4uG51kk0PMtDaJkkNGSFp3Qrw==
X-Google-Smtp-Source: AGHT+IH1eP5l3JdR3XDw6JOrexumfxNYGwcVtFiAYfuAzVE/xFZs2HP7K1FOxeDC/EITPyd5c97qBw==
X-Received: by 2002:a17:90a:c16:b0:2c8:5cb7:54e5 with SMTP id 98e67ed59e1d1-2d5e9dcabb1mr2998947a91.32.1724255193998;
        Wed, 21 Aug 2024 08:46:33 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d5eba2e538sm2021098a91.17.2024.08.21.08.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 08:46:33 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] nilfs2: treat missing sufile header block as metadata corruption
Date: Thu, 22 Aug 2024 00:46:23 +0900
Message-Id: <20240821154627.11848-2-konishi.ryusuke@gmail.com>
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

The sufile, a metadata file that holds metadata for segment management,
has statistical information in its first block, but if reading this
block fails, it receives the internal code -ENOENT and returns it
unchanged to the callers.

To prevent this -ENOENT from being propagated to system calls, if
reading the header block fails, return -EIO (or -EINVAL depending on
the context) instead.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/sufile.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 7bfc0860acee..f071eba48163 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -79,10 +79,17 @@ nilfs_sufile_block_get_segment_usage(const struct inode *sufile, __u64 segnum,
 		NILFS_MDT(sufile)->mi_entry_size;
 }
 
-static inline int nilfs_sufile_get_header_block(struct inode *sufile,
-						struct buffer_head **bhp)
+static int nilfs_sufile_get_header_block(struct inode *sufile,
+					 struct buffer_head **bhp)
 {
-	return nilfs_mdt_get_block(sufile, 0, 0, NULL, bhp);
+	int err = nilfs_mdt_get_block(sufile, 0, 0, NULL, bhp);
+
+	if (unlikely(err == -ENOENT)) {
+		nilfs_error(sufile->i_sb,
+			    "missing header block in segment usage metadata");
+		err = -EIO;
+	}
+	return err;
 }
 
 static inline int
@@ -1237,9 +1244,15 @@ int nilfs_sufile_read(struct super_block *sb, size_t susize,
 	if (err)
 		goto failed;
 
-	err = nilfs_sufile_get_header_block(sufile, &header_bh);
-	if (err)
+	err = nilfs_mdt_get_block(sufile, 0, 0, NULL, &header_bh);
+	if (unlikely(err)) {
+		if (err == -ENOENT) {
+			nilfs_err(sb,
+				  "missing header block in segment usage metadata");
+			err = -EINVAL;
+		}
 		goto failed;
+	}
 
 	sui = NILFS_SUI(sufile);
 	kaddr = kmap_local_page(header_bh->b_page);
-- 
2.34.1

