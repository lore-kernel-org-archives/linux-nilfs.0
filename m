Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A279E383AE
	for <linux-nilfs@vger.kernel.org>; Fri, 19 Jul 2024 19:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721416649; cv=none; b=VvWSTn6kF5ujxf/UhHQud3SrUQWVK05aazu/+cWAP5vVDMmD7RZT4bSoCUwYJO5IDFA+6OGDAgKsWooCwViuyE+PxJ8Wf1zRME6pEBZrPTlv6IaImoWfnuTYYcHLauaXRERGL/jYPb8pVfvhjq+xSBTGkG4/vcbxolO/yZGE1o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721416649; c=relaxed/simple;
	bh=ZYEhG5jQlzdWVLVs5i03CrYxaTBLZTBrXaUnHyyFloA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ATvVWLd8bE3p8wJPm8NWZa9FoqzvD+pBGEE2Y6/ghEKevi6O5gi9xrgvWhX7AcL3A2dT/CA2AZSJW4Z0DQGg3XD0iJ+w84uSohmmEjLQ3v/t9C5J5VkdPlxiNcYWvetaMDZ/b4g/yJIlKF6w+lxRz+grV+Of2C37A+T9WftvEuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-397a7f98808so20930385ab.0
        for <linux-nilfs@vger.kernel.org>; Fri, 19 Jul 2024 12:17:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721416647; x=1722021447;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QeMwvX3I24vEwTsWwfxgus96XanxDlZHTirb6u2yzzI=;
        b=hlpmDuI9sg7ae75MgycAvwnmfCK1Ba04enZYNGMP2laDjj/Q+h6NyOC6jZcU9iiEAQ
         Tb0+zDepYKluDR98R3imTaLpXeQRoJeRrwPAa9ychetMCC3+M27NOA5Gf3ek5WjH/8W3
         vN/AErYroDySzUPzj/1QU8nguW4U8BHI/LnjqRgX9xI8xKxEVcdrxe1FS+u0fsr4fbmG
         w+cU40Desxn3qZ/1PSqxeAh4jSMJCvqSTf7Gf4r1Orug9uxw/zrWpqhxRU08g6coewwn
         vn3w1pyeQU5N9fJvUD0sqEu7Ly+6wjLT8PyxRfh7MdUWdmzy+BfI/TMJSZq9XeLXmq0L
         QS6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVt4h3ZHe10AM0yYpUy3yirED2tblBqdkEnCn2gHZUqo9nhWef5sJECY8MnL1Gs4of9AlU5vVqBHVhPFZkApYIZpnLoazZ49bkDRsA=
X-Gm-Message-State: AOJu0YzZH40u575DRiCP2x+XxfBZq46FOgVzczbYPijrhFUwDcnXjhMh
	Dih0MrSnhw5cRE+Wyr9eWkcN/P7JhH4KYREWyO66Q4JNCfXnphfZrqc4rxCQHjA9tnuBqIjAbyQ
	Llu4UD/cEBf7y69odyplnzC/OR6+cXpNYTXCkhWmi/Bg/y8YDx0o2Iko=
X-Google-Smtp-Source: AGHT+IFLxdZPK4iw+JywOgpZMIk3twdH77NIKb9EFunlAVqJoczcjqr1557igaQYH0nUqqkbRL1krFd10xRRTOgOOKu6UZzInKE5
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12c1:b0:397:9426:e7fc with SMTP id
 e9e14a558f8ab-398e1995fe7mr507285ab.0.1721416646887; Fri, 19 Jul 2024
 12:17:26 -0700 (PDT)
Date: Fri, 19 Jul 2024 12:17:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bf9aea061d9e8b1b@google.com>
Subject: [syzbot] [nilfs?] INFO: task hung in nilfs_segctor_thread (3)
From: syzbot <syzbot+377059e0af6136c7d5c4@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0434dbe32053 Merge tag 'linux_kselftest-next-6.11-rc1' of ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12d9612d980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4b8bd5292e033239
dashboard link: https://syzkaller.appspot.com/bug?extid=377059e0af6136c7d5c4
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3766752b5090/disk-0434dbe3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e3608abc3f91/vmlinux-0434dbe3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c133560ad498/bzImage-0434dbe3.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+377059e0af6136c7d5c4@syzkaller.appspotmail.com

INFO: task segctord:12059 blocked for more than 143 seconds.
      Not tainted 6.10.0-syzkaller-02711-g0434dbe32053 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:segctord        state:D stack:28272 pid:12059 tgid:12059 ppid:2      flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5188 [inline]
 __schedule+0x17ae/0x4a10 kernel/sched/core.c:6529
 __schedule_loop kernel/sched/core.c:6606 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6621
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6678
 rwsem_down_write_slowpath+0xeeb/0x13b0 kernel/locking/rwsem.c:1178
 __down_write_common kernel/locking/rwsem.c:1306 [inline]
 __down_write kernel/locking/rwsem.c:1315 [inline]
 down_write+0x1d7/0x220 kernel/locking/rwsem.c:1580
 nilfs_transaction_lock+0x25d/0x4f0 fs/nilfs2/segment.c:357
 nilfs_segctor_thread_construct fs/nilfs2/segment.c:2515 [inline]
 nilfs_segctor_thread+0x551/0x11b0 fs/nilfs2/segment.c:2601
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/30:
 #0: ffffffff8e335fe0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:327 [inline]
 #0: ffffffff8e335fe0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:839 [inline]
 #0: ffffffff8e335fe0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6613
