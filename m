Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A421991CA;
	Sat,  3 May 2025 05:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746250415; cv=none; b=devGkU5An0ODFNtHkKn2LDtfdH3g1+sWUEVFY4lYvoxFp/lbdu2UpzI+1fyuk16p12OqYIUIaboPGMnRvgzv7gXlR3lhIRiG2bDI/2DY5ObMBMBFFtUx6WeNiP3xzAv+uzPeXKUdorgDiSODvEfYNmJvXVVKUGydO31Lp/pPII4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746250415; c=relaxed/simple;
	bh=pnnwH9h6jCuQbO2HsVRJ6QZdDhPkUem1LVnM6G2azYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyFHXFQa1YqOy259P5CzMuL34MxvH5XSmdkYe26cnZ3WLUJxYJ0v/m6Ieos/kFV4kwXciy9+/wsSGb+mNA0sO147wU8nQc13g+HYi5yqIFX19g+vC6EO8Vf7hl1AAaKjmFQb4a/9vtOj3v0lxdvv0Ynrkdyen1/jvO+gDKZHtBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XGiLcrhe; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XGiLcrhe"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-af548cb1f83so2780468a12.3;
        Fri, 02 May 2025 22:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746250413; x=1746855213; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rGVr7pzveIQVBJcdkyJ5vlZ9pdt4TQLzihESk8p7K20=;
        b=XGiLcrhett2IOxw3rU25f42FschSAEPzEs8FW1xgI3e6iNbPeHbI+3YJypPjbvzxfe
         jISo6QzybbmMGZ+Spsbc7+LQwxHEuZ8TTrwKQnIXkDk8hjNL0XxOAql+Om6Do4T0/+/a
         6IrH7L9zf5LTerBJFrnlWbaWffIk8ZbIEhAxziQdAO/ZpA9adqwzwktmmMKSXWYpt2dh
         KbNb8C43Lpsk92iWToOuDvcChUZsctAoCSSEdYm84D/17JATz/J7Gs6HfXtGFOBrjf5t
         Z332xkz1P32bseBC/7ojqkIKzSjbdUlDRb7na7ivocjmFyOeIBJwhDDKCfy/2qQn+Oj4
         yJAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746250413; x=1746855213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rGVr7pzveIQVBJcdkyJ5vlZ9pdt4TQLzihESk8p7K20=;
        b=KBfAwqYcbwDzNBVxDlBMKQAShDMewnZbgVofQmdTppyTYHZ7LlDgjRYTwcBJ5dA45c
         bYLYLZTHttYyKSKC8Aog1WKxIg9zhXeUVKnv0Lr3Wq5AGprg50jAFlt2aQdgosM81XOw
         equEEC2nHnyV3HXo3Oi66q6UN3PnRb/k0IUDsfFgB3/inBrqr5l2h6HagGjA+ILAHjKD
         quF7dESoY2cCZx44nuAv0LxMsRTPVIWMfGT7WqHZZnkHLsWYAFue/5s7HUD57aOwVOP1
         Ttn9GfZUpxpou6GYtG2br7tpMIWWEAX8i8tlgoymdTsAuAMTW+/Snq+gtBC8LCBD8F7a
         UZ/w==
X-Forwarded-Encrypted: i=1; AJvYcCWBiCkr3M8hoB6Yx8DgooUkWXAib4XeH/QM5U7J1nNwSq61pEEFDDB07yRHbvtbW1tQsuyICVR3pzp9R9Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXkN20oMl90+5eQXir2snKB7YeBum/mR+cDyzOygEtPtoVzCWA
	lYQoTBmA8nOoOtAxl9PswVDm8kuDnU+u0cqCeQxO5ypxEIl1CoKA
