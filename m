From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: KASAN: use-after-free in nilfs_mdt_destroy
Date: Mon, 22 Mar 2021 23:45:52 +0900
Message-ID: <CAKFNMok0DEsxBeJVsVp7y8GpiBgPVQREsXJPPWn45Vdz14A3Dg@mail.gmail.com>
References: <CAFcO6XOcf1Jj2SeGt=jJV59wmhESeSKpfR0omdFRq+J9nD1vfQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CYyNrDJV16gZnStk5mxzG182JA/FjURCrXf6+U/eXek=;
        b=B6iqJWr3T0kys0DBPX412YawQi+DPjfGk1o57JozX0c0CzOowNtYYwi1WWdDLF17p6
         AzOK7zw2DPG4Je02H6UNPCvwCdxl9aIf8FI2q/m12/hI+4ClRaA/rM/Kpw7ASILA/XQa
         naQPOe+jox3b0ioFKX9PiP+EpqMmPtBrQA+BIRmpTctVseVkGx+rUJnd3pxgysN0O8ey
         l2boUJIlKa2D45rusXYawWh14IS6g4bRZXG+IbwxjMwYztcRHG/5Ucs5DCBppugn5RX/
         8tdsjo7QQMGoz6g12iii5/hZqXbTJyT6Z/9T4tj46ainGs8pLCnNQzcO8T5abX0+7u7s
         kgLw==
In-Reply-To: <CAFcO6XOcf1Jj2SeGt=jJV59wmhESeSKpfR0omdFRq+J9nD1vfQ@mail.gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>

Hi,

I haven't yet succeeded to reproduce the issue with the attached program.
How reproducible is it in your environment?   (Does it take a long
time to reproduce ?)

Regards,
Ryusuke Konishi

