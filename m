Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5BD1A0728;
	Thu,  1 May 2025 16:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746116117; cv=none; b=gAWbCtzrhaseLgYUxW16bjXZhqkdSbJFMZ1Uc7jgQJIipEUyfncX688ce7YCa9Zu9qvpj3YQfcIm+wZ4Wzflltx5sm8ECR1LKR5vJSVx/gI3/8vgPYCgrE2GhtTs7+bt7Zxlh25aMyHFqHocALmVkLMAFPlmfzLg+q5g5VHiOEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746116117; c=relaxed/simple;
	bh=9TpDqDf8cpKjFy0P5rmSdOXhJzQ1ceYd29IX9dLzap0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jdALEjX09p0YRV2lmcm4V+2DcCRAizlirnEqANQsBvDc5KrmJ8mcYX5ZCggwNS0iG+EdIhw6fANnv4/ZvaA7kMcrc+keBXroVBRgosH+Rx0ylF/xx+UYJpWG2yVOnKWbL+KtkBc21m2wIzfMOl1PLDD4jqcqEBQWbOBB+MxJGUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eY17OZ1V; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eY17OZ1V"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-30bfc79ad97so23975711fa.1;
        Thu, 01 May 2025 09:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746116113; x=1746720913; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FIodQesU0VSgAotXKOIbbDPRU61imraIz1xpqfldZmA=;
        b=eY17OZ1Vu9AjUlFcOjcLoEpGaB8nsEmI0do6NasdN5tJmGf5XVjLJIIQNEG4xXV/Hl
         kqWC5OWtay/sFp/ikjasOiTE3D8hnzKGrKgj++WRgC1wYCvCzWQ6clKil20jToOi/tIB
         A55UxdwpAbnn3vl63S9uYO6hVDllKG4Hwy8t0sYnEPJF4OpnzWPH47tYYjO64cZ1d0Yx
         +Y+iJEBC2dcdMPWhJmkYlbsmsPFzCkCXm48gxxtvtMUlPPhC0brZnZaDl+tefkojNZeh
         I/VVZiMilZ8W8950GY6wIJOnh6qGxX1KBcFIsLDaxa2cb2rFgKyJkAyR/u4rHIheYIdL
         HKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746116113; x=1746720913;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FIodQesU0VSgAotXKOIbbDPRU61imraIz1xpqfldZmA=;
        b=AS+PH2aeOlCdm8owFcqppbmG+lS/fjQxD8IkjNoqgpsC2EwY2IeGBpxW+pEBpPc9Dd
         o0i8Yao1jrCJ0CoPb0zbK3H6oD/2t4E/Ma+zh7KRVosJxIRymYyXbxzoWJ9UJRlA1Reb
         Rl6oYp3MCCs9sdMgJds4bhom4GgKk53I3YIDWPGSmI1IKqkCNlmNKTNqpb4UuaKnB3a2
         JJ5AAqZn+PgAKUHf/fGUKx69RFGUxJdLbl7/TgNa68SRtbJalCXnEVWLQD2ilXk42lSf
         3Jel92+Q7TJO17z+FnoOOOuQb/Xt8qI6+0oF+FbmLfsy4qRxe+Iu+nxtHKHRODJqJPCX
         pFQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPKAuF5vh9gRLk5WvjapYvGfrxvjZUxjKbORsILBegEvikf8W2k0Vo58sCC+dWt37Z9pArXi0N6T9ZVg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJQbh+zoG4V5uYPZQWy2pWw7Qa2/TBGfQFLR/293416lcPVzh2
	vrrk+oNAW2bEFd9RKoTkzbRomt08iiCfFfblvwMYISURPG7+EABovPfsdRKTEXQBGT3ioadc8Nk
	+r6r6LsaflqUXyS5lWZR7uc+yaV7to59M
X-Gm-Gg: ASbGncseacLkJjNzv+TK/EIh+ioBBZH9dT9vnXAfXc/qD7ZThIjzX7uLvhC7vjIkVic
	nyiXQY/9/G7aPfslhdjI28j9mOloXx+oUyIq9rATqrsh4knO33hhSexc1wbK+CFWNVrmm41sRXR
	CStwu3OPMDlJYfSCLK4a7GTInr3kHOLKh6GsbQLGjx7TRXe45zJ9F1r7M=
