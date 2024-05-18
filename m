Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4D33211;
	Sat, 18 May 2024 19:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716060041; cv=none; b=p9GfkLzmZiEb4hfXfQW55+BEBznZauRu4i7Dt1OPE8ng60rAjJcffP7ACS+DPSBW+bXdT6V6veFSAtf+VXZjjfxX3gA6APgUKlAZ5MyRkFJRyvyb7WOF0pVmaW5a8ZuQhaWzd4N8btZv5XM9Id4BCkfrCGCrAqdZY9j/rnMdSs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716060041; c=relaxed/simple;
	bh=No5wsXR97acgio4xrwO89Aj9Zj0i0efzYNZBdPGp85Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hLDUQd4gea45yDd2p+xbwiBlBpsR6AojDi8bnuL2ePLrZk8ntwsjm5Pq6kYWY7ECximWzLsdrnQ6nJIo6KmzPuW1YE3vtiRQICtr73NNKtA1vh4+agOhzDtBLk/7ZEmproZvOxttuJh1+f9TWW007jwtFZ0SL6dRHGCva/WGafU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AQ1FtrOY; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AQ1FtrOY"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-51f60817e34so3581523e87.2;
        Sat, 18 May 2024 12:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716060037; x=1716664837; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rr86DxBQxLfNmh1RErR4I+sUEwZj6b654dy5Y19p538=;
        b=AQ1FtrOYPIZTGGOyXjFJSq3YQYhRE5Cl31uBuANOTwJVaRygCObs59l7CagBxE7NSc
         PeY/Am0ac4W7x2JYemsb55oAAPNyN/e8OD5o9TCkHr0SVKG3OlCDPpRcGaQH3hQh/sP7
         XRztbp/uV96rt1+iPUpgFxHs6PMjv28orh2FWTkewBF4wnYUJHclVYHSmjAlXexHqFiJ
         ynJ5JBqSgr4BeN9CG9upltMwnELxsgguNyKNONJdb09jaqru51zzxtdL2yb+PwbaWC8k
         ldw/ihc793XPGXBWfj/6qO/XGhDiiczLtvdkivNf01mxcxNw0ZGAqUru6kXQ1ZUYNM8T
         9NAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716060037; x=1716664837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rr86DxBQxLfNmh1RErR4I+sUEwZj6b654dy5Y19p538=;
        b=or8iOkqpAtEuUiJTKLP3UZt9NQ5KqhAcFjOowYPzwY1x6ExusJKS0SPJBIW0O+wY8o
         CQxibm3lsho7+aTuB+ATKBI0rUMN9caMlE/Glbz05vVhAlpP0d9Bsp0DkSPm1ho5hKjY
         zwrzVvLGPIpKpZwDtM33RDLtbc829kCDBsDgStcdNZYLr79th11SWH3q2pUwoaIfNIpa
         Tu23xrn06szAdITBPKAWcDZRNaPnDUdVMKEwijSrsyFgagaBQ6ZJi5j5rJLtoV22M6ay
         0WT4ph3tsSe11x9UWLq+5mGwRAA4Uv+ZJBwGcERPLFtV8s/H8RKIBIdT9NFEPcdatoLW
         z/nw==
X-Forwarded-Encrypted: i=1; AJvYcCXMWDoteYg1hXaxSBLMMpO+Q94J4xEfafPylqAJxnQW65P9o1F7oHp8c5WW8sTpc2bEbyM3iFQzkwzLLro9R+WjRSRkRxTkcUm8xPM=
X-Gm-Message-State: AOJu0YxWOXGiUUNym59q/iPpbNsU5TK1UqiEhTFcbwY+OHwZnSvgy5Ct
	lJrh1VDhW4MGm+yFgN87aN4tSOBcypmaQZwLhtutSK6qQYX3JfHcGaGM3sn/9SWty3SB/OkMWc4
	fPYeSA46R2Rgk2e2xn9oVDpjzlufVsCPn
X-Google-Smtp-Source: AGHT+IHZB5TTLErEIhgmOlsK8PlR4vl3sobYNtsMVm5XO80teP+Lc+BgTScz0E/npoKYBxk6MybLUz9FzZpqkIRrbS8=
X-Received: by 2002:ac2:592f:0:b0:523:89b0:9b64 with SMTP id
 2adb3069b0e04-52389b09bbdmr8010502e87.7.1716060037160; Sat, 18 May 2024
 12:20:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0000000000001e3b5d0618befc84@google.com>
