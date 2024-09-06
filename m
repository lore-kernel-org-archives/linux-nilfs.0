Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2556155316
	for <linux-nilfs@vger.kernel.org>; Fri,  6 Sep 2024 21:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725659783; cv=none; b=QZr5VNjP0dzleVI+zZq1xxG1Jb4V4dwaaF7UjVjdN0P2o9JsNg+5x1/v3+zlVZeN6pbRGqUAeEMoxzs2bKGBaZjq0x0b8KtvYbfBCtNIANew9O2pce64AK/UF212YyRLzTk6hSdNeK7BvEaSfq/88nRS/K9i5/AU8qHIqaX4FmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725659783; c=relaxed/simple;
	bh=1egvPLoqLrqFllUQKUuKT1D1vElaNOa2Llu7dBqTBMw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=EKir0n0CUNOSxAoRig1EzNOFvccBimZ4iazEJph8H+Fp5l97geeINkeN3lCZcg2SaswA2bRTurBBuaWZiGW45NCswjbMJZCP2IKAJRUTnFP8IBMZEag2IY+u40vIAPZn1Zwj5gA6W7/PXHg8mnVukqFYqMjNd8cXpX664mkQgaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a045e7ed57so49118795ab.2
        for <linux-nilfs@vger.kernel.org>; Fri, 06 Sep 2024 14:56:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725659780; x=1726264580;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cN20myY6wWKrOr83S6wPbuKeQRwSmHjCnatTtQWhhRA=;
        b=jVgzk/TItpMrdLdUBdxuFSrP2WC+RURkgsj2n8loSXyNr+d7LDlcsRQg7jKiuipUnY
         x2N2ZiYkNyh2NK+hAjInKPzC0G2tA5Virl7riehTWj9lP2qfMMdJo2Ck4XhXmPp84TMA
         43TgTu3nzFBR90qWA0BBLHiRXi4itnwgZ187HqYumAIKjYq/04g9epniKJNZWdpNRgn7
         wBqZUyK+gL3pkx86k1uk/PlHUUNLM7EY3hy+ebV3na153KHaH/cdvmYKGezXziuGsBH/
         fHfrRGwp6ArO0dEecigBmjPDx5uhrUCFx9auPXMLIuyNyDDEvrVKsyodFZmyrQrpMjd2
         l1Bw==
X-Forwarded-Encrypted: i=1; AJvYcCXVHqgjZRybak1mt/AbKhms9tE+yhCl0ywRjPrfsCKKC7pevtNWoPCDG0/YoI++ji1b2UuOlzn8weeoZw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxoUYQgbLUhKHbHMQXHhCX9Kwm236IspyYSrpmRm7fo5yfnuqng
	svNy3Jveq67XEaLyj12mQOaaBMWzIPLP9Xy3vioUJnCw0ffDE6hnm6Shfip21TqcliNQ1OmZmHf
	53wXQFsW8Ejd2+ZVl41FId4awiH1c8jjHIppNLWy3lqD5DQ8SFIsvq7Y=
X-Google-Smtp-Source: AGHT+IG8H5+MXnZyK9pcZ7ga3B/sb5xVZKpoOuTMx6Qap73O5SfcLiUeFWHR86IYAaDCreYQIow/7GUWAeJCZnHUJSb3YZ0C5DG4
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fca:b0:39f:50c7:9749 with SMTP id
 e9e14a558f8ab-3a04f0985bfmr2113075ab.2.1725659779977; Fri, 06 Sep 2024
 14:56:19 -0700 (PDT)
Date: Fri, 06 Sep 2024 14:56:19 -0700
In-Reply-To: <000000000000e450e805ea5b2b39@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000030626806217a7aec@google.com>
Subject: Re: [syzbot] [fs] INFO: task hung in path_openat (7)
From: syzbot <syzbot+950a0cdaa2fdd14f5bdc@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    b831f83e40a2 Merge tag 'bpf-6.11-rc7' of git://git.kernel...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=13ceca8b980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8926d683f62db53e
dashboard link: https://syzkaller.appspot.com/bug?extid=950a0cdaa2fdd14f5bdc
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11849200580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12472ffb980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7de57e317906/disk-b831f83e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/83081a33fb63/vmlinux-b831f83e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1a98ffa98a52/bzImage-b831f83e.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/9f8e1f401e6c/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+950a0cdaa2fdd14f5bdc@syzkaller.appspotmail.com

