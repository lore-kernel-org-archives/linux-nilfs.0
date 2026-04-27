Received: from mail-pj1-f79.google.com (mail-pj1-f79.google.com [209.85.216.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EB3322C77
	for <linux-nilfs@vger.kernel.org>; Mon, 27 Apr 2026 15:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777302268; cv=none; b=f0XEGCXoTlD9V7G7k2nsLKottyAFyLBvj8tE7p2k0cS3/F0gPAK9kIvvbUIQGb2CFIoAGlWWra5WJFAGWXh02DQGaQOYQvc4zSWyozHg/h+MM3uT48sZOEB80+VRDUEokiJOY3F8uQewnzXRQI5cL2K7L1fAi9vDB0ialZFPjAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777302268; c=relaxed/simple;
	bh=V5EIZHKi6YQL0Vno8lAFTtyYFxiSmxs39tYRHICJTjg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Ulf4sAcCb0Kpi9cltGhR7LYMczqFzH9Dt1UUB8u5AwYr1PrZnBPiDDEKrERpJ76p3pYJ50ynVkfhuDqrAs9rt8XDZjN3p5248ifiyuiMaiBUSvC3sE+7YFPQ4f18vePYrhLyBk/+72F/3QS9atm7UV3sgRgOVNsAsfqWNTrehag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.216.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-pj1-f79.google.com with SMTP id 98e67ed59e1d1-358e95e81aeso13915515a91.0
        for <linux-nilfs@vger.kernel.org>; Mon, 27 Apr 2026 08:04:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777302266; x=1777907066;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eSv0QIc/20hoKDJgUSxQolLoVKLhjDEt0WNo8A4SkTE=;
        b=UR8V1qKuoHq+D2goO/k3pQQkKLIXjTH0Qi56493gbznUL77rfch/JaDTpgPPtgymZP
         f+Wl3d03enZzdinW2bfl62vttQA0iMtjfkah5+bnm/jbp/tId3ZZMwbXxVmHd8ft/9UK
         tAzVrrlKUEy5BYcOUWve+2BzQibC4yc340jyGWbSp+8c2sPFSFXWuVQcrg0VwTr+DZzH
         9/2J5bISCeBX1WxMhYzpJz4/AJZoQf56Q1erKCjXhtLKq+nWkmAqmTRlXbSNC+PDyBlP
         uwMStszGI2xdsHt4fCFTTUTZEwFWZCLl6f44UjBgILcMvrxSMAeuiLviG3VaGEQk3kIL
         cvIg==
X-Forwarded-Encrypted: i=1; AFNElJ+leEXlNEqpIwnn1pruLIwp0SH2XaXIX1v8d6LYryG0AKbvHutsOupvJg6o9uW/1OnZq31SV3DFGMHQWw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy82Xou3hzDKXbhZYxO8IUcm0WPoVG3eiBr6npGfLogzOLRNSYI
	DQQiiHklmUYL8UPmi7s0+91VkLtt2Z2KYz2HvSDwgQO6AIa1ahVgSCqKlSL88khF/1kWJEQmkdE
	mtA8ZzGZMMK2d5doNJlA9h3GVlvaX8iE6rdSYkIbJQUHQuhKSJmxZ4kjSRx4=
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a17:90b:52cf:b0:35f:b784:d3bf with SMTP id
 98e67ed59e1d1-361403adbadmr43999152a91.1.1777302265659; Mon, 27 Apr 2026
 08:04:25 -0700 (PDT)
Date: Mon, 27 Apr 2026 08:04:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ef7af9.050a0220.1eaaa4.0002.GAE@google.com>
Subject: [syzbot] [nilfs?] INFO: task hung in nilfs_transaction_begin (2)
From: syzbot <syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, slava@dubeyko.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    897d54018cc9 Merge tag 'fbdev-for-7.1-rc1-2' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=158d02ce580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4caf64b1ee83dac0
dashboard link: https://syzkaller.appspot.com/bug?extid=62f0f99d2f2bb8e3bbd7
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15c1d2d2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=104609ba580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7ee63649b268/disk-897d5401.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/dea757dcebb8/vmlinux-897d5401.xz
kernel image: https://storage.googleapis.com/syzbot-assets/340e219de0d5/bzImage-897d5401.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f712fa2cd562/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+62f0f99d2f2bb8e3bbd7@syzkaller.appspotmail.com

INFO: task syz.0.17:5918 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.17        state:D stack:25832 pid:5918  tgid:5911  ppid:5833   task_flags:0x400040 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5387 [inline]
 __schedule+0x17b4/0x5680 kernel/sched/core.c:7188
 __schedule_loop kernel/sched/core.c:7267 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7282
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7339
 rwsem_down_read_slowpath+0x6d9/0x940 kernel/locking/rwsem.c:1114
 __down_read_common kernel/locking/rwsem.c:1291 [inline]
 __down_read kernel/locking/rwsem.c:1304 [inline]
 down_read+0x99/0x2e0 kernel/locking/rwsem.c:1570
 nilfs_transaction_begin+0x364/0x710 fs/nilfs2/segment.c:221
 nilfs_setattr+0x124/0x2c0 fs/nilfs2/inode.c:921
 notify_change+0xc1a/0xf40 fs/attr.c:556
 chmod_common+0x273/0x4a0 fs/open.c:637
 do_fchmodat+0x12d/0x230 fs/open.c:682
 __do_sys_fchmodat fs/open.c:701 [inline]
 __se_sys_fchmodat fs/open.c:698 [inline]
 __x64_sys_fchmodat+0x7d/0x90 fs/open.c:698
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc71999cdd9
RSP: 002b:00007fc71a8fe028 EFLAGS: 00000246
 ORIG_RAX: 000000000000010c
RAX: ffffffffffffffda RBX: 00007fc719c16090 RCX: 00007fc71999cdd9
RDX: 000000000000017f RSI: 0000200000000300 RDI: ffffffffffffff9c
RBP: 00007fc719a32d69 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc719c16128 R14: 00007fc719c16090 R15: 00007fffbf6a8c68
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/31:
 #0: ffffffff8e95cd60 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8e95cd60 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #0: ffffffff8e95cd60 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
2 locks held by getty/5375:
 #0: ffff888035c970a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000321e2e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x45c/0x13a0 drivers/tty/n_tty.c:2211
2 locks held by syz.0.17/5912:
4 locks held by syz.0.17/5918:
 #0: ffff888079e74410 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:493
 #1: ffff88805f4f0ec0 (&type->i_mutex_dir_key#8){++++}-{4:4}, at: inode_lock_killable include/linux/fs.h:1034 [inline]
 #1: ffff88805f4f0ec0 (&type->i_mutex_dir_key#8){++++}-{4:4}, at: chmod_common+0x191/0x4a0 fs/open.c:629
 #2: ffff888079e74600 (sb_internal#2){.+.+}-{0:0}, at: nilfs_setattr+0x124/0x2c0 fs/nilfs2/inode.c:921
 #3: ffff888078880288 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_begin+0x364/0x710 fs/nilfs2/segment.c:221
3 locks held by syz.1.18/6027:
4 locks held by syz.1.18/6029:
 #0: ffff888076484410 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:493
 #1: ffff88805f41ddf8 (&type->i_mutex_dir_key#8){++++}-{4:4}, at: inode_lock_killable include/linux/fs.h:1034 [inline]
 #1: ffff88805f41ddf8 (&type->i_mutex_dir_key#8){++++}-{4:4}, at: chmod_common+0x191/0x4a0 fs/open.c:629
 #2: ffff888076484600 (sb_internal#2){.+.+}-{0:0}, at: nilfs_setattr+0x124/0x2c0 fs/nilfs2/inode.c:921
 #3: ffff8880316d2288 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_begin+0x364/0x710 fs/nilfs2/segment.c:221
2 locks held by syz.2.19/6067:
4 locks held by syz.2.19/6069:
 #0: 
ffff888032d1a410
 (
sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:493
 #1: ffff88805f4f3968 (&type->i_mutex_dir_key#8){++++}-{4:4}, at: inode_lock_killable include/linux/fs.h:1034 [inline]
 #1: ffff88805f4f3968 (&type->i_mutex_dir_key#8){++++}-{4:4}, at: chmod_common+0x191/0x4a0 fs/open.c:629
 #2: ffff888032d1a600 (sb_internal#2
){.+.+}-{0:0}
, at: nilfs_setattr+0x124/0x2c0 fs/nilfs2/inode.c:921
 #3: 
ffff888079970288
 (
&nilfs->ns_segctor_sem
){++++}-{4:4}
, at: nilfs_transaction_begin+0x364/0x710 fs/nilfs2/segment.c:221
2 locks held by syz.3.20/6113:
4 locks held by syz.3.20/6115:
 #0: 
ffff88802539c410
 (
sb_writers
#12
){.+.+}-{0:0}
, at: mnt_want_write+0x41/0x90 fs/namespace.c:493
 #1: 
ffff88806f1d0290
 (
&type->i_mutex_dir_key
#8
){++++}-{4:4}
, at: inode_lock_killable include/linux/fs.h:1034 [inline]
, at: chmod_common+0x191/0x4a0 fs/open.c:629
 #2: 
ffff88802539c600
 (sb_internal#2){.+.+}-{0:0}, at: nilfs_setattr+0x124/0x2c0 fs/nilfs2/inode.c:921
 #3: 
ffff88802512c288
 (
&nilfs->ns_segctor_sem
){++++}-{4:4}, at: nilfs_transaction_begin+0x364/0x710 fs/nilfs2/segment.c:221
7 locks held by syz.4.21/6161:
4 locks held by syz.4.21/6163:
 #0: ffff888067cac410
 (sb_writers
#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:493
 #1: ffff88806f1d5df8
 (&type->i_mutex_dir_key
#8
){++++}-{4:4}
, at: inode_lock_killable include/linux/fs.h:1034 [inline]
, at: chmod_common+0x191/0x4a0 fs/open.c:629
 #2: 
ffff888067cac600
 (
sb_internal
#2){.+.+}-{0:0}, at: nilfs_setattr+0x124/0x2c0 fs/nilfs2/inode.c:921
 #3: 
ffff888076c65288
 (
&nilfs->ns_segctor_sem
){++++}-{4:4}
, at: nilfs_transaction_begin+0x364/0x710 fs/nilfs2/segment.c:221
2 locks held by syz.5.22/6208:
4 locks held by syz.5.22/6210:
 #0: 
ffff88807c43a410
 (
sb_writers
#12
){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:493
 #1: ffff88806f01a720 (&type->i_mutex_dir_key#8
){++++}-{4:4}
, at: inode_lock_killable include/linux/fs.h:1034 [inline]
, at: chmod_common+0x191/0x4a0 fs/open.c:629
 #2: 
ffff88807c43a600
 (
sb_internal
#2
){.+.+}-{0:0}
, at: nilfs_setattr+0x124/0x2c0 fs/nilfs2/inode.c:921
 #3: ffff88802990c288 (
&nilfs->ns_segctor_sem
){++++}-{4:4}
, at: nilfs_transaction_begin+0x364/0x710 fs/nilfs2/segment.c:221
3 locks held by syz.6.23/6263:
4 locks held by syz.6.23/6265:
 #0: 
ffff88802ba72410
 (
sb_writers
#12
){.+.+}-{0:0}
, at: mnt_want_write+0x41/0x90 fs/namespace.c:493
 #1: 
ffff88806f01a108 (&type->i_mutex_dir_key#8){++++}-{4:4}, at: inode_lock_killable include/linux/fs.h:1034 [inline]
ffff88806f01a108 (&type->i_mutex_dir_key#8){++++}-{4:4}, at: chmod_common+0x191/0x4a0 fs/open.c:629
 #2: ffff88802ba72600 (sb_internal#2){.+.+}-{0:0}, at: nilfs_setattr+0x124/0x2c0 fs/nilfs2/inode.c:921
 #3: ffff88802877f288 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_begin+0x364/0x710 fs/nilfs2/segment.c:221
1 lock held by modprobe/6273:

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 31 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x274/0x2d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x135/0x170 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:353 [inline]
 watchdog+0xfd3/0x1030 kernel/hung_task.c:561
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 6113 Comm: syz.3.20 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
RIP: 0010:srso_alias_safe_ret+0x0/0x7 arch/x86/lib/retpoline.S:210
Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <48> 8d 64 24 08 c3 cc e8 f4 ff ff ff 0f 0b cc cc cc cc cc cc cc cc
RSP: 0018:ffffc900000075d8 EFLAGS: 00000292
RAX: 0000000091643301 RBX: ffffc900000076a0 RCX: 0000000000000102
RDX: 0000000000000007 RSI: ffffffff8e216b62 RDI: ffff88802e838000
RBP: ffffc90000007670 R08: ffffc90000007d98 R09: ffffc90000007638
R10: dffffc0000000000 R11: fffff52000000ec9 R12: ffff88802e838000
R13: 00000000000000f0 R14: ffffffff81b0d880 R15: ffffc900000075e8
FS:  00007faaf1ac36c0(0000) GS:ffff888125295000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7ac9347e20 CR3: 0000000077017000 CR4: 0000000000350ef0
Call Trace:
 <IRQ>
 srso_alias_return_thunk+0x5/0xfbef5 arch/x86/lib/retpoline.S:220
 arch_stack_walk+0x11b/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0xa9/0x100 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4569 [inline]
 slab_alloc_node mm/slub.c:4898 [inline]
 kmem_cache_alloc_node_noprof+0x384/0x690 mm/slub.c:4950
 __alloc_skb+0x1d0/0x7d0 net/core/skbuff.c:702
 skb_copy+0x188/0x800 net/core/skbuff.c:2182
 mac80211_hwsim_tx_frame_no_nl+0xe82/0x1650 drivers/net/wireless/virtual/mac80211_hwsim.c:1991
 mac80211_hwsim_tx_frame+0x1b5/0x200 drivers/net/wireless/virtual/mac80211_hwsim.c:2400
 mac80211_hwsim_beacon_tx+0x3e8/0x870 drivers/net/wireless/virtual/mac80211_hwsim.c:2501
 __iterate_interfaces+0x2ab/0x590 net/mac80211/util.c:772
 ieee80211_iterate_active_interfaces_atomic+0xdb/0x180 net/mac80211/util.c:808
 mac80211_hwsim_beacon+0xbb/0x180 drivers/net/wireless/virtual/mac80211_hwsim.c:2531
 __run_hrtimer kernel/time/hrtimer.c:1930 [inline]
 __hrtimer_run_queues+0x3c0/0xa20 kernel/time/hrtimer.c:1994
 hrtimer_run_softirq+0x17a/0x240 kernel/time/hrtimer.c:2011
 handle_softirqs+0x22a/0x840 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0xca/0x220 kernel/softirq.c:735
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:752
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1061 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1061
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:console_flush_one_record arch/x86/include/asm/irqflags.h:-1 [inline]
RIP: 0010:console_flush_all+0x801/0xb20 kernel/printk/printk.c:3343
Code: ff ff e8 42 e1 20 00 90 0f 0b 90 e9 85 fc ff ff e8 34 e1 20 00 e8 9f f2 02 0a 48 85 db 74 c0 e8 25 e1 20 00 fb 48 8b 5c 24 08 <48> 8b 44 24 20 42 80 3c 20 00 4c 8b 74 24 18 74 08 4c 89 f7 e8 f6
RSP: 0018:ffffc90003236c40 EFLAGS: 00000293
RAX: ffffffff81a4c28b RBX: ffffc90003236da0 RCX: ffff88802e838000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003236d50 R08: ffffffff903096f7 R09: 1ffffffff20612de
R10: dffffc0000000000 R11: fffffbfff20612df R12: dffffc0000000000
R13: 0000000000000001 R14: 0000000000000000 R15: ffffffff8f2195a0
 __console_flush_and_unlock kernel/printk/printk.c:3373 [inline]
 console_unlock+0xd1/0x1c0 kernel/printk/printk.c:3413
 vprintk_emit+0x485/0x560 kernel/printk/printk.c:2479
 _printk+0xdd/0x130 kernel/printk/printk.c:2504
 __nilfs_msg+0x373/0x450 fs/nilfs2/super.c:78
 nilfs_sufile_updatev+0x21c/0x6d0 fs/nilfs2/sufile.c:186
 nilfs_sufile_freev fs/nilfs2/sufile.h:93 [inline]
 nilfs_free_segments fs/nilfs2/segment.c:1140 [inline]
 nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1261 [inline]
 nilfs_segctor_collect fs/nilfs2/segment.c:1547 [inline]
 nilfs_segctor_do_construct+0x1f55/0x76c0 fs/nilfs2/segment.c:2122
 nilfs_segctor_construct+0x17b/0x690 fs/nilfs2/segment.c:2462
 nilfs_clean_segments+0x3bd/0xa50 fs/nilfs2/segment.c:2536
 nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c:922 [inline]
 nilfs_ioctl+0x261f/0x2780 fs/nilfs2/ioctl.c:1352
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7faaf0b9cdd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007faaf1ac3028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007faaf0e15fa0 RCX: 00007faaf0b9cdd9
RDX: 0000200000000640 RSI: 0000000040786e88 RDI: 0000000000000004
RBP: 00007faaf0c32d69 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007faaf0e16038 R14: 00007faaf0e15fa0 R15: 00007ffe90caddb8
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
