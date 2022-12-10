From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [syzbot] WARNING in nilfs_segctor_do_construct
Date: Sat, 10 Dec 2022 10:29:10 +0900
Message-ID: <CAKFNMo=6dyq_2uBThftyGMbikDjU9UFhuzy1s5FvSfMro5i7rA@mail.gmail.com>
References: <0000000000001a6b6705e9b3533d@google.com> <0000000000008eac3f05ef6ec145@google.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1ehC4gRqwWPVpI0ho/T17FP2Neecdj4vCB7ajo1mNbM=;
        b=a4qBDdlCOPjXA6d0LSD1n3iBI46mxevJII1X51S4rQE9yjYV9FVAs9gxyOaNDVSYUl
         JADCgoDJc9p3vf0vd9iDzXScd/emGxHoXwYnYHBgLU0trSmajHHyBoYMq2g7MFYSMaeN
         v8xrlOALQy9X9BgM+uoDNigKDbw5ENYL6OXlwzzc+jc5OFxgV++HrjRkM7J5MZWWgPmK
         trZlqtiH5QS/6KS6aYm/Odg2/XMApTMwrniM2jFVPDglvd9GpFlwAX3G5uEGNY/cmNjS
         jE/k2mGaKiG/xejyjr/JbYWHcq3ZJnFSB00CsWD8mjsTaRPCbO4WD8wSK3z1FLBrYMcp
         GHNw==
In-Reply-To: <0000000000008eac3f05ef6ec145@google.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+fbb3e0b24e8dae5a16ee@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, stable-commits@vger.kernel.org, stable@vger.kernel.org, syzkaller-bugs@googlegroups.com

On Sat, Dec 10, 2022 at 9:57 AM syzbot wrote:
>
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    a5541c0811a0 Merge branch 'for-next/core' into for-kernelci
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=15c56bdb880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cbd4e584773e9397
> dashboard link: https://syzkaller.appspot.com/bug?extid=fbb3e0b24e8dae5a16ee
> compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14caa71d880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1032f2b7880000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/4b7702208fb9/disk-a5541c08.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/9ec0153ec051/vmlinux-a5541c08.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/6f8725ad290a/Image-a5541c08.gz.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/0911b0ec76cf/mount_0.gz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+fbb3e0b24e8dae5a16ee@syzkaller.appspotmail.com
>
> NILFS (loop0): segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
> NILFS (loop0): nilfs_sufile_update: invalid segment number: 53
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 3149 at fs/nilfs2/segment.c:1482 nilfs_segctor_truncate_segments fs/nilfs2/segment.c:1482 [inline]
> WARNING: CPU: 0 PID: 3149 at fs/nilfs2/segment.c:1482 nilfs_segctor_collect fs/nilfs2/segment.c:1534 [inline]
> WARNING: CPU: 0 PID: 3149 at fs/nilfs2/segment.c:1482 nilfs_segctor_do_construct+0x6cc/0xefc fs/nilfs2/segment.c:2045
> Modules linked in:
> CPU: 0 PID: 3149 Comm: segctord Not tainted 6.1.0-rc8-syzkaller-33330-ga5541c0811a0 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : nilfs_segctor_truncate_segments fs/nilfs2/segment.c:1482 [inline]
> pc : nilfs_segctor_collect fs/nilfs2/segment.c:1534 [inline]
> pc : nilfs_segctor_do_construct+0x6cc/0xefc fs/nilfs2/segment.c:2045
> lr : nilfs_segctor_truncate_segments fs/nilfs2/segment.c:1482 [inline]
> lr : nilfs_segctor_collect fs/nilfs2/segment.c:1534 [inline]
> lr : nilfs_segctor_do_construct+0x6cc/0xefc fs/nilfs2/segment.c:2045
> sp : ffff800012f6bc80
> x29: ffff800012f6bd00 x28: ffff800008f744fc x27: ffff0000c6cf9128
> x26: ffff0000c6cf9258 x25: ffff0000c9039138 x24: ffff0000ca797818
> x23: ffff0000c90390b8 x22: 00000000ffffffea x21: 0000000000000001
> x20: ffff0000cb9a8000 x19: ffff0000c9039000 x18: 000000000000027f
> x17: 0000000000000000 x16: ffff80000dbe6158 x15: ffff0000c6508000
> x14: 0000000000000000 x13: 00000000ffffffff x12: ffff0000c6508000
> x11: ff80800008f68d3c x10: 0000000000000000 x9 : ffff800008f68d3c
> x8 : ffff0000c6508000 x7 : ffff80000816678c x6 : 0000000000000000
> x5 : 0000000000000080 x4 : 0000000000000001 x3 : 0000000000000000
> x2 : ffff0001fefbecd0 x1 : 00000000ffffffea x0 : 0000000000000000
> Call trace:
>  nilfs_segctor_truncate_segments fs/nilfs2/segment.c:1482 [inline]
>  nilfs_segctor_collect fs/nilfs2/segment.c:1534 [inline]
>  nilfs_segctor_do_construct+0x6cc/0xefc fs/nilfs2/segment.c:2045
>  nilfs_segctor_construct+0xa0/0x380 fs/nilfs2/segment.c:2379
>  nilfs_segctor_thread_construct fs/nilfs2/segment.c:2487 [inline]
>  nilfs_segctor_thread+0x180/0x634 fs/nilfs2/segment.c:2570
>  kthread+0x12c/0x158 kernel/kthread.c:376
>  ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
> irq event stamp: 8892
> hardirqs last  enabled at (8891): [<ffff80000816681c>] raw_spin_rq_unlock_irq kernel/sched/sched.h:1366 [inline]
> hardirqs last  enabled at (8891): [<ffff80000816681c>] finish_lock_switch+0x94/0xe8 kernel/sched/core.c:4968
> hardirqs last disabled at (8892): [<ffff80000c084084>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last  enabled at (8698): [<ffff8000080102e4>] _stext+0x2e4/0x37c
> softirqs last disabled at (8677): [<ffff800008017c88>] ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:80
> ---[ end trace 0000000000000000 ]---

This is a different issue than the one we fixed earlier.
WARN_ON is caught in another function nilfs_segctor_truncate_segments().
I will look into it and think of a fix.

Ryusuke Konishi