INFO: task syz-executor292:5263 blocked for more than 143 seconds.
      Not tainted 6.11.0-rc6-syzkaller-00183-gb831f83e40a2 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor292 state:D stack:27952 pid:5263  tgid:5250  ppid:5245   flags:0x00004006
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
 inode_lock include/linux/fs.h:800 [inline]
 open_last_lookups fs/namei.c:3644 [inline]
 path_openat+0x7fb/0x3470 fs/namei.c:3883
 do_filp_open+0x235/0x490 fs/namei.c:3913
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1416
 do_sys_open fs/open.c:1431 [inline]
 __do_sys_open fs/open.c:1439 [inline]
 __se_sys_open fs/open.c:1435 [inline]
 __x64_sys_open+0x225/0x270 fs/open.c:1435
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4a1e867bc9
RSP: 002b:00007f4a1e7fc218 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007f4a1e8f96b8 RCX: 00007f4a1e867bc9
RDX: 0000000000000000 RSI: 000000000010b942 RDI: 0000000020000080
RBP: 00007f4a1e8f96b0 R08: 00007ffee00fdc47 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f4a1e8f96bc
R13: 00007f4a1e8bc0c0 R14: 0031656c69662f2e R15: 0030656c69662f2e
 </TASK>
INFO: task syz-executor292:5264 blocked for more than 144 seconds.
      Not tainted 6.11.0-rc6-syzkaller-00183-gb831f83e40a2 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor292 state:D stack:27952 pid:5264  tgid:5251  ppid:5246   flags:0x00004006
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
 inode_lock include/linux/fs.h:800 [inline]
 open_last_lookups fs/namei.c:3644 [inline]
 path_openat+0x7fb/0x3470 fs/namei.c:3883
 do_filp_open+0x235/0x490 fs/namei.c:3913
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1416
 do_sys_open fs/open.c:1431 [inline]
 __do_sys_open fs/open.c:1439 [inline]
 __se_sys_open fs/open.c:1435 [inline]
 __x64_sys_open+0x225/0x270 fs/open.c:1435
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4a1e867bc9
RSP: 002b:00007f4a1e7fc218 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007f4a1e8f96b8 RCX: 00007f4a1e867bc9
RDX: 0000000000000000 RSI: 000000000010b942 RDI: 0000000020000080
RBP: 00007f4a1e8f96b0 R08: 00007ffee00fdc47 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f4a1e8f96bc
R13: 00007f4a1e8bc0c0 R14: 0031656c69662f2e R15: 0030656c69662f2e
 </TASK>
INFO: task syz-executor292:5265 blocked for more than 145 seconds.
      Not tainted 6.11.0-rc6-syzkaller-00183-gb831f83e40a2 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor292 state:D stack:27952 pid:5265  tgid:5253  ppid:5248   flags:0x00004006
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
 inode_lock include/linux/fs.h:800 [inline]
 open_last_lookups fs/namei.c:3644 [inline]
 path_openat+0x7fb/0x3470 fs/namei.c:3883
 do_filp_open+0x235/0x490 fs/namei.c:3913
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1416
 do_sys_open fs/open.c:1431 [inline]
 __do_sys_open fs/open.c:1439 [inline]
 __se_sys_open fs/open.c:1435 [inline]
 __x64_sys_open+0x225/0x270 fs/open.c:1435
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4a1e867bc9
RSP: 002b:00007f4a1e7fc218 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007f4a1e8f96b8 RCX: 00007f4a1e867bc9
RDX: 0000000000000000 RSI: 000000000010b942 RDI: 0000000020000080
RBP: 00007f4a1e8f96b0 R08: 00007ffee00fdc47 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f4a1e8f96bc
R13: 00007f4a1e8bc0c0 R14: 0031656c69662f2e R15: 0030656c69662f2e
 </TASK>
