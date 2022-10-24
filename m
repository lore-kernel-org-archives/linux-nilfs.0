From: syzbot <syzbot+b0a35a5c1f7e846d3b09-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Subject: [syzbot] kernel BUG in nilfs_btnode_create_block
Date: Mon, 24 Oct 2022 02:58:36 -0700
Message-ID: <000000000000d1d6c205ebc4d512@google.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=169b556a880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3a4a45d2d827c1e
dashboard link: https://syzkaller.appspot.com/bug?extid=b0a35a5c1f7e846d3b09
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e8e91bc79312/disk-bbed346d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c1cb3fb3b77e/vmlinux-bbed346d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b0a35a5c1f7e846d3b09-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

------------[ cut here ]------------
kernel BUG at fs/nilfs2/btnode.c:59!
Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 2986 Comm: syz-executor.2 Not tainted 6.0.0-rc7-syzkaller-18095-gbbed346d5a96 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : nilfs_btnode_create_block+0x1c0/0x2f8 fs/nilfs2/btnode.c:58
lr : nilfs_btnode_create_block+0x1c0/0x2f8 fs/nilfs2/btnode.c:58
sp : ffff80001f993640
x29: ffff80001f993640 x28: 00000000000a0011 x27: ffff000115a270a8
x26: 00000000000a0011 x25: 0000000000000001 x24: ffff000115a270a8
x23: 000000000000000a x22: 0000000000020011 x21: ffff000119804898
x20: 000000000000091f x19: ffff000119b43498 x18: 000000000000001c
x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000002 x13: 0000000000000406 x12: 0000000000040000
x11: 000000000000bf84 x10: ffff80001b857000 x9 : 00000000ffffffff
x8 : ffff000119b434f8 x7 : ffff8000083d3920 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000020000 x3 : 000000000000000a
x2 : 0000000000000000 x1 : 0000000000000001 x0 : 0000000000000000
Call trace:
 nilfs_btnode_create_block+0x1c0/0x2f8 fs/nilfs2/btnode.c:58
 nilfs_btnode_prepare_change_key+0x138/0x19c fs/nilfs2/btnode.c:219
 nilfs_btree_prepare_update_v+0x128/0x17c fs/nilfs2/btree.c:1921
 nilfs_btree_prepare_propagate_v fs/nilfs2/btree.c:1988 [inline]
 nilfs_btree_propagate_v+0x110/0x420 fs/nilfs2/btree.c:2033
 nilfs_btree_propagate+0x258/0x350 fs/nilfs2/btree.c:2090
 nilfs_bmap_propagate+0x40/0xa8 fs/nilfs2/bmap.c:337
 nilfs_collect_file_data+0x34/0xa8 fs/nilfs2/segment.c:568
 nilfs_segctor_apply_buffers+0x84/0x168 fs/nilfs2/segment.c:1012
 nilfs_segctor_scan_file_dsync fs/nilfs2/segment.c:1101 [inline]
 nilfs_segctor_collect_blocks+0x1bc/0x93c fs/nilfs2/segment.c:1255
 nilfs_segctor_collect fs/nilfs2/segment.c:1497 [inline]
 nilfs_segctor_do_construct+0x3e4/0xee8 fs/nilfs2/segment.c:2039
 nilfs_construct_dsync_segment+0x21c/0x2ec fs/nilfs2/segment.c:2306
 nilfs_writepages+0x6c/0xa8 fs/nilfs2/inode.c:170
 do_writepages+0x144/0x27c mm/page-writeback.c:2468
 filemap_fdatawrite_wbc+0xac/0xd0 mm/filemap.c:388
 __filemap_fdatawrite_range mm/filemap.c:421 [inline]
 filemap_write_and_wait_range+0x84/0x1e8 mm/filemap.c:673
 __generic_file_write_iter+0x188/0x21c mm/filemap.c:3852
 generic_file_write_iter+0x6c/0x168 mm/filemap.c:3898
 call_write_iter include/linux/fs.h:2187 [inline]
 new_sync_write fs/read_write.c:491 [inline]
 vfs_write+0x2dc/0x46c fs/read_write.c:578
 ksys_write+0xb4/0x160 fs/read_write.c:631
 __do_sys_write fs/read_write.c:643 [inline]
 __se_sys_write fs/read_write.c:640 [inline]
 __arm64_sys_write+0x24/0x34 fs/read_write.c:640
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:636
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:654
 el0t_64_sync+0x18c/0x190 arch/arm64/kernel/entry.S:581
Code: 14000002 97cd2111 aa1303e0 9400004f (d4210000) 
---[ end trace 0000000000000000 ]---


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
