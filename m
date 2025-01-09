Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075E01AAC9
	for <linux-nilfs@vger.kernel.org>; Thu,  9 Jan 2025 04:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736398462; cv=none; b=Cr/LuYfhuugULKUokpoFyosoyTqnHy/W1uqJ4EAiCFz8abi1ceG2abArcw/Pl+G7SFm+UKSC7jH1CqcxQItTJVnzdI/HGB+BsBbieQ9mLUosWf/Dxx+0MCTe3fF+3GS5OBSD9551Ix6ZGhLxtuAQYUBLqdBS0RpnGPKQlHHp494=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736398462; c=relaxed/simple;
	bh=TcKgY7NdjN4xavB9r2xaNINQOh5zG3VpEvCsSmfmeL0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ZT0Fhlwsytz2oQaxGcM4sY5mL2Su+ODKKr+5N4MK2nBdhS/VwcQ8gQwoIt+8dZb5hVIig/H3pL8aRz28tlWloEGrXBlMVKj0t8xUz6koGwXKe13g+IA410ht+QG66PfR9vdQjDUU/sU3xAXlIsEDA3shNwQfddVZQi2PBJ4J63g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3a81684bac0so9066835ab.0
        for <linux-nilfs@vger.kernel.org>; Wed, 08 Jan 2025 20:54:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736398460; x=1737003260;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wcH7WKHw2o7kWDsYn69yBg320xPxpfambWhETYbAKes=;
        b=jVrpw9sFi/DNMp7NhyPr3dKDw3y/4QYw7shoZZSG13wUwfLMGkTIVSpOiW9rn+BmTS
         SJevyPLWAV3ztkKD1Kp58lC01t+9GHPTbKY59cL+e5TTHRgqIbW1jikrwwybkDw/ebME
         qJI/Pvan1hMmDThpYu9ImfbDmsr8F5rtTE6TAgBtRObE2edAi3wxSxtzOd+FznwEZMdL
         nYBQCk462S/7LlRPSO4RrAr72uFPQLir5KkkgJTZMA/qIPK4jRqMNVf8IeYRikkl8MDi
         Il6fFg2BMndotpqiiLbOHNmrEOoYLWG634xNS4BfgmLSvywzuXUVaN0qPvIA9alDy8Xm
         cL/A==
X-Forwarded-Encrypted: i=1; AJvYcCVJaqvVjbBccAafFU/tX9GKc9Eig4ywYMoovCNDMWVzaPTFS1/rGt0hkf0aV1A+jGWhwRV7gcVlX/PoyA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLvBSsArinTDcCktIRaDOytLTpgs/uDqeEq2w5edHTrd4CPo4d
	hKLdoZEYAMlRiAOMx7rLYJeJjveLHB7TU4PB4K8HAtdJ07cp/9MV3JP1+XgE9QKSQs1QM6k3V0e
	FPI4fbSo4G4vamNPEXylHJhdB6lXPFUfBMq5OgwPhgEVJocc8Vq/Hpj8=
X-Google-Smtp-Source: AGHT+IFnsqqMphLJKd0CaM2Pnz/YHh/iUNdzsPyYU5IfY901S0PtpiP8ahTTsvoSf0mz7u9ghtWNJUZOwvG7Lt27KBX+yQPkx6Xe
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1f11:b0:3a7:e7bd:9f09 with SMTP id
 e9e14a558f8ab-3ce3a86af82mr49486425ab.5.1736398460140; Wed, 08 Jan 2025
 20:54:20 -0800 (PST)
Date: Wed, 08 Jan 2025 20:54:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <677f567c.050a0220.25a300.01ad.GAE@google.com>
Subject: [syzbot] [nilfs?] INFO: task hung in find_inode (2)
From: syzbot <syzbot+6646318bbcf419411bc5@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ab75170520d4 Merge tag 'linux-watchdog-6.13-rc6' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=156a96f8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ba7cde9482d6bb6
dashboard link: https://syzkaller.appspot.com/bug?extid=6646318bbcf419411bc5
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1725f8b0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d909c4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/205ade41622a/disk-ab751705.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/39aa1b893dfc/vmlinux-ab751705.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c741f4e4b082/bzImage-ab751705.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/9907b5d18f5c/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6646318bbcf419411bc5@syzkaller.appspotmail.com

