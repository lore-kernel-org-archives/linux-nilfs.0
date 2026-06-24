Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E053CBE80
	for <linux-nilfs@vger.kernel.org>; Wed, 24 Jun 2026 19:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782331165; cv=none; b=IomGOsiwGuSBwSfmWS+zLRwTtFiiClm31ehLDXvjU3irxbE0WJGbZhrICsjPnzpiIVYM+ohv9HKM74LTvSeN46Z+w40NvUCAE79CZZoCSc+bazzcfuD88XxP/mD6A9aP4QB1+x1PinUpi3fSrj/bo3kMJLfp2noRt/QMwZRAGuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782331165; c=relaxed/simple;
	bh=m7TyPrZCU7XFixGWHFjaRE2q4ge4QIBm0i7WwlTp5Ps=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=RI1gbpOnrIRsBIfhNFLPnQb6fPyBhIhZFQl7VTYIDflr0kadzHHPFYWBeYnPKp2RZCUQ7CfowC6AUOoRcMWhPfnmJaTHPxQbdRkzUJD5dJyu6xY9DeWOT1MO4CRxCshRR0/emKb8SIYRhR9wG4mUWoiFoHzaOkZwzw0RKpydsRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-6a0e15d07e6so979512eaf.1
        for <linux-nilfs@vger.kernel.org>; Wed, 24 Jun 2026 12:59:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782331163; x=1782935963;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5/m6Cbxwc4/lM1kyE/wM2cFeTGwq56pJiOJnDNGDZd8=;
        b=bY50A48/BIvPyVOvrXeYh8t5wVfkkGs0/i6wjBe/6lB+bGEMUoy5T6Y/1gVbfOeFDQ
         Ijc8iNYifNdT46oq0/cRPd77jHKPXF9wcvEAXZ2K1rqXalruYFmLET2cXEJge+eh68gr
         lYgN8tIoB7zg6HcnCc9NmIL4OXdsT8b/9o8uxiuTsIBxD8w+OGxc/lr7D2ym2QrD2rcc
         ktBbdlmFls9/DQkn1XVhSAe/yk5ns61zzxh+hZj5WBqOrsjUSB+rUK2aaII6Liuev1Dy
         ASl0E5kXHNRxXAxMwn1r3Buitd+yrXNydZT/BgcJQq9sQMHOLBxgX9Cdw5Sz+cWPHDZp
         vtWg==
X-Forwarded-Encrypted: i=1; AFNElJ9k5r9SoNSSIiZeyEmlGfOAlNlyly6P7XelLXpgiBWzESlBMC28gvmCWGNr2L253T3zRK6P2vHn2xTqvQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YybOA99lHXIbh7xGfFzI6ikp0tNRNXIXGh8M2+wzmu8NHYd0OGc
	goq8Iail2cEFw8o0kIwHXGV8O4VSsxhvvpGQMoDmNs+UQ/LS1jIsUVGNE79vqjEQp81eeRrAJjW
	KZ3y2whG4ehXYh+U6QKfulxd5GatB8VC7NooVEfSds8IXw2hwK+uWhnDjCk4=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2008:b0:69e:86af:a8a9 with SMTP id
 006d021491bc7-6a122eacea5mr3282114eaf.3.1782331163190; Wed, 24 Jun 2026
 12:59:23 -0700 (PDT)
Date: Wed, 24 Jun 2026 12:59:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a3c371b.80e5668d.5d0ef.0000.GAE@google.com>
Subject: [syzbot] [nilfs?] BUG: corrupted list in nilfs_lookup_dirty_data_buffers
From: syzbot <syzbot+c37bed40868932d790e9@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f31c00c377cc Merge tag 'platform-drivers-x86-v7.2-1' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10f687f2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=31a51e0acb798311
dashboard link: https://syzkaller.appspot.com/bug?extid=c37bed40868932d790e9
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10376ba1580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c42341580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f31c00c3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/65376d2aeca1/vmlinux-f31c00c3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/dba2c41e8c30/bzImage-f31c00c3.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/12e3220d6326/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c37bed40868932d790e9@syzkaller.appspotmail.com

list_add double add: new=ffff888043d25c80, prev=ffff888043d25c80, next=ffffc900034ff1c0.
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:37!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5513 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__list_add_valid_or_report+0xa5/0x130 lib/list_debug.c:35
Code: 74 12 b0 01 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 48 c7 c7 60 9f 2a 8c 4c 89 fe 4c 89 f2 48 89 d9 e8 7c 57 63 fc 90 <0f> 0b 48 c7 c7 40 9d 2a 8c e8 6d 57 63 fc 90 0f 0b 48 c7 c7 00 9e
RSP: 0018:ffffc900034fed48 EFLAGS: 00010246
RAX: 0000000000000058 RBX: ffffc900034ff1c0 RCX: 74a71100abd37800
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: 1ffff9200069fe39 R08: ffff88801fc24713 R09: 1ffff11003f848e2
R10: dffffc0000000000 R11: ffffed1003f848e3 R12: 1ffff110087a4b90
R13: dffffc0000000000 R14: ffff888043d25c80 R15: ffff888043d25c80
FS:  00005555919bc500(0000) GS:ffff88808c821000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4434df8eb8 CR3: 000000001ab95000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __list_add_valid include/linux/list.h:96 [inline]
 __list_add include/linux/list.h:158 [inline]
 list_add_tail include/linux/list.h:191 [inline]
 nilfs_lookup_dirty_data_buffers+0x468/0x7b0 fs/nilfs2/segment.c:745
 nilfs_segctor_scan_file+0x26a/0xf70 fs/nilfs2/segment.c:1046
 nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1198 [inline]
 nilfs_segctor_collect fs/nilfs2/segment.c:1547 [inline]
 nilfs_segctor_do_construct+0x1c8d/0x7bb0 fs/nilfs2/segment.c:2122
 nilfs_segctor_construct+0x170/0x690 fs/nilfs2/segment.c:2462
 nilfs_clean_segments+0x4ec/0xbb0 fs/nilfs2/segment.c:2557
 nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:922 [inline]
 nilfs_ioctl+0x2619/0x2780 fs/nilfs2/ioctl.c:1352
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f620d99ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffb7f16fb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f620dc15fa0 RCX: 00007f620d99ce59
RDX: 0000200000000040 RSI: 0000000040786e88 RDI: 0000000000000004
RBP: 00007f620da32e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f620dc15fac R14: 00007f620dc15fa0 R15: 00007f620dc15fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_add_valid_or_report+0xa5/0x130 lib/list_debug.c:35
Code: 74 12 b0 01 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 48 c7 c7 60 9f 2a 8c 4c 89 fe 4c 89 f2 48 89 d9 e8 7c 57 63 fc 90 <0f> 0b 48 c7 c7 40 9d 2a 8c e8 6d 57 63 fc 90 0f 0b 48 c7 c7 00 9e
RSP: 0018:ffffc900034fed48 EFLAGS: 00010246
RAX: 0000000000000058 RBX: ffffc900034ff1c0 RCX: 74a71100abd37800
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: 1ffff9200069fe39 R08: ffff88801fc24713 R09: 1ffff11003f848e2
R10: dffffc0000000000 R11: ffffed1003f848e3 R12: 1ffff110087a4b90
R13: dffffc0000000000 R14: ffff888043d25c80 R15: ffff888043d25c80
FS:  00005555919bc500(0000) GS:ffff88808c821000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe0c8f2f440 CR3: 000000001ab95000 CR4: 0000000000352ef0


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
