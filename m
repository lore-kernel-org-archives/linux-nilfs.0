From: John Huttley <John-jE24nFfhqzU3hwNNidygWXTaI6DYlTYJ@public.gmane.org>
Subject: cleanerd crash
Date: Sat, 18 Oct 2008 13:39:55 +1300
Message-ID: <48F9305B.8010807@mib-infotech.co.nz>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

I also got this, which might help.
This is part of the original 'crash and lockup fs bug', it might have 
been using the older version of the utils.
Is the this the bug you fixed??

--john



2008-10-18T10:10:20+13:00 kernel BUG at 
/var/tmp/paludis/sys-fs-nilfs-2.0.4/work/nilfs-2.0.4/fs/dat.c:970!
2008-10-18T10:10:20+13:00 invalid opcode: 0000 [1] SMP
2008-10-18T10:10:20+13:00 CPU 1
2008-10-18T10:10:20+13:00 Modules linked in: iscsi_trgt nilfs2 reiserfs 
ohci_hcd lpfc qla2xxx firmware_class scsi_wait_scan
2008-10-18T10:10:20+13:00 Pid: 28706, comm: nilfs_cleanerd Not tainted 
2.6.26-gentoo #2
2008-10-18T10:10:20+13:00 RIP: 0010:[<ffffffffa00c05b2>]  
[<ffffffffa00c05b2>] :nilfs2:nilfs_dat_freev+0x262/0x370
2008-10-18T10:10:20+13:00 RSP: 0018:ffff810000c73b38  EFLAGS: 00010292
2008-10-18T10:10:20+13:00 RAX: 000000000000003d RBX: ffff8100090eb000 
RCX: 0000000000000002
2008-10-18T10:10:20+13:00 RDX: ffff810033d42650 RSI: 0000000000000086 
RDI: ffffffff80863000
2008-10-18T10:10:20+13:00 RBP: ffff810000c73b98 R08: fffffffffd9da600 
R09: 00003b4a92744154
2008-10-18T10:10:20+13:00 R10: 0000000000000000 R11: ffff810001015880 
R12: 0000000000000bff
2008-10-18T10:10:20+13:00 R13: 000000000000000c R14: ffff81003b59c400 
R15: 0000000000000001
2008-10-18T10:10:20+13:00 FS:  00007fe35a4bf6f0(0000) 
GS:ffff81003f806480(0000) knlGS:0000000000000000
2008-10-18T10:10:20+13:00 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
2008-10-18T10:10:20+13:00 CR2: 00007fc6be589e44 CR3: 0000000002fd2000 
CR4: 00000000000006e0
2008-10-18T10:10:20+13:00 DR0: 0000000000000000 DR1: 0000000000000000 
DR2: 0000000000000000
2008-10-18T10:10:20+13:00 DR3: 0000000000000000 DR6: 00000000ffff0ff0 
DR7: 0000000000000400
2008-10-18T10:10:20+13:00 Process nilfs_cleanerd (pid: 28706, threadinfo 
ffff810000c72000, task ffff8100385eabe0)
2008-10-18T10:10:20+13:00 Stack:  0000000000000bff ffff8100024e0000 
0000000000020000 ffffe200001fb368
2008-10-18T10:10:20+13:00 00000000624cea40 ffff810013b055b0 
ffff810013b052a0 0000000000000bff
2008-10-18T10:10:20+13:00 0000000000000bff ffff810000c73c78 
ffff8100024e0000 0000000000000000
2008-10-18T10:10:20+13:00 Call Trace:
2008-10-18T10:10:20+13:00 [<ffffffffa00ceb5b>] 
:nilfs2:nilfs_ioctl_do_free_vblocknrs+0x3b/0x60
2008-10-18T10:10:20+13:00 [<ffffffffa00cd71b>] 
:nilfs2:nilfs_ioctl_wrap_copy+0x10b/0x160
2008-10-18T10:10:20+13:00 [<ffffffffa00ceb20>] ? 
:nilfs2:nilfs_ioctl_do_free_vblocknrs+0x0/0x60
2008-10-18T10:10:20+13:00 [<ffffffffa00ce5b6>] 
:nilfs2:nilfs_ioctl_prepare_clean_segments+0x96/0x100
2008-10-18T10:10:20+13:00 [<ffffffffa00c8330>] 
:nilfs2:nilfs_clean_segments+0x90/0x2d0
2008-10-18T10:10:20+13:00 [<ffffffff8026c654>] ? 
free_compound_page+0x14/0x20
2008-10-18T10:10:20+13:00 [<ffffffff8026fda6>] ? put_compound_page+0x26/0x40
2008-10-18T10:10:20+13:00 [<ffffffff802704c7>] ? put_page+0xe7/0xf0
2008-10-18T10:10:20+13:00 [<ffffffff8028d86e>] ? kfree+0x9e/0xb0
2008-10-18T10:10:20+13:00 [<ffffffffa00cd8bd>] 
:nilfs2:nilfs_ioctl+0x10d/0x810
2008-10-18T10:10:20+13:00 [<ffffffff802677ad>] ? unlock_page+0x2d/0x40
2008-10-18T10:10:20+13:00 [<ffffffff802a1fce>] ? locks_free_lock+0x3e/0x60
2008-10-18T10:10:20+13:00 [<ffffffff8029f1aa>] vfs_ioctl+0x7a/0x90
2008-10-18T10:10:20+13:00 [<ffffffff8029f233>] do_vfs_ioctl+0x73/0x2c0
2008-10-18T10:10:20+13:00 [<ffffffff8029f4ca>] sys_ioctl+0x4a/0x80
2008-10-18T10:10:20+13:00 [<ffffffff8020b54b>] 
system_call_after_swapgs+0x7b/0x80
2008-10-18T10:10:20+13:00
2008-10-18T10:10:20+13:00
2008-10-18T10:10:20+13:00 Code: f0 49 89 d2 31 d2 49 f7 f2 f0 0f b3 17 
19 d2 85 d2 75 90 49 8b 13 48 c7 c6 b0 f7 0c a0 48 c7 c7 e8 13 0d a0 31 
c0 e8 de 84 17 e0 <0f> 0b eb fe 4c 63 65 c4 48 ba 00 00 00 00 00 1e 00 
00 48 03 55
2008-10-18T10:10:20+13:00 RIP  [<ffffffffa00c05b2>] 
:nilfs2:nilfs_dat_freev+0x262/0x370
2008-10-18T10:10:20+13:00 RSP <ffff810000c73b38>
2008-10-18T10:10:20+13:00 ---[ end trace 90c6f5253eb3feb3 ]---
