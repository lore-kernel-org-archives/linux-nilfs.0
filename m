Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B08374FB
	for <linux-nilfs@vger.kernel.org>; Sat, 18 May 2024 12:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716035375; cv=none; b=G/NKKZtd6bkzFLah0oeA16bwl/d1foDFtpih6ofuvoYiGrX6CDwPW7nzPiJhYixvWtlWY2atmErCiJ5HpLVivbW7IY4wB3Jk9XnK34ek/8+J73YooSlHDWmADXopYdZSyk8D9aFOMceBcXte+dkHwf+AMvhEHtekZqVzhOxOvls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716035375; c=relaxed/simple;
	bh=FL19ndtJVT1jEoramjVP0De/6i7Va1NeaPMgBx4MzAE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=MkjZu2bjao/z53dZGCSCCv71hW/P6LGogiOxGkzAS6qgIAiPMofTAThQpGWYkzee5NEpAta5dYNfkf4WTpscAVr3BN4OwaU8Zkj5bp4uEM9tPDpOHPEG2fiObM2M7oTBU4CaMQU84oEdwiIR5MFEZopyBslndnDL0XcytxxZSAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7e1db7e5386so861533139f.3
        for <linux-nilfs@vger.kernel.org>; Sat, 18 May 2024 05:29:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716035373; x=1716640173;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fEAA6+enGti/b+5UaS6moDffnbXFlCLvFfjgXueob98=;
        b=oBlOUobKGOf2A1jB6atVPyqAc8yZIQK2wLWUoM6T0+FyrsPSZlEaXBp0ptU2boGUoF
         FxCheBTU1r0nOKg4BBHvFzaoXZ67PAnUnAG0TBcSPUEyvgocK97LFnuK+Bf3FPA2h/SH
         qoGmpsFt8WR8ixgQIFmyJsJjVzQcFNoJpFPVbfkFa8ivfn9soLey5ECdJ1WF5TR8L9vU
         ju0wIl7f719gdcM2YEwkBP80PhuWXTFld6by7lm6z/DkHlEQB+PBjgsW5dJ5puIYJXv4
         FgEk5qpuGCaa7tmFMk/w6Soek8qLjw/cOOvtgndt9tvdDQKnFR0ofDiXFSqPMgRkbeCh
         Gw3A==
X-Forwarded-Encrypted: i=1; AJvYcCV2MnP3knKHR8DyYuITTrZQJU54y1GcSiI0DQp7mTCRYRI2AoF/RdRlqh6QbIprIct7yVpM0mXnM8tI9oNpeIclGR0B5tq9EuSVulI=
X-Gm-Message-State: AOJu0YzVLArYlxTq9ua6q/oSFYwAWju1ZiPG2B3TtpH5JuJ6Z48fLja9
	B0B5RgO9yNy5nhzVGfHCO4cAqz5ZEWIgLNAi99Ahj6TLG6/s7z7Cpw0ujh6zf1656j3BHbv73ni
	hsU7FEQR7ywgq2DbgZuiqNcljGspID3ZDQssfNpYwkhWGH2q3WnzUxGU=
X-Google-Smtp-Source: AGHT+IEln7iHdvMc7d6tmFuEi2Z+hR3rxLiU3ZXOD91BYH/nkLanmyGwkEyDCaoTB7f+GMymPm7APjZR6XvyGBpy8WMHKDWPEmkY
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3793:b0:48a:37e1:a543 with SMTP id
 8926c6da1cb9f-48a37e1a688mr770748173.6.1716035373022; Sat, 18 May 2024
 05:29:33 -0700 (PDT)
Date: Sat, 18 May 2024 05:29:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d4cc840618b99e23@google.com>
Subject: [syzbot] [nilfs?] possible deadlock in nilfs_transaction_begin
From: syzbot <syzbot+77c39f023a0cb2e4c149@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a5131c3fdf26 Merge tag 'x86-shstk-2024-05-13' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=144c6e04980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fdb182f40cdd66f7
dashboard link: https://syzkaller.appspot.com/bug?extid=77c39f023a0cb2e4c149
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-a5131c3f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6d23116dab9c/vmlinux-a5131c3f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/dd8b9de9af4f/bzImage-a5131c3f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+77c39f023a0cb2e4c149@syzkaller.appspotmail.com

NILFS (loop2): inode bitmap is inconsistent for reserved inodes
NILFS (loop2): repaired inode bitmap for reserved inodes
======================================================
WARNING: possible circular locking dependency detected
6.9.0-syzkaller-01768-ga5131c3fdf26 #0 Not tainted
------------------------------------------------------
syz-executor.2/23478 is trying to acquire lock:
ffffffff8d938460 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:312 [inline]
ffffffff8d938460 (fs_reclaim){+.+.}-{0:0}, at: prepare_alloc_pages.constprop.0+0x155/0x560 mm/page_alloc.c:4346