X-Google-Smtp-Source: AGHT+IEAnWG78nXMvQOS54pI5ILZQJavARLC6Y8QR6NC9pQ77ItR0UNrzcLZs6PX4vp2l4ZbE3w2iRDxm4llsksdjs8=
X-Received: by 2002:a2e:a811:0:b0:309:22dc:6917 with SMTP id
 38308e7fff4ca-31fc16cab17mr10749541fa.19.1746116112816; Thu, 01 May 2025
 09:15:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6811d7ac.050a0220.16fb2c.000b.GAE@google.com>
In-Reply-To: <6811d7ac.050a0220.16fb2c.000b.GAE@google.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 2 May 2025 01:14:55 +0900
X-Gm-Features: ATxdqUGYlteZhuz9EfmjPN5CtvW-rPoPS-yVO8A9QMCh2N7gZX42rOo-F5EyJZY
Message-ID: <CAKFNMomt3HLOY69gfjo0qebz5_NsquMV_QtM3wWgkyorRjEfpg@mail.gmail.com>
Subject: Re: [syzbot] [nilfs?] possible deadlock in nilfs_page_mkwrite (2)
To: syzbot <syzbot+3f86ff971bc63d62b932@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2025 at 4:56=E2=80=AFPM syzbot
<syzbot+3f86ff971bc63d62b932@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    ca91b9500108 Merge tag 'v6.15-rc4-ksmbd-server-fixes' of =
g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D175868d458000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Da42a9d5527881=
77b
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D3f86ff971bc63d6=
2b932
> compiler:       Debian clang version 20.1.2 (++20250402124445+58df0ef89dd=
6-1~exp1~20250402004600.97), Debian LLD 20.1.2
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/8f91302b28da/dis=
k-ca91b950.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/99926b0845ed/vmlinu=
x-ca91b950.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/ace62028a7c9/b=
zImage-ca91b950.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+3f86ff971bc63d62b932@syzkaller.appspotmail.com
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> 6.15.0-rc4-syzkaller-00021-gca91b9500108 #0 Not tainted
> ------------------------------------------------------
> syz.0.145/7282 is trying to acquire lock:
> ffff88806be68610 (sb_internal#4){.+.+}-{0:0}, at: nilfs_page_mkwrite+0x8b=
0/0xc20 fs/nilfs2/file.c:95
>
> but task is already holding lock:
> ffff88806be68518 (sb_pagefaults#4){.+.+}-{0:0}, at: do_page_mkwrite+0x14a=
/0x310 mm/memory.c:3287
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #5 (sb_pagefaults#4){.+.+}-{0:0}:
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
>        handle_mm_fault+0x2d5/0x7f0 mm/memory.c:6309
>        faultin_page mm/gup.c:1193 [inline]
>        __get_user_pages+0x16f0/0x2a40 mm/gup.c:1491
>        __get_user_pages_locked mm/gup.c:1821 [inline]
>        __gup_longterm_locked+0x105d/0x15b0 mm/gup.c:2523
>        gup_fast_fallback+0x1843/0x1d60 mm/gup.c:3417
>        iov_iter_extract_user_pages lib/iov_iter.c:1849 [inline]
>        iov_iter_extract_pages+0x35a/0x5e0 lib/iov_iter.c:1912
>        dio_refill_pages fs/direct-io.c:172 [inline]
>        dio_get_page fs/direct-io.c:213 [inline]
>        do_direct_IO fs/direct-io.c:915 [inline]
>        __blockdev_direct_IO+0x10ed/0x3310 fs/direct-io.c:1243
>        blockdev_direct_IO include/linux/fs.h:3422 [inline]
>        nilfs_direct_IO+0xed/0x120 fs/nilfs2/inode.c:267
>        generic_file_read_iter+0x319/0x510 mm/filemap.c:2871
>        new_sync_read fs/read_write.c:489 [inline]
>        vfs_read+0x4cd/0x980 fs/read_write.c:570
>        ksys_read+0x145/0x250 fs/read_write.c:713
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> -> #4 (&mm->mmap_lock){++++}-{4:4}:
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
> -> #3 (&sb->s_type->i_mutex_key#7){++++}-{4:4}:
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
> -> #2 (&nilfs->ns_sem){++++}-{4:4}:
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
>        down_write+0x96/0x1f0 kernel/locking/rwsem.c:1577
>        nilfs_set_error fs/nilfs2/super.c:92 [inline]
>        __nilfs_error+0x1ca/0x4b0 fs/nilfs2/super.c:141
>        nilfs_bmap_convert_error fs/nilfs2/bmap.c:35 [inline]
>        nilfs_bmap_propagate+0x108/0x130 fs/nilfs2/bmap.c:332
>        nilfs_collect_file_data+0x4f/0xd0 fs/nilfs2/segment.c:589
>        nilfs_segctor_apply_buffers+0x161/0x330 fs/nilfs2/segment.c:1010
>        nilfs_segctor_scan_file+0x68e/0x8e0 fs/nilfs2/segment.c:1059
>        nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1254 [inline]
>        nilfs_segctor_collect fs/nilfs2/segment.c:1547 [inline]
>        nilfs_segctor_do_construct+0x1d46/0x6970 fs/nilfs2/segment.c:2122
>        nilfs_segctor_construct+0x17b/0x690 fs/nilfs2/segment.c:2478
>        nilfs_segctor_thread_construct fs/nilfs2/segment.c:2586 [inline]
>        nilfs_segctor_thread+0x6f7/0xe00 fs/nilfs2/segment.c:2700
>        kthread+0x70e/0x8a0 kernel/kthread.c:464
>        ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:153
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> -> #1 (&nilfs->ns_segctor_sem){++++}-{4:4}:
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
> -> #0 (sb_internal#4){.+.+}-{0:0}:
>        check_prev_add kernel/locking/lockdep.c:3166 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3285 [inline]
>        validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3909
>        __lock_acquire+0xaac/0xd20 kernel/locking/lockdep.c:5235
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
>        handle_mm_fault+0x2d5/0x7f0 mm/memory.c:6309
>        faultin_page mm/gup.c:1193 [inline]
>        __get_user_pages+0x16f0/0x2a40 mm/gup.c:1491
>        __get_user_pages_locked mm/gup.c:1821 [inline]
>        __gup_longterm_locked+0x105d/0x15b0 mm/gup.c:2523
>        gup_fast_fallback+0x1843/0x1d60 mm/gup.c:3417
>        iov_iter_extract_user_pages lib/iov_iter.c:1849 [inline]
>        iov_iter_extract_pages+0x35a/0x5e0 lib/iov_iter.c:1912
>        dio_refill_pages fs/direct-io.c:172 [inline]
>        dio_get_page fs/direct-io.c:213 [inline]
>        do_direct_IO fs/direct-io.c:915 [inline]
>        __blockdev_direct_IO+0x10ed/0x3310 fs/direct-io.c:1243
>        blockdev_direct_IO include/linux/fs.h:3422 [inline]
>        nilfs_direct_IO+0xed/0x120 fs/nilfs2/inode.c:267
>        generic_file_read_iter+0x319/0x510 mm/filemap.c:2871
>        new_sync_read fs/read_write.c:489 [inline]
>        vfs_read+0x4cd/0x980 fs/read_write.c:570
>        ksys_read+0x145/0x250 fs/read_write.c:713
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> other info that might help us debug this:
>
> Chain exists of:
>   sb_internal#4 --> &mm->mmap_lock --> sb_pagefaults#4
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   rlock(sb_pagefaults#4);
>                                lock(&mm->mmap_lock);
>                                lock(sb_pagefaults#4);
>   rlock(sb_internal#4);
>
>  *** DEADLOCK ***
>
> 4 locks held by syz.0.145/7282:
>  #0: ffff8880258a0b78 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x247/0=
x320 fs/file.c:1213
>  #1: ffff88805d73c8c0 (&sb->s_type->i_mutex_key#23){+.+.}-{4:4}, at: inod=
e_lock include/linux/fs.h:867 [inline]
>  #1: ffff88805d73c8c0 (&sb->s_type->i_mutex_key#23){+.+.}-{4:4}, at: __bl=
ockdev_direct_IO+0x318/0x3310 fs/direct-io.c:1140
>  #2: ffff88806d6595e0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock_ki=
llable include/linux/mmap_lock.h:193 [inline]
>  #2: ffff88806d6595e0 (&mm->mmap_lock){++++}-{4:4}, at: __get_user_pages_=
locked mm/gup.c:1812 [inline]
>  #2: ffff88806d6595e0 (&mm->mmap_lock){++++}-{4:4}, at: __gup_longterm_lo=
cked+0x1005/0x15b0 mm/gup.c:2523
>  #3: ffff88806be68518 (sb_pagefaults#4){.+.+}-{0:0}, at: do_page_mkwrite+=
0x14a/0x310 mm/memory.c:3287
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 7282 Comm: syz.0.145 Not tainted 6.15.0-rc4-syzkaller-=
00021-gca91b9500108 #0 PREEMPT(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 04/19/2025
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
>  percpu_down_read include/linux/percpu-rwsem.h:52 [inline]
>  __sb_start_write include/linux/fs.h:1783 [inline]
>  sb_start_intwrite include/linux/fs.h:1966 [inline]
>  nilfs_transaction_begin+0x268/0x710 fs/nilfs2/segment.c:218
>  nilfs_page_mkwrite+0x8b0/0xc20 fs/nilfs2/file.c:95
>  do_page_mkwrite+0x14a/0x310 mm/memory.c:3287
>  do_shared_fault mm/memory.c:5594 [inline]
>  do_fault mm/memory.c:5656 [inline]
>  do_pte_missing mm/memory.c:4160 [inline]
>  handle_pte_fault mm/memory.c:5997 [inline]
>  __handle_mm_fault+0x18d2/0x5380 mm/memory.c:6140
>  handle_mm_fault+0x2d5/0x7f0 mm/memory.c:6309
>  faultin_page mm/gup.c:1193 [inline]
>  __get_user_pages+0x16f0/0x2a40 mm/gup.c:1491
>  __get_user_pages_locked mm/gup.c:1821 [inline]
>  __gup_longterm_locked+0x105d/0x15b0 mm/gup.c:2523
>  gup_fast_fallback+0x1843/0x1d60 mm/gup.c:3417
>  iov_iter_extract_user_pages lib/iov_iter.c:1849 [inline]
>  iov_iter_extract_pages+0x35a/0x5e0 lib/iov_iter.c:1912
>  dio_refill_pages fs/direct-io.c:172 [inline]
>  dio_get_page fs/direct-io.c:213 [inline]
>  do_direct_IO fs/direct-io.c:915 [inline]
>  __blockdev_direct_IO+0x10ed/0x3310 fs/direct-io.c:1243
>  blockdev_direct_IO include/linux/fs.h:3422 [inline]
>  nilfs_direct_IO+0xed/0x120 fs/nilfs2/inode.c:267
>  generic_file_read_iter+0x319/0x510 mm/filemap.c:2871
>  new_sync_read fs/read_write.c:489 [inline]
>  vfs_read+0x4cd/0x980 fs/read_write.c:570
>  ksys_read+0x145/0x250 fs/read_write.c:713
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f75a3f8e969
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f75a4de1038 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: ffffffffffffffda RBX: 00007f75a41b6080 RCX: 00007f75a3f8e969
> RDX: 0000000000001000 RSI: 0000200000000400 RDI: 0000000000000004
> RBP: 00007f75a4010ab1 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000001 R14: 00007f75a41b6080 R15: 00007fffacbb86c8
>  </TASK>
> NILFS error (device loop0): nilfs_bmap_lookup_contig: broken bmap (inode =
number=3D2097152)
> Remounting filesystem read-only
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

Although syzbot has not found any reproducers yet, this looks a false
positive deadlock warning, similar to the one in the syzbot report
below, likely caused by inode locking introduced in set_blocksize():

#syz dup: possible deadlock in __nilfs_error (3)

I am working on identifying the cause, and once that is done, I will
submit a patch to resolve these issues with a fix to init_nilfs().

Ryusuke Konishi
