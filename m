Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CB116BE3A
	for <linux-nilfs@vger.kernel.org>; Wed, 19 Mar 2025 14:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394996; cv=none; b=TSMRYtplbjF5mfemUBYGFiEkrbuIFtPVh0U8EpUFPfZn3z++ptjwIkLkqr7VuigzEu2ybnGGkAF4SgugnQYNgr+PicXXTouznzBxkWJEsZ3zu8Wi80auDky6lJF/abFt5K3K/Z51arglrk73WkRcT00st05HFlZBsuuxVYhfq94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394996; c=relaxed/simple;
	bh=VwkRyNTB6AopmwgvSZOhy+xymyGdInnvRqU5ZcdFhTk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=KmTAl92HwDMyZX69vPnIU5gfFpLx2tZeKAPYDq8lAwjmuKeWc+u4AyCZoO6sKD8lsYrhcBUDRnJZOQnDIL0z1prCcdzcltQ2jElStDrl8LcRSTQyyPLzA6ElH/0RlrUpXxc6Lbj9LzKfk91AJzK79DBKWC4Ik/TcKgSfoxMe77U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3d585d76b79so8672115ab.1
        for <linux-nilfs@vger.kernel.org>; Wed, 19 Mar 2025 07:36:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742394993; x=1742999793;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ddYPRAkcr9Xsvyo/22R1ypzYpm49+Ib8p/kw8Jc6QS8=;
        b=C5kt2W8zRa6Kk1zCLjBFSEhnqDxmjU/yEiGF29fF2FbLP9NbxSRkUmMoLde70NNO5R
         Xji9wz49iGwuFOT11PLy6b9yTgcNjjJrKMTMiblYJPyUDj/IO+bqGzXA/kULafp4YviN
         nYO75/hku8p6HqjRloxFiY/wQpenX+dyJg7XHiXn1mdLJav1OrpOctadNcEMehIl7ne8
         Hgb3UuRs8vtDrgmh7dYM3A80uc1MSD/qkp+3i6+/DVJyf6FMLtZsq9BDgVI6xDUCD6A2
         8i0hfwUgL2UXpv5lvQmC3JwOqn/6AqgKT1fnj6sBI/nmRxTgGQ4zHEaE01k8j7ZoIdGX
         ixWg==
X-Forwarded-Encrypted: i=1; AJvYcCVh8a0W9BZ9cIPlpZyyguW+ASoC7g1myJx3MMfi23j9iiCUIfClvodL/wQVSNoHstwRZEupetrhTSyjoA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwhCOz1X7iW7FCOHCQxu00FptgvzrlA5PJ0RcKCjSjn33qD7CUk
	PSqitePYuTzK0QVML+GGUj3MwBgkh0zOvsgzYlrqcNE+hHpW6U0XG+MmrUhcbTQqT8yNtVjInsp
	EEFUU5JiCXvCiDGrTwbb4cl1mnIbXV85MjiqRvli8p0Z6FPxjL61ZzVg=
X-Google-Smtp-Source: AGHT+IGprIEtIHLk6p9Ioilh5RwFLooi2qk4hDHIrEmV5gHppwIXFz1EFbMUCvUv1cR8876DqjduO14ooUH9s91iqTQBZ1B16VaQ
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3193:b0:3d4:28c0:1692 with SMTP id
 e9e14a558f8ab-3d586b29777mr35171185ab.5.1742394993648; Wed, 19 Mar 2025
 07:36:33 -0700 (PDT)
Date: Wed, 19 Mar 2025 07:36:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67dad671.050a0220.2ca2c6.0197.GAE@google.com>
Subject: [syzbot] [isdn4linux?] [nilfs?] INFO: task hung in mISDN_ioctl
From: syzbot <syzbot+5d83cecd003a369a9965@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, eadavis@qq.com, 
	isdn4linux@listserv.isdn4linux.de, isdn@linux-pingi.de, 
	konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a29967be967e Merge tag 'v6.14-rc6-smb3-client-fixes' of gi..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=13ebae54580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=67fb5d057adc2bbe
