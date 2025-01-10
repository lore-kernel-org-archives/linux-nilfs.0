Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474512080DB
	for <linux-nilfs@vger.kernel.org>; Fri, 10 Jan 2025 13:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736516545; cv=none; b=WxpVNwpO2H121oIPO8+zlwpV868p/EHzqqFZUk7yVXw1gl6rw1SqlMqU9/NFhPUEy/OXxpRBYNEb6Yi5owD5sTICLxwCLCBYNasTz3lOcyXBQwHFXrCQxNzQyo6E1rvBFAJMaIm7OFHGXM+n+IiEc8vW62huWPFazCztwdq5Axc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736516545; c=relaxed/simple;
	bh=2oPafSaF+U+wwnSSIQrB7MzNnyrsIiqx0JQVHkSvoao=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=aHwsRjQGlvrL5khE2u8Fx8fsFgrIsm6Vfp2LD1PF+laQQkvrvwDnfcFfKZvqccv8wCCdfQFwKd6ufGBhRZZN9OkCJYDUFhQmcpTCkUMDOrtm6/i9Gv/G8rDXzhzDgnYsOCJFDRisHVza8N0favQk5XFFOpQFRqbW1GqG35jYW/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3a7e4bfae54so16211825ab.0
        for <linux-nilfs@vger.kernel.org>; Fri, 10 Jan 2025 05:42:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736516543; x=1737121343;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ueKhbx99YrxbsA7xImzVYe47LV++NIJ+2cMP5wQU9F8=;
        b=JYrax+hq/ZkOaddTfW518h12GP2zPEHWe52WosLopqK7K2i44Rtuo/1xRzCqJE7xc8
         OJoEm3wqRPMHoS9zG6L6PDQj/UIwN5aDrzZ2tiOIqUgCIWkbDoUwEYqS5dEpE3ALmmNn
         DE05ZPcQe8j7z2t9bUi/cHHu6gSJKjpm7jAYSzfI4Vt6JgUH9ghaYhQ/FT8z4Lo7UHs+
         FSNKtEyhcjmh+0ZWe9JjEUwoJmCvhZZcpQjF/X5mNFLUnTv1DVrgYTi1Yk2mXJcO+vug
         bTi0GCsu2DFWQitcSx+U4bVEzNeiLOe4d0VWUwDReBQp7Qq3G3+WR6RkZXzP+OK6mnQF
         uxCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpFmf8APAD1I+2/LlK/FVFWSoAtYhW1TNWzxp7u4Nawdu7ShdDwnGkL6osfPKVL+0p3pON7O6SDVYBMg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxjWtTmJ75CYOOZx6wXpaAG+QoXpn61ysAX6aAiNqADapKLas6M
	++Jk8BvjtW/stsE47KyacPpaVhZ/FWxE8pEa3KUwfnVgJHyQvRAvDDpg4xn/+zrYo/il0+bv+jf
	yYWsYwGUaR6+lbtTPLIRo83VMuVpei0+HKxW7EKuECwoZ3Dke8m4ZPqY=
X-Google-Smtp-Source: AGHT+IFnFAXzyi2qiswxzO/hFplzsmpbM7CTSR4KY19xlJZsXrWCGH2C7Ucvn6+g3w7OfadTighnLG/RXOkeonqEuWEu18hnlfk1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c24f:0:b0:3a7:e592:55ee with SMTP id
 e9e14a558f8ab-3ce3aa746d1mr86893085ab.20.1736516543463; Fri, 10 Jan 2025
 05:42:23 -0800 (PST)
