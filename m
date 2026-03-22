Received: from mail-oi1-f205.google.com (mail-oi1-f205.google.com [209.85.167.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAEF36BCC2
	for <linux-nilfs@vger.kernel.org>; Sun, 22 Mar 2026 17:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774200933; cv=none; b=GJA+9dloVqqwwzOIwiOdT0aL1gmvrCSR2xUx3YE7ZJmGF73CSEOjAqwmAo5aNf1Ob0FI9MX4sjyBT0HLKM0GjmtmRA4ePbuS7N2V4FCaHt4RTzxa/zf0TqnIJ8Ziaton7t5xNWeiT1VRgQi6dacBnImimJouss0l/RymNW3AXis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774200933; c=relaxed/simple;
	bh=Awx9m9bkkZtWsUZXVJ0ozFgzC/h3PjP0T4jrBxGzt0o=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=DLvcwS3b4TmUk+REmdij1AszNW2SAp0FwE1/orOaP178P7YUE9DDq+V8Ug3VZalE1MDG8d8qwd9a5YKjHRSFh1fxRO91E3rc+ioET2sP15VZghYmek4AwgFQX7b0G1+nq/2imnzjQahbArXl7kEINHWbfcmBfaNOmYPH0kb7Vy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f205.google.com with SMTP id 5614622812f47-463a018f61bso10398879b6e.3
        for <linux-nilfs@vger.kernel.org>; Sun, 22 Mar 2026 10:35:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774200924; x=1774805724;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=byg3vd0JFaslz44DXobn1Giu8omrpZflMOl56OiyMUE=;
        b=Hbd1grERJk2YWwLzIVAspSf9Znu2ePKu+DJb7N6YlmmULWf3ZnmRVkXswX5vspZcQx
         pcfi5Jeg5JzElh5Yy9DnAC+z6+Fj6p2Cpqo7ICDb4Q+P3rnnnQ9g/nnurbl18mJrqiNs
         cTlqFa5cYR88nhXWxGfKJS6+GYf7Dd5iz3FaKfnSQ9jkshkClsDXzxHpdbZbeg/ppe9F
         iXNwQ0WaP3uJcxMcMeOy6oMadwMvlftwnX4eo3WOVsZfYwbWelemDCHDBqQ32iTX3DPk
         xF3IONMB4HORhsO1qe9tqQwCJPLxlXd8bCOLwASOq0tYWYw2F7kc/xAhbz0/eSi7XCSk
         OpBw==
X-Forwarded-Encrypted: i=1; AJvYcCV6iov35kdR2V35/qDB0XpF7ZDM/uq7SIT8ykKOFHMHwmnSYPF25rYtXGIw4CRYxY/6Xr3/idid3cc+lQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwGyRelrqxE3z8EGKA1pXh35nUkhHjSAi2QujB4BitB4PSt5pml
	Dp9FMB1wZ/xkUHq/FHHwaqX4rzdjEewcaA7+uM07VFI3/5o3SaIPJrBCQCOWxRE1A5ANv1gRUA2
	hh+al6vhyQAxi3C4ZBfi/UgDQVhINRNEw5jC6t+OvJA0JTg6nzrKv2B7vrN8=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1987:b0:67d:55ac:1b98 with SMTP id
 006d021491bc7-67d55ac20c9mr3654994eaf.45.1774200923751; Sun, 22 Mar 2026
 10:35:23 -0700 (PDT)
Date: Sun, 22 Mar 2026 10:35:23 -0700
In-Reply-To: <69bba3ff.050a0220.227207.0031.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69c0285b.050a0220.3bf4de.0087.GAE@google.com>
Subject: Re: [syzbot] [nilfs?] WARNING in nilfs_btree_mark
From: syzbot <syzbot+98a040252119df0506f8@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, kartikey406@gmail.com, 
	konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, sato.koji@lab.ntt.co.jp, slava@dubeyko.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    113ae7b4decc Merge tag 'hwmon-for-v7.0-rc5' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16f841d6580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6754c86e8d9e4c91
dashboard link: https://syzkaller.appspot.com/bug?extid=98a040252119df0506f8
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a52cba580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14108b52580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4905694a5f6d/disk-113ae7b4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/70f903690e79/vmlinux-113ae7b4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f3b857f0e5b8/bzImage-113ae7b4.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/89bbedcc6080/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+98a040252119df0506f8@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 4096
------------[ cut here ]------------
ret == -ENOENT
WARNING: fs/nilfs2/btree.c:2356 at nilfs_btree_mark+0x1c9/0x210 fs/nilfs2/btree.c:2356, CPU#1: syz.0.17/5978
Modules linked in:
CPU: 1 UID: 0 PID: 5978 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
RIP: 0010:nilfs_btree_mark+0x1c9/0x210 fs/nilfs2/btree.c:2356
Code: 48 8b 05 fa 0d 70 0f 48 3b 44 24 10 75 26 89 e8 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d e9 c9 1e 64 fd cc e8 b8 7e 19 fe 90 <0f> 0b 90 bd fe ff ff ff eb c3 e8 08 7f 02 08 44 89 f1 80 e1 07 80
RSP: 0018:ffffc900038075b0 EFLAGS: 00010293
RAX: ffffffff83ac2248 RBX: ffff888035117080 RCX: ffff888028170000
RDX: 0000000000000000 RSI: 00000000fffffffe RDI: 00000000fffffffe
RBP: 00000000fffffffe R08: 0000000000000341 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed1006a22ee3 R12: ffff88805726c5c0
R13: dffffc0000000000 R14: ffff88805726c588 R15: fffffffffffffff8
FS:  000055558815d500(0000) GS:ffff88812555d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2f663fff CR3: 00000000270a5000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 nilfs_bmap_mark+0xba/0x180 fs/nilfs2/bmap.c:402
 nilfs_ioctl_mark_blocks_dirty fs/nilfs2/ioctl.c:764 [inline]
 nilfs_ioctl_prepare_clean_segments+0x49a/0x800 fs/nilfs2/ioctl.c:799
 nilfs_clean_segments+0x18c/0xa50 fs/nilfs2/segment.c:2525
 nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:916 [inline]
 nilfs_ioctl+0x261f/0x2780 fs/nilfs2/ioctl.c:1346
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f97fcd9c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffdfc45fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f97fd015fa0 RCX: 00007f97fcd9c799
RDX: 0000200000000640 RSI: 0000000040786e88 RDI: 0000000000000004
RBP: 00007f97fce32c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f97fd015fac R14: 00007f97fd015fa0 R15: 00007f97fd015fa0
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
