From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [syzbot] possible deadlock in __nilfs_error
Date: Wed, 19 Oct 2022 13:20:43 +0900
Message-ID: <CAKFNMokXkta6TToBtZdGdr48YrzeQN0ZwLBjZ4kdADXv5Y+RqQ@mail.gmail.com>
References: <00000000000092950405eb17aac7@google.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ou9V6wakgWUF4RzadCI+dfA+wXt9PMjFyd9DhZfd2Qc=;
        b=q6NHtxJZO3A1iEAPo2I6kttAZ9ZDkhU3VSwvv01Bq6RtCvX8p5/s9ces130D2kuCmg
         4NkgmzT3l9TcCk0q06o1y2qWCltIp94LQuQFVanOo8osP4Vam0RBu0Kef+MM32dJ9Hl1
         YGX+O4ZSXJprbrIKw7KgTorank6XM5Nz9nXoL7SiX0GLjxTHMP91KehlR45fPPK6fUNO
         QGRXGu26HV6fmLrgBDejuo43IrT7RBZL6Pk+XMjsGXkZZTVT1DX6/S6FXBtORCUM1FfE
         Mikt7ryixZNxkxEsCYV3U6NzlzVmDTCSwjC6+8om/WhdGujy460/CiRE1YjQp9zNsTJi
         MaRw==
In-Reply-To: <00000000000092950405eb17aac7-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+3a94da2c82ba4f401b9e-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org

