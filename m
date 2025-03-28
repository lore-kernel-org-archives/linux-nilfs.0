Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8898E22094
	for <linux-nilfs@vger.kernel.org>; Fri, 28 Mar 2025 14:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743172648; cv=none; b=aBfSfVqaaZ8tWqN9kNbgJI4ZmJp3OUyBpiCyhtDUf4IecnKbrpoEaswB5M7D6x2CNX93PUZiXU/D6wGCBWBr9w+9C2n30csYuRXk9OQCNocRUMxgzhayx47sHsw38NpeFg3P9gc+kMFHz87PMEIuI6BmKXV4QA1RJj/X0tbmVhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743172648; c=relaxed/simple;
	bh=OBYzTZFoHAN83oXuieaMTBSdlLVwJk2BCIyVJvz4jT8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=gWGvnZOw6K29rUCRrIKx7H8ctslAQldtlN/EB7ONZ5oI/Px4NTaXul+yLTwlnx35fYKRxOFpva4Nm6DyxGhXBxYL/R3d7bw8OySOx1LqvSg21gLsOuCtw6gByOIIseI8cIT1jQDe4wHzRTU4rBxf3hkdjb9WKSlJFxFSRIL1wW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d43d3338d7so39510335ab.0
        for <linux-nilfs@vger.kernel.org>; Fri, 28 Mar 2025 07:37:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743172646; x=1743777446;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=in9Fxz7sPmLisq9z/I1FINk98QZ3Ufr2as9HZQd05tA=;
        b=SANKJvSuFGr45QSXOa+QCyYI7tG2th4ugWr73zWcT00zSRFEFmGC5JiLgixh+P33oo
         JhcYfWSYo3ywO9c8gAzY3G6K/Zr47x+f3ciidkMJf66dXos0JuBKjagDD0v6pQngHcmb
         WhJVeH2z+Nl3X9HxkSWzT+Hv39E59wU3W9W783oF2WvXgmXDCc4BW/UtlJ9WuYV4UnJ3
         bv15iKifyRENM414EVUSFijvc6FmVhvfsOmm5cGcWg0P0peXQqDzIhlpJRjkYmdzUYkP
         2rdMktSvqBhE8foqwkYYTj4DyfiFbyOw3OuBgt/lV0hZWeAoa70yXJVkW0mGKUDt1IXm
         D7+g==
X-Forwarded-Encrypted: i=1; AJvYcCVHUW89sHp3Ck6g7BkkaA82Shkreth18nVk8SOWB2KdzOmwyGbNtiVZOBXTvL7zlzSsPVHDCpWxPjixTg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxX36IFeDrQ+upRvl+K6jJM9k3KczPfkUVD9ctFrUbcq5Gk5jTO
	Y84wfx7yxlx/VaNwdv7JdIuJtW1RmgUgz9C4gMuDD45mUEIuHdWKD1xYaqsesKOGE/5iM5gLRBm
	hTvfasUfHtvV+F7MLUafhThIuWR8Gjcki1mQaeJBGTQQhGp2tuCh+kbM=
X-Google-Smtp-Source: AGHT+IFIw/vm3Pb5HkzUoplyyGcu4k31jdIztWPHjANo/3dqRfCoVHBbF8hQTvlKxNe3xHVcKBaTvNemuNRVSJ/0ZdeY5YhxzH6Z
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3c02:b0:3d4:244b:db20 with SMTP id
 e9e14a558f8ab-3d5cce1d301mr84009215ab.16.1743172645612; Fri, 28 Mar 2025
 07:37:25 -0700 (PDT)