INFO: task syz-executor292:5266 blocked for more than 146 seconds.
      Not tainted 6.11.0-rc6-syzkaller-00183-gb831f83e40a2 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor292 state:D stack:27928 pid:5266  tgid:5254  ppid:5247   flags:0x00004006
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
 inode_lock include/linux/fs.h:800 [inline]
 open_last_lookups fs/namei.c:3644 [inline]
 path_openat+0x7fb/0x3470 fs/namei.c:3883
 do_filp_open+0x235/0x490 fs/namei.c:3913
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1416
 do_sys_open fs/open.c:1431 [inline]
 __do_sys_open fs/open.c:1439 [inline]
 __se_sys_open fs/open.c:1435 [inline]
 __x64_sys_open+0x225/0x270 fs/open.c:1435
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4a1e867bc9
RSP: 002b:00007f4a1e7fc218 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007f4a1e8f96b8 RCX: 00007f4a1e867bc9
RDX: 0000000000000000 RSI: 000000000010b942 RDI: 0000000020000080
RBP: 00007f4a1e8f96b0 R08: 00007ffee00fdc47 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f4a1e8f96bc
R13: 00007f4a1e8bc0c0 R14: 0031656c69662f2e R15: 0030656c69662f2e
 </TASK>
INFO: task syz-executor292:5262 blocked for more than 147 seconds.
      Not tainted 6.11.0-rc6-syzkaller-00183-gb831f83e40a2 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor292 state:D stack:27320 pid:5262  tgid:5255  ppid:5249   flags:0x00004006
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
 inode_lock include/linux/fs.h:800 [inline]
 open_last_lookups fs/namei.c:3644 [inline]
 path_openat+0x7fb/0x3470 fs/namei.c:3883
 do_filp_open+0x235/0x490 fs/namei.c:3913
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1416
 do_sys_open fs/open.c:1431 [inline]
 __do_sys_open fs/open.c:1439 [inline]
 __se_sys_open fs/open.c:1435 [inline]
 __x64_sys_open+0x225/0x270 fs/open.c:1435
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4a1e867bc9
RSP: 002b:00007f4a1e7fc218 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007f4a1e8f96b8 RCX: 00007f4a1e867bc9
RDX: 0000000000000000 RSI: 000000000010b942 RDI: 0000000020000080
RBP: 00007f4a1e8f96b0 R08: 00007ffee00fdc47 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f4a1e8f96bc
R13: 00007f4a1e8bc0c0 R14: 0031656c69662f2e R15: 0030656c69662f2e
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/30:
 #0: ffffffff8e738320 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:326 [inline]
 #0: ffffffff8e738320 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #0: ffffffff8e738320 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6626
1 lock held by kswapd0/89:
2 locks held by getty/4976:
 #0: ffff88803030c0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000312b2f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6ac/0x1e00 drivers/tty/n_tty.c:2211
2 locks held by syz-executor292/5257:
1 lock held by syz-executor292/5263:
 #0: ffff8880783006c0 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: inode_lock include/linux/fs.h:800 [inline]
 #0: ffff8880783006c0 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: open_last_lookups fs/namei.c:3644 [inline]
 #0: ffff8880783006c0 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: path_openat+0x7fb/0x3470 fs/namei.c:3883
1 lock held by syz-executor292/5256:
1 lock held by syz-executor292/5264:
 #0: ffff888078300180 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: inode_lock include/linux/fs.h:800 [inline]
 #0: ffff888078300180 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: open_last_lookups fs/namei.c:3644 [inline]
 #0: ffff888078300180 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: path_openat+0x7fb/0x3470 fs/namei.c:3883
1 lock held by syz-executor292/5258:
1 lock held by syz-executor292/5265:
 #0: ffff8880783c06c0 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: inode_lock include/linux/fs.h:800 [inline]
 #0: ffff8880783c06c0 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: open_last_lookups fs/namei.c:3644 [inline]
 #0: ffff8880783c06c0 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: path_openat+0x7fb/0x3470 fs/namei.c:3883
1 lock held by syz-executor292/5259:
1 lock held by syz-executor292/5266:
 #0: ffff888078300c00 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: inode_lock include/linux/fs.h:800 [inline]
 #0: ffff888078300c00 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: open_last_lookups fs/namei.c:3644 [inline]
 #0: ffff888078300c00 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: path_openat+0x7fb/0x3470 fs/namei.c:3883
