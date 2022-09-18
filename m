From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Subject: Re: [syzbot] BUG: unable to handle kernel paging request in
 kernfs_put_active
Date: Sun, 18 Sep 2022 15:26:52 +0900
Message-ID: <f3b88739-148c-323c-2458-4b9d6bf9c592@I-love.SAKURA.ne.jp>
References: <00000000000095339805e8d6958e@google.com>
 <de81bf82-3ddf-4875-381d-e52949046b25@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <de81bf82-3ddf-4875-381d-e52949046b25-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: syzbot <syzbot+258ad6d2cb6685e145bc-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org

On 2022/09/18 0:50, Tetsuo Handa wrote:
> I don't know whether crafted filesystem image is used is relevant to this problem.
> But I think a bug is inside NILFS2 filesystem code.

I confirmed that use of crafted filesystem image is irrelevant to this problem.
You can reproduce this problem using fault injection patch

----------
diff --git a/fs/inode.c b/fs/inode.c
index ba1de23c13c1..dfde0cadd51e 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -192,6 +192,10 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_wb_frn_history = 0;
 #endif
 
+	if (!strcmp(current->comm, "my_touch")) {
+		inode->i_security = NULL;
+		goto out;
+	}
 	if (security_inode_alloc(inode))
 		goto out;
 	spin_lock_init(&inode->i_lock);
----------

and script which uses freshly created clean filesystem image.

----------
cp -p /bin/touch my_touch
dd if=/dev/zero of=nilfs.img bs=134221824 count=1
mkfs.nilfs2 nilfs.img
while date; do mount -o loop -t nilfs2 nilfs.img /mnt/; ./my_touch /mnt/file; umount -d /mnt/; done
----------

For your information, use of loop module is also irrelevant to this problem.
Since this is a memory corruption, oops happens at random location.

----------
root@fuzz:~/linux# fdisk -l /dev/sdb
Disk /dev/sdb: 129 MiB, 135266304 bytes, 264192 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
root@fuzz:~# mkfs.nilfs2 /dev/sdb
mkfs.nilfs2 (nilfs-utils 2.2.8)
Start writing file system initial data to the device
       Blocksize:4096  Device:/dev/sdb  Device Size:135266304
File system initialization succeeded !!
root@fuzz:~# while date; do mount -t nilfs2 /dev/sdb /mnt/; ./my_touch /mnt/file; umount /mnt/; done
----------

