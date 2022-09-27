From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [syzbot] BUG: unable to handle kernel paging request in alloc_nilfs
Date: Tue, 27 Sep 2022 23:10:49 +0900
Message-ID: <CAKFNMomi2Xh87cZHkSWowShpu8XUPOEw_D+6CDByJkjFn75Z_A@mail.gmail.com>
References: <000000000000922a2105e8615576@google.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=1kmSACpTUpQFMKFjBw1sVbOoeMhRcmNy9W4vZr1+8Pg=;
        b=MdlRQY1NT42XawxBjQgXYbtaI91ytx7nHGfvON/NIQpfM++Zo3IWJ9gT8fQ20hlvFp
         qhUMIniq6bwqYCyv+7BbaQOA5mWJazh+1tYCFUg5Jwp0t/po6vXdvU0PiMjlsmYyq1UM
         S9Tr/mXLKZDsMyVBPlJieRy99O546qfUj1zwKacbuR2kZ6SSgebKCK5RzbEoF41Xinf9
         FXWqQ7x6wsL6adOU2T53NO2aiVTUUiKchcap6hIgC542+I0QugFSYNK3XieNnDApKy8G
         rZ2cH+amEjplPac8sQyM09+BdEJk+ki970cDlE9BGeAqeo2BDHzkB4D67S0AcGqtuMHw
         ZmOw==
In-Reply-To: <000000000000922a2105e8615576-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+19d51a2ee09e1cb9ba06-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org

On Sun, Sep 11, 2022 at 4:00 PM syzbot wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    25050c56fa3c Merge branch 'for-next/fixes' into for-kernelci
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=176f0273080000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=db8b30b83a444315
> dashboard link: https://syzkaller.appspot.com/bug?extid=19d51a2ee09e1cb9ba06
> compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=152b3417080000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ded8f5080000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+19d51a2ee09e1cb9ba06-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
>
> loop0: detected capacity change from 0 to 200
> Unable to handle kernel paging request at virtual address dead4ead00000400
> Mem abort info:
>   ESR = 0x0000000096000004
>   EC = 0x25: DABT (current EL), IL = 32 bits
>   SET = 0, FnV = 0
>   EA = 0, S1PTW = 0
>   FSC = 0x04: level 0 translation fault
> Data abort info:
>   ISV = 0, ISS = 0x00000004
>   CM = 0, WnR = 0
> [dead4ead00000400] address between user and kernel address ranges
> Internal error: Oops: 96000004 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 0 PID: 3066 Comm: syz-executor208 Not tainted 6.0.0-rc4-syzkaller-17186-g25050c56fa3c #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
> pstate: 40400005 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : slab_alloc mm/slub.c:3251 [inline]
> pc : kmem_cache_alloc_trace+0x184/0x324 mm/slub.c:3282
> lr : slab_pre_alloc_hook mm/slab.h:702 [inline]
> lr : slab_alloc_node mm/slub.c:3157 [inline]
> lr : slab_alloc mm/slub.c:3251 [inline]
> lr : kmem_cache_alloc_trace+0x8c/0x324 mm/slub.c:3282
> sp : ffff8000127f3a80
> x29: ffff8000127f3a90 x28: ffff0000c58c0000 x27: ffff80000d379000
> x26: ffff80000cdb4419 x25: 0000000000000083 x24: dead4ead00000000
> x23: 0000000000000000 x22: ffff800008f7bda0 x21: ffff0000c0001600
> x20: 00000000000004d0 x19: 0000000000000dc0 x18: 0000000000000000
> x17: 0000000000000000 x16: ffff80000dbb8658 x15: ffff0000c58c0000
> x14: 0000000000000010 x13: 0000000000000000 x12: ffff0000c58c0000
> x11: 0000000000000001 x10: 0000000000000000 x9 : 0000000000000400
> x8 : 0000000000001ec8 x7 : ffff8000084b7800 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000001ed0
> x2 : 0000000000000000 x1 : 0000000000000800 x0 : 0000000000000000
> Call trace:
>  next_tid mm/slub.c:2311 [inline]
>  slab_alloc_node mm/slub.c:3227 [inline]
>  slab_alloc mm/slub.c:3251 [inline]
>  kmem_cache_alloc_trace+0x184/0x324 mm/slub.c:3282
>  kmalloc include/linux/slab.h:600 [inline]
>  kzalloc include/linux/slab.h:733 [inline]
>  alloc_nilfs+0x2c/0x13c fs/nilfs2/the_nilfs.c:59
>  nilfs_fill_super+0x40/0x2e8 fs/nilfs2/super.c:1041
>  nilfs_mount+0x370/0x52c fs/nilfs2/super.c:1317
>  legacy_get_tree+0x30/0x74 fs/fs_context.c:610
>  vfs_get_tree+0x40/0x140 fs/super.c:1530
>  do_new_mount+0x1dc/0x4e4 fs/namespace.c:3040
>  path_mount+0x358/0x914 fs/namespace.c:3370
>  do_mount fs/namespace.c:3383 [inline]
>  __do_sys_mount fs/namespace.c:3591 [inline]
>  __se_sys_mount fs/namespace.c:3568 [inline]
>  __arm64_sys_mount+0x2f8/0x408 fs/namespace.c:3568
>  __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
>  invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
>  el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
>  do_el0_svc+0x48/0x154 arch/arm64/kernel/syscall.c:206
>  el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:624
>  el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:642
>  el0t_64_sync+0x18c/0x190
> Code: 54000d41 34000d4b b9402aa9 91002103 (f8696b19)
> ---[ end trace 0000000000000000 ]---
> ----------------
> Code disassembly (best guess):
>    0:   54000d41        b.ne    0x1a8  // b.any
>    4:   34000d4b        cbz     w11, 0x1ac
>    8:   b9402aa9        ldr     w9, [x21, #40]
>    c:   91002103        add     x3, x8, #0x8
> * 10:   f8696b19        ldr     x25, [x24, x9] <-- trapping instruction
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

This one turned out to be the same issue as the following report:

#syz dup: BUG: unable to handle kernel paging request in kernfs_put_active

I confirmed that the associated fix commit "fs: fix UAF/GPF bug in
nilfs_mdt_destroy" fixes the oops.

Ryusuke Konishi
