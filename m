Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245392E6CA6
	for <linux-nilfs@vger.kernel.org>; Mon, 27 Oct 2025 21:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761599914; cv=none; b=ADFcjS2lxkjZkiCysFHOHEj641G6/f/82KQjfOFQ4s7Xp0qpyQts4GxKotb3RmvOBQaED0AHIBbKiBtw9lzt1w3AHtS1w27XFR1uFPxG8EJFRikWmzZh6tEWn/e6VaVB/o2Pkrn52LhGqAhHlhDnuZwy8KZrOoD58/nJXRk9iYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761599914; c=relaxed/simple;
	bh=yWnQOcvj5nXT4iKmipWt5HgJE+kFx6wV2L3dMTdY7kQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XlDEdh1o3egDBDWg1bCoLLIc/QhGkRZQ7wVi9A2y3t6dzCakwHphzHTZr1HDDT16g25Z8dFgS9WlUrjxVtE1+qGOj+UEcF1P+8M7dYrcUfe/ib3u0f5gg8EBLQQu6hRQ/b34NQo0t32I0Vj0cnuXK7LGV0L5cwXKnXoZlBG+5lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-430d4ed5cfcso190750645ab.0
        for <linux-nilfs@vger.kernel.org>; Mon, 27 Oct 2025 14:18:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761599912; x=1762204712;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t74g6tD6twh87/78NLoHkEzhT0tBtwgTsI86ZtSWuf0=;
        b=WD0w0cgy2fohQn1MSKzU+Kt5h26pxnPmAA8m4f4mtyYUFloSVfSN7MUN0FUKzH8+tH
         K+2sUn5Tgywf2ZJ0N5hI513PopkrW29uib4oqOrQKN01YR3iXTH/fjERtWvqx6RfBX0N
         Yt7wuxIjkZyyQpildbJUhBd8Xt+PqZQPew/FXo6rNrXUQeql88Q8UsbxinEyZ8QaUq1i
         KR4caNNzQQK48q5ztyvc1TB1qyzSA1KH23dxYfSC8rZIHe6LPLE+Qz7bP3k3CIOMN9bv
         A9Sj+FMTHdt3D8YXNPikfbZ0gA9Cau6ffGIE3JPWHsgbnFGs4ArTIR7w27znrjAgRWoT
         iikQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgq9SpLMS3lBK5Z55ASBfXmDuwLbSHtM02weiKCg77DbV7KjunQDizGnfdtlf/azz59Yg1uszBZhG0Vw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxbNDVjVO8yJjsRjwcEJoIubxqNpb23HsF0QWDyGbYWKO9jiZtv
	b/ZCIbCOU2TF1hD0daFbvfKpI3leQkieJN1rL7NmXfdVvL238AJMxFde5kWlsvIwvBiv8rQ8+AZ
	QuSWGkYfSgCiB5Y0lbYHmL5UeBdZaA1nlczdCGX6CMBlJFopeM8hgxBlcwgU=
X-Google-Smtp-Source: AGHT+IGyAr3zQUoQQPc7ccSMkcTKfUdmtTVqtn4Dtu5YYPplk9AIWdbXth2wHp1LLK/JKLf8kLOJCATVKRa/KaILsParrBNoXTPh
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:170f:b0:431:d763:193b with SMTP id
 e9e14a558f8ab-4320f79b3e8mr21701555ab.24.1761599912295; Mon, 27 Oct 2025
 14:18:32 -0700 (PDT)
