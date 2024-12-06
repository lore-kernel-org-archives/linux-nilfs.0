Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4EE1FCD11;
	Fri,  6 Dec 2024 13:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733491528; cv=none; b=e3UOb4ywvvcirxh3T748h3i2qYw5HbmxW4aV2VVY8x4QAWtp6i0/3/rFq2Va2c7wzC0Us6vxo5jxOyG2wiWl/4eo1MIDsppU9xjbxdVdyxelegwzI6dzvVPQpXQDvP7gETg9DPIrjsWIwp2/C63Rf69RelH+mPZv6blmQwQ9hik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733491528; c=relaxed/simple;
	bh=CcCZQR/RBk4BYiNbQI6RvTXGbsgq+rlKj/Q98d23NtU=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=J54BUEd0zGZbJP9CJHMcSDlPhJ1drSkPA4v/5YuvDXwRRCyD3KxK2e/aqDESNgHfZQrWLjgNlQYAvlmqd6wAjzYW2oEYbheOsXoLQ1Bl+SPjUROhtitJJFYPNzy2lL38VZQJ0BQ91n3082yzahlC7oC5jUC5UEgzaACdTcNsexQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=c/bpshv+; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="c/bpshv+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1733491213; bh=VEYX/ZGgNNSVckntCgsMeNJF8XttrKfpsGFIHdlHn78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/bpshv+lrC3UlZSQXg11pQ8GJPtBNEYTVmvSsvYhdLZt1NhT4N28Nsnq+eaa7sWl
	 dmI4kGxqGpgHqdhmHLYCRZyi1lvlzKsidbm2N1JchD7dBw8DOGbQ/7sgkm5Pku94bY
	 A2ZVsv/Gyga9/jo1C2+JKWXrSkH9pHra1c8Hgp5E=
Received: from pek-lxu-l1.wrs.com ([114.244.57.34])
	by newxmesmtplogicsvrsza36-0.qq.com (NewEsmtp) with SMTP
	id 378B4AC5; Fri, 06 Dec 2024 21:13:56 +0800
X-QQ-mid: xmsmtpt1733490836t83hwzxro
Message-ID: <tencent_C97469775766D83D6D366E966236D24AB409@qq.com>
X-QQ-XMAILINFO: MgH8QHUHzFh7Tm0jOYdzHBLdFwqQ+A4cKd+h7bUmNao1cASazwvtrOS88QYFfh
	 K3dszxWqtgknY2CKdsmOJmx9/h6NnuUH0LaznsUePdVkeprsOnKAWU1+A+w2u2NMtt9ypkSSUW8B
	 vQr5I/XYtxj0AFrPPaqHdlxCFYHKtZ+S7sWwbTpV0ETtqpTYZ1MsrTxC8SLD7CZ3SLUVGTwYm/4c
	 Ef1zCDWGGVdF/RmRyZlB0FyGlgmJbIN5BXH2CUdPiHDCdQRNTS/f/s/sbSQIG7oLWOQ48xQEn4eU
	 Y9G82WMxKHiFUhx2Z4FITbQiDGwQBCrBb/zU4eNNrlaOEDj0z265FzLjVoUpq6CzY0Lpc3ejemRO
	 elArCOf8XhZI9sy4twq1mxFZMbA/0s+rZtHBrmjAV+bAZFCTsAo+RZWU3gXOVlMf57ummoPE130D
	 jKtWsv1tPRuALxRwIlufJ+k7TFDbnhqG9vX8WZAOlTMxZJJFdpyhLGTVZpnb91COb8kPmVrtExgT
	 MS3Zormtir9EIaVDQYjV2eXE5qt41To9VpYxgvrRuAaH+A43pet3aVbpJBuUhwGXXBPFMnsPEGHd
	 6Pk7/Sqycwlb8vWZulWaY5+/eK09gzLZqUJsbYIdQvOsyXx6JAr/6Jx4/ijDd/+pgsak5hCdO9xu
	 hx5ARF1/46yW2jQBg6KMbyc8jIWbItIAO27/NBCfVvr3RbiVxSMrKA+1i7xW2/eF5SwEuoYX5zc8
	 ywpZJxNd3M1Rh6G3EpKCZnEBJthk3ScEW2w/bK8sScwvuIbvnpqG5M4W/qqq+gYeqUgXfO7wox9R
	 pu+wwW33R1UCvzFvkHvhPeDT9fbgZDaBLA+yatMa7wdyUFY8QRV+WA+MHXiVe8Na3B79G5ghsfgM
	 nSzOBK7ZGUXuXtEBsoEoW7gJu3ZTLjdXIEfP52oGiUvL4zXbeatyKmJ2yPsuZpqax8sw5+JwIJS7
	 9wr/c3t8HQLVq9DTyNDw==
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
From: Edward Adam Davis <eadavis@qq.com>
To: konishi.ryusuke@gmail.com
Cc: eadavis@qq.com,
	linux-kernel@vger.kernel.org,
	linux-nilfs@vger.kernel.org,
	syzbot+9260555647a5132edd48@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] nilfs2: drop the inode which has been removed
