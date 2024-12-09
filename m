Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560DB214A92;
	Mon,  9 Dec 2024 06:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733727484; cv=none; b=m0ETuAcYKlg4dpuxISXzZIuP1uwMcpGj2j9ZLFX2VNt1iN6AKoSKg9R/3sHzeALyZobWU6OWCkkPwLvfxVvJ4TvajN6Y8Us7Ply1R4JB1uF8T1Gpthx9bk4qCdz70uLopbRHf0iWnUhnGijfaqC3fr6ZlUTRBLCvJwNSNEwL3vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733727484; c=relaxed/simple;
	bh=8bfXcYRDDt7dtabz3UtPnwxZkXo2DLfdwnfsWVXfIxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTYklG709WdXW6EdHoWGILLjBW14qo5D82Q4urfm5mspYAgb8likg1kRMNU7jKW/7dyaXo8F0px+s8cs561xAJJ4M4wNdy/jeO9eWUFQI3VEeLdYih8G2GsXw1wWd8VBPAsOn0MbST1Y/dtPyISNt/er7IwnkRuleZf5Bt1c15A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nA5REt+k; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nA5REt+k"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-725f4623df7so217309b3a.2;
        Sun, 08 Dec 2024 22:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733727482; x=1734332282; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ukHcVGD5bZ7NrwgcKlKtj7kYTlysawc41Nl+yMhJCU=;
        b=nA5REt+kZLrfss7cdjQxuNShItfwtnoCeLEUd6IZ0Uh8l3ctek8EfLC7dx7VAfBl1C
         Ogih2md4yXCx6KsGTgfAMX+f3MBttWFMV4bJww88t5aHKCVNkC82xS5pNDJLzt4dCp/N
         AB6KEgarm3hgxqUnmu8qCqmtn5KWoEvGDCO7BNlYpY+Zqx+4FVKM6MVif4DwhA2W/1S8
         6JsL6rMilj9ILcCkZ4Yk56+ydqFWuCoP8kWudO+gqkq7pTpIcrEpcHTDwKDRS+R0Ve1D
         5e0FHjJPQxC5n2rhGWzMVw1knI606dej7ELMH0bLjD6tS0QmpDRdWXd2oJ8eIAY4hazX
         a8pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733727482; x=1734332282;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ukHcVGD5bZ7NrwgcKlKtj7kYTlysawc41Nl+yMhJCU=;
        b=ujA2vfrzDkDtWztnnDsWm42nek6Ew6xZTMkCWXgFhAa4vI5Jck60+wRC6ppOZwIjOh
         9Sh+Zoq+2W/qdfL3vRHQt/D7HSf7rerqtIpUAbUeQnc3iX0Ry2jSHv5YnI911bSM2s3t
         1ab54iHyYy0SVcc9CWxpxe5KfnThstiXznKZqou5LiHnIyVQIQK84noJXyUFpvJRfqBq
         +pozaKwCFQEov17LBL4R/h7eLjZvwEUlSGXC6bCR9IGbgeCrc+W/R3imYPtgJ95+4Xpq
         U3kqHaszn+pXrK1V+WSNBw/lgY/uZ86ZddnvDdjFtGklTrCA0dBd1Uz4lsxOcelHUyzl
         H8dQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDPxpeNXwsVaHI0duszwGPhhx1047Wo8EL/TYbvMpZUDrEZl1oEdOEWhTyDdRlYaCSkrkBxk+KJ28x1rA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1S+wIE6wKETfbux4UiV/SCaMJE5e20tKhVhaIPFHFot0uQQfe
	2RT5PnzfhlMgh7x+I0vBvQvJ46EkcV7K7BIlDWHHLZK3ZKrQad7hSrwxeQ==
X-Gm-Gg: ASbGnctpQazpBEfWkmaAjIfnslHFMkYzK1S16RQrsVNRIQiSefs/8mji+CfhHAXxEle
	VbBVYnlXPE/n4wMZjouau9aK0Ubjw97nqTw6gGjcfgWhYnByXbjhpFy0bPoUjFj6FYSCqdWPCzB
	7tVYHFsnGyo9VKrZDBqSOBIW5pbFulTZdoMaUGSU9ibYZZ5oAkURNyiUqyI+ltZ9iBHT2e64zj5
	d3p4hmPVoT915EdfEiNnYsQIhwwGCFXeXEcKeDIe+Gg2e7nfM4R8NEP/SbbsBAI6Iwbd0tlVArr
	M2UCd0TnEMQPaDb+YfF+2gdX
