Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2466B12E1D1
	for <linux-nilfs@vger.kernel.org>; Tue,  2 Apr 2024 14:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712068708; cv=none; b=mZ1rseZHgStLfe2oQae7LlLqrm/JAcIHuCWytkY4wQOJhYDDbWoJ1SghQUn0OUILqVTrtrk2j5SaMjCqIb1MDsNmubdflBnB6ixZTAIs2dsg3doPfe4eaVDbYaG1igi4hNoPLgm7lEYh/yH0snSWSBbAHoJtZ76ub9tiQ8Npj+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712068708; c=relaxed/simple;
	bh=XPcXEYcJJ/WyBS2lsYIXXkraZhwxK8dNLIWkGZ7mmY0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=eMXtRWQIV8NxxzX7wK2etcRSRnNPUntmnvXS1+pKnNukbEpNzGiV1NfxQosZCW4NqqGbA2lsJSdn6kBq52+OdQlaTqlMqgU2k8TuCKz2sBtxSby+QqEGg9UrL9MUS0Yg0+/QlWKAbGkq+CBhq1JbLkLavLw3fKW4p5gWSLMsRkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7c88a694b46so471313439f.1
        for <linux-nilfs@vger.kernel.org>; Tue, 02 Apr 2024 07:38:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712068705; x=1712673505;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m4BhvGm+79dtUpakYQBDCahsgl61NTLQEW72duDPoDg=;
        b=uXrbi3RG7fjKmlXY9OQb5dhbIDCcTolVB1X5FxSX0E8Q/hEvPPmC22KchL+1tD2tyx
         dOc9qGJ4LL6v31U8WC3uCwm9CRiCWg73ER/c0XPU3/4SU8P09K3gA/eTtpgWhrCYpEz0
         366aLxbdd3kBJEwcexAb5akzQrHOejjHp89aOFHLa7XdAKbD0zSJZGYaKwd6bBFnoU0M
         kr/yDYR0dOUSZfpwfkdym2ZcgEWvTFdFzpQTDV57oth6Lt0POu9irdFG4qKd97Jie1Jm
         /IN0CMSVs4kMxYV37l0ZEHXTjG5CmDHLu9QyIrWir+bRt+5nKYRro3pxm+4mHdt/hXd4
         3+EA==
X-Forwarded-Encrypted: i=1; AJvYcCWALA7AYL7e3luENlbdKxMB07QyFpOHUbkQ0S0MCLOOaIwz9yEGHNAG5/NZ8NSzXGH0AgBQa6DTaNsRUd8pcV9jIRfIRGNTuRgSXH0=
X-Gm-Message-State: AOJu0YxQ+06j3uYXeMvm+hwLHAlGuh31dFEMDkZpa8t6TkmCQT/7Ttg6
	bQV+F91W7yROSjGQcLMBMGLdX36JazujXeI19/qpzuDBiV9QQJzGXCTKuU99XTlTULM4U9oKsz5
	b6pX3uKSP0uQnTNkaIusv7EAnj67ispwv2Rjg/yXzKTCLFjkVebmjyKE=
X-Google-Smtp-Source: AGHT+IENNhNE/GDQmjAHYipmcF1H/AxFjMFf17QczdzHuoWrG0c2372dVZR/CCYhqnLZZBg25EKhjBbV/UCE6WJcbYeL21xTdKr7
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3fc4:b0:7c8:c7ec:2b71 with SMTP id
 fc4-20020a0566023fc400b007c8c7ec2b71mr172499iob.3.1712068705362; Tue, 02 Apr
 2024 07:38:25 -0700 (PDT)
Date: Tue, 02 Apr 2024 07:38:25 -0700
In-Reply-To: <000000000000fd0f2a061506cc93@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000003b8c406151e0fd1@google.com>
Subject: Re: [syzbot] [nilfs?] KASAN: slab-out-of-bounds Read in wb_writeback
From: syzbot <syzbot+7b219b86935220db6dd8@syzkaller.appspotmail.com>
To: brauner@kernel.org, gregkh@linuxfoundation.org, jack@suse.cz, 
	konishi.ryusuke@gmail.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tj@kernel.org, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    c0b832517f62 Add linux-next specific files for 20240402
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14af7dd9180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=afcaf46d374cec8c
dashboard link: https://syzkaller.appspot.com/bug?extid=7b219b86935220db6dd8
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1729f003180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17fa4341180000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0d36ec76edc7/disk-c0b83251.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6f9bb4e37dd0/vmlinux-c0b83251.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2349287b14b7/bzImage-c0b83251.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/9760c52a227c/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7b219b86935220db6dd8@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in __lock_acquire+0x78/0x1fd0 kernel/locking/lockdep.c:5005
Read of size 8 at addr ffff888020485fa8 by task kworker/u8:2/35

