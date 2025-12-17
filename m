Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06E1157487
	for <linux-nilfs@vger.kernel.org>; Wed, 17 Dec 2025 00:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765932389; cv=none; b=aPAhT3CfavnbRA0oNOnOoU7XrrmjSNWKfRM5C0Vh45Uix0NcqNLyHTRBNlWERmWna5C4uQg3jqErvapYTthmAdAdJkLh57FqvCka1evj4vsh/ldaQf6Y4fZooFe+qV6QJ7RSxA23oj1QpTN8Mph4ZjbJsKziI1k93bU6DG0K3Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765932389; c=relaxed/simple;
	bh=C7N+xIJ3VSKTm5T6GIGdNgdUjYuuO1ZuZM3Bm8VoOYg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PBvaKhO2L+KrG5Dk+1ckaeVudcyh6nT3SCMZPH3fpJTHs/40P6ABsXAQZoiJL2KR3OZzDU7TETs8eGxoUh9H9oY26tmoDPDj8DupS3ODlLBIy8VZQ+GV0YuIZOV5yKUzQakohOb9TDifgZA2Gd81c0+/W8JM0vNUyyN6JwzP+FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-450adce3ee8so10794572b6e.1
        for <linux-nilfs@vger.kernel.org>; Tue, 16 Dec 2025 16:46:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765932387; x=1766537187;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LN7H3tSfbJ0/j6ARdBvc9GFHUGQUnD6u1T/t5vWCrvk=;
        b=Gf8m8L5R7SHkC4Utt6+SgSynfCfEO6L8Jefxdy9oCTqcYJ7BwJ3IzQIanKswKioS7h
         SBv+4qOyZaGMO7DljJyeKtXAqHNNABYXgKQqMylsEjsjP0u3bOrPV30waM7ha3CsDjND
         H5KRdse/079O+hO6fL6e/HJ0fC92iWl/X6VH5xlzLN7uVOg6nkRe9b9UFMb2u5Z3EUV/
         SlMFMilDpb3IcmFqSQsY7FqZ8haetiebmbEv6Ixui/OHAA20M3POpcRq+QKhvWFh3X0L
         lDPt5DFfyZJZ4DYhM2GD5OGEh4OLqps/eigguFV7ST8gxyz9trESSEpW/Ft2IxVojewk
         9ouA==
X-Forwarded-Encrypted: i=1; AJvYcCUgcwDiuyeR6YrmGcrqWrf01GylDSHucL/uf2uF2lpxBi3j8lkfk7XYGYDr5mmZwR2CbRO7zF3dAh6loA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/joIhF6+DcGfLPho9wOQQErWaBCdqQNEfXbau3fh2HmmeSz7M
	jm07F5Tcg0aNfEejXsqAY4d+DHXrDWv2VICsBUAY7ZGkhy8/bIKb5lPeTtQUGUnxP1OWS6EGnrv
	A3GX89g3uaNY1SDeJApBfiAYUMCSjTxUJRnmZdceLJZncUvAzbnhE5fWjgBg=
X-Google-Smtp-Source: AGHT+IH/GnTX7bnOcCj35ZpAF2GzoTY6C5AhI0ovNaLePzZr3ATopcdBf6XyqovnSffEDwVKaIKVqDEXWNlABTdyE9/WT+bj+YAk
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:298f:b0:659:9a49:8fdc with SMTP id
 006d021491bc7-65b4516d5c5mr6319029eaf.9.1765932386860; Tue, 16 Dec 2025
 16:46:26 -0800 (PST)
Date: Tue, 16 Dec 2025 16:46:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6941fd62.a70a0220.207337.0022.GAE@google.com>
Subject: [syzbot] [nilfs?] INFO: task hung in nilfs_segctor_thread (6)
From: syzbot <syzbot+7eedce5eb281acd832f0@syzkaller.appspotmail.com>
To: axboe@kernel.dk, konishi.ryusuke@gmail.com, kristian@klausen.dk, 
	linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8f0b4cce4481 Linux 6.19-rc1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=178ac11a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1f2b6fe1fdf1a00b
