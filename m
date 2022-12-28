From: syzbot <syzbot+ede796cecd5296353515-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Subject: [syzbot] [nilfs2?] general protection fault in nilfs_btree_insert
Date: Wed, 28 Dec 2022 05:40:42 -0800
Message-ID: <000000000000bd89e205f0e38355@google.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org

Hello,

syzbot found the following issue on:

HEAD commit:    51094a24b85e Merge tag 'hardening-v6.2-rc1-fixes' of git:/..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=172e2b44480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e2d7bfa2d6d5a76
dashboard link: https://syzkaller.appspot.com/bug?extid=ede796cecd5296353515
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1243578c480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1506f1ac480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a26f3769fdfb/disk-51094a24.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5decc3ae71d7/vmlinux-51094a24.xz
kernel image: https://storage.googleapis.com/syzbot-assets/dd2ac18a5b04/bzImage-51094a24.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/559169c47ec8/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ede796cecd5296353515-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

loop0: detected capacity change from 0 to 2048
general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
CPU: 1 PID: 5066 Comm: syz-executor153 Not tainted 6.1.0-syzkaller-14587-g51094a24b85e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:nilfs_btree_get_nonroot_node fs/nilfs2/btree.c:418 [inline]
RIP: 0010:nilfs_btree_prepare_insert fs/nilfs2/btree.c:1077 [inline]
RIP: 0010:nilfs_btree_insert+0x6d3/0x1c10 fs/nilfs2/btree.c:1238
Code: bc 24 80 00 00 00 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 ff e8 4b 02 92 fe 4d 8b 3f 49 83 c7 28 4c 89 f8 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 ff e8 2e 02 92 fe 4d 8b 3f 49 83 c7 02
RSP: 0018:ffffc90003bcf4a0 EFLAGS: 00010206
RAX: 0000000000000005 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff88807eba3a80 RSI: 0000000000000002 RDI: 0000000000000001
RBP: ffffc90003bcf630 R08: ffffffff834f80d8 R09: ffffed100571ff9b
R10: ffffed100571ff9b R11: 1ffff1100571ff9a R12: ffff888021d03480
R13: dffffc0000000000 R14: 0000000000000002 R15: 0000000000000028
FS:  000055555588c300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4614ff5a70 CR3: 000000007eb7c000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 nilfs_bmap_do_insert fs/nilfs2/bmap.c:121 [inline]
 nilfs_bmap_insert+0x20d/0x360 fs/nilfs2/bmap.c:147
 nilfs_get_block+0x414/0x8d0 fs/nilfs2/inode.c:101
 __block_write_begin_int+0x54c/0x1a80 fs/buffer.c:1991
 __block_write_begin fs/buffer.c:2041 [inline]
 block_write_begin+0x93/0x1e0 fs/buffer.c:2102
 nilfs_write_begin+0x9c/0x110 fs/nilfs2/inode.c:261
 generic_perform_write+0x2e4/0x5e0 mm/filemap.c:3772
 __generic_file_write_iter+0x176/0x400 mm/filemap.c:3900
 generic_file_write_iter+0xab/0x310 mm/filemap.c:3932
 call_write_iter include/linux/fs.h:2186 [inline]
 new_sync_write fs/read_write.c:491 [inline]
 vfs_write+0x7dc/0xc50 fs/read_write.c:584
 ksys_write+0x177/0x2a0 fs/read_write.c:637
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fca03d80b59
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 51 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdd1df8c28 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fca03d80b59
RDX: 000000000000002f RSI: 0000000020000040 RDI: 0000000000000004
RBP: 00007fca03d40160 R08: 0000000000000014 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fca03d401f0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:nilfs_btree_get_nonroot_node fs/nilfs2/btree.c:418 [inline]
RIP: 0010:nilfs_btree_prepare_insert fs/nilfs2/btree.c:1077 [inline]
RIP: 0010:nilfs_btree_insert+0x6d3/0x1c10 fs/nilfs2/btree.c:1238
Code: bc 24 80 00 00 00 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 ff e8 4b 02 92 fe 4d 8b 3f 49 83 c7 28 4c 89 f8 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 ff e8 2e 02 92 fe 4d 8b 3f 49 83 c7 02
RSP: 0018:ffffc90003bcf4a0 EFLAGS: 00010206
RAX: 0000000000000005 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff88807eba3a80 RSI: 0000000000000002 RDI: 0000000000000001
RBP: ffffc90003bcf630 R08: ffffffff834f80d8 R09: ffffed100571ff9b
R10: ffffed100571ff9b R11: 1ffff1100571ff9a R12: ffff888021d03480
R13: dffffc0000000000 R14: 0000000000000002 R15: 0000000000000028
FS:  000055555588c300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a236e64fe0 CR3: 000000007eb7c000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	bc 24 80 00 00       	mov    $0x8024,%esp
   5:	00 4c 89 f8          	add    %cl,-0x8(%rcx,%rcx,4)
   9:	48 c1 e8 03          	shr    $0x3,%rax
   d:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)
  12:	74 08                	je     0x1c
  14:	4c 89 ff             	mov    %r15,%rdi
  17:	e8 4b 02 92 fe       	callq  0xfe920267
  1c:	4d 8b 3f             	mov    (%r15),%r15
  1f:	49 83 c7 28          	add    $0x28,%r15
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 ff             	mov    %r15,%rdi
  34:	e8 2e 02 92 fe       	callq  0xfe920267
  39:	4d 8b 3f             	mov    (%r15),%r15
  3c:	49 83 c7 02          	add    $0x2,%r15


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