CPU: 0 PID: 35 Comm: kworker/u8:2 Not tainted 6.9.0-rc2-next-20240402-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
Workqueue: writeback wb_workfn (flush-7:1)
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 __lock_acquire+0x78/0x1fd0 kernel/locking/lockdep.c:5005
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:351 [inline]
 wb_writeback+0x66f/0xd30 fs/fs-writeback.c:2160
 wb_check_old_data_flush fs/fs-writeback.c:2233 [inline]
 wb_do_writeback fs/fs-writeback.c:2286 [inline]
 wb_workfn+0xba1/0x1090 fs/fs-writeback.c:2314
 process_one_work kernel/workqueue.c:3218 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3299
 worker_thread+0x86d/0xd70 kernel/workqueue.c:3380
 kthread+0x2f0/0x390 kernel/kthread.c:388
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:243
 </TASK>

Allocated by task 5052:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:370 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:387
 kasan_kmalloc include/linux/kasan.h:211 [inline]
 __do_kmalloc_node mm/slub.c:4048 [inline]
 __kmalloc_noprof+0x200/0x410 mm/slub.c:4061
 kmalloc_noprof include/linux/slab.h:664 [inline]
 tomoyo_realpath_from_path+0xcf/0x5e0 security/tomoyo/realpath.c:251
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x2b7/0x740 security/tomoyo/file.c:822
 security_inode_getattr+0xd8/0x130 security/security.c:2269
 vfs_getattr+0x45/0x430 fs/stat.c:173
 vfs_fstat fs/stat.c:198 [inline]
 vfs_fstatat+0xd6/0x190 fs/stat.c:300
 __do_sys_newfstatat fs/stat.c:468 [inline]
 __se_sys_newfstatat fs/stat.c:462 [inline]
 __x64_sys_newfstatat+0x125/0x1b0 fs/stat.c:462
 do_syscall_64+0xfb/0x240
 entry_SYSCALL_64_after_hwframe+0x72/0x7a

Freed by task 5052:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object+0xe0/0x150 mm/kasan/common.c:240
 __kasan_slab_free+0x37/0x60 mm/kasan/common.c:256
 kasan_slab_free include/linux/kasan.h:184 [inline]
 slab_free_hook mm/slub.c:2180 [inline]
 slab_free mm/slub.c:4363 [inline]
 kfree+0x149/0x350 mm/slub.c:4484
 tomoyo_realpath_from_path+0x5a9/0x5e0 security/tomoyo/realpath.c:286
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x2b7/0x740 security/tomoyo/file.c:822
 security_inode_getattr+0xd8/0x130 security/security.c:2269
 vfs_getattr+0x45/0x430 fs/stat.c:173
 vfs_fstat fs/stat.c:198 [inline]
 vfs_fstatat+0xd6/0x190 fs/stat.c:300
 __do_sys_newfstatat fs/stat.c:468 [inline]
 __se_sys_newfstatat fs/stat.c:462 [inline]
 __x64_sys_newfstatat+0x125/0x1b0 fs/stat.c:462
 do_syscall_64+0xfb/0x240
 entry_SYSCALL_64_after_hwframe+0x72/0x7a

The buggy address belongs to the object at ffff888020484000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 4008 bytes to the right of
 allocated 4096-byte region [ffff888020484000, ffff888020485000)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x20480
head: order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff80000000040(head|node=0|zone=1|lastcpupid=0xfff)
page_type: 0xffffefff(slab)
raw: 00fff80000000040 ffff888015042140 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000040004 00000001ffffefff 0000000000000000
head: 00fff80000000040 ffff888015042140 dead000000000100 dead000000000122
head: 0000000000000000 0000000000040004 00000001ffffefff 0000000000000000
head: 00fff80000000003 ffffea0000812001 ffffea0000812048 00000000ffffffff
head: 0000000800000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid -957297381 (swapper/0), ts 1, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1490
 prep_new_page mm/page_alloc.c:1498 [inline]
 get_page_from_freelist+0x2e7e/0x2f40 mm/page_alloc.c:3454
 __alloc_pages_noprof+0x256/0x6c0 mm/page_alloc.c:4712
 __alloc_pages_node_noprof include/linux/gfp.h:244 [inline]
 alloc_pages_node_noprof include/linux/gfp.h:271 [inline]
 alloc_slab_page+0x5f/0x120 mm/slub.c:2249
 allocate_slab+0x5a/0x2e0 mm/slub.c:2412
 new_slab mm/slub.c:2465 [inline]
 ___slab_alloc+0xea8/0x1430 mm/slub.c:3599
 __slab_alloc+0x58/0xa0 mm/slub.c:3684
 __slab_alloc_node mm/slub.c:3737 [inline]
 slab_alloc_node mm/slub.c:3915 [inline]
 kmalloc_node_trace_noprof+0x20c/0x300 mm/slub.c:4087
 kmalloc_node_noprof include/linux/slab.h:677 [inline]
 bdi_alloc+0x4f/0x140 mm/backing-dev.c:894
 __alloc_disk_node+0xb8/0x590 block/genhd.c:1347
 __blk_mq_alloc_disk+0x17d/0x260 block/blk-mq.c:4166
 loop_add+0x448/0xba0 drivers/block/loop.c:2032
 loop_init+0x17a/0x230 drivers/block/loop.c:2275
 do_one_initcall+0x248/0x880 init/main.c:1258
 do_initcall_level+0x157/0x210 init/main.c:1320
 do_initcalls+0x3f/0x80 init/main.c:1336
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888020485e80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888020485f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888020485f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                  ^
 ffff888020486000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888020486080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
