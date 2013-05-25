From: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Subject: Re: Broken nilfs2 filesystem
Date: Sat, 25 May 2013 18:26:21 +0200
Message-ID: <51A0E62D.5060600@antoneliasson.se>
References: <519D2B96.9000106@antoneliasson.se> <1369291449.2673.15.camel@slavad-ubuntu> <51A0A7A0.6010207@antoneliasson.se>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51A0A7A0.6010207-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Anton Eliasson skrev 2013-05-25 13:59:
[...]
>>> ~20:00
>>> ======
>>> When I came back, bup hade frozen (/var/log/messages at 18:53:31).[1] I
>>> restart X by pressing Alt+SysRq+K (/var/log/messages at 20:06:33) and
>>> return to the login screen. The system freezes during login though,
>>> probably because /home had probably been mounted read only). So I reboot
>>> using Alt+SysRq+REISUB (/var/log/messages at 20:07:05). I noticed some
>>> I/O errors during shutdown.
>>>
>>> After the reboot there are no immediate signs of disaster. I launch bup
>>> again. Some time later, /home remounts as read only. I notice that bup
>>> has reported I/O errors while reading some files in /home.[2] dmesg and
>>> /var/log/kern.log contains errors mentioning "bad btree node" and
>>> "nilfs_bmap_lookup_contig: broken bmap".[3]
>>>
>> Now we have patch for overcome the freezing of system after such issue:
>> http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01614.html.
> That is good. I shall await the next release with great anticipation.
I don't think the bug described in the patch you linked to is 
responsible for my crashes. Check this out:

