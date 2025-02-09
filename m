Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CAB15B546
	for <linux-nilfs@vger.kernel.org>; Sun,  9 Feb 2025 14:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739112865; cv=none; b=XjUs0R8R0k8APv/93Yqb16izfqbTxr4NPbIe9vBFrsy+c6kVpdVL+YpyE2DTxYAhL4K+m2EyCpJmCxslP2RIsZYA3CHBi3VGMuBeGyaoPBgpeIC1gxRfQHvqOlGZK6vPEY8lKVle3zF7SW7Bdskc+39CgH1gpJRRYnXsETZGuhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739112865; c=relaxed/simple;
	bh=AeJ96wjGswKTDXfnHm36nX76HZaeJ9jxU/Zu8QddFAQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Sd7j7urSuDir3wStixjhDeAhbHiANcyBfB+gL2lDyqWJT/m6WpOKtChAhZ4tIoRenC3L67cXhANsPNrdYr5gZpqeiCvNHPOXBDOtr0cFffgYq1mQ/AnYKjKpnSyx0PgTMTVxAXwUea/k+yvCawWdIzM3xuJyZZnnAszJUD1xRwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3cfb20d74b5so29552935ab.3
        for <linux-nilfs@vger.kernel.org>; Sun, 09 Feb 2025 06:54:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739112863; x=1739717663;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7nz9UlUnjnQqbAEiWSUUu4+Q2pwjTLwC0fT1nvy12d8=;
        b=mzrEglfy37uKMcHW/XtAkFhyT77/vVVDHMsevRIDgiQOA/DS+8VdzmYdmgqbe3eqoo
         Tk/7eP2ScdHa1XlpxKVOUsqVq0wK4BQXJ6oHSibDfyXM4JHXaEx9taMcnYzSXix4OeLL
         aFGReRKNHkNudJGj3rvMcEBUJ1E6fjIwGfSNZhS4ca2EFOwRwOYDi9IAconMDG0alKk0
         tfOdihFBzkKC2tPkzQgDY+0/iUfFiN8hEfDzxejZhT8/UPvw5j+thd0vOgLPDLfN3UpE
         8tc/TbE0+3/MeYL4cpeKf9kT3poiVy8sNA83CkE42RGmKY8YUhyoZT2ftg/9l54vtqJy
         amHA==
X-Forwarded-Encrypted: i=1; AJvYcCWhmwSBoMJuAkVt5eopARovF0GzEOQQk756N3rNF7X9skYG0R1GkYYV7l6mxRFDtS5znpCST8ZDXR0Sjg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyCMNKprHqL6uhnc0WAdkdV1sumxM4h7lkze8/XsT8suIU75rik
	nEXi8ZfDuodEg4GM/ydcBJh5o9DkaEYviBgxlw6FJl+YJUCl0a4OXsOnVTASWy+K9G+N6fgZEo1
	LHIOZOU9waMy653e8+GslQ35HEV19oUxHH/SgXVQAjdibW1hibKF8zsY=
X-Google-Smtp-Source: AGHT+IFkaLhp8zlBB3MCaA6wNK6oj75MPtlBGQ2bmAJG360+Cx4h1/qyi3420m2OlYv/bLOiSX4hhbttf7Qtq6cIR7uB3VdBhiG8
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:216a:b0:3cf:fd28:852 with SMTP id
 e9e14a558f8ab-3d13dd0280fmr104591105ab.3.1739112863190; Sun, 09 Feb 2025
 06:54:23 -0800 (PST)
Date: Sun, 09 Feb 2025 06:54:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a8c19f.050a0220.110943.001b.GAE@google.com>
Subject: [syzbot] [nilfs?] possible deadlock in nilfs_bmap_clear (2)
From: syzbot <syzbot+4d7417d6eb8b36554c0d@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5c8c229261f1 Merge tag 'kthreads-fixes-2025-02-04' of git:..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=113e93df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1909f2f0d8e641ce
dashboard link: https://syzkaller.appspot.com/bug?extid=4d7417d6eb8b36554c0d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-5c8c2292.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fc7bd0937147/vmlinux-5c8c2292.xz
kernel image: https://storage.googleapis.com/syzbot-assets/55fb37b08731/bzImage-5c8c2292.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4d7417d6eb8b36554c0d@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.14.0-rc1-syzkaller-00028-g5c8c229261f1 #0 Not tainted
------------------------------------------------------
kswapd0/77 is trying to acquire lock:
ffff888011b773c0 (&bmap->b_sem){++++}-{4:4}, at: nilfs_bmap_clear+0x29/0xa0 fs/nilfs2/bmap.c:305

