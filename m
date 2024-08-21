Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509271B81CB;
	Wed, 21 Aug 2024 15:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724255204; cv=none; b=Z4OeLrBNdOoRNqBouAF7BwMDqJ8GigxjLCWiFOtjAgq10uJO+XQ02LB5n2gO8N9s472QH4I5Owr8qRAjP2YC2qNwRdbV9G6Dr7e+g8cSp4QqIpy4gf2zVZI79NfCgANnI8IJ7LFDt/Yi6sJedisDr/2qLVqSTFV8PFScJrXkAzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724255204; c=relaxed/simple;
	bh=JFhvxudKAyDcJoff+u30SQwG262RmxSemzEJxC4bf7k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H/L1oxBoR/+wd9BSJwGQK6bPjWZGYDqU9bg9yxVxn+7jekT7mf9EVCsE/jBKNUfAmiscQNGPLol1tvdLkoq+SZ4hyx0UPlEm4/Fb3NEPSHqNMrtf0O+qea7mxmY5EGN1nvrRJ1xsdO0u5RiBXWDNfJ0OJ3dbVTrsgDpKFfn5JJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TgIfCWgq; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TgIfCWgq"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2d3c5f769d6so4797345a91.3;
        Wed, 21 Aug 2024 08:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724255202; x=1724860002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sJ754iKlMI0/FfjFl9UoTlxsvxa5x9Z9ZGZU52BNo2A=;
        b=TgIfCWgqiNV2SC0Foy4z7xlaci37ZfHW+R4IuH4uG3qxwxFcr41yVdwmJF1nkZSlYt
         HtD2CtgjDzEEirHNNjRnzw6NE7z7+DSB94Z9zo29l4Ees9MJ3WAEdv177/7mkROTSysO
         79HjMFhGZ2GkXrBtAQiJzp+G3hVlmbprcWvYmqLesOMtZPtLysVNHiyc04ujCdXqK+wB
         QYAmTKmpeLzbZMY+AeRcnRV/lIk8CmCmHcv5vG4n5rSVtfTlV51GHJKaw7kvYYrAWAmQ
         Bxx7F1qIAmvPEwzLh6V22fLdydphyr6ZEn7b6O89RPeUODo2Flyh9mwxQOrx4qDw40b8
         toBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724255202; x=1724860002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sJ754iKlMI0/FfjFl9UoTlxsvxa5x9Z9ZGZU52BNo2A=;
        b=ij1IM/QzWtBa8HxM2ONc0pq5ZEvNbjfZh/bDqPa1clyJ0TduWsdBAbQNBapTy1cpee
         QeWtOLD9VrHKcbPL1YYoZGx+tt3OvCG9r3VHD3UgMLVwNwZuvM8LNoRBv9X0JLR+5lVe
         5hJXXA9kSxOXq3Vd7C2uk+ZKh5J5dTkAvyHHYwfvjywOYBFStsRrVbJ3mkjaHYMyxUIH
         Mfea4/rjj087j3YMkX8LnFE/Oju3RoaeOVdPNzAv93/OIF3EZ12TUXGg051sg0oBwo4m
         Nh8eJR2PkfDufxmTRYBUjqMETPaNwecTAykMoYY9G3xPad/3i8wS8QWwAv8PV+fegZAR
         oToQ==
X-Forwarded-Encrypted: i=1; AJvYcCWB9GwdZzz4ll41UYV6UWkNr3i17bS/NM9qFJRfvOqo063D3IWfPjmI40SvC1vkjrLr88K7jFsFbLG8QQg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKI5m/096PX2Z6We0Li+1XmD1DDbCi5To7wiqLeVv4wkmYfsfr
	iK7PiQFNZLTPhIEEhL0P6p23eHmKMCC1jbJvY+77gs69nwvV7P20DHgFSw==
X-Google-Smtp-Source: AGHT+IHfGsDV7o6EBNNiTzBgeLr2GJHrti9TDmVj/Y33OPr4IXAGi1WakkKwHV1OzKV6vOzEt6F4Fw==
X-Received: by 2002:a17:90a:b00a:b0:2c8:da73:af82 with SMTP id 98e67ed59e1d1-2d5e99ec785mr2906918a91.10.1724255202323;
        Wed, 21 Aug 2024 08:46:42 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d5eba2e538sm2021098a91.17.2024.08.21.08.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 08:46:41 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] nilfs2: do not propagate ENOENT error from nilfs_sufile_mark_dirty()
Date: Thu, 22 Aug 2024 00:46:27 +0900
Message-Id: <20240821154627.11848-6-konishi.ryusuke@gmail.com>
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

nilfs_sufile_mark_dirty(), which marks a block in the sufile metadata
file as dirty in preparation for log writing, returns -ENOENT to the
caller if the block containing the segment usage of the specified
segment is missing.

This internal code can propagate through the log writer to system
calls such as fsync.  To prevent this, treat this case as a filesystem
error and return -EIO instead.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/sufile.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index f071eba48163..eea5a6a12f7b 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -513,8 +513,15 @@ int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
 
 	down_write(&NILFS_MDT(sufile)->mi_sem);
 	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
-	if (ret)
+	if (unlikely(ret)) {
+		if (ret == -ENOENT) {
+			nilfs_error(sufile->i_sb,
+				    "segment usage for segment %llu is unreadable due to a hole block",
+				    (unsigned long long)segnum);
+			ret = -EIO;
+		}
 		goto out_sem;
+	}
 
 	kaddr = kmap_local_page(bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
-- 
2.34.1

