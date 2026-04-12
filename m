Received: from mail-oi1-f208.google.com (mail-oi1-f208.google.com [209.85.167.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BCE1A9FBC
	for <linux-nilfs@vger.kernel.org>; Sun, 12 Apr 2026 12:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775997151; cv=none; b=FDUME9YZQTC1XuOeVuUilH31eDiw8WuzT69weGGlMmgP7xoeDhDBMHXYvokaJH6FHXwTl5n8pV1u8qgceBoabTOW7F0sVNPiBlLROeIuzbf4rIMYL8VI4Q3/fYBhysGCEwdrkSjV3sz1/31Ec6MaJ29PttdfczLC1anFUfx62q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775997151; c=relaxed/simple;
	bh=F3sZ55wWc7HJA7wMpZa+TDB7nekduQTgRrgq7z0WEiY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=HBCRtuLJ/46bIwdw3Gt5CjQWWS/mt/JfqlI4KIETdFuLJsn4kp37axiZCv8qFWTZnNG+3dy/d0xbH1JC43hM5EKwZeHBbTZjatMjlLpbbOqCEBUR1G9Oo1NszuGD590zpwNwScjCsa/A3jo2SfOMqRfS15iQr2cjGLGWnEOt3Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f208.google.com with SMTP id 5614622812f47-4723af8974fso2310792b6e.3
        for <linux-nilfs@vger.kernel.org>; Sun, 12 Apr 2026 05:32:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775997149; x=1776601949;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fqd15eanNnvvmuUfyG6koD3X6378mDomTR6hIhBh6jE=;
        b=lPNgQKra88+GfJeF7pJQ/x9kxAkerB3VfqqukP6eN7PM2A9QU251nPevMRPKWQDZww
         YQs7PVu7NSwwNwMTrFs08N8Sl7WrcKH6wcld9z/nw0QNFLNGAqgqHGZQ9mHoqVdBLwUh
         38iFokVLV8D++ZQ3CmrXjzv9s7ypWUc7GZGzZ6+v1bcWe9JIQc4kQF2o/Z52W7iN6PvQ
         7e0mi+EdxTpYzolgudZS0kWpDiggCXlTLnpw72uw7BEMiMckcjPFd5Cod8CxBxd9/4jQ
         TRACymi0RjhwDmfjaiBfV47WZHSGaiqhCJRVyyvEmDp2FlgLVLluDf5s2AGsCnHpF1g6
         XDew==
X-Forwarded-Encrypted: i=1; AJvYcCV9YdsqLjTaSnvB9He7NXHmkc07EBIaSNxVB+VZk1cGKi9XljyO0vCa9FBmOxZLeg/aCfa4FXqyXVBLTg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwAx3ZgZO87/2wVRTs21v7UUCfOwySfwbUjRv+0IZ9QB8Tx+bb2
	ysxHQBvIZ+Xv4vv1KMmdI9QnPgx4HmVPzVBIUtl88KBwJDv2MieriitwRVXoghYXLOF6QPbKixa
	Lwbd6Q9ufjNHkuZchRaGOFLF6zMFGCpqs2gF6DWp57LBGEo6lJ0TLw8isYEw=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:201c:b0:68d:9ba5:de2a with SMTP id
 006d021491bc7-68d9ba5e248mr2194443eaf.54.1775997148824; Sun, 12 Apr 2026
 05:32:28 -0700 (PDT)
Date: Sun, 12 Apr 2026 05:32:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69db90dc.a00a0220.475f0.0016.GAE@google.com>
Subject: [syzbot] [nilfs?] kernel BUG in nilfs_copy_dirty_pages
From: syzbot <syzbot+8baf9a79a3ffc6271cb6@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3036cd0d3328 Merge tag 'ata-7.0-final' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12718eba580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d46eab0cfd31c214
dashboard link: https://syzkaller.appspot.com/bug?extid=8baf9a79a3ffc6271cb6
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-3036cd0d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/52b4694b61e7/vmlinux-3036cd0d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3cae4a12f2ba/bzImage-3036cd0d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8baf9a79a3ffc6271cb6@syzkaller.appspotmail.com

NILFS (loop0): mounting fs with errors
Buffer I/O error on dev loop0, logical block 1, lost sync page write
NILFS (loop0): unable to write superblock: err=-5
NILFS_FOLIO_BUG(ffffea00010c5f40): cnt=3 index#=0 flags=0x4fff38000004225 mapping=ffff888055c549c8 ino=3
 BH[0] ffff888046f3b488: cnt=1 block#=42 state=0x1b
 BH[1] ffff888046f3b570: cnt=1 block#=43 state=0x1b
 BH[2] ffff888046f3b658: cnt=1 block#=44 state=0x19
 BH[3] ffff888046f3b740: cnt=0 block#=18446744073709551615 state=0x0
------------[ cut here ]------------
kernel BUG at fs/nilfs2/page.c:262!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5324 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:nilfs_copy_dirty_pages+0x5af/0x610 fs/nilfs2/page.c:262
Code: 41 5d 41 5e 41 5f 5d e9 4f b2 07 08 cc e8 19 d9 18 fe e9 67 ff ff ff e8 ff ca 04 08 e8 0a d9 18 fe 4c 89 e7 e8 f2 f7 ff ff 90 <0f> 0b e8 fa d8 18 fe 4c 89 e7 48 c7 c6 20 85 10 8c e8 bb 24 7b fd
RSP: 0018:ffffc9000cc774e0 EFLAGS: 00010283
RAX: ffffffff83acf054 RBX: 0000000000000000 RCX: 0000000000100000
RDX: ffffc90020001000 RSI: 0000000000001f7b RDI: 0000000000001f7c
RBP: ffffc9000cc776f8 R08: ffffc9000cc77227 R09: 1ffff9200198ee44
R10: dffffc0000000000 R11: fffff5200198ee45 R12: ffffea00010c5f40
R13: 0000000000000001 R14: dffffc0000000000 R15: ffffea00010c5f48
FS:  00007f05fddc96c0(0000) GS:ffff88808ca49000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f05f0fff000 CR3: 0000000040acc000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 nilfs_mdt_save_to_shadow_map+0xbb/0x1c0 fs/nilfs2/mdt.c:554
 nilfs_clean_segments+0x162/0xa50 fs/nilfs2/segment.c:2521
 nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:916 [inline]
 nilfs_ioctl+0x261f/0x2780 fs/nilfs2/ioctl.c:1346
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f05fcf9c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f05fddc8fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f05fd216090 RCX: 00007f05fcf9c819
RDX: 0000200000000640 RSI: 0000000040786e88 RDI: 000000000000000c
RBP: 00007f05fd032c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f05fd216128 R14: 00007f05fd216090 R15: 00007ffedc700128
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:nilfs_copy_dirty_pages+0x5af/0x610 fs/nilfs2/page.c:262
Code: 41 5d 41 5e 41 5f 5d e9 4f b2 07 08 cc e8 19 d9 18 fe e9 67 ff ff ff e8 ff ca 04 08 e8 0a d9 18 fe 4c 89 e7 e8 f2 f7 ff ff 90 <0f> 0b e8 fa d8 18 fe 4c 89 e7 48 c7 c6 20 85 10 8c e8 bb 24 7b fd
RSP: 0018:ffffc9000cc774e0 EFLAGS: 00010283
RAX: ffffffff83acf054 RBX: 0000000000000000 RCX: 0000000000100000
RDX: ffffc90020001000 RSI: 0000000000001f7b RDI: 0000000000001f7c
RBP: ffffc9000cc776f8 R08: ffffc9000cc77227 R09: 1ffff9200198ee44
R10: dffffc0000000000 R11: fffff5200198ee45 R12: ffffea00010c5f40
R13: 0000000000000001 R14: dffffc0000000000 R15: ffffea00010c5f48
FS:  00007f05fddc96c0(0000) GS:ffff88808ca49000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055fd031e8168 CR3: 0000000040acc000 CR4: 0000000000352ef0


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
