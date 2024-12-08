Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30EB1DA23;
	Sun,  8 Dec 2024 06:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733638027; cv=none; b=iOz0ORgdA0MyDGTTknu/qKt7PmxJE9S6pJh4VJR8XV6ETrJMddVxkl5gNDLBjeoF+72vFOQy5cSqpO+MQPzsBzL1yfAPH6jeyCpxRfCceenoRoMhosOr2svZdY5Bczyl0u3+aLcdnexhoEuy/kj36CRmiZaSFHhGYnxn7jiV7WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733638027; c=relaxed/simple;
	bh=niKzD15HR7l+5SsvG7XlStB3vvws4sohmR+b98rSAH0=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=R6D26kNLeVIRD53GBEl57JHn1vH6/8t+IvkCSXVfm/hqhBLvhwlemCD9lomtMW5lJyfphp4tPVG+urNedaFMr39mhtuDUVNdaoEleQklauCgVmR6LaA+NS0jQN4U4bkyUEld1ISRflLSrL+bpqkGbmRmzRPRw3SyErHP/XMdWnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=F0ylrBqT; arc=none smtp.client-ip=162.62.57.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="F0ylrBqT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1733638012; bh=3Zx3ARU30xGZi0ga9aJ9b5p8Xzm+HMbqCcag9EvD1b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0ylrBqTjbR8+fRbkoSs/vVYedcUDliprzgl3+k35n4KtWidVTal/VVRYggRXN5Mq
	 9VNy1fc6fWh4Nta5+e7Dl+5xAZie34V8xBDVKIgLUDJYcN9CbrRhsLxelTdtXHHXtb
	 QsvQCyJrJyuCmGPewzQJi3xruiCCBbZvjFwzySFU=
Received: from pek-lxu-l1.wrs.com ([114.244.57.34])
	by newxmesmtplogicsvrsza29-0.qq.com (NewEsmtp) with SMTP
	id 2E1B66F; Sun, 08 Dec 2024 14:00:46 +0800
X-QQ-mid: xmsmtpt1733637646tijkqhr7m
Message-ID: <tencent_95592538BA04BB7933F79E351B014BE51B08@qq.com>
X-QQ-XMAILINFO: MRQq5cyInCgJE5nfkwaicdrqkhiY5SIaOPN5lrOnyO7GzsofTL52fe0W2NVmpC
	 wTwNMUUqHwmO0H48pPQKdM8Sj9KsUQliB8NZsyL0nPxoBk4pNaeLxKQ+eNlw5+t6TTZvQ6BMW4eL
	 xOsL4NDLaELf1plsJbwLG4A8+Mb8YbfycqFNCT8GmiBseoL3mlE7Sw05heIZCeOWbopweK+1ljnS
	 7QliVuZlq1y2kFW54B9hfOo2nO+qJAkHMN8Gbsxj2ReIJBixnew/JfhXLKFqQXY4tKhoRoUCbM+2
	 E44px4TpHeFcTP9RZrPZTwNUCZqN6i94BO6dWALdcy0AI3ypgNwAc6aafGxuRcsh8OkTzNtga6/j
	 rkoYDOvHn1tk4j26KuMFou6RD7wvoYSOWjLaR9uGWqqwuJYGqNfZfNiaLvcrR8HSlDAcISlxA38s
	 kcgSHgfcfxDxmaF+74s1JP9YZ8aNs+qda0ayIi3yOPcs0XCQuJBgBjsLSzYKdpWh+tkg9u3yFhFb
	 AypH99rDmud7a2w6f3U2m5b/Vxh0/dLsG3h80wQ+o8NCJ5kJSgLMFzJMClaCy9AvwNdETaaEKFe8
	 Nw1OkzauLE7XNHdWHoZ8a6MejAtn6ZQDb6g8dlsSb3jU9IKojNq9tE42wACNkXJZf1F3Aevgea6R
	 O8nSIeCjo5NEUdWJvNBbgKSNE0AjuXttxdCquT3SYzpONoEHdl+oVC02jNAx7V+//VpJ59DWfm38
	 cZ9y7WpIl/pygjHSJxtLfEQnuATLyCHcn9ejr1eu1yzjy2W4yx6BRKI25De11HHfGhrh0aRm+pN+
	 qyEPbtnqfAXaew7bvshVGteDO4zesIweiY7SMcU4ekR/CM2eqvf1xn/8JWFH4zU1jFsD1ab8GAIy
	 uinKyYCfyxVMmdTEd2mUbwrjbqJgypFy+5wqS30hOb52ZE4qMuTObrXRFLnmly9g==
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
From: Edward Adam Davis <eadavis@qq.com>
To: konishi.ryusuke@gmail.com
Cc: eadavis@qq.com,
	linux-kernel@vger.kernel.org,
	linux-nilfs@vger.kernel.org,
	syzbot+9260555647a5132edd48@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH V3] nilfs2: prevent use of deleted inode
Date: Sun,  8 Dec 2024 14:00:46 +0800
X-OQ-MSGID: <20241208060045.2354163-2-eadavis@qq.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <CAKFNMo=ck+c2NJHVOFszzT02ksF1a0KG9vA5zU+Woa7noLeFrA@mail.gmail.com>
References: <CAKFNMo=ck+c2NJHVOFszzT02ksF1a0KG9vA5zU+Woa7noLeFrA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
Modules linked in:
CPU: 1 UID: 0 PID: 5824 Comm: syz-executor223 Not tainted 6.12.0-syzkaller-12113-gbcc8eda6d349 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:drop_nlink+0xc4/0x110 fs/inode.c:407
Code: bb 70 07 00 00 be 08 00 00 00 e8 57 0b e6 ff f0 48 ff 83 70 07 00 00 5b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc e8 9d 4c 7e ff 90 <0f> 0b 90 eb 83 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 5c ff ff ff
RSP: 0018:ffffc900037f7c70 EFLAGS: 00010293
RAX: ffffffff822124a3 RBX: 1ffff1100e7ae034 RCX: ffff88807cf53c00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff82212423 R09: 1ffff1100f8ba8ee
R10: dffffc0000000000 R11: ffffed100f8ba8ef R12: ffff888073d701a0
R13: 1ffff1100e79f5c4 R14: ffff888073d70158 R15: dffffc0000000000
FS:  0000555558d1e480(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555558d37878 CR3: 000000007d920000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
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
---
V1 -> V2: Adjust the patch as suggested by Ryusuke Konishi
V2 -> V3: Modify the input parameters of nilfs_error and split Reported-and-tested_by

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
2.47.0

