Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5621E89A;
	Wed,  8 May 2024 22:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715206532; cv=none; b=KU2iZpiZy3P0+Pp70YJsM7M7hwOsD5TsVFXhgaFIkGm+hOm23L7VFOBbrkSLfb6IAmvyhRFQC0lmT/n6qnlWID0q/b28SR6Qqb9BGka7OW9Pv1ioyXWk5lSHnW5hCwwWdjOamPKq5HHgUVeJwMI36ogKWGrPBPNyaf3i2ODCQeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715206532; c=relaxed/simple;
	bh=zYvmqBYytu5lrRG063ZNZe74anNEulI5cB5MgQaGA1o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XY/BgaqUVx4bT0rH981tRf5lOsMiVMy8yuDCVd+JICa8tJ4AHGm+SbuPIrpbvqC9bufosrEDEwtxQyifbVfJ9zfMSsE5owtDq2aUdxZTK+4hS6+8wHsG5/eT+RrNh9bMlLQ2Fizk1VSDyIko52hIAM8VfxgSujGbfO+L06xiz2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eXKI4NuU; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eXKI4NuU"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6f4521ad6c0so279129b3a.0;
        Wed, 08 May 2024 15:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715206530; x=1715811330; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OvRrvqgNHBwilgARP9eErTNvt8papjTXT1DLOpLacEo=;
        b=eXKI4NuU2kYWfCrlw+SUgqMyyKcDvV4/vEn/xp0zO24fncLFa7F5H5nqZBjPPj9FNY
         WHaBNQSeiGWf1kWRkKsM31zKOho484tUKumKMPugcR9+B2up97INpY653XrRwEl3PJZt
         c2W2/k17HK9F88GghtZoh6jNBzb05sMTMG/Nps9yft+/8M2GtYBuabsfX8rq8ZZFzGcF
         tRaZ6bs0FeA0Yz6civPPWmHZdvT0j87+y/FxwcHmacytG3G7myRDTVIS2OxK7990nD23
         qmz3ORv6JHuoRfsoyE6z5QWqxnW7cMU+xyvstaOEH+bZUr1R39WNryt16fxZhmrRbX5j
         /hnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715206530; x=1715811330;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OvRrvqgNHBwilgARP9eErTNvt8papjTXT1DLOpLacEo=;
        b=dDAkwHfl9K5o6ygqWS1EWEmI3hdiVK1obd4iQT/AtWgkpkCoM02N1WQdGyvyD5pph4
         3ZIMaL+FWAhWTJEAPgFRzLK3v4tc2IrXDopvxY0f6vFmzkPmeEaRa8/YF26uTG4VLMy6
         VSXPazJXlPz/5feY/wGt2+GR43kjvGuohvp5rje2gsmOgr1O7533d1CjkuPZwl6Gp/F1
         9bfA5wDQ3q7vMdN5ZoobpDyg6FOXmfF3/sqQWbesdTQJknvr6GouXU1Hp+EYQXUkvXyC
         OL7T64Las6HRIO5IZrkVux3/J+XO6xyoDc2+NsJaF3RyqTpzppK+EWJtcj9ic4IQ3+6y
         TtzA==
X-Forwarded-Encrypted: i=1; AJvYcCViWvLCKUKV7739NO09V5Hbw8+zwFY7NRQgXMkRLZONr85av1c3Ljiz3BaDHjkhsWPpeSILINowbX/Gl1pyAVb8wDjZCZgsdGizy9Hl
X-Gm-Message-State: AOJu0YxWHYNj4M6Olh1QIKeSstjH+hputr/L6Huqt5E45pNsjYiZWf0D
	TTP3pCM3coBxsq59fTcwZaH+xD2r5yVxfCHSL6N8C9NtFjsLN9tECYesmg==
X-Google-Smtp-Source: AGHT+IEh1dwN0KLko66GVhIrfD96Ti3gBfpmYP1Ad9GyHui8JFYBG+1nQSIf8iu9Qm2dUhba/y/aBw==
X-Received: by 2002:a05:6a20:9494:b0:1af:c0f9:b155 with SMTP id adf61e73a8af0-1afc8d8eb58mr4085639637.38.1715206530400;
        Wed, 08 May 2024 15:15:30 -0700 (PDT)
Received: from carrot.. (i223-218-106-142.s42.a014.ap.plala.or.jp. [223.218.106.142])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b628ea59absm1938826a91.47.2024.05.08.15.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 15:15:29 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH -mm] nilfs2: convert BUG_ON() in nilfs_finish_roll_forward() to WARN_ON()
Date: Thu,  9 May 2024 07:14:29 +0900
Message-Id: <20240508221429.7559-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The BUG_ON check performed on the return value of __getblk() in
nilfs_finish_roll_forward() assumes that a buffer that has been
successfully read once is retrieved with the same parameters and does
not fail (__getblk() does not return an error due to memory allocation
failure).  Also, nilfs_finish_roll_forward() is called at most once
during mount.

Taking these into consideration, rewrite the check to use WARN_ON() to
avoid using BUG_ON().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Andrew, please add this to the queue for the next cycle (if it's not late).

This is a change to reduce BUG_ONs in legacy usage.

 fs/nilfs2/recovery.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index e48372618ac4..020f304c600e 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -699,7 +699,9 @@ static void nilfs_finish_roll_forward(struct the_nilfs *nilfs,
 		return;
 
 	bh = __getblk(nilfs->ns_bdev, ri->ri_lsegs_start, nilfs->ns_blocksize);
-	BUG_ON(!bh);
+	if (WARN_ON(!bh))
+		return;  /* should never happen */
+
 	memset(bh->b_data, 0, bh->b_size);
 	set_buffer_dirty(bh);
 	err = sync_dirty_buffer(bh);
-- 
2.34.1

