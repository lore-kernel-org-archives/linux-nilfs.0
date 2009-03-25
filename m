From: admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org
Subject: Re: error on kernel 2.6.29 while running cleaner on a
 1tb volume
Date: Wed, 25 Mar 2009 12:18:47 +0100 (CET)
Message-ID: <45581.212.24.212.169.1237979927.squirrel@www.prnet.org>
References: <49C9BF81.6090203@prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <49C9BF81.6090203-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
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

Hi,

after trying to run the cleaner a second time, I had the following errors:

Mar 25 06:09:50 server nilfs_cleanerd[6772]: start
Mar 25 07:14:24 server nilfs_cpfile_delete_checkpoints: invalid range of
checkpo
int numbers: [4294969344, 32720)
Mar 25 07:14:24 server NILFS: GC failed during preparation: cannot delete
checkp
oints: err=-22
Mar 25 07:14:24 server nilfs_cleanerd[6772]: Invalid argument
Mar 25 07:14:24 server nilfs_cleanerd[6772]: cannot clean segments:
Invalid argu
ment
Mar 25 07:14:24 server nilfs_cleanerd[6772]: shutdown

Bye,
David Arendt

> Hi,
>
> First of all, please don't get me wrong for posting all this bug
> reports. It is not in the sense of complaining me. I am very satisfied
> with nilfs2. As I am a software developer myself, I always like
> receiving bug reports. What I hate most is people complaining in the
> sense nothing is working without any more information.
>
> So here an error on kernel 2.6.29 while running cleaner on a 1 tb
> volume. I am not sure if it is nilfs related, but I post it for your
> information.
>
> BUG: unable to handle kernel paging request at 9c5c67f0
> IP: [<c0239049>] radix_tree_delete+0x19/0x220
> *pdpt = 0000000030490001 *pde = 0000000000000000
> Oops: 0000 [#1] PREEMPT SMP
> last sysfs file:
> /sys/devices/pci0000:00/0000:00:1e.0/0000:04:03.0/resource
> Modules linked in: nvidia(P) vmnet vmblock vmci vmmon fcpci(P) capi
> capifs kernelcapi nilfs2 scsi_wait_scan
>
> Pid: 333, comm: kswapd0 Tainted: P           (2.6.29server #1) P5QL-E
> EIP: 0060:[<c0239049>] EFLAGS: 00010092 CPU: 3
> EIP is at radix_tree_delete+0x19/0x220
> EAX: 0537456a EBX: 00000000 ECX: f73f10d4 EDX: f701c598
> ESI: f73f10d4 EDI: f73f10e4 EBP: f73f10d8 ESP: f76e9d08
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process kswapd0 (pid: 333, ti=f76e8000 task=f76885c0 task.ti=f76e8000)
> Stack:
>  00000000 f6fc0040 0537456a 00000000 00000000 00000000 f76e9d2c c0169827
>  f5f0d3d0 f56e482c 00000080 0000c400 00000000 00000000 0000c5ab 0000c5ab
>  00000000 f56e482c c108dee0 f73f10d4 f73f10e4 f76e9ebc c014fc15 0000c5ab
> Call Trace:
>  [<c0169827>] page_referenced_file+0x77/0x90
>  [<c014fc15>] __remove_from_page_cache+0x15/0x90
>  [<c0158864>] __remove_mapping+0x84/0xc0
>  [<c01590f3>] shrink_page_list+0x393/0x6d0
>  [<c0158cf2>] shrink_active_list+0x332/0x3a0
>  [<c01580f8>] isolate_pages_global+0x88/0x210
>  [<c0156e39>] ____pagevec_lru_add+0x119/0x130
>  [<c0159654>] shrink_list+0x224/0x560
>  [<c0159c07>] shrink_zone+0x277/0x300
>  [<c015a6f8>] kswapd+0x518/0x530
>  [<c0158070>] isolate_pages_global+0x0/0x210
>  [<c0138940>] autoremove_wake_function+0x0/0x50
>  [<c011d33d>] complete+0x3d/0x60
>  [<c015a1e0>] kswapd+0x0/0x530
>  [<c0138622>] kthread+0x42/0x70
>  [<c01385e0>] kthread+0x0/0x70
>  [<c010391b>] kernel_thread_helper+0x7/0x1c
> Code: 89 f8 5b 5e 5f 5d c3 0f 0b eb fe 0f 0b eb fe 8d 76 00 55 89 c5 57
> 56 53 31 db 83 ec 48 89 54 24 08 8b 10 8b 44 24 08 89 5c 24 0c <39> 04
> 95 90 51 55 c0 0f 82 1c 01 00 00 8b 4d 08 85 d2 89 4c 24
> EIP: [<c0239049>] radix_tree_delete+0x19/0x220 SS:ESP 0068:f76e9d08
> ---[ end trace 86f39789c1fa8998 ]---
> note: kswapd0[333] exited with preempt_count 1
> BUG: unable to handle kernel NULL pointer dereference at 00000104
> IP: [<c01504f9>] find_get_pages+0x79/0xf0
> *pdpt = 0000000030e61001 *pde = 0000000000000000
> Oops: 0000 [#2] PREEMPT SMP
> last sysfs file:
> /sys/devices/pci0000:00/0000:00:1e.0/0000:04:03.0/resource
> Modules linked in: nvidia(P) vmnet vmblock vmci vmmon fcpci(P) capi
> capifs kernelcapi nilfs2 scsi_wait_scan
> Pid: 8494, comm: nilfs_cleanerd Tainted: P      D    (2.6.29server #1)
> P5QL-E
> EIP: 0060:[<c01504f9>] EFLAGS: 00210213 CPU: 2
> EIP is at find_get_pages+0x79/0xf0
> EAX: 00000100 EBX: 00000104 ECX: 00000100 EDX: db6a1cc4
> ESI: 0000000a EDI: db6a1c9c EBP: 0000000a ESP: db6a1c2c
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process nilfs_cleanerd (pid: 8494, ti=db6a0000 task=f75e7800
> task.ti=db6a0000)
> Stack:
>  0000000e db6a1cc4 00000104 00000002 f70d78a0 0000000e 000f76cf 0000000d
>  000f76cf db6a1c94 000f76ce 0000000e c0157502 db6a1c9c 000f76cf c1cf16e0
>  f8330336 0000000e db6a1c98 0000000e f70d7aec f70d78ac f70d7ae0 f70d789c
> Call Trace:
>  [<c0157502>] pagevec_lookup+0x22/0x30
>  [<f8330336>] nilfs_copy_back_pages+0x56/0x220 [nilfs2]
>  [<f834328b>] nilfs_commit_gcdat_inode+0x8b/0xc0 [nilfs2]
>  [<f833b1bd>] nilfs_segctor_complete_write+0x2fd/0x310 [nilfs2]
>  [<f833b914>] nilfs_segctor_do_construct+0x424/0x18c0 [nilfs2]
>  [<f83319bf>] nilfs_bmap_test_and_clear_dirty+0x2f/0x40 [nilfs2]
>  [<f833d009>] nilfs_segctor_construct+0x99/0xb0 [nilfs2]
>  [<f833df1f>] nilfs_clean_segments+0xef/0x200 [nilfs2]
>  [<f83427e0>] nilfs_ioctl+0x3d0/0x480 [nilfs2]
>  [<c030f774>] ehci_work+0x124/0x9a0
>  [<c011da6b>] update_curr+0x7b/0xe0
>  [<c012eeb7>] lock_timer_base+0x27/0x60
>  [<c013f55e>] getnstimeofday+0x4e/0x120
>  [<c0140808>] clocksource_get_next+0x38/0x40
>  [<f8342410>] nilfs_ioctl+0x0/0x480 [nilfs2]
>  [<c0180c6b>] vfs_ioctl+0x2b/0x90
>  [<c0180fdb>] do_vfs_ioctl+0x1eb/0x530
>  [<c012ebdb>] run_timer_softirq+0x15b/0x190
>  [<c012a484>] __do_softirq+0x94/0x160
>  [<c018135d>] sys_ioctl+0x3d/0x70
>  [<c0103131>] sysenter_do_call+0x12/0x25
>  [<c0400000>] pci_bus_size_bridges+0x1f0/0x410
> Code: 00 00 8b 44 24 34 8d 04 b0 89 44 24 04 8b 54 24 04 8b 02 8b 00 a8
> 01 75 ba 85 c0 89 c1 74 3e 83 f8 ff 74 af 8d 58 04 89 5c 24 08 <8b> 50
> 04 85 d2 74 db 8d 7a 01 89 d0 8b 5c 24 08 f0 0f b1 3b 39
> EIP: [<c01504f9>] find_get_pages+0x79/0xf0 SS:ESP 0068:db6a1c2c
> ---[ end trace 86f39789c1fa8999 ]---
> note: nilfs_cleanerd[8494] exited with preempt_count 1
>
> Bye,
> David Arendt
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
>
