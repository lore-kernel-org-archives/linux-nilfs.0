Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C74126ACC
	for <linux-nilfs@vger.kernel.org>; Mon,  3 Feb 2025 18:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738608925; cv=none; b=I5ncV/aNuIvJSXsKkFe/0JGm26GXi702v6Cj5dqwxDwkQptvJOywANtQG0pMmbGANmpNXtuTaXtG2OftPT0ypz8C4lJniivtWEtOIdTRv15YeS9GQaNm3zN5REzC6e1shlXia0xeorqlcjkcPO1NhNu9Sogy1X5jOxrXQtPErrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738608925; c=relaxed/simple;
	bh=s87yMXE1FIAH0Xa6Wv5iXCM7uECS9Rj3i5pnXX+HKgs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=rpp2XG79aFA/8VZx3GWkO0p1zqGWJMc/EGhpZDsiSAkcDg7BmguUxpIffWANrChg99aYd4qPRZuyIJMdCbK3YZbINv/6UlcsHW6MevyV3m+OT6XIDY/RsjuBoCsZ70F0VzBSbRO/QYV06Hr/3AaRhLHF1nqA6DJiYSfYY9P97HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3a7e4bfae54so40282065ab.0
        for <linux-nilfs@vger.kernel.org>; Mon, 03 Feb 2025 10:55:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738608922; x=1739213722;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k8dxxwyMgVxu9UaFYI4n9tupnMZbSxwjPVr/sArAatY=;
        b=MjHSLRl1cNC3JiUgHgdQKDaxEDa2O0XCzby3KN/gCH3yFkvoiF0UyOiVJU8AztLWVz
         r9/nvNKcbTxyQ8MoFKC6kD5Wrf3OYkKLpr5YIL9Q/vxaXnBpbBdVYTfTG4EDKFXd+jtm
         2kvRitQNUtpmjcEaHkZCl/dk5ASEVmiBm9ehBdNBpDsN6JMiBuc1YphC6gnRnJmVmP/+
         jyQPLds7RdYEPZOvY0HCtnSSjGHZhU8afJdJe2Wvl0HyNPqBkH/MZcjlcLSlm5cdkEoQ
         oPaUWTvQGPAYtwBnhlLK/B5ECKLJcsuKjefBB/pmkJ5Ju0Mu05sRAiKO7wnNVtAljjgA
         /h3w==
X-Forwarded-Encrypted: i=1; AJvYcCXL0WGRTjgE2W/qy4M9A1963XL4eUN1aGOSbxl2+ro0A7uZo9fCEXKlFF9qV7WYfLTURwl2LNoGqSuolQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwCngD7AuhIAZK+Md0/f/BGPnHcGpnWNFsjZMLErigs8ZT28erX
	d2qzvEE5sSlBMqars1TToltKO+OeAsjgxYZSYFxyBLqjNbd7XXFQqiok2lsXe7gpNySHq+dVexG
	Zi+bvGb94ClvrGFbiH+ANJCzNw76RicfVbsxIjlNdJ+f3rbPQ87SRm/w=
X-Google-Smtp-Source: AGHT+IHG2c61isn5GA9+55vBjD8aJW9fFN5gdQmIboy7WuCMsi5OHCrOIBK5CnwT1e82O3YnNWW/bx4JJjNRYnpkFNub7Gg8NGDL
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:138d:b0:3d0:2ea8:87c0 with SMTP id
 e9e14a558f8ab-3d02ea889c2mr59491685ab.8.1738608922538; Mon, 03 Feb 2025
 10:55:22 -0800 (PST)
Date: Mon, 03 Feb 2025 10:55:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a1111a.050a0220.d7c5a.00a4.GAE@google.com>
Subject: [syzbot] [nilfs?] general protection fault in __d_unalias
From: syzbot <syzbot+ab57f676a518849a8d57@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    69b8923f5003 Merge tag 'for-linus-6.14-ofs4' of git://git...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14fbdddf980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=57ab43c279fa614d
dashboard link: https://syzkaller.appspot.com/bug?extid=ab57f676a518849a8d57
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15da95f8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=165f8b24580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ea84ac864e92/disk-69b8923f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6a465997b4e0/vmlinux-69b8923f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d72b67b2bd15/bzImage-69b8923f.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/7d96d510aa23/mount_0.gz

The issue was bisected to:

commit 30d61efe118cad1a73ad2ad66a3298e4abdf9f41
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Mon Jan 6 02:33:17 2025 +0000

    9p: fix ->rename_sem exclusion

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=148b7b64580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=168b7b64580000
console output: https://syzkaller.appspot.com/x/log.txt?x=128b7b64580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ab57f676a518849a8d57@syzkaller.appspotmail.com
Fixes: 30d61efe118c ("9p: fix ->rename_sem exclusion")