----------
[  298.082977][ T4437] NILFS (sdb): segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
[  299.544397][ T4447] NILFS (sdb): segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
[  300.927033][ T4457] NILFS (sdb): segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
[  302.264135][ T4467] NILFS (sdb): segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
[  302.321643][ T4471] ------------[ cut here ]------------
[  302.322713][ T4471] kernel BUG at arch/x86/mm/physaddr.c:23!
[  302.324231][ T4471] invalid opcode: 0000 [#1] PREEMPT SMP
[  302.325534][ T4471] CPU: 1 PID: 4471 Comm: my_touch Not tainted 6.0.0-rc5-00094-ga335366bad13-dirty #855
[  302.327840][ T4471] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  302.329932][ T4471] RIP: 0010:__phys_addr+0xe5/0xf0
[  302.331203][ T4471] Code: d5 27 00 48 c7 c7 80 38 50 86 4c 89 fe 4c 89 f2 e8 40 47 68 01 eb 9a e8 e9 d4 27 00 0f 0b e8 e2 d4 27 00 0f 0b e8 db d4 27 00 <0f> 0b 66 0f 1f 84 00 00 00 00 00 53 48 89 fb e8 c7 d4 27 00 48 81
[  302.335926][ T4471] RSP: 0018:ffffc90003a97ac0 EFLAGS: 00010293
[  302.337401][ T4471] RAX: ffffffff811b9035 RBX: 000000007fffffff RCX: ffff888106ee0000
[  302.339356][ T4471] RDX: 0000000000000000 RSI: 000000007fffffff RDI: 000000001fffffff
[  302.341314][ T4471] RBP: ffffffffffffffff R08: ffffffff811b8ff9 R09: 0000000000000c40
[  302.343242][ T4471] R10: ffffffff816d23a0 R11: ffff888106ee0000 R12: ffff888012c26000
[  302.345201][ T4471] R13: 0000000000000041 R14: ffff888011d10158 R15: 000000007fffffff
[  302.347107][ T4471] FS:  00007f50cbe78740(0000) GS:ffff888121a00000(0000) knlGS:0000000000000000
[  302.349316][ T4471] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  302.351011][ T4471] CR2: 00007f50cbd08b60 CR3: 0000000011ad4000 CR4: 00000000000506e0
[  302.353031][ T4471] Call Trace:
[  302.353868][ T4471]  <TASK>
[  302.354587][ T4471]  kfree+0x47/0x2b0
[  302.355528][ T4471]  ? nilfs_mdt_destroy+0x1c/0x30
[  302.356787][ T4471]  ? trace_kmem_cache_alloc+0x2d/0xe0
[  302.358140][ T4471]  nilfs_mdt_destroy+0x1c/0x30
[  302.359368][ T4471]  nilfs_free_inode+0x20/0x40
[  302.360466][ T4471]  ? nilfs_setup_super+0x210/0x210
[  302.361763][ T4471]  alloc_inode+0xc1/0xe0
[  302.362851][ T4471]  new_inode+0x1e/0xd0
[  302.364096][ T4471]  nilfs_new_inode+0x37/0x340
[  302.365349][ T4471]  nilfs_create+0x5a/0x150
[  302.366621][ T4471]  ? nilfs_lookup+0x90/0x90
[  302.367875][ T4471]  path_openat+0x8d4/0x1510
[  302.372812][ T4471]  do_filp_open+0xb9/0x1a0
[  302.374131][ T4471]  ? alloc_fd+0x2de/0x320
[  302.375151][ T4471]  ? do_raw_spin_unlock+0x64/0x2b0
[  302.376581][ T4471]  ? _raw_spin_unlock+0x24/0x40
[  302.377904][ T4471]  do_sys_openat2+0x9b/0x240
[  302.392326][ T4471]  __x64_sys_openat+0xcb/0xf0
[  302.406515][ T4471]  do_syscall_64+0x3d/0x90
[  302.420310][ T4471]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  302.432032][ T4471] RIP: 0033:0x7f50cbd146eb
[  302.445517][ T4471] Code: 25 00 00 41 00 3d 00 00 41 00 74 4b 64 8b 04 25 18 00 00 00 85 c0 75 67 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 0f 87 91 00 00 00 48 8b 54 24 28 64 48 2b 14 25
[  302.475988][ T4471] RSP: 002b:00007ffea2dd8af0 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
[  302.491286][ T4471] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f50cbd146eb
[  302.506272][ T4471] RDX: 0000000000000941 RSI: 00007ffea2dd974c RDI: 00000000ffffff9c
[  302.516526][ T4471] RBP: 00007ffea2dd974c R08: 0000000000000001 R09: 0000000000000000
[  302.532010][ T4471] R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000941
[  302.547302][ T4471] R13: 0000000000000002 R14: 00007f50cbebf2e0 R15: 00007ffea2dd8de8
[  302.562739][ T4471]  </TASK>
[  302.576503][ T4471] Modules linked in:
[  302.590802][ T4471] ---[ end trace 0000000000000000 ]---
[  302.607760][ T4471] RIP: 0010:__phys_addr+0xe5/0xf0
[  302.622428][ T4471] Code: d5 27 00 48 c7 c7 80 38 50 86 4c 89 fe 4c 89 f2 e8 40 47 68 01 eb 9a e8 e9 d4 27 00 0f 0b e8 e2 d4 27 00 0f 0b e8 db d4 27 00 <0f> 0b 66 0f 1f 84 00 00 00 00 00 53 48 89 fb e8 c7 d4 27 00 48 81
[  302.653011][ T4471] RSP: 0018:ffffc90003a97ac0 EFLAGS: 00010293
[  302.667464][ T4471] RAX: ffffffff811b9035 RBX: 000000007fffffff RCX: ffff888106ee0000
[  302.682257][ T4471] RDX: 0000000000000000 RSI: 000000007fffffff RDI: 000000001fffffff
[  302.696817][ T4471] RBP: ffffffffffffffff R08: ffffffff811b8ff9 R09: 0000000000000c40
[  302.711387][ T4471] R10: ffffffff816d23a0 R11: ffff888106ee0000 R12: ffff888012c26000
[  302.725838][ T4471] R13: 0000000000000041 R14: ffff888011d10158 R15: 000000007fffffff
[  302.740693][ T4471] FS:  00007f50cbe78740(0000) GS:ffff888121a00000(0000) knlGS:0000000000000000
[  302.755595][ T4471] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  302.770509][ T4471] CR2: 00007f50cbd08b60 CR3: 0000000011ad4000 CR4: 00000000000506e0
[  302.784918][ T4471] Kernel panic - not syncing: Fatal exception
[  302.799730][ T4471] Kernel Offset: disabled
[  302.813206][ T4471] Rebooting in 10 seconds..
----------

