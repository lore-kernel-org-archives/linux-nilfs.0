Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BAE1A2C15;
	Thu,  4 Jul 2024 16:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720111223; cv=none; b=uqy5krrfd2n7F/L5IF4uEVQrUtjM0+JWE83xhmC1+oUXCra8IwpqbjfdLwak0f0MjGMPicqQ5VWhNa35/DFt/hSpGaCM7wJIZ+3x+Togc+ntpGCxddYjWUlVkR/ykvDLDRhaN/s9Ih74wZZ3vhxIUXjRcPBnnge7n89yejs5cwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720111223; c=relaxed/simple;
	bh=41UXaRJjgP+Gz1ludXOqNI4cxR2RlwQR+jdGN/bcEUQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qGR/AGcGfbf3hgBZ71GY3yfqnVJHuP59q9z6ACNPW4J/IImTnaXeqmt75ZDrMZm2q28EZOkuXqK7DLAa2djAYLOcxFN13j9hv8iwz18IZMMfgk/K+W/bc4a/cZTQtRwn+p26Xhybu/e2WeSKnACB30jxgLVMG1E2tSmAVP3egIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UQ/MoKHc; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UQ/MoKHc"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2ec408c6d94so8760301fa.3;
        Thu, 04 Jul 2024 09:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720111219; x=1720716019; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P1vS7ohFSaqw+3sp5ohDiY8Mw+qtd3hUBf+qCH0KNkI=;
        b=UQ/MoKHcgWzmuqxr7Q/wCHwOBeq6Jte0PWN5yy8vp8I5e2/lnYQTh0MUtzdGCCPu3V
         PqDnq/86yzwCbrwxjQsQ4ChKH2ZDRtI03pdLD2+pymt/7LK3nQl4lx+KlgsZ1VftazdN
         C1N/4Mk26mY38CSlcZj8FLGqnv1dp7nuh/807UoC6jzOj4U0/fWQRHlklkEFAoUY/VTF
         CSABl9HRiCnADz6H5cgKCh3Pg0ekblA/RaDHi1fHFfIKKcQd3zolBHOjDaK3JbZtoXZi
         XSnS1yzw8MDJ05mk4oi6TuqT5n80TgMkSH5TfwuKSeYEwFvqMdW5MTa3EJxg1AorRhr3
         Z/Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720111219; x=1720716019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P1vS7ohFSaqw+3sp5ohDiY8Mw+qtd3hUBf+qCH0KNkI=;
        b=HoJfPnzItBcAqR2I64kSrBMWlpCmnyQeLvBhwD48jvGaJdGo6rpJueMb/WMsGKFara
         VMa2nBAxuIlVdXxKmiM6AQSrew0QSjlmRnQzQ0oM3A1jYJX+b3yC6mXjVgZ03rAzs2Vo
         p17cQvIpSKw9i9CT8C6yqgNnw7E0VKcLSVlvXgZsKqTuUDFc9V1yb0V9B9nUQjo+4SUe
         /gdOVVsxzfaZmkT9F+48KKcHTHBHqoTTyxAMvj2OMWQqYXUxNm2sqd4XTekOXwY6H9A7
         W9wdGTfeiL5edRYpZuh5j8v4p7koLzNw4CwWnuQUx/T+cGea10qg+X6j9ytYFZ2jIhSu
         obsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKdd4BiJYcSqhNaaoe0V/KVyec91t+vUzje0oOhPzxk4OVfpcwn7Uccv2lMuBhHbCvh1PwpjVLuTNaN9hZU6vs51O461YUl4fdzok=
X-Gm-Message-State: AOJu0YygEgkaQUh7VArdQwmgdlOwLts7H+6vY2pVOdyP/1291PE6BRRj
	wh+pW8qWgb+jDYi1ED4DXdaeZnGWL/sm1v9R+iCIcTsEMuFAOxx1H6p+U6DvI5fX/R9oAXPz85h
	7a7nDuqdxkpER2xfgaTgDiLgFGM8=