Date: Mon, 27 Oct 2025 14:18:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ffe1a8.050a0220.3344a1.03a1.GAE@google.com>
Subject: [syzbot] [nilfs?] WARNING: ODEBUG bug in nilfs_detach_log_writer (2)
From: syzbot <syzbot+24d8b70f039151f65590@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b98c94eed4a9 arm64: mte: Do not warn if the page is alread..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=14144be2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=158bd6857eb7a550
dashboard link: https://syzkaller.appspot.com/bug?extid=24d8b70f039151f65590
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12ce5d2f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16136e7c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2c82e514449b/disk-b98c94ee.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a322ed38c368/vmlinux-b98c94ee.xz
kernel image: https://storage.googleapis.com/syzbot-assets/059db7d7114e/Image-b98c94ee.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/3ad719caa640/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+24d8b70f039151f65590@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: free active (active state 0) object: 00000000dacb411a object type: timer_list hint: __ll_sc_atomic64_andnot arch/arm64/include/asm/atomic_ll_sc.h:-1 [inline]
ODEBUG: free active (active state 0) object: 00000000dacb411a object type: timer_list hint: arch_atomic64_andnot arch/arm64/include/asm/atomic.h:64 [inline]
ODEBUG: free active (active state 0) object: 00000000dacb411a object type: timer_list hint: raw_atomic64_andnot include/linux/atomic/atomic-arch-fallback.h:3675 [inline]
ODEBUG: free active (active state 0) object: 00000000dacb411a object type: timer_list hint: raw_atomic_long_andnot include/linux/atomic/atomic-long.h:964 [inline]
ODEBUG: free active (active state 0) object: 00000000dacb411a object type: timer_list hint: arch_clear_bit include/asm-generic/bitops/atomic.h:25 [inline]
ODEBUG: free active (active state 0) object: 00000000dacb411a object type: timer_list hint: clear_bit include/asm-generic/bitops/instrumented-atomic.h:42 [inline]
ODEBUG: free active (active state 0) object: 00000000dacb411a object type: timer_list hint: clear_nilfs_purging fs/nilfs2/the_nilfs.h:206 [inline]
ODEBUG: free active (active state 0) object: 00000000dacb411a object type: timer_list hint: nilfs_construction_timeout+0x0/0x50 fs/nilfs2/segment.c:2893
WARNING: CPU: 0 PID: 6673 at lib/debugobjects.c:615 debug_print_object lib/debugobjects.c:612 [inline]
WARNING: CPU: 0 PID: 6673 at lib/debugobjects.c:615 __debug_check_no_obj_freed lib/debugobjects.c:1099 [inline]
WARNING: CPU: 0 PID: 6673 at lib/debugobjects.c:615 debug_check_no_obj_freed+0x390/0x470 lib/debugobjects.c:1129
Modules linked in:
CPU: 0 UID: 0 PID: 6673 Comm: syz-executor Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
pstate: 63400005 (nZCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : debug_print_object lib/debugobjects.c:612 [inline]
pc : __debug_check_no_obj_freed lib/debugobjects.c:1099 [inline]
pc : debug_check_no_obj_freed+0x390/0x470 lib/debugobjects.c:1129
lr : debug_print_object lib/debugobjects.c:612 [inline]
lr : __debug_check_no_obj_freed lib/debugobjects.c:1099 [inline]
lr : debug_check_no_obj_freed+0x390/0x470 lib/debugobjects.c:1129
sp : ffff8000a1547910
x29: ffff8000a1547950 x28: ffff0000cf608400 x27: 0000000000000000
x26: ffff80008aed7f20 x25: ffff0000cf608270 x24: ffff800082080a4c
x23: ffff0000d8cabfc0 x22: ffff0000cf608000 x21: dfff800000000000
x20: 0000000000000000 x19: ffff0000cf608000 x18: 00000000ffffffff
x17: 626f206131313462 x16: ffff800082de9540 x15: 0000000000000001
x14: 1fffe000337db6fa x13: 0000000000000000 x12: 0000000000000000
x11: ffff6000337db6fb x10: 0000000000ff0100 x9 : c941407f25652900
x8 : c941407f25652900 x7 : ffff8000805638d4 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff8000807d4f2c
x2 : 0000000000000001 x1 : 0000000100000000 x0 : 0000000000000000
Call trace:
 debug_print_object lib/debugobjects.c:612 [inline] (P)
 __debug_check_no_obj_freed lib/debugobjects.c:1099 [inline] (P)
 debug_check_no_obj_freed+0x390/0x470 lib/debugobjects.c:1129 (P)
 slab_free_hook mm/slub.c:2454 [inline]
 slab_free mm/slub.c:6611 [inline]
 kfree+0x120/0x600 mm/slub.c:6818
 nilfs_segctor_destroy fs/nilfs2/segment.c:2811 [inline]
 nilfs_detach_log_writer+0x668/0x8cc fs/nilfs2/segment.c:2877
 nilfs_put_super+0x4c/0x12c fs/nilfs2/super.c:509
 generic_shutdown_super+0x12c/0x2b8 fs/super.c:642
 kill_block_super+0x44/0x90 fs/super.c:1722
 deactivate_locked_super+0xc4/0x12c fs/super.c:473
 deactivate_super+0xe0/0x100 fs/super.c:506
 cleanup_mnt+0x31c/0x3ac fs/namespace.c:1327
 __cleanup_mnt+0x20/0x30 fs/namespace.c:1334
 task_work_run+0x1dc/0x260 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop+0xfc/0x178 kernel/entry/common.c:43
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 arm64_exit_to_user_mode arch/arm64/kernel/entry-common.c:103 [inline]
 el0_svc+0x170/0x254 arch/arm64/kernel/entry-common.c:747
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:765
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
irq event stamp: 136662
hardirqs last  enabled at (136661): [<ffff800080559f90>] vprintk_store+0x898/0xac8 kernel/printk/printk.c:2329
hardirqs last disabled at (136662): [<ffff80008ade9670>] el1_brk64+0x20/0x54 arch/arm64/kernel/entry-common.c:434
softirqs last  enabled at (136170): [<ffff8000801f95fc>] local_bh_enable+0x10/0x34 include/linux/bottom_half.h:32
softirqs last disabled at (136168): [<ffff8000801f95c8>] local_bh_disable+0x10/0x34 include/linux/bottom_half.h:19
---[ end trace 0000000000000000 ]---
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer
NILFS (loop1): disposed unprocessed dirty file(s) when stopping log writer


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