2 locks held by syz-executor292/5260:
1 lock held by syz-executor292/5262:
 #0: ffff8880783c0180 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: inode_lock include/linux/fs.h:800 [inline]
 #0: ffff8880783c0180 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: open_last_lookups fs/namei.c:3644 [inline]
 #0: ffff8880783c0180 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: path_openat+0x7fb/0x3470 fs/namei.c:3883

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.11.0-rc6-syzkaller-00183-gb831f83e40a2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:223 [inline]
 watchdog+0xff4/0x1040 kernel/hung_task.c:379
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 5259 Comm: syz-executor292 Not tainted 6.11.0-rc6-syzkaller-00183-gb831f83e40a2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x70 kernel/kcov.c:209
Code: 89 fb e8 23 00 00 00 48 8b 3d bc 26 75 0c 48 89 de 5b e9 53 75 58 00 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <f3> 0f 1e fa 48 8b 04 24 65 48 8b 0c 25 c0 d6 03 00 65 8b 15 50 4a
RSP: 0018:ffffc90003796ee0 EFLAGS: 00000246
RAX: ffffffff90106f08 RBX: ffffffff90106f0c RCX: ffff88807f0ebc00
RDX: 0000000000000000 RSI: ffffffff82086c46 RDI: ffffffff82086c88
RBP: ffffffff82086c88 R08: ffffffff81412c60 R09: ffffc900037970b0
R10: 0000000000000003 R11: ffffffff817f2f30 R12: ffffffff90106f08
R13: ffffffff90106f08 R14: ffffffff82086c46 R15: ffffffff90106f08
FS:  00007f4a1e81d6c0(0000) GS:ffff8880b8900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000559ac1abfe30 CR3: 00000000287e6000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 __orc_find arch/x86/kernel/unwind_orc.c:99 [inline]
 orc_find arch/x86/kernel/unwind_orc.c:227 [inline]
 unwind_next_frame+0x531/0x2a00 arch/x86/kernel/unwind_orc.c:494
 arch_stack_walk+0x151/0x1b0 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x118/0x1d0 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 unpoison_slab_object mm/kasan/common.c:312 [inline]
 __kasan_slab_alloc+0x66/0x80 mm/kasan/common.c:338
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slub.c:3992 [inline]
 slab_alloc_node mm/slub.c:4041 [inline]
 kmem_cache_alloc_noprof+0x135/0x2a0 mm/slub.c:4048
 alloc_buffer_head+0x2a/0x290 fs/buffer.c:3025
 folio_alloc_buffers+0x241/0x5b0 fs/buffer.c:929
 create_empty_buffers+0x3a/0x740 fs/buffer.c:1671
 block_read_full_folio+0x25c/0xcd0 fs/buffer.c:2387
 filemap_read_folio+0x1a0/0x790 mm/filemap.c:2355
 do_read_cache_folio+0x134/0x820 mm/filemap.c:3789
 do_read_cache_page+0x30/0x200 mm/filemap.c:3855
 read_mapping_page include/linux/pagemap.h:907 [inline]
 dir_get_page fs/sysv/dir.c:64 [inline]
 sysv_find_entry+0x1af/0x410 fs/sysv/dir.c:157
 sysv_inode_by_name+0x98/0x1f0 fs/sysv/dir.c:374
 sysv_lookup+0x6b/0xe0 fs/sysv/namei.c:38
 lookup_open fs/namei.c:3556 [inline]
 open_last_lookups fs/namei.c:3647 [inline]
 path_openat+0x11cc/0x3470 fs/namei.c:3883
 do_filp_open+0x235/0x490 fs/namei.c:3913
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1416
 do_sys_open fs/open.c:1431 [inline]
 __do_sys_openat fs/open.c:1447 [inline]
 __se_sys_openat fs/open.c:1442 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1442
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4a1e867bc9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4a1e81d218 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f4a1e8f96a8 RCX: 00007f4a1e867bc9
RDX: 0000000000000800 RSI: 0000000020000240 RDI: 00000000ffffff9c
RBP: 00007f4a1e8f96a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000039 R11: 0000000000000246 R12: 00007f4a1e8f96ac
R13: 00007f4a1e8bc0c0 R14: 0031656c69662f2e R15: 0030656c69662f2e
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 2.204 msecs


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
