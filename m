From: Markus Trippelsdorf <markus-xp2qqqlHh3xzoYq+O6RWwA@public.gmane.org>
Subject: kernel Oops while running nilfs_cleanerd
Date: Thu, 5 Nov 2009 22:31:58 +0000 (UTC)
Message-ID: <hcvjou$7nt$1@ger.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

While playing with nilfs as the root fs on my SSD I ran into the following
problem: 

Nov  5 22:16:00 arch kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
Nov  5 22:16:00 arch kernel: IP: [<ffffffff811846b2>] nilfs_ioctl_clean_segments+0x342/0x49d
Nov  5 22:16:00 arch kernel: PGD 11c663067 PUD 11c7a2067 PMD 0
Nov  5 22:16:00 arch kernel: Oops: 0000 [#1] SMP
Nov  5 22:16:00 arch kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:05.0/boot_vga
Nov  5 22:16:00 arch kernel: CPU 2
Nov  5 22:16:00 arch kernel: Pid: 1204, comm: nilfs_cleanerd Not tainted 2.6.32-rc6-00058-g9724678-dirty #1 System Product Name
Nov  5 22:16:00 arch kernel: RIP: 0010:[<ffffffff811846b2>]  [<ffffffff811846b2>] nilfs_ioctl_clean_segments+0x342/0x49d
Nov  5 22:16:00 arch kernel: RSP: 0018:ffff88011dc9dca8  EFLAGS: 00010246
Nov  5 22:16:00 arch kernel: RAX: 0000000000000000 RBX: 00000000ffffffef RCX: ffff8800b61430b8
Nov  5 22:16:00 arch kernel: RDX: ffffffff8155ab7a RSI: 0000000000400000 RDI: 0000000000000004
Nov  5 22:16:00 arch kernel: RBP: ffff88011dc9ddf8 R08: 0000000000400020 R09: 0000000000000000
Nov  5 22:16:00 arch kernel: R10: 0000000000000000 R11: ffff8800b93f4ad8 R12: ffff8800b6143070
Nov  5 22:16:00 arch kernel: R13: ffff88011f0c0a00 R14: 0000000000000004 R15: ffff88011f583558
Nov  5 22:16:00 arch kernel: FS:  00007ff8c9960700(0000) GS:ffff880028300000(0000) knlGS:0000000000000000
Nov  5 22:16:00 arch kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov  5 22:16:00 arch kernel: CR2: 0000000000000038 CR3: 000000011dcbb000 CR4: 00000000000006e0
Nov  5 22:16:00 arch kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov  5 22:16:00 arch kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov  5 22:16:00 arch kernel: Process nilfs_cleanerd (pid: 1204, threadinfo ffff88011dc9c000, task ffff88011d565800)
Nov  5 22:16:00 arch kernel: Stack:
Nov  5 22:16:00 arch kernel: ffff88011dc9dcf8 0000000000000202 ffff88011dc9dcc8 ffff88011dc9dda8
Nov  5 22:16:00 arch kernel: <0> 000000000097b320 ffff8800b61430b8 0000000000000000 0000000000000005
Nov  5 22:16:00 arch kernel: <0> 00000000000008e4 00000000000008e4 000000000098f330 00000040000008e4
Nov  5 22:16:00 arch kernel: Call Trace:
Nov  5 22:16:00 arch kernel: [<ffffffff811841e0>] ? nilfs_ioctl_wrap_copy+0x179/0x18b
Nov  5 22:16:00 arch kernel: [<ffffffff81184a61>] nilfs_ioctl+0x254/0x2ba
Nov  5 22:16:00 arch kernel: [<ffffffff8110750c>] ? locks_free_lock+0x4f/0x53
Nov  5 22:16:00 arch kernel: [<ffffffff810e3637>] vfs_ioctl+0x22/0x87
Nov  5 22:16:00 arch kernel: [<ffffffff810e3b4d>] do_vfs_ioctl+0x435/0x47b
Nov  5 22:16:00 arch kernel: [<ffffffff810c37fb>] ? remove_vma+0x5c/0x64
Nov  5 22:16:00 arch kernel: [<ffffffff810e3bda>] sys_ioctl+0x47/0x6a
Nov  5 22:16:00 arch kernel: [<ffffffff8103157b>] system_call_fastpath+0x16/0x1b
Nov  5 22:16:00 arch kernel: Code: d8 fe ff ff e8 ba f6 ff ff 85 c0 48 8b 95 d8 fe ff ff 79 59 83 f8 ef 89 c3 0f 85 ad 00 00 00 49 8b 44 24 40 48 c7 c2 7a ab 55 81 <83> 78 38 00 48 8b 78 10 48 8b 70 28 4c 8b 48 30 4c 8b 40 08 48
Nov  5 22:16:00 arch kernel: RIP  [<ffffffff811846b2>] nilfs_ioctl_clean_segments+0x342/0x49d
Nov  5 22:16:00 arch kernel: RSP <ffff88011dc9dca8>
Nov  5 22:16:00 arch kernel: CR2: 0000000000000038
Nov  5 22:16:00 arch kernel: ---[ end trace 1fa7d83d961ba4e4 ]---

Nov  5 22:21:15 arch kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
Nov  5 22:21:15 arch kernel: IP: [<ffffffff811846b2>] nilfs_ioctl_clean_segments+0x342/0x49d
Nov  5 22:21:15 arch kernel: PGD 11c538067 PUD 11b952067 PMD 0
Nov  5 22:21:15 arch kernel: Oops: 0000 [#1] SMP
Nov  5 22:21:15 arch kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:12.1/usb4/idVendor
Nov  5 22:21:15 arch kernel: CPU 3
Nov  5 22:21:15 arch kernel: Pid: 1226, comm: nilfs_cleanerd Not tainted 2.6.32-rc6-00058-g9724678-dirty #1 System Product Name
Nov  5 22:21:15 arch kernel: RIP: 0010:[<ffffffff811846b2>]  [<ffffffff811846b2>] nilfs_ioctl_clean_segments+0x342/0x49d
Nov  5 22:21:15 arch kernel: RSP: 0018:ffff88011d493ca8  EFLAGS: 00010246
Nov  5 22:21:15 arch kernel: RAX: 0000000000000000 RBX: 00000000ffffffef RCX: ffff88011b025a58
Nov  5 22:21:15 arch kernel: RDX: ffffffff8155ab7a RSI: 0000000000400000 RDI: 0000000000000004
Nov  5 22:21:15 arch kernel: RBP: ffff88011d493df8 R08: 0000000000400020 R09: 0000000000000000
Nov  5 22:21:15 arch kernel: R10: 0000000000000000 R11: ffff88011f733af8 R12: ffff88011b025a10
Nov  5 22:21:15 arch kernel: R13: ffff88011faa7600 R14: 0000000000000004 R15: ffff88011f7b0840
Nov  5 22:21:15 arch kernel: FS:  00007fcf4fd80700(0000) GS:ffff880028380000(0000) knlGS:0000000000000000
Nov  5 22:21:15 arch kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov  5 22:21:15 arch kernel: CR2: 0000000000000038 CR3: 000000011cdd4000 CR4: 00000000000006e0
Nov  5 22:21:15 arch kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov  5 22:21:15 arch kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov  5 22:21:15 arch kernel: Process nilfs_cleanerd (pid: 1226, threadinfo ffff88011d492000, task ffff88011c482c00)
Nov  5 22:21:15 arch kernel: Stack:
Nov  5 22:21:15 arch kernel: ffff88011d493cf8 0000000000000202 ffff88011d493cc8 ffff88011d493da8
Nov  5 22:21:15 arch kernel: <0> 0000000001aeb320 ffff88011b025a58 0000000000000000 0000000000000005
Nov  5 22:21:15 arch kernel: <0> 00000000000008e4 00000000000008e4 00007fcf4fd3e010 00000040000008e4
Nov  5 22:21:15 arch kernel: Call Trace:
Nov  5 22:21:15 arch kernel: [<ffffffff811841e0>] ? nilfs_ioctl_wrap_copy+0x179/0x18b
Nov  5 22:21:15 arch kernel: [<ffffffff81184a61>] nilfs_ioctl+0x254/0x2ba
Nov  5 22:21:15 arch kernel: [<ffffffff810bb3de>] ? __inc_zone_state+0x9/0x73
Nov  5 22:21:15 arch kernel: [<ffffffff810b05e1>] ? __lru_cache_add+0x9/0x60
Nov  5 22:21:15 arch kernel: [<ffffffff810b065f>] ? lru_cache_add_lru+0x27/0x29
Nov  5 22:21:15 arch kernel: [<ffffffff810e3637>] vfs_ioctl+0x22/0x87
Nov  5 22:21:15 arch kernel: [<ffffffff810e3b4d>] do_vfs_ioctl+0x435/0x47b
Nov  5 22:21:15 arch kernel: [<ffffffff811f8e97>] ? __up_read+0x9a/0xa3
Nov  5 22:21:15 arch kernel: [<ffffffff8107ed46>] ? up_read+0xe/0x10
Nov  5 22:21:15 arch kernel: [<ffffffff810e3bda>] sys_ioctl+0x47/0x6a
Nov  5 22:21:15 arch kernel: [<ffffffff8103157b>] system_call_fastpath+0x16/0x1b
Nov  5 22:21:15 arch kernel: Code: d8 fe ff ff e8 ba f6 ff ff 85 c0 48 8b 95 d8 fe ff ff 79 59 83 f8 ef 89 c3 0f 85 ad 00 00 00 49 8b 44 24 40 48 c7 c2 7a ab 55 81 <83> 78 38 00 48 8b 78 10 48 8b 70 28 4c 8b 48 30 4c 8b 40 08 48
Nov  5 22:21:15 arch kernel: RIP  [<ffffffff811846b2>] nilfs_ioctl_clean_segments+0x342/0x49d
Nov  5 22:21:15 arch kernel: RSP <ffff88011d493ca8>
Nov  5 22:21:15 arch kernel: CR2: 0000000000000038
Nov  5 22:21:15 arch kernel: ---[ end trace 8e34edfc69969ade ]---


(This is all the info I can provide, because I immediately switched back to btrfs)
-- 
Markus
