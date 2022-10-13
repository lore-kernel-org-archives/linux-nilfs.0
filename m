From: syzbot <syzbot+e67c6877ee7e6e68c45a-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Subject: [syzbot] WARNING: ODEBUG bug in nilfs_mdt_destroy
Date: Thu, 13 Oct 2022 01:18:51 -0700
Message-ID: <000000000000d3fe2105eae628eb@google.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org

Hello,

syzbot found the following issue on:

HEAD commit:    bbed346d5a96 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=161c8578880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3a4a45d2d827c1e
dashboard link: https://syzkaller.appspot.com/bug?extid=e67c6877ee7e6e68c45a
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e8e91bc79312/disk-bbed346d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c1cb3fb3b77e/vmlinux-bbed346d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e67c6877ee7e6e68c45a-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

------------[ cut here ]------------
ODEBUG: free active (active state 0) object type: timer_list hint: br_multicast_group_expired+0x0/0x230 net/bridge/br_multicast.c:606
WARNING: CPU: 1 PID: 8079 at lib/debugobjects.c:505 debug_print_object lib/debugobjects.c:502 [inline]
WARNING: CPU: 1 PID: 8079 at lib/debugobjects.c:505 __debug_check_no_obj_freed lib/debugobjects.c:989 [inline]
WARNING: CPU: 1 PID: 8079 at lib/debugobjects.c:505 debug_check_no_obj_freed+0x214/0x2b0 lib/debugobjects.c:1020
Modules linked in:
CPU: 1 PID: 8079 Comm: syz-executor.4 Not tainted 6.0.0-rc7-syzkaller-18095-gbbed346d5a96 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : debug_print_object lib/debugobjects.c:502 [inline]
pc : __debug_check_no_obj_freed lib/debugobjects.c:989 [inline]
pc : debug_check_no_obj_freed+0x214/0x2b0 lib/debugobjects.c:1020
lr : debug_print_object lib/debugobjects.c:502 [inline]
lr : __debug_check_no_obj_freed lib/debugobjects.c:989 [inline]
lr : debug_check_no_obj_freed+0x214/0x2b0 lib/debugobjects.c:1020
sp : ffff80001488b990
x29: ffff80001488b9b0 x28: ffff000134488000 x27: ffff000134489000
x26: ffff0001362a1398 x25: ffff000121ada0f0 x24: ffff80000bfff5b8
x23: ffff000134488f40 x22: ffff80000bfff5b8 x21: 0000000000000001
x20: dead000000000100 x19: ffff000134488f00 x18: 000000000000010e
x17: 0000000000000000 x16: ffff80000db49158 x15: ffff0000facdb500
x14: 0000000000000000 x13: 00000000ffffffff x12: 0000000000040000
x11: 0000000000006464 x10: ffff80001f2be000 x9 : 49f3c7340dde9a00
x8 : 49f3c7340dde9a00 x7 : ffff800008161d1c x6 : 0000000000000000
x5 : 0000000000000080 x4 : 0000000000000001 x3 : 0000000000000000
x2 : 0000000000000007 x1 : 0000000100000000 x0 : 0000000000000067
Call trace:
 debug_print_object lib/debugobjects.c:502 [inline]
 __debug_check_no_obj_freed lib/debugobjects.c:989 [inline]
 debug_check_no_obj_freed+0x214/0x2b0 lib/debugobjects.c:1020
 slab_free_hook mm/slub.c:1734 [inline]
 slab_free_freelist_hook mm/slub.c:1785 [inline]
 slab_free mm/slub.c:3539 [inline]
 kfree+0x14c/0x348 mm/slub.c:4567
 nilfs_mdt_destroy+0x2c/0x3c fs/nilfs2/mdt.c:498
 nilfs_free_inode+0x2c/0x54 fs/nilfs2/super.c:168
 i_callback fs/inode.c:249 [inline]
 alloc_inode+0xdc/0x104 fs/inode.c:274
 new_inode_pseudo fs/inode.c:1019 [inline]
 new_inode+0x2c/0xc0 fs/inode.c:1047
 nilfs_new_inode+0x48/0x378 fs/nilfs2/inode.c:334
 nilfs_mknod+0x7c/0x170 fs/nilfs2/namei.c:113
 vfs_mknod+0x2e8/0x318 fs/namei.c:3892
 unix_bind_bsd+0x138/0x320 net/unix/af_unix.c:1192
 unix_bind+0xd4/0x10c net/unix/af_unix.c:1283
 __sys_bind+0x148/0x1b0 net/socket.c:1776
 __do_sys_bind net/socket.c:1787 [inline]
 __se_sys_bind net/socket.c:1785 [inline]
 __arm64_sys_bind+0x28/0x3c net/socket.c:1785
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:636
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:654
 el0t_64_sync+0x18c/0x190 arch/arm64/kernel/entry.S:581
irq event stamp: 3716
hardirqs last  enabled at (3715): [<ffff800008161dac>] raw_spin_rq_unlock_irq kernel/sched/sched.h:1367 [inline]
hardirqs last  enabled at (3715): [<ffff800008161dac>] finish_lock_switch+0x94/0xe8 kernel/sched/core.c:4942
hardirqs last disabled at (3716): [<ffff80000bfb5fbc>] el1_dbg+0x24/0x5c arch/arm64/kernel/entry-common.c:404
softirqs last  enabled at (3520): [<ffff80000801c33c>] local_bh_enable+0x10/0x34 include/linux/bottom_half.h:32
softirqs last disabled at (3518): [<ffff80000801c308>] local_bh_disable+0x10/0x34 include/linux/bottom_half.h:19
---[ end trace 0000000000000000 ]---


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