dashboard link: https://syzkaller.appspot.com/bug?extid=7eedce5eb281acd832f0
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12efdb90580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f9cd92580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ea3b19e4d883/disk-8f0b4cce.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bd7c115820ba/vmlinux-8f0b4cce.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e5813cc1963f/bzImage-8f0b4cce.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/80eb4ac785e9/mount_0.gz

The issue was bisected to:

commit 2b9ac22b12a266eb4fec246a07b504dd4983b16b
Author: Kristian Klausen <kristian@klausen.dk>
Date:   Fri Jun 18 11:51:57 2021 +0000

    loop: Fix missing discard support when using LOOP_CONFIGURE

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17e3b11a580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1413b11a580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1013b11a580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7eedce5eb281acd832f0@syzkaller.appspotmail.com
Fixes: 2b9ac22b12a2 ("loop: Fix missing discard support when using LOOP_CONFIGURE")

INFO: tas[  327.531540][   T38] INFO: task segctord:6093 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:segctord        state:D stack:28968 pid:6093  tgid:6093  ppid:2      task_flags:0x200040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5256 [inline]
 __schedule+0x1480/0x50a0 kernel/sched/core.c:6863
 __schedule_loop kernel/sched/core.c:6945 [inline]
 rt_mutex_schedule+0x77/0xf0 kernel/sched/core.c:7241
 rwbase_write_lock+0x3dd/0x750 kernel/locking/rwbase_rt.c:272
 nilfs_transaction_lock+0x253/0x4c0 fs/nilfs2/segment.c:357
 nilfs_segctor_thread_construct fs/nilfs2/segment.c:2569 [inline]
 nilfs_segctor_thread+0x6ec/0xe00 fs/nilfs2/segment.c:2684
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/38:
 #0: ffffffff8d5ae880 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8d5ae880 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:867 [inline]
 #0: ffffffff8d5ae880 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
3 locks held by kworker/u8:14/1555:
2 locks held by getty/5561:
 #0: ffff8880354c00a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90003e8b2e0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x44f/0x1460 drivers/tty/n_tty.c:2211
1 lock held by syz-executor/5830:
5 locks held by syz.0.17/6090:
1 lock held by segctord/6093:
 #0: ffff88803672b2b0 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_lock+0x253/0x4c0 fs/nilfs2/segment.c:357
2 locks held by syz.1.18/6168:
1 lock held by segctord/6169:
 #0: ffff88805c1e12b0 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_lock+0x253/0x4c0 fs/nilfs2/segment.c:357
2 locks held by syz.2.19/6194:
1 lock held by segctord/6195:
 #0: ffff88801fadf2b0 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_lock+0x253/0x4c0 fs/nilfs2/segment.c:357
3 locks held by syz.3.20/6222:
1 lock held by segctord/6223:
 #0: ffff88801b7aa2b0 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_lock+0x253/0x4c0 fs/nilfs2/segment.c:357
4 locks held by syz.4.21/6261:
1 lock held by segctord/6263:
 #0: ffff8880308212b0 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_lock+0x253/0x4c0 fs/nilfs2/segment.c:357
3 locks held by syz.5.22/6295:
1 lock held by segctord/6296:
 #0: ffff888033ee82b0 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_lock+0x253/0x4c0 fs/nilfs2/segment.c:357