dashboard link: https://syzkaller.appspot.com/bug?extid=5d83cecd003a369a9965
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=154f0278580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1093f874580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ba9ee368ed83/disk-a29967be.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1c4f0d6b1a0d/vmlinux-a29967be.xz
kernel image: https://storage.googleapis.com/syzbot-assets/74eba4ba6f62/bzImage-a29967be.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/c035da738a55/mount_0.gz

The issue was bisected to:

commit 901ce9705fbb9f330ff1f19600e5daf9770b0175
Author: Edward Adam Davis <eadavis@qq.com>
Date:   Mon Dec 9 06:56:52 2024 +0000

    nilfs2: prevent use of deleted inode

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15e9bff8580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17e9bff8580000
console output: https://syzkaller.appspot.com/x/log.txt?x=13e9bff8580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5d83cecd003a369a9965@syzkaller.appspotmail.com
Fixes: 901ce9705fbb ("nilfs2: prevent use of deleted inode")

INFO: task syz-executor371:5847 blocked for more than 143 seconds.
      Not tainted 6.14.0-rc6-syzkaller-00202-ga29967be967e #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor371 state:D stack:22288 pid:5847  tgid:5847  ppid:5844   task_flags:0x400140 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5378 [inline]
 __schedule+0x18bc/0x4c40 kernel/sched/core.c:6765
 __schedule_loop kernel/sched/core.c:6842 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6857
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6914
 __mutex_lock_common kernel/locking/mutex.c:662 [inline]
 __mutex_lock+0x817/0x1010 kernel/locking/mutex.c:730
 mISDN_ioctl+0x96/0x810 drivers/isdn/mISDN/timerdev.c:226
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f250416fd09
RSP: 002b:00007fff88981fd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000400000000040 RCX: 00007f250416fd09
RDX: 0000400000001f00 RSI: 0000000080044940 RDI: 0000000000000005
RBP: 00000000000f4240 R08: 0000000000000000 R09: 0000555585b92378
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007fff88982010 R14: 00007fff88981ffc R15: 00007f25041b801d
 </TASK>
INFO: task syz-executor371:5848 blocked for more than 143 seconds.
      Not tainted 6.14.0-rc6-syzkaller-00202-ga29967be967e #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor371 state:D stack:22224 pid:5848  tgid:5848  ppid:5843   task_flags:0x400140 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5378 [inline]
 __schedule+0x18bc/0x4c40 kernel/sched/core.c:6765
 __schedule_loop kernel/sched/core.c:6842 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6857
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6914
 __mutex_lock_common kernel/locking/mutex.c:662 [inline]
 __mutex_lock+0x817/0x1010 kernel/locking/mutex.c:730
 mISDN_ioctl+0x96/0x810 drivers/isdn/mISDN/timerdev.c:226
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f250416fd09
RSP: 002b:00007fff88981fd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000400000000040 RCX: 00007f250416fd09
RDX: 0000400000001f00 RSI: 0000000080044940 RDI: 0000000000000005
RBP: 00000000000f4240 R08: 0000000000000000 R09: 0000555585b92378
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007fff88982010 R14: 00007fff88981ffc R15: 00007f25041b801d
 </TASK>
INFO: task syz-executor371:5851 blocked for more than 143 seconds.
      Not tainted 6.14.0-rc6-syzkaller-00202-ga29967be967e #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor371 state:D stack:22368 pid:5851  tgid:5851  ppid:5849   task_flags:0x400140 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5378 [inline]
 __schedule+0x18bc/0x4c40 kernel/sched/core.c:6765
 __schedule_loop kernel/sched/core.c:6842 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6857
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6914
 __mutex_lock_common kernel/locking/mutex.c:662 [inline]
 __mutex_lock+0x817/0x1010 kernel/locking/mutex.c:730
 mISDN_ioctl+0x96/0x810 drivers/isdn/mISDN/timerdev.c:226
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f250416fd09
RSP: 002b:00007fff88981fd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000400000000040 RCX: 00007f250416fd09
RDX: 0000400000001f00 RSI: 0000000080044940 RDI: 0000000000000005
RBP: 00000000000f4240 R08: 0000000000000000 R09: 0000555585b92378
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007fff88982010 R14: 00007fff88981ffc R15: 00007f25041b801d
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/31:
 #0: ffffffff8eb393e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8eb393e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8eb393e0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6746