X-Gm-Gg: ASbGncuUc6OWFQNX3GHY9T79gNalgFUlNKHSsvP0jzb+dQYjC4Ps9FDswSm/WlVDbei
	ShFiNItb54bhLd7Q/yaQKd7YoSUkUB66IMXrma5iwzLN8cZgPU2+OzWnpxVI5zkEBWu3oEdjFsR
	ustklV6Hw6A9CMjUrGbnimoHsrZzSsa4l9H17Xfdiw//IJFTzs18F2A9Z61OSuVaYaQaxIebYek
	Db4wDE2InmCOz/XEI04GAYYEclISqaJQgngF2i9YcJfpjejLNnqw5h3yKFhJRPwpUEyG1NjJec5
	oIIV1OR99SqGomGGk5I13HT1eWhv2RIHdNgVqfI7YpDr7M1ic3GBOk8wgD+n/kWPyN+4T5+f85J
	mMZiScEKHxJ/R3GY=
X-Google-Smtp-Source: AGHT+IFzpioxSF0MLPGkbM656c3DDcsrGVrt7fACDHLnvFWrBI30kRDVoDO6TTP4zQYg4OTZ6XXecA==
X-Received: by 2002:a05:6a20:7807:b0:20e:4f4b:944a with SMTP id adf61e73a8af0-20e4f4b94ccmr1021921637.32.1746250412894;
        Fri, 02 May 2025 22:33:32 -0700 (PDT)
Received: from carrot.. (i223-218-150-204.s42.a014.ap.plala.or.jp. [223.218.150.204])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3b5607csm1752418a12.23.2025.05.02.22.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 22:33:32 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	syzbot+00f7f5b884b117ee6773@syzkaller.appspotmail.com,
	syzbot+f30591e72bfc24d4715b@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nilfs2: fix deadlock warnings caused by lock dependency in init_nilfs()
Date: Sat,  3 May 2025 14:33:14 +0900
Message-ID: <20250503053327.12294-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <68118a52.050a0220.39e3a1.0cab.GAE@google.com>
References: <68118a52.050a0220.39e3a1.0cab.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After commit c0e473a0d226 ("block: fix race between set_blocksize and
read paths") was merged, set_blocksize() called by sb_set_blocksize()
now locks the inode of the backing device file.  As a result of this
change, syzbot started reporting deadlock warnings due to a circular
dependency involving the semaphore "ns_sem" of the nilfs object, the
inode lock of the backing device file, and the locks that this inode
lock is transitively dependent on.

This is caused by a new lock dependency added by the above change,
since init_nilfs() calls sb_set_blocksize() in the lock section of
"ns_sem".  However, these warnings are false positives because
init_nilfs() is called in the early stage of the mount operation and
the filesystem has not yet started.

The reason why "ns_sem" is locked in init_nilfs() was to avoid a race
condition in nilfs_fill_super() caused by sharing a nilfs object among
multiple filesystem instances (super block structures) in the early
implementation.  However, nilfs objects and super block structures
have long ago become one-to-one, and there is no longer any need to
use the semaphore there.

So, fix this issue by removing the use of the semaphore "ns_sem" in
init_nilfs().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+00f7f5b884b117ee6773@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=00f7f5b884b117ee6773
Tested-by: syzbot+00f7f5b884b117ee6773@syzkaller.appspotmail.com
Reported-by: syzbot+f30591e72bfc24d4715b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f30591e72bfc24d4715b
Tested-by: syzbot+f30591e72bfc24d4715b@syzkaller.appspotmail.com
Fixes: c0e473a0d226 ("block: fix race between set_blocksize and read paths")
---
Hi Andrew, please apply this as a regression fix.

This resolves some deadlock warnings reported by syzbot since a change
in 6.15-rc4.

Thanks,
Ryusuke Konishi

 fs/nilfs2/the_nilfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index cb01ea81724d..d0bcf744c553 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -705,8 +705,6 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 	int blocksize;
 	int err;
 
-	down_write(&nilfs->ns_sem);
-
 	blocksize = sb_min_blocksize(sb, NILFS_MIN_BLOCK_SIZE);
 	if (!blocksize) {
 		nilfs_err(sb, "unable to set blocksize");
@@ -779,7 +777,6 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 	set_nilfs_init(nilfs);
 	err = 0;
  out:
-	up_write(&nilfs->ns_sem);
 	return err;
 
  failed_sbh:
-- 
2.43.0