2 locks held by syz.6.23/6334:
1 lock held by segctord/6335:
 #0: ffff888038fc92b0 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_lock+0x253/0x4c0 fs/nilfs2/segment.c:357

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 38 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x135/0x170 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:346 [inline]
 watchdog+0xf95/0xfe0 kernel/hung_task.c:515
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 6295 Comm: syz.5.22 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:io_apic_sync arch/x86/kernel/apic/io_apic.c:398 [inline]
RIP: 0010:io_apic_modify_irq arch/x86/kernel/apic/io_apic.c:386 [inline]
RIP: 0010:mask_ioapic_irq+0x187/0x380 arch/x86/kernel/apic/io_apic.c:407
Code: 10 00 00 00 c1 e5 0c 81 c5 00 40 20 00 48 63 cd 48 c7 c2 00 f0 7f ff 48 29 ca 8b 0b 81 e1 ff 0f 00 00 89 04 0a 44 89 74 0a 10 <41> 0f b6 44 35 00 84 c0 0f 85 2c 01 00 00 44 8b 2f 49 81 fd 80 00
RSP: 0018:ffffc90000007f00 EFLAGS: 00000046
RAX: 0000000000000024 RBX: ffffffff91b73694 RCX: 0000000000000000
RDX: ffffffffff5fb000 RSI: dffffc0000000000 RDI: ffff88813ff7d850
RBP: 0000000000204000 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000000fbc R12: ffff88813ff7d840
R13: 1ffff11027fefb0a R14: 0000000000018020 R15: 000000000000000a
FS:  00007fe5d0c066c0(0000) GS:ffff888126d03000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055f04873d608 CR3: 000000003567c000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 mask_irq kernel/irq/chip.c:434 [inline]
 handle_fasteoi_irq+0x33f/0xa00 kernel/irq/chip.c:762
 generic_handle_irq_desc include/linux/irqdesc.h:172 [inline]
 handle_irq arch/x86/kernel/irq.c:255 [inline]
 call_irq_handler arch/x86/kernel/irq.c:-1 [inline]
 __common_interrupt+0x141/0x1f0 arch/x86/kernel/irq.c:326
 common_interrupt+0xb6/0xe0 arch/x86/kernel/irq.c:319
 </IRQ>
 <TASK>
 asm_common_interrupt+0x26/0x40 arch/x86/include/asm/idtentry.h:688
RIP: 0010:arch_atomic_read arch/x86/include/asm/atomic.h:23 [inline]
RIP: 0010:raw_atomic_read include/linux/atomic/atomic-arch-fallback.h:457 [inline]
RIP: 0010:rcu_is_watching_curr_cpu include/linux/context_tracking.h:128 [inline]
RIP: 0010:rcu_is_watching+0x4e/0xb0 kernel/rcu/tree.c:751
Code: ff df 4c 8d 34 dd d0 ad 01 8d 4c 89 f0 48 c1 e8 03 42 80 3c 38 00 74 08 4c 89 f7 e8 ac 92 7c 00 48 c7 c3 58 0c b3 91 49 03 1e <48> 89 d8 48 c1 e8 03 42 0f b6 04 38 84 c0 75 34 8b 03 65 ff 0d 79
RSP: 0018:ffffc90003f074c8 EFLAGS: 00000283
RAX: 1ffffffff1a035ba RBX: ffff8880b8833c58 RCX: f99f3176bf70e500
RDX: 0000000000000000 RSI: ffffffff8b3f5640 RDI: ffffffff8b3f5600
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffff88803df1b2b8 R11: ffffed1007be365b R12: dffffc0000000000
R13: ffff88803df1b280 R14: ffffffff8d01add0 R15: dffffc0000000000
 rcu_read_lock include/linux/rcupdate.h:868 [inline]
 bio_associate_blkg+0xa6/0x230 block/blk-cgroup.c:2154
 bio_init block/bio.c:267 [inline]
 bio_alloc_percpu_cache block/bio.c:473 [inline]
 bio_alloc_bioset+0x46a/0x12d0 block/bio.c:526
 bio_alloc include/linux/bio.h:374 [inline]
 blk_alloc_discard_bio+0x194/0x2c0 block/blk-lib.c:47
 __blkdev_issue_discard block/blk-lib.c:68 [inline]
 blkdev_issue_discard+0xf2/0x1b0 block/blk-lib.c:93
 nilfs_sufile_trim_fs+0xc31/0xf90 fs/nilfs2/sufile.c:1182
 nilfs_ioctl_trim_fs fs/nilfs2/ioctl.c:1041 [inline]
 nilfs_ioctl+0x1411/0x25a0 fs/nilfs2/ioctl.c:1354
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xff/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe5d159f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe5d0c06038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fe5d17f5fa0 RCX: 00007fe5d159f749
RDX: 00002000000004c0 RSI: 00000000c0185879 RDI: 0000000000000005
RBP: 00007fe5d1623f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe5d17f6038 R14: 00007fe5d17f5fa0 R15: 00007ffff490ff28
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
