Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9888456455
	for <linux-nilfs@vger.kernel.org>; Sat, 18 May 2024 18:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716058415; cv=none; b=kadg15THux1uc1jxKWG0BU8XQmugLd+qvBFT6+IcnJZET/dyVQUmf9Nzc3Uuyva3AtBt6rNYFeojIJOO8icQNpPQgxCcarb3fQHQUPh3WACqJcAUwBRXgd/2EPd/KmH+1gjupOTs7S0af4/Mk0vIJ7l3tzgmKPFFCejleM1nGHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716058415; c=relaxed/simple;
	bh=PzvWtsYxvq9OvEyn5u7y1pLUR9t9O6XwE27nVOaJft0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=n7GlKAQNtxZBZWOliX3LZVFbMRxS1ayX9OI8rbiUt0c6uwTZkXUq+WCkcQ1lSQhA1hfOFZFcA5BiLuM/O4At21VRgXyNgPpnO231lUK5NNEfPut3gDhtgsZcAM6hX2GxducatGleuMcF5kjtZ4zsK56wC7lXUCkjBeNxLkHcs5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-7e1fe2ba2e1so574421839f.3
        for <linux-nilfs@vger.kernel.org>; Sat, 18 May 2024 11:53:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716058413; x=1716663213;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jmqBSJMyaQSkwkaSX9SRtYVcBMPda0xro2Wg0fWt3pc=;
        b=Klg7SxGYXW9nKKRS5KHeN472LcCInq0gjXYMcnhCkJLT9M5J+MJtcN1bODIOaGHLJj
         UlWxiLvJrFjh4GyIcnOjC0sJMDZz8QACwrKXcpG9iUoAEqZrWSbGPxvrVas5zVtYRd4R
         JH/foYY9HvzEK22F1YVUrhmYeMK7ugOi3bafYc5GJA/17v+2Y3eaCyVdzxXJUhBml+en
         pqN4IaeWiwulBTzn7AoLKIVGaQDSLejiczMDVhTblK2k2RB3leSr2U+76K4sIdwz3HrP
         Qwiicc0h9n5FieW3fw/pNMKOjqho9cvth5vE8QxCC7mzuo+Y1YQBIbS3EwOHfLCYY2WN
         bXCA==
X-Forwarded-Encrypted: i=1; AJvYcCVokxRDkH4xR2/PW6VCpb1igbyn9EZS1jRrjg2NPNjQUPqdk5Mo319QKvPrYHG4UeXVKhhiwx7hWJeP2TLHlf+Dhs3uELRZsUdkX3Y=
X-Gm-Message-State: AOJu0YxlLhdshYiM+eZ90t3oYjqPD5UfbZ0ZPbpiTtjb1c1rQOlHv9Hx
	aKCrBRL5DE5NvcDL5DwWhnQ9osbq520Sv9iS7m9Ux/v2HXarckhDUdaNxyksFQpLRcxI3Pc/+LL
	6Ufh6a7ZBkBCEJgtLDfAdWhZ5yCuOXrIAShNtpN47F8vfIYPofPfc7UY=
X-Google-Smtp-Source: AGHT+IEwgTHnLE/N6ajh52qHQ4jZbewL6olqAZnK+n1knRF9j8yz7bykLNABPQ0Qe1rq4TTXQkuxWoJM01tHsUMTn0BOLEl2r4So
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3782:b0:488:7748:107a with SMTP id
 8926c6da1cb9f-48958c02105mr1751686173.4.1716058412951; Sat, 18 May 2024
 11:53:32 -0700 (PDT)
