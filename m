From: Andrea Gelmini <andrea.gelmini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Crash...
Date: Thu, 23 Jul 2009 23:02:47 +0200
Message-ID: <9cdbb57f0907231402i1a92cb4qfe5a9d81346a4665@mail.gmail.com>
References: <9cdbb57f0907230555k768383c2ld1690d31cc6fff83@mail.gmail.com>
	<20090724.011249.110726474.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090724.011249.110726474.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

2009/7/23 Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>:
> It also suggests that an inconsistent state in page cache of B-tree
> nodes hit the function; the function found a dirty page, but the page
> didn't have buffer heads which was supposed to be impossible for the
> b-tree of nilfs.

Well,
   thanks for your quick reply.
   Anyway, I can reproduce the same problem doing same things with
stable kernel (2.6.29.6) and nilfs2-module from git repository.
   I do this:
   -> mkfs.nilfs2 -b 1024 /dev/mapper/VG-NilfHome (maybe the problem
is the 1K block size?)
   -> mount /dev/mapper/VG-NilfHome /tmp/test/
   -> I run mirrordir (here's exactly as a "cp -a")

   It stucks at the same file as the crash before.
   It's a 5G file, if it could help.

  Here the log:
 1429.034107] ------------[ cut here ]------------
[ 1429.034111] kernel BUG at /home/gelma/dev/nilfs2-module/fs/segment.c:846!
[ 1429.034113] invalid opcode: 0000 [#1] SMP
[ 1429.034115] last sysfs file: /sys/devices/virtual/block/dm-1/range
[ 1429.034116] Modules linked in: nilfs2 binfmt_misc rfcomm bridge stp
llc bnep sco l2cap bluetooth kqemu video backlight output sbs sbshc
pci_slot container battery ac loop rtc_cmos psmouse nvidia(P) rtc_core
rt2860sta(C) rtc_lib serio_raw i2c_core pcspkr iTCO_wdt
iTCO_vendor_support evdev joydev button sha256_generic sr_mod cdrom sg
usbhid hid sd_mod ata_generic usb_storage libusual pata_acpi ohci1394
ieee1394 ata_piix ehci_hcd pata_marvell libata scsi_mod uhci_hcd
e1000e usbcore dm_snapshot thermal processor fan thermal_sys hwmon
dm_mirror dm_region_hash dm_log
[ 1429.034149]
[ 1429.034151] Pid: 10294, comm: segctord Tainted: P         C
(2.6.29.6 #1)
[ 1429.034153] EIP: 0060:[<f842fccc>] EFLAGS: 00010246 CPU: 1
[ 1429.034162] EIP is at nilfs_segctor_scan_file+0xa5/0x19e [nilfs2]
[ 1429.034164] EAX: 40000020 EBX: 00000000 ECX: 0000000e EDX: c149c880
[ 1429.034165] ESI: f1c1e900 EDI: eba22468 EBP: f15c6dec ESP: f15c6d78
[ 1429.034167]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 1429.034168] Process segctord (pid: 10294, ti=f15c6000 task=f2c07c90
task.ti=f15c6000)
[ 1429.034170] Stack:
[ 1429.034170]  e3918e80 f843faa8 e3918e80 eba22408 eba22380 0000000e
00000000 c149c880
[ 1429.034174]  c139cd20 c16c99c0 c112f9e0 c127dca0 c127e560 c127e580
c127dda0 c127ddc0
[ 1429.034178]  c127e5c0 c1599640 c1599660 c1599680 c15996a0 f15c6dcc
f15c6dcc e38fe628
[ 1429.034182] Call Trace:
[ 1429.034187]  [<f84308d6>] ? nilfs_segctor_do_construct+0x66a/0x1e7f [nilfs2]
[ 1429.034196]  [<c010edab>] ? smp_reschedule_interrupt+0x13/0x25
[ 1429.034200]  [<c0103414>] ? reschedule_interrupt+0x28/0x30
[ 1429.034203]  [<c01226e6>] ? finish_task_switch+0x2c/0xa9
[ 1429.034210]  [<f843227c>] ? nilfs_segctor_construct+0x35/0x7f [nilfs2]
[ 1429.034218]  [<f8432bab>] ? nilfs_segctor_thread+0x141/0x26d [nilfs2]
[ 1429.034226]  [<f8432831>] ? nilfs_construction_timeout+0x0/0xa [nilfs2]
[ 1429.034235]  [<f8432a6a>] ? nilfs_segctor_thread+0x0/0x26d [nilfs2]
[ 1429.034243]  [<c013564f>] ? kthread+0x3b/0x61
[ 1429.034245]  [<c0135614>] ? kthread+0x0/0x61
[ 1429.034247]  [<c0103623>] ? kernel_thread_helper+0x7/0x10
[ 1429.034250] Code: 8d 47 a0 89 55 9c 89 45 98 c7 45 f0 00 00 00 00
c7 45 a0 00 00 00 00 c7 45 a4 00 00 00 00 eb 5e 8b 54 9d a8 8b 02 f6
c4 08 75 04 <0f> 0b eb fe 8b 52 0c 89 55 94 89 d1 f6 01 02 74 21 8d 41
34 f0
[ 1429.034271] EIP: [<f842fccc>] nilfs_segctor_scan_file+0xa5/0x19e
[nilfs2] SS:ESP 0068:f15c6d78
[ 1429.034285] ---[ end trace 0ea06b01ef382693 ]---

Thanks a lot again,
Andrea
