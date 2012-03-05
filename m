From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 00000048
Date: Tue, 06 Mar 2012 00:33:56 +0900 (JST)
Message-ID: <20120306.003356.57456133.ryusuke@osrg.net>
References: <CAMRzUtxbOXWOyZ1wMRmxSsRs67FoDq_hf7Pg_UrAi4P=DnhqsA@mail.gmail.com>
	<20120305.233028.248350005.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120305.233028.248350005.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: slicky.dvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 05 Mar 2012 23:30:28 +0900 (JST), Ryusuke Konishi wrote:
> Hi,
> On Wed, 29 Feb 2012 17:31:18 +0300, Slicky Devil wrote:
> > Hello!
> > 
> > I think I found a bug for you, guys.
> > 
> > The situation was as following. At first, I set up LVM with a single
> > lv (with nilfs) for root. Everything worked fine. Then I decided to
> > create a separate home partition. I shrank the root a bit, created
> > another nilfs logical volume for home. Then I shrank root/expanded
> > home a couple of times. In the end I got the bug, when tried to mount
> > the home.
> > 
> > I'm pretty much confident (say 90%) that I didn't mess things up by
> > shrinking a partition before resizing the appropriate filesystem.
> >
> > Now every time I try to mount home I get the following:
> > 
> > [ 1367.830334] BUG: unable to handle kernel NULL pointer dereference at 00000048
> > [ 1367.831581] IP: [<d0d7a08e>] nilfs_load_super_block+0x17e/0x280 [nilfs2]
> > [ 1367.832098] *pde = 00000000
> > [ 1367.832596] Oops: 0000 [#1] PREEMPT SMP
> > [ 1367.833098] Modules linked in: ext2 mbcache snd_intel8x0 e1000
> > ppdev snd_ac97_codec ac97_bus snd_pcm snd_page_alloc vboxvideo(O)
> > snd_timer drm snd agpgart parport_pc soundcore parport i2c_piix4
> > i2c_core serio_raw psmouse pcspkr evdev joydev processor ac button
> > vboxsf(O) vboxguest(O) nilfs2 dm_mod sr_mod cdrom sd_mod usbhid hid
> > ahci libahci libata ohci_hcd scsi_mod usbcore usb_common
> > [ 1367.833562]
> > [ 1367.833562] Pid: 710, comm: mount.nilfs2 Tainted: G           O
> > 3.2.6-2-ARCH #1 innotek GmbH VirtualBox
> > [ 1367.833562] EIP: 0060:[<d0d7a08e>] EFLAGS: 00010202 CPU: 0
> > [ 1367.833562] EIP is at nilfs_load_super_block+0x17e/0x280 [nilfs2]
> > [ 1367.833562] EAX: c9cb6400 EBX: ce845e00 ECX: 00000000 EDX: 00000000
> > [ 1367.833562] ESI: 00000001 EDI: 00000000 EBP: ca9bbe08 ESP: ca9bbdcc
> > [ 1367.833562]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> > [ 1367.833562] Process mount.nilfs2 (pid: 710, ti=ca9ba000
> > task=cf054d20 task.ti=ca9ba000)
> > [ 1367.833562] Stack:
> > [ 1367.833562]  00000400 ce845e1c 0013f800 00000000 00000000 00000000
> > cc7d6c00 00000400
> > [ 1367.833562]  00000001 00000001 00000001 00000001 ce845e00 ca9bbe30
> > cc7d6c00 ca9bbe40
> > [ 1367.833562]  d0d7a87b ca9bbe30 00000114 000080d0 00000200 00034460
> > cc7d6db0 00000000
> > [ 1367.833562] Call Trace:
> > [ 1367.833562]  [<d0d7a87b>] init_nilfs+0x4b/0x2e0 [nilfs2]
> > [ 1367.833562]  [<d0d6f707>] nilfs_mount+0x447/0x5b0 [nilfs2]
> > [ 1367.833562]  [<c01f33a4>] ? pcpu_alloc+0x714/0x810
> > [ 1367.833562]  [<c02d2add>] ? ida_get_new_above+0x1ad/0x230
> > [ 1367.833562]  [<c02d2add>] ? ida_get_new_above+0x1ad/0x230
> > [ 1367.833562]  [<c0226636>] mount_fs+0x36/0x180
> > [ 1367.833562]  [<c01f34af>] ? __alloc_percpu+0xf/0x20
> > [ 1367.833562]  [<c023d961>] vfs_kern_mount+0x51/0xa0
> > [ 1367.833562]  [<c023ddae>] do_kern_mount+0x3e/0xe0
> > [ 1367.833562]  [<c023f189>] do_mount+0x169/0x700
> > [ 1367.833562]  [<c01eeb29>] ? strndup_user+0x49/0x70
> > [ 1367.833562]  [<c023fa9b>] sys_mount+0x6b/0xa0
> > [ 1367.833562]  [<c04abd1f>] sysenter_do_call+0x12/0x28
> > [ 1367.833562] Code: 53 18 8b 43 20 89 4b 18 8b 4b 24 89 53 1c 89 43
> > 24 89 4b 20 8b 43 20 c7 43 2c 00 00 00 00 23 75 e8 8b 50 68 89 53 28
> > 8b 54 b3 20 <8b> 72 48 8b 7a 4c 8b 55 08 89 b3 84 00 00 00 89 bb 88 00
> > 00 00
> > [ 1367.833562] EIP: [<d0d7a08e>] nilfs_load_super_block+0x17e/0x280
> > [nilfs2] SS:ESP 0068:ca9bbdcc
> > [ 1367.833562] CR2: 0000000000000048
> > [ 1367.855410] ---[ end trace 0b5fed15fa08cff2 ]---
> > 
> > The kernel is the standard archlinux "stocK" kernel run within
> > virtualbox: Linux arch1 3.2.6-2-ARCH #1 SMP PREEMPT Thu Feb 16
> > 10:23:00 UTC 2012 i686 Intel(R) Core(TM) i5 CPU 650 @ 3.20GHz
> > GenuineIntel GNU/Linux
> > 
> > I can provide the partition superblock, if necessary.
> 
> Thank you for reporting this issue.
> 
> I found a bug in the nilfs_load_super_block function which has
> potential to cause this oops.

Here is a further note on the oops.

According to your log, the oops looks to be caused by an access to a
structure member located at the offset of 48 hex bytes from the head
of super block (and the pointer to the super block was NULL).

> BUG: unable to handle kernel NULL pointer dereference at 00000048

The member is 's_last_seq', and its only referrer in
nilfs_load_super_block function is the following line:

    nilfs->ns_prot_seq = le64_to_cpu(sbp[valid[1] & !swp]->s_last_seq);

where sbp[] is the array of pointers to super blocks.


Thus, either valid[1] or swp seemed to be wrong, and my assumption is
valid[1] was not properly set to zero by the following defect.

Ryusuke Konishi

> Could you try the following patch if you still have the partition ?
> 
> 
> Thanks,
> Ryusuke Konishi
> 
> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> index d327140..35a8970 100644
> --- a/fs/nilfs2/the_nilfs.c
> +++ b/fs/nilfs2/the_nilfs.c
> @@ -515,6 +515,7 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
>  		brelse(sbh[1]);
>  		sbh[1] = NULL;
>  		sbp[1] = NULL;
> +		valid[1] = 0;
>  		swp = 0;
>  	}
>  	if (!valid[swp]) {
> -- 
> 1.7.7.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
