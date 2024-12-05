Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A1B217F41;
	Thu,  5 Dec 2024 12:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733401599; cv=none; b=u8GgbYyIk1l8akDZNVvP1Xc2hRVQyVYYrMNoWP1jptIAp9YLBnDSIihiZ8tf2omnv0H71OcbysynQNCpgZH6eUzidFa1q/8Zopn9vrNAb80NX5r8B1olbsH+GtmsNIELmVwWkqekequVndfOPh5UQzm7eYAjWp3uzqlvO/u+DsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733401599; c=relaxed/simple;
	bh=rqYjDz2ndWToCkMOGlekbv3N/pUHqvPe5KnfdFYe5VM=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=brweD1AB3youW3El+681FJdKT304CGoyJTPGqhk64AN53wDqEx347D596nB/nol1DpZ1ycRF5Q3jCgYHPlqqrqpiDc2UCVAYrvs4HW8sBIp/qRMfXaCuX3QxwVotrug2RrkuV8/VJavacrDaGKLck+1ONmbUw1fFwUFdj3Lg4ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=mZvngHyG; arc=none smtp.client-ip=43.163.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="mZvngHyG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1733401589; bh=VmJ9Y01rlwA2K6RfLHocoulXFC2JDlQaFE30T46B3fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZvngHyGk521xHb7KIz7Il5QY0bbxrRxr+PGjnGjNrPEdunzZmQ/G0d3+INMbFxSp
	 Wttb9IGCdAsblhDFCZsvICKw0x+ycRBLrpBBLZeLKTFJriJIZb7+28Wd158k2GMS0n
	 vPWEwNxPKm2r839jglqwtK7RSs5XtidMuIRJYtqY=
Received: from pek-lxu-l1.wrs.com ([114.244.57.34])
	by newxmesmtplogicsvrsza36-0.qq.com (NewEsmtp) with SMTP
	id 69B2CAF4; Thu, 05 Dec 2024 20:26:27 +0800
X-QQ-mid: xmsmtpt1733401587tme26c0gb
Message-ID: <tencent_F4C3B4644C977CF77226C95362E373897105@qq.com>
X-QQ-XMAILINFO: NyTsQ4JOu2J23W8T+v+r228Gxj0k3JeiQ3Y9Htxzq/rSHkgbuRGC3tbz7zsYWo
	 th9W1sXLexZEwCMABylqN23mMhRvNbfwpyFZPlsspTiAu23RtMMnH/l8aJJ2pWKNMIjbxs2/K9yQ
	 4H3mQUuW95EVn+7TawwLZnJFxgsnw5rpdVtCK10G2829fbC2RT86xAQJJxxfH4vpxS0gAbzkXVyr
	 iq2zzzdm4t32KGZyOFlnTgj15Zlhfb6uLaQFQZn/aBQNqMW98V9j13W0NHYll73rAIO2OYA1bJ4e
	 sX7JpoU3E9qgzA+zqywjFxzcCK9RBA7jFyEh8BlZxl+nYlN5Qug/7LhWLXSnMwZXmt8hZbmPAsMH
	 oktsOZaSSH3Y/TBj3bHs1Lrltyd9tpX+5yXb0YPFBFlIf4Obu/JIgM/LoXLhuvVRr3FVdHE7ax8M
	 0P2yrB8oMQmytgBL3yt4aOy2I3Zxem++XsPQWQd731Y/BDECZXppLd3NcjNM+DF1qsbsF40qxHAh
	 FDMN+Vs6Rb0sGDHsA2WLG5rDZivL9omVrjPmpmPlytlBeSMP1Y22W5yxQcdxg6Wr+e6t3r4LkV0n
	 FL2sBJmCraZcubg0cosvjt5LpTty03NuZwadzl2B6t4todNZcSoOtohwt2S31K67MxQ513G1+tuk
	 RFM0WeBtDhM4AY8S/AF7RGE2M4TTAlhpLeJH+4uMUGMeiO41YZuqnbj6CrhM80eoLjysng1xJKgk
	 hcNbjVuIaKHBog94zca/4TXx8hOiDOAF8iEdW6wMAUj3VXrMSgHaepAqniFGsmeQCM+WNI9Ch5Be
	 sewsrYqf2XmKJE0uTbonY3z8Z2U5lz6jI8AZ/LyRTKAuxh2rQ52R1Bg0TP5nVPFyFO8LubM2IVny
	 t0AYnE8saqSFHHQhvO8t5b6Q23F9wBmQ==
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+9260555647a5132edd48@syzkaller.appspotmail.com
Cc: konishi.ryusuke@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-nilfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] nilfs2: drop the inode which has been removed
Date: Thu,  5 Dec 2024 20:26:28 +0800
X-OQ-MSGID: <20241205122627.1066297-2-eadavis@qq.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <673e20ae.050a0220.3c9d61.0163.GAE@google.com>
References: <673e20ae.050a0220.3c9d61.0163.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot reported a WARNING in nilfs_rmdir. [1]

The inode is used twice by the same task to unmount and remove directories
".nilfs" and "file0", it trigger warning in nilfs_rmdir.

Avoid to this issue, check i_size and i_nlink in nilfs_iget(), if they are
both 0, it means that this inode has been removed, and iput is executed to
reclaim it.

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
 fs/nilfs2/inode.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index cf9ba481ae37..254a5e46f8ea 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -544,8 +544,15 @@ struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root *root,
 	inode = nilfs_iget_locked(sb, root, ino);
 	if (unlikely(!inode))
 		return ERR_PTR(-ENOMEM);
-	if (!(inode->i_state & I_NEW))
+
+	if (!(inode->i_state & I_NEW)) {
+		if (!inode->i_size && !inode->i_nlink) {
+			make_bad_inode(inode);
+			iput(inode);
+			return ERR_PTR(-EIO);
+		}
 		return inode;
+	}
 
 	err = __nilfs_read_inode(sb, root, ino, inode);
 	if (unlikely(err)) {
-- 
2.47.0

