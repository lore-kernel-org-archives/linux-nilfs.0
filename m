Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457B51D31B2
	for <linux-nilfs@vger.kernel.org>; Sat, 19 Oct 2024 05:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729314870; cv=none; b=K9RU9OIsCaCwCpCi6FxKEmHF6+AVJAiKdIciQCBQqa4rNioGqLHLk3fpb0124oYyzjXdm47GLy9qlIR58ytDpufteIBeKFqjTGIwPW7822tGAbqHNQJxTcHxoOfllhPVZEgjs2cP/eo6JT8o7bLqYE0gVKvsKOZnEgV/gJqbIYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729314870; c=relaxed/simple;
	bh=jQqJd3f2riE0QHl/3tzAbyAQqQxAvlfbNxbeI6AspEw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=phfvZt+KUvjDI7RMTfzXh4aqywIodDUNOZnpW7Fc4JI8WkJuvGCrTj6g3CLPVZmfDFjrYqA6fUTu8Ausa+EZE63x+LYJUr4oVmoyaJd3/19adh6zupKLlK+6cE29DgUL5R6JhXVboKFN/5K7JCY0/Zi9XwxYUMNzsIAysrbABU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a3972c435dso24615365ab.0
        for <linux-nilfs@vger.kernel.org>; Fri, 18 Oct 2024 22:14:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729314867; x=1729919667;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tEYw0fhHA0VYRi0ziT7jMy1rPvXCW3e+5w0LF2njhaQ=;
        b=NHY4LYA7iX4nydA6PUYQe1YfvsMUSgXtorfhh8V4YEW4ry6YKz2mYaRLJ4o722CSP8
         0WF94/0d/Eq1Qh0VYRxKIifosWHvUokwy/UF4D8z3h+gWDgDjtRtlzmSCWdqqR/SwBAX
         CUHF57Wzt3GJumMEgQYMGZXNUOEtXM/+FFmrXwGw5OKG+v6WRhSAHpuwKmogGD4CyYgl
         Tuo362td47Wbl7apKfht2cR1QxI2iLAx7rj8fNB6THzataZZaDLOlx7CpRRAuq065856
         fYpuixvNDANbSx2mLGzPXHXpo0RA2y7JbwX0n0/fpo/kZhemo7ai/Lrzp8CWA5E/Nzf9
         zABw==
X-Forwarded-Encrypted: i=1; AJvYcCVQpM6rV721HCTDIypdIfhq5Dsi6FEG3VnApfrEdJSG7a0IRBWEArDzG7b/VDU/+Z/rIEWNiYmrDpIfHg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyTzLXqCgWc8Qit0m/vhTlyP2jjU3SBYfHUFluY1FrrNrlU1X74
	jnZbDeZ8M5TeK72/G2+4WW/Ilnmdv36cpxw9WKM4ycCM1Genprw4qsnQx07N7gF4665x9Bm/UEz
	X8WIFXaeNeZJpRm/5wb3L7ieHQDzYyE/EeGmvDgim15OKNU1YXuX8Mj0=
X-Google-Smtp-Source: AGHT+IHKyA2DYOhiRSurMjGgDp4dpao/kX+IPqQnuHuZG25RHasWFKPsZ/Cd4NN7e+bF4nBELaydBRoN/5P/exYv39XIfqHrkfLI
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c541:0:b0:3a0:926a:8d31 with SMTP id
 e9e14a558f8ab-3a3f40a86aemr55249035ab.16.1729314867183; Fri, 18 Oct 2024
 22:14:27 -0700 (PDT)
