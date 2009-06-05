From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: NIlfs panic
Date: Sat, 06 Jun 2009 04:58:57 +0900 (JST)
Message-ID: <20090606.045857.56043935.ryusuke@osrg.net>
References: <4A29678F.10306@0bits.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4A29678F.10306-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, dave-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org

Hi Dave,
On Fri, 05 Jun 2009 22:44:31 +0400, Dave <dave-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org> wrote:
> Hi,
> 
> Was running a make, find and i paniced. I know this i'm running tanited 
> due to nvidia closed binary, but it may be something worth looking at.
> 
> Thanks
> Dave

Thanks for reporting.  I will look into the log.

Regards,
Ryusuke Konishi
 
> Jun  5 22:17:39 home kernel: BUG: unable to handle kernel NULL pointer 
> dereference at 000000a6
> Jun  5 22:17:39 home kernel: IP: [<c019c08f>] sync_buffer+0xf/0x40
> Jun  5 22:17:39 home kernel: *pdpt = 000000000ce16001 *pde = 
> 0000000000000000
> Jun  5 22:17:39 home kernel: Oops: 0000 [#1] PREEMPT SMP
> Jun  5 22:17:39 home kernel: last sysfs file: 
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed
> Jun  5 22:17:39 home kernel: Modules linked in: vboxnetflt vboxdrv 
> nls_iso8859_1 nls_cp437 vfat fat nvidia(P) rfcomm fuse sco bridge stp 
> llc bnep l2cap iptable_filter ip_tables x_tables autofs4 nfsd lockd 
> sunrpc exportfs snd_hda_codec_analog snd_hda_intel snd_hda_codec 
> snd_hwdep via_rhine tun usblp snd_pcm_oss snd_pcm snd_timer 
> snd_page_alloc snd_mixer_oss snd usb_storage hci_usb bluetooth uhci_hcd 
> ehci_hcd ohci_hcd it87 hwmon_vid i2c_dev i2c_core nilfs2
> Jun  5 22:17:39 home kernel:
> Jun  5 22:17:39 home kernel: Pid: 27412, comm: rm Tainted: P 
> (2.6.28 #1) System Product Name
> Jun  5 22:17:39 home kernel: EIP: 0060:[<c019c08f>] EFLAGS: 00210286 CPU: 1
> Jun  5 22:17:39 home kernel: EIP is at sync_buffer+0xf/0x40
> Jun  5 22:17:39 home kernel: EAX: 00000002 EBX: daf97e28 ECX: e3d11b50 
> EDX: 00000002
> Jun  5 22:17:39 home kernel: ESI: 00000002 EDI: daf97e30 EBP: c38018d8 
> ESP: daf97e08
> Jun  5 22:17:39 home kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Jun  5 22:17:39 home kernel: Process rm (pid: 27412, ti=daf96000 
> task=ddb3b800 task.ti=daf96000)
> Jun  5 22:17:39 home kernel: Stack:
> Jun  5 22:17:39 home kernel:  c038cf4d c019c080 e3d11b50 00000002 
> c019c080 e3d11b50 c038cfdb 00000002
> Jun  5 22:17:39 home kernel:  e3d11b50 00000002 00000001 ddb3b800 
> c013f4d0 c38018dc c38018dc e3d11b50
> Jun  5 22:17:39 home kernel:  00000021 00000000 c019c299 00000002 
> e3d11b50 c019d662 00000000 c2092360
> Jun  5 22:17:39 home kernel: Call Trace:
> Jun  5 22:17:39 home kernel:  [<c038cf4d>] __wait_on_bit_lock+0x3d/0x70
> Jun  5 22:17:39 home kernel:  [<c019c080>] sync_buffer+0x0/0x40
> Jun  5 22:17:39 home kernel:  [<c019c080>] sync_buffer+0x0/0x40
> Jun  5 22:17:39 home kernel:  [<c038cfdb>] 
> out_of_line_wait_on_bit_lock+0x5b/0x70
> Jun  5 22:17:39 home kernel:  [<c013f4d0>] wake_bit_function+0x0/0x60
> Jun  5 22:17:39 home kernel:  [<c019c299>] __lock_buffer+0x29/0x30
> Jun  5 22:17:39 home kernel:  [<c019d662>] block_invalidatepage+0xa2/0xb0
> Jun  5 22:17:39 home kernel:  [<c019d5c0>] block_invalidatepage+0x0/0xb0
> Jun  5 22:17:39 home kernel:  [<c015f296>] do_invalidatepage+0x16/0x20
> Jun  5 22:17:39 home kernel:  [<c015f7fd>] truncate_complete_page+0x4d/0x60
> Jun  5 22:17:39 home kernel:  [<c015f8d9>] 
> truncate_inode_pages_range+0xc9/0x350
> Jun  5 22:17:39 home kernel:  [<f82617fa>] nilfs_dirty_inode+0x5a/0x60 
> [nilfs2]
> Jun  5 22:17:39 home kernel:  [<c038e1bd>] _spin_lock+0xd/0x30
> Jun  5 22:17:39 home kernel:  [<f82731f1>] 
> nilfs_segctor_start_timer+0x11/0x70 [nilfs2]
> Jun  5 22:17:39 home kernel:  [<c038e5ac>] _spin_unlock+0xc/0x20
> Jun  5 22:17:39 home kernel:  [<c01a41e7>] inotify_inode_is_dead+0x17/0x80
> Jun  5 22:17:39 home kernel:  [<c015fb77>] truncate_inode_pages+0x17/0x20
> Jun  5 22:17:39 home kernel:  [<f826201f>] nilfs_delete_inode+0x8f/0xc0 
> [nilfs2]
> Jun  5 22:17:39 home kernel:  [<c038e1bd>] _spin_lock+0xd/0x30
> Jun  5 22:17:39 home kernel:  [<f8261f90>] nilfs_delete_inode+0x0/0xc0 
> [nilfs2]
> Jun  5 22:17:39 home kernel:  [<c018f58e>] generic_delete_inode+0x5e/0xd0
> Jun  5 22:17:39 home kernel:  [<c018eb64>] iput+0x44/0x50
> Jun  5 22:17:39 home kernel:  [<c01880d6>] do_unlinkat+0xd6/0x150
> Jun  5 22:17:39 home kernel:  [<c016bbee>] sys_brk+0xce/0x100
> Jun  5 22:17:39 home kernel:  [<c0103241>] sysenter_do_call+0x12/0x25
> Jun  5 22:17:39 home kernel: Code: 80 23 f7 89 d8 5b e9 31 f4 ff ff 90 
> 5b c3 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 0f ae f0 66 90 8b 40 18 
> 85 c0 74 1f 8b 40 04 <8b> 80 a4 00 00 00 85 c0 74 12 8b 40 40 85 c0 74 
> 0b 8b 48 14 85
> Jun  5 22:17:39 home kernel: EIP: [<c019c08f>] sync_buffer+0xf/0x40 
> SS:ESP 0068:daf97e08
> Jun  5 22:17:39 home kernel: ---[ end trace 89b09713be804d48 ]---
> 
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
