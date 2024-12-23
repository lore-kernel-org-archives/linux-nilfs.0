Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEEF38C
	for <linux-nilfs@vger.kernel.org>; Mon, 23 Dec 2024 00:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734914369; cv=none; b=B+64JcuAATQwYUslexPhUL+GjVedigDbTbzVQ3xlll2UBnnCFea7KeB4JoGOQehhL6Wt1IguSoXZXMbZMvTZUb8sU8EplNIT4pOVsBOtBPrj23sI+7hFf9aoXMlIa6ffaNKX8Yqdy+zI9ez8Et3hjSqNVOKOOO7nZ8n8pw2PYbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734914369; c=relaxed/simple;
	bh=t41O1ldqcn9OzEeJBDflaYI4TiakTD0vsGvsG/R+s5E=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=BpOdtMoz9+IxMGT5bFyy9kKvw45BEFoYfoiKvn2H5KBo91GV7gtUAwjOm9Vfkp12cIBzeSOjcQMrUn4l/iCMrnjJFCrAjM/zJI1BeCym1ojb+hJ/kpzxp+HEBi1sCuDkngMY4pB031dMbLqLPBksviVWL8yv3Y0BxPvRZ46Q7Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3a7e0d7b804so30836305ab.0
        for <linux-nilfs@vger.kernel.org>; Sun, 22 Dec 2024 16:39:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734914366; x=1735519166;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RERxOP3kkFVKOFbl0Zn5ScJiEU16CVZNCLTNI9N8F70=;
        b=JZMo9BMEjsk+ovpE7GZIeJozDL6GPfZx82NmixGwzHyawo7EaAIrt6vY0wn8XzNwRR
         8WRYBw0vv9Wxc9pHjQwsB9B7O6yjnv7QADmBGVMiZ6RfyVHLOXAdXyG7QO0XCDLTilYy
         i0QrAukuVC4V+O9wsca3coWBLFKDyssbhPVRZXe1WOSVKAs4CZ0WXxGfJi7FValoh1no
         4yvXZqAFoGFwa9SuoqB3OyIto4LCk+VrXuUBRNckcHHmSexjDovt6mXDP9riszXoYhrl
         YeyCs2vGjaWBRINZTMUxXWQDRJpjP7VY9FQYFPJSsQsiN48ptnRxaGLzzL2YiL7fVDiW
         3zQg==
X-Forwarded-Encrypted: i=1; AJvYcCWHlQ3fLP6uJagm106ECfFKxrO0HkfnqlL3Kt/1/6EO7ZG03r1yyRv0iaW5txSFw6ro2Ttz9ZcrHFFqWQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwMHi0SlN4DuRv9pLnv6f9zRlEe2jMCOekQPzp7Cyv13zy8W3Z8
	Ty0trha7CnCaMJjhNTP03uOybBV8YH0hoNQXcc1hr9GwiXkQIa/hg41ISDsQTMq9PK2VZKYWkXR
	R7oI1EtNBCTZ+IyrjZmPPiLGRE2sUB07LFYUb9jkSOH+1IHtK8cv55q4=
X-Google-Smtp-Source: AGHT+IHvKn5Wo8IHcOINT/HUYbKgtx8xm+WRKY9mKMVFlmYH8tgoip7UCpXdCzaK6nIc8p6+q6eppGDGt9RHX+eDJtIbBYYylhCP
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1546:b0:3a7:708b:da28 with SMTP id
 e9e14a558f8ab-3c2d5919bcfmr84937415ab.21.1734914365697; Sun, 22 Dec 2024
 16:39:25 -0800 (PST)
Date: Sun, 22 Dec 2024 16:39:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6768b13d.050a0220.3a8527.0001.GAE@google.com>
Subject: [syzbot] [nilfs?] WARNING in nilfs_rename
From: syzbot <syzbot+de6c4b3beb823e112ead@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    aef25be35d23 hexagon: Disable constant extender optimizati..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11cab7e8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6a2b862bf4a5409f
dashboard link: https://syzkaller.appspot.com/bug?extid=de6c4b3beb823e112ead
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-aef25be3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b51d6862d2de/vmlinux-aef25be3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/cdb968bd31a4/bzImage-aef25be3.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+de6c4b3beb823e112ead@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 4096
NILFS (loop0): invalid segment: Checksum error in segment payload
NILFS (loop0): trying rollback from an earlier position
NILFS (loop0): recovery complete
loop0: detected capacity change from 4096 to 64
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5319 at fs/inode.c:407 drop_nlink+0xc4/0x110 fs/inode.c:407
Modules linked in:
CPU: 0 UID: 0 PID: 5319 Comm: syz.0.0 Not tainted 6.13.0-rc3-syzkaller-00044-gaef25be35d23 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:drop_nlink+0xc4/0x110 fs/inode.c:407
Code: bb 70 07 00 00 be 08 00 00 00 e8 c7 37 e7 ff 3e 48 ff 83 70 07 00 00 5b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc e8 5d cc 80 ff 90 <0f> 0b 90 eb 83 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 5c ff ff ff
RSP: 0018:ffffc9000d21f8f0 EFLAGS: 00010283
RAX: ffffffff821ea793 RBX: 1ffff1100a603834 RCX: 0000000000100000
RDX: ffffc9000e60a000 RSI: 0000000000000c56 RDI: 0000000000000c57
RBP: 0000000000000000 R08: ffffffff821ea713 R09: 1ffffffff2032f46
R10: dffffc0000000000 R11: fffffbfff2032f47 R12: ffff88805301c1a0
R13: ffff88804ced1050 R14: ffff88805301c158 R15: dffffc0000000000
FS:  00007f8bc463e6c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8bc396c4c8 CR3: 00000000438e4000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 nilfs_rename+0x7b0/0xb60 fs/nilfs2/namei.c:410
 vfs_rename+0xbdb/0xf00 fs/namei.c:5067
 do_renameat2+0xd94/0x13f0 fs/namei.c:5224
 __do_sys_rename fs/namei.c:5271 [inline]
 __se_sys_rename fs/namei.c:5269 [inline]
 __x64_sys_rename+0x82/0x90 fs/namei.c:5269
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8bc3785d29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8bc463e038 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
RAX: ffffffffffffffda RBX: 00007f8bc3975fa0 RCX: 00007f8bc3785d29
RDX: 0000000000000000 RSI: 0000000020000b80 RDI: 0000000020001640
RBP: 00007f8bc3801a20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f8bc3975fa0 R15: 00007ffe7b8ea018
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
