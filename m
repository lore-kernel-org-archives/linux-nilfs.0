Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FFC3D6D;
	Sun, 20 Oct 2024 04:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729399457; cv=none; b=kytL9ahlqcywq+g2s11q4szYiBaNd6skpfe+Uk9kjugZ+nSXuaJaY5m0Erf+PEiAzQo4BjfGd5A7QHa1m9WvMitUz4QhFTOLOsdKQa82uEm2x9h/0PFpA9xm+aUw97LpdVKcsMeFuVSfR1t2jl0KP88dGZfhMKpL6bEua7+tXWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729399457; c=relaxed/simple;
	bh=4QyW6R9lut9Re2pIQveoUZCbz2Gy/4n4UbV5rSWYifw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F45GApXsRz9oSrEdrojd2oVoLqCirzY8SmeNAtMGWLmUJtDCG+MuubjGEplpv3iFV97ZKoe6pr4wvh6N1dAEvBiD+VgTVbwDdAj9WfxNNcOA6S3Skoo2u0XcKWALqx0ekx6afop0+9537KZXNUEi1IACpO4hjAHIqOwhRgyafX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PM4n/mDz; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PM4n/mDz"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-20c767a9c50so31898975ad.1;
        Sat, 19 Oct 2024 21:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729399455; x=1730004255; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dDs6LtKOyP/Pre2ItPTAhwUX3UQfGRseg7n3uXJjZVo=;
        b=PM4n/mDzgBnrXaInepvFcloEFKv7dnoK8wO213J/Dst4VnN16d4xfF4QdVN+f1xh4G
         jW2abzqxUpeTq5DXGbyV44Lzn69eURbaVq3R3fNnnB1AkbRbAdcG5mfAyUQRAHbdF0sy
         LzBDVPKbfdMxTILDfWk6q6ft1rwOXLVM00OPYnj4ejK7R4dWY6LNtDKzVv9X8Mz+VEGo
         6vt9MvScS8rt6ok/H8qkY68fmEBBiccNY9UcE1RQ8/160jREy7OnwHfWetEPpjlkxdEz
         6AUAK6iqe4NkK/sjCyFkbSYJopw02B8qaKTpb32Sj++Df19EQkPxisOjwYgh0NjXhcyV
         rs7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729399455; x=1730004255;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dDs6LtKOyP/Pre2ItPTAhwUX3UQfGRseg7n3uXJjZVo=;
        b=B36DjIdf2mnFqIRh6XGFZNppeul+qkEn/7wei3B7hF70U/OSJ7mhYUq6l96HeNq5Jb
         F5Ni+o//GvPVIT+49r76TNVOp3ObmTCUNSTl1kqq0dCC5YVyj/kARdT2XJWo5bxaEvsi
         Qm5qRjojlr5ZCpShhKND+Z6FXKGoqG+O1GJK6NpGB1noERsa/7rE6REWN5982Qv/Ju4f
         8Jig4Jr2hBbGpHjkBkrRmfJutFh4Fh2IBuv2nDtESbT4YjnuRX47eaD1RRWMqvxklnDy
         oczm+KZrnK8yINQSBrPQMCo09xIzURC9kBGr+L1Y6ZlOaj7q0COdqsJrURdpk5mOHgJr
         nGgA==
X-Forwarded-Encrypted: i=1; AJvYcCWMPEAAJ0vUDXch5WxZdjBIjVSG0rWj41av8pWRyfVu7PsswETENN/lwdzGuuUXGjtGU/631isLval9JlM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzaIY+3NEPxMt6GkbkXLdN5+taMN1kTScapAIF97tAlCPVQSgRQ
	YvKBUMK6f88XVnUN+Bb5JtCOVtqbpxN7s1xJGr8qaHtEJY8bjD3eQ7sWBA==
X-Google-Smtp-Source: AGHT+IHwaIYQpkDRxUDukmk8lRB8IbagrZSbwADY4jchzpRTasfpkg+tUTGt1zpi4AGuUCefzx6iCw==
X-Received: by 2002:a17:903:32d1:b0:20b:8c13:5307 with SMTP id d9443c01a7336-20e5a8c3befmr84742405ad.33.1729399455105;
        Sat, 19 Oct 2024 21:44:15 -0700 (PDT)
Received: from carrot.. (i118-19-49-33.s41.a014.ap.plala.or.jp. [118.19.49.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7ef0bd97sm4649505ad.92.2024.10.19.21.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 21:44:14 -0700 (PDT)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot <syzbot+9ef37ac20608f4836256@syzkaller.appspotmail.co>,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] nilfs2: fix potential deadlock with newly created symlinks
Date: Sun, 20 Oct 2024 13:36:30 +0900
Message-ID: <20241020044418.4253-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <67134033.050a0220.1e4b4d.001f.GAE@google.com>
References: <67134033.050a0220.1e4b4d.001f.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot reported that page_symlink(), called by nilfs_symlink(),
triggers memory reclamation involving the filesystem layer, which can
result in circular lock dependencies among the reader/writer semaphore
nilfs->ns_segctor_sem, s_writers percpu_rwsem (intwrite) and the
fs_reclaim pseudo lock.

This is because after commit 21fc61c73c39 ("don't put symlink bodies in
pagecache into highmem"), the gfp flags of the page cache for symbolic
links are overwritten to GFP_KERNEL via inode_nohighmem().

This is not a problem for symlinks read from the backing device,
because the __GFP_FS flag is dropped after inode_nohighmem() is called.
However, when a new symlink is created with nilfs_symlink(), the gfp
flags remain overwritten to GFP_KERNEL.  Then, memory allocation called
from page_symlink() etc. triggers memory reclamation including the FS
layer, which may call nilfs_evict_inode() or nilfs_dirty_inode().  And
these can cause a deadlock if they are called while
nilfs->ns_segctor_sem is held:

Fix this issue by dropping the __GFP_FS flag from the page cache GFP
flags of newly created symlinks in the same way that nilfs_new_inode()
and __nilfs_read_inode() do, as a workaround until we adopt nofs
allocation scope consistently or improve the locking constraints.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+9ef37ac20608f4836256@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9ef37ac20608f4836256
Fixes: 21fc61c73c39 ("don't put symlink bodies in pagecache into highmem")
Tested-by: syzbot+9ef37ac20608f4836256@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
---
Andrew, please apply this patch as a bug fix.

This fixes a potential deadlock issue recently reported by syzbot.

Thanks,
Ryusuke Konishi

 fs/nilfs2/namei.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 4905063790c5..9b108052d9f7 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -157,6 +157,9 @@ static int nilfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	/* slow symlink */
 	inode->i_op = &nilfs_symlink_inode_operations;
 	inode_nohighmem(inode);
+	mapping_set_gfp_mask(inode->i_mapping,
+			     mapping_gfp_constraint(inode->i_mapping,
+						    ~__GFP_FS));
 	inode->i_mapping->a_ops = &nilfs_aops;
 	err = page_symlink(inode, symname, l);
 	if (err)
-- 
2.43.0