X-Google-Smtp-Source: AGHT+IFxzo2LvHyD9enk3JgH6M/uX2cEDeeVHgFREStcWi+cpSW7GgbOYR9Ci6K9Rop3OGma4S+J223ShUpN4jBEgQU=
X-Received: by 2002:a2e:bc82:0:b0:2ee:89d2:f92d with SMTP id
 38308e7fff4ca-2ee8edd31c0mr19614891fa.42.1720111219151; Thu, 04 Jul 2024
 09:40:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0000000000001e3b5d0618befc84@google.com> <CAKFNMo=mGh9i7eqeg1WU__vYZZHV71fYj9A+6E-R8rvba5nbBA@mail.gmail.com>
In-Reply-To: <CAKFNMo=mGh9i7eqeg1WU__vYZZHV71fYj9A+6E-R8rvba5nbBA@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 5 Jul 2024 01:40:02 +0900
Message-ID: <CAKFNMon1ZP-9KreQJgk-W_5UfGsZRL2kchOa=JL4RdqaF2s=KA@mail.gmail.com>
Subject: Re: [syzbot] [nilfs?] possible deadlock in nilfs_evict_inode (2)
To: syzbot <syzbot+c48f1971ba117125f94c@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 19, 2024 at 4:20=E2=80=AFAM Ryusuke Konishi
<konishi.ryusuke@gmail.com> wrote:
>
> On Sun, May 19, 2024 at 3:53=E2=80=AFAM syzbot
> <syzbot+c48f1971ba117125f94c@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    6bfd2d442af5 Merge tag 'irq-core-2024-05-12' of git://g=
it...
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D13aefc20980=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D395546166dc=
fe360
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3Dc48f1971ba117=
125f94c
> > compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for=
 Debian) 2.40
