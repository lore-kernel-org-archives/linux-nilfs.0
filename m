Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082E6346AFD
	for <linux-nilfs@vger.kernel.org>; Thu, 19 Mar 2026 07:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773904897; cv=none; b=GtWNV79n5WuEmNUEsfCMF7ZudQwO6MASglZnN5PLgDwvUPvSuQ+HrN6PRcE6r7jNOJjmpSren5zTwS6xwfSQ8g2O6G+keukikGkbC/ZfzhCwTEbPt4hZ/J7v4afL+hFuvySLKD5bJuk7pdMzuaeyeLTuHM0g+nFbjME18IHPJ8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773904897; c=relaxed/simple;
	bh=8seua+4qj/e0rmygFKzK6UtLvFZjOqL7B76gpKYERkQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=RQ4RoebW7GhGVfglDIOgxkcyfooK1EpjTwQimejxZjq/P0D4sE9zAETuDB+HwBtNa9X82cOxK+SQGtJAOA3TLJwFM6PvMpeVkHnIxwWRvjiP/r/LN5rthehiZ+4R5GVv7ucUYo306/8utLzOJUY++fnoYUexs1Ug/gyV68GF4X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-67bb2273d42so11129380eaf.0
        for <linux-nilfs@vger.kernel.org>; Thu, 19 Mar 2026 00:21:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773904895; x=1774509695;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ufulecwshlguFde1LfsWzzbGCArOQYfbgkkoEJK2Tzc=;
        b=KkA3OxouTcEYIgLf/qPRuv9AQnr8Id6gnCXSz7DLzSr2dV6fLV/Zi5ECcqbvWYPANu
         K1A10D8F392Re3YPXx5sdommUPjQqxPLD84UOl0Ho1YqDIxMJmj805e7qwd9n5LHzAjH
         79RQwHBEG1uAceDK9WoTbZmAQ/ZQ1NKuTXVhjxh9zvjRUC5ieR/L5Tb03v6FI59/m2dt
         CfBg87J367/TiMc/4yZ7/1iXJXoPYrVZz1GXlkUGo6+fcbmgBjnwATwbCK6ZAFFikT9j
         /N5HMUoNPg/uMidh6DzYnDe7C77ECjcrhooZSZhtx4jXxRTJStGu4jbfIafgr+DmMObA
         AKoA==
X-Forwarded-Encrypted: i=1; AJvYcCVeLTNWf5CzSxgNofxsFpiuMvKBoa1Dxor751Qb89eG8ZAhuFV7OrFtDsDXs7bAOJSMG0+KHDSrOgkZnw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzpQW6yPvMTQ/APyBK4jHDdewVs3LkDwo2Oum07Y5ujW2SL7EUf
	rdrc/NPwiXUzoxnOamv7Y2GLAvb+BAAoXMjWtnR3sCi2W0Ye+YTc67SdatP8Cje4jAoQz/SUBpe
	aemmMf4l/S6m1xakc4HZoWk3lIME2ZUc1+SeGM3hzt0sAcSLGXXkFpkYZO4o=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:80c5:b0:67b:af3e:b1de with SMTP id
 006d021491bc7-67c0db3b7cfmr4420192eaf.69.1773904895177; Thu, 19 Mar 2026
 00:21:35 -0700 (PDT)
Date: Thu, 19 Mar 2026 00:21:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69bba3ff.050a0220.227207.0031.GAE@google.com>
Subject: [syzbot] [nilfs?] WARNING in nilfs_btree_mark
From: syzbot <syzbot+98a040252119df0506f8@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f0caa1d49cc0 Merge tag 'hid-for-linus-2026031701' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12d868da580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d46eab0cfd31c214
dashboard link: https://syzkaller.appspot.com/bug?extid=98a040252119df0506f8
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1452974a580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f0caa1d4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/790e2ce16030/vmlinux-f0caa1d4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/dcb6a5644f0c/bzImage-f0caa1d4.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/93d9925377df/mount_1.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+98a040252119df0506f8@syzkaller.appspotmail.com

------------[ cut here ]------------
ret == -ENOENT
WARNING: fs/nilfs2/btree.c:2356 at nilfs_btree_mark+0x1c9/0x210 fs/nilfs2/btree.c:2356, CPU#0: syz.0.17/5469
Modules linked in:
CPU: 0 UID: 0 PID: 5469 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:nilfs_btree_mark+0x1c9/0x210 fs/nilfs2/btree.c:2356
Code: 48 8b 05 4a f8 6e 0f 48 3b 44 24 10 75 26 89 e8 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 88 f8 17 fe 90 <0f> 0b 90 bd fe ff ff ff eb c3 e8 58 99 02 08 44 89 f1 80 e1 07 80
RSP: 0018:ffffc90003d375b0 EFLAGS: 00010293
RAX: ffffffff83adb7f8 RBX: ffff888042014000 RCX: ffff888040904980
RDX: 0000000000000000 RSI: 00000000fffffffe RDI: 00000000fffffffe
RBP: 00000000fffffffe R08: 000000000000000e R09: 0000000000000000
R10: ffff888042014678 R11: ffffed10084028d3 R12: ffff8880464286a0
R13: dffffc0000000000 R14: ffff888046428668 R15: 0000000000000009
FS:  00007f5bd0f206c0(0000) GS:ffff88808ca55000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fab839e8000 CR3: 0000000033512000 CR4: 0000000000352ef0
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
RIP: 0033:0x7f5bcff9c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5bd0f20028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f5bd0215fa0 RCX: 00007f5bcff9c799
RDX: 0000200000000640 RSI: 0000000040786e88 RDI: 0000000000000004
RBP: 00007f5bd0032c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5bd0216038 R14: 00007f5bd0215fa0 R15: 00007ffdf65e5358
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