Date: Fri, 18 Oct 2024 22:14:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67134033.050a0220.1e4b4d.001f.GAE@google.com>
Subject: [syzbot] [nilfs?] possible deadlock in nilfs_dirty_inode (4)
From: syzbot <syzbot+9ef37ac20608f4836256@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    eca631b8fe80 Merge tag 'f2fs-6.12-rc4' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=101f4030580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbd94c114a3d407
dashboard link: https://syzkaller.appspot.com/bug?extid=9ef37ac20608f4836256
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1705f85f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17d81887980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-eca631b8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/830e1433408d/vmlinux-eca631b8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5538dfbaa4ef/bzImage-eca631b8.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/049290da6bbe/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/c0f1baa786eb/mount_4.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9ef37ac20608f4836256@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.12.0-rc3-syzkaller-00013-geca631b8fe80 #0 Not tainted
------------------------------------------------------
kswapd0/73 is trying to acquire lock:
ffff888011a34610 (sb_internal#2){.+.+}-{0:0}, at: nilfs_dirty_inode+0x158/0x200 fs/nilfs2/inode.c:1110

but task is already holding lock:
ffffffff8ea37160 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6844 [inline]
ffffffff8ea37160 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xbf1/0x3700 mm/vmscan.c:7226

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (fs_reclaim){+.+.}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       __fs_reclaim_acquire mm/page_alloc.c:3834 [inline]
       fs_reclaim_acquire+0x88/0x130 mm/page_alloc.c:3848
       might_alloc include/linux/sched/mm.h:318 [inline]
       prepare_alloc_pages+0x147/0x5b0 mm/page_alloc.c:4493
       __alloc_pages_noprof+0x16f/0x710 mm/page_alloc.c:4722
       alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
       alloc_pages_noprof mm/mempolicy.c:2345 [inline]
       folio_alloc_noprof+0x128/0x180 mm/mempolicy.c:2352
       filemap_alloc_folio_noprof+0xdf/0x500 mm/filemap.c:1010
       __filemap_get_folio+0x446/0xbd0 mm/filemap.c:1952
       block_write_begin+0x66/0x120 fs/buffer.c:2226
       nilfs_write_begin+0xa0/0x110 fs/nilfs2/inode.c:259
       page_symlink+0x2a6/0x4a0 fs/namei.c:5362
       nilfs_symlink+0x236/0x380 fs/nilfs2/namei.c:153
       vfs_symlink+0x137/0x2e0 fs/namei.c:4615
       do_symlinkat+0x222/0x3a0 fs/namei.c:4641
       __do_sys_symlink fs/namei.c:4662 [inline]
       __se_sys_symlink fs/namei.c:4660 [inline]
       __x64_sys_symlink+0x7a/0x90 fs/namei.c:4660
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&nilfs->ns_segctor_sem){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
       nilfs_transaction_begin+0x320/0x6e0 fs/nilfs2/segment.c:223
       nilfs_symlink+0x135/0x380 fs/nilfs2/namei.c:140
       vfs_symlink+0x137/0x2e0 fs/namei.c:4615
       do_symlinkat+0x222/0x3a0 fs/namei.c:4641
       __do_sys_symlink fs/namei.c:4662 [inline]
       __se_sys_symlink fs/namei.c:4660 [inline]
       __x64_sys_symlink+0x7a/0x90 fs/namei.c:4660
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (sb_internal#2){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5202
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1716 [inline]
       sb_start_intwrite include/linux/fs.h:1899 [inline]
       nilfs_transaction_begin+0x216/0x6e0 fs/nilfs2/segment.c:220
       nilfs_dirty_inode+0x158/0x200 fs/nilfs2/inode.c:1110
       __mark_inode_dirty+0x2ee/0xe90 fs/fs-writeback.c:2493
       mark_inode_dirty_sync include/linux/fs.h:2479 [inline]
       iput+0x1f1/0xa50 fs/inode.c:1900
       __dentry_kill+0x20d/0x630 fs/dcache.c:615
       shrink_kill+0xa9/0x2c0 fs/dcache.c:1060
       shrink_dentry_list+0x2c0/0x5b0 fs/dcache.c:1087
       prune_dcache_sb+0x10f/0x180 fs/dcache.c:1168
       super_cache_scan+0x34f/0x4b0 fs/super.c:221
       do_shrink_slab+0x701/0x1160 mm/shrinker.c:435
       shrink_slab+0x1093/0x14d0 mm/shrinker.c:662
       shrink_one+0x43b/0x850 mm/vmscan.c:4818
       shrink_many mm/vmscan.c:4879 [inline]
       lru_gen_shrink_node mm/vmscan.c:4957 [inline]
       shrink_node+0x3799/0x3de0 mm/vmscan.c:5937
       kswapd_shrink_node mm/vmscan.c:6765 [inline]
       balance_pgdat mm/vmscan.c:6957 [inline]
       kswapd+0x1ca3/0x3700 mm/vmscan.c:7226
       kthread+0x2f0/0x390 kernel/kthread.c:389
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

other info that might help us debug this:

Chain exists of:
  sb_internal#2 --> &nilfs->ns_segctor_sem --> fs_reclaim

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&nilfs->ns_segctor_sem);
                               lock(fs_reclaim);
  rlock(sb_internal#2);

 *** DEADLOCK ***

2 locks held by kswapd0/73:
 #0: ffffffff8ea37160 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6844 [inline]
 #0: ffffffff8ea37160 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xbf1/0x3700 mm/vmscan.c:7226
 #1: ffff888011a340e0 (&type->s_umount_key#44){++++}-{3:3}, at: super_trylock_shared fs/super.c:562 [inline]
 #1: ffff888011a340e0 (&type->s_umount_key#44){++++}-{3:3}, at: super_cache_scan+0x94/0x4b0 fs/super.c:196

stack backtrace:
CPU: 0 UID: 0 PID: 73 Comm: kswapd0 Not tainted 6.12.0-rc3-syzkaller-00013-geca631b8fe80 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2074
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
 __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5202
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
 percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
 __sb_start_write include/linux/fs.h:1716 [inline]
 sb_start_intwrite include/linux/fs.h:1899 [inline]
 nilfs_transaction_begin+0x216/0x6e0 fs/nilfs2/segment.c:220
 nilfs_dirty_inode+0x158/0x200 fs/nilfs2/inode.c:1110
 __mark_inode_dirty+0x2ee/0xe90 fs/fs-writeback.c:2493
 mark_inode_dirty_sync include/linux/fs.h:2479 [inline]
 iput+0x1f1/0xa50 fs/inode.c:1900
 __dentry_kill+0x20d/0x630 fs/dcache.c:615
 shrink_kill+0xa9/0x2c0 fs/dcache.c:1060
 shrink_dentry_list+0x2c0/0x5b0 fs/dcache.c:1087
 prune_dcache_sb+0x10f/0x180 fs/dcache.c:1168
 super_cache_scan+0x34f/0x4b0 fs/super.c:221
 do_shrink_slab+0x701/0x1160 mm/shrinker.c:435
 shrink_slab+0x1093/0x14d0 mm/shrinker.c:662
 shrink_one+0x43b/0x850 mm/vmscan.c:4818
 shrink_many mm/vmscan.c:4879 [inline]
 lru_gen_shrink_node mm/vmscan.c:4957 [inline]
 shrink_node+0x3799/0x3de0 mm/vmscan.c:5937
 kswapd_shrink_node mm/vmscan.c:6765 [inline]
 balance_pgdat mm/vmscan.c:6957 [inline]
 kswapd+0x1ca3/0x3700 mm/vmscan.c:7226
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
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
