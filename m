Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6179A33E7
	for <linux-nilfs@vger.kernel.org>; Wed, 30 Oct 2024 17:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730310328; cv=none; b=oULeuL+PCVPC7f8wPsixEA5b05vuScVgPU724A/Cdrz7q7MUWP6Ytx92LH1jzccciIvWlIziE07ZKvwR1Yr5wa8S4Wkt1JqCrd7eWSBTQrbN4h+PZbJRwxtzxmDnUATqodYnLSjuPOyu+5HbdyRPbKb0+5vc7JTVfuW/5yjfmcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730310328; c=relaxed/simple;
	bh=Zq/og7AFoo14KZf3UG5QWOaDH7TQMemEI6G2OS0FsyU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=l2KwGno4TmWYyk69BWvOz2P1oOkaLoP4nBdaoTaW8h3yqFlNzFeulH/IYMyxc7GYCeJC7CYDOe686W1EAqr8QNjfXY3S2tu+Q2XezQawXQrzlsK1NND259wDVqpW8S/zF6+99kw8IuKoD2QsqZRUKbl2uUPYjbclNUbczCYzkHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a3ba4fcf24so1490505ab.0
        for <linux-nilfs@vger.kernel.org>; Wed, 30 Oct 2024 10:45:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730310325; x=1730915125;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=za1ciVBGbO8OmadBn8zcwu8ODHnRS81vIUIVlw5CgJQ=;
        b=HHXWdxEjTkNVLoTfdRE4yImeAQQYEAqUoAL+6QqWUBZ6KHmMY4gtVVSt5ALV6PWaM/
         SLOFnSgJLDCKyjeCI+3M3JgK4efGltQmN4MrLiMYaIHt5/86RJzgqcvf5zAjYSVF+R7s
         Q62jJD/o6Q1zKUJ460atJI8nHWA83ZrAgxQK6rf44s7Z8ay9gKpUkXv31khcPjC/8VMM
         1tumMjGObKuNmPtSGUJhxWU15DLpVeuHOWQ55aKYUi36k+mrcEwp/GeoSDVSuDUtpnT9
         uYA9jCxSM+WbxuKfBS61rDaG+iEz6mK8jEugL/y34dUs19CITOyBZt3/WytFMNBr1yqu
         3XJg==
X-Forwarded-Encrypted: i=1; AJvYcCWNxMaYvRjEmByjh6VGkQqGHsxHJuwMg3tPffaUqSyKQ2ktlDA5Tew9Iziem5sEEt2eUea0caPdWME/tg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwdMTtH7sP2/EuRqCNDiPC8eFvBXtVG2hYBcnlR2ymaA5fDct17
	YG2SxmKU+1aclJCHIdtd2rqnWOXaE8GCp7WIe/NHHStRkr38WGWiIu1iDXUZIma9v5s/sLke2l+
	/xzXfNAq5CuqPqn17n7oFvahLXQFeyEN47JDZ9ijk6cjYHL0emzzzuuQ=
X-Google-Smtp-Source: AGHT+IGEahBYQ7BzD3UISV4ElGJszR1pZkIWegWM3huF35bJRhUgilgud/4NlvH8ey6+BAl9dknOWuaq+EJWn8HhTeRI3D1ZI3nu
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:174e:b0:3a3:40f0:cb8c with SMTP id
 e9e14a558f8ab-3a61752b08cmr6920635ab.17.1730310325436; Wed, 30 Oct 2024
 10:45:25 -0700 (PDT)
