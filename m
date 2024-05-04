Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCA611C83
	for <linux-nilfs@vger.kernel.org>; Sat,  4 May 2024 10:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714818026; cv=none; b=oiKAXA7OXNFp0wLzgs05Hst4btvRttpOxoerKROZU3ipPT/FzPKPmBZh0dZn46QiRBLY/V57n3wu6SGc4IZNhQKan6PKiOKJnSkCvtgaCfzUUV1pbkYPLOiu3pS+ID5wusonDOr4glg5F8oDxFVrkMluoL+E8gfv5qnlDSPJuRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714818026; c=relaxed/simple;
	bh=f3ZCC3zL8tRcZUJFQuNyugK98teMQI6taUUDNNpK8HI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=RS9Ap5PF7AnO+dXvtKW5vql51XejftjEuOu+UPkIF2kwrss9M9dZ2bN0/PwzYscoer3uCX9veFX/q27DF4leMQf2DpzL7IECMIWLc8jtG61JGatv4DVPbkhfIKtcZRrhlMatM8GoS4v2W7HZ23s7ZCtp3gNg7zBTCF0iSHrtBZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7dabc125bddso54322439f.1
        for <linux-nilfs@vger.kernel.org>; Sat, 04 May 2024 03:20:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714818024; x=1715422824;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xB7sASZi2zAZfTr+eiRShYCfkDng1wuAp6mEFs4Fxtg=;
        b=AO+/BcNS+yZaDARZIXN+uITtftUi/m+bHHrLfajlcKviHcCLa2JOz8fQLGSu3NSCLb
         3r2hgwnBBsUu9HuhpXs+dkaYmDAD0ZCmJFmn5f3khcICR5A7p4KG4DhMx3Z0QsCLAmH5
         7AZX+e6uvTp2BHcZ/VAeSSn3unLuhJ19JaDcfGFFS8wWMmBMn8vdyD18Lc4eslcK+zro
         jAnXD8NJnonwvfd23paIDwjurb4U5hSQU965+alzBkyOSXWqAbeDfhLdP/HX5iLIiFWd
         WrK4bE/5fC6BYqBsJ47e4qWlsfTE521lMjfb8nugQndwV9WqbB4eL4wFK2SlggagWyyD
         yRIw==
X-Forwarded-Encrypted: i=1; AJvYcCVIHR2qBuAgvdvTsub5RGSQTV19PSITcbUEfoX9r2u959UNKDkUrIiyCrXRwVWCrIc8pA4IgWCTBuH8VDJvrTiAV1FM18Q4dW1+Jgs=
X-Gm-Message-State: AOJu0YwdNigI/DSK5QCmRwiE3+OxWoaJiTE/fZvuCmsFf4tZlQixLWmD
	17friSQd0JBBLfCIbmu7LU3slV3cI/3JcEd/dXp7/P1Mh+CNxO/3CbrKm6iMsW3NsanXIJIQItB
	BPYTqA90pVKi5DeKal/4RB8WGmoO2DFioAnl2wd6rcGcRFxrKojNmULI=
X-Google-Smtp-Source: AGHT+IGzvz1Mw0fAOzxO2wWjg3fBabX/zrPt0NQhWeXtWP4eC4Rb7cDxXoHSKDDciTcFgZjK5CrM+YSbQ3UdeOdBvcX9qGJdhC8q
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:168b:b0:7de:e58e:4d72 with SMTP id
 s11-20020a056602168b00b007dee58e4d72mr163608iow.1.1714818024205; Sat, 04 May
 2024 03:20:24 -0700 (PDT)