INFO: task syz-executor173:6352 blocked for more than 143 seconds.
      Not tainted 6.13.0-rc5-syzkaller-00163-gab75170520d4 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor173 state:D stack:22848 pid:6352  tgid:6351  ppid:5841   flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x17fb/0x4be0 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 __wait_on_freeing_inode+0x1a4/0x2f0 fs/inode.c:2502
 find_inode+0x29e/0x480 fs/inode.c:1062
 inode_insert5+0xfd/0x4c0 fs/inode.c:1333
 insert_inode_locked4+0x5b/0xb0 fs/inode.c:1879
 nilfs_insert_inode_locked fs/nilfs2/inode.c:291 [inline]
 nilfs_new_inode+0x59d/0x830 fs/nilfs2/inode.c:345
 nilfs_mkdir+0x10d/0x340 fs/nilfs2/namei.c:234
 vfs_mkdir+0x2f9/0x4f0 fs/namei.c:4311
 do_mkdirat+0x264/0x3a0 fs/namei.c:4334
 __do_sys_mkdirat fs/namei.c:4349 [inline]
 __se_sys_mkdirat fs/namei.c:4347 [inline]
 __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4347
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1a0ea43cc9
RSP: 002b:00007f1a0e9fa218 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00007f1a0eacc6a8 RCX: 00007f1a0ea43cc9
RDX: 00000000000001c0 RSI: 0000000020000080 RDI: 00000000ffffff9c
RBP: 00007f1a0eacc6a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 74733d726564726f
R13: 0031656c69662f2e R14: 6569727261626f6e R15: 0030656c69662f2e
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/30:
 #0: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6744
3 locks held by kworker/1:1/46:
 #0: ffff88801ac80948 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac80948 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc90000b67d00 ((work_completion)(&sci->sc_iput_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90000b67d00 ((work_completion)(&sci->sc_iput_work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffff8880772d6610 (sb_internal#2){.+.+}-{0:0}, at: nilfs_evict_inode+0x167/0x500 fs/nilfs2/inode.c:861
3 locks held by kworker/0:3/1220:
 #0: ffff88801ac80948 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac80948 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc900044cfd00 ((work_completion)(&sci->sc_iput_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc900044cfd00 ((work_completion)(&sci->sc_iput_work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffff888070e54610 (sb_internal#2){.+.+}-{0:0}, at: nilfs_evict_inode+0x167/0x500 fs/nilfs2/inode.c:861
3 locks held by kworker/1:2/3075:
 #0: ffff88801ac80948 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac80948 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc9000c4a7d00 ((work_completion)(&sci->sc_iput_work)){+.+.}-{0:0}
