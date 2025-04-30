Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066E5139D0A
	for <linux-nilfs@vger.kernel.org>; Wed, 30 Apr 2025 02:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745979988; cv=none; b=CpQ+SY3HMbXKEfHYdAp0nTY8dgiuyR9Y/AQiU8NsaMQmy9IAhQdh4ItufSrQyzdkSgwUrAHa4zW7+7smxkbvL+xjRlJrCW69E26ajT/R4gx6FXMgrc3eqDfoJ+EOy4DT7gexAe/jB/WEPewjB//ehsy2zD98xXpmj9lwWvikPZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745979988; c=relaxed/simple;
	bh=FU/0E30Iy0/GFEuaDNkojSeh+9ROwkD/Vfb8glrcJiE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=lUsnqJldOJtLzYiECnvd3BEk4oROOosdPO+kv0nHRBpFPnN4dmxMmILpbkT9FgMjWSQtFByTGa6qhvpPA1t3wBEfHX+1PN4nneGp06yT1BChVrAjw0+sHnq1Svkv0tgPFu+4//ujUM5nVzmx4EvzztL3V1Vh62iYXkAGFpOBcRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-86463467dddso416402639f.3
        for <linux-nilfs@vger.kernel.org>; Tue, 29 Apr 2025 19:26:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745979986; x=1746584786;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+WI3UpbHGKkclhOy4vJJJk1p5KgjlUeDzhsQXSFt86I=;
        b=nQZbqQJUSX3OBK8pMKjR4TlkY77SugTurAJgdoq4JDOlwFxZ8PpP7dDs6EilDS+VLC
         XiYnG3EvMCIdo6DDAJvvltM9r+84R4MGnwkAhF2QFAtpo9O2hywsOAhAEACEeA/m3sbx
         OIgcJ1QurlkUKurbkI+uYHZkd7XgZ0goOrAIeQsK0bG7h20TFpEeeBa96NYBhItVlY/t
         1t/SQ3bkyKNtjLLAqB8SfCzTReeS+6qUMigIZK9X3fey5celQIezdPmUnY6bMZFSiAh/
         EDySKoOnwGGUib0phZO4uqt2JgIRK3h5H/DcfWTOkuBJj8a5OlWk2OAGnOuRPZUc0CBJ
         A9fQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyQlp3KYswca5+8suMImObGqw6IWy6pPF41InLp9FvQbuYYeXeezI0We3Wa+Zg8SOsgbYLS3rpVSQ7PQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7HN1QcK53aGIH1JSfWnFVXGb2F8+oVRTsRkU6iE0iX1wofiON
	SafCsfrvn5lVeyFWeygupeGP5OgLWS/LnnH6RwNWHCd2xpxi9Y0pUjqv3u8bN0HYUbxydXc4VWf
	P1OetkNsR1MioVWj85P7gBdu8ehNrGGQES9k+EBLUzHyJwNmvGWCpjcU=
X-Google-Smtp-Source: AGHT+IHq+4KAVE88/PdN5D0CQcJYgbGp8ARrv+sIQ/JtgZwURXnWDZ9gGAdt8A/jBYXJzHTQxBJcVuSTHPKDR6hgLGbf+63vzTx7
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:401b:b0:85b:538e:1faf with SMTP id
 ca18e2360f4ac-86495e80421mr215375739f.7.1745979986092; Tue, 29 Apr 2025
 19:26:26 -0700 (PDT)
Date: Tue, 29 Apr 2025 19:26:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68118a52.050a0220.39e3a1.0cab.GAE@google.com>
Subject: [syzbot] [nilfs?] possible deadlock in __nilfs_error (3)
From: syzbot <syzbot+00f7f5b884b117ee6773@syzkaller.appspotmail.com>
To: konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ca91b9500108 Merge tag 'v6.15-rc4-ksmbd-server-fixes' of g..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=172188d4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a42a9d552788177b
dashboard link: https://syzkaller.appspot.com/bug?extid=00f7f5b884b117ee6773
compiler:       Debian clang version 20.1.2 (++20250402124445+58df0ef89dd6-1~exp1~20250402004600.97), Debian LLD 20.1.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a00a70580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=114b8774580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8f91302b28da/disk-ca91b950.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/99926b0845ed/vmlinux-ca91b950.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ace62028a7c9/bzImage-ca91b950.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/5c8198c5e35a/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/a89d3d8742e8/mount_3.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=12dabb74580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+00f7f5b884b117ee6773@syzkaller.appspotmail.com

NILFS (loop0): vblocknr = 23 has abnormal lifetime: start cno (= 4294967298) > current cno (= 3)
NILFS error (device loop0): nilfs_bmap_propagate: broken bmap (inode number=4)
======================================================
WARNING: possible circular locking dependency detected
6.15.0-rc4-syzkaller-00021-gca91b9500108 #0 Not tainted
------------------------------------------------------
segctord/5821 is trying to acquire lock:
ffff88814d79f090 (&nilfs->ns_sem){++++}-{4:4}, at: nilfs_set_error fs/nilfs2/super.c:92 [inline]
ffff88814d79f090 (&nilfs->ns_sem){++++}-{4:4}, at: __nilfs_error+0x1ca/0x4b0 fs/nilfs2/super.c:141

