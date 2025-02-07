Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A271A3162
	for <linux-nilfs@vger.kernel.org>; Fri,  7 Feb 2025 07:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738913307; cv=none; b=nsY/9F9po05WqDNG4ox3eOPINudJ8nS2cgYfPdv1m1b5m6HX0xKhGDeEiL5Yjta/IF0CBiJy2U8qofuF9GwSNDLaL2ichFjsqbldEHnqkJbXi6ijTm2H7vN9D85bii1Q2D+DJCjTI+TePbTzxkoS6MacFCY+BNTWB+q3+6Ye1ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738913307; c=relaxed/simple;
	bh=PuFYJXnwk4/BXSpalbP5VBzjOGVv/QoW3u+WP5yzF90=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Ka9Zc1i+7j+izoOcBz9XTDiOvlTWMx2ZezioS7fGjqGyug0cg6td+vWdrE38PhpcdZNlTjar+ufytXSKTUKcNUq9QrltlbyeRt9RnKeBVDoggNZ/U7jQoya/OCIJaH4jIozR5jytLF2ntZfkxbJ1nnT3UHTbUjhNnp6G++ZNk5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d04b390e9cso12320525ab.3
        for <linux-nilfs@vger.kernel.org>; Thu, 06 Feb 2025 23:28:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738913304; x=1739518104;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ksq+vmV4D99f2reoufSLwNhXWJqZYH64AqJSgNxiiM4=;
        b=QHaFIM/1A3XOgMRlBPyNsjB6IwZmwNKPnqd2rUDY17i2ap1I/QIjVDsZuD164mQJT0
         ke47KD3J8bw/Nx3ZUNLMejtbdamhrmMqJam0TMx9lMxyG3vdk6mRTegs1DAQieZ0B4yY
         pYdWpXroNzQdWvtoMgMDtylNDy6pZVAR2CMRMy20D6DaGXqo++3QnLKBxj4Bem5JYDC9
         y4Z1C+BoSXCyJN202V4IajkLs3IwG9M7bG5ZzleiE8VVOrQ7CJWu1tcmQhvQ/CtZECsf
         /7cg+5wHccx4KrcwOxlnqhZK6viXxFrJMTfWjAj7bKi0rgwyhjYBhbSuUATwPL2qW8Uc
         tiDA==
X-Forwarded-Encrypted: i=1; AJvYcCUYIMjAPqxXZH/s/vq4oE3maQ8RNtQdGtMcddq1JVs89Qr/PW5X0Sqj2+olHcLqXf+0v0hPbXOMQ2NF0g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwkGSHh8RFlRnrqyKgtOF82CXyxqQaYXJ7sZctpXh3VpCLVvlTS
	OJzYnW+3Vw3rKQhAN1hA9lWs+yWSfLkSfwYrGs3qsqUBgK6Git7RPISh/SY30G4fODdIuGw8RR2
	0WgGxMuu/WEkJtI+cC/+FtuGRZlmU3pnMWSJWSonQt7q19H+jfm7Pd/w=
X-Google-Smtp-Source: AGHT+IFKuxQyRDqSTVSzxp/M3gY501azWw9ihUH26cCP0PiGyErXyzrZpYEuTk0lOO/9Gi51yQORwCbOd1y2RC4Gs2Vv/VJ7GHaA
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2163:b0:3d0:2331:f809 with SMTP id
 e9e14a558f8ab-3d13dcde9e4mr18978195ab.2.1738913304700; Thu, 06 Feb 2025
 23:28:24 -0800 (PST)
Date: Thu, 06 Feb 2025 23:28:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a5b618.050a0220.2b1e6.0018.GAE@google.com>
Subject: [syzbot] [nilfs?] WARNING in nilfs_segctor_abort_construction (2)
From: syzbot <syzbot+86e5da039cef3ad11c6e@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    69e858e0b8b2 Merge tag 'uml-for-linus-6.14-rc1' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=127db5f8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d033b14aeef39158
dashboard link: https://syzkaller.appspot.com/bug?extid=86e5da039cef3ad11c6e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0c358838d66a/disk-69e858e0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/29a6852a21ee/vmlinux-69e858e0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fb214c6e7c43/bzImage-69e858e0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+86e5da039cef3ad11c6e@syzkaller.appspotmail.com

segctord: attempt to access beyond end of device
loop4: rw=0, sector=80, nr_sectors = 2 limit=0
NILFS (loop4): I/O error reading meta-data file (ino=5, block-offset=0)
------------[ cut here ]------------
WARNING: CPU: 1 PID: 6772 at fs/nilfs2/segment.c:1507 nilfs_cancel_segusage fs/nilfs2/segment.c:1507 [inline]
WARNING: CPU: 1 PID: 6772 at fs/nilfs2/segment.c:1507 nilfs_segctor_abort_construction+0xe51/0xec0 fs/nilfs2/segment.c:1873
Modules linked in:
CPU: 1 UID: 0 PID: 6772 Comm: segctord Not tainted 6.13.0-syzkaller-09760-g69e858e0b8b2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
RIP: 0010:nilfs_cancel_segusage fs/nilfs2/segment.c:1507 [inline]
RIP: 0010:nilfs_segctor_abort_construction+0xe51/0xec0 fs/nilfs2/segment.c:1873
Code: 8b 04 25 28 00 00 00 48 3b 84 24 a0 00 00 00 75 74 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d e9 d0 38 6d fd e8 80 64 1c fe 90 <0f> 0b 90 e9 ea f9 ff ff e8 72 64 1c fe 90 0f 0b 90 e9 93 fb ff ff
RSP: 0018:ffffc90003adf5e0 EFLAGS: 00010293
RAX: ffffffff83a30840 RBX: 00000000fffffffb RCX: ffff888025700000
RDX: 0000000000000000 RSI: 00000000fffffffb RDI: 0000000000000000
RBP: ffffc90003adf6d0 R08: ffffffff83a30226 R09: 1ffff1100457f180
R10: dffffc0000000000 R11: ffffed100457f181 R12: 000000000000002f
R13: 0000000000000000 R14: ffff888057ef0008 R15: ffff888055c9a138
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f579116b440 CR3: 000000000e738000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 nilfs_segctor_do_construct+0x6615/0x6ea0 fs/nilfs2/segment.c:2186
 nilfs_segctor_construct+0x181/0x6b0 fs/nilfs2/segment.c:2478
 nilfs_segctor_thread_construct fs/nilfs2/segment.c:2586 [inline]
 nilfs_segctor_thread+0x69e/0xe80 fs/nilfs2/segment.c:2700
 kthread+0x7ab/0x920 kernel/kthread.c:464
 ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
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
