Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCD8188A0E
	for <linux-nilfs@vger.kernel.org>; Wed, 30 Apr 2025 07:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745999791; cv=none; b=n2dK1IaOakWlMptcXgRJ91jqUZhblNcLwrpWVGKIOdi5IdVRXGIHO46ZDHCyzPTd+e/rhd6qWf2w2MC1bJVYebtn4uLbBXkgQ2Yb78imtYsUEuhAGLuV6HoGsI8rK8TJ3KhvF1S1uTg8oQc0YNt3Trr91Gj59+uOtaIT3A1h2kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745999791; c=relaxed/simple;
	bh=RszhLQ2p9O753ftdP5ZTcrAl9pu69x1hx1AVesjP6iU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=RgzrCqsAb10hsZ4TYuENiUwRMcqUXGKjrSOR+ysGnnTcWjtw4RmmsbPQ3fDsuwt8yV0LpXeiTvi0s4vI1Uq6JMuGrFlgx0XehgYMpaSfGRRchaTNVlx6I3txXEFo5azHiMNIirTizUpKUFEQMGKfsyM69M23fhMaR05iBmDjZPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-85c552b10b9so630456639f.1
        for <linux-nilfs@vger.kernel.org>; Wed, 30 Apr 2025 00:56:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745999789; x=1746604589;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gp8rAvLAmfy0NJCQzYnwm1r1iXTxdGiBnxsm8zao6vY=;
        b=dR67r3vLxneay18xdXgVpzDBchye8ykzQfOVXKH5M9q1Kz7BGEvHZJYUCCDTbvPW8Y
         qPuRxTYAQ5jlel1NRtNWdrqlg57FK97Yi3INEKvp6dwLd2VmhvZMT4DOummdRwNm3noG
         yGDg3++RbXi9+idHVsJd6naTjLPBunGjsQAsWyNAvpWmNrSqcuKPUlOeO4xyP3SoKJkz
         4t/jCC8vLl1c1Tm9wM/HTCUzh4+cRpIrjx6VXhZ6QpvlzyMjdFppYSaHYATY+MxqL3xj
         gvRZHV3fXp4Q+zVlXPlNwvwuYXtHx0g96uRh9mTzEFmKTsXcPZ2GYhDseBFVdlNfYXXk
         whEg==
X-Forwarded-Encrypted: i=1; AJvYcCUwwdYV1Ijw4MUbGNZslwHogX9SBwFGQQh53jgiMsRhTqnGntu34b7oWUEqN0Rpbc/iqPQMddQMYoPQgg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwQq/WX0f6fOiv9OCFzkaCxAqEULW2tQ3AF09RHgHGIGv7/+Rjp
	qsivWp4UdEle6RdTDpQ8PjRdhSQ6Mkjp4MWRXwcFFMV+GKE008r9sn0m8Gt678BXRBkeA1Ejgkc
	ssvqnuS66ShfcTj6KKS0WH5wGIV6xfXMBpIqE6If65VzowNjVL95ujeE=
X-Google-Smtp-Source: AGHT+IEsuzlP49aU25bLG0Ked4nMxkBgAx4ToAW5PVYFXtFOCTitXhEAHRGvCM5qlxhAt8HbMSoCWumiNZMmNnUsVk+xVS9N9Bk1
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:7287:b0:855:5e3a:e56b with SMTP id
 ca18e2360f4ac-86495f0f3cfmr285730039f.12.1745999788957; Wed, 30 Apr 2025
 00:56:28 -0700 (PDT)