but task is already holding lock:
ffff88814d79f2a0 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_lock+0x253/0x4c0 fs/nilfs2/segment.c:357

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #6 (&nilfs->ns_segctor_sem){++++}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
       down_read+0x46/0x2e0 kernel/locking/rwsem.c:1524
       nilfs_transaction_begin+0x365/0x710 fs/nilfs2/segment.c:221
       nilfs_page_mkwrite+0x8b0/0xc20 fs/nilfs2/file.c:95
       do_page_mkwrite+0x14a/0x310 mm/memory.c:3287
       wp_page_shared mm/memory.c:3688 [inline]
       do_wp_page+0x2626/0x5760 mm/memory.c:3907
       handle_pte_fault mm/memory.c:6013 [inline]
       __handle_mm_fault+0x1028/0x5380 mm/memory.c:6140
       handle_mm_fault+0x2d5/0x7f0 mm/memory.c:6309
       do_user_addr_fault+0xa81/0x1390 arch/x86/mm/fault.c:1337
       handle_page_fault arch/x86/mm/fault.c:1480 [inline]
       exc_page_fault+0x68/0x110 arch/x86/mm/fault.c:1538
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

-> #5 (sb_internal#2){.+.+}-{0:0}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
       percpu_down_read include/linux/percpu-rwsem.h:52 [inline]
       __sb_start_write include/linux/fs.h:1783 [inline]
       sb_start_intwrite include/linux/fs.h:1966 [inline]
       nilfs_transaction_begin+0x268/0x710 fs/nilfs2/segment.c:218
       nilfs_page_mkwrite+0x8b0/0xc20 fs/nilfs2/file.c:95
       do_page_mkwrite+0x14a/0x310 mm/memory.c:3287
       wp_page_shared mm/memory.c:3688 [inline]
       do_wp_page+0x2626/0x5760 mm/memory.c:3907
       handle_pte_fault mm/memory.c:6013 [inline]
       __handle_mm_fault+0x1028/0x5380 mm/memory.c:6140
       handle_mm_fault+0x2d5/0x7f0 mm/memory.c:6309
       do_user_addr_fault+0xa81/0x1390 arch/x86/mm/fault.c:1337
       handle_page_fault arch/x86/mm/fault.c:1480 [inline]
       exc_page_fault+0x68/0x110 arch/x86/mm/fault.c:1538
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

-> #4 (sb_pagefaults){.+.+}-{0:0}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
       percpu_down_read include/linux/percpu-rwsem.h:52 [inline]
       __sb_start_write include/linux/fs.h:1783 [inline]
       sb_start_pagefault include/linux/fs.h:1948 [inline]
       nilfs_page_mkwrite+0x21e/0xc20 fs/nilfs2/file.c:57
       do_page_mkwrite+0x14a/0x310 mm/memory.c:3287
       wp_page_shared mm/memory.c:3688 [inline]
       do_wp_page+0x2626/0x5760 mm/memory.c:3907
       handle_pte_fault mm/memory.c:6013 [inline]
       __handle_mm_fault+0x1028/0x5380 mm/memory.c:6140
       handle_mm_fault+0x2d5/0x7f0 mm/memory.c:6309
       do_user_addr_fault+0xa81/0x1390 arch/x86/mm/fault.c:1337
       handle_page_fault arch/x86/mm/fault.c:1480 [inline]
       exc_page_fault+0x68/0x110 arch/x86/mm/fault.c:1538
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