On Mon, Mar 22, 2021 at 6:05 PM butt3rflyh4ck
<butterflyhuangxx@gmail.com> wrote:
>
> Hi, guy, I reported a bug found by syzkaller fuzzer with custom
> modifications and reproduced in 5.12.0-rc3+ too.
>
> There are use-after-free crashes in nilfs_mdt_destroy in fs/nilfs2/mdt.c.
>
> and there is a latest crash logs as follows:
>
> ==================================================================
> BUG: KASAN: use-after-free in nilfs_mdt_destroy+0x6f/0x80 fs/nilfs2/mdt.c:485
> Read of size 8 at addr ffff8880478f0098 by task syz-executor325/8480
>
> CPU: 1 PID: 8480 Comm: syz-executor325 Not tainted 5.12.0-rc3+ #42
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1 04/01/2014
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0xfa/0x151 lib/dump_stack.c:120
>  print_address_description.constprop.0.cold+0x82/0x32c mm/kasan/report.c:232
>  __kasan_report mm/kasan/report.c:399 [inline]
>  kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
>  nilfs_mdt_destroy+0x6f/0x80 fs/nilfs2/mdt.c:485
>  nilfs_free_inode+0x3e/0x60 fs/nilfs2/super.c:167
>  i_callback+0x3f/0x70 fs/inode.c:223
>  alloc_inode+0x13e/0x1e0 fs/inode.c:248
>  iget5_locked fs/inode.c:1148 [inline]
>  iget5_locked+0x57/0xd0 fs/inode.c:1141
>  nilfs_iget_locked fs/nilfs2/inode.c:570 [inline]
>  nilfs_iget+0xb2/0x870 fs/nilfs2/inode.c:579
>  nilfs_lookup fs/nilfs2/namei.c:63 [inline]
>  nilfs_lookup+0xfd/0x130 fs/nilfs2/namei.c:54
>  __lookup_slow+0x255/0x490 fs/namei.c:1626
>  lookup_slow fs/namei.c:1643 [inline]
>  walk_component+0x418/0x6a0 fs/namei.c:1939
>  link_path_walk.part.0+0x6b6/0xc10 fs/namei.c:2266
>  link_path_walk fs/namei.c:2190 [inline]
>  path_lookupat.isra.0+0x8d/0x530 fs/namei.c:2419
>  filename_lookup+0x1a3/0x3e0 fs/namei.c:2453
>  user_path_at include/linux/namei.h:60 [inline]
>  vfs_statx+0x13c/0x370 fs/stat.c:195
>  do_statx+0xd9/0x160 fs/stat.c:590
>  __do_sys_statx fs/stat.c:613 [inline]
>  __se_sys_statx fs/stat.c:608 [inline]
>  __x64_sys_statx+0xba/0x150 fs/stat.c:608
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x4505ad
> Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff7db857c8 EFLAGS: 00000246 ORIG_RAX: 000000000000014c
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004505ad
> RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000006
> RBP: 0000000000000004 R08: 0000000000000000 R09: 00000000004a4099
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff7db857ec
> R13: 00007fff7db85810 R14: 00007fff7db857f0 R15: 0000000000000010
>
> Allocated by task 8426:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_set_track mm/kasan/common.c:46 [inline]
>  set_alloc_info mm/kasan/common.c:427 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:506 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:465 [inline]
>  __kasan_kmalloc+0x99/0xc0 mm/kasan/common.c:515
>  kasan_kmalloc include/linux/kasan.h:233 [inline]
>  __kmalloc+0x1c7/0x3d0 mm/slub.c:4055
>  kmalloc include/linux/slab.h:559 [inline]
>  kzalloc include/linux/slab.h:684 [inline]
>  nilfs_mdt_init+0x2c/0x1e0 fs/nilfs2/mdt.c:448
>  nilfs_dat_read+0x11b/0x2c0 fs/nilfs2/dat.c:489
>  nilfs_load_super_root fs/nilfs2/the_nilfs.c:120 [inline]
>  load_nilfs+0x327/0x11c0 fs/nilfs2/the_nilfs.c:269
>  nilfs_fill_super fs/nilfs2/super.c:1058 [inline]
>  nilfs_mount+0xab0/0xfe0 fs/nilfs2/super.c:1316
>  legacy_get_tree+0x105/0x220 fs/fs_context.c:592
>  vfs_get_tree+0x89/0x2f0 fs/super.c:1497
>  do_new_mount fs/namespace.c:2903 [inline]
>  path_mount+0x123b/0x1cc0 fs/namespace.c:3233
>  do_mount+0xf3/0x110 fs/namespace.c:3246
>  __do_sys_mount fs/namespace.c:3454 [inline]
>  __se_sys_mount fs/namespace.c:3431 [inline]
>  __x64_sys_mount+0x18f/0x230 fs/namespace.c:3431
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Last potentially related work creation:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
>  __call_rcu kernel/rcu/tree.c:3039 [inline]
>  call_rcu+0xb1/0x700 kernel/rcu/tree.c:3114
>  netlink_release+0xd41/0x1c20 net/netlink/af_netlink.c:810
>  __sock_release+0xcd/0x280 net/socket.c:599
>  sock_close+0x18/0x20 net/socket.c:1258
>  __fput+0x288/0x920 fs/file_table.c:280
>  task_work_run+0xe0/0x1a0 kernel/task_work.c:140
>  tracehook_notify_resume include/linux/tracehook.h:189 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
>  exit_to_user_mode_prepare+0x25c/0x270 kernel/entry/common.c:208
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
>  syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Second to last potentially related work creation:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
>  insert_work+0x4a/0x3a0 kernel/workqueue.c:1331
>  __queue_work+0x4d4/0x1120 kernel/workqueue.c:1497
>  queue_work_on+0xae/0xc0 kernel/workqueue.c:1524
>  kref_put include/linux/kref.h:65 [inline]
>  tty_kref_put drivers/tty/tty_io.c:1589 [inline]
>  release_tty+0x4e9/0x610 drivers/tty/tty_io.c:1626
>  tty_release_struct+0x37/0x50 drivers/tty/tty_io.c:1725
>  tty_release+0xbd2/0x1140 drivers/tty/tty_io.c:1885
>  __fput+0x288/0x920 fs/file_table.c:280
>  task_work_run+0xe0/0x1a0 kernel/task_work.c:140
>  tracehook_notify_resume include/linux/tracehook.h:189 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
>  exit_to_user_mode_prepare+0x25c/0x270 kernel/entry/common.c:208
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
>  syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> The buggy address belongs to the object at ffff8880478f0000
>  which belongs to the cache kmalloc-2k of size 2048
> The buggy address is located 152 bytes inside of
>  2048-byte region [ffff8880478f0000, ffff8880478f0800)
> The buggy address belongs to the page:
> page:0000000003e87868 refcount:1 mapcount:0 mapping:0000000000000000
> index:0xffff8880478f0000 pfn:0x478f0
> head:0000000003e87868 order:3 compound_mapcount:0 compound_pincount:0
> flags: 0x4fff00000010200(slab|head)
> raw: 04fff00000010200 ffffea00011e0600 0000000200000002 ffff88800fc42000
> raw: ffff8880478f0000 0000000080080007 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff8880478eff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff8880478f0000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff8880478f0080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                             ^
>  ffff8880478f0100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8880478f0180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
>
> the attachment is reproduce.
>
> Regards,
>   butt3rflyh4ck.
