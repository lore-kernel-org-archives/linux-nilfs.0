From: Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>
Subject: Nilfs panics kernel 2.6.18-194.17 (Centos 5.5) on a umount.
Date: Fri, 23 Mar 2012 11:30:19 -0700
Message-ID: <053D39D3D76C474EB2D2A284AA6BA3181F611E5917@COLOSSEXCH01.starsolutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,
  We are running a built-in nilfs2 kernel module version "2.0.22", (i.e. not a module). Umount.nilfs2 is based on nilfs-utils 2.1.0. Has anybody encountered this kernel panic and worked around it? If not does anybody see any issues in still using our current setup? Btw, on a reboot things came up with no problem. Could this be caused by using a newer version of nilfs-utils with an older version of the kernel module? Any other thoughts/ideas? Thanks.

Here is the kernel stack trace:

Unmounting pipe file systems:
Unmounting file systems:  Force option is ignored (only supported for NFS)------------[ cut here ]------------ kernel BUG at fs/nilfs2/debug.c:442!
invalid opcode: 0000 [#1]
SMP
last sysfs file: /class/net/bond0/bonding/arp_ip_target
Modules linked in: autofs4 hidp l2cap bluetooth sunrpc 8021q bonding ipv6 xfrm_nalgo crypto_api loop dm_mirror dm_multip ath scsi_dh video backlight sbs power_meter hwmon i2c_ec dell_wmi wmi button battery asus_acpi ac parport_pc lp parport sg e1000e i2c_i801 pcspkr serio_raw floppy i2c_core dm_raid45 dm_message dm_region_hash dm_log dm_mod dm_mem_cache usb_s torage ata_piix libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd
CPU:    1

EIP:    0060:[<c04d3e47>]    Not tainted VLI
EFLAGS: 00010246   (2.6.18-194.17.4.el5SSI_NILFS #1)
EIP is at nilfs_page_debug+0x4f1/0x606
eax: c000006d   ebx: 00000006   ecx: c29a5120   edx: c29a5120
esi: 0000002d   edi: 000001a1   ebp: f745fc73   esp: f745fc04
ds: 007b   es: 007b   ss: 0068
Process umount.nilfs2 (pid: 4222, ti=f745f000 task=f7d72000 task.ti=f745f000)
Stack: 00000000 00000000 f75c5ab8 0000005f 45474150 39326320 32313561 6f742030
       616d206f 7020796e 20656761 6e756f63 63203a74 333d746e 646e6920 3d237865
       616d2030 6e697070 20313d67 3d75726c 696e2031 5f73666c 656c6572 70657361 Call Trace:
 [<c045cf86>] get_page_from_freelist+0x96/0x370  [<c045d1af>] get_page_from_freelist+0x2bf/0x370
 [<c045d2c9>] __alloc_pages+0x69/0x2cf
 [<c0464e3f>] __handle_mm_fault+0x690/0xaac  [<c0459530>] do_generic_mapping_read+0x378/0x380
 [<c0472075>] free_block+0xc4/0xe3
 [<c0472075>] free_block+0xc4/0xe3
 [<c045caac>] free_pages_bulk+0x16f/0x1d5  [<c045cd24>] __pagevec_free+0x14/0x1a  [<c04d4157>] nilfs_releasepage+0x109/0x114  [<c04d404e>] nilfs_releasepage+0x0/0x114  [<c047736a>] try_to_release_page+0x34/0x46  [<c04d3859>] nilfs_invalidatepage+0x0/0x31  [<c0476fb5>] do_invalidatepage+0x16/0x18  [<c045fb50>] truncate_complete_page+0x18/0x58  [<c045fc34>] truncate_inode_pages_range+0xa4/0x256
 [<c045fdef>] truncate_inode_pages+0x9/0xe  [<c048cd4c>] dispose_list+0x2c/0xb1  [<c048d01e>] invalidate_inodes+0xa9/0xbe  [<c047bf64>] generic_shutdown_super+0x43/0xd5  [<c047c01a>] kill_block_super+0x24/0x34  [<c047c0c2>] deactivate_super+0x52/0x65  [<c048ff22>] sys_umount+0x1f0/0x218  [<c044bede>] audit_syscall_entry+0x15a/0x18c  [<c048ff55>] sys_oldumount+0xb/0xe  [<c0404f17>] syscall_call+0x7/0xb  =======================
Code: 7d 49 66 c0 29 f0 50 8d 44 35 00 50 e8 33 48 03 00 01 c6 83 c4 10 83 7c 24 08 00 74 6a 8b 8c 24 30 02 00 00 8b 01
f6 c4 08 75 08 <0f> 0b ba 01 86 48 66 c0 8b 94 24 30 02 00 00 8b 42 0c 8b 00 66
EIP: [<c04d3e47>] nilfs_page_debug+0x4f1/0x606 SS:ESP 0068:f745fc04  <0>Kernel panic - not syncing: Fatal exception

Zahid
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