2 locks held by kworker/u8:5/1034:
4 locks held by kworker/u8:7/1060:
 #0: ffff888015ed3148 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3206 [inline]
 #0: ffff888015ed3148 ((wq_completion)netns){+.+.}-{0:0}, at: process_scheduled_works+0x90a/0x1830 kernel/workqueue.c:3312
 #1: ffffc90004217d00 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3207 [inline]
 #1: ffffc90004217d00 (net_cleanup_work){+.+.}-{0:0}, at: process_scheduled_works+0x945/0x1830 kernel/workqueue.c:3312
 #2: ffffffff8f5cfc90 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x16a/0xcc0 net/core/net_namespace.c:594
 #3: ffff8880b943e718 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2a/0x140 kernel/sched/core.c:560
2 locks held by getty/4838:
 #0: ffff88802f2b10a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc900031332f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6b5/0x1e10 drivers/tty/n_tty.c:2211
3 locks held by kworker/0:8/5199:
 #0: ffff888015080948 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3206 [inline]
 #0: ffff888015080948 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x90a/0x1830 kernel/workqueue.c:3312
 #1: ffffc90004467d00 ((work_completion)(&data->fib_event_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3207 [inline]
 #1: ffffc90004467d00 ((work_completion)(&data->fib_event_work)){+.+.}-{0:0}, at: process_scheduled_works+0x945/0x1830 kernel/workqueue.c:3312
 #2: ffff8880781c2240 (&data->fib_lock){+.+.}-{3:3}, at: nsim_fib_event_work+0x2d1/0x4130 drivers/net/netdevsim/fib.c:1489
2 locks held by syz.4.647/12057:
1 lock held by segctord/12059:
 #0: ffff88806aa062a0 (&nilfs->ns_segctor_sem){++++}-{3:3}, at: nilfs_transaction_lock+0x25d/0x4f0 fs/nilfs2/segment.c:357
1 lock held by syz-executor/14558:
 #0: ffffffff8e33b3b8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:296 [inline]
 #0: ffffffff8e33b3b8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x381/0x830 kernel/rcu/tree_exp.h:958
1 lock held by syz.3.965/14640:
 #0: ffffffff8e33b3b8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:328 [inline]
 #0: ffffffff8e33b3b8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x451/0x830 kernel/rcu/tree_exp.h:958
5 locks held by dhcpcd-run-hook/14674:

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 30 Comm: khungtaskd Not tainted 6.10.0-syzkaller-02711-g0434dbe32053 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:223 [inline]
 watchdog+0xfde/0x1020 kernel/hung_task.c:379
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 14367 Comm: syz-executor Not tainted 6.10.0-syzkaller-02711-g0434dbe32053 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
RIP: 0010:unwind_next_frame+0x1bad/0x2a00 arch/x86/kernel/unwind_orc.c:682
Code: 85 db 0f 84 74 04 00 00 e8 80 30 55 00 43 0f b6 04 2f 84 c0 0f 85 8e 05 00 00 c7 45 00 00 00 00 00 31 c0 48 81 c4 a0 00 00 00 <5b> 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc e8 4f 30 55 00 43 80
RSP: 0018:ffffc90004bff4a0 EFLAGS: 00000286
RAX: ffffffff81412e01 RBX: 0000000080000000 RCX: ffff88802a13bc00
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc90004bff540 R08: ffffffff81412e85 R09: ffffffff8141297f
R10: 0000000000000003 R11: ffff88802a13bc00 R12: ffffc90004bff540
R13: dffffc0000000000 R14: ffffc90004bf8000 R15: ffffc90004bff548
FS:  0000000000000000(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000559dc10c4a18 CR3: 0000000063d66000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 __unwind_start+0x641/0x7c0 arch/x86/kernel/unwind_orc.c:760
 unwind_start arch/x86/include/asm/unwind.h:64 [inline]
 arch_stack_walk+0x103/0x1b0 arch/x86/kernel/stacktrace.c:24
 stack_trace_save+0x118/0x1d0 kernel/stacktrace.c:122
 save_stack+0xfb/0x1f0 mm/page_owner.c:156
 __reset_page_owner+0x75/0x3f0 mm/page_owner.c:297
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1093 [inline]
 free_unref_page+0xd19/0xea0 mm/page_alloc.c:2588
 vfree+0x186/0x2e0 mm/vmalloc.c:3363
 kcov_put kernel/kcov.c:429 [inline]
 kcov_close+0x2b/0x50 kernel/kcov.c:525
 __fput+0x24a/0x8a0 fs/file_table.c:422
 task_work_run+0x24f/0x310 kernel/task_work.c:222
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0xa2f/0x27f0 kernel/exit.c:877
 do_group_exit+0x207/0x2c0 kernel/exit.c:1026
 get_signal+0x16a1/0x1740 kernel/signal.c:2917
 arch_do_signal_or_restart+0x96/0x860 arch/x86/kernel/signal.c:310
 exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0xc9/0x370 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4aac5777ac
Code: Unable to access opcode bytes at 0x7f4aac577782.
RSP: 002b:00007ffdc6a34ef0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: 0000000000000028 RBX: 00007f4aad234620 RCX: 00007f4aac5777ac
RDX: 0000000000000028 RSI: 00007f4aad234670 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffdc6a34f44 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000003
R13: 0000000000000000 R14: 00007f4aad234670 R15: 0000000000000000
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
