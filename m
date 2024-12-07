Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5C1823D1
	for <linux-nilfs@vger.kernel.org>; Sat,  7 Dec 2024 09:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733565266; cv=none; b=q16zZT1Ksfq+N7yZhxAzyHLJIr8znpVRCeHwfiVo2w+nfWUyu0NMOBRnXyud0AmaR9XvilDS7Z7ZaoyY8UOEpMYXvYxszrKqqav1aITYBf2LwPlSYwX/stLW7hg1pjtZtqUyJGCXwStKby1SjaIBezDr4VjNnB6ifdx7w6h8DzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733565266; c=relaxed/simple;
	bh=u9wGb17ASdV0B8NdwIq/eJhE34QufYW97MwhU1mAdfA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PjSpkBJTAI28rWtBmdO1a7JbKGYGQUPTMXeo2KtyZoq/RhmjVOts+FJzEp5Azqpy2lxC6jZE8kbK4mcz/48eeMGabyM9O2WCJu6nwf4pcc8kWqRzUpILd5DF/YceEY/1gEx5PlliIqeNmf4jqVxB0EtuhqQiEyz3DWgcwjA96eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3a81828bc7cso5425445ab.3
        for <linux-nilfs@vger.kernel.org>; Sat, 07 Dec 2024 01:54:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733565264; x=1734170064;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kSggsx+iqFcas++QFTyZtwy4xjWtKYfgMIOuDxA72Ec=;
        b=NBAM2Z3YcbXR+S1/86GfjqeYttOiaT0wqD4JuiMlqpbC4ddI+yNaUoRJA3Wh43vh5a
         6chp11OKubASXUqd+tNa7ftaXHBY/q1b6WKcbFML/ZW1vLzIxC6Q/rLI0WP4Wah8oshj
         GJXUsikCcctc0IWhEzmajHM+9SQmUs3V1shlWSGmSpwGnFsEAODivHawFqR61w9tHY02
         U1BQXg7dfz7k5nrZQ4MMSWqk91xWXTLriDtnR+h93ZB50cSfMihj5goGnRHAMN/yfYfI
         DzsLagoLgsGZ6rowD42K9Vd/ummtkNgEowoksVS39adDbgEEivbjiii2Q9eo/LRf6fGH
         tvMA==
X-Forwarded-Encrypted: i=1; AJvYcCVbpml7G7HjoWakmGtHV3Y64IHRtdVH9EiDpr0M82mIs0IwMQPgND/VYsk2B8/ff8NfFE7McreyPznubw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzSVGFHtsyGC1lM0400I2Jcfw/UB4XTAosrmEo0BYiolbyGKgYq
	Hk7W5/+/09nLi2SLp+lvRKul+uUp4J2iYwNAyFSpQs8SfOw0ooHv5ToWPZ6ya50ifIRbvf25Vto
	U9m7uknS2+cSueP1iofMYEIlJ6dmIQM3FazOezxPkv7jstxzKbWrU7Qs=
X-Google-Smtp-Source: AGHT+IEP31vHJe78FU+hJSeCgdxIc3yKTotBVB85gGdHzDX+82CzbqJ1gT9XacMDomVNbK/dLgD5+3yB7xsltlr2HHwQe1mPEkBS
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a22:b0:3a7:e800:7d26 with SMTP id
 e9e14a558f8ab-3a811dc35e7mr61544865ab.8.1733565264156; Sat, 07 Dec 2024
 01:54:24 -0800 (PST)