X-Google-Smtp-Source: AGHT+IF+oyxte+LR9ny2z9H7vppbStyo2tnOaJFs2EiS/iu61vevYty3+F7lpdz2V87hQoik4FcIew==
X-Received: by 2002:a05:6a20:6a21:b0:1db:ddba:8795 with SMTP id adf61e73a8af0-1e187123148mr19355255637.36.1733727482403;
        Sun, 08 Dec 2024 22:58:02 -0800 (PST)
Received: from carrot.. (i114-186-166-114.s41.a014.ap.plala.or.jp. [114.186.166.114])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fd48c5216fsm1719540a12.77.2024.12.08.22.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Dec 2024 22:58:01 -0800 (PST)
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
	syzbot <syzbot+9260555647a5132edd48@syzkaller.appspotmail.com>,
	syzkaller-bugs@googlegroups.com,
	LKML <linux-kernel@vger.kernel.org>,
	Edward Adam Davis <eadavis@qq.com>
Subject: [PATCH] nilfs2: prevent use of deleted inode
Date: Mon,  9 Dec 2024 15:56:52 +0900
Message-ID: <20241209065759.6781-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <673e20ae.050a0220.3c9d61.0163.GAE@google.com>
References: <673e20ae.050a0220.3c9d61.0163.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Edward Adam Davis <eadavis@qq.com>

syzbot reported a WARNING in nilfs_rmdir. [1]

Because the inode bitmap is corrupted, an inode with an inode number
that should exist as a ".nilfs" file was reassigned by nilfs_mkdir for
"file0", causing an inode duplication during execution.
And this causes an underflow of i_nlink in rmdir operations.

The inode is used twice by the same task to unmount and remove directories
".nilfs" and "file0", it trigger warning in nilfs_rmdir.

Avoid to this issue, check i_nlink in nilfs_iget(), if it is 0, it means
that this inode has been deleted, and iput is executed to reclaim it.

[1]
WARNING: CPU: 1 PID: 5824 at fs/inode.c:407 drop_nlink+0xc4/0x110 fs/inode.c:407
...
Call Trace:
 <TASK>
 nilfs_rmdir+0x1b0/0x250 fs/nilfs2/namei.c:342
 vfs_rmdir+0x3a3/0x510 fs/namei.c:4394
 do_rmdir+0x3b5/0x580 fs/namei.c:4453
 __do_sys_rmdir fs/namei.c:4472 [inline]
 __se_sys_rmdir fs/namei.c:4470 [inline]
 __x64_sys_rmdir+0x47/0x50 fs/namei.c:4470
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Reported-by: syzbot+9260555647a5132edd48@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9260555647a5132edd48
Tested-by: syzbot+9260555647a5132edd48@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Fixes: d25006523d0b ("nilfs2: pathname operations")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
Hi Andrew, please apply this as a bug fix.

This prevents the link count underflow that can occur when deleting
directories in an inconsistent file system, which was recently
reported by syzbot.

Thanks,
Ryusuke Konishi

 fs/nilfs2/inode.c | 8 +++++++-
 fs/nilfs2/namei.c | 5 +++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index cf9ba481ae37..b7d4105f37bf 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -544,8 +544,14 @@ struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root *root,
 	inode = nilfs_iget_locked(sb, root, ino);
 	if (unlikely(!inode))
 		return ERR_PTR(-ENOMEM);
-	if (!(inode->i_state & I_NEW))
+
+	if (!(inode->i_state & I_NEW)) {
+		if (!inode->i_nlink) {
+			iput(inode);
+			return ERR_PTR(-ESTALE);
+		}
 		return inode;
+	}
 
 	err = __nilfs_read_inode(sb, root, ino, inode);
 	if (unlikely(err)) {
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 9b108052d9f7..1d836a5540f3 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -67,6 +67,11 @@ nilfs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 		inode = NULL;
 	} else {
 		inode = nilfs_iget(dir->i_sb, NILFS_I(dir)->i_root, ino);
+		if (inode == ERR_PTR(-ESTALE)) {
+			nilfs_error(dir->i_sb,
+					"deleted inode referenced: %lu", ino);
+			return ERR_PTR(-EIO);
+		}
 	}
 
 	return d_splice_alias(inode, dentry);
-- 
2.43.0

