Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F5826FD88
	for <linux-nilfs@vger.kernel.org>; Thu,  8 May 2025 16:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746721348; cv=none; b=XO9UsftYO6D+wWPWdZ1lF5AKpW1DM3tz0EfvsKnyZS2B3MGD+1g514IOACTJs1Vu6nr66OTA8yE0tPLwNSHvYXLiONESohPjndRFfadRe7Yq5IKpqkKtA7LCfxuPfkGwgP2IJVD4xnWWrm/c7lSQIbWYKplo6H5xcZJ+EnwMNvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746721348; c=relaxed/simple;
	bh=mrsjIDv3OYI8SMmb84JvrCrdEGbeijlrZ5u4z+WQTcA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=IwWKjUk8I0H2g7l5JMnzXTng2XkGumm6dBu0yNSwsRt9a3sW9G4+7YpcBKIYIArHrBUAIj5oQvQ8ikTOlOPWVFOqzEMXjO0BgFpoupBHSbOw3Rbwth2rI+94BfBfeohfFN048vJATV1J1OG7azomRLNaZFKQxGZ54KyVto8tsog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3da707dea42so25498845ab.3
        for <linux-nilfs@vger.kernel.org>; Thu, 08 May 2025 09:22:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746721345; x=1747326145;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=swiHo3/PazECIkroxGIMfS4xFp+4PWXCQQTAhtqVqwM=;
        b=XschI2DKBEyK0Fft9piX2SQiaOQqhAdYGuVAOiTIeNOkguDmsLx3JUG/mn5HJ2vMx6
         s7LVUySTKHZdQvuvvFe4ot6yZrT0sdKhxcxmf3GWYWnp1wue2cq5qpm07ZSQkVT1eBML
         oDHJrvO1b+cmQk7Mw/CqnoVCTwj2hNnJe2m2AA2rj2/EeesUcnmv01zhwrJlM5BtPl5a
         miYiFl+gYFmu3aWsnUAeMhP5LNg63nB0gNDk0cj7TkO2xDZUJlTCPaIVxUPB7fzPmiQU
         XahSt/G+SDpJdd/H1jbzhw+HVTiIVLkK6Spl91VMCWzwAFJaghIol9xVxBY4f36n5T5F
         wM1g==
X-Forwarded-Encrypted: i=1; AJvYcCXhLqT6lOWgOooo9IykL+p2iATQm1k8v2uvTOFNCEU5FOWQKYOycMP3kCCqc+McEBOi4rCKyFQHo4rhMg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwKhtbaXEFwwvPXcnFK9++f5SxsEoOuGvbaXlnUsRr8HW+qRhK6
	bp78DMAnzbIOCK93NLR+VmPXnIz9+s9FnYL0azpfF0yfPi6Zg3iUr9782C6y+klscBJmPmb2NnY
	jkUTA5T8JunFwImqlazB8cc9RfqyMYwjqgcywC3DbYd07BVNvac5RI4M=
X-Google-Smtp-Source: AGHT+IEWQzMkDe2kElFmS/4MJzQD2UVWOXOpJXFUityQsG77kRD0N7888xxla9a3ucVLMMtwX2WWQuxm1hENtF5glntdAXGT+YR4
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3e91:b0:3d3:e287:3e7a with SMTP id
 e9e14a558f8ab-3da7e20d81bmr199475ab.19.1746721345324; Thu, 08 May 2025
 09:22:25 -0700 (PDT)
