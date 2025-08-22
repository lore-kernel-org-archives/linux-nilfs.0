Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D580726656D
	for <linux-nilfs@vger.kernel.org>; Fri, 22 Aug 2025 08:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755850121; cv=none; b=UMiDja6FbzcuIBxi5gFeHDX8le4XFeRvATFZChMaEBTMKZUT2ynlBsHwMNwlymW6zhaDtAgZnA9oaa4CUAtvbDJHQIBcKFQaUSjfVY/yhi9ADn8Zc5SqF5dEDfob6DIfrd/E90+f2D/bQ1oaN874QkKidxzKCb/lRYhBsZVOpKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755850121; c=relaxed/simple;
	bh=gvMucvsGL9/rs+sKNGY8FGvWklmjh5DHZVp98Pm1JbQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=oWUCjVXOAzPw/0Qk+xGP+mqbY50aTk1as9Ze6nIN8lX9r8dLvVn9xgkmptKhhg1MYp33/rPE2xQAB/TlrBOtkjQu7EK9G0oS7hSDXU/PjhuY5PeC/Ucl6Q8UJlXuSGqv5I8kT0QT8hbD6LcUsjHunkShIl62GTaP/5E+mus3UV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3e5d398a961so45438875ab.1
        for <linux-nilfs@vger.kernel.org>; Fri, 22 Aug 2025 01:08:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755850119; x=1756454919;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m1G4T+LI1tz01U4aeRa7XV3JJRdBzExQv3v5X47SK24=;
        b=W8qt72Fd4IRpfgJxGeXitC4PlRc40FQnLssw2mxecIHptoL0v3Ro3hQnztGn14ff8G
         UI0s8rvrpoo6Sl+NO1qGA/SdJBE+ow5LvkNre6i/geLamO5ZsnZ8yHzEJl3obh/pg7iY
         mes8sAXLRSek25XuK6+CkyLTydPcFv7DFuDfoLn+fGqoPSSNX1AY1racIJ8szYT9pW3u
         mXzCjs0dAP/ny494m+n+lYIcMs8Df4Uw+hbo4r4HJyN21jURiPSd/tXZxjgKTPlk5NcS
         S10Num4Mq6+Npj8rc8Z0fMDD3lgY2F7QatMa7V1F0g3qAGABaYda6CGhvezmIuK8Oyd/
         Q1+A==
X-Forwarded-Encrypted: i=1; AJvYcCUmyUkPtG1bEPgUHxquyVOFliIqKz+rq3At7Bt3+f3Q2otGzzT3F//pBfUUOENbKANXDUSgx7CzilEnHQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyoLvQGcNQGAnT4Evn+CVivFJ/26UJ1sIHAo9rqetRvjKtRURPj
	sgzuSUAS1siR7mpwTiI6eU5UiskDbLi2SeY5KgapL3FoSnig1ubv4cRspcDHUhP66e8S7380FAD
	VZapWiQcIROh+Go/HWA/MfIRsoqlzFjVn03lsG0STeuFI/zgY8JX+A7UwHeU=
X-Google-Smtp-Source: AGHT+IFwZIXIXCg5wwhs4/GBcc6ClLz1hXcz4EkY84ASMXYWrkc7r1KAg4dvOlK5D6atePoZyoTaGz71gEZjJ6M8YAsoQJMqI1Sk
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:19c7:b0:3e5:6a2e:e3cf with SMTP id
 e9e14a558f8ab-3e9203e6ef4mr37986065ab.10.1755850118945; Fri, 22 Aug 2025
 01:08:38 -0700 (PDT)
Date: Fri, 22 Aug 2025 01:08:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a82586.a00a0220.33401d.0251.GAE@google.com>
Subject: [syzbot] [nilfs?] WARNING in nilfs_rename (2)
From: syzbot <syzbot+f6c7e1f1809f235eeb90@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b19a97d57c15 Merge tag 'pull-fixes' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1485e6f0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a7016efe6aaa498c
dashboard link: https://syzkaller.appspot.com/bug?extid=f6c7e1f1809f235eeb90
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-b19a97d5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/873500da1a4e/vmlinux-b19a97d5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2e4fbb7fb070/bzImage-b19a97d5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f6c7e1f1809f235eeb90@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 2048
NILFS (loop0): broken superblock, retrying with spare superblock (blocksize = 1024)
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5356 at fs/inode.c:417 drop_nlink+0xc5/0x110 fs/inode.c:417
Modules linked in:
CPU: 0 UID: 0 PID: 5356 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:drop_nlink+0xc5/0x110 fs/inode.c:417
Code: 78 07 00 00 be 08 00 00 00 e8 d7 f0 e7 ff 3e 48 ff 83 78 07 00 00 5b 41 5c 41 5e 41 5f 5d e9 82 96 41 09 cc e8 3c 06 83 ff 90 <0f> 0b 90 eb 81 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 5b ff ff ff
RSP: 0018:ffffc9000d6879f0 EFLAGS: 00010283
RAX: ffffffff823cb4a4 RBX: ffff88804461bab8 RCX: 0000000000100000
RDX: ffffc9000e58a000 RSI: 000000000000096c RDI: 000000000000096d
RBP: 0000000000000000 R08: ffffffff8fa3a437 R09: 1ffffffff1f47486
R10: dffffc0000000000 R11: fffffbfff1f47487 R12: 1ffff110088c3760
R13: ffff88804461adf8 R14: ffff88804461bb00 R15: dffffc0000000000
FS:  00007f40b8f4e6c0(0000) GS:ffff88808d210000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000010000 CR3: 0000000043cee000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 nilfs_rename+0x46a/0x820 fs/nilfs2/namei.c:418
 vfs_rename+0xbd7/0xf00 fs/namei.c:5129
 do_renameat2+0x6ce/0xa80 fs/namei.c:5278
 __do_sys_rename fs/namei.c:5325 [inline]
 __se_sys_rename fs/namei.c:5323 [inline]
 __x64_sys_rename+0x82/0x90 fs/namei.c:5323
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f40b818ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f40b8f4e038 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
RAX: ffffffffffffffda RBX: 00007f40b83b5fa0 RCX: 00007f40b818ebe9
RDX: 0000000000000000 RSI: 0000200000000040 RDI: 0000200000000000
RBP: 00007f40b8211e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f40b83b6038 R14: 00007f40b83b5fa0 R15: 00007ffc1ce1df48
 </TASK>


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
