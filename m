From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs_cpfile_delete_checkpoints: cannot delete
 block
Date: Sun, 10 May 2009 14:43:13 +0900 (JST)
Message-ID: <20090510.144313.10164669.ryusuke@osrg.net>
References: <4A00944B.2020105@prnet.org>
	<20090506.120204.27533580.ryusuke@osrg.net>
	<4A01B0D2.6030509@prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4A01B0D2.6030509-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
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
To: admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi David,
On Wed, 06 May 2009 17:46:26 +0200, David Arendt wrote:
> Hi,
> 
> today I had run cleanerd on 2 clean partitions.
> 
> One worked flawlessly. On the other one this error occured:
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000ccd
> IP: [<f8341fcc>] nilfs_gc_iget+0x4c/0x130 [nilfs2]
> *pdpt = 0000000013d32001 *pde = 0000000000000000
> Oops: 0000 [#1] PREEMPT SMP
> last sysfs file: /sys/devices/pci0000:00/0000:00:1f.0/resource
> Modules linked in: nvidia(P) vmnet vmblock vmci vmmon fcpci(P) capi 
> capifs kernelcapi nilfs2 scsi_wait_scan
> 
> Pid: 8551, comm: nilfs_cleanerd Tainted: P           (2.6.29.2server #1) 
> P5QL-E
> EIP: 0060:[<f8341fcc>] EFLAGS: 00010202 CPU: 3
> EIP is at nilfs_gc_iget+0x4c/0x130 [nilfs2]
> EAX: 00000ccd EBX: 00000000 ECX: 00000002 EDX: f6897c00
> ESI: 0000004e EDI: 00000002 EBP: 00000000 ESP: c3801ca0
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process nilfs_cleanerd (pid: 8551, ti=c3800000 task=d4d10330 
> task.ti=c3800000)
> Stack:
>  e11854c0 f6857a00 f6897c3c 00000000 00000000 00000000 e1185500 f8342e06
>  00000002 00000000 c3801d60 00000044 f7450990 d4d10484 00000001 00000001
>  00000000 00000000 00020050 00000202 00000000 00000000 00000000 c3801d58
> Call Trace:
>  [<f8342e06>] nilfs_ioctl_do_move_blocks+0x76/0x3e0 [nilfs2]
>  [<f8342379>] nilfs_ioctl_wrap_copy+0x169/0x1f0 [nilfs2]
>  [<f834292e>] nilfs_ioctl_prepare_clean_segments+0x6e/0x130 [nilfs2]
>  [<f8342d90>] nilfs_ioctl_do_move_blocks+0x0/0x3e0 [nilfs2]
>  [<f833deb3>] nilfs_clean_segments+0x83/0x200 [nilfs2]
>  [<f83423c6>] nilfs_ioctl_wrap_copy+0x1b6/0x1f0 [nilfs2]
>  [<f8342810>] nilfs_ioctl+0x3d0/0x480 [nilfs2]
>  [<f8342c90>] nilfs_ioctl_do_get_bdescs+0x0/0xb0 [nilfs2]
>  [<c0312ddf>] ehci_irq+0x17f/0x340
>  [<c0168a78>] page_add_new_anon_rmap+0x28/0x60
>  [<c013ddfe>] getnstimeofday+0x4e/0x120
>  [<f8342440>] nilfs_ioctl+0x0/0x480 [nilfs2]
>  [<c017f50b>] vfs_ioctl+0x2b/0x90
>  [<c017f87b>] do_vfs_ioctl+0x1eb/0x530
>  [<c012d45b>] run_timer_softirq+0x15b/0x190
>  [<c0128d74>] __do_softirq+0x94/0x140
>  [<c017fbfd>] sys_ioctl+0x3d/0x70
>  [<c0103131>] sysenter_do_call+0x12/0x25
>  [<c0400000>] pci_read_bridge_bases+0x20/0x350
> Code: f8 69 c0 01 00 37 9e c1 e8 18 c1 e0 02 89 44 24 08 8b 92 dc 00 00 
> 00 01 d0 89 44 24 08 8b 00 85 c0 75 08 eb 2b 85 c9 74 27 89 c8 <8b> 08 
> 0f 18 01 90 3b 70 20 89 c3 75 ed 8b 50 9c 8b 40 98 31 ea
> EIP: [<f8341fcc>] nilfs_gc_iget+0x4c/0x130 [nilfs2] SS:ESP 0068:c3801ca0
> ---[ end trace 573da78de6d7c815 ]---
> 
> Bye,
> Arendt David

I finally gave up trailing this problem from your log because my gcc
generates different assembler code with yours.

Could you send me a disassembler output of the nilfs_gc_iget function?
It is acquirable as follows:

  $ cd nilfs2-module/fs
  $ objdump -D gcinode.o > gcinode.disasm

And, please let me know the gcc version you are using.

Thanks in advance,
Ryusuke Konishi