-> #3 (vm_lock){++++}-{0:0}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
       __vma_enter_locked+0x182/0x380 mm/memory.c:6473
       __vma_start_write+0x1e/0x120 mm/memory.c:6497
       vma_start_write include/linux/mm.h:829 [inline]
       mprotect_fixup+0x571/0x9b0 mm/mprotect.c:670
       setup_arg_pages+0x53a/0xaa0 fs/exec.c:780
       load_elf_binary+0xb7a/0x27b0 fs/binfmt_elf.c:1019
       search_binary_handler fs/exec.c:1778 [inline]
       exec_binprm fs/exec.c:1810 [inline]
       bprm_execve+0x999/0x1440 fs/exec.c:1862
       kernel_execve+0x8f0/0x9f0 fs/exec.c:2028
       try_to_run_init_process+0x13/0x60 init/main.c:1385
       kernel_init+0xad/0x1d0 init/main.c:1513
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:153
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #2 (&mm->mmap_lock){++++}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
       __might_fault+0xcc/0x130 mm/memory.c:7151
       _copy_to_iter+0xf3/0x15a0 lib/iov_iter.c:184
       copy_page_to_iter+0xa7/0x150 lib/iov_iter.c:362
       copy_folio_to_iter include/linux/uio.h:198 [inline]
       filemap_read+0x78d/0x11d0 mm/filemap.c:2753
       blkdev_read_iter+0x30a/0x440 block/fops.c:809
       new_sync_read fs/read_write.c:489 [inline]
       vfs_read+0x4cd/0x980 fs/read_write.c:570
       ksys_read+0x145/0x250 fs/read_write.c:713
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&sb->s_type->i_mutex_key#7){++++}-{4:4}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1577
       inode_lock include/linux/fs.h:867 [inline]
       set_blocksize+0x23b/0x500 block/bdev.c:203
       sb_set_blocksize block/bdev.c:224 [inline]
       sb_min_blocksize+0x119/0x210 block/bdev.c:239
       init_nilfs+0x43/0x690 fs/nilfs2/the_nilfs.c:710
       nilfs_fill_super+0x8f/0x650 fs/nilfs2/super.c:1060
       nilfs_get_tree+0x4f4/0x870 fs/nilfs2/super.c:1228
       vfs_get_tree+0x8f/0x2b0 fs/super.c:1759
       do_new_mount+0x24a/0xa40 fs/namespace.c:3884
       do_mount fs/namespace.c:4224 [inline]
       __do_sys_mount fs/namespace.c:4435 [inline]
       __se_sys_mount+0x317/0x410 fs/namespace.c:4412
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&nilfs->ns_sem){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3166 [inline]
       check_prevs_add kernel/locking/lockdep.c:3285 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3909
       __lock_acquire+0xaac/0xd20 kernel/locking/lockdep.c:5235
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
       down_write+0x96/0x1f0 kernel/locking/rwsem.c:1577
       nilfs_set_error fs/nilfs2/super.c:92 [inline]
       __nilfs_error+0x1ca/0x4b0 fs/nilfs2/super.c:141
       nilfs_bmap_convert_error fs/nilfs2/bmap.c:35 [inline]
       nilfs_bmap_propagate+0x108/0x130 fs/nilfs2/bmap.c:332
       nilfs_collect_file_data+0x4f/0xd0 fs/nilfs2/segment.c:589
       nilfs_segctor_apply_buffers+0x161/0x330 fs/nilfs2/segment.c:1010
       nilfs_segctor_scan_file+0x68e/0x8e0 fs/nilfs2/segment.c:1059
       nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1254 [inline]
       nilfs_segctor_collect fs/nilfs2/segment.c:1547 [inline]
       nilfs_segctor_do_construct+0x1d46/0x6970 fs/nilfs2/segment.c:2122
       nilfs_segctor_construct+0x17b/0x690 fs/nilfs2/segment.c:2478
       nilfs_segctor_thread_construct fs/nilfs2/segment.c:2586 [inline]
       nilfs_segctor_thread+0x6f7/0xe00 fs/nilfs2/segment.c:2700
       kthread+0x70e/0x8a0 kernel/kthread.c:464
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:153
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

Chain exists of:
  &nilfs->ns_sem --> sb_internal#2 --> &nilfs->ns_segctor_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&nilfs->ns_segctor_sem);
                               lock(sb_internal#2);
                               lock(&nilfs->ns_segctor_sem);
  lock(&nilfs->ns_sem);

 *** DEADLOCK ***

1 lock held by segctord/5821:
 #0: ffff88814d79f2a0 (&nilfs->ns_segctor_sem){++++}-{4:4}, at: nilfs_transaction_lock+0x253/0x4c0 fs/nilfs2/segment.c:357

stack backtrace:
CPU: 0 UID: 0 PID: 5821 Comm: segctord Not tainted 6.15.0-rc4-syzkaller-00021-gca91b9500108 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/19/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_circular_bug+0x2ee/0x310 kernel/locking/lockdep.c:2079
 check_noncircular+0x134/0x160 kernel/locking/lockdep.c:2211
 check_prev_add kernel/locking/lockdep.c:3166 [inline]
 check_prevs_add kernel/locking/lockdep.c:3285 [inline]
 validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3909
 __lock_acquire+0xaac/0xd20 kernel/locking/lockdep.c:5235
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5866
 down_write+0x96/0x1f0 kernel/locking/rwsem.c:1577
 nilfs_set_error fs/nilfs2/super.c:92 [inline]
 __nilfs_error+0x1ca/0x4b0 fs/nilfs2/super.c:141
 nilfs_bmap_convert_error fs/nilfs2/bmap.c:35 [inline]
 nilfs_bmap_propagate+0x108/0x130 fs/nilfs2/bmap.c:332
 nilfs_collect_file_data+0x4f/0xd0 fs/nilfs2/segment.c:589
 nilfs_segctor_apply_buffers+0x161/0x330 fs/nilfs2/segment.c:1010
 nilfs_segctor_scan_file+0x68e/0x8e0 fs/nilfs2/segment.c:1059
 nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1254 [inline]
 nilfs_segctor_collect fs/nilfs2/segment.c:1547 [inline]
 nilfs_segctor_do_construct+0x1d46/0x6970 fs/nilfs2/segment.c:2122
 nilfs_segctor_construct+0x17b/0x690 fs/nilfs2/segment.c:2478
 nilfs_segctor_thread_construct fs/nilfs2/segment.c:2586 [inline]
 nilfs_segctor_thread+0x6f7/0xe00 fs/nilfs2/segment.c:2700
 kthread+0x70e/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:153
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Remounting filesystem read-only


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
