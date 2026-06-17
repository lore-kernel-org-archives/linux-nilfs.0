Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CCA2F7F06
	for <linux-nilfs@vger.kernel.org>; Wed, 17 Jun 2026 14:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781705494; cv=none; b=KMixF8DfedbQMd9yYgS5Et11ZtV8OtvWcmjaDFxRKuMzRTZ+00JFCGvK9IKcP6GC6qLvIiAe69J2uMfNEX0BgZRnOxiBkQYLB/kPtUj9YUaepo/9nvjI95o0XROF9kDJPDhk3QNGdn6mqUwp+L+cjr6N7m3d0VNHB2CJvlre6MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781705494; c=relaxed/simple;
	bh=OCfkun+HcaVusAp36LJlnZcyXu02dIiegZl7wHA7FEQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=IA/uxSFlBv1NvfNXt5WWPxN4VLrlYTVkc3w5WN0pPx9ckzxUWAVseRB9fR/ZIcPcTghZDO0kM/ItLkD6w3HXoWWcrgGCDUd2VJAkWMV0QEUF7Sj2kzcPRZV51EejDN/HeDgM8MwKLMitx4mlgajZb/wIvoXxjDWK82bSC/CmkWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-487059fb570so11890747b6e.0
        for <linux-nilfs@vger.kernel.org>; Wed, 17 Jun 2026 07:11:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781705491; x=1782310291;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1n7zR6bo3QG6DgEEgYgb5z/y+K75dRK1+s4R3i2aUg0=;
        b=UEtvYmqGUW2rh3ORVdBEVdcMpjIAkuPjbSrNr1xzInmGa/9jAFCsuPgSqzYchZuYDf
         FwI5tBRCuR/LGRXfrFmwu9HAr2dlRT81LkdMe3xuEvPPzp4Pgx4dmrqugEY9gSVr7gnk
         3tkBACWkOXZHroKfBnc/pDwKjNRUyXJ06+2lw63aLai1lpTz/BG9srKiMyGPvL3WCkuO
         I0L/1XVIt1syyKlj9jr7OJ5cjm43Tw7m5p2x0NzdLslAHrzQByDNcLm4GwP/6MdLhl7B
         FzUQLRO4jA6AlcISREnSi6F9ZtcihcUGdPT/8Y2JuJFZM4uISIzfp7uB6eRHXCluGeoj
         hhzA==
X-Forwarded-Encrypted: i=1; AFNElJ/UJdnbIuAsVugfNK4eGMFbE7vh9MGs6mcdQ1nOcFQDQciJSuLpCQPtBpIYFirhEmmCB0/fjmtVam19qg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo2dhEnJu45La1jj2bBYmF+Af7SYLdXZykpCU3R6yqnew+p4OK
	y7l3rax7/M9zY21V6nIKsKUqNkG78E60hjMAlItpHacfRuvdZXaP6Pr0+CcvJLe6ii7LL7Jeoi+
	DBJyBvoLijCQX//edhxncfp1jCANdWLDvv8+qi6/VUE7JaOnNPyAxC7scP/Y=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1707:b0:479:ded7:477 with SMTP id
 5614622812f47-48942acd893mr3145617b6e.40.1781705491355; Wed, 17 Jun 2026
 07:11:31 -0700 (PDT)
Date: Wed, 17 Jun 2026 07:11:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a32ab13.d1b4d54b.11ef78.0031.GAE@google.com>
Subject: [syzbot] [nilfs?] INFO: task hung in nilfs_segctor_thread (7)
From: syzbot <syzbot+155b515977fecb686986@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    062871f1371b Merge tag 'pinctrl-v7.1-3' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16fa58ae580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e828c596d7aa593
dashboard link: https://syzkaller.appspot.com/bug?extid=155b515977fecb686986
compiler:       Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1510f3d2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e3dc965f9a88/disk-062871f1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2f67e7ba9e6a/vmlinux-062871f1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4ad13e1ccf55/bzImage-062871f1.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f2ea87a29031/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+155b515977fecb686986@syzkaller.appspotmail.com

INFO: task segctord:6131 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:segctord        state:D stack:28680 pid:6131  tgid:6131  ppid:2      task_flags:0x200040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5388 [inline]
 __schedule+0x1840/0x57a0 kernel/sched/core.c:7189
 __schedule_loop kernel/sched/core.c:7268 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7283
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7340
 rwsem_down_write_slowpath+0x87d/0x1080 kernel/locking/rwsem.c:1215
 __down_write_common kernel/locking/rwsem.c:1347 [inline]
 __down_write kernel/locking/rwsem.c:1356 [inline]
 down_write+0x1bc/0x200 kernel/locking/rwsem.c:1626
 nilfs_transaction_lock+0x24a/0x4b0 fs/nilfs2/segment.c:357
 nilfs_segctor_thread_construct fs/nilfs2/segment.c:2569 [inline]
 nilfs_segctor_thread+0x6be/0xdb0 fs/nilfs2/segment.c:2684
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/32:
 #0: 
ffffffff8e95c780
 (
rcu_read_lock
){....}-{1:3}
, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
2 locks held by getty/5382:
 #0: 
ffff888031f200a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: 
ffffc900032332e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x45a/0x1380 drivers/tty/n_tty.c:2211
3 locks held by syz.0.17/6086:
2 locks held by syz.5.22/6114:
3 locks held by syz.2.19/6118:
3 locks held by syz.1.18/6126:
2 locks held by syz.3.20/6130:
3 locks held by syz.4.21/6132:
1 lock held by segctord/6131:
 #0: ffff88805bb0c288 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_lock+0x24a/0x4b0 fs/nilfs2/segment.c:357
