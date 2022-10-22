From: syzbot <syzbot+53369d11851d8f26735c-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Subject: [syzbot] general protection fault in nilfs_clear_dirty_page
Date: Sat, 22 Oct 2022 02:12:40 -0700
Message-ID: <000000000000da4f6b05eb9bf593@google.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org

Hello,

syzbot found the following issue on:

HEAD commit:    6d36c728bc2e Merge tag 'net-6.1-rc2' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1526d2e2880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=afc317c0f52ce670
dashboard link: https://syzkaller.appspot.com/bug?extid=53369d11851d8f26735c
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a2030ff47985/disk-6d36c728.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/82a6ec6fd4db/vmlinux-6d36c728.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+53369d11851d8f26735c-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

NILFS (loop4): discard dirty block: blocknr=0, size=1024
NILFS (loop4): discard dirty block: blocknr=0, size=1024
NILFS (loop4): discard dirty block: blocknr=0, size=1024
NILFS (loop4): discard dirty block: blocknr=0, size=1024
general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 5633 Comm: kworker/u4:11 Not tainted 6.1.0-rc1-syzkaller-00093-g6d36c728bc2e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022
Workqueue: writeback wb_workfn (flush-7:4)
RIP: 0010:nilfs_clear_dirty_page+0x9a/0x1080 fs/nilfs2/page.c:387
Code: 31 e8 9a b3 3c fe 49 8d 5f 18 48 89 d8 48 c1 e8 03 42 80 3c 30 00 74 08 48 89 df e8 e0 9c 90 fe 48 8b 1b 48 89 d8 48 c1 e8 03 <42> 80 3c 30 00 74 08 48 89 df e8 c7 9c 90 fe 4c 8b 2b 49 8d 5d 28
RSP: 0018:ffffc900053e7020 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff888026a08000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffea00020d3440
RBP: ffffc900053e70f0 R08: ffffffff834ae92a R09: fffff9400041a689
R10: fffff9400041a689 R11: 1ffffd400041a688 R12: 000000000000000e
R13: 0000000000000000 R14: dffffc0000000000 R15: ffffea00020d3440
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f592433f000 CR3: 0000000033285000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 nilfs_clear_dirty_pages+0x1d9/0x380 fs/nilfs2/page.c:372
 nilfs_writepages+0x117/0x150 fs/nilfs2/inode.c:165
 do_writepages+0x3c3/0x680 mm/page-writeback.c:2469
 __writeback_single_inode+0xd1/0x670 fs/fs-writeback.c:1587
 writeback_sb_inodes+0xb3b/0x18f0 fs/fs-writeback.c:1870
 __writeback_inodes_wb+0x125/0x420 fs/fs-writeback.c:1941
 wb_writeback+0x440/0x7b0 fs/fs-writeback.c:2046
 wb_check_start_all fs/fs-writeback.c:2168 [inline]
 wb_do_writeback fs/fs-writeback.c:2194 [inline]
 wb_workfn+0x827/0xef0 fs/fs-writeback.c:2227
 process_one_work+0x877/0xdb0 kernel/workqueue.c:2289
 worker_thread+0xb14/0x1330 kernel/workqueue.c:2436
 kthread+0x266/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:nilfs_clear_dirty_page+0x9a/0x1080 fs/nilfs2/page.c:387
Code: 31 e8 9a b3 3c fe 49 8d 5f 18 48 89 d8 48 c1 e8 03 42 80 3c 30 00 74 08 48 89 df e8 e0 9c 90 fe 48 8b 1b 48 89 d8 48 c1 e8 03 <42> 80 3c 30 00 74 08 48 89 df e8 c7 9c 90 fe 4c 8b 2b 49 8d 5d 28
RSP: 0018:ffffc900053e7020 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff888026a08000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffea00020d3440
RBP: ffffc900053e70f0 R08: ffffffff834ae92a R09: fffff9400041a689
R10: fffff9400041a689 R11: 1ffffd400041a688 R12: 000000000000000e
R13: 0000000000000000 R14: dffffc0000000000 R15: ffffea00020d3440
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c000074368 CR3: 000000007ef36000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	e8 9a b3 3c fe       	callq  0xfe3cb39f
   5:	49 8d 5f 18          	lea    0x18(%r15),%rbx
   9:	48 89 d8             	mov    %rbx,%rax
   c:	48 c1 e8 03          	shr    $0x3,%rax
  10:	42 80 3c 30 00       	cmpb   $0x0,(%rax,%r14,1)
  15:	74 08                	je     0x1f
  17:	48 89 df             	mov    %rbx,%rdi
  1a:	e8 e0 9c 90 fe       	callq  0xfe909cff
  1f:	48 8b 1b             	mov    (%rbx),%rbx
  22:	48 89 d8             	mov    %rbx,%rax
  25:	48 c1 e8 03          	shr    $0x3,%rax
* 29:	42 80 3c 30 00       	cmpb   $0x0,(%rax,%r14,1) <-- trapping instruction
  2e:	74 08                	je     0x38
  30:	48 89 df             	mov    %rbx,%rdi
  33:	e8 c7 9c 90 fe       	callq  0xfe909cff
  38:	4c 8b 2b             	mov    (%rbx),%r13
  3b:	49 8d 5d 28          	lea    0x28(%r13),%rbx


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