2 locks held by getty/5582:
 #0: ffff8880318030a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002fde2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x616/0x1770 drivers/tty/n_tty.c:2211
3 locks held by syz-executor371/5845:
1 lock held by syz-executor371/5847:
 #0: ffffffff8fbf9fe8 (mISDN_mutex){+.+.}-{4:4}, at: mISDN_ioctl+0x96/0x810 drivers/isdn/mISDN/timerdev.c:226
1 lock held by syz-executor371/5848:
 #0: ffffffff8fbf9fe8 (mISDN_mutex){+.+.}-{4:4}, at: mISDN_ioctl+0x96/0x810 drivers/isdn/mISDN/timerdev.c:226
1 lock held by syz-executor371/5851:
 #0: ffffffff8fbf9fe8 (mISDN_mutex){+.+.}-{4:4}, at: mISDN_ioctl+0x96/0x810 drivers/isdn/mISDN/timerdev.c:226

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 31 Comm: khungtaskd Not tainted 6.14.0-rc6-syzkaller-00202-ga29967be967e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:236 [inline]
 watchdog+0x1058/0x10a0 kernel/hung_task.c:399
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 5845 Comm: syz-executor371 Not tainted 6.14.0-rc6-syzkaller-00202-ga29967be967e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x70 kernel/kcov.c:210
Code: 89 fb e8 23 00 00 00 48 8b 3d f4 03 92 0c 48 89 de 5b e9 f3 66 59 00 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <f3> 0f 1e fa 48 8b 04 24 65 48 8b 0c 25 00 d5 03 00 65 8b 15 80 f5
RSP: 0018:ffffc9000400fa50 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff88807f697418 RCX: ffff88806ffd8000
RDX: 0000000000000004 RSI: ffffffff9022d040 RDI: 0000000000000001
RBP: 0000000000000001 R08: 0000000000000005 R09: ffffffff8bf84d8b
R10: 0000000000000004 R11: ffff88806ffd8000 R12: dffffc0000000000
R13: 0000400000001fff R14: ffff88807f697408 R15: 0000400000001000
FS:  0000555585b91380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000400000001f00 CR3: 000000003177c000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 ma_slots lib/maple_tree.c:775 [inline]
 mtree_range_walk+0x3fe/0x8e0 lib/maple_tree.c:2790
 mas_state_walk lib/maple_tree.c:3609 [inline]
 mt_find+0x3a8/0x920 lib/maple_tree.c:6889
 find_vma+0xf9/0x170 mm/mmap.c:913
 lock_mm_and_find_vma+0x5f/0x2f0 mm/memory.c:6319
 do_user_addr_fault arch/x86/mm/fault.c:1360 [inline]
 handle_page_fault arch/x86/mm/fault.c:1480 [inline]
 exc_page_fault+0x1bf/0x8b0 arch/x86/mm/fault.c:1538
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0010:__put_user_4+0x11/0x20 arch/x86/lib/putuser.S:88
Code: 1f 84 00 00 00 00 00 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 48 89 cb 48 c1 fb 3f 48 09 d9 0f 01 cb <89> 01 31 c9 0f 01 ca c3 cc cc cc cc 0f 1f 00 90 90 90 90 90 90 90
RSP: 0018:ffffc9000400fe68 EFLAGS: 00050206
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000400000001f00
RDX: 0000000000000001 RSI: ffffffff8c2ac600 RDI: ffffffff8c802e60
RBP: 0000000000000000 R08: ffffffff903bd077 R09: 1ffffffff2077a0e
R10: dffffc0000000000 R11: fffffbfff2077a0f R12: 0000400000001f00
R13: ffff88801dae7d28 R14: dffffc0000000000 R15: 0000000000000000
 mISDN_ioctl+0x694/0x810 drivers/isdn/mISDN/timerdev.c:241
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f250416fd09
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff88981fd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000400000000040 RCX: 00007f250416fd09
RDX: 0000400000001f00 RSI: 0000000080044940 RDI: 0000000000000005
RBP: 00000000000f4240 R08: 0000000000000000 R09: 0000555585b92378
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007fff88982010 R14: 00007fff88981ffc R15: 00007f25041b801d
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.247 msecs


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
