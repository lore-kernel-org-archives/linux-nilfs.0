Received: from out203-205-221-190.mail.qq.com (out203-205-221-190.mail.qq.com [203.205.221.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C449BA4B;
	Sun,  8 Dec 2024 03:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733628631; cv=none; b=IPzOPUpNUN1HausvqiFAOtadQ9KCTbpSUt6V3mbzSHe2Z8io6yfdaJTNj5mTyeC8cT5iJs1QRms+OogTwcUnMnHCO1PWzzARLiU77XBKuBqrSAITYXTgyrZvd0RHGOYOCkZ6Jhu4oUQQ9jzOKQvi2cQ0rs181nq8m35QKSKJ1eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733628631; c=relaxed/simple;
	bh=BG57EQmQThxd+ozN5Q3bUFeu+y3rNtF+xMAEuOgrpDU=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=SjGJKd35eBfJekUVtkZ+xcaDVbCqMcQhyttuQV9mgtv+a06NbQIoRf+fsbBgTZydtT5QhLZ1C7v7YNAP74YdtX+y0HSWzDYtwYkhlmFSNEZ90QIqw1r3u+XNAKnqoFjX+5TE11LcSONhm3mOeo55cN5L20NHI2s+5Qv3UvDsSPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=rvinjgZM; arc=none smtp.client-ip=203.205.221.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="rvinjgZM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1733628623; bh=ucp257+OUZPko0+d8LLFYd48yVVz9Ih0yzGEGWfpmcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rvinjgZMHuf0hZL4uz9eu/1ttHXYRDSjhDwjSQcaWa0o7JouOmZEC/TuBde97t7Hb
	 u+nt6lv8huQxNGWy3BrhTQlrhG79JEty6LbWzXqVx/CyirKl0SwSEmef6+OCguj088
	 i5loZIqLi5zhMKKEikdx5Xs2+Z03l3akPpfWRhsE=
Received: from pek-lxu-l1.wrs.com ([114.244.57.34])
	by newxmesmtplogicsvrszb16-1.qq.com (NewEsmtp) with SMTP
	id 60E12254; Sun, 08 Dec 2024 11:24:14 +0800
X-QQ-mid: xmsmtpt1733628254tbvwesve5
Message-ID: <tencent_B7D4EAEAED76CDAC79026EF02F4D6D5C950A@qq.com>
X-QQ-XMAILINFO: MANJig+gdatzOacpMEVq+EeZdgfeZOASGsbV3JnXN7FZbBkOhNlC/5+2Akyb1S
	 WAjhmDt0ll4fExjqdqFWli3/WUtmDhcbyfQ0x2DJL3vpt57CjKk8SKsugbtdo0xp/XSpTJ4pRDjd
	 ESx5MzHYCPiJSyQ3FTeNBSF95JZ82ndFiL7rhE7pnmm/epjPAEQRi/Sn7unruck4PwX4f1+ukNsY
	 9KFxiabQr8U3HM1UjdXx+yZUa6oNpLjamBTfzCKt5pVzSd+6yOO7Pr5egNOIPBXfHpruNlo9VwXJ
	 cJ9XbciqXw29o/qkFApwpaM9qJPW4yQlIe2pATO+kh7h2Ueq/2K/99HwhYXB/2V5bCT8qp/K8OgT
	 rbOs5ryLAKs7OrRrzOggDWq56j7sk2tx6wm9jIrAbvfc0UppAI13afHj11MnxraqgNUfWgeGPYft
	 3aWGDQSgdCdPOidxqBi+WwgVBftXnbvbJy/GoWM3nsjhGoHGs1gj9yKvoXoYJRZjSoWdbTdK+GyC
	 zhfCgZTfNOevLF951v2m1pZ/WQ9/AC0faEKw2E0lMvVRHZKIbuL4RyP9zZHq3AvJCXi67cs2R11j
	 LAgipeZrKIB0zVvVr6qc7UfaTiLPgQeBGgVoCR491t0acO7KTC0qqe4XRNgsLWw9vki29mM/01Dg
	 TdksqTqLdGtG4qmgcd5tuhtAXkLCTDu3xbFf/LHXMxtOMJwrYAfP8wqWj0kYQc6LYTJmd6vWt41A
	 ZEjkauDcCLVCRWBeKIIAp2lpNR+dM13OpmCUGhzvMBKN32025yGpjoXVWLDTGJzSJU4KN90yB1iK
	 kM9ujJMyR6jeSKO0qla6p1PXyWu61nlw1xktPt6DmazWQrakpIZS9/l8A4FiD5IH9Mo027beSMNc
	 mZNrEiNNoCbV8G72rov55I6O28m4hkryvG1NGFQXfRYAEWPWt3gOg=
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
From: Edward Adam Davis <eadavis@qq.com>
To: konishi.ryusuke@gmail.com
Cc: eadavis@qq.com,
	linux-kernel@vger.kernel.org,
	linux-nilfs@vger.kernel.org,
	syzbot+9260555647a5132edd48@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH V2] nilfs2: prevent use of deleted inode
Date: Sun,  8 Dec 2024 11:24:14 +0800
X-OQ-MSGID: <20241208032413.2213943-2-eadavis@qq.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <CAKFNMono7BGpLOOjF1TcUpj7GM=x-aATHUv+fCXTs6=WVhYMUw@mail.gmail.com>
References: <CAKFNMono7BGpLOOjF1TcUpj7GM=x-aATHUv+fCXTs6=WVhYMUw@mail.gmail.com>
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

Reported-and-tested-by: syzbot+9260555647a5132edd48@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9260555647a5132edd48
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
V1 -> V2: Adjust the patch as suggested by Ryusuke Konishi

 fs/nilfs2/inode.c | 8 +++++++-
 fs/nilfs2/namei.c | 6 ++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

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
index 9b108052d9f7..7037f47c454f 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -67,6 +67,12 @@ nilfs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 		inode = NULL;
 	} else {
 		inode = nilfs_iget(dir->i_sb, NILFS_I(dir)->i_root, ino);
+		if (inode == ERR_PTR(-ESTALE)) {
+			nilfs_error(dir->i_sb, __func__,
+					"deleted inode referenced: %lu",
+					(unsigned long) ino);
+			return ERR_PTR(-EIO);
+		}
 	}
 
 	return d_splice_alias(inode, dentry);
-- 
2.47.0

