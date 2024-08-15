Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC51C18C345;
	Thu, 15 Aug 2024 07:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723707909; cv=none; b=cb4zQYH7x0NkxXylO3jBOhg4Axk5uTJH0wzZOdg6H6/pXQdZOILz569UIo6HbMw+Mw7LsdZ4MLvBep7ud4R05K+dbHgnTtRQ6h/Hd38nwxnnuEK8nZIrVwLPymCjNGvMt1UmS4r+0RhbDTezZfMea+fVRutfLshQsxAKIuHJR0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723707909; c=relaxed/simple;
	bh=/mB/mlfQrIgD0frh/4DcIeHDLda+/2ewOJd7MQOI3yc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qIHWSCWawB7XpR5Uhp7Qp2sjZiAGElhi9QnaEUl6TrwqCQJ10ZJbwtWg5BJbhohl1CeCR+ABShAIrSEYDNyAFpCDSy1RDe8zxH1O25DW/kyeyrVymMTO4Q+bgM97jFa2mFRheqYnG64FU94wfg7q1yGla/rJtWjo4n20kxUcvWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MHkquwVv; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MHkquwVv"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3db504ab5f3so399843b6e.0;
        Thu, 15 Aug 2024 00:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723707907; x=1724312707; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bU0q1yZ+PWK8s4WWyTu7zQH49E1o8+TlEE7m0tArHx8=;
        b=MHkquwVvxeeUUPD1TGK4h+ZMcn5JEfy0OKps0bYAvih9GksV7ejxh+T8pmUMkHrf3q
         x7EE971f/Pdagxl/uahddXv3d0jb2zQ9PAnNvulpsJxI9ePHgTmQl2YsYW8FOjiPPomb
         kRHluAoo+R3Y1O8C1wQito8JLeKYbUBfvj0yZKVQEWX5CSdIX9ys+bUY7I2dc9Vx/soU
         Nb/AzGSVz2MAABkA8ld7p6q7P7hGn+DngYaq/tbCNHaTecrOAFxzxkfy49+Z9LBMf2GK
         8QjGVqiwhEaZDGG0k/EkpycJ09d6jRz8RohWu16Fg+fguBHEjFDl1jeDQJIe6EFXhTn8
         tfgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723707907; x=1724312707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bU0q1yZ+PWK8s4WWyTu7zQH49E1o8+TlEE7m0tArHx8=;
        b=LmVupO7nXLOVOPKGMO3OLbRPEuhbbuGwU32MOWZLsvB64g3VRgBuWOhlj/CoVqFm5a
         q4AN4WV7qnbSk6hI2PyIcm8+Whbiep3m+XKbU+hkk9tn+9vSqU1dZASaRjnWEqWxRse8
         DLUJW2DvLCakSERM4pc4RPSooAFZb9Mz0jZF8W6IXDoSjHcTgQlDD6wsFeQwxZaWXKGU
         VWI1UvdGxUqBS76s6vDMzgQRFbex/wOhEMdduQCjxY13W+WpFI7aHdumQsbXs4qEAdM7
         X4IhpcLT0qn1CvN6EU0YUMaLm11G/4lwTK/CjX48nIFaztmjyIeBubnGCoJRIsuD26PB
         I4jA==
X-Forwarded-Encrypted: i=1; AJvYcCXf+T9BI5kpFQDymzp3GCndSdyHPLuLbxB8jCjydBXu7saR5858jWxFCLjSDIQxcadtBE8t0YTOV9rDYQHU6wxQH6Cy7Cq+U2EoIT2H
X-Gm-Message-State: AOJu0YxOms6vf2SDUnfPB6WYrwAoxjnhTWYPLYhbidl2Du41P2A0mZda
	EcyIae7doaSP1e73Qelwr83+z6Cgz4+SWrGuaUZ3wkRYg4MQ5UBzqvHxeQ==
X-Google-Smtp-Source: AGHT+IGf1Ia5UvOW1nviDnQ+6Olj1OBL2BE1pruYmmbR28+ThG7CXAV9Vh88PbbD3/YTOAWgOEGsCA==
X-Received: by 2002:a05:6870:d60a:b0:25d:e3d:b441 with SMTP id 586e51a60fabf-26fe5be0ac4mr5839090fac.40.1723707906818;
        Thu, 15 Aug 2024 00:45:06 -0700 (PDT)
Received: from carrot.. (i222-151-34-139.s42.a014.ap.plala.or.jp. [222.151.34.139])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127add721dsm584767b3a.42.2024.08.15.00.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 00:45:06 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] nilfs2: add support for FS_IOC_GETUUID
Date: Thu, 15 Aug 2024 16:44:05 +0900
Message-Id: <20240815074408.5550-2-konishi.ryusuke@gmail.com>
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

Expose the UUID of a file system instance using the super_set_uuid
helper and support the FS_IOC_GETUUID ioctl.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index e835e1f5a712..167050b3ce7e 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1063,6 +1063,9 @@ nilfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (err)
 		goto failed_nilfs;
 
+	super_set_uuid(sb, nilfs->ns_sbp[0]->s_uuid,
+		       sizeof(nilfs->ns_sbp[0]->s_uuid));
+
 	cno = nilfs_last_cno(nilfs);
 	err = nilfs_attach_checkpoint(sb, cno, true, &fsroot);
 	if (err) {
-- 
2.34.1

