Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3EF1CBEAD;
	Tue, 19 Nov 2024 17:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732037050; cv=none; b=o1YhrfthKXty28xCrI/qNvSlwoYc3x4RS7ohnHT9A0kNnkYL/dGNxfF3VQFTCYPMCpgpkz3mvzoMYNQojNibz1K27Po2hyG1Vao0BuEfauo9oz99CnvG5JEejQTbXNk3+0D+P8oLnoo9k/oUDLvQvk5qczDsHbeS/X9pyDKg1c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732037050; c=relaxed/simple;
	bh=cMil2pur+KBm9u09/bMWkblEQziartoZ5kizC/Nlqhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q41egsj0x10lZzWW7ZhdDVN//DffCaXO+lm6GgOr7prbisjOf9FevG621bEBYMwt0RT0aH2eyjoQN3IKZq9A3kVDgPeqNzAr9wPHZhjrp4BZ0/G47qIqJCkvIgb39T8aSvNyTC7iINkV9mwmSeZk+ppOQZBDSH15AORL1hyL470=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MjDpy/Na; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MjDpy/Na"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7ee11ff7210so2916706a12.1;
        Tue, 19 Nov 2024 09:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732037049; x=1732641849; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a994QgEYvKCbl+4fSKENhp+gY0CvPXweZu4rmnsb44g=;
        b=MjDpy/NaIHccs/khiCvHgZ0qV8Eg6nUGgMEQ4Z2x5aMChoJTA91Nk97WBIoaNLsZWn
         nVIxnGBXmlypLaB9eqbMYWOzU7QSatu8jLB9ur8Lt4uPb+npQmavR9WscZTqOT71Ks/X
         zuyc5zyJo5CL210XQ9HWNUzgpPws2MjQo2LihY6IPaqoms5wI+zz8OtnWvJWpXSAzIWE
         10FNA45ybyWPf4wzBLfQRj7tLmVCOyfU0XtYrTIqigFZL3KsDY1OUrZaphS4PvQxhKgY
         BFFOVnCp5Oy/b/LAdZs1U1OWgX2IE9Tx0zljuIBZY1PcpBWO4I1yHG7ovI8LBxif9+Ma
         j4kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732037049; x=1732641849;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a994QgEYvKCbl+4fSKENhp+gY0CvPXweZu4rmnsb44g=;
        b=cmeWBW6e4u4MQOIqBry15kazXHLVGIwfaKbkJX1CTTYlHIZ0svDUvfF4DLdoLRZvc2
         UQAhamLXvJeyrsgeX/0c59TfRraTYjGh+E075fiXblRkCD2TxF1mnPsvwOcTLOXwU41L
         Vml4+2hqJG5YHf+lexbY//p3qy9hCKZ8L/dN+l8clmF18HE/C9sFArGTDFdHH6xePCfF
         f9oxyz5UTW7FLVUjAc6iQ7MfkvnWI7z76K3TkiZhNVK35Eabl23HT2BZic/fVnwf5UFH
         QtDgsqKDzVoa6C3743kmoguJIp8VqTIzXrKOQ/o8zeOUjlyQfEqbsLukTkeB5I0YorO7
         UMVg==
X-Forwarded-Encrypted: i=1; AJvYcCVfF/QP0REzaygurm8Eg89MiH8Fp7PaaQOesmyeWoGmRXaTsurOu1IiqJKRH7TQF4a08oYiMQXpk47kBA8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZr9ZSQtM9eJkj4y9HLJbUSPLfgVV6IXatCO6PiGqNLcKyA+vb
	T//y/vsapQRVaa9z05uLiKjVFlPIYebAtoQIhD+6AE5hkRuufZIR
X-Google-Smtp-Source: AGHT+IHlb3j1ZVwzLqPyzvCoxRdYjejFShVvJSV6YVQTRMuPiZToHT3qfLJQGihC9TdFI4m/K0Ljaw==
X-Received: by 2002:a05:6a20:72a3:b0:1db:eead:c588 with SMTP id adf61e73a8af0-1dc90bb7adcmr28658664637.29.1732037048665;
        Tue, 19 Nov 2024 09:24:08 -0800 (PST)
Received: from carrot.. (i118-19-249-239.s41.a014.ap.plala.or.jp. [118.19.249.239])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7f8c1c176a5sm7942720a12.3.2024.11.19.09.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 09:24:07 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	syzbot <syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com>,
	syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nilfs2: fix potential out-of-bounds memory access in nilfs_find_entry()
Date: Wed, 20 Nov 2024 02:23:37 +0900
Message-ID: <20241119172403.9292-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6732e1d8.050a0220.138bd5.00d3.GAE@google.com>
References: <6732e1d8.050a0220.138bd5.00d3.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot reported that when searching for records in a directory where
the inode's i_size is corrupted and has a large value, memory access
outside the folio/page range may occur, or a use-after-free bug may be
detected if KASAN is enabled.

This is because nilfs_last_byte(), which is called by
nilfs_find_entry() and others to calculate the number of valid bytes of
directory data in a page from i_size and the page index, loses the
upper 32 bits of the 64-bit size information due to an inappropriate
type of local variable to which the i_size value is assigned.

This caused a large byte offset value due to underflow in the end
address calculation in the calling nilfs_find_entry(), resulting in
memory access that exceeds the folio/page size.

Fix this issue by changing the type of the local variable causing the
bit loss from "unsigned int" to "u64".  The return value of
nilfs_last_byte() is also of type "unsigned int", but it is truncated
so as not to exceed PAGE_SIZE and no bit loss occurs, so no change is
required.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=96d5d14c47d97015c624
Tested-by: syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com
Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
Cc: stable@vger.kernel.org
---
Andrew, please apply this as a bug fix.

This fixes a potential out-of-page memory access bug recently
reported by syzbot.

Thanks,
Ryusuke Konishi

 fs/nilfs2/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index a8602729586a..f61c58fbf117 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -70,7 +70,7 @@ static inline unsigned int nilfs_chunk_size(struct inode *inode)
  */
 static unsigned int nilfs_last_byte(struct inode *inode, unsigned long page_nr)
 {
-	unsigned int last_byte = inode->i_size;
+	u64 last_byte = inode->i_size;
 
 	last_byte -= page_nr << PAGE_SHIFT;
 	if (last_byte > PAGE_SIZE)
-- 
2.43.0

