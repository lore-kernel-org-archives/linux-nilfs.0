Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C984303A32
	for <linux-nilfs@vger.kernel.org>; Sat, 28 Mar 2026 20:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774730365; cv=none; b=SSvwPyYQSLZnRMC0EJO1q+EnoG/Rw59w3BoUBayUPj8NOs1B0GrJMk0aLFAdVPKyoN8EI1JK2hxnMCQxGzGHJonPa5CnKEMBswGfUsMthSQyboECL0wfaDc+b2KmY47wzZIW3HUiZD9h53SBSUNC7NrGtHmQdUeYgd9/l7MFhXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774730365; c=relaxed/simple;
	bh=LJW51NrdGmu/+r33vJt16XprBCiqzBAkS9b+U8rQYgU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=WmnJ1RAyThAJe9/UHoKnydE0SYiWrVA5XCgxQO+++jS06VKClLJtjQJvnzBYv5VK2bbLoDTd3nQZhcuU2pGFHDc2IudqdPU+cnOLawsVA2IIXPIbfMreP26GzLvzLXxyZV5XGkTOyUhn+93IxsWvwS2lFcFVU+LhLY9vy9hBMBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-67dfa1ab0b1so12403433eaf.0
        for <linux-nilfs@vger.kernel.org>; Sat, 28 Mar 2026 13:39:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774730362; x=1775335162;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kPa2nNP441GZ+WF5R49SQJsy0SEoXnoBKot/rPKosck=;
        b=HbfDg8ozGfcVMGIzGjFkKEEczRKA5XC8aGTnctKBhsLK/20Iqde28V/EV4ogJl3/kw
         37eBarU2//xyqxDuykJ+AZGIObVP8sn8MNHsM2pQNwoIiczSItK46N+i0aIcJje2F8j6
         x/FCFh7vkynP4vywkqmBWo2GZ1Ik5DfxuVHREI6B1sFafIEQy2y0TVM5wLb0z2nn2GmL
         2H1vZorzVxF6MoJjDjJyYIC907kqo2l//HuW4XVdJGMpQE0K2Pqnk5/8oAw9aVLb+6UI
         1d2jPP2E0dWFTaV9Bx7FY5Hgd3l+BB0NhlvxhmnBHJkIdRVRP0OfpaHPSgx5ztQHMOoS
         8oHA==
X-Forwarded-Encrypted: i=1; AJvYcCUKvbjn+yJ1WApnj3lxm9bf77kKd1Yp/pO9b0UtDgL9SpIy9yfewKVhci0JDFULMMvXi6bxoEkokQAgug==@vger.kernel.org
X-Gm-Message-State: AOJu0YxsvSzVjmlhGL+9aGu38D+071gzXYcfEKaMHaXrDlqsRf+6EOM/
	afj56T669zVJba26a2kr5yjz1+rblbYHrS+5suuGaKtvF8+DWBqF3BvroiZXy6HNuOwXK+yqehy
	DP2vAnwwC7wz7uWDX61Eg4FbgBjChb5jfzGn6NVTCFXMpDQZmXGYGRfuiSEE=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1a0b:b0:67e:160c:36ba with SMTP id
 006d021491bc7-67e18713836mr3705710eaf.48.1774730362585; Sat, 28 Mar 2026
 13:39:22 -0700 (PDT)
Date: Sat, 28 Mar 2026 13:39:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69c83c7a.050a0220.183828.0007.GAE@google.com>
Subject: [syzbot] [nilfs?] WARNING in nilfs_rmdir (2)
From: syzbot <syzbot+b41999640fad20a4dd44@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e3c33bc767b5 Merge tag 'mm-hotfixes-stable-2026-03-23-17-5..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1327aa06580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=45cb3c58fd963c27
dashboard link: https://syzkaller.appspot.com/bug?extid=b41999640fad20a4dd44
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/95a5c5b7cf3f/disk-e3c33bc7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9813b6b6d1c8/vmlinux-e3c33bc7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/711f8da725b2/bzImage-e3c33bc7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b41999640fad20a4dd44@syzkaller.appspotmail.com

NILFS (loop2): nilfs_palloc_commit_free_entry (ino=6): entry number 14 already freed
------------[ cut here ]------------
inode->i_nlink == 0
WARNING: fs/inode.c:418 at drop_nlink+0xc5/0x110 fs/inode.c:418, CPU#0: syz-executor/12719
Modules linked in:
CPU: 0 UID: 0 PID: 12719 Comm: syz-executor Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
RIP: 0010:drop_nlink+0xc5/0x110 fs/inode.c:418
Code: c0 08 00 00 be 08 00 00 00 e8 e7 e1 ea ff f0 48 ff 83 c0 08 00 00 5b 41 5c 41 5e 41 5f 5d e9 c2 5b e7 08 cc e8 6c c1 84 ff 90 <0f> 0b 90 eb 81 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 5b ff ff ff
RSP: 0018:ffffc90005b6fc50 EFLAGS: 00010293
RAX: ffffffff823fb6e4 RBX: ffff888062dfd2a8 RCX: ffff888040885b80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed100573ed19 R12: 1ffff1100c5bfa5e
R13: ffff888062dfd2a8 R14: ffff888062dfd2f0 R15: dffffc0000000000
FS:  000055557bc92500(0000) GS:ffff888126339000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2f323ffc CR3: 00000000533a4000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 nilfs_rmdir+0x1b4/0x250 fs/nilfs2/namei.c:347
 vfs_rmdir+0x400/0x6f0 fs/namei.c:5338
 filename_rmdir+0x292/0x520 fs/namei.c:5393
 __do_sys_unlinkat fs/namei.c:5568 [inline]
 __se_sys_unlinkat+0x71/0x1a0 fs/namei.c:5561
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3a7afeb8b7
Code: 77 01 c3 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 b8 07 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdf64d6368 EFLAGS: 00000207 ORIG_RAX: 0000000000000107
RAX: ffffffffffffffda RBX: 0000000000000065 RCX: 00007f3a7afeb8b7
RDX: 0000000000000200 RSI: 00007ffdf64d7510 RDI: 00000000ffffff9c
RBP: 00007f3a7b082050 R08: 0000000000008560 R09: 00000000ffffffff
R10: 0000000000000100 R11: 0000000000000207 R12: 00007ffdf64d7510
R13: 00007f3a7b082050 R14: 0000000000085d50 R15: 00007ffdf64d96d0
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
