Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF241F9413
	for <linux-nilfs@vger.kernel.org>; Tue, 15 Oct 2024 17:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729013370; cv=none; b=Nbs+4o+UOwyO/mhLpvgHD02fNYled8xXc1lFW6C2ejaXJqxfp/IxyR7KPtmlY38stNaX8keyEs4JH73BLaqcuaeCO3mGj+vd1k2o/IQlmYgW3XxDgXx5CJ9hBop1xtFS2O0at3ASeuzRi7XvTP4FF+jk4MrwqMyCGRZ69lLG5oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729013370; c=relaxed/simple;
	bh=q33cYYopDekDCRcZAwvDSMZNFJEflYa9wSS0/ibI0q0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=uD2Px9PJ9Lnv3TkFTJSE9YkzZF45wduH+RT8z5OKk7P+yCL3mFFXdxlyAlb8spZBNvD8IyIHAKe3mKYSz9va0QsVJi3gX8eI0QcUeYu//Z+1UcLHPoejRNfMubF5tTr4GIjZGHGQR1BLOpqsk6RDInkBZbjumCUM71Wjx6JIdk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a3b4395dedso46312465ab.1
        for <linux-nilfs@vger.kernel.org>; Tue, 15 Oct 2024 10:29:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729013368; x=1729618168;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=skFPW33VGv1s1JqEpC2/mpqw+JweLIgTbRQQYpesroQ=;
        b=WML94+zbypfRStrKPACaoGNhvCA/B8elN4r88aMr+L2XDsa0o7RY0XvPUrflbcmPRN
         p2X20UtmsQbGsdjttqcPfISLjVCs6xJAFth7cWwqKnPi4rv3HU7v+aQMbAj0nWvBHCJk
         7/emV3u7at8zaz4v6mHiHvaov1Ri7aSkes7K5RnMHLL14OFN860eCqwtQKIZOHOpxm5y
         GU33vVilyjU7qfsu3/0DO2caRNqIinA4UwErbiQgLzWVFEOdEqSbGdEW9NT5+53C5plL
         jxH95jfiqi43l0Y5JJ4cwU4aTDdV6GHSbquoMx1ceeBS+NNyr4QDBdYwB/EG8+7BG75g
         03Ow==
X-Forwarded-Encrypted: i=1; AJvYcCVqdE/DcBOw3pjVQb1KEkN29ASUlQT5xtlN1Wu9GPDB+5SYziTs4R3qAdXcxH8mGJwIL0I3DuyJ3n63QQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzpoaTUh3ao0Tm+cXtyickeQgGoknt+jzWG6BU7YcPnrZUXB26W
	yJ5DgX0Z7wvvoFdpaeqWuEr5Yb/WxOxEu+PxcRHMGQXFMkEF57zTDfs1dMTCf8jo85v5AXbeXQn
	AW45ut1RLWQfgejav9NK2VBgahBjjD6tr5R+OxwtEpy+rwjbShArDFhI=
X-Google-Smtp-Source: AGHT+IG9+q+H5kI8MCuHdsxZRYetfgqrzi3K+JVBRYt3vXfubjkncW3Sh14dcWRWG1bFGTWUs6wZmRQ/VXnxfIR0BRMrAlSC7Vsa
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:194d:b0:3a2:4cc4:cfd with SMTP id
 e9e14a558f8ab-3a3b5faab6amr148219125ab.14.1729013368184; Tue, 15 Oct 2024
 10:29:28 -0700 (PDT)
Date: Tue, 15 Oct 2024 10:29:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <670ea678.050a0220.d5849.000b.GAE@google.com>
Subject: [syzbot] [nilfs?] WARNING in nilfs_btree_propagate (2)
From: syzbot <syzbot+b2b14916b77acf8626d7@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1d227fcc7222 Merge tag 'net-6.12-rc3' of git://git.kernel...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1342205f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7a3fccdd0bb995
dashboard link: https://syzkaller.appspot.com/bug?extid=b2b14916b77acf8626d7
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11692840580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12ea6f07980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f64f03b05002/disk-1d227fcc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3ab8ba99a1b6/vmlinux-1d227fcc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/97581c221708/bzImage-1d227fcc.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/0cfc62de73c5/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b2b14916b77acf8626d7@syzkaller.appspotmail.com

WARNING: CPU: 0 PID: 5245 at fs/nilfs2/btree.c:2089 nilfs_btree_propagate+0xc79/0xdf0 fs/nilfs2/btree.c:2089
Modules linked in:
CPU: 0 UID: 0 PID: 5245 Comm: segctord Not tainted 6.12.0-rc2-syzkaller-00205-g1d227fcc7222 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:nilfs_btree_propagate+0xc79/0xdf0 fs/nilfs2/btree.c:2089
Code: 48 8b 44 24 08 49 8d 74 05 58 e8 12 67 ff ff 48 8b 6c 24 10 43 80 3c 27 00 0f 85 16 fe ff ff e9 19 fe ff ff e8 78 1d 20 fe 90 <0f> 0b 90 e9 ea f3 ff ff e8 6a 1d 20 fe 48 8b 1c 24 48 81 c3 d0 00
RSP: 0018:ffffc90003d873a0 EFLAGS: 00010293
RAX: ffffffff8374c988 RBX: 0000000000000000 RCX: ffff888011dada00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffffff8c47aec8 R08: ffffffff8374bd6c R09: 1ffff1100ec15f96
R10: dffffc0000000000 R11: ffffed100ec15f97 R12: dffffc0000000000
R13: 1ffff1100ec15f9f R14: 1ffff1100ec15f96 R15: ffff8880760afcb0
FS:  0000000000000000(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8737b0dd58 CR3: 0000000079068000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 nilfs_bmap_propagate+0x75/0x120 fs/nilfs2/bmap.c:345
 nilfs_collect_file_data+0x4d/0xd0 fs/nilfs2/segment.c:587
 nilfs_segctor_apply_buffers+0x184/0x340 fs/nilfs2/segment.c:1006
 nilfs_segctor_scan_file+0x28c/0xa50 fs/nilfs2/segment.c:1045
 nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1216 [inline]
 nilfs_segctor_collect fs/nilfs2/segment.c:1540 [inline]
 nilfs_segctor_do_construct+0x1c28/0x6b90 fs/nilfs2/segment.c:2115
 nilfs_segctor_construct+0x181/0x6b0 fs/nilfs2/segment.c:2479
 nilfs_segctor_thread_construct fs/nilfs2/segment.c:2587 [inline]
 nilfs_segctor_thread+0x69e/0xe80 fs/nilfs2/segment.c:2701
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