Date: Sat, 18 May 2024 11:53:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001e3b5d0618befc84@google.com>
Subject: [syzbot] [nilfs?] possible deadlock in nilfs_evict_inode (2)
From: syzbot <syzbot+c48f1971ba117125f94c@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6bfd2d442af5 Merge tag 'irq-core-2024-05-12' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13aefc20980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=395546166dcfe360
dashboard link: https://syzkaller.appspot.com/bug?extid=c48f1971ba117125f94c
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-6bfd2d44.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7ad901fe99c6/vmlinux-6bfd2d44.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8d6ef2df621f/bzImage-6bfd2d44.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c48f1971ba117125f94c@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.9.0-syzkaller-01893-g6bfd2d442af5 #0 Not tainted
------------------------------------------------------
kswapd0/111 is trying to acquire lock:
ffff888018e7e610 (sb_internal#4){.+.+}-{0:0}, at: nilfs_evict_inode+0x157/0x550 fs/nilfs2/inode.c:924

but task is already holding lock:
ffffffff8d9390c0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x166/0x1a10 mm/vmscan.c:6782

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (fs_reclaim){+.+.}-{0:0}:
       __fs_reclaim_acquire mm/page_alloc.c:3698 [inline]
       fs_reclaim_acquire+0x102/0x160 mm/page_alloc.c:3712
       might_alloc include/linux/sched/mm.h:312 [inline]
       prepare_alloc_pages.constprop.0+0x155/0x560 mm/page_alloc.c:4346
       __alloc_pages+0x194/0x2460 mm/page_alloc.c:4564
       alloc_pages_mpol+0x275/0x610 mm/mempolicy.c:2264
       folio_alloc+0x1e/0x40 mm/mempolicy.c:2342
       filemap_alloc_folio+0x3ba/0x490 mm/filemap.c:984
       __filemap_get_folio+0x527/0xa90 mm/filemap.c:1926
       pagecache_get_page+0x2c/0x260 mm/folio-compat.c:93
       block_write_begin+0x38/0x4a0 fs/buffer.c:2209
       nilfs_write_begin+0x9f/0x1a0 fs/nilfs2/inode.c:262
       page_symlink+0x356/0x450 fs/namei.c:5236
       nilfs_symlink+0x23c/0x3c0 fs/nilfs2/namei.c:153
       vfs_symlink fs/namei.c:4489 [inline]
       vfs_symlink+0x3e8/0x630 fs/namei.c:4473
       do_symlinkat+0x263/0x310 fs/namei.c:4515
       __do_sys_symlink fs/namei.c:4536 [inline]
       __se_sys_symlink fs/namei.c:4534 [inline]
       __ia32_sys_symlink+0x78/0xa0 fs/namei.c:4534
       do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
       __do_fast_syscall_32+0x75/0x120 arch/x86/entry/common.c:386
       do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
       entry_SYSENTER_compat_after_hwframe+0x84/0x8e

-> #1 (&nilfs->ns_segctor_sem){++++}-{3:3}:
       down_read+0x9a/0x330 kernel/locking/rwsem.c:1526
       nilfs_transaction_begin+0x326/0xa40 fs/nilfs2/segment.c:223
       nilfs_symlink+0x114/0x3c0 fs/nilfs2/namei.c:140
       vfs_symlink fs/namei.c:4489 [inline]
       vfs_symlink+0x3e8/0x630 fs/namei.c:4473
       do_symlinkat+0x263/0x310 fs/namei.c:4515
       __do_sys_symlink fs/namei.c:4536 [inline]
       __se_sys_symlink fs/namei.c:4534 [inline]
       __ia32_sys_symlink+0x78/0xa0 fs/namei.c:4534
       do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
       __do_fast_syscall_32+0x75/0x120 arch/x86/entry/common.c:386
       do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
       entry_SYSENTER_compat_after_hwframe+0x84/0x8e

-> #0 (sb_internal#4){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3134 [inline]
       check_prevs_add kernel/locking/lockdep.c:3253 [inline]
       validate_chain kernel/locking/lockdep.c:3869 [inline]
       __lock_acquire+0x2478/0x3b30 kernel/locking/lockdep.c:5137
       lock_acquire kernel/locking/lockdep.c:5754 [inline]
       lock_acquire+0x1b1/0x560 kernel/locking/lockdep.c:5719
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1661 [inline]
       sb_start_intwrite include/linux/fs.h:1844 [inline]
       nilfs_transaction_begin+0x21b/0xa40 fs/nilfs2/segment.c:220
       nilfs_evict_inode+0x157/0x550 fs/nilfs2/inode.c:924
       evict+0x2ed/0x6c0 fs/inode.c:667
       iput_final fs/inode.c:1741 [inline]
       iput.part.0+0x5a8/0x7f0 fs/inode.c:1767
       iput+0x5c/0x80 fs/inode.c:1757
       dentry_unlink_inode+0x295/0x440 fs/dcache.c:400
       __dentry_kill+0x1d0/0x600 fs/dcache.c:603
       shrink_kill fs/dcache.c:1048 [inline]
       shrink_dentry_list+0x140/0x5d0 fs/dcache.c:1075
       prune_dcache_sb+0xeb/0x150 fs/dcache.c:1156
       super_cache_scan+0x32a/0x550 fs/super.c:221
       do_shrink_slab+0x44f/0x11c0 mm/shrinker.c:435
       shrink_slab_memcg mm/shrinker.c:548 [inline]
       shrink_slab+0xa87/0x1310 mm/shrinker.c:626
       shrink_one+0x493/0x7c0 mm/vmscan.c:4774
       shrink_many mm/vmscan.c:4835 [inline]
       lru_gen_shrink_node+0x89f/0x1750 mm/vmscan.c:4935
       shrink_node mm/vmscan.c:5894 [inline]
       kswapd_shrink_node mm/vmscan.c:6704 [inline]
       balance_pgdat+0x10d1/0x1a10 mm/vmscan.c:6895
       kswapd+0x5ea/0xbf0 mm/vmscan.c:7164
       kthread+0x2c1/0x3a0 kernel/kthread.c:388
       ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

other info that might help us debug this:

Chain exists of:
  sb_internal#4 --> &nilfs->ns_segctor_sem --> fs_reclaim

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&nilfs->ns_segctor_sem);
                               lock(fs_reclaim);
  rlock(sb_internal#4);

 *** DEADLOCK ***

2 locks held by kswapd0/111:
 #0: ffffffff8d9390c0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x166/0x1a10 mm/vmscan.c:6782
 #1: ffff888018e7e0e0 (&type->s_umount_key#74){++++}-{3:3}, at: super_trylock_shared fs/super.c:561 [inline]
 #1: ffff888018e7e0e0 (&type->s_umount_key#74){++++}-{3:3}, at: super_cache_scan+0x96/0x550 fs/super.c:196

stack backtrace:
CPU: 2 PID: 111 Comm: kswapd0 Not tainted 6.9.0-syzkaller-01893-g6bfd2d442af5 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:114
 check_noncircular+0x31a/0x400 kernel/locking/lockdep.c:2187
 check_prev_add kernel/locking/lockdep.c:3134 [inline]
 check_prevs_add kernel/locking/lockdep.c:3253 [inline]
 validate_chain kernel/locking/lockdep.c:3869 [inline]
 __lock_acquire+0x2478/0x3b30 kernel/locking/lockdep.c:5137
 lock_acquire kernel/locking/lockdep.c:5754 [inline]
 lock_acquire+0x1b1/0x560 kernel/locking/lockdep.c:5719
 percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
 __sb_start_write include/linux/fs.h:1661 [inline]
 sb_start_intwrite include/linux/fs.h:1844 [inline]
 nilfs_transaction_begin+0x21b/0xa40 fs/nilfs2/segment.c:220
 nilfs_evict_inode+0x157/0x550 fs/nilfs2/inode.c:924
 evict+0x2ed/0x6c0 fs/inode.c:667
 iput_final fs/inode.c:1741 [inline]
 iput.part.0+0x5a8/0x7f0 fs/inode.c:1767
 iput+0x5c/0x80 fs/inode.c:1757
 dentry_unlink_inode+0x295/0x440 fs/dcache.c:400
 __dentry_kill+0x1d0/0x600 fs/dcache.c:603
 shrink_kill fs/dcache.c:1048 [inline]
 shrink_dentry_list+0x140/0x5d0 fs/dcache.c:1075
 prune_dcache_sb+0xeb/0x150 fs/dcache.c:1156
 super_cache_scan+0x32a/0x550 fs/super.c:221
 do_shrink_slab+0x44f/0x11c0 mm/shrinker.c:435
 shrink_slab_memcg mm/shrinker.c:548 [inline]
 shrink_slab+0xa87/0x1310 mm/shrinker.c:626
 shrink_one+0x493/0x7c0 mm/vmscan.c:4774
 shrink_many mm/vmscan.c:4835 [inline]
 lru_gen_shrink_node+0x89f/0x1750 mm/vmscan.c:4935
 shrink_node mm/vmscan.c:5894 [inline]
 kswapd_shrink_node mm/vmscan.c:6704 [inline]
 balance_pgdat+0x10d1/0x1a10 mm/vmscan.c:6895
 kswapd+0x5ea/0xbf0 mm/vmscan.c:7164
 kthread+0x2c1/0x3a0 kernel/kthread.c:388
 ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
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