Date: Sat, 07 Dec 2024 01:54:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67541b50.050a0220.2477f.0013.GAE@google.com>
Subject: [syzbot] [nilfs?] possible deadlock in nilfs_page_mkwrite
From: syzbot <syzbot+992e362a20499e2e3e60@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    cdd30ebb1b9f module: Convert symbol namespace to string li..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=179675e8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ad7dafcfaa48849c
dashboard link: https://syzkaller.appspot.com/bug?extid=992e362a20499e2e3e60
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9acca520618c/disk-cdd30ebb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4fa9e0fa6b05/vmlinux-cdd30ebb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f902822d291c/bzImage-cdd30ebb.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+992e362a20499e2e3e60@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.13.0-rc1-syzkaller-00002-gcdd30ebb1b9f #0 Not tainted
------------------------------------------------------
syz.7.1218/10445 is trying to acquire lock:
ffff888022f78610 (sb_internal#2){.+.+}-{0:0}, at: nilfs_page_mkwrite+0x96c/0xcf0 fs/nilfs2/file.c:95

but task is already holding lock:
ffff888022f78518 (sb_pagefaults#7){.+.+}-{0:0}, at: do_page_mkwrite+0x17a/0x380 mm/memory.c:3176

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #7 (sb_pagefaults#7){.+.+}-{0:0}:
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1725 [inline]
       sb_start_pagefault include/linux/fs.h:1890 [inline]
       nilfs_page_mkwrite+0x24c/0xcf0 fs/nilfs2/file.c:57
       do_page_mkwrite+0x17a/0x380 mm/memory.c:3176
       do_shared_fault mm/memory.c:5398 [inline]
       do_fault mm/memory.c:5460 [inline]
       do_pte_missing+0x29e/0x3e70 mm/memory.c:3979
       handle_pte_fault mm/memory.c:5801 [inline]
       __handle_mm_fault+0x103c/0x2a40 mm/memory.c:5944
       handle_mm_fault+0x3fa/0xaa0 mm/memory.c:6112
       do_user_addr_fault+0x7a3/0x13f0 arch/x86/mm/fault.c:1389
       handle_page_fault arch/x86/mm/fault.c:1481 [inline]
       exc_page_fault+0x5c/0xc0 arch/x86/mm/fault.c:1539
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

-> #6 (&mm->mmap_lock){++++}-{4:4}:
       __might_fault mm/memory.c:6751 [inline]
       __might_fault+0x11b/0x190 mm/memory.c:6744
       _inline_copy_from_user include/linux/uaccess.h:162 [inline]
       _copy_from_user+0x29/0xd0 lib/usercopy.c:18
       copy_from_user include/linux/uaccess.h:212 [inline]
       __blk_trace_setup+0xa8/0x180 kernel/trace/blktrace.c:626
       blk_trace_ioctl+0x163/0x290 kernel/trace/blktrace.c:740
       blkdev_ioctl+0x109/0x6d0 block/ioctl.c:682
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl fs/ioctl.c:892 [inline]
       __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #5 (&q->debugfs_mutex){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x19b/0xa60 kernel/locking/mutex.c:735
       blk_mq_init_sched+0x42b/0x640 block/blk-mq-sched.c:473
       elevator_init_mq+0x2cd/0x420 block/elevator.c:610
       add_disk_fwnode+0x113/0x1300 block/genhd.c:413
       sd_probe+0xa86/0x1000 drivers/scsi/sd.c:4024
       call_driver_probe drivers/base/dd.c:579 [inline]
       really_probe+0x241/0xa90 drivers/base/dd.c:658
       __driver_probe_device+0x1de/0x440 drivers/base/dd.c:800
       driver_probe_device+0x4c/0x1b0 drivers/base/dd.c:830
       __device_attach_driver+0x1df/0x310 drivers/base/dd.c:958
       bus_for_each_drv+0x15a/0x1e0 drivers/base/bus.c:459
       __device_attach_async_helper+0x1d3/0x290 drivers/base/dd.c:987
       async_run_entry_fn+0x9f/0x530 kernel/async.c:129
       process_one_work+0x9c8/0x1ba0 kernel/workqueue.c:3229
       process_scheduled_works kernel/workqueue.c:3310 [inline]
       worker_thread+0x6c8/0xf00 kernel/workqueue.c:3391
       kthread+0x2c4/0x3a0 kernel/kthread.c:389
       ret_from_fork+0x48/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #4 (&q->q_usage_counter(queue)#50){++++}-{0:0}:
       blk_queue_enter+0x50f/0x640 block/blk-core.c:328
       blk_mq_alloc_request+0x59b/0x950 block/blk-mq.c:651
       scsi_alloc_request drivers/scsi/scsi_lib.c:1222 [inline]
       scsi_execute_cmd+0x1eb/0xf40 drivers/scsi/scsi_lib.c:304
       read_capacity_16+0x213/0xe10 drivers/scsi/sd.c:2655
       sd_read_capacity drivers/scsi/sd.c:2824 [inline]
       sd_revalidate_disk.isra.0+0x1a06/0xa8d0 drivers/scsi/sd.c:3734
       sd_probe+0x904/0x1000 drivers/scsi/sd.c:4010
       call_driver_probe drivers/base/dd.c:579 [inline]
       really_probe+0x241/0xa90 drivers/base/dd.c:658
       __driver_probe_device+0x1de/0x440 drivers/base/dd.c:800
       driver_probe_device+0x4c/0x1b0 drivers/base/dd.c:830
       __device_attach_driver+0x1df/0x310 drivers/base/dd.c:958
       bus_for_each_drv+0x15a/0x1e0 drivers/base/bus.c:459
       __device_attach_async_helper+0x1d3/0x290 drivers/base/dd.c:987
       async_run_entry_fn+0x9f/0x530 kernel/async.c:129
       process_one_work+0x9c8/0x1ba0 kernel/workqueue.c:3229
       process_scheduled_works kernel/workqueue.c:3310 [inline]
       worker_thread+0x6c8/0xf00 kernel/workqueue.c:3391
       kthread+0x2c4/0x3a0 kernel/kthread.c:389
       ret_from_fork+0x48/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #3 (&q->limits_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x19b/0xa60 kernel/locking/mutex.c:735
       queue_limits_start_update include/linux/blkdev.h:949 [inline]
       loop_reconfigure_limits+0x407/0x8c0 drivers/block/loop.c:998
       loop_set_block_size drivers/block/loop.c:1473 [inline]
       lo_simple_ioctl drivers/block/loop.c:1496 [inline]
       lo_ioctl+0x901/0x18b0 drivers/block/loop.c:1559
       blkdev_ioctl+0x279/0x6d0 block/ioctl.c:693
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl fs/ioctl.c:892 [inline]
       __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&q->q_usage_counter(io)#24){++++}-{0:0}:
       bio_queue_enter block/blk.h:75 [inline]
       blk_mq_submit_bio+0x1fb6/0x24c0 block/blk-mq.c:3091
       __submit_bio+0x384/0x540 block/blk-core.c:629
       __submit_bio_noacct_mq block/blk-core.c:710 [inline]
       submit_bio_noacct_nocheck+0x698/0xd70 block/blk-core.c:739
       submit_bio_noacct+0x93a/0x1e20 block/blk-core.c:868
       nilfs_mdt_submit_block+0x33e/0x870 fs/nilfs2/mdt.c:153
       nilfs_mdt_read_block+0xa4/0x3b0 fs/nilfs2/mdt.c:178
       nilfs_mdt_get_block+0xd8/0xac0 fs/nilfs2/mdt.c:253
       nilfs_palloc_get_block+0xb5/0x300 fs/nilfs2/alloc.c:219
       nilfs_palloc_get_desc_block+0x131/0x180 fs/nilfs2/alloc.c:268
       nilfs_palloc_prepare_alloc_entry+0x21e/0xc50 fs/nilfs2/alloc.c:548
       nilfs_ifile_create_inode+0x129/0x320 fs/nilfs2/ifile.c:62
       nilfs_new_inode+0x207/0x760 fs/nilfs2/inode.c:313
       nilfs_create fs/nilfs2/namei.c:93 [inline]
       nilfs_create+0x121/0x320 fs/nilfs2/namei.c:83
       lookup_open.isra.0+0x1177/0x14c0 fs/namei.c:3649
       open_last_lookups fs/namei.c:3748 [inline]
       path_openat+0x904/0x2d60 fs/namei.c:3984
       do_filp_open+0x20c/0x470 fs/namei.c:4014
       do_sys_openat2+0x17a/0x1e0 fs/open.c:1402
       do_sys_open fs/open.c:1417 [inline]
       __do_sys_open fs/open.c:1425 [inline]
       __se_sys_open fs/open.c:1421 [inline]
       __x64_sys_open+0x154/0x1e0 fs/open.c:1421
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&nilfs->ns_segctor_sem){++++}-{4:4}:
       down_read+0x9a/0x330 kernel/locking/rwsem.c:1524
       nilfs_transaction_begin+0x326/0xa40 fs/nilfs2/segment.c:223
       nilfs_ioctl_set_suinfo fs/nilfs2/ioctl.c:1268 [inline]
       nilfs_ioctl+0x1763/0x1e00 fs/nilfs2/ioctl.c:1391
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl fs/ioctl.c:892 [inline]
       __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (sb_internal#2){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain kernel/locking/lockdep.c:3904 [inline]
       __lock_acquire+0x249e/0x3c40 kernel/locking/lockdep.c:5226
       lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5849
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1725 [inline]
       sb_start_intwrite include/linux/fs.h:1908 [inline]
       nilfs_transaction_begin+0x21b/0xa40 fs/nilfs2/segment.c:220
       nilfs_page_mkwrite+0x96c/0xcf0 fs/nilfs2/file.c:95
       do_page_mkwrite+0x17a/0x380 mm/memory.c:3176
       do_shared_fault mm/memory.c:5398 [inline]
       do_fault mm/memory.c:5460 [inline]
       do_pte_missing+0x29e/0x3e70 mm/memory.c:3979
       handle_pte_fault mm/memory.c:5801 [inline]
       __handle_mm_fault+0x103c/0x2a40 mm/memory.c:5944
       handle_mm_fault+0x3fa/0xaa0 mm/memory.c:6112
       do_user_addr_fault+0x7a3/0x13f0 arch/x86/mm/fault.c:1389
       handle_page_fault arch/x86/mm/fault.c:1481 [inline]
       exc_page_fault+0x5c/0xc0 arch/x86/mm/fault.c:1539
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

other info that might help us debug this:

Chain exists of:
  sb_internal#2 --> &mm->mmap_lock --> sb_pagefaults#7

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(sb_pagefaults#7);
                               lock(&mm->mmap_lock);
                               lock(sb_pagefaults#7);
  rlock(sb_internal#2);

 *** DEADLOCK ***

2 locks held by syz.7.1218/10445:
 #0: ffff88807a8d6d20 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_trylock include/linux/mmap_lock.h:163 [inline]
 #0: ffff88807a8d6d20 (&mm->mmap_lock){++++}-{4:4}, at: get_mmap_lock_carefully mm/memory.c:6149 [inline]
 #0: ffff88807a8d6d20 (&mm->mmap_lock){++++}-{4:4}, at: lock_mm_and_find_vma+0x35/0x6a0 mm/memory.c:6209
 #1: ffff888022f78518 (sb_pagefaults#7){.+.+}-{0:0}, at: do_page_mkwrite+0x17a/0x380 mm/memory.c:3176

stack backtrace:
CPU: 1 UID: 0 PID: 10445 Comm: syz.7.1218 Not tainted 6.13.0-rc1-syzkaller-00002-gcdd30ebb1b9f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_circular_bug+0x419/0x5d0 kernel/locking/lockdep.c:2074
 check_noncircular+0x31a/0x400 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain kernel/locking/lockdep.c:3904 [inline]
 __lock_acquire+0x249e/0x3c40 kernel/locking/lockdep.c:5226
 lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5849
 percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
 __sb_start_write include/linux/fs.h:1725 [inline]
 sb_start_intwrite include/linux/fs.h:1908 [inline]
 nilfs_transaction_begin+0x21b/0xa40 fs/nilfs2/segment.c:220
 nilfs_page_mkwrite+0x96c/0xcf0 fs/nilfs2/file.c:95
 do_page_mkwrite+0x17a/0x380 mm/memory.c:3176
 do_shared_fault mm/memory.c:5398 [inline]
 do_fault mm/memory.c:5460 [inline]
 do_pte_missing+0x29e/0x3e70 mm/memory.c:3979
 handle_pte_fault mm/memory.c:5801 [inline]
 __handle_mm_fault+0x103c/0x2a40 mm/memory.c:5944
 handle_mm_fault+0x3fa/0xaa0 mm/memory.c:6112
 do_user_addr_fault+0x7a3/0x13f0 arch/x86/mm/fault.c:1389
 handle_page_fault arch/x86/mm/fault.c:1481 [inline]
 exc_page_fault+0x5c/0xc0 arch/x86/mm/fault.c:1539
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0033:0x7f0fd0e453e1
Code: 48 8b 54 24 08 48 85 d2 74 17 8b 44 24 18 0f c8 89 c0 48 89 44 24 18 48 83 fa 01 0f 85 b3 01 00 00 48 8b 44 24 10 8b 54 24 18 <89> 10 e9 15 fd ff ff 48 8b 44 24 10 8b 10 48 8b 44 24 08 48 85 c0
RSP: 002b:00007fff411a4cf0 EFLAGS: 00010246
RAX: 0000000020000180 RBX: 0000000000000004 RCX: 0000000000000000
RDX: 00000000000007ff RSI: 0000000000000000 RDI: 000055556d6533c8
RBP: 00007fff411a4e08 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000078d5d
R13: 00007f0fd1145fa0 R14: 0000000000000032 R15: fffffffffffffffe
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