Date: Fri, 28 Mar 2025 07:37:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67e6b425.050a0220.2f068f.007c.GAE@google.com>
Subject: [syzbot] [nilfs?] possible deadlock in nilfs_evict_inode (3)
From: syzbot <syzbot+cfb767df63e683c533af@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    586de92313fc Merge tag 'i2c-for-6.14-rc8' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1207243f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=27515cfdbafbb90d
dashboard link: https://syzkaller.appspot.com/bug?extid=cfb767df63e683c533af
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-586de923.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ce0ae238d692/vmlinux-586de923.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c8c843acbfaf/bzImage-586de923.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cfb767df63e683c533af@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.14.0-rc7-syzkaller-00205-g586de92313fc #0 Not tainted
------------------------------------------------------
kswapd1/82 is trying to acquire lock:
ffff8880440f4610 (sb_internal#2){.+.+}-{0:0}, at: nilfs_evict_inode+0x167/0x500 fs/nilfs2/inode.c:859

but task is already holding lock:
ffffffff8ec3a6c0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6886 [inline]
ffffffff8ec3a6c0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xb9f/0x3b10 mm/vmscan.c:7264

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (fs_reclaim){+.+.}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       __fs_reclaim_acquire mm/page_alloc.c:3853 [inline]
       fs_reclaim_acquire+0x88/0x130 mm/page_alloc.c:3867
       might_alloc include/linux/sched/mm.h:318 [inline]
       slab_pre_alloc_hook mm/slub.c:4066 [inline]
       slab_alloc_node mm/slub.c:4144 [inline]
       kmem_cache_alloc_node_noprof+0x48/0x380 mm/slub.c:4216
       __alloc_skb+0x1c3/0x440 net/core/skbuff.c:596
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

-> #3 (uevent_sock_mutex){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x19c/0x1010 kernel/locking/mutex.c:730
       uevent_net_broadcast_untagged lib/kobject_uevent.c:317 [inline]
       kobject_uevent_net_broadcast+0x280/0x580 lib/kobject_uevent.c:410
       kobject_uevent_env+0x57d/0x8e0 lib/kobject_uevent.c:608
       loop_set_size drivers/block/loop.c:235 [inline]
       loop_set_status+0x4f8/0x800 drivers/block/loop.c:1292
       lo_ioctl+0xce6/0x2870
       blkdev_ioctl+0x5d0/0x6f0 block/ioctl.c:693
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&q->q_usage_counter(io)#17){++++}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       bio_queue_enter block/blk.h:78 [inline]
       blk_mq_submit_bio+0x14e1/0x25d0 block/blk-mq.c:3091
       __submit_bio+0x2cf/0x6a0 block/blk-core.c:628
       __submit_bio_noacct_mq block/blk-core.c:715 [inline]
       submit_bio_noacct_nocheck+0x4d3/0xe30 block/blk-core.c:744
       nilfs_mdt_submit_block+0x5c5/0x880 fs/nilfs2/mdt.c:153
       nilfs_mdt_read_block+0xeb/0x430 fs/nilfs2/mdt.c:178
       nilfs_mdt_get_block+0x10a/0xa30 fs/nilfs2/mdt.c:254
       nilfs_palloc_get_block+0x181/0x2a0 fs/nilfs2/alloc.c:239
       nilfs_palloc_get_bitmap_block fs/nilfs2/alloc.c:317 [inline]
       nilfs_palloc_prepare_alloc_entry+0x71c/0x1070 fs/nilfs2/alloc.c:621
       nilfs_ifile_create_inode+0x156/0x3a0 fs/nilfs2/ifile.c:61
       nilfs_new_inode+0x254/0x830 fs/nilfs2/inode.c:321
       nilfs_create+0xfd/0x2d0 fs/nilfs2/namei.c:98
       lookup_open fs/namei.c:3651 [inline]
       open_last_lookups fs/namei.c:3750 [inline]
       path_openat+0x193c/0x3590 fs/namei.c:3986
       do_filp_open+0x27f/0x4e0 fs/namei.c:4016
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1428
       do_sys_open fs/open.c:1443 [inline]
       __do_sys_openat fs/open.c:1459 [inline]
       __se_sys_openat fs/open.c:1454 [inline]
       __x64_sys_openat+0x247/0x2a0 fs/open.c:1454
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&nilfs->ns_segctor_sem){++++}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
       nilfs_transaction_begin+0x320/0x6e0 fs/nilfs2/segment.c:221
       nilfs_create+0xc7/0x2d0 fs/nilfs2/namei.c:95
       lookup_open fs/namei.c:3651 [inline]
       open_last_lookups fs/namei.c:3750 [inline]
       path_openat+0x193c/0x3590 fs/namei.c:3986
       do_filp_open+0x27f/0x4e0 fs/namei.c:4016
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1428
       do_sys_open fs/open.c:1443 [inline]
       __do_sys_openat fs/open.c:1459 [inline]
       __se_sys_openat fs/open.c:1454 [inline]
       __x64_sys_openat+0x247/0x2a0 fs/open.c:1454
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (sb_internal#2){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3163 [inline]
       check_prevs_add kernel/locking/lockdep.c:3282 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1785 [inline]
       sb_start_intwrite include/linux/fs.h:1968 [inline]
       nilfs_transaction_begin+0x216/0x6e0 fs/nilfs2/segment.c:218
       nilfs_evict_inode+0x167/0x500 fs/nilfs2/inode.c:859
       evict+0x4e8/0x9a0 fs/inode.c:796
       __dentry_kill+0x20d/0x630 fs/dcache.c:643
       shrink_kill+0xa9/0x2c0 fs/dcache.c:1088
       shrink_dentry_list+0x2c0/0x5b0 fs/dcache.c:1115
       prune_dcache_sb+0x10f/0x180 fs/dcache.c:1196
       super_cache_scan+0x34f/0x4b0 fs/super.c:221
       do_shrink_slab+0x72d/0x1160 mm/shrinker.c:437
       shrink_slab_memcg mm/shrinker.c:550 [inline]
       shrink_slab+0x878/0x14d0 mm/shrinker.c:628
       shrink_one+0x43b/0x850 mm/vmscan.c:4868
       shrink_many mm/vmscan.c:4929 [inline]
       lru_gen_shrink_node mm/vmscan.c:5007 [inline]
       shrink_node+0x379b/0x3e20 mm/vmscan.c:5978
       kswapd_shrink_node mm/vmscan.c:6807 [inline]
       balance_pgdat mm/vmscan.c:6999 [inline]
       kswapd+0x20f3/0x3b10 mm/vmscan.c:7264
       kthread+0x7a9/0x920 kernel/kthread.c:464
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

other info that might help us debug this:

Chain exists of:
  sb_internal#2 --> uevent_sock_mutex --> fs_reclaim

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(uevent_sock_mutex);
                               lock(fs_reclaim);
  rlock(sb_internal#2);

 *** DEADLOCK ***

2 locks held by kswapd1/82:
 #0: ffffffff8ec3a6c0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6886 [inline]
 #0: ffffffff8ec3a6c0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xb9f/0x3b10 mm/vmscan.c:7264
 #1: ffff8880440f40e0 (&type->s_umount_key#50){.+.+}-{4:4}, at: super_trylock_shared fs/super.c:562 [inline]
 #1: ffff8880440f40e0 (&type->s_umount_key#50){.+.+}-{4:4}, at: super_cache_scan+0x94/0x4b0 fs/super.c:196

stack backtrace:
CPU: 0 UID: 0 PID: 82 Comm: kswapd1 Not tainted 6.14.0-rc7-syzkaller-00205-g586de92313fc #0
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
 percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
 __sb_start_write include/linux/fs.h:1785 [inline]
 sb_start_intwrite include/linux/fs.h:1968 [inline]
 nilfs_transaction_begin+0x216/0x6e0 fs/nilfs2/segment.c:218
 nilfs_evict_inode+0x167/0x500 fs/nilfs2/inode.c:859
 evict+0x4e8/0x9a0 fs/inode.c:796
 __dentry_kill+0x20d/0x630 fs/dcache.c:643
 shrink_kill+0xa9/0x2c0 fs/dcache.c:1088
 shrink_dentry_list+0x2c0/0x5b0 fs/dcache.c:1115
 prune_dcache_sb+0x10f/0x180 fs/dcache.c:1196
 super_cache_scan+0x34f/0x4b0 fs/super.c:221
 do_shrink_slab+0x72d/0x1160 mm/shrinker.c:437
 shrink_slab_memcg mm/shrinker.c:550 [inline]
 shrink_slab+0x878/0x14d0 mm/shrinker.c:628
 shrink_one+0x43b/0x850 mm/vmscan.c:4868
 shrink_many mm/vmscan.c:4929 [inline]
 lru_gen_shrink_node mm/vmscan.c:5007 [inline]
 shrink_node+0x379b/0x3e20 mm/vmscan.c:5978
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