Date: Wed, 30 Oct 2024 10:45:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <672270b5.050a0220.3c8d68.052a.GAE@google.com>
Subject: [syzbot] [nilfs?] general protection fault in touch_buffer
From: syzbot <syzbot+9982fb8d18eba905abe2@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c1e939a21eb1 Merge tag 'cgroup-for-6.12-rc5-fixes' of git:..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15bd4e87980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4aec7739e14231a7
dashboard link: https://syzkaller.appspot.com/bug?extid=9982fb8d18eba905abe2
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17e24630580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1427255f980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-c1e939a2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/79a07b922222/vmlinux-c1e939a2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0a5d98e2bb0d/bzImage-c1e939a2.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/e4ead0d018d8/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9982fb8d18eba905abe2@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 2048
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
CPU: 0 UID: 0 PID: 5503 Comm: syz-executor197 Not tainted 6.12.0-rc5-syzkaller-00044-gc1e939a21eb1 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:perf_trace_block_buffer+0x293/0x490 include/trace/events/block.h:24
Code: 24 18 48 8d 58 30 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 2b 82 62 fd 4c 8b 3b 49 83 c7 34 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 28 84 c0 0f 85 6c 01 00 00 45 8b 3f 49 8d 5c 24 08 48
RSP: 0018:ffffc9000d4ef420 EFLAGS: 00010207
RAX: 0000000000000006 RBX: ffff888049091030 RCX: ffff88801f02c880
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88801fc37928
RBP: ffffc9000d4ef518 R08: ffffffff819e732b R09: 1ffffffff203a095
R10: dffffc0000000000 R11: fffffbfff203a096 R12: ffffe8ffffc33cd0
R13: dffffc0000000000 R14: ffff88801fc378a0 R15: 0000000000000034
FS:  00007f230dad76c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffebac93808 CR3: 0000000043d34000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 trace_block_touch_buffer include/trace/events/block.h:54 [inline]
 touch_buffer+0x1d5/0x240 fs/buffer.c:64
 __nilfs_get_folio_block fs/nilfs2/page.c:42 [inline]
 nilfs_grab_buffer+0x321/0x440 fs/nilfs2/page.c:61
 nilfs_mdt_submit_block+0xdc/0x890 fs/nilfs2/mdt.c:121
 nilfs_mdt_read_block+0xeb/0x430 fs/nilfs2/mdt.c:176
 nilfs_mdt_get_block+0x127/0xb70 fs/nilfs2/mdt.c:251
 nilfs_palloc_get_block+0x181/0x2a0 fs/nilfs2/alloc.c:217
 nilfs_palloc_get_entry_block+0x8e/0xb0 fs/nilfs2/alloc.c:319
 nilfs_ifile_get_inode_block+0xed/0x180 fs/nilfs2/ifile.c:141
 __nilfs_read_inode fs/nilfs2/inode.c:476 [inline]
 nilfs_iget+0x240/0x810 fs/nilfs2/inode.c:581
 nilfs_get_root_dentry+0x28/0x230 fs/nilfs2/super.c:909
 nilfs_fill_super+0x50b/0x720 fs/nilfs2/super.c:1090
 nilfs_get_tree+0x4f9/0x920 fs/nilfs2/super.c:1220
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f230db220da
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f230dad7088 EFLAGS: 00000286 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f230dad70a0 RCX: 00007f230db220da
RDX: 0000000020000000 RSI: 0000000020000040 RDI: 00007f230dad70a0
RBP: 0000000000000004 R08: 00007f230dad70e0 R09: 0000000000000aa1
R10: 0000000003200c00 R11: 0000000000000286 R12: 00007f230dad70e0
R13: 0000000003200c00 R14: 0000000000000003 R15: 0000000000100000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:perf_trace_block_buffer+0x293/0x490 include/trace/events/block.h:24
Code: 24 18 48 8d 58 30 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 2b 82 62 fd 4c 8b 3b 49 83 c7 34 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 28 84 c0 0f 85 6c 01 00 00 45 8b 3f 49 8d 5c 24 08 48
RSP: 0018:ffffc9000d4ef420 EFLAGS: 00010207
RAX: 0000000000000006 RBX: ffff888049091030 RCX: ffff88801f02c880
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88801fc37928
RBP: ffffc9000d4ef518 R08: ffffffff819e732b R09: 1ffffffff203a095
R10: dffffc0000000000 R11: fffffbfff203a096 R12: ffffe8ffffc33cd0
R13: dffffc0000000000 R14: ffff88801fc378a0 R15: 0000000000000034
FS:  00007f230dad76c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffebac93808 CR3: 0000000043d34000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	24 18                	and    $0x18,%al
   2:	48 8d 58 30          	lea    0x30(%rax),%rbx
   6:	48 89 d8             	mov    %rbx,%rax
   9:	48 c1 e8 03          	shr    $0x3,%rax
   d:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)
  12:	74 08                	je     0x1c
  14:	48 89 df             	mov    %rbx,%rdi
  17:	e8 2b 82 62 fd       	call   0xfd628247
  1c:	4c 8b 3b             	mov    (%rbx),%r15
  1f:	49 83 c7 34          	add    $0x34,%r15
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 28       	movzbl (%rax,%r13,1),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	0f 85 6c 01 00 00    	jne    0x1a3
  37:	45 8b 3f             	mov    (%r15),%r15d
  3a:	49 8d 5c 24 08       	lea    0x8(%r12),%rbx
  3f:	48                   	rex.W


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