> > userspace arch: i386
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets=
/7bc7510fe41f/non_bootable_disk-6bfd2d44.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/7ad901fe99c6/vmli=
nux-6bfd2d44.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/8d6ef2df621f=
/bzImage-6bfd2d44.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+c48f1971ba117125f94c@syzkaller.appspotmail.com
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> > WARNING: possible circular locking dependency detected
> > 6.9.0-syzkaller-01893-g6bfd2d442af5 #0 Not tainted
> > ------------------------------------------------------
> > kswapd0/111 is trying to acquire lock:
> > ffff888018e7e610 (sb_internal#4){.+.+}-{0:0}, at: nilfs_evict_inode+0x1=
57/0x550 fs/nilfs2/inode.c:924
> >
> > but task is already holding lock:
> > ffffffff8d9390c0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x166/0x1a=
10 mm/vmscan.c:6782
> >
> > which lock already depends on the new lock.
> >
> >
> > the existing dependency chain (in reverse order) is:
> >
> > -> #2 (fs_reclaim){+.+.}-{0:0}:
> >        __fs_reclaim_acquire mm/page_alloc.c:3698 [inline]
> >        fs_reclaim_acquire+0x102/0x160 mm/page_alloc.c:3712
> >        might_alloc include/linux/sched/mm.h:312 [inline]
> >        prepare_alloc_pages.constprop.0+0x155/0x560 mm/page_alloc.c:4346
> >        __alloc_pages+0x194/0x2460 mm/page_alloc.c:4564
> >        alloc_pages_mpol+0x275/0x610 mm/mempolicy.c:2264
> >        folio_alloc+0x1e/0x40 mm/mempolicy.c:2342
> >        filemap_alloc_folio+0x3ba/0x490 mm/filemap.c:984
> >        __filemap_get_folio+0x527/0xa90 mm/filemap.c:1926
> >        pagecache_get_page+0x2c/0x260 mm/folio-compat.c:93
> >        block_write_begin+0x38/0x4a0 fs/buffer.c:2209
> >        nilfs_write_begin+0x9f/0x1a0 fs/nilfs2/inode.c:262
> >        page_symlink+0x356/0x450 fs/namei.c:5236
> >        nilfs_symlink+0x23c/0x3c0 fs/nilfs2/namei.c:153
> >        vfs_symlink fs/namei.c:4489 [inline]
> >        vfs_symlink+0x3e8/0x630 fs/namei.c:4473
> >        do_symlinkat+0x263/0x310 fs/namei.c:4515
> >        __do_sys_symlink fs/namei.c:4536 [inline]
> >        __se_sys_symlink fs/namei.c:4534 [inline]
> >        __ia32_sys_symlink+0x78/0xa0 fs/namei.c:4534
> >        do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
> >        __do_fast_syscall_32+0x75/0x120 arch/x86/entry/common.c:386
> >        do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
> >        entry_SYSENTER_compat_after_hwframe+0x84/0x8e
> >
> > -> #1 (&nilfs->ns_segctor_sem){++++}-{3:3}:
> >        down_read+0x9a/0x330 kernel/locking/rwsem.c:1526
> >        nilfs_transaction_begin+0x326/0xa40 fs/nilfs2/segment.c:223
> >        nilfs_symlink+0x114/0x3c0 fs/nilfs2/namei.c:140
> >        vfs_symlink fs/namei.c:4489 [inline]
> >        vfs_symlink+0x3e8/0x630 fs/namei.c:4473
> >        do_symlinkat+0x263/0x310 fs/namei.c:4515
> >        __do_sys_symlink fs/namei.c:4536 [inline]
> >        __se_sys_symlink fs/namei.c:4534 [inline]
> >        __ia32_sys_symlink+0x78/0xa0 fs/namei.c:4534
> >        do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
> >        __do_fast_syscall_32+0x75/0x120 arch/x86/entry/common.c:386
> >        do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
> >        entry_SYSENTER_compat_after_hwframe+0x84/0x8e
> >
> > -> #0 (sb_internal#4){.+.+}-{0:0}:
> >        check_prev_add kernel/locking/lockdep.c:3134 [inline]
> >        check_prevs_add kernel/locking/lockdep.c:3253 [inline]
> >        validate_chain kernel/locking/lockdep.c:3869 [inline]
> >        __lock_acquire+0x2478/0x3b30 kernel/locking/lockdep.c:5137
> >        lock_acquire kernel/locking/lockdep.c:5754 [inline]
> >        lock_acquire+0x1b1/0x560 kernel/locking/lockdep.c:5719
> >        percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
> >        __sb_start_write include/linux/fs.h:1661 [inline]
> >        sb_start_intwrite include/linux/fs.h:1844 [inline]
> >        nilfs_transaction_begin+0x21b/0xa40 fs/nilfs2/segment.c:220
> >        nilfs_evict_inode+0x157/0x550 fs/nilfs2/inode.c:924
> >        evict+0x2ed/0x6c0 fs/inode.c:667
> >        iput_final fs/inode.c:1741 [inline]
> >        iput.part.0+0x5a8/0x7f0 fs/inode.c:1767
> >        iput+0x5c/0x80 fs/inode.c:1757
> >        dentry_unlink_inode+0x295/0x440 fs/dcache.c:400
> >        __dentry_kill+0x1d0/0x600 fs/dcache.c:603
> >        shrink_kill fs/dcache.c:1048 [inline]
> >        shrink_dentry_list+0x140/0x5d0 fs/dcache.c:1075
> >        prune_dcache_sb+0xeb/0x150 fs/dcache.c:1156
> >        super_cache_scan+0x32a/0x550 fs/super.c:221
> >        do_shrink_slab+0x44f/0x11c0 mm/shrinker.c:435
> >        shrink_slab_memcg mm/shrinker.c:548 [inline]
> >        shrink_slab+0xa87/0x1310 mm/shrinker.c:626
> >        shrink_one+0x493/0x7c0 mm/vmscan.c:4774
> >        shrink_many mm/vmscan.c:4835 [inline]
> >        lru_gen_shrink_node+0x89f/0x1750 mm/vmscan.c:4935
> >        shrink_node mm/vmscan.c:5894 [inline]
> >        kswapd_shrink_node mm/vmscan.c:6704 [inline]
> >        balance_pgdat+0x10d1/0x1a10 mm/vmscan.c:6895
> >        kswapd+0x5ea/0xbf0 mm/vmscan.c:7164
> >        kthread+0x2c1/0x3a0 kernel/kthread.c:388
> >        ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
> >        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> >
> > other info that might help us debug this:
> >
> > Chain exists of:
> >   sb_internal#4 --> &nilfs->ns_segctor_sem --> fs_reclaim
> >
> >  Possible unsafe locking scenario:
> >
> >        CPU0                    CPU1
> >        ----                    ----
> >   lock(fs_reclaim);
> >                                lock(&nilfs->ns_segctor_sem);
> >                                lock(fs_reclaim);
> >   rlock(sb_internal#4);
> >
> >  *** DEADLOCK ***
> >
> > 2 locks held by kswapd0/111:
> >  #0: ffffffff8d9390c0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x166=
/0x1a10 mm/vmscan.c:6782
> >  #1: ffff888018e7e0e0 (&type->s_umount_key#74){++++}-{3:3}, at: super_t=
rylock_shared fs/super.c:561 [inline]
> >  #1: ffff888018e7e0e0 (&type->s_umount_key#74){++++}-{3:3}, at: super_c=
ache_scan+0x96/0x550 fs/super.c:196
> >
> > stack backtrace:
> > CPU: 2 PID: 111 Comm: kswapd0 Not tainted 6.9.0-syzkaller-01893-g6bfd2d=
442af5 #0
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-=
1.16.2-1 04/01/2014
> > Call Trace:
> >  <TASK>
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:114
> >  check_noncircular+0x31a/0x400 kernel/locking/lockdep.c:2187
> >  check_prev_add kernel/locking/lockdep.c:3134 [inline]
> >  check_prevs_add kernel/locking/lockdep.c:3253 [inline]
> >  validate_chain kernel/locking/lockdep.c:3869 [inline]
> >  __lock_acquire+0x2478/0x3b30 kernel/locking/lockdep.c:5137
> >  lock_acquire kernel/locking/lockdep.c:5754 [inline]
> >  lock_acquire+0x1b1/0x560 kernel/locking/lockdep.c:5719
> >  percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
> >  __sb_start_write include/linux/fs.h:1661 [inline]
> >  sb_start_intwrite include/linux/fs.h:1844 [inline]
> >  nilfs_transaction_begin+0x21b/0xa40 fs/nilfs2/segment.c:220
> >  nilfs_evict_inode+0x157/0x550 fs/nilfs2/inode.c:924
> >  evict+0x2ed/0x6c0 fs/inode.c:667
> >  iput_final fs/inode.c:1741 [inline]
> >  iput.part.0+0x5a8/0x7f0 fs/inode.c:1767
> >  iput+0x5c/0x80 fs/inode.c:1757
> >  dentry_unlink_inode+0x295/0x440 fs/dcache.c:400
> >  __dentry_kill+0x1d0/0x600 fs/dcache.c:603
> >  shrink_kill fs/dcache.c:1048 [inline]
> >  shrink_dentry_list+0x140/0x5d0 fs/dcache.c:1075
> >  prune_dcache_sb+0xeb/0x150 fs/dcache.c:1156
> >  super_cache_scan+0x32a/0x550 fs/super.c:221
> >  do_shrink_slab+0x44f/0x11c0 mm/shrinker.c:435
> >  shrink_slab_memcg mm/shrinker.c:548 [inline]
> >  shrink_slab+0xa87/0x1310 mm/shrinker.c:626
> >  shrink_one+0x493/0x7c0 mm/vmscan.c:4774
> >  shrink_many mm/vmscan.c:4835 [inline]
> >  lru_gen_shrink_node+0x89f/0x1750 mm/vmscan.c:4935
> >  shrink_node mm/vmscan.c:5894 [inline]
> >  kswapd_shrink_node mm/vmscan.c:6704 [inline]
> >  balance_pgdat+0x10d1/0x1a10 mm/vmscan.c:6895
> >  kswapd+0x5ea/0xbf0 mm/vmscan.c:7164
> >  kthread+0x2c1/0x3a0 kernel/kthread.c:388
> >  ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> >  </TASK>
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> >
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> >
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> >
> > If you want to undo deduplication, reply with:
> > #syz undup
>
> Similarly, it seems to have the same root as the report below, but I
> can't confirm it right now, so I'll leave it now.
>
> https://syzkaller.appspot.com/bug?extid=3Dca73f5a22aec76875d85
>
> Similarly, the GFP flags on the symlink's page cache allocation
> appears to be causing this circular lock dependency.
>
> Ryusuke Konishi

#syz dup: possible deadlock in nilfs_transaction_begin

Ryusuke Konishi