2 locks held by syz-executor/6175:
1 lock held by syz-executor/6176:
7 locks held by syz.6.23/6349:
2 locks held by syz.7.24/6383:
3 locks held by syz.8.25/6380:
3 locks held by syz.9.26/6391:
1 lock held by syz.5.286/7133:
2 locks held by syz.0.288/7141:
1 lock held by syz.3.289/7140:

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 32 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x274/0x2d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x135/0x170 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:353 [inline]
 watchdog+0xfd7/0x1030 kernel/hung_task.c:561
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 6126 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
RIP: 0010:hrtick_start+0x4a/0x250 kernel/sched/core.c:959
Code: 00 00 41 bc 10 27 00 00 4c 0f 4d e6 4c 8d b7 e0 0d 00 00 4d 89 f7 49 c1 ef 03 43 0f b6 04 2f 84 c0 0f 85 83 01 00 00 41 8b 2e <85> ed 74 46 83 cd 04 43 0f b6 04 2f 84 c0 0f 85 8a 01 00 00 89 ab
RSP: 0018:ffffc90000a08a90 EFLAGS: 00000046
RAX: 0000000000000000 RBX: ffff8880b873b080 RCX: 0000000000000392
RDX: 00000000000000da RSI: 000000000017eda4 RDI: ffff8880b873b080
RBP: 0000000000000000 R08: ffffffff902f890f R09: 1ffffffff205f121
R10: dffffc0000000000 R11: fffffbfff205f122 R12: 000000000017eda4
R13: dffffc0000000000 R14: ffff8880b873be60 R15: 1ffff110170e77cc
FS:  00007f8ac9dd86c0(0000) GS:ffff8881253b9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f775c7ec4b8 CR3: 0000000022337000 CR4: 0000000000350ef0
Call Trace:
 <IRQ>
 enqueue_task+0x75/0x410 kernel/sched/core.c:2165
 activate_task kernel/sched/core.c:2205 [inline]
 ttwu_do_activate+0x1c8/0x650 kernel/sched/core.c:3725
 ttwu_queue kernel/sched/core.c:3978 [inline]
 try_to_wake_up+0x70e/0x1330 kernel/sched/core.c:4302
 autoremove_wake_function+0x17/0x100 kernel/sched/wait.c:403
 __wake_up_common kernel/sched/wait.c:108 [inline]
 __wake_up_common_lock+0x13a/0x1f0 kernel/sched/wait.c:125
 irq_work_single+0xe0/0x240 kernel/irq_work.c:221
 irq_work_run_list kernel/irq_work.c:252 [inline]
 irq_work_tick+0x238/0x2a0 kernel/irq_work.c:277
 update_process_times+0x263/0x2f0 kernel/time/timer.c:2478
 tick_sched_handle kernel/time/tick-sched.c:298 [inline]
 tick_nohz_handler+0x3fb/0x730 kernel/time/tick-sched.c:319
 __run_hrtimer kernel/time/hrtimer.c:1930 [inline]
 __hrtimer_run_queues+0x371/0xa10 kernel/time/hrtimer.c:1994
 hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2113
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1067
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1061 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1061
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:console_trylock_spinning kernel/printk/printk.c:2039 [inline]
RIP: 0010:vprintk_emit+0x45d/0x560 kernel/printk/printk.c:2478
Code: 0f 84 44 ff ff ff e8 72 17 21 00 fb eb 44 e8 6a 17 21 00 e8 45 1c fe 09 4d 85 f6 74 94 e8 5b 17 21 00 fb 48 c7 c7 00 ed 94 8e <31> f6 ba 01 00 00 00 31 c9 41 b8 01 00 00 00 45 31 c9 53 e8 6b 19
RSP: 0018:ffffc900035cee40 EFLAGS: 00000293
RAX: ffffffff81a428d5 RBX: ffffffff81a4274f RCX: ffff888076f21f00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8e94ed00
RBP: ffffc900035ceef0 R08: ffffffff902f88f7 R09: 1ffffffff205f11e
R10: dffffc0000000000 R11: fffffbfff205f11f R12: 0000000000000000
R13: 0000000000000040 R14: 0000000000000200 R15: 1ffff920006b9dcc
 _printk+0xdd/0x130 kernel/printk/printk.c:2504
 __nilfs_msg+0x373/0x450 fs/nilfs2/super.c:78
 nilfs_sufile_updatev+0x21c/0x6d0 fs/nilfs2/sufile.c:186
 nilfs_sufile_freev fs/nilfs2/sufile.h:93 [inline]
 nilfs_free_segments fs/nilfs2/segment.c:1140 [inline]
 nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1261 [inline]
 nilfs_segctor_collect fs/nilfs2/segment.c:1547 [inline]
 nilfs_segctor_do_construct+0x20dd/0x7bb0 fs/nilfs2/segment.c:2122
 nilfs_segctor_construct+0x170/0x690 fs/nilfs2/segment.c:2462
 nilfs_clean_segments+0x3ac/0xa50 fs/nilfs2/segment.c:2536
 nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:922 [inline]
 nilfs_ioctl+0x2619/0x2780 fs/nilfs2/ioctl.c:1352
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8ac8f9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8ac9dd8028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f8ac9216090 RCX: 00007f8ac8f9ce59
RDX: 0000200000000640 RSI: 0000000040786e88 RDI: 0000000000000004
RBP: 00007f8ac9032d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8ac9216128 R14: 00007f8ac9216090 R15: 00007ffd4ee3dc58
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