Date: Wed, 30 Apr 2025 00:56:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6811d7ac.050a0220.16fb2c.000b.GAE@google.com>
Subject: [syzbot] [nilfs?] possible deadlock in nilfs_page_mkwrite (2)
From: syzbot <syzbot+3f86ff971bc63d62b932@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ca91b9500108 Merge tag 'v6.15-rc4-ksmbd-server-fixes' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=175868d4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a42a9d552788177b
dashboard link: https://syzkaller.appspot.com/bug?extid=3f86ff971bc63d62b932
compiler:       Debian clang version 20.1.2 (++20250402124445+58df0ef89dd6-1~exp1~20250402004600.97), Debian LLD 20.1.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8f91302b28da/disk-ca91b950.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/99926b0845ed/vmlinux-ca91b950.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ace62028a7c9/bzImage-ca91b950.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3f86ff971bc63d62b932@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.15.0-rc4-syzkaller-00021-gca91b9500108 #0 Not tainted
------------------------------------------------------
syz.0.145/7282 is trying to acquire lock:
ffff88806be68610 (sb_internal#4){.+.+}-{0:0}, at: nilfs_page_mkwrite+0x8b0/0xc20 fs/nilfs2/file.c:95

but task is already holding lock:
ffff88806be68518 (sb_pagefaults#4){.+.+}-{0:0}, at: do_page_mkwrite+0x14a/0x310 mm/memory.c:3287

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #5 (sb_pagefaults#4){.+.+}-{0:0}:
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
       handle_mm_fault+0x2d5/0x7f0 mm/memory.c:6309
       faultin_page mm/gup.c:1193 [inline]
       __get_user_pages+0x16f0/0x2a40 mm/gup.c:1491
       __get_user_pages_locked mm/gup.c:1821 [inline]
       __gup_longterm_locked+0x105d/0x15b0 mm/gup.c:2523
       gup_fast_fallback+0x1843/0x1d60 mm/gup.c:3417
       iov_iter_extract_user_pages lib/iov_iter.c:1849 [inline]
       iov_iter_extract_pages+0x35a/0x5e0 lib/iov_iter.c:1912
       dio_refill_pages fs/direct-io.c:172 [inline]
       dio_get_page fs/direct-io.c:213 [inline]
       do_direct_IO fs/direct-io.c:915 [inline]
       __blockdev_direct_IO+0x10ed/0x3310 fs/direct-io.c:1243
       blockdev_direct_IO include/linux/fs.h:3422 [inline]
       nilfs_direct_IO+0xed/0x120 fs/nilfs2/inode.c:267
       generic_file_read_iter+0x319/0x510 mm/filemap.c:2871
       new_sync_read fs/read_write.c:489 [inline]
       vfs_read+0x4cd/0x980 fs/read_write.c:570
       ksys_read+0x145/0x250 fs/read_write.c:713
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #4 (&mm->mmap_lock){++++}-{4:4}:
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

-> #3 (&sb->s_type->i_mutex_key#7){++++}-{4:4}:
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

-> #2 (&nilfs->ns_sem){++++}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1577
       nilfs_set_error fs/nilfs2/super.c:92 [inline]
       __nilfs_error+0x1ca/0x4b0 fs/nilfs2/super.c:141
       nilfs_bmap_convert_error fs/nilfs2/bmap.c:35 [inline]
       nilfs_bmap_propagate+0x108/0x130 fs/nilfs2/bmap.c:332
       nilfs_collect_file_data+0x4f/0xd0 fs/nilfs2/segment.c:589
       nilfs_segctor_apply_buffers+0x161/0x330 fs/nilfs2/segment.c:1010
       nilfs_segctor_scan_file+0x68e/0x8e0 fs/nilfs2/segment.c:1059
       nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1254 [inline]
       nilfs_segctor_collect fs/nilfs2/segment.c:1547 [inline]
       nilfs_segctor_do_construct+0x1d46/0x6970 fs/nilfs2/segment.c:2122
       nilfs_segctor_construct+0x17b/0x690 fs/nilfs2/segment.c:2478
       nilfs_segctor_thread_construct fs/nilfs2/segment.c:2586 [inline]
       nilfs_segctor_thread+0x6f7/0xe00 fs/nilfs2/segment.c:2700
       kthread+0x70e/0x8a0 kernel/kthread.c:464
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:153
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #1 (&nilfs->ns_segctor_sem){++++}-{4:4}:
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

-> #0 (sb_internal#4){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3166 [inline]
       check_prevs_add kernel/locking/lockdep.c:3285 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3909
       __lock_acquire+0xaac/0xd20 kernel/locking/lockdep.c:5235
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
       handle_mm_fault+0x2d5/0x7f0 mm/memory.c:6309
       faultin_page mm/gup.c:1193 [inline]
       __get_user_pages+0x16f0/0x2a40 mm/gup.c:1491
       __get_user_pages_locked mm/gup.c:1821 [inline]
       __gup_longterm_locked+0x105d/0x15b0 mm/gup.c:2523
       gup_fast_fallback+0x1843/0x1d60 mm/gup.c:3417
       iov_iter_extract_user_pages lib/iov_iter.c:1849 [inline]
       iov_iter_extract_pages+0x35a/0x5e0 lib/iov_iter.c:1912
       dio_refill_pages fs/direct-io.c:172 [inline]
       dio_get_page fs/direct-io.c:213 [inline]
       do_direct_IO fs/direct-io.c:915 [inline]
       __blockdev_direct_IO+0x10ed/0x3310 fs/direct-io.c:1243
       blockdev_direct_IO include/linux/fs.h:3422 [inline]
       nilfs_direct_IO+0xed/0x120 fs/nilfs2/inode.c:267
       generic_file_read_iter+0x319/0x510 mm/filemap.c:2871
       new_sync_read fs/read_write.c:489 [inline]
       vfs_read+0x4cd/0x980 fs/read_write.c:570
       ksys_read+0x145/0x250 fs/read_write.c:713
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  sb_internal#4 --> &mm->mmap_lock --> sb_pagefaults#4

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(sb_pagefaults#4);
                               lock(&mm->mmap_lock);
                               lock(sb_pagefaults#4);
  rlock(sb_internal#4);

 *** DEADLOCK ***

4 locks held by syz.0.145/7282:
 #0: ffff8880258a0b78 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x247/0x320 fs/file.c:1213
 #1: ffff88805d73c8c0 (&sb->s_type->i_mutex_key#23){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:867 [inline]
 #1: ffff88805d73c8c0 (&sb->s_type->i_mutex_key#23){+.+.}-{4:4}, at: __blockdev_direct_IO+0x318/0x3310 fs/direct-io.c:1140
 #2: ffff88806d6595e0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock_killable include/linux/mmap_lock.h:193 [inline]
 #2: ffff88806d6595e0 (&mm->mmap_lock){++++}-{4:4}, at: __get_user_pages_locked mm/gup.c:1812 [inline]
 #2: ffff88806d6595e0 (&mm->mmap_lock){++++}-{4:4}, at: __gup_longterm_locked+0x1005/0x15b0 mm/gup.c:2523
 #3: ffff88806be68518 (sb_pagefaults#4){.+.+}-{0:0}, at: do_page_mkwrite+0x14a/0x310 mm/memory.c:3287

stack backtrace:
CPU: 1 UID: 0 PID: 7282 Comm: syz.0.145 Not tainted 6.15.0-rc4-syzkaller-00021-gca91b9500108 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/19/2025
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
 handle_mm_fault+0x2d5/0x7f0 mm/memory.c:6309
 faultin_page mm/gup.c:1193 [inline]
 __get_user_pages+0x16f0/0x2a40 mm/gup.c:1491
 __get_user_pages_locked mm/gup.c:1821 [inline]
 __gup_longterm_locked+0x105d/0x15b0 mm/gup.c:2523
 gup_fast_fallback+0x1843/0x1d60 mm/gup.c:3417
 iov_iter_extract_user_pages lib/iov_iter.c:1849 [inline]
 iov_iter_extract_pages+0x35a/0x5e0 lib/iov_iter.c:1912
 dio_refill_pages fs/direct-io.c:172 [inline]
 dio_get_page fs/direct-io.c:213 [inline]
 do_direct_IO fs/direct-io.c:915 [inline]
 __blockdev_direct_IO+0x10ed/0x3310 fs/direct-io.c:1243
 blockdev_direct_IO include/linux/fs.h:3422 [inline]
 nilfs_direct_IO+0xed/0x120 fs/nilfs2/inode.c:267
 generic_file_read_iter+0x319/0x510 mm/filemap.c:2871
 new_sync_read fs/read_write.c:489 [inline]
 vfs_read+0x4cd/0x980 fs/read_write.c:570
 ksys_read+0x145/0x250 fs/read_write.c:713
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f75a3f8e969
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f75a4de1038 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 00007f75a41b6080 RCX: 00007f75a3f8e969
RDX: 0000000000001000 RSI: 0000200000000400 RDI: 0000000000000004
RBP: 00007f75a4010ab1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000001 R14: 00007f75a41b6080 R15: 00007fffacbb86c8
 </TASK>
NILFS error (device loop0): nilfs_bmap_lookup_contig: broken bmap (inode number=2097152)
Remounting filesystem read-only


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