Date: Fri,  6 Dec 2024 21:13:57 +0800
X-OQ-MSGID: <20241206131356.1321480-2-eadavis@qq.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <CAKFNMomAScDK6OBUn=+46=VRZCQMvipWtetX8SMVuLkHpVGvdg@mail.gmail.com>
References: <CAKFNMomAScDK6OBUn=+46=VRZCQMvipWtetX8SMVuLkHpVGvdg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 6 Dec 2024 01:04:23 +0900, Ryusuke Konishi wrote:
> > syzbot reported a WARNING in nilfs_rmdir. [1]
> >
> > The inode is used twice by the same task to unmount and remove directories
> > ".nilfs" and "file0", it trigger warning in nilfs_rmdir.
> >
> > Avoid to this issue, check i_size and i_nlink in nilfs_iget(), if they are
> > both 0, it means that this inode has been removed, and iput is executed to
> > reclaim it.
> >
> > [1]
> > WARNING: CPU: 1 PID: 5824 at fs/inode.c:407 drop_nlink+0xc4/0x110 fs/inode.c:407
> > Modules linked in:
> > CPU: 1 UID: 0 PID: 5824 Comm: syz-executor223 Not tainted 6.12.0-syzkaller-12113-gbcc8eda6d349 #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
> > RIP: 0010:drop_nlink+0xc4/0x110 fs/inode.c:407
> > Code: bb 70 07 00 00 be 08 00 00 00 e8 57 0b e6 ff f0 48 ff 83 70 07 00 00 5b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc e8 9d 4c 7e ff 90 <0f> 0b 90 eb 83 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 5c ff ff ff
> > RSP: 0018:ffffc900037f7c70 EFLAGS: 00010293
> > RAX: ffffffff822124a3 RBX: 1ffff1100e7ae034 RCX: ffff88807cf53c00
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > RBP: 0000000000000000 R08: ffffffff82212423 R09: 1ffff1100f8ba8ee
> > R10: dffffc0000000000 R11: ffffed100f8ba8ef R12: ffff888073d701a0
> > R13: 1ffff1100e79f5c4 R14: ffff888073d70158 R15: dffffc0000000000
> > FS:  0000555558d1e480(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000555558d37878 CR3: 000000007d920000 CR4: 00000000003526f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <TASK>
> >  nilfs_rmdir+0x1b0/0x250 fs/nilfs2/namei.c:342
> >  vfs_rmdir+0x3a3/0x510 fs/namei.c:4394
> >  do_rmdir+0x3b5/0x580 fs/namei.c:4453
> >  __do_sys_rmdir fs/namei.c:4472 [inline]
> >  __se_sys_rmdir fs/namei.c:4470 [inline]
> >  __x64_sys_rmdir+0x47/0x50 fs/namei.c:4470
> >  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> >  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > Reported-and-tested-by: syzbot+9260555647a5132edd48@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=9260555647a5132edd48
> > Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> > ---
> >  fs/nilfs2/inode.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> > index cf9ba481ae37..254a5e46f8ea 100644
> > --- a/fs/nilfs2/inode.c
> > +++ b/fs/nilfs2/inode.c
> > @@ -544,8 +544,15 @@ struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root *root,
> >         inode = nilfs_iget_locked(sb, root, ino);
> >         if (unlikely(!inode))
> >                 return ERR_PTR(-ENOMEM);
> > -       if (!(inode->i_state & I_NEW))
> > +
> > +       if (!(inode->i_state & I_NEW)) {
> > +               if (!inode->i_size && !inode->i_nlink) {
> > +                       make_bad_inode(inode);
> > +                       iput(inode);
> > +                       return ERR_PTR(-EIO);
> > +               }
> >                 return inode;
> > +       }
> >
> >         err = __nilfs_read_inode(sb, root, ino, inode);
> >         if (unlikely(err)) {
> > --
> > 2.47.0
> 
> Thank you Edward.
> 
> This fix seems good except for the i_size check, but I think we need
> to look into what's going on a bit more.
> 
> I was unable to work for a while due to machine trouble, so I'd like
> to know if you have made any progress on your investigation.
> 
> First, is this caused by a corrupted filesystem image? Or is it that
> the directories or files with the same inode number were generated
> during the namespace operations (due to a timing issue or something),
> and could this problem occur even if the original filesystem image is
> normal?
According to the log when I reproduced the problem, I analyzed that the
problem occurred like this:

		CPU0					CPU1
		====					====
		nilfs_mkdir      // file0
		nilfs_new_inode  // ino is 11
		mount            // mount file0
							umount       // .nilfs, ino is 11
							nilfs_rmdir  // ino is 11, i_size = 0, i_nlink = 0
							umount       // file0, ino is 11
							nilfs_rmdir  // ino 11, i_size = 0, i_nlink = 0, trigger warning

> 
> When I mounted the mount_0 image as read-only, the filesystem looked
> normal without such inode duplication.
> 
> At least, nilfs_read_inode_common(), which reads inodes from block
> devices, is implemented to return an error with -ESTALE if i_nlink ==
> 0.  So it seems that nilfs_iget() picked up this inode with i_nlilnk
> == 0 because it hit an inode being deleted in the inode cache.  Why is
> that happening?
Are you talking about the following call trace?
If so, then because the value of inode->i_state is I_DIRTY (set in nilfs_mkdir)
it will not enter __nilfs_read_inode().

nilfs_iget()->
  __nilfs_read_inode()->
    nilfs_read_inode_common()
> 
> Also, why do you put the i_size check as an AND condition?
i_size will set to 0 in nilfs_rmdir(), so check it too.
> i_size is independent of i_nlink and the inode lifecycles.  If i_size
> is also broken, this check will not work properly.
> If something is not working and you have included it as a workaround,
> I would like to know about it.

BR,
Edward