but task is already holding lock:
ffff888026c5c2a0 (&nilfs->ns_segctor_sem){++++}-{3:3}, at: nilfs_transaction_begin+0x326/0xa40 fs/nilfs2/segment.c:223

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&nilfs->ns_segctor_sem){++++}-{3:3}:
       down_read+0x9a/0x330 kernel/locking/rwsem.c:1526
       nilfs_transaction_begin+0x326/0xa40 fs/nilfs2/segment.c:223
       nilfs_create+0xb7/0x320 fs/nilfs2/namei.c:82
       lookup_open.isra.0+0x10a1/0x13c0 fs/namei.c:3505
       open_last_lookups fs/namei.c:3574 [inline]
       path_openat+0x92f/0x2990 fs/namei.c:3804
       do_filp_open+0x1dc/0x430 fs/namei.c:3834
       do_sys_openat2+0x17a/0x1e0 fs/open.c:1406
       do_sys_open fs/open.c:1421 [inline]
       __do_compat_sys_openat fs/open.c:1481 [inline]
       __se_compat_sys_openat fs/open.c:1479 [inline]
       __ia32_compat_sys_openat+0x16e/0x210 fs/open.c:1479
       do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
       __do_fast_syscall_32+0x75/0x120 arch/x86/entry/common.c:386
       do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
       entry_SYSENTER_compat_after_hwframe+0x84/0x8e

-> #1 (sb_internal#5){.+.+}-{0:0}:
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1661 [inline]
       sb_start_intwrite include/linux/fs.h:1844 [inline]
       nilfs_transaction_begin+0x21b/0xa40 fs/nilfs2/segment.c:220
       nilfs_dirty_inode+0x1a4/0x270 fs/nilfs2/inode.c:1153
       __mark_inode_dirty+0x1f0/0xe70 fs/fs-writeback.c:2486
       mark_inode_dirty_sync include/linux/fs.h:2426 [inline]
       iput.part.0+0x5b/0x7f0 fs/inode.c:1764
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

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3134 [inline]
       check_prevs_add kernel/locking/lockdep.c:3253 [inline]
       validate_chain kernel/locking/lockdep.c:3869 [inline]
       __lock_acquire+0x2478/0x3b30 kernel/locking/lockdep.c:5137
       lock_acquire kernel/locking/lockdep.c:5754 [inline]
       lock_acquire+0x1b1/0x560 kernel/locking/lockdep.c:5719
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

other info that might help us debug this:

Chain exists of:
  fs_reclaim --> sb_internal#5 --> &nilfs->ns_segctor_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&nilfs->ns_segctor_sem);
                               lock(sb_internal#5);
                               lock(&nilfs->ns_segctor_sem);
  lock(fs_reclaim);

 *** DEADLOCK ***

4 locks held by syz-executor.2/23478:
 #0: ffff888000c0c420 (sb_writers#32){.+.+}-{0:0}, at: filename_create+0x10d/0x530 fs/namei.c:3893
 #1: ffff88804b284f88 (&type->i_mutex_dir_key#23/1){+.+.}-{3:3}, at: inode_lock_nested include/linux/fs.h:826 [inline]
 #1: ffff88804b284f88 (&type->i_mutex_dir_key#23/1){+.+.}-{3:3}, at: filename_create+0x1c2/0x530 fs/namei.c:3900
 #2: ffff888000c0c610 (sb_internal#5){.+.+}-{0:0}, at: nilfs_symlink+0x114/0x3c0 fs/nilfs2/namei.c:140
 #3: ffff888026c5c2a0 (&nilfs->ns_segctor_sem){++++}-{3:3}, at: nilfs_transaction_begin+0x326/0xa40 fs/nilfs2/segment.c:223

stack backtrace:
CPU: 2 PID: 23478 Comm: syz-executor.2 Not tainted 6.9.0-syzkaller-01768-ga5131c3fdf26 #0
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
RIP: 0023:0xf734f579
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f5f415ac EFLAGS: 00000292 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 0000000020000340 RCX: 0000000020000100
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000292 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
----------------
Code disassembly (best guess), 2 bytes skipped:
   0:	10 06                	adc    %al,(%rsi)
   2:	03 74 b4 01          	add    0x1(%rsp,%rsi,4),%esi
   6:	10 07                	adc    %al,(%rdi)
   8:	03 74 b0 01          	add    0x1(%rax,%rsi,4),%esi
   c:	10 08                	adc    %cl,(%rax)
   e:	03 74 d8 01          	add    0x1(%rax,%rbx,8),%esi
  1e:	00 51 52             	add    %dl,0x52(%rcx)
  21:	55                   	push   %rbp
  22:	89 e5                	mov    %esp,%ebp
  24:	0f 34                	sysenter
  26:	cd 80                	int    $0x80
* 28:	5d                   	pop    %rbp <-- trapping instruction
  29:	5a                   	pop    %rdx
  2a:	59                   	pop    %rcx
  2b:	c3                   	ret
  2c:	90                   	nop
  2d:	90                   	nop
  2e:	90                   	nop
  2f:	90                   	nop
  30:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi
  37:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi


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
