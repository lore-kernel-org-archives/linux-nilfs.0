Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B3C20605C
	for <linux-nilfs@vger.kernel.org>; Wed, 16 Oct 2024 09:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729072770; cv=none; b=YvQJYdQ8ynMqfPIRB249vPeHdkn9yuXUbdZhQ5gOW7eubmCZmrDhpzbIUiQCvXo4ii1++unZBqXWKuHcHQyNVDu4AfJ+I8CtBvx6lY/EwwjenAsKSrQ2e5vMOWrF6x9hcOlPFVAe1wmfBcJTSiEn164+vzhnSV0d3v3NEKXJjYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729072770; c=relaxed/simple;
	bh=CsaAuW/c+r+49Zy9BNSxKxc3Q2WsQboJgPMl0jfwOzc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=FuaPM13YHJ1K76gcwVpLFe7vH+2reNBflf+1536Z+aB1Ym+RPU3pI5O9w9ZcUHDA/xiNNLh4FdSuQg2mzQdKrcjiyf8RTnwyEpkaCeZGh+DXSR9nRGJOaa9mGDciMTTbS9rzUbUiVTtY6BzPHCPu5u7LonXWJe7lbZRuwUQMYp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a3cd35858aso18983735ab.1
        for <linux-nilfs@vger.kernel.org>; Wed, 16 Oct 2024 02:59:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729072768; x=1729677568;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/mcL+Ha40smPG0e5OGzEdRegaD2j1e3PUR7489d5OBo=;
        b=lr9/TwDAzn47jfm3ad3vtYjfrYOB4Psg6ASevbXvCP5I3Sz751JhvEaLkVKf9hJUVN
         VjcKmXqy/NagSmmZMWTZQ+ny5TdQgOnDa32jeoZNfZDok615i7kAnK0DFqrCyf03lwpZ
         SlQLfgSUQIrNIPxVFIIER+icoJu2zutmXO91J0LLGAOcgCdVOXTcg+vKLqWEA/TR7SB/
         Da4KQTCtJxQ2YSMrurZEoTtzBz36xa1owLvDjpmP5L0g53Pw4kZ0YMzTnVec4DeTRvoB
         2W5D0x43Qrjuo+eACKliasp/0mN75lXIEaBwcTftr/Px8okOyKdd6I0coYLS5oeGoRld
         DYbw==
X-Forwarded-Encrypted: i=1; AJvYcCWH70SCtM6NwxwEjTi53mGGA0NllR6Ao4RO1QxObyw7qn0C+44JttAh7fztGalIZHt9PorTbgplSjCzhA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzZCg5o+SYrJHgiXVv0zJuABbSWQp+srJ7QMjk+9SP3t0Szgn7r
	qEU4L85JG/oYnkldOxMMewgBx1RAm9x9SzLlV+RkzAnI7Sy6qXaeiscvY3EEjCDJrv/KqO/EtGU
	n45nH1yClnQSmnK32ByjAEb/16SOaJUN/bV9oErZB2Xrd8+iJ7raJJVc=
X-Google-Smtp-Source: AGHT+IHoQ1SfCXoFHherlmdA4cX3q47lXXWbvVjw59Xca+H2T/EL59OOq8i/X6K89HxatG2i5A6SUHsFrGDt3ct7Y1HUTlf0Yj9u
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1562:b0:3a0:4250:165f with SMTP id
 e9e14a558f8ab-3a3dc3ce0a4mr35824085ab.0.1729072768209; Wed, 16 Oct 2024
 02:59:28 -0700 (PDT)
Date: Wed, 16 Oct 2024 02:59:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <670f8e80.050a0220.d9b66.0163.GAE@google.com>
Subject: [syzbot] [nilfs?] kernel BUG in __block_write_begin_int (3)
From: syzbot <syzbot+d6ca2daf692c7a82f959@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2f87d0916ce0 Merge tag 'trace-ringbuffer-v6.12-rc3' of git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1425d887980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbd94c114a3d407
dashboard link: https://syzkaller.appspot.com/bug?extid=d6ca2daf692c7a82f959
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13a2245f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13295030580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-2f87d091.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2704ba6867a8/vmlinux-2f87d091.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9f7121fd532b/bzImage-2f87d091.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/b4825b2e2eaa/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d6ca2daf692c7a82f959@syzkaller.appspotmail.com

NILFS (loop0): mounting fs with errors
------------[ cut here ]------------
kernel BUG at fs/buffer.c:2099!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5098 Comm: syz-executor902 Not tainted 6.12.0-rc3-syzkaller-00044-g2f87d0916ce0 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__block_write_begin_int+0x19a7/0x1a70 fs/buffer.c:2099
Code: 31 ff e8 cc 58 71 ff 48 89 d8 48 25 ff 0f 00 00 74 27 e8 dc 53 71 ff e9 c6 e7 ff ff e8 d2 53 71 ff 90 0f 0b e8 ca 53 71 ff 90 <0f> 0b e8 c2 53 71 ff 90 0f 0b e8 6a b2 a2 09 48 8b 5c 24 08 48 89
RSP: 0018:ffffc9000179f9e0 EFLAGS: 00010293
RAX: ffffffff82239386 RBX: 0000000000007372 RCX: ffff8880008ec880
RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000007372
RBP: ffffc9000179fb50 R08: ffffffff82237bb3 R09: 1ffffd400021e7b8
R10: dffffc0000000000 R11: fffff9400021e7b9 R12: 04fff5000000462d
R13: 0000000000000000 R14: 0000000000001000 R15: 0000000000007372
FS:  000055558bc8f380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005597207fdc30 CR3: 00000000404c2000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 nilfs_prepare_chunk fs/nilfs2/dir.c:86 [inline]
 nilfs_add_link+0x66e/0xb50 fs/nilfs2/dir.c:486
 nilfs_mkdir+0x1f9/0x340 fs/nilfs2/namei.c:233
 vfs_mkdir+0x2f9/0x4f0 fs/namei.c:4257
 do_mkdirat+0x264/0x3a0 fs/namei.c:4280
 __do_sys_mkdir fs/namei.c:4300 [inline]
 __se_sys_mkdir fs/namei.c:4298 [inline]
 __x64_sys_mkdir+0x6c/0x80 fs/namei.c:4298
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6018852427
Code: 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdfca7e2b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6018852427
RDX: 0000000000000004 RSI: 00000000000001ff RDI: 0000000020000780
RBP: 0000000020000780 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffdfca7e350 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__block_write_begin_int+0x19a7/0x1a70 fs/buffer.c:2099
Code: 31 ff e8 cc 58 71 ff 48 89 d8 48 25 ff 0f 00 00 74 27 e8 dc 53 71 ff e9 c6 e7 ff ff e8 d2 53 71 ff 90 0f 0b e8 ca 53 71 ff 90 <0f> 0b e8 c2 53 71 ff 90 0f 0b e8 6a b2 a2 09 48 8b 5c 24 08 48 89
RSP: 0018:ffffc9000179f9e0 EFLAGS: 00010293
RAX: ffffffff82239386 RBX: 0000000000007372 RCX: ffff8880008ec880
RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000007372
RBP: ffffc9000179fb50 R08: ffffffff82237bb3 R09: 1ffffd400021e7b8
R10: dffffc0000000000 R11: fffff9400021e7b9 R12: 04fff5000000462d
R13: 0000000000000000 R14: 0000000000001000 R15: 0000000000007372
FS:  000055558bc8f380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005597207fdc30 CR3: 00000000404c2000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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
