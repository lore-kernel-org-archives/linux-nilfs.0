Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7814D381B10
	for <linux-nilfs@vger.kernel.org>; Tue,  6 Oct 2026 09:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791277397; cv=none; b=iyc27iDaHz9gw1bCuQe0scisLY/GH23D4t4uJnVQvYWRT6jYF0fgkoWSTTWtibqreRcaBUvCx1vCxFHrataRvdu6BMuop+bkBwh2cdA7KrjTUvyIJDLsjniACaIF/Hd1sH6/U3xnpQwR/aWpN5HIb0zKJlGsK9I52RD4J0uGTQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791277397; c=relaxed/simple;
	bh=o4BW5J8ceg7xnt3NcTJKNGXIbgaQotqUIkiMmP02YGM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UaaHKIdMfn2kQGrI0Q/XkQGB0eSHAwFkptWnrVSxUEPnGe5qrZlS6Gd4xyVS8J7Y7RW3L6RXtVaxXw7OLg+3R1Y95710McGygPghqlkjJ0U0dCIqJtgjXMGinrhaDxShy7YE/bxwDYEkeqerflTZcm5m6KwZbls1X8863JPaJEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q7DVpSwu; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q7DVpSwu"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cc4c02ddd62so1057686a12.0
        for <linux-nilfs@vger.kernel.org>; Tue, 06 Oct 2026 02:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791277396; x=1791882196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jv16xH89Xx9NsAEAWDIJw2mIwcZ7SQIk9fF3fRGYISI=;
        b=Q7DVpSwucr+NQyy80F8lbsiZji+oroqlxoiSjzeqRsBPuBrDqbEq7nYyGYB9LM2InW
         v+ODk0Dn43QMmODHMWk68sk1BVdW5qif3uLCtRd98e4E4BzGxBIO89UvhQ2sKhgzRy2v
         cy4D195EVEkAZhi6YdbiFN8TWXlBy4rVnoQ3NtQD/kQVGLoTt+h+0Li9QAOJqQGNBvKs
         cfXkMR5JWJ/HjRYmcByQkOvMmgFpDeh3agvaiECNt/CBHT+tK0IHlXV3oJTxtkn9GCL1
         Rn370bVh+eXvgeFuLPxbPIER4CyV/2/5snol551gJnaBkUG2erZtg7YhQPDsqUT5Jt+L
         ShXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791277396; x=1791882196;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jv16xH89Xx9NsAEAWDIJw2mIwcZ7SQIk9fF3fRGYISI=;
        b=lTeo50A7myyV8CRgwjGMH+NwPuxG78qPSSwPN0Fmsyy7yOlkvYSyg/MaGGbdrxnzZa
         WR8K+/9zbiPrsNQn2/LDsqqt3O3pE69Z1P9buHr2fvfJwfGLvTP1iftLtyXrM7uVX7gE
         MIez8xPGd9/biKmTG3PYsPRKfHyW/K1MDLdIz+hrNaxAVWnNY/IO3YCRHM6KQRjJ7kCh
         hIQc02GvGKheESnefomctBUNpx5L97lmU462gTq+H0VPbTPfCcy7FXo/Ac22UDouKm7r
         tAHXippRUgsowFFIc5by9mfWNRWpg7qXjezQH2+63g20wQpRXM/XCjClMD6PqEPKNzWX
         wMjQ==
X-Gm-Message-State: AFuF++lIoYQqVHPx8BXfYq7/gHZameFgD4+FHcCAHKi9niEfOyLM7e+u
	FzmoBcs7wwfDzKyfbl5j78KRl9srq/i8yHn4LMzxbJPMBT1OiGrLTJ73
X-Gm-Gg: AYBFou2f5ZFdQBcyrw3t/4z3WDmZaMF1y22svdjdE59KJJ8nscZjJThoqZyub/SKb9E
	NewVBbjgUiJb7VfQv0c1UcRAwbC4HtZleLWMLXJdVn39XubAy9/Ed4ukeWhUXTPMRWsQWw7gAY8
	EOwx12rqVyarE7FOLVPw0qtf1ohhNtNhE4Z2zmlI95T2/s7YPTDFH/A3gTP2YqlVczO2C0KXiAl
	iLrIFm/3V+j9Rl8ig9AaCOy8ojNiWO+6YJiDTD92BwS6hrC2RTdfforjrtdgUMabIUbdAsjCLIY
	9xuS2ewuzZApUQbQn+nXXud7I472kZ8uIo3uJtFqxplTN/6wPAemVImYsxR8FVftF4mhIJD0Xh0
	45+97+foe+2QAJVCgVrAMVm6GyX58Kso2N8s5rXrE+27Dd76aOZLlCJHvl6rdzXPjTg3cw/IwSw
	qjfmokrUbFtIQrkL2GQhX36SQmlJvzdqufPOiPE5Fi5sfe4oTiVX+4pac+KfwsOBkzgTbiY/bF8
	oETlLJmf56wu6OrKLCh9qbKYgLuirIKtS3ONEaBqP34U9n/JcJe
X-Received: by 2002:a05:6a21:7303:b0:3dd:85aa:d266 with SMTP id adf61e73a8af0-3e124848916mr665141637.30.1791277395654;
        Tue, 06 Oct 2026 02:03:15 -0700 (PDT)
Received: from carrot.taila25129.ts.net (madb688455.ap.nuro.jp. [219.104.132.85])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cce6dce5548sm2105081a12.20.2026.10.06.02.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 02:03:14 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] nilfs2: fix link count underflow when removing corrupted directory
Date: Tue,  6 Oct 2026 17:48:25 +0900
Message-ID: <20261006090311.47123-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When removing an empty directory with a corrupted link count (e.g.,
i_nlink is 1 due to filesystem corruption), nilfs_rmdir() calls
drop_nlink() via nilfs_do_unlink() and then calls drop_nlink() again
on the directory inode.  This second call causes an underflow of
i_nlink, triggering a kernel WARNING in drop_nlink().

Fix this issue by using clear_nlink() instead of drop_nlink() to
finalize the link count reset for the target directory in nilfs_rmdir().
Additionally, log a warning message when i_nlink is not 2 before
removing an empty directory to notify about the link count inconsistency.

Reported-by: syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c388db0347b7fc88fa7a
Fixes: d25006523d0b ("nilfs2: pathname operations")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Hi Viacheslav,

Please apply this for the next cycle.

This fixes a link count underflow during rmdir on a directory with a
corrupted link count (an issue recently reported by syzbot).

Thanks,
Ryusuke Konishi

 fs/nilfs2/namei.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index e037e0c6e31a..d326bb1acb11 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -341,10 +341,16 @@ static int nilfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	err = -ENOTEMPTY;
 	if (nilfs_empty_dir(inode)) {
+		if (unlikely(inode->i_nlink != 2))
+			nilfs_warn(dir->i_sb,
+				"inconsistent empty directory link count %u (ino=%llu)",
+				inode->i_nlink,
+				(unsigned long long)inode->i_ino);
+
 		err = nilfs_do_unlink(dir, dentry);
 		if (!err) {
 			inode->i_size = 0;
-			drop_nlink(inode);
+			clear_nlink(inode);
 			nilfs_mark_inode_dirty(inode);
 			drop_nlink(dir);
 			nilfs_mark_inode_dirty(dir);
-- 
2.53.0

