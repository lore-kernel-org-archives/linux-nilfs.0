Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4531F462F;
	Thu,  8 May 2025 16:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746722252; cv=none; b=M5XNcwSOQxtunbvFH4dMNNkE22361lLgt7Yi7OlE+2p7RYufo3k2UBP+45HH14DlWnJ44S9odHJoFIcNBy1UQFQYPWMS61uOmMfrVZpOb1gGhrwNh1kB3PvEOS2A02P9Jf8ttTyMhArGz7XR01qx/2rRzgtLNtifaRuPHQTv5fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746722252; c=relaxed/simple;
	bh=zgcJas1y1EUPLW/s9cIytdNc36H0/zgCz13n5bf/F9w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GKwyDnGS3uLwhqTPAfqaGP5RjKjLXrjzO/Odhvdq0fKCp3PPcHTnw6f7IRpecNArqLIBMBsftQUcUWK0cWmy449mqieRXbYlb2vKWgKP3Bh6RQA2VsWFjeBjH0GkhAKUjW2Dvq+v+neoNKba0E9SjT4mU3WKurI3SD8aiy7rxig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fUM4e9q1; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fUM4e9q1"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-54afb5fcebaso1573930e87.3;
        Thu, 08 May 2025 09:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746722249; x=1747327049; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/zlE7pTOB/EmXJVS8lFGnGaite7v7cxzH3xi/FHttn0=;
        b=fUM4e9q1lAkHkJQLpY2SzphrP6GdPOyjegceSSw1wOv3Y+ObrzNvBTfuAGQPzW64Ny
         ZN98Uz9RzJF2uAuHeZ8PFugzNHG+BgnqVjTfd7dZkJtEf9YiG42BrVr2yB3W6oKnr3dz
         3Ig79RFnGHbLZNg87MAgj02DzET1ZJF6nmfVfGFKI06etk0FR6S36MPEADucSoLXeM/j
         XMVbT/3eKCHlQ5gzyCSzhxLuZgnp5V0DWh/tdsZe1dbHXAUuJuOElZJfRuOG68KBpnP/
         +v1PU3rB3fON9q2Rm5/gPDZoHCaYk1tmlqKRJOpV7FBFNRj2gHUnZUQvTmk9iRRkbSdb
         XTWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746722249; x=1747327049;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/zlE7pTOB/EmXJVS8lFGnGaite7v7cxzH3xi/FHttn0=;
        b=fRtHyPYKzOkOof7vKBzB5ZgclNtmcwMFxZKVNT5Wi8t9JkxQsAGUowkzfNC9XauAER
         sWfTBsWxXfAPGlyHG7/SEmQNn2JReOBCCAIWr3fAGIEBkLar1HaJ4ohsnB7YUeVB+X54
         JKGe96yML5fZQWhYu3mWLks56eu7Df4fFmh4oLWJIybqmk+7P4q2+aP6v86pZf0U9/te
         QWOHB36eIUaXDloLFknNaVh2kxzE28IO2nzU7pd0Ntmto++jkH5mtLdmTwQJsFoM0hAf
         O+sQHEao9dQODJJdJkvqsOoX/aSJp8+Nk2Q9sD1K9IuP4bYq8mqFZNFNesl99vcpX5z+
         iutA==
X-Forwarded-Encrypted: i=1; AJvYcCV0ZbN8WgGEE7LbqlyVOx1rpvYXptkBKtZT+YElpyBcqNv10v4qj8UFJpBUhkF4HODDvd/gK6Xdb6BSyg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2GioJ2mZAdF4hdhouuKJG1OdoNdRMH0D+owUA8OfGd+LlUJPi
	SSk1P6POpDBjjJvM+dD4Z0Yw1twCjeX0dyGpkAEU1+w701r0nh5ctJJv6F/tRwjy6eyg1BzRxIw
	J/Ct5V7UWcvE+jInHY72/5ISFeeycgFiS
X-Gm-Gg: ASbGncup06sKrsT0Warzq3WscgAm4aM/hLjUuw3EGarIvNOPvzENx32PZrzzBu71xa1
	OTXZXIN8fOqcMqNVG4UWFr1r+UFaiVuUK16urku91FM8P3QRQ1+iAlVByZCdjaH0PQwtiHC4v0y
	VNzVGOCO26/eG2gAuMcJnXNa5vy6U+RhSNMEoC+UqJ51AANhCil05WiWQ=
X-Google-Smtp-Source: AGHT+IEf4Tz6UoCNLLTEOZ1oUNVfzyZ75OsRHM7AIRSbZpcFCzhzUhVGc7tgEPsKJGm6U67MfGg8cPiF1ztFAQo5KsU=
X-Received: by 2002:a2e:a541:0:b0:309:26e8:cb1a with SMTP id
 38308e7fff4ca-326c4620d59mr962741fa.30.1746722248443; Thu, 08 May 2025
 09:37:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <681cda41.050a0220.a19a9.0118.GAE@google.com>