On Sun, Oct 16, 2022 at 4:22 AM syzbot wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    bbed346d5a96 Merge branch 'for-next/core' into for-kernelci
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=12497f8a880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3a4a45d2d827c1e
> dashboard link: https://syzkaller.appspot.com/bug?extid=3a94da2c82ba4f401b9e
> compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> userspace arch: arm64
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/e8e91bc79312/disk-bbed346d.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/c1cb3fb3b77e/vmlinux-bbed346d.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3a94da2c82ba4f401b9e-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
>
> WARNING: possible circular locking dependency detected
> 6.0.0-rc7-syzkaller-18095-gbbed346d5a96 #0 Not tainted
> ------------------------------------------------------
> syz-executor.5/28633 is trying to acquire lock:
> ffff0001126ee890 (&nilfs->ns_sem){++++}-{3:3}, at: nilfs_set_error fs/nilfs2/super.c:92 [inline]
> ffff0001126ee890 (&nilfs->ns_sem){++++}-{3:3}, at: __nilfs_error+0xb4/0x284 fs/nilfs2/super.c:137
>
> but task is already holding lock:
> ffff000123b51e70 (&dat_lock_key
> ){.+.+}-{3:3}, at: nilfs_get_block+0x64/0x364 fs/nilfs2/inode.c:84
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #1 (&dat_lock_key){.+.+}-{3:3}:
>        down_read+0x5c/0x78 kernel/locking/rwsem.c:1499
>        nilfs_count_free_blocks+0x2c/0x6c fs/nilfs2/the_nilfs.c:693
>        nilfs_set_log_cursor fs/nilfs2/super.c:236 [inline]
>        nilfs_cleanup_super+0x118/0x1f0 fs/nilfs2/super.c:318
>        nilfs_put_super+0x54/0x9c fs/nilfs2/super.c:472
>        generic_shutdown_super+0x8c/0x190 fs/super.c:491
>        kill_block_super+0x30/0x78 fs/super.c:1427
>        deactivate_locked_super+0x70/0xe8 fs/super.c:332
>        deactivate_super+0xd0/0xd4 fs/super.c:363
>        cleanup_mnt+0x1f8/0x234 fs/namespace.c:1186
>        __cleanup_mnt+0x20/0x30 fs/namespace.c:1193
>        task_work_run+0xc4/0x14c kernel/task_work.c:177
>        resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
>        do_notify_resume+0x174/0x1f0 arch/arm64/kernel/signal.c:1127
>        prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
>        exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
>        el0_svc+0x9c/0x150 arch/arm64/kernel/entry-common.c:637
>        el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:654
>        el0t_64_sync+0x18c/0x190 arch/arm64/kernel/entry.S:581
>
> -> #0 (&nilfs->ns_sem){++++}-{3:3}:
>        check_prev_add kernel/locking/lockdep.c:3095 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3214 [inline]
>        validate_chain kernel/locking/lockdep.c:3829 [inline]
>        __lock_acquire+0x1530/0x30a4 kernel/locking/lockdep.c:5053
>        lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5666
>        down_write+0x5c/0xcc kernel/locking/rwsem.c:1552
>        nilfs_set_error fs/nilfs2/super.c:92 [inline]
>        __nilfs_error+0xb4/0x284 fs/nilfs2/super.c:137
>        nilfs_bmap_convert_error fs/nilfs2/bmap.c:35 [inline]
>        nilfs_bmap_lookup_contig+0x98/0xc0 fs/nilfs2/bmap.c:95
>        nilfs_get_block+0x7c/0x364 fs/nilfs2/inode.c:85
>        block_truncate_page+0x1b4/0xab4 fs/buffer.c:2583
>        nilfs_truncate+0xb8/0x178 fs/nilfs2/inode.c:857
>        nilfs_setattr+0xf8/0x164 fs/nilfs2/inode.c:955
>        notify_change+0x758/0x7f0 fs/attr.c:420
>        do_truncate+0x108/0x150 fs/open.c:65
>        vfs_truncate+0x1dc/0x24c fs/open.c:111
>        do_sys_truncate+0x94/0x140 fs/open.c:134
>        __do_sys_truncate fs/open.c:146 [inline]
>        __se_sys_truncate fs/open.c:144 [inline]
>        __arm64_sys_truncate+0x20/0x30 fs/open.c:144
>        __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
>        invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
>        el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
>        do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
>        el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:636
>        el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:654
>        el0t_64_sync+0x18c/0x190 arch/arm64/kernel/entry.S:581
>
> other info that might help us debug this:
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&dat_lock_key);
>                                lock(&nilfs->ns_sem);
>                                lock(&dat_lock_key);
>   lock(&nilfs->ns_sem);
>
>  *** DEADLOCK ***
>
> 5 locks held by syz-executor.5/28633:
>  #0: ffff0001199e2460 (sb_writers#16){.+.+}-{0:0}, at: mnt_want_write+0x20/0x64 fs/namespace.c:393
>  #1: ffff0001128b2648 (&sb->s_type->i_mutex_key#26){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:756 [inline]
>  #1: ffff0001128b2648 (&sb->s_type->i_mutex_key#26){+.+.}-{3:3}, at: do_truncate+0xf4/0x150 fs/open.c:63
>  #2: ffff0001199e2650 (sb_internal#3){.+.+}-{0:0}, at: nilfs_setattr+0x84/0x164 fs/nilfs2/inode.c:947
>  #3: ffff0001126eeaa0 (&nilfs->ns_segctor_sem){++++}-{3:3}, at: nilfs_transaction_begin+0x214/0x384 fs/nilfs2/segment.c:223
>  #4: ffff000123b51e70 (&dat_lock_key){.+.+}-{3:3}, at: nilfs_get_block+0x64/0x364 fs/nilfs2/inode.c:84
>
> stack backtrace:
> CPU: 1 PID: 28633 Comm: syz-executor.5 Not tainted 6.0.0-rc7-syzkaller-18095-gbbed346d5a96 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
> Call trace:
>  dump_backtrace+0x1c4/0x1f0 arch/arm64/kernel/stacktrace.c:156
>  show_stack+0x2c/0x54 arch/arm64/kernel/stacktrace.c:163
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x104/0x16c lib/dump_stack.c:106
>  dump_stack+0x1c/0x58 lib/dump_stack.c:113
>  print_circular_bug+0x2c4/0x2c8 kernel/locking/lockdep.c:2053
>  check_noncircular+0x14c/0x154 kernel/locking/lockdep.c:2175
>  check_prev_add kernel/locking/lockdep.c:3095 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3214 [inline]
>  validate_chain kernel/locking/lockdep.c:3829 [inline]
>  __lock_acquire+0x1530/0x30a4 kernel/locking/lockdep.c:5053
>  lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5666
>  down_write+0x5c/0xcc kernel/locking/rwsem.c:1552
>  nilfs_set_error fs/nilfs2/super.c:92 [inline]
>  __nilfs_error+0xb4/0x284 fs/nilfs2/super.c:137
>  nilfs_bmap_convert_error fs/nilfs2/bmap.c:35 [inline]
>  nilfs_bmap_lookup_contig+0x98/0xc0 fs/nilfs2/bmap.c:95
>  nilfs_get_block+0x7c/0x364 fs/nilfs2/inode.c:85
>  block_truncate_page+0x1b4/0xab4 fs/buffer.c:2583
>  nilfs_truncate+0xb8/0x178 fs/nilfs2/inode.c:857
>  nilfs_setattr+0xf8/0x164 fs/nilfs2/inode.c:955
>  notify_change+0x758/0x7f0 fs/attr.c:420
>  do_truncate+0x108/0x150 fs/open.c:65
>  vfs_truncate+0x1dc/0x24c fs/open.c:111
>  do_sys_truncate+0x94/0x140 fs/open.c:134
>  __do_sys_truncate fs/open.c:146 [inline]
>  __se_sys_truncate fs/open.c:144 [inline]
>  __arm64_sys_truncate+0x20/0x30 fs/open.c:144
>  __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
>  invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
>  el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
>  do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
>  el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:636
>  el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:654
>  el0t_64_sync+0x18c/0x190 arch/arm64/kernel/entry.S:581
> Remounting filesystem read-only
> NILFS (loop5): bad btree node (ino=16, blocknr=15): level = 0, flags = 0x0, nchildren = 0
> NILFS error (device loop5): nilfs_bmap_last_key: broken bmap (inode number=16)
> NILFS (loop5): error -5 truncating bmap (ino=16)
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

According to the stack trace, this looks like the same issue as below:

#syz dup: possible deadlock in nilfs_count_free_blocks


Ryusuke Konishi