----------
[  506.599768][ T9545] NILFS (sdb): segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
[  508.025268][ T9555] NILFS (sdb): segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
[  509.390901][ T9565] NILFS (sdb): segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
[  510.763935][ T9575] NILFS (sdb): segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
[  512.169897][ T9585] NILFS (sdb): segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
[  513.548042][ T9595] NILFS (sdb): segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
[  514.910318][ T9605] NILFS (sdb): segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
[  516.279080][ T9614] BUG: kernel NULL pointer dereference, address: 00000000000001a8
[  516.294944][ T9614] #PF: supervisor read access in kernel mode
[  516.310648][ T9614] #PF: error_code(0x0000) - not-present page
[  516.326186][ T9614] PGD 8a8c9067 P4D 8a8c9067 PUD 88e9c067 PMD 0 
[  516.341907][ T9614] Oops: 0000 [#1] PREEMPT SMP
[  516.356456][ T9614] CPU: 1 PID: 9614 Comm: mount.nilfs2 Not tainted 6.0.0-rc5-00094-ga335366bad13-dirty #855
[  516.372406][ T9614] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  516.383284][ T9614] RIP: 0010:nilfs_attach_log_writer+0x2b2/0x440
[  516.397928][ T9614] Code: 35 ff 48 85 db 74 0f e8 cc b0 35 ff 49 89 9c 24 b8 02 00 00 eb 05 e8 bd b0 35 ff 4d 89 a5 28 02 00 00 49 8b 45 18 48 8b 58 30 <48> 83 bb a8 01 00 00 00 74 07 e8 9f b0 35 ff eb 16 e8 98 b0 35 ff
[  516.429611][ T9614] RSP: 0018:ffffc900112dfc98 EFLAGS: 00010293
[  516.445173][ T9614] RAX: ffffffff89de8e38 RBX: 0000000000000000 RCX: ffff88800ba43900
[  516.461654][ T9614] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[  516.478266][ T9614] RBP: ffff8881035f3000 R08: ffffffff820db43a R09: 0000000000000000
[  516.494788][ T9614] R10: ffffffff82759b34 R11: ffff88800ba43900 R12: ffff88810544b000
[  516.511110][ T9614] R13: ffff8881035f3000 R14: ffff88810d501d00 R15: ffff8881035f3000
[  516.528123][ T9614] FS:  00007f6749ad1800(0000) GS:ffff888121a00000(0000) knlGS:0000000000000000
[  516.545496][ T9614] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  516.562052][ T9614] CR2: 00000000000001a8 CR3: 00000000802b2000 CR4: 00000000000506e0
[  516.579321][ T9614] Call Trace:
[  516.595390][ T9614]  <TASK>
[  516.611067][ T9614]  ? nilfs_attach_checkpoint+0x172/0x1c0
[  516.627444][ T9614]  nilfs_fill_super+0x19d/0x2c0
[  516.643529][ T9614]  nilfs_mount+0x387/0x590
[  516.659363][ T9614]  ? trace_kmalloc+0x2d/0xe0
[  516.675432][ T9614]  ? kfree+0x35/0x2b0
[  516.691383][ T9614]  ? aa_get_newest_label+0x6b/0x350
[  516.709097][ T9614]  legacy_get_tree+0x2c/0x70
[  516.724981][ T9614]  vfs_get_tree+0x2f/0x110
[  516.740205][ T9614]  do_new_mount+0x1dd/0x560
[  516.754968][ T9614]  __se_sys_mount+0x286/0x2e0
[  516.769748][ T9614]  ? syscall_enter_from_user_mode+0x2e/0x1d0
[  516.784000][ T9614]  do_syscall_64+0x3d/0x90
[  516.798686][ T9614]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  516.818489][ T9614] RIP: 0033:0x7f6749926eae
[  516.835460][ T9614] Code: 48 8b 0d 85 1f 0f 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 52 1f 0f 00 f7 d8 64 89 01 48
[  516.869770][ T9614] RSP: 002b:00007ffd011ea2a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
[  516.886854][ T9614] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6749926eae
[  516.903145][ T9614] RDX: 00000000006a0b40 RSI: 00000000006a0b60 RDI: 00000000006a0b80
[  516.919669][ T9614] RBP: 00000000006a0910 R08: 0000000000000000 R09: 00000000006a4850
[  516.935717][ T9614] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  516.952125][ T9614] R13: 00000000006a0b40 R14: 00000000006a0b80 R15: 00000000006a0910
[  516.968742][ T9614]  </TASK>
[  516.983539][ T9614] Modules linked in:
[  516.998303][ T9614] CR2: 00000000000001a8
[  517.013537][ T9614] ---[ end trace 0000000000000000 ]---
[  517.030306][ T9614] RIP: 0010:nilfs_attach_log_writer+0x2b2/0x440
[  517.045670][ T9614] Code: 35 ff 48 85 db 74 0f e8 cc b0 35 ff 49 89 9c 24 b8 02 00 00 eb 05 e8 bd b0 35 ff 4d 89 a5 28 02 00 00 49 8b 45 18 48 8b 58 30 <48> 83 bb a8 01 00 00 00 74 07 e8 9f b0 35 ff eb 16 e8 98 b0 35 ff
[  517.078650][ T9614] RSP: 0018:ffffc900112dfc98 EFLAGS: 00010293
[  517.094862][ T9614] RAX: ffffffff89de8e38 RBX: 0000000000000000 RCX: ffff88800ba43900
[  517.111291][ T9614] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[  517.123443][ T9614] RBP: ffff8881035f3000 R08: ffffffff820db43a R09: 0000000000000000
[  517.139682][ T9614] R10: ffffffff82759b34 R11: ffff88800ba43900 R12: ffff88810544b000
[  517.157097][ T9614] R13: ffff8881035f3000 R14: ffff88810d501d00 R15: ffff8881035f3000
[  517.175687][ T9614] FS:  00007f6749ad1800(0000) GS:ffff888121a00000(0000) knlGS:0000000000000000
[  517.193810][ T9614] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  517.210835][ T9614] CR2: 00000000000001a8 CR3: 00000000802b2000 CR4: 00000000000506e0
[  517.228628][ T9614] Kernel panic - not syncing: Fatal exception
[  517.245269][ T9614] Kernel Offset: disabled
[  517.261513][ T9614] Rebooting in 10 seconds..
----------