In-Reply-To: <681cda41.050a0220.a19a9.0118.GAE@google.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 9 May 2025 01:37:11 +0900
X-Gm-Features: ATxdqUF_44xJ5V_WHQrrxIne_8NzJxaRCe0vrJ7cTont6tMYgDTEBw9dwmyW3nI
Message-ID: <CAKFNMonPU4PhL6_GAbiXBbOB7vc313JQvw06HgZ_a_t0_OhgbQ@mail.gmail.com>
Subject: Re: [syzbot] [nilfs?] possible deadlock in nilfs_segctor_construct
To: syzbot <syzbot+81394db39b0e2ed2db06@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 9, 2025 at 1:22=E2=80=AFAM syzbot
<syzbot+81394db39b0e2ed2db06@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    e8ab83e34bdc Merge tag 'arm64-fixes' of git://git.kernel.=
o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D146e70f458000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Da9a25b7a36123=
454
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D81394db39b0e2ed=
2db06
> compiler:       Debian clang version 20.1.2 (++20250402124445+58df0ef89dd=
6-1~exp1~20250402004600.97), Debian LLD 20.1.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D148c9a70580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1530b8d458000=
0
>
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7=
feb34a89c2a/non_bootable_disk-e8ab83e3.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/b26f15c51ac7/vmlinu=
x-e8ab83e3.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/05e91bf788d8/b=
zImage-e8ab83e3.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/09efd3b532=
ea/mount_0.gz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+81394db39b0e2ed2db06@syzkaller.appspotmail.com
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> 6.15.0-rc4-syzkaller-00296-ge8ab83e34bdc #0 Not tainted
> ------------------------------------------------------
> segctord/5299 is trying to acquire lock:
> ffff88801189e090 (&nilfs->ns_sem){++++}-{4:4}, at: nilfs_segctor_construc=
t+0x2b1/0x690 fs/nilfs2/segment.c:2485
>
> but task is already holding lock:
> ffff88801189e2a0 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transact=
ion_lock+0x253/0x4c0 fs/nilfs2/segment.c:357
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #5 (&nilfs->ns_segctor_sem){++++}-{4:4}:
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
>        down_read+0x46/0x2e0 kernel/locking/rwsem.c:1524
>        nilfs_transaction_begin+0x365/0x710 fs/nilfs2/segment.c:221
>        nilfs_create+0xc9/0x2f0 fs/nilfs2/namei.c:95
>        lookup_open fs/namei.c:3701 [inline]
>        open_last_lookups fs/namei.c:3800 [inline]
>        path_openat+0x14f1/0x3830 fs/namei.c:4036
>        do_filp_open+0x1fa/0x410 fs/namei.c:4066
>        do_sys_openat2+0x121/0x1c0 fs/open.c:1429
>        do_sys_open fs/open.c:1444 [inline]
>        __do_sys_openat fs/open.c:1460 [inline]
>        __se_sys_openat fs/open.c:1455 [inline]
>        __x64_sys_openat+0x138/0x170 fs/open.c:1455
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> -> #4 (sb_internal#2){.+.+}-{0:0}:
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
>        percpu_down_read include/linux/percpu-rwsem.h:52 [inline]
>        __sb_start_write include/linux/fs.h:1783 [inline]
>        sb_start_intwrite include/linux/fs.h:1966 [inline]
>        nilfs_transaction_begin+0x268/0x710 fs/nilfs2/segment.c:218
>        nilfs_page_mkwrite+0x8b0/0xc20 fs/nilfs2/file.c:95
>        do_page_mkwrite+0x14a/0x310 mm/memory.c:3287
>        do_shared_fault mm/memory.c:5594 [inline]
>        do_fault mm/memory.c:5656 [inline]
>        do_pte_missing mm/memory.c:4160 [inline]
>        handle_pte_fault mm/memory.c:5997 [inline]
>        __handle_mm_fault+0x18d2/0x5380 mm/memory.c:6140
>        handle_mm_fault+0x3f6/0x8c0 mm/memory.c:6309
>        do_user_addr_fault+0x764/0x1390 arch/x86/mm/fault.c:1388
>        handle_page_fault arch/x86/mm/fault.c:1480 [inline]
>        exc_page_fault+0x68/0x110 arch/x86/mm/fault.c:1538
>        asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
>
> -> #3 (sb_pagefaults){.+.+}-{0:0}:
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
>        percpu_down_read include/linux/percpu-rwsem.h:52 [inline]
>        __sb_start_write include/linux/fs.h:1783 [inline]
>        sb_start_pagefault include/linux/fs.h:1948 [inline]
>        nilfs_page_mkwrite+0x21e/0xc20 fs/nilfs2/file.c:57
>        do_page_mkwrite+0x14a/0x310 mm/memory.c:3287
>        do_shared_fault mm/memory.c:5594 [inline]
>        do_fault mm/memory.c:5656 [inline]
>        do_pte_missing mm/memory.c:4160 [inline]
>        handle_pte_fault mm/memory.c:5997 [inline]
>        __handle_mm_fault+0x18d2/0x5380 mm/memory.c:6140
>        handle_mm_fault+0x3f6/0x8c0 mm/memory.c:6309
>        do_user_addr_fault+0x764/0x1390 arch/x86/mm/fault.c:1388
>        handle_page_fault arch/x86/mm/fault.c:1480 [inline]
>        exc_page_fault+0x68/0x110 arch/x86/mm/fault.c:1538
>        asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
>
> -> #2 (&mm->mmap_lock){++++}-{4:4}:
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
>        __might_fault+0xcc/0x130 mm/memory.c:7151
>        _copy_to_iter+0xf3/0x15a0 lib/iov_iter.c:184
>        copy_page_to_iter+0xa7/0x150 lib/iov_iter.c:362
>        copy_folio_to_iter include/linux/uio.h:198 [inline]
>        filemap_read+0x78d/0x11d0 mm/filemap.c:2753
>        blkdev_read_iter+0x30a/0x440 block/fops.c:809
>        new_sync_read fs/read_write.c:489 [inline]
>        vfs_read+0x4cd/0x980 fs/read_write.c:570
>        ksys_read+0x145/0x250 fs/read_write.c:713
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> -> #1 (&sb->s_type->i_mutex_key#8){++++}-{4:4}:
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
>        down_write+0x96/0x1f0 kernel/locking/rwsem.c:1577
>        inode_lock include/linux/fs.h:867 [inline]
>        set_blocksize+0x23b/0x500 block/bdev.c:203
>        sb_set_blocksize block/bdev.c:224 [inline]
>        sb_min_blocksize+0x119/0x210 block/bdev.c:239
>        init_nilfs+0x43/0x690 fs/nilfs2/the_nilfs.c:710
>        nilfs_fill_super+0x8f/0x650 fs/nilfs2/super.c:1060
>        nilfs_get_tree+0x4f4/0x870 fs/nilfs2/super.c:1228
>        vfs_get_tree+0x8f/0x2b0 fs/super.c:1759
>        do_new_mount+0x24a/0xa40 fs/namespace.c:3884
>        do_mount fs/namespace.c:4224 [inline]
>        __do_sys_mount fs/namespace.c:4435 [inline]
>        __se_sys_mount+0x317/0x410 fs/namespace.c:4412
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> -> #0 (&nilfs->ns_sem){++++}-{4:4}:
>        check_prev_add kernel/locking/lockdep.c:3166 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3285 [inline]
>        validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3909
>        __lock_acquire+0xaac/0xd20 kernel/locking/lockdep.c:5235
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
>        down_write+0x96/0x1f0 kernel/locking/rwsem.c:1577
>        nilfs_segctor_construct+0x2b1/0x690 fs/nilfs2/segment.c:2485
>        nilfs_segctor_thread_construct fs/nilfs2/segment.c:2586 [inline]
>        nilfs_segctor_thread+0x6f7/0xe00 fs/nilfs2/segment.c:2700
>        kthread+0x70e/0x8a0 kernel/kthread.c:464
>        ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:153
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> other info that might help us debug this:
>
> Chain exists of:
>   &nilfs->ns_sem --> sb_internal#2 --> &nilfs->ns_segctor_sem
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&nilfs->ns_segctor_sem);
>                                lock(sb_internal#2);
>                                lock(&nilfs->ns_segctor_sem);
>   lock(&nilfs->ns_sem);
>
>  *** DEADLOCK ***
>
> 1 lock held by segctord/5299:
>  #0: ffff88801189e2a0 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_tra=
nsaction_lock+0x253/0x4c0 fs/nilfs2/segment.c:357
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5299 Comm: segctord Not tainted 6.15.0-rc4-syzkaller-0=
0296-ge8ab83e34bdc #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.=
16.3-2~bpo12+1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_circular_bug+0x2ee/0x310 kernel/locking/lockdep.c:2079
>  check_noncircular+0x134/0x160 kernel/locking/lockdep.c:2211
>  check_prev_add kernel/locking/lockdep.c:3166 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3285 [inline]
>  validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3909
>  __lock_acquire+0xaac/0xd20 kernel/locking/lockdep.c:5235
>  lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
>  down_write+0x96/0x1f0 kernel/locking/rwsem.c:1577
>  nilfs_segctor_construct+0x2b1/0x690 fs/nilfs2/segment.c:2485
>  nilfs_segctor_thread_construct fs/nilfs2/segment.c:2586 [inline]
>  nilfs_segctor_thread+0x6f7/0xe00 fs/nilfs2/segment.c:2700
>  kthread+0x70e/0x8a0 kernel/kthread.c:464
>  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:153
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup

This looks a false positive deadlock warning similar to the one in the
syzbot report
below, caused by inode locking introduced in set_blocksize():

#syz dup: possible deadlock in __nilfs_error (3)

A patch to fix this warning is already on its way to the mainline.

Ryusuke Konishi