May 25 17:15:12 riven kernel: [ 1165.629786] /dev/vmnet: port on hub 0 
successfully opened
May 25 17:15:15 riven kernel: [ 1168.871258] /dev/vmnet: open called by 
PID 2073 (vmx-vcpu-0)
May 25 17:15:15 riven kernel: [ 1168.871281] /dev/vmnet: port on hub 0 
successfully opened
May 25 17:15:34 riven kernel: [ 1187.572676] /dev/vmnet: open called by 
PID 2075 (vmx-vcpu-1)
May 25 17:15:34 riven kernel: [ 1187.572693] /dev/vmnet: port on hub 0 
successfully opened
May 25 17:15:38 riven kernel: [ 1192.188770] BUG: unable to handle 
kernel NULL pointer dereference at 0000000000000b95
May 25 17:15:38 riven kernel: [ 1192.188781] IP: [<ffffffffa03021a2>] 
nilfs_end_page_io+0x12/0xc0 [nilfs2]
May 25 17:15:38 riven kernel: [ 1192.188798] PGD 1982f8067 PUD 198e2b067 
PMD 0
May 25 17:15:38 riven kernel: [ 1192.188803] Oops: 0000 [#1] PREEMPT SMP
May 25 17:15:38 riven kernel: [ 1192.188809] Modules linked in: nfsv3 
nfs_acl vmnet(O) ppdev parport_pc parport fuse vsock vmci(O) vmmon(O) 
ext4 crc16 mbcache jbd2 nvidia(PO) gpio_ich iTCO_wdt iTCO_vendor_support 
coretemp kvm_intel kvm snd_hda_codec_realtek pcspkr psmouse microcode 
serio_raw i2c_i801 snd_hda_intel lpc_ich snd_hda_codec drm evdev r8169 
snd_hwdep snd_pcm i2c_core snd_page_alloc mii acpi_cpufreq snd_timer 
intel_agp mperf intel_gtt snd soundcore button processor loop nfs lockd 
sunrpc fscache nilfs2 dm_mod sd_mod sr_mod cdrom ata_generic pata_acpi 
hid_generic usbhid hid ahci libahci pata_it8213 libata firewire_ohci 
scsi_mod firewire_core crc_itu_t ehci_pci uhci_hcd ehci_hcd usbcore 
usb_common
May 25 17:15:38 riven kernel: [ 1192.188877] CPU 1
May 25 17:15:38 riven kernel: [ 1192.188883] Pid: 262, comm: 
nilfs_cleanerd Tainted: P           O 3.9.3-1-ARCH #1 Gigabyte 
Technology Co., Ltd. EP45-DS4/EP45-DS4
May 25 17:15:38 riven kernel: [ 1192.188888] RIP: 
0010:[<ffffffffa03021a2>]  [<ffffffffa03021a2>] 
nilfs_end_page_io+0x12/0xc0 [nilfs2]
May 25 17:15:38 riven kernel: [ 1192.188897] RSP: 0018:ffff880195afdb30 
  EFLAGS: 00010206
May 25 17:15:38 riven kernel: [ 1192.188900] RAX: ffff8801a25e7d48 RBX: 
0000000000000b95 RCX: 0000000000000034
May 25 17:15:38 riven kernel: [ 1192.188903] RDX: 000000000000000d RSI: 
0000000000000000 RDI: 0000000000000b95
May 25 17:15:38 riven kernel: [ 1192.188906] RBP: ffff880195afdb38 R08: 
a200000000000000 R09: a800028051000000
May 25 17:15:38 riven kernel: [ 1192.188908] R10: 57ffe77fafa01440 R11: 
0000000000000019 R12: ffff8801988b2648
May 25 17:15:38 riven kernel: [ 1192.188911] R13: ffff8801a25e7d00 R14: 
ffffea00000d04c0 R15: ffffea0000a01180
May 25 17:15:38 riven kernel: [ 1192.188914] FS:  00007f8bf81f3740(0000) 
GS:ffff8801afc80000(0000) knlGS:0000000000000000
May 25 17:15:38 riven kernel: [ 1192.188917] CS:  0010 DS: 0000 ES: 0000 
CR0: 000000008005003b
May 25 17:15:38 riven kernel: [ 1192.188920] CR2: 0000000000000b95 CR3: 
00000001959eb000 CR4: 00000000000007e0
May 25 17:15:38 riven kernel: [ 1192.188923] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
May 25 17:15:38 riven kernel: [ 1192.188925] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
May 25 17:15:38 riven kernel: [ 1192.188928] Process nilfs_cleanerd 
(pid: 262, threadinfo ffff880195afc000, task ffff880195f2c300)
May 25 17:15:38 riven kernel: [ 1192.188930] Stack:
May 25 17:15:38 riven kernel: [ 1192.188932]  ffff8801988b25a0 
ffff880195afdc20 ffffffffa0303ed5 ffffea0002dfb7c0
May 25 17:15:38 riven kernel: [ 1192.188938]  ffff880195f2c300 
ffff880195f2c300 ffff880195f2c300 ffff8801a56b8a70
May 25 17:15:38 riven kernel: [ 1192.188942]  ffff8801a49d0b60 
ffff8801a49d0a00 0000000102dfb7c0 ffff8801a56b8a60
May 25 17:15:38 riven kernel: [ 1192.188947] Call Trace:
May 25 17:15:38 riven kernel: [ 1192.188959]  [<ffffffffa0303ed5>] 
nilfs_segctor_do_construct+0xd65/0x1ab0 [nilfs2]
May 25 17:15:38 riven kernel: [ 1192.188969]  [<ffffffffa0304e42>] 
nilfs_segctor_construct+0x172/0x290 [nilfs2]
May 25 17:15:38 riven kernel: [ 1192.188978]  [<ffffffffa0305ead>] 
nilfs_clean_segments+0xed/0x270 [nilfs2]
May 25 17:15:38 riven kernel: [ 1192.188985]  [<ffffffff811bc4bc>] ? 
__set_page_dirty+0x6c/0xc0
May 25 17:15:38 riven kernel: [ 1192.188994]  [<ffffffffa030c06f>] 
nilfs_ioctl_clean_segments.isra.14+0x4bf/0x740 [nilfs2]
May 25 17:15:38 riven kernel: [ 1192.189003]  [<ffffffffa02fca8d>] ? 
nilfs_btree_lookup+0x4d/0x70 [nilfs2]
May 25 17:15:38 riven kernel: [ 1192.189012]  [<ffffffffa030c70c>] 
nilfs_ioctl+0x21c/0x740 [nilfs2]
May 25 17:15:38 riven kernel: [ 1192.189018]  [<ffffffff8119cf65>] 
do_vfs_ioctl+0x2e5/0x4d0
May 25 17:15:38 riven kernel: [ 1192.189025]  [<ffffffff81152930>] ? 
do_munmap+0x2b0/0x3e0
May 25 17:15:38 riven kernel: [ 1192.189029]  [<ffffffff8119d1d1>] 
sys_ioctl+0x81/0xa0
May 25 17:15:38 riven kernel: [ 1192.189036]  [<ffffffff814d3769>] ? 
do_device_not_available+0x19/0x20
May 25 17:15:38 riven kernel: [ 1192.189042]  [<ffffffff814d9e9d>] 
system_call_fastpath+0x1a/0x1f
May 25 17:15:38 riven kernel: [ 1192.189044] Code: ff ff ff 48 81 c4 88 
00 00 00 5b 41 5c 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 
48 85 ff 48 89 e5 53 48 89 fb 74 4e <48> 8b 07 f6 c4 08 0f 84 8c 00 00 
00 48 8b 47 30 48 8b 00 f6 c4
May 25 17:15:38 riven kernel: [ 1192.189089] RIP  [<ffffffffa03021a2>] 
nilfs_end_page_io+0x12/0xc0 [nilfs2]
May 25 17:15:38 riven kernel: [ 1192.189098]  RSP <ffff880195afdb30>
May 25 17:15:38 riven kernel: [ 1192.189100] CR2: 0000000000000b95
May 25 17:15:38 riven kernel: [ 1192.189104] ---[ end trace 
0c7496171e3b9dfd ]---
May 25 18:03:02 riven kernel: [    0.000000] Initializing cgroup subsys 
cpuset
May 25 18:03:02 riven kernel: [    0.000000] Initializing cgroup subsys cpu
May 25 18:03:02 riven kernel: [    0.000000] Linux version 3.9.3-1-ARCH 
(tobias@T-POWA-LX) (gcc version 4.8.0 20130502 (prerelease) (GCC) ) #1 
SMP PREEMPT Sun May 19 22:50:29 CEST 2013
May 25 18:03:02 riven kernel: [    0.000000] Command line: 
BOOT_IMAGE=/boot/vmlinuz-linux root=/dev/mapper/riven-arch ro quiet

No remounts, just a kernel oops. I can reproduce this without fail by 
booting a VMware Workstation (9.0.2) virtual machine that resides on the 
nilfs /home volume while another virtual machine is doing something 
IO-intensive.

More specifically, I have a virtual machine running Windows XP in /home, 
a nilfs filesystem, and a virtual machine running Windows 7 in 
/Supplement. /Supplement is an ext4 volume in the same LVM volume group 
as /home on the same slow hard drive. I can crash the host by either:

* Starting both machines at the same time.
* Starting the W7 machine first and when it is fully booted to the 
desktop, but still doing I/O intensive Windows stuff, starting the WXP 
machine.

If I first start the WXP machine and let it boot to the desktop, at the 
point where it is actually I/O idle, I can safely start the W7 machine. 
After that I found no trouble installing software updates and logging in 
and out of both machines at the same time, though the HDD made it very 
slow of course.

After the host had crashed, I could still list and read files in /home 
but as soon as I attempted to `touch` a file, that terminal froze. Any 
terminal that attempted to read a file after that point froze as well 
and there was nothing left to do but to Alt+SysRq+B.

-- 
Best Regards,
Anton Eliasson
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
