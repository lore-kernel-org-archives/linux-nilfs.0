Received: from mail-oa1-f79.google.com (mail-oa1-f79.google.com [209.85.160.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBEE2C21C0
	for <linux-nilfs@vger.kernel.org>; Tue, 17 Mar 2026 03:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773717270; cv=none; b=g4ZUySAWHEmCO8uhb/kLaEmKSqK0dlgDHLdFh4LBd1kAV3jK/3NXuhrlCXuMKsnMmgO3wt3pbcIgivScaqMZjHpV+aekBi0Jsw1kuIbtied6G1eEcYdxTC5MA63NspNRDS35kk3Vo2XHgfgGjIhbFMwad0JZJG5fx/k57DOfRGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773717270; c=relaxed/simple;
	bh=UdT7xSVpmDX9MKhlHbBrVLBW0VxaU/5NnRke/15lj5s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=DhGnuDEzFnhKPz7AEMZJ9DEC539tXZGTYLeWQKbWdwV/QNNUAB4sm2XY4KaCZUfo76AquRhus/4O7XOlYMoKcAkbvI3OwQ7RUm/+Hvg7X+HUSPC3pcUqTSrV9F5ofX8rRRtGTF7LkFnPOtE1QR+4zjcqs8ARYu7hPyTKpXjAE/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f79.google.com with SMTP id 586e51a60fabf-4171fdb5a67so36129753fac.0
        for <linux-nilfs@vger.kernel.org>; Mon, 16 Mar 2026 20:14:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773717267; x=1774322067;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mzb4uhI+WK2CSK9wg7bU4aWICNMWWFMLAMY4qDM1fPU=;
        b=RJgtImIUFmg4Ru8tbBGYqfRy27rWlG0CZcht8RA6twTe87nUXDXEwDdWqPJyPtQjhz
         Y0Pxm7PKoffJV0k7B2ldlKmspqMIaRq7e16AnvrXCLZnZmmIjdtljTLMvDUppiDqrmyM
         nmIMZZn4cf8L+vYP0ok68i75relID26npdcK1m0tR9ML2XvFzAj7/3W7zQF8N7VZkrHk
         6SWfKJiR8sEyAtog25auryjPnpqUrzltx/eCVGsYd3rV6e53ExYwqam5xyrJ9xVKXprc
         LyGCC0wvrRwsNqIWORuMuj5uVW6Fpne/miCgeqACg8u2DwkGUhpkkpBQuJPeOoCb98bw
         iE6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWnZ71bRJujGbmyK8ZUsynWk7UpTBpz/6+zzUtht4wpIvq5zqyhf8wG6C2JIOfw/7QotlwUatrGGk//dg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4PTNEZULYbJpAUIZpb/gjrW41SzK7jyRTSq42W196XwsQIUdq
	k6TaNxNMp24QcaQqM2z/gZF18ppY7rBOcSzNYMO2nUQgEXZW8qv6juZ9qXod2SG9qNMIdha+x8i
	8e+DnPvb3vmnMTP5Yme8rAKaOiPdSVp8NzZ1ComRegXOs0MYL87M8CF3zxcE=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:b583:0:b0:67b:f1c8:eddb with SMTP id
 006d021491bc7-67bf1c8f3f5mr4510939eaf.51.1773717267535; Mon, 16 Mar 2026
 20:14:27 -0700 (PDT)
Date: Mon, 16 Mar 2026 20:14:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b8c713.a00a0220.3b25d1.0029.GAE@google.com>
Subject: [syzbot] [nilfs?] general protection fault in nilfs_mdt_save_to_shadow_map
From: syzbot <syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b84a0ebe421c Add linux-next specific files for 20260313
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=115098ba580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d079c776411aaf59
dashboard link: https://syzkaller.appspot.com/bug?extid=4b4093b1f24ad789bf37
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e844da580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11775d52580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ed9cdd5f6ba1/disk-b84a0ebe.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/856b866a24e9/vmlinux-b84a0ebe.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b1d5ecff5545/bzImage-b84a0ebe.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/66467c518306/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 4096
NILFS (loop0): invalid segment: Checksum error in segment payload
NILFS (loop0): trying rollback from an earlier position
NILFS (loop0): recovery complete
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
CPU: 0 UID: 0 PID: 6003 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
RIP: 0010:nilfs_mdt_save_to_shadow_map+0x141/0x1c0 fs/nilfs2/mdt.c:559
Code: 3f 4c 8d 63 d8 4c 89 e0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 e7 e8 2e 0b 83 fe 4d 8b 24 24 49 83 c4 30 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 e7 e8 10 0b 83 fe 49 8b 34 24 4c 89 ff
RSP: 0018:ffffc90002767708 EFLAGS: 00010206
RAX: 0000000000000006 RBX: ffff8880605d4560 RCX: 0000000000000000
RDX: ffff88802cde8000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffff88802cde8000 R09: 0000000000000003
R10: 0000000000000406 R11: 0000000000000000 R12: 0000000000000030
R13: dffffc0000000000 R14: ffff8880764a6538 R15: ffff8880605d3b18
FS:  000055556403c500(0000) GS:ffff888125436000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30263fff CR3: 0000000074cae000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 nilfs_clean_segments+0x162/0xa50 fs/nilfs2/segment.c:2521
 nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:916 [inline]
 nilfs_ioctl+0x261f/0x2780 fs/nilfs2/ioctl.c:1346
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd2a5f9c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd6d77cd18 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fd2a6215fa0 RCX: 00007fd2a5f9c799
RDX: 0000200000000640 RSI: 0000000040786e88 RDI: 0000000000000004
RBP: 00007fd2a6032c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fd2a6215fac R14: 00007fd2a6215fa0 R15: 00007fd2a6215fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:nilfs_mdt_save_to_shadow_map+0x141/0x1c0 fs/nilfs2/mdt.c:559
Code: 3f 4c 8d 63 d8 4c 89 e0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 e7 e8 2e 0b 83 fe 4d 8b 24 24 49 83 c4 30 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 e7 e8 10 0b 83 fe 49 8b 34 24 4c 89 ff
RSP: 0018:ffffc90002767708 EFLAGS: 00010206
RAX: 0000000000000006 RBX: ffff8880605d4560 RCX: 0000000000000000
RDX: ffff88802cde8000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffff88802cde8000 R09: 0000000000000003
R10: 0000000000000406 R11: 0000000000000000 R12: 0000000000000030
R13: dffffc0000000000 R14: ffff8880764a6538 R15: ffff8880605d3b18
FS:  000055556403c500(0000) GS:ffff888125536000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1536619000 CR3: 0000000074cae000 CR4: 00000000003526f0
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	4c 8d 63 d8          	lea    -0x28(%rbx),%r12
   4:	4c 89 e0             	mov    %r12,%rax
   7:	48 c1 e8 03          	shr    $0x3,%rax
   b:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)
  10:	74 08                	je     0x1a
  12:	4c 89 e7             	mov    %r12,%rdi
  15:	e8 2e 0b 83 fe       	call   0xfe830b48
  1a:	4d 8b 24 24          	mov    (%r12),%r12
  1e:	49 83 c4 30          	add    $0x30,%r12
  22:	4c 89 e0             	mov    %r12,%rax
  25:	48 c1 e8 03          	shr    $0x3,%rax
* 29:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2e:	74 08                	je     0x38
  30:	4c 89 e7             	mov    %r12,%rdi
  33:	e8 10 0b 83 fe       	call   0xfe830b48
  38:	49 8b 34 24          	mov    (%r12),%rsi
  3c:	4c 89 ff             	mov    %r15,%rdi


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