Date: Thu, 08 May 2025 09:22:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <681cda41.050a0220.a19a9.0118.GAE@google.com>
Subject: [syzbot] [nilfs?] possible deadlock in nilfs_segctor_construct
From: syzbot <syzbot+81394db39b0e2ed2db06@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e8ab83e34bdc Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=146e70f4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a9a25b7a36123454
dashboard link: https://syzkaller.appspot.com/bug?extid=81394db39b0e2ed2db06
compiler:       Debian clang version 20.1.2 (++20250402124445+58df0ef89dd6-1~exp1~20250402004600.97), Debian LLD 20.1.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=148c9a70580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1530b8d4580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-e8ab83e3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b26f15c51ac7/vmlinux-e8ab83e3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/05e91bf788d8/bzImage-e8ab83e3.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/09efd3b532ea/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+81394db39b0e2ed2db06@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.15.0-rc4-syzkaller-00296-ge8ab83e34bdc #0 Not tainted
------------------------------------------------------
segctord/5299 is trying to acquire lock:
ffff88801189e090 (&nilfs->ns_sem){++++}-{4:4}, at: nilfs_segctor_construct+0x2b1/0x690 fs/nilfs2/segment.c:2485

but task is already holding lock:
ffff88801189e2a0 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_lock+0x253/0x4c0 fs/nilfs2/segment.c:357

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #5 (&nilfs->ns_segctor_sem){++++}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
       down_read+0x46/0x2e0 kernel/locking/rwsem.c:1524
       nilfs_transaction_begin+0x365/0x710 fs/nilfs2/segment.c:221
       nilfs_create+0xc9/0x2f0 fs/nilfs2/namei.c:95
       lookup_open fs/namei.c:3701 [inline]
       open_last_lookups fs/namei.c:3800 [inline]
       path_openat+0x14f1/0x3830 fs/namei.c:4036
       do_filp_open+0x1fa/0x410 fs/namei.c:4066
       do_sys_openat2+0x121/0x1c0 fs/open.c:1429
       do_sys_open fs/open.c:1444 [inline]
       __do_sys_openat fs/open.c:1460 [inline]
       __se_sys_openat fs/open.c:1455 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1455
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #4 (sb_internal#2){.+.+}-{0:0}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
       percpu_down_read include/linux/percpu-rwsem.h:52 [inline]
       __sb_start_write include/linux/fs.h:1783 [inline]
       sb_start_intwrite include/linux/fs.h:1966 [inline]
       nilfs_transaction_begin+0x268/0x710 fs/nilfs2/segment.c:218
       nilfs_page_mkwrite+0x8b0/0xc20 fs/nilfs2/file.c:95
       do_page_mkwrite+0x14a/0x310 mm/memory.c:3287
       do_shared_fault mm/memory.c:5594 [inline]
       do_fault mm/memory.c:5656 [inline]
       do_pte_missing mm/memory.c:4160 [inline]
       handle_pte_fault mm/memory.c:5997 [inline]
       __handle_mm_fault+0x18d2/0x5380 mm/memory.c:6140
       handle_mm_fault+0x3f6/0x8c0 mm/memory.c:6309
       do_user_addr_fault+0x764/0x1390 arch/x86/mm/fault.c:1388
       handle_page_fault arch/x86/mm/fault.c:1480 [inline]
       exc_page_fault+0x68/0x110 arch/x86/mm/fault.c:1538
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

-> #3 (sb_pagefaults){.+.+}-{0:0}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
       percpu_down_read include/linux/percpu-rwsem.h:52 [inline]
       __sb_start_write include/linux/fs.h:1783 [inline]
       sb_start_pagefault include/linux/fs.h:1948 [inline]
       nilfs_page_mkwrite+0x21e/0xc20 fs/nilfs2/file.c:57
       do_page_mkwrite+0x14a/0x310 mm/memory.c:3287
       do_shared_fault mm/memory.c:5594 [inline]
       do_fault mm/memory.c:5656 [inline]
       do_pte_missing mm/memory.c:4160 [inline]
       handle_pte_fault mm/memory.c:5997 [inline]
       __handle_mm_fault+0x18d2/0x5380 mm/memory.c:6140
       handle_mm_fault+0x3f6/0x8c0 mm/memory.c:6309
       do_user_addr_fault+0x764/0x1390 arch/x86/mm/fault.c:1388
       handle_page_fault arch/x86/mm/fault.c:1480 [inline]
       exc_page_fault+0x68/0x110 arch/x86/mm/fault.c:1538
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