Oops: general protection fault, probably for non-canonical address 0xdffffc000000000d: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000068-0x000000000000006f]
CPU: 0 UID: 0 PID: 5821 Comm: syz-executor287 Not tainted 6.13.0-syzkaller-09793-g69b8923f5003 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
RIP: 0010:__d_unalias+0x199/0x2a0 fs/dcache.c:2969
Code: 98 00 00 00 4c 89 fb 48 c1 eb 03 49 89 ed 80 3c 2b 00 74 08 4c 89 ff e8 65 62 e7 ff 49 8b 2f 48 83 c5 68 48 89 e8 48 c1 e8 03 <42> 80 3c 28 00 74 08 48 89 ef e8 48 62 e7 ff 4c 8b 5d 00 4d 85 db
RSP: 0018:ffffc90003d9fa98 EFLAGS: 00010202
RAX: 000000000000000d RBX: 1ffff1100996cb61 RCX: ffff88804d821e00
RDX: 0000000000000000 RSI: ffff88804cb65a70 RDI: ffff88804cb658f8
RBP: 0000000000000068 R08: ffff88804e530f6b R09: 1ffff11009ca61ed
R10: dffffc0000000000 R11: ffffed1009ca61ee R12: ffff88804cb65a70
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88804cb65b08
FS:  000055555b892380(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe074ff000 CR3: 0000000078440000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 d_splice_alias+0x1e6/0x330 fs/dcache.c:3037
 nilfs_lookup+0x1c2/0x2a0 fs/nilfs2/namei.c:77
 lookup_one_qstr_excl+0x126/0x2b0 fs/namei.c:1693
 do_renameat2+0x706/0x13f0 fs/namei.c:5176
 __do_sys_rename fs/namei.c:5273 [inline]
 __se_sys_rename fs/namei.c:5271 [inline]
 __x64_sys_rename+0x82/0x90 fs/namei.c:5271
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7cc482fad9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe074fe328 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
RAX: ffffffffffffffda RBX: 00007f7cc4878fc8 RCX: 00007f7cc482fad9
RDX: 0000000000000000 RSI: 0000000020000800 RDI: 00000000200001c0
RBP: 00007f7cc48a35f0 R08: 000055555b8934c0 R09: 000055555b8934c0
R10: 000055555b8934c0 R11: 0000000000000246 R12: 00007ffe074fe350
R13: 00007ffe074fe578 R14: 431bde82d7b634db R15: 00007f7cc487803b
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__d_unalias+0x199/0x2a0 fs/dcache.c:2969
Code: 98 00 00 00 4c 89 fb 48 c1 eb 03 49 89 ed 80 3c 2b 00 74 08 4c 89 ff e8 65 62 e7 ff 49 8b 2f 48 83 c5 68 48 89 e8 48 c1 e8 03 <42> 80 3c 28 00 74 08 48 89 ef e8 48 62 e7 ff 4c 8b 5d 00 4d 85 db
RSP: 0018:ffffc90003d9fa98 EFLAGS: 00010202
RAX: 000000000000000d RBX: 1ffff1100996cb61 RCX: ffff88804d821e00
RDX: 0000000000000000 RSI: ffff88804cb65a70 RDI: ffff88804cb658f8
RBP: 0000000000000068 R08: ffff88804e530f6b R09: 1ffff11009ca61ed
R10: dffffc0000000000 R11: ffffed1009ca61ee R12: ffff88804cb65a70
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88804cb65b08
FS:  000055555b892380(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe074ff000 CR3: 0000000078440000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	98                   	cwtl
   1:	00 00                	add    %al,(%rax)
   3:	00 4c 89 fb          	add    %cl,-0x5(%rcx,%rcx,4)
   7:	48 c1 eb 03          	shr    $0x3,%rbx
   b:	49 89 ed             	mov    %rbp,%r13
   e:	80 3c 2b 00          	cmpb   $0x0,(%rbx,%rbp,1)
  12:	74 08                	je     0x1c
  14:	4c 89 ff             	mov    %r15,%rdi
  17:	e8 65 62 e7 ff       	call   0xffe76281
  1c:	49 8b 2f             	mov    (%r15),%rbp
  1f:	48 83 c5 68          	add    $0x68,%rbp
  23:	48 89 e8             	mov    %rbp,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	48 89 ef             	mov    %rbp,%rdi
  34:	e8 48 62 e7 ff       	call   0xffe76281
  39:	4c 8b 5d 00          	mov    0x0(%rbp),%r11
  3d:	4d 85 db             	test   %r11,%r11


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
