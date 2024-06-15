Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567031DFC7
	for <linux-nilfs@vger.kernel.org>; Sat, 15 Jun 2024 16:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718469144; cv=none; b=JNghMMzN+3AOyjDdVMyeU13oR2PIh1LKQEWU0gbdcACokAcdVtXfjl73LetFKs43DsMKRGYNPK7t5BlU5ooeuFLyFDgTYycBbByoQQamzZuyYYGJrxmYKqajmYMz0v6RFUdMD3WWjhcuSx9fOxt2ciygW8dRQ/hQIfpl46RsUPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718469144; c=relaxed/simple;
	bh=w3bdb5f8NpJyzYXhwZKAp+q9I68UQniR5oMzb0zA2SE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=r/WTWP9AWyKCJaOIRW0lT6sTpzPZPj0n+9yGcF/JaEpVZBdQ3FFRLgZUP68gfwt3sZIFoxQiLI5zHKYcRyktsSuQyNIoS6kK0+UNSzKGAIQDBpE0AI3kKDi3KlH3LgLZ76MlJz5AC5dwL4ngbDp68rvPKBucFmocVxJfHQzM+ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-375a26a094dso30006675ab.0
        for <linux-nilfs@vger.kernel.org>; Sat, 15 Jun 2024 09:32:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718469142; x=1719073942;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EQaCIZK4GkVF+JVNWthD0E2q5gmK5QBOjggwhuBrRjM=;
        b=TgirdiBYzGU2UBCNsuHNVBJBnDysvO8b7K9K62/FldrXOo3g/z5a0YcnPtKH7EO7B7
         +NZ6tMTwxT5/rAxwsiRL27BjOLkpAE6g1scRo9j5cCx7vMkeQ3U5fFp6+nKodiPOKW14
         1Xhz/ktLMKGjmhHzKuYlTwyEEazuOFQPr5iVw//lMPkJiGtpq+aAy1tmmpmb/NY0mEBq
         VZkkXYxe0eKiPtq+coNzZFVtUxenCsJ31lCWw0Kg2qoj4qwKUkLukdeyDFnfs8mpjcMV
         /fggZBZYoV1ZuI3E6Qok43Gn/zjFSDt6hcSdbk0ZFJNF9hsQ6WcJJlJWkK9UUqLdoT0Y
         VUvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdkEwh+J5p0X8Ge8yIv3Pw3FRp5kp1DPYVKRbqNmB3Vv+VUAwWND9IPdzxEbtMB1kJ7ZC/2zmo+21hVQAd9zCflv+1u1ZuG8rqyGA=
X-Gm-Message-State: AOJu0Yxo5bU4wknPAw5o9fGuuyv2+893U4DWQYjoX+jIrpr8ZyTXQkGi
	rF3GZqO2VvXT2Yu4b40VdG9uerjnZ0RaCYIxEjhhhkZINJWocchmp+euV4Tzek0RGTmodoLkb0V
	0PennO9sic6ahWmTba9rWnVcjAUyy8zkSkuu3E0L+ZVzCgxn0LcyQAjo=
X-Google-Smtp-Source: AGHT+IGJwWwyY/FPWTkxgWUdRxJUCdwApcOzTEVArEh1VNXdC/0EHHCWhfShh+f5sCDjOcOl4zVE5w1jcYluqvgLoeHZuR1OaZSl
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:180d:b0:375:da97:f21a with SMTP id
 e9e14a558f8ab-375e0e7af51mr4059675ab.3.1718469142470; Sat, 15 Jun 2024
 09:32:22 -0700 (PDT)
Date: Sat, 15 Jun 2024 09:32:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cb6fca061af0462e@google.com>
Subject: [syzbot] [nilfs?] kernel BUG in nilfs_btnode_create_block (2)
From: syzbot <syzbot+89cc4f2324ed37988b60@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    83a7eefedc9b Linux 6.10-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13ab3d96980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c79815c08cc14227
dashboard link: https://syzkaller.appspot.com/bug?extid=89cc4f2324ed37988b60
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b45273014a8f/disk-83a7eefe.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/94cd5708292e/vmlinux-83a7eefe.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a89698812e8b/bzImage-83a7eefe.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+89cc4f2324ed37988b60@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/nilfs2/btnode.c:59!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 PID: 7600 Comm: segctord Not tainted 6.10.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:nilfs_btnode_create_block+0x3dc/0x400 fs/nilfs2/btnode.c:59
Code: 8e 48 89 da e8 85 25 73 01 e9 a7 fd ff ff e8 cb d2 28 fe eb 0c e8 c4 d2 28 fe eb 05 e8 bd d2 28 fe 4c 89 ef e8 35 00 00 00 90 <0f> 0b e8 ad d2 28 fe 4c 89 f7 48 c7 c6 40 f2 06 8c e8 8e c0 6f fe
RSP: 0000:ffffc90004f1f270 EFLAGS: 00010202
RAX: ffffffff821b2801 RBX: 0000000000000010 RCX: ffffffff821b2819
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff88807746f5d0
RBP: 0000000000001cc3 R08: ffff88807746f5d3 R09: 1ffff1100ee8deba
R10: dffffc0000000000 R11: ffffed100ee8debb R12: dffffc0000000000
R13: ffff88807746f570 R14: 1ffff1100ee8deae R15: ffff88805e399490
FS:  0000000000000000(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdd25186000 CR3: 000000007a728000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 nilfs_btnode_prepare_change_key+0x26d/0x300 fs/nilfs2/btnode.c:219
 nilfs_btree_prepare_update_v+0x397/0x450 fs/nilfs2/btree.c:1942
 nilfs_btree_prepare_propagate_v fs/nilfs2/btree.c:2001 [inline]
 nilfs_btree_propagate_v fs/nilfs2/btree.c:2054 [inline]
 nilfs_btree_propagate+0x3bf/0xdf0 fs/nilfs2/btree.c:2111
 nilfs_bmap_propagate+0x75/0x120 fs/nilfs2/bmap.c:345
 nilfs_segctor_apply_buffers+0x184/0x340 fs/nilfs2/segment.c:1006
 nilfs_segctor_scan_file+0x810/0xa50 fs/nilfs2/segment.c:1066
 nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1164 [inline]
 nilfs_segctor_collect fs/nilfs2/segment.c:1492 [inline]
 nilfs_segctor_do_construct+0x1c43/0x6b50 fs/nilfs2/segment.c:2040
 nilfs_segctor_construct+0x181/0x6b0 fs/nilfs2/segment.c:2408
 nilfs_segctor_thread_construct fs/nilfs2/segment.c:2516 [inline]
 nilfs_segctor_thread+0x55c/0x11b0 fs/nilfs2/segment.c:2601
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:nilfs_btnode_create_block+0x3dc/0x400 fs/nilfs2/btnode.c:59
Code: 8e 48 89 da e8 85 25 73 01 e9


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