but task is already holding lock:
ffffffff8ea392e0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6886 [inline]
ffffffff8ea392e0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xb9f/0x3b10 mm/vmscan.c:7264

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (fs_reclaim){+.+.}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       __fs_reclaim_acquire mm/page_alloc.c:3853 [inline]
       fs_reclaim_acquire+0x88/0x130 mm/page_alloc.c:3867
       might_alloc include/linux/sched/mm.h:318 [inline]
       slab_pre_alloc_hook mm/slub.c:4066 [inline]
       slab_alloc_node mm/slub.c:4144 [inline]
       kmem_cache_alloc_node_noprof+0x48/0x380 mm/slub.c:4216
       __alloc_skb+0x1c3/0x440 net/core/skbuff.c:668
       alloc_skb include/linux/skbuff.h:1331 [inline]
       alloc_uevent_skb+0x74/0x230 lib/kobject_uevent.c:289
       uevent_net_broadcast_untagged lib/kobject_uevent.c:326 [inline]
       kobject_uevent_net_broadcast+0x2fd/0x580 lib/kobject_uevent.c:410
       kobject_uevent_env+0x57d/0x8e0 lib/kobject_uevent.c:608
       kobject_synth_uevent+0x4ef/0xae0 lib/kobject_uevent.c:207
       bus_uevent_store+0x116/0x170 drivers/base/bus.c:832
       kernfs_fop_write_iter+0x3a0/0x500 fs/kernfs/file.c:334
       new_sync_write fs/read_write.c:586 [inline]
       vfs_write+0xacf/0xd10 fs/read_write.c:679
       ksys_write+0x18f/0x2b0 fs/read_write.c:731
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (uevent_sock_mutex){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x19c/0x1010 kernel/locking/mutex.c:730
       uevent_net_broadcast_untagged lib/kobject_uevent.c:317 [inline]
       kobject_uevent_net_broadcast+0x280/0x580 lib/kobject_uevent.c:410
       kobject_uevent_env+0x57d/0x8e0 lib/kobject_uevent.c:608
       loop_set_size drivers/block/loop.c:235 [inline]
       loop_set_status+0x687/0x9e0 drivers/block/loop.c:1292
       lo_ioctl+0xcd9/0x2600
       blkdev_ioctl+0x57d/0x6a0 block/ioctl.c:693
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&q->q_usage_counter(io)#17){++++}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       bio_queue_enter block/blk.h:77 [inline]
       blk_mq_submit_bio+0x14e1/0x25a0 block/blk-mq.c:3091
       __submit_bio+0x2cf/0x6a0 block/blk-core.c:628
       __submit_bio_noacct_mq block/blk-core.c:715 [inline]
       submit_bio_noacct_nocheck+0x4d3/0xe30 block/blk-core.c:744
       nilfs_mdt_submit_block+0x5c5/0x880 fs/nilfs2/mdt.c:153
       nilfs_mdt_read_block+0xeb/0x430 fs/nilfs2/mdt.c:178
       nilfs_mdt_get_block+0x10a/0xa30 fs/nilfs2/mdt.c:254
       nilfs_palloc_get_block+0x181/0x2a0 fs/nilfs2/alloc.c:239
       nilfs_palloc_get_desc_block fs/nilfs2/alloc.c:296 [inline]
       nilfs_palloc_prepare_alloc_entry+0x3ee/0x1070 fs/nilfs2/alloc.c:607
       nilfs_dat_prepare_alloc fs/nilfs2/dat.c:78 [inline]
       nilfs_dat_prepare_update+0x6e/0x320 fs/nilfs2/dat.c:250
       nilfs_direct_propagate+0x1ec/0x3c0 fs/nilfs2/direct.c:279
       nilfs_bmap_propagate+0x75/0x120 fs/nilfs2/bmap.c:329
       nilfs_collect_file_data+0x4d/0xd0 fs/nilfs2/segment.c:589
       nilfs_segctor_apply_buffers+0x184/0x340 fs/nilfs2/segment.c:1010
       nilfs_segctor_scan_file+0x791/0xa50 fs/nilfs2/segment.c:1059
       nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1221 [inline]
       nilfs_segctor_collect fs/nilfs2/segment.c:1547 [inline]
       nilfs_segctor_do_construct+0x1c2b/0x6ea0 fs/nilfs2/segment.c:2122
       nilfs_segctor_construct+0x181/0x6b0 fs/nilfs2/segment.c:2478
       nilfs_segctor_thread_construct fs/nilfs2/segment.c:2586 [inline]
       nilfs_segctor_thread+0x69e/0xe80 fs/nilfs2/segment.c:2700
       kthread+0x7a9/0x920 kernel/kthread.c:464
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #0 (&bmap->b_sem){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3163 [inline]
       check_prevs_add kernel/locking/lockdep.c:3282 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       nilfs_bmap_clear+0x29/0xa0 fs/nilfs2/bmap.c:305
       nilfs_clear_inode+0x147/0x2a0 fs/nilfs2/inode.c:836
       nilfs_evict_inode+0x105/0x500 fs/nilfs2/inode.c:856
       evict+0x4e8/0x9a0 fs/inode.c:796
       dispose_list fs/inode.c:845 [inline]
       prune_icache_sb+0x239/0x2f0 fs/inode.c:1033
       super_cache_scan+0x38c/0x4b0 fs/super.c:223
       do_shrink_slab+0x72d/0x1160 mm/shrinker.c:437
       shrink_slab_memcg mm/shrinker.c:550 [inline]
       shrink_slab+0x878/0x14d0 mm/shrinker.c:628
       shrink_one+0x43b/0x850 mm/vmscan.c:4868
       shrink_many mm/vmscan.c:4929 [inline]
       lru_gen_shrink_node mm/vmscan.c:5007 [inline]
       shrink_node+0x37c5/0x3e50 mm/vmscan.c:5978
       kswapd_shrink_node mm/vmscan.c:6807 [inline]
       balance_pgdat mm/vmscan.c:6999 [inline]
       kswapd+0x20f3/0x3b10 mm/vmscan.c:7264
       kthread+0x7a9/0x920 kernel/kthread.c:464
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

other info that might help us debug this:

Chain exists of:
  &bmap->b_sem --> uevent_sock_mutex --> fs_reclaim

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(uevent_sock_mutex);
                               lock(fs_reclaim);
  lock(&bmap->b_sem);

 *** DEADLOCK ***

2 locks held by kswapd0/77:
 #0: ffffffff8ea392e0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6886 [inline]
 #0: ffffffff8ea392e0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xb9f/0x3b10 mm/vmscan.c:7264
 #1: ffff888043b8c0e0 (&type->s_umount_key#49){.+.+}-{4:4}, at: super_trylock_shared fs/super.c:562 [inline]
 #1: ffff888043b8c0e0 (&type->s_umount_key#49){.+.+}-{4:4}, at: super_cache_scan+0x94/0x4b0 fs/super.c:196

stack backtrace:
CPU: 0 UID: 0 PID: 77 Comm: kswapd0 Not tainted 6.14.0-rc1-syzkaller-00028-g5c8c229261f1 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2076
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2208
 check_prev_add kernel/locking/lockdep.c:3163 [inline]
 check_prevs_add kernel/locking/lockdep.c:3282 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
 __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
 down_write+0x99/0x220 kernel/locking/rwsem.c:1577
 nilfs_bmap_clear+0x29/0xa0 fs/nilfs2/bmap.c:305
 nilfs_clear_inode+0x147/0x2a0 fs/nilfs2/inode.c:836
 nilfs_evict_inode+0x105/0x500 fs/nilfs2/inode.c:856
 evict+0x4e8/0x9a0 fs/inode.c:796
 dispose_list fs/inode.c:845 [inline]
 prune_icache_sb+0x239/0x2f0 fs/inode.c:1033
 super_cache_scan+0x38c/0x4b0 fs/super.c:223
 do_shrink_slab+0x72d/0x1160 mm/shrinker.c:437
 shrink_slab_memcg mm/shrinker.c:550 [inline]
 shrink_slab+0x878/0x14d0 mm/shrinker.c:628
 shrink_one+0x43b/0x850 mm/vmscan.c:4868
 shrink_many mm/vmscan.c:4929 [inline]
 lru_gen_shrink_node mm/vmscan.c:5007 [inline]
 shrink_node+0x37c5/0x3e50 mm/vmscan.c:5978
 kswapd_shrink_node mm/vmscan.c:6807 [inline]
 balance_pgdat mm/vmscan.c:6999 [inline]
 kswapd+0x20f3/0x3b10 mm/vmscan.c:7264
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
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
