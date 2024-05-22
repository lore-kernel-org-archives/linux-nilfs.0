Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD131E4A2
	for <linux-nilfs@vger.kernel.org>; Wed, 22 May 2024 02:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346534; cv=none; b=Y4iBYqBatJFBG5SBLorWqOwWlvNZVZgl0r0f2XpNAfaY5cDrYLPmDI7v+k50fgbwzgNje0ju3f2gb5RlLZkBDxkXdHWxE9RUxDQ/5Pu55OT4GNnnIHD1GRc+GkfQAmJ8kRffzOw94KLkpVqSQUtcbQQgvClcmxfhUxahqCqV+mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346534; c=relaxed/simple;
	bh=Fmq4cfmTdTx1iUl4iK3aruK2b4BklXedhpLLjn/V3gg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ifo9Yfc3fpPq5NSrVfN9ALMY9QUZrE6Cd0yOOuAoyzBvNoChsck25kfgUGqc/fyq0sZvCTxacCcaSHR2uHrwnDomiNrU9Zrzf3X2bTx+eN+VQxQ9hcNbh31UEG5mp0Uzoc2zp0tJldPOKKMwnDjKku0RVf4fkaWbRt4IapTFyg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7e1ea8608afso1041686539f.2
        for <linux-nilfs@vger.kernel.org>; Tue, 21 May 2024 19:55:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716346532; x=1716951332;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+Ry/8RZHi+cirGva08ioXvtiJ6dGry8jsjjnUdJmvrA=;
        b=djEuNedHmcruoXrwzrzmZHqu4eU89JZrQZ/isHN09Xh251pgkkzGY8r/1SEez0aB0y
         Ks3MS+p/FIZyRtYZpXEDVOuWfV87iSW22yc6GbsCOwlsmsl8r7JdqQOnLYS6svPpL5Qj
         aqxr9zz0qW2xmBtnILRv9qdYFj2YAi3XzlRhyCjXk+q27FOhiSx5W4yfVWVHAbzLdq1t
         HmqGjyoGRWN0053QVrQKqptb10o3gjwhPs+ljxIdx03Gs0NgYIsKqBTTsIjKC9USfLC0
         37YIMZzqwj0fHdj4sR/ITKDt5umMV0iXhwIl4hwjFty842vz3s5X+UZUaXPFw+cQSexM
         gKWw==
X-Forwarded-Encrypted: i=1; AJvYcCWxc1A9LDlDNHu3vJmveKc7nsN6pe0cEhtuA1TvDL4pwFQifmYKyopt0W52cTyJD5wP/In0u6e+cGR2Y16XrJH05k6fCzL93EDOORQ=
X-Gm-Message-State: AOJu0Yyw8bT2P6b90gxmlztNQcP7aBsaUGPyv8zAeJis07yIj6ejBuL4
	aQblChyiFuGHsmVrtaigRalxHuXEbq+avi1Acw2Bz3w8XtgJA7SNUhZIDNBG2fbMwlE+GT7QJcg
	tqx4AXaJnBubqlcF7LjtmQ4c/PNWZQNkn25FdHOcXyei9umaBLelL+n0=
X-Google-Smtp-Source: AGHT+IE8dA3Y436YSv7w4/IDzm52Ag7PNo4+j3PLSkNAq1wZDNdZDmA0MipCEBB/rcPn+CkVUest9bxdsZlwz9iQbnABinemAg3b
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a26:b0:36c:2ed4:8d4c with SMTP id
 e9e14a558f8ab-371f96ed3aemr617085ab.4.1716346532155; Tue, 21 May 2024
 19:55:32 -0700 (PDT)
Date: Tue, 21 May 2024 19:55:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005c66ec061902110a@google.com>
Subject: [syzbot] [nilfs?] [btrfs?] WARNING in filemap_unaccount_folio
From: syzbot <syzbot+026119922c20a8915631@syzkaller.appspotmail.com>
To: brauner@kernel.org, clm@fb.com, dsterba@suse.com, jack@suse.cz, 
	josef@toxicpanda.com, konishi.ryusuke@gmail.com, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b6394d6f7159 Merge tag 'pull-misc' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=142a7cb2980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=713476114e57eef3
dashboard link: https://syzkaller.appspot.com/bug?extid=026119922c20a8915631
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14d43f84980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11d4fadc980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e8e1377d4772/disk-b6394d6f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/19fbbb3b6dd5/vmlinux-b6394d6f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4dcce16af95d/bzImage-b6394d6f.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/e197bb1019a1/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/1c62d475ecf4/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+026119922c20a8915631@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 5096 at mm/filemap.c:217 filemap_unaccount_folio+0x6be/0xe40 mm/filemap.c:216
Modules linked in:
CPU: 1 PID: 5096 Comm: syz-executor306 Not tainted 6.9.0-syzkaller-10729-gb6394d6f7159 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:filemap_unaccount_folio+0x6be/0xe40 mm/filemap.c:216
Code: 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df 0f b6 04 08 84 c0 0f 85 e5 00 00 00 8b 6d 00 ff c5 e9 45 fa ff ff e8 c3 66 ca ff 90 <0f> 0b 90 48 b8 00 00 00 00 00 fc ff df 41 80 3c 06 00 74 0a 48 8b
RSP: 0018:ffffc9000382f1f8 EFLAGS: 00010093
RAX: ffffffff81cbd3ad RBX: ffff888079ef0380 RCX: ffff88802d4f5a00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000003 R08: ffffffff81cbd2c9 R09: 1ffffd40000c1ec8
R10: dffffc0000000000 R11: fffff940000c1ec9 R12: 1ffffd40000c1ec8
R13: ffffea000060f640 R14: 1ffff1100f3de070 R15: ffffea000060f648
FS:  00007f13ab0c76c0(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000002ca92000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 delete_from_page_cache_batch+0x173/0xc70 mm/filemap.c:341
 truncate_inode_pages_range+0x364/0xfc0 mm/truncate.c:359
 truncate_inode_pages mm/truncate.c:439 [inline]
 truncate_pagecache mm/truncate.c:732 [inline]
 truncate_setsize+0xcf/0xf0 mm/truncate.c:757
 simple_setattr+0xbe/0x110 fs/libfs.c:886
 notify_change+0xbb4/0xe70 fs/attr.c:499
 do_truncate+0x220/0x310 fs/open.c:65
 handle_truncate fs/namei.c:3308 [inline]
 do_open fs/namei.c:3654 [inline]
 path_openat+0x2a3d/0x3280 fs/namei.c:3807
 do_filp_open+0x235/0x490 fs/namei.c:3834
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1405
 do_sys_open fs/open.c:1420 [inline]
 __do_sys_creat fs/open.c:1496 [inline]
 __se_sys_creat fs/open.c:1490 [inline]
 __x64_sys_creat+0x123/0x170 fs/open.c:1490
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f13ab131c99
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f13ab0c7198 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
RAX: ffffffffffffffda RBX: 00007f13ab1bf6d8 RCX: 00007f13ab131c99
RDX: 00007f13ab131c99 RSI: 0000000000000000 RDI: 00000000200001c0
RBP: 00007f13ab1bf6d0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f13ab18c160
R13: 000000000000006e R14: 0030656c69662f2e R15: 00007f13ab186bc0
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
