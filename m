Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4738146013;
	Tue,  4 Jun 2024 13:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717508526; cv=none; b=Xj234ak+oI4rKRbHYGiZvkoI5rgc69OwGtPp/YFDoh6GbuL8PCmRzwimIyjm4OWMR8YqyyMPC5IElXVhripBVYbHTYlTKOcwRN0LNDdzI90B+XXftFMxWUbE45zS0uFSbWc+Y62O1Xa4nHeTGHw2yKDA0pXowaiLpWeji8+UPAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717508526; c=relaxed/simple;
	bh=NpiGOU/wc8bprEs+G3H4btUN0UKgYT+8jImA/+loXlU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gw7bQMSXRBoRXtSzUV2Owr0GcvFt8xa4/pi6K7UMkI6Xz49bouG4uWV0MyJIv8QqbaQYcZh7QQjOxjtmtHcvz8vwgcqrA4R6SN1lUUmlOin9duMEt7FHABSaKVlHvls9NSo7pJHQQHV1Va+WJrfPxKQqLkcuzpNjjxWExjRXlng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D4QzNjO9; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D4QzNjO9"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-701b0b0be38so4935696b3a.0;
        Tue, 04 Jun 2024 06:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717508524; x=1718113324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rj3ma7MoGTsKwEShYWgennrGInTihdBJ4l4EKp81zZk=;
        b=D4QzNjO9eS9aFctXGeeUgrQUspWyzIX8aTmS/wkvNfHWNh9LKqPK988HmUf+3v+2Wo
         2x31lpdgLVCtIIluEyUhCmhQ3dS53EZSOy5B0WX31FF3iljAejYKe1Ulq5C6MQne78Ed
         pf8QdIuARSyMY6UXnJsQYX8IpRsvPwqgI0LsSVOGFSgdWHSQbBXJQ7oDOu/BZBsf48A8
         RBkmhDyhhoySeVzNdcmJ4wjz6xZzW19JUBbQ8dSd9ufePcPGPsXf2sHZhcjPXDbix3On
         UqEDZ8axMkNGXkb84ybx+pu0y1A8J32iWOQ/gjFM3r6F2oJxn8MEZDU768fLscauRYqq
         GhxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717508524; x=1718113324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rj3ma7MoGTsKwEShYWgennrGInTihdBJ4l4EKp81zZk=;
        b=nuUvY63IHhmFIu97NZJoOhD0VQq5zG/Fge1RjoZWCdvh7tHNucUj6nUdbN3/bVzYo+
         zt9UyPtB16os8thPywruwsrcm+/qZqvhz1hcc8NgDxpwUGyDtR/Z8YmcMaJ9uP+ZWzwx
         qt8KYc9bmtG9EGZurqMCHyHVofU1bwlnATDMmbvUUklC0Xyp4QngvSRhReXzhV3Jt6Cy
         L+gktN5Pm1FEEI4sSGWPYO0YuzoNhW9DPtKTXl1i15zdB4woAYvVm7NSrBMP2ZDh5G7T
         vInyUbDcwlybTMWfVJAf+mI76QRmcZJG4NHCc6/VJlrJ1uci/hVb7EjcwGSpbP+peSlG
         a2HQ==
X-Forwarded-Encrypted: i=1; AJvYcCWICCZyDfJkb+8qBtEITi712wdygJPEQk16Xr3LQvGhk75OBr9wU6PcvcnGuCD5whzWz8HnIAdC2O8FsbtMoco+Xzx9lhM+0NYu+MXh
X-Gm-Message-State: AOJu0YzMEufDpOZxXUuoIrv5XDo+/8l5xJRjTwFCIcygAv2fxrbXjOBI
	BbSgitmPDy+Vq09DtJQ1vZ5pnXpGJ+MQC9xJxsiOgUg3net75J+6IwyxOw==
X-Google-Smtp-Source: AGHT+IFsLgU6qa4slPEBxZVz54BIxZGe3KUMxrE3IkM4CUIAOHQZ7w8G80dMd9GZn28i7cNNiqKQnA==
X-Received: by 2002:a05:6a20:9187:b0:1b2:2893:4c30 with SMTP id adf61e73a8af0-1b26f2cc0efmr13513674637.43.1717508523859;
        Tue, 04 Jun 2024 06:42:03 -0700 (PDT)
Received: from carrot.. (i223-217-95-32.s42.a014.ap.plala.or.jp. [223.217.95.32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6323f6dadsm82903925ad.221.2024.06.04.06.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 06:42:03 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	syzbot <syzbot+c8166c541d3971bf6c87@syzkaller.appspotmail.com>,
	syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nilfs2: fix nilfs_empty_dir() misjudgment and long loop on I/O errors
Date: Tue,  4 Jun 2024 22:42:55 +0900
Message-Id: <20240604134255.7165-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <00000000000020f6700619e765c8@google.com>
References: <00000000000020f6700619e765c8@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The error handling in nilfs_empty_dir() when a directory folio/page
read fails is incorrect, as in the old ext2 implementation, and if the
folio/page cannot be read or nilfs_check_folio() fails, it will falsely
determine the directory as empty and corrupt the file system.

In addition, since nilfs_empty_dir() does not immediately return on
a failed folio/page read, but continues to loop, this can cause a long
loop with I/O if i_size of the directory's inode is also corrupted,
causing the log writer thread to wait and hang, as reported by syzbot.

Fix these issues by making nilfs_empty_dir() immediately return a false
value (0) if it fails to get a directory folio/page.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+c8166c541d3971bf6c87@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c8166c541d3971bf6c87
Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: stable@vger.kernel.org
---
Hi Andrew, please apply this as a bug fix.

This fixes a bug in the empty directory function and the resulting
hang issue reported by syzbot.

Thanks,
Ryusuke Konishi

 fs/nilfs2/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index a002a44ff161..52e50b1b7f22 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -607,7 +607,7 @@ int nilfs_empty_dir(struct inode *inode)
 
 		kaddr = nilfs_get_folio(inode, i, &folio);
 		if (IS_ERR(kaddr))
-			continue;
+			return 0;
 
 		de = (struct nilfs_dir_entry *)kaddr;
 		kaddr += nilfs_last_byte(inode, i) - NILFS_DIR_REC_LEN(1);
-- 
2.34.1