Date: Sat, 04 May 2024 03:20:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003002be06179e2f61@google.com>
Subject: [syzbot] [nilfs?] kernel BUG in __block_write_begin_int (2)
From: syzbot <syzbot+d3abed1ad3d367fa2627@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9e4bc4bcae01 Merge tag 'nfs-for-6.9-2' of git://git.linux-..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12f2ae87180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3714fc09f933e505
dashboard link: https://syzkaller.appspot.com/bug?extid=d3abed1ad3d367fa2627
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150c697f180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140de537180000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b98a742ff5ed/disk-9e4bc4bc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/207a8191df7c/vmlinux-9e4bc4bc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7dd86c3ad0ba/bzImage-9e4bc4bc.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d35001c4b748/mount_0.gz

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15526d37180000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17526d37180000
console output: https://syzkaller.appspot.com/x/log.txt?x=13526d37180000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d3abed1ad3d367fa2627@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/buffer.c:2083!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 PID: 5084 Comm: syz-executor283 Not tainted 6.9.0-rc6-syzkaller-00012-g9e4bc4bcae01 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
RIP: 0010:__block_write_begin_int+0x19a7/0x1a70 fs/buffer.c:2083
Code: 31 ff e8 ac 35 78 ff 48 89 d8 48 25 ff 0f 00 00 74 27 e8 bc 30 78 ff e9 c6 e7 ff ff e8 b2 30 78 ff 90 0f 0b e8 aa 30 78 ff 90 <0f> 0b e8 a2 30 78 ff 90 0f 0b e8 ca 5d 62 09 48 8b 5c 24 08 48 89
RSP: 0018:ffffc90003327760 EFLAGS: 00010293
RAX: ffffffff821ddf06 RBX: 0000000000007b54 RCX: ffff88802eff3c00
RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000007b54
RBP: ffffc900033278c8 R08: ffffffff821dc733 R09: 1ffffd400006f810
R10: dffffc0000000000 R11: fffff9400006f811 R12: 00fff0000000920d
R13: 0000000000000000 R14: 0000000000001000 R15: 0000000000007b54
FS:  000055556494d480(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055838a10d7f0 CR3: 0000000078508000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 nilfs_prepare_chunk fs/nilfs2/dir.c:86 [inline]
 nilfs_set_link+0xc5/0x2a0 fs/nilfs2/dir.c:411
 nilfs_rename+0x5b2/0xaf0 fs/nilfs2/namei.c:416
 vfs_rename+0xbdd/0xf00 fs/namei.c:4880
 do_renameat2+0xd94/0x13f0 fs/namei.c:5037
 __do_sys_rename fs/namei.c:5084 [inline]
 __se_sys_rename fs/namei.c:5082 [inline]
 __x64_sys_rename+0x86/0xa0 fs/namei.c:5082
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa292c67f99
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd9d3b0198 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fa292c67f99
RDX: 00007fa292c67f99 RSI: 0000000020000040 RDI: 0000000020000180
RBP: 0000000000000000 R08: 00007ffd9d3b01d0 R09: 00007ffd9d3b01d0
R10: 0000000000000f69 R11: 0000000000000246 R12: 00007ffd9d3b01d0
R13: 00007ffd9d3b0458 R14: 431bde82d7b634db R15: 00007fa292cb103b
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__block_write_begin_int+0x19a7/0x1a70 fs/buffer.c:2083
Code: 31 ff e8 ac 35 78 ff 48 89 d8 48 25 ff 0f 00 00 74 27 e8 bc 30 78 ff e9 c6 e7 ff ff e8 b2 30 78 ff 90 0f 0b e8 aa 30 78 ff 90 <0f> 0b e8 a2 30 78 ff 90 0f 0b e8 ca 5d 62 09 48 8b 5c 24 08 48 89
RSP: 0018:ffffc90003327760 EFLAGS: 00010293
RAX: ffffffff821ddf06 RBX: 0000000000007b54 RCX: ffff88802eff3c00
RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000007b54
RBP: ffffc900033278c8 R08: ffffffff821dc733 R09: 1ffffd400006f810
R10: dffffc0000000000 R11: fffff9400006f811 R12: 00fff0000000920d
R13: 0000000000000000 R14: 0000000000001000 R15: 0000000000007b54
FS:  000055556494d480(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055838a039e38 CR3: 0000000078508000 CR4: 0000000000350ef0


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
