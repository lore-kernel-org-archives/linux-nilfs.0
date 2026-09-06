Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610673B6C17
	for <linux-nilfs@vger.kernel.org>; Sun,  6 Sep 2026 04:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788668374; cv=none; b=HeM+DfQtFTpgNd4U3wrYh16OLXFCYeX9nXEaUGR5qn69PmBQRMZIURy6vt0deepLDlmpCGaAOsyFu+r/3kEUVYkL+h2m4imSYR97mS/s/ytkOMQzY91uk/aqCi+0XpfWGrX7E1iu+o0NJy+o8vsstmN5N6RmpcnV15HORui5dtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788668374; c=relaxed/simple;
	bh=PGPzWHwAirtV0I+Q8QKmVU0Rq2BRThx0qhC8Ybjwf/U=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=lMaNsXWi+6m+FvVa99yOsemf0IOBHoW4+BYm9pfqyduvrx0hS2U+jJpvoWSxUruJOMVq9xKuER76lG/7FEWto51tZn0JrSrnNFNzLnBuq6GU1IcLc7Eb3Ieqsdg84CUyE+kSmCrROAKiYdZbdOCU1k0+MRwvg+TIF0QgcDPUrbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-4ab260600easo4167022b6e.1
        for <linux-nilfs@vger.kernel.org>; Sat, 05 Sep 2026 21:19:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788668371; x=1789273171;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WJYM/ngiHGbwrinobd7mC8mmqG7Yhx352LAc7Qn4uMI=;
        b=R988GLPBryMdHve3hRbC1+nZUwrYDAtr41WIzOOh9vYV/7qd5xa4KrTwMwdg9GquOF
         1NYzR1tdiqBx3V76fceffob42h4zi4FAV1heUAhJsBysfRAO9nMJ9uf8X8b30fXTZ9PV
         SAyEhu4CNctU4v44mjIqWUi8vHihB3JaJJ470hUK0ZpnUoHrLBO5f/GSrqCHVzpnL0rw
         SUKHJjC4sMKrLWMQ33HAc/HWeWB4zhVi4bo+cxSsMrqi8T2FFI89AnKs0rXROQytA9D3
         fIo/uUwpo34cQa7EuihIsVMcDN6QNxEBmNQ6TzkI9Ofd/7GwLud+9UPPUuUShu0Dt0e9
         f/7A==
X-Forwarded-Encrypted: i=1; AKwUvBwIYesMh6RlyVK8xO/abpgB563ZuTdKyzthc9rXLR9CjldabkTIg6x4CA2QNsKRVlP/EjIASacKOrbHIA==@vger.kernel.org
X-Gm-Message-State: AFuF++mL4LmGuBrDBmvqTw9uI764srd5rsbBlhzNuqGTP806WsZLQ7Kb
	oKGgdI9zZMQ/w6S5PNBP9QTApraOFVjHZ/+7v0sZdCNC8uE+GEVhrxnA7VB1cglmyN7F15W5hrm
	GdX2GhC6IZfYGMYNr7eALBBa/t+59bKrkRxQAKb9pvHJ9fdt3c7aSvtTZoU4=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c9f:b0:6b8:2b7a:674e with SMTP id
 006d021491bc7-6b82b7a6a58mr4413455eaf.5.1788668370586; Sat, 05 Sep 2026
 21:19:30 -0700 (PDT)
Date: Sat, 05 Sep 2026 21:19:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9ce9d2.0a3344eb.391530.0018.GAE@google.com>
Subject: [syzbot] [nilfs?] WARNING in nilfs_copy_dirty_pages
From: syzbot <syzbot+5aea413a54e976f31725@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    89a312991dc6 Merge tag 'cifs-fixes-7.3-rc2' of https://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11a5f349580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e909ffe6b35dddb7
dashboard link: https://syzkaller.appspot.com/bug?extid=5aea413a54e976f31725
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-89a31299.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/114a4744ab8e/vmlinux-89a31299.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c65021627f2c/bzImage-89a31299.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5aea413a54e976f31725@syzkaller.appspotmail.com

NILFS (loop0): mounting fs with errors
------------[ cut here ]------------
inconsistent dirty state
WARNING: fs/nilfs2/page.c:263 at nilfs_copy_dirty_pages+0x49f/0x6a0 fs/nilfs2/page.c:262, CPU#0: syz.0.0/5326
Modules linked in:
CPU: 0 UID: 0 PID: 5326 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:nilfs_copy_dirty_pages+0x49f/0x6a0 fs/nilfs2/page.c:262
Code: c7 ae 60 fe 4d 8b 36 44 89 f6 83 e6 01 31 ff e8 b7 4c ef fd 41 f6 c6 01 0f 85 f1 00 00 00 e8 e8 46 ef fd 48 8d 3d 01 5c aa 0c <67> 48 0f b9 3a e9 67 ff ff ff e8 d2 46 ef fd 48 c7 c7 60 7a 31 8f
RSP: 0018:ffffc9000f4274e0 EFLAGS: 00010287
RAX: ffffffff83d88548 RBX: ffffea00010e0080 RCX: 0000000000100000
RDX: ffffc9000f689000 RSI: 00000000000003d0 RDI: ffffffff9082e150
RBP: ffffc9000f4276f8 R08: ffffea00010e0087 R09: 1ffffd400021c010
R10: dffffc0000000000 R11: fffff9400021c011 R12: dffffc0000000000
R13: ffffea00010e0088 R14: 0000000062000400 R15: 0000000000000000
FS:  00007f95373936c0(0000) GS:ffff88808c2cf000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000000b038 CR3: 0000000040631000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 nilfs_mdt_save_to_shadow_map+0xbb/0x1c0 fs/nilfs2/mdt.c:552
 nilfs_clean_segments+0x28d/0xbe0 fs/nilfs2/segment.c:2546
 nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:938 [inline]
 nilfs_ioctl+0x2619/0x2780 fs/nilfs2/ioctl.c:1368
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f953659e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9537392fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f9536826090 RCX: 00007f953659e159
RDX: 0000200000000040 RSI: 0000000040786e88 RDI: 0000000000000006
RBP: 00007f9536635024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9536826128 R14: 00007f9536826090 R15: 00007fff3c0fc038
 </TASK>
----------------
Code disassembly (best guess), 3 bytes skipped:
   0:	fe 4d 8b             	decb   -0x75(%rbp)
   3:	36 44 89 f6          	ss mov %r14d,%esi
   7:	83 e6 01             	and    $0x1,%esi
   a:	31 ff                	xor    %edi,%edi
   c:	e8 b7 4c ef fd       	call   0xfdef4cc8
  11:	41 f6 c6 01          	test   $0x1,%r14b
  15:	0f 85 f1 00 00 00    	jne    0x10c
  1b:	e8 e8 46 ef fd       	call   0xfdef4708
  20:	48 8d 3d 01 5c aa 0c 	lea    0xcaa5c01(%rip),%rdi        # 0xcaa5c28
* 27:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2c:	e9 67 ff ff ff       	jmp    0xffffff98
  31:	e8 d2 46 ef fd       	call   0xfdef4708
  36:	48 c7 c7 60 7a 31 8f 	mov    $0xffffffff8f317a60,%rdi


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