In-Reply-To: <0000000000001e3b5d0618befc84@google.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Sun, 19 May 2024 04:20:20 +0900
Message-ID: <CAKFNMo=mGh9i7eqeg1WU__vYZZHV71fYj9A+6E-R8rvba5nbBA@mail.gmail.com>
Subject: Re: [syzbot] [nilfs?] possible deadlock in nilfs_evict_inode (2)
To: syzbot <syzbot+c48f1971ba117125f94c@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 19, 2024 at 3:53=E2=80=AFAM syzbot
<syzbot+c48f1971ba117125f94c@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    6bfd2d442af5 Merge tag 'irq-core-2024-05-12' of git://git=
...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D13aefc2098000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D395546166dcfe=
360
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dc48f1971ba11712=
5f94c
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for D=
ebian) 2.40
> userspace arch: i386
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7=
bc7510fe41f/non_bootable_disk-6bfd2d44.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/7ad901fe99c6/vmlinu=
x-6bfd2d44.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/8d6ef2df621f/b=
zImage-6bfd2d44.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+c48f1971ba117125f94c@syzkaller.appspotmail.com
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> 6.9.0-syzkaller-01893-g6bfd2d442af5 #0 Not tainted
> ------------------------------------------------------
> kswapd0/111 is trying to acquire lock:
> ffff888018e7e610 (sb_internal#4){.+.+}-{0:0}, at: nilfs_evict_inode+0x157=
/0x550 fs/nilfs2/inode.c:924
>
> but task is already holding lock:
> ffffffff8d9390c0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x166/0x1a10=
 mm/vmscan.c:6782
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #2 (fs_reclaim){+.+.}-{0:0}:
>        __fs_reclaim_acquire mm/page_alloc.c:3698 [inline]
>        fs_reclaim_acquire+0x102/0x160 mm/page_alloc.c:3712
>        might_alloc include/linux/sched/mm.h:312 [inline]
>        prepare_alloc_pages.constprop.0+0x155/0x560 mm/page_alloc.c:4346
>        __alloc_pages+0x194/0x2460 mm/page_alloc.c:4564
>        alloc_pages_mpol+0x275/0x610 mm/mempolicy.c:2264
>        folio_alloc+0x1e/0x40 mm/mempolicy.c:2342
>        filemap_alloc_folio+0x3ba/0x490 mm/filemap.c:984
>        __filemap_get_folio+0x527/0xa90 mm/filemap.c:1926
>        pagecache_get_page+0x2c/0x260 mm/folio-compat.c:93
>        block_write_begin+0x38/0x4a0 fs/buffer.c:2209
>        nilfs_write_begin+0x9f/0x1a0 fs/nilfs2/inode.c:262
>        page_symlink+0x356/0x450 fs/namei.c:5236
>        nilfs_symlink+0x23c/0x3c0 fs/nilfs2/namei.c:153
>        vfs_symlink fs/namei.c:4489 [inline]
>        vfs_symlink+0x3e8/0x630 fs/namei.c:4473
>        do_symlinkat+0x263/0x310 fs/namei.c:4515
>        __do_sys_symlink fs/namei.c:4536 [inline]
>        __se_sys_symlink fs/namei.c:4534 [inline]
>        __ia32_sys_symlink+0x78/0xa0 fs/namei.c:4534
>        do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
>        __do_fast_syscall_32+0x75/0x120 arch/x86/entry/common.c:386
>        do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
>        entry_SYSENTER_compat_after_hwframe+0x84/0x8e
>
> -> #1 (&nilfs->ns_segctor_sem){++++}-{3:3}:
>        down_read+0x9a/0x330 kernel/locking/rwsem.c:1526
>        nilfs_transaction_begin+0x326/0xa40 fs/nilfs2/segment.c:223
>        nilfs_symlink+0x114/0x3c0 fs/nilfs2/namei.c:140
>        vfs_symlink fs/namei.c:4489 [inline]
>        vfs_symlink+0x3e8/0x630 fs/namei.c:4473
>        do_symlinkat+0x263/0x310 fs/namei.c:4515
>        __do_sys_symlink fs/namei.c:4536 [inline]
>        __se_sys_symlink fs/namei.c:4534 [inline]
>        __ia32_sys_symlink+0x78/0xa0 fs/namei.c:4534
>        do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
>        __do_fast_syscall_32+0x75/0x120 arch/x86/entry/common.c:386
>        do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
>        entry_SYSENTER_compat_after_hwframe+0x84/0x8e
>
> -> #0 (sb_internal#4){.+.+}-{0:0}:
>        check_prev_add kernel/locking/lockdep.c:3134 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3253 [inline]
>        validate_chain kernel/locking/lockdep.c:3869 [inline]
>        __lock_acquire+0x2478/0x3b30 kernel/locking/lockdep.c:5137
>        lock_acquire kernel/locking/lockdep.c:5754 [inline]
>        lock_acquire+0x1b1/0x560 kernel/locking/lockdep.c:5719
>        percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
>        __sb_start_write include/linux/fs.h:1661 [inline]
>        sb_start_intwrite include/linux/fs.h:1844 [inline]
>        nilfs_transaction_begin+0x21b/0xa40 fs/nilfs2/segment.c:220
>        nilfs_evict_inode+0x157/0x550 fs/nilfs2/inode.c:924
>        evict+0x2ed/0x6c0 fs/inode.c:667
>        iput_final fs/inode.c:1741 [inline]
>        iput.part.0+0x5a8/0x7f0 fs/inode.c:1767
>        iput+0x5c/0x80 fs/inode.c:1757
>        dentry_unlink_inode+0x295/0x440 fs/dcache.c:400
>        __dentry_kill+0x1d0/0x600 fs/dcache.c:603
>        shrink_kill fs/dcache.c:1048 [inline]
>        shrink_dentry_list+0x140/0x5d0 fs/dcache.c:1075
>        prune_dcache_sb+0xeb/0x150 fs/dcache.c:1156
>        super_cache_scan+0x32a/0x550 fs/super.c:221
>        do_shrink_slab+0x44f/0x11c0 mm/shrinker.c:435
>        shrink_slab_memcg mm/shrinker.c:548 [inline]
>        shrink_slab+0xa87/0x1310 mm/shrinker.c:626
>        shrink_one+0x493/0x7c0 mm/vmscan.c:4774
>        shrink_many mm/vmscan.c:4835 [inline]
>        lru_gen_shrink_node+0x89f/0x1750 mm/vmscan.c:4935
>        shrink_node mm/vmscan.c:5894 [inline]
>        kswapd_shrink_node mm/vmscan.c:6704 [inline]
>        balance_pgdat+0x10d1/0x1a10 mm/vmscan.c:6895
>        kswapd+0x5ea/0xbf0 mm/vmscan.c:7164
>        kthread+0x2c1/0x3a0 kernel/kthread.c:388
>        ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>
> other info that might help us debug this:
>
> Chain exists of:
>   sb_internal#4 --> &nilfs->ns_segctor_sem --> fs_reclaim
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(fs_reclaim);
>                                lock(&nilfs->ns_segctor_sem);
>                                lock(fs_reclaim);
>   rlock(sb_internal#4);
>
>  *** DEADLOCK ***
>
> 2 locks held by kswapd0/111:
>  #0: ffffffff8d9390c0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x166/0=
x1a10 mm/vmscan.c:6782
>  #1: ffff888018e7e0e0 (&type->s_umount_key#74){++++}-{3:3}, at: super_try=
lock_shared fs/super.c:561 [inline]
>  #1: ffff888018e7e0e0 (&type->s_umount_key#74){++++}-{3:3}, at: super_cac=
he_scan+0x96/0x550 fs/super.c:196
>
> stack backtrace:
> CPU: 2 PID: 111 Comm: kswapd0 Not tainted 6.9.0-syzkaller-01893-g6bfd2d44=
2af5 #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:114
>  check_noncircular+0x31a/0x400 kernel/locking/lockdep.c:2187
>  check_prev_add kernel/locking/lockdep.c:3134 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3253 [inline]
>  validate_chain kernel/locking/lockdep.c:3869 [inline]
>  __lock_acquire+0x2478/0x3b30 kernel/locking/lockdep.c:5137
>  lock_acquire kernel/locking/lockdep.c:5754 [inline]
>  lock_acquire+0x1b1/0x560 kernel/locking/lockdep.c:5719
>  percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
>  __sb_start_write include/linux/fs.h:1661 [inline]
>  sb_start_intwrite include/linux/fs.h:1844 [inline]
>  nilfs_transaction_begin+0x21b/0xa40 fs/nilfs2/segment.c:220
>  nilfs_evict_inode+0x157/0x550 fs/nilfs2/inode.c:924
>  evict+0x2ed/0x6c0 fs/inode.c:667
>  iput_final fs/inode.c:1741 [inline]
>  iput.part.0+0x5a8/0x7f0 fs/inode.c:1767
>  iput+0x5c/0x80 fs/inode.c:1757
>  dentry_unlink_inode+0x295/0x440 fs/dcache.c:400
>  __dentry_kill+0x1d0/0x600 fs/dcache.c:603
>  shrink_kill fs/dcache.c:1048 [inline]
>  shrink_dentry_list+0x140/0x5d0 fs/dcache.c:1075
>  prune_dcache_sb+0xeb/0x150 fs/dcache.c:1156
>  super_cache_scan+0x32a/0x550 fs/super.c:221
>  do_shrink_slab+0x44f/0x11c0 mm/shrinker.c:435
>  shrink_slab_memcg mm/shrinker.c:548 [inline]
>  shrink_slab+0xa87/0x1310 mm/shrinker.c:626
>  shrink_one+0x493/0x7c0 mm/vmscan.c:4774
>  shrink_many mm/vmscan.c:4835 [inline]
>  lru_gen_shrink_node+0x89f/0x1750 mm/vmscan.c:4935
>  shrink_node mm/vmscan.c:5894 [inline]
>  kswapd_shrink_node mm/vmscan.c:6704 [inline]
>  balance_pgdat+0x10d1/0x1a10 mm/vmscan.c:6895
>  kswapd+0x5ea/0xbf0 mm/vmscan.c:7164
>  kthread+0x2c1/0x3a0 kernel/kthread.c:388
>  ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
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
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup

Similarly, it seems to have the same root as the report below, but I
can't confirm it right now, so I'll leave it now.

https://syzkaller.appspot.com/bug?extid=3Dca73f5a22aec76875d85

Similarly, the GFP flags on the symlink's page cache allocation
appears to be causing this circular lock dependency.

Ryusuke Konishi