Date: Fri, 10 Jan 2025 05:42:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <678123bf.050a0220.216c54.000f.GAE@google.com>
Subject: [syzbot] [nilfs?] kernel BUG in nilfs_set_link
From: syzbot <syzbot+1097e95f134f37d9395c@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9d89551994a4 Linux 6.13-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1510b418580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4ef22c4fce5135b4
dashboard link: https://syzkaller.appspot.com/bug?extid=1097e95f134f37d9395c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-9d895519.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bcfa24563a7a/vmlinux-9d895519.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5bc14c94d0b7/bzImage-9d895519.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1097e95f134f37d9395c@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 2048
loop0: detected capacity change from 2048 to 0
syz.0.0: attempt to access beyond end of device
loop0: rw=0, sector=84, nr_sectors = 2 limit=0
NILFS (loop0): I/O error reading meta-data file (ino=3, block-offset=0)
NILFS (loop0): error -5 truncating bmap (ino=16)
syz.0.0: attempt to access beyond end of device
loop0: rw=0, sector=100, nr_sectors = 2 limit=0
NILFS (loop0): I/O error reading meta-data file (ino=3, block-offset=226)
syz.0.0: attempt to access beyond end of device
loop0: rw=0, sector=100, nr_sectors = 2 limit=0
NILFS (loop0): I/O error reading meta-data file (ino=3, block-offset=226)
syz.0.0: attempt to access beyond end of device
loop0: rw=0, sector=100, nr_sectors = 2 limit=0
NILFS (loop0): I/O error reading meta-data file (ino=3, block-offset=226)
syz.0.0: attempt to access beyond end of device
loop0: rw=0, sector=100, nr_sectors = 2 limit=0
NILFS (loop0): I/O error reading meta-data file (ino=3, block-offset=226)
syz.0.0: attempt to access beyond end of device
loop0: rw=0, sector=100, nr_sectors = 2 limit=0
NILFS (loop0): I/O error reading meta-data file (ino=3, block-offset=226)
syz.0.0: attempt to access beyond end of device
loop0: rw=0, sector=70, nr_sectors = 2 limit=0
NILFS (loop0): I/O error reading meta-data file (ino=6, block-offset=0)
syz.0.0: attempt to access beyond end of device
loop0: rw=0, sector=70, nr_sectors = 2 limit=0
NILFS (loop0): I/O error reading meta-data file (ino=6, block-offset=0)
NILFS (loop0): mounting fs with errors
Buffer I/O error on dev loop0, logical block 1, lost sync page write
NILFS (loop0): unable to write superblock: err=-5
NILFS (loop0): I/O error reading meta-data file (ino=3, block-offset=2)
------------[ cut here ]------------
kernel BUG at fs/nilfs2/dir.c:413!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5317 Comm: syz.0.0 Not tainted 6.13.0-rc6-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:nilfs_set_link+0x3ed/0x3f0 fs/nilfs2/dir.c:413
Code: c6 60 af 46 8c e8 03 b8 6d fe 90 0f 0b e8 eb f7 23 fe 4c 89 ef 48 c7 c6 60 af 46 8c e8 ec b7 6d fe 90 0f 0b e8 d4 f7 23 fe 90 <0f> 0b 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55 41 57
RSP: 0018:ffffc9000d1ff8c0 EFLAGS: 00010283
RAX: ffffffff837b8c4c RBX: 00000000fffffffb RCX: 0000000000100000
RDX: ffffc9000e672000 RSI: 0000000000000edb RDI: 0000000000000edc
RBP: ffff88804cb93050 R08: ffffffff837b8a9b R09: 1ffff11008674b79
R10: dffffc0000000000 R11: ffffed1008674b7a R12: dffffc0000000000
R13: ffffea000132e4c0 R14: 0000000000000050 R15: 0000000000000018
FS:  00007f595bb756c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff7ccc87580 CR3: 00000000339c0000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 nilfs_rename+0x6a3/0xb60 fs/nilfs2/namei.c:409
 vfs_rename+0xbdb/0xf00 fs/namei.c:5067
 do_renameat2+0xd94/0x13f0 fs/namei.c:5224
 __do_sys_rename fs/namei.c:5271 [inline]
 __se_sys_rename fs/namei.c:5269 [inline]
 __x64_sys_rename+0x82/0x90 fs/namei.c:5269
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f595ad85d29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f595bb75038 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
RAX: ffffffffffffffda RBX: 00007f595af75fa0 RCX: 00007f595ad85d29
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000020000000
RBP: 00007f595ae01b08 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f595af75fa0 R15: 00007ffd8f311a58
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:nilfs_set_link+0x3ed/0x3f0 fs/nilfs2/dir.c:413
Code: c6 60 af 46 8c e8 03 b8 6d fe 90 0f 0b e8 eb f7 23 fe 4c 89 ef 48 c7 c6 60 af 46 8c e8 ec b7 6d fe 90 0f 0b e8 d4 f7 23 fe 90 <0f> 0b 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55 41 57
RSP: 0018:ffffc9000d1ff8c0 EFLAGS: 00010283
RAX: ffffffff837b8c4c RBX: 00000000fffffffb RCX: 0000000000100000
RDX: ffffc9000e672000 RSI: 0000000000000edb RDI: 0000000000000edc
RBP: ffff88804cb93050 R08: ffffffff837b8a9b R09: 1ffff11008674b79
R10: dffffc0000000000 R11: ffffed1008674b7a R12: dffffc0000000000
R13: ffffea000132e4c0 R14: 0000000000000050 R15: 0000000000000018
FS:  00007f595bb756c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f595bb53fe0 CR3: 00000000339c0000 CR4: 0000000000352ef0
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

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