, at: process_one_work kernel/workqueue.c:3205 [inline]
, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffff88807fa26610 (sb_internal#2){.+.+}-{0:0}, at: nilfs_evict_inode+0x167/0x500 fs/nilfs2/inode.c:861
1 lock held by udevd/5198:
 #0: ffff8880b863e758 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2a/0x140 kernel/sched/core.c:598
2 locks held by getty/5587:
 #0: ffff88814da010a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc900032fb2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
1 lock held by syz-executor173/5842:
 #0: ffffffff8e93cff8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:297 [inline]
 #0: ffffffff8e93cff8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x381/0x830 kernel/rcu/tree_exp.h:976
1 lock held by syz-executor173/5843:
 #0: ffffffff8e93cff8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:329 [inline]
 #0: ffffffff8e93cff8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x451/0x830 kernel/rcu/tree_exp.h:976
4 locks held by syz-executor173/6352:
 #0: ffff8880772d6420 (sb_writers#9){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff888073484f20 (&type->i_mutex_dir_key#6/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:853 [inline]
 #1: ffff888073484f20 (&type->i_mutex_dir_key#6/1){+.+.}-{4:4}, at: filename_create+0x260/0x540 fs/namei.c:4080
 #2: ffff8880772d6610 (sb_internal#2){.+.+}-{0:0}, at: nilfs_mkdir+0xce/0x340 fs/nilfs2/namei.c:228
 #3: ffff888024bcc2a0 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_begin+0x320/0x6e0 fs/nilfs2/segment.c:223
1 lock held by segctord/6356:
 #0: ffff888024bcc2a0 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_lock+0x25d/0x4f0 fs/nilfs2/segment.c:357
4 locks held by syz-executor173/7364:
 #0: ffff888070e54420 (sb_writers#9){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff88807355c8c0 (&type->i_mutex_dir_key#6/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:853 [inline]
 #1: ffff88807355c8c0 (&type->i_mutex_dir_key#6/1){+.+.}-{4:4}, at: filename_create+0x260/0x540 fs/namei.c:4080
 #2: ffff888070e54610 (sb_internal#2){.+.+}-{0:0}, at: nilfs_mkdir+0xce/0x340 fs/nilfs2/namei.c:228
 #3: ffff88802a1f22a0 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_begin+0x320/0x6e0 fs/nilfs2/segment.c:223
1 lock held by segctord/7370:
 #0: ffff88802a1f22a0 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_lock+0x25d/0x4f0 fs/nilfs2/segment.c:357
4 locks held by syz-executor173/9191:
 #0: ffff88807fa26420 (sb_writers#9){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff8880734dd580 (&type->i_mutex_dir_key#6/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:853 [inline]
 #1: ffff8880734dd580 (&type->i_mutex_dir_key#6/1){+.+.}-{4:4}, at: filename_create+0x260/0x540 fs/namei.c:4080
 #2: ffff88807fa26610 (sb_internal#2){.+.+}-{0:0}, at: nilfs_mkdir+0xce/0x340 fs/nilfs2/namei.c:228
 #3: ffff88807ab9f2a0 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_begin+0x320/0x6e0 fs/nilfs2/segment.c:223
1 lock held by segctord/9198:
 #0: ffff88807ab9f2a0 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_lock+0x25d/0x4f0 fs/nilfs2/segment.c:357

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.13.0-rc5-syzkaller-00163-gab75170520d4 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:234 [inline]
 watchdog+0xff6/0x1040 kernel/hung_task.c:397
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 43 Comm: kworker/1:1H Not tainted 6.13.0-rc5-syzkaller-00163-gab75170520d4 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue:  0x0 (kblockd)
RIP: 0010:update_misfit_status+0x46/0x660 kernel/sched/fair.c:5230
Code: ff df 48 8d 9e d8 0b 00 00 48 89 d8 48 c1 e8 03 42 0f b6 04 20 84 c0 75 17 8b 1b 66 90 48 83 c4 20 5b 41 5c 41 5d 41 5e 41 5f <5d> c3 cc cc cc cc 89 d9 80 e1 07 80 c1 03 38 c1 7c dd 48 89 df e8
RSP: 0018:ffffc90000b37ac0 EFLAGS: 00000082
RAX: 0000000000000000 RBX: ffff88801d2d0000 RCX: dffffc0000000000
RDX: ffff888027301ec0 RSI: ffff8880b873e740 RDI: ffff88801d2d0000
RBP: ffff88801d2d00c8 R08: ffffffff814ec593 R09: 1ffffffff2030ad6
R10: dffffc0000000000 R11: fffffbfff2030ad7 R12: 1ffff110170e7e64
R13: ffff88801d2d00c0 R14: ffff8880b873e740 R15: ffff8880b873f320
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1a065ff000 CR3: 000000000e736000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 __set_next_task_fair kernel/sched/fair.c:13272 [inline]
 pick_next_task_fair+0x9af/0xc90 kernel/sched/fair.c:8970
 __pick_next_task+0xdd/0x400 kernel/sched/core.c:6023
 __schedule+0x776/0x4be0 kernel/sched/core.c:6709
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 worker_thread+0xa30/0xd30 kernel/workqueue.c:3406
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.117 msecs


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