-> #2 (&mm->mmap_lock){++++}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
       __might_fault+0xcc/0x130 mm/memory.c:7151
       _copy_to_iter+0xf3/0x15a0 lib/iov_iter.c:184
       copy_page_to_iter+0xa7/0x150 lib/iov_iter.c:362
       copy_folio_to_iter include/linux/uio.h:198 [inline]
       filemap_read+0x78d/0x11d0 mm/filemap.c:2753
       blkdev_read_iter+0x30a/0x440 block/fops.c:809
       new_sync_read fs/read_write.c:489 [inline]
       vfs_read+0x4cd/0x980 fs/read_write.c:570
       ksys_read+0x145/0x250 fs/read_write.c:713
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&sb->s_type->i_mutex_key#8){++++}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:867 [inline]
       set_blocksize+0x23b/0x500 block/bdev.c:203
       sb_set_blocksize block/bdev.c:224 [inline]
       sb_min_blocksize+0x119/0x210 block/bdev.c:239
       init_nilfs+0x43/0x690 fs/nilfs2/the_nilfs.c:710
       nilfs_fill_super+0x8f/0x650 fs/nilfs2/super.c:1060
       nilfs_get_tree+0x4f4/0x870 fs/nilfs2/super.c:1228
       vfs_get_tree+0x8f/0x2b0 fs/super.c:1759
       do_new_mount+0x24a/0xa40 fs/namespace.c:3884
       do_mount fs/namespace.c:4224 [inline]
       __do_sys_mount fs/namespace.c:4435 [inline]
       __se_sys_mount+0x317/0x410 fs/namespace.c:4412
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&nilfs->ns_sem){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3166 [inline]
       check_prevs_add kernel/locking/lockdep.c:3285 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3909
       __lock_acquire+0xaac/0xd20 kernel/locking/lockdep.c:5235
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1577
       nilfs_segctor_construct+0x2b1/0x690 fs/nilfs2/segment.c:2485
       nilfs_segctor_thread_construct fs/nilfs2/segment.c:2586 [inline]
       nilfs_segctor_thread+0x6f7/0xe00 fs/nilfs2/segment.c:2700
       kthread+0x70e/0x8a0 kernel/kthread.c:464
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:153
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

Chain exists of:
  &nilfs->ns_sem --> sb_internal#2 --> &nilfs->ns_segctor_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&nilfs->ns_segctor_sem);
                               lock(sb_internal#2);
                               lock(&nilfs->ns_segctor_sem);
  lock(&nilfs->ns_sem);

 *** DEADLOCK ***

1 lock held by segctord/5299:
 #0: ffff88801189e2a0 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_lock+0x253/0x4c0 fs/nilfs2/segment.c:357

stack backtrace:
CPU: 0 UID: 0 PID: 5299 Comm: segctord Not tainted 6.15.0-rc4-syzkaller-00296-ge8ab83e34bdc #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_circular_bug+0x2ee/0x310 kernel/locking/lockdep.c:2079
 check_noncircular+0x134/0x160 kernel/locking/lockdep.c:2211
 check_prev_add kernel/locking/lockdep.c:3166 [inline]
 check_prevs_add kernel/locking/lockdep.c:3285 [inline]
 validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3909
 __lock_acquire+0xaac/0xd20 kernel/locking/lockdep.c:5235
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
 down_write+0x96/0x1f0 kernel/locking/rwsem.c:1577
 nilfs_segctor_construct+0x2b1/0x690 fs/nilfs2/segment.c:2485
 nilfs_segctor_thread_construct fs/nilfs2/segment.c:2586 [inline]
 nilfs_segctor_thread+0x6f7/0xe00 fs/nilfs2/segment.c:2700
 kthread+0x70e/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:153
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
