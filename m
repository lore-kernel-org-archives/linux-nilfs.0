From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: crashing real time kernel
Date: Wed, 14 Apr 2010 17:58:42 +0900 (JST)
Message-ID: <20100414.175842.53861717.ryusuke@osrg.net>
References: <m2vee5afd761004131157q42db24a7p464d2412cec685d7@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <m2vee5afd761004131157q42db24a7p464d2412cec685d7-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,
On Tue, 13 Apr 2010 20:57:38 +0200, Jan de Kruyf <jan.de.kruyf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hallo all of you,
> 
> I need some help here interpreting. I do not read "kernel" very well!
> Last week I set up kernel 2.6.30-5 to be a real time kernel with aid
> of RTAI 3.8 package.
> so since last week I had 2 kernel crashes which both seem to involve
> nilfs in more or less the same way.
> 
> In the first case there was no real time stuff started or running and
> in the second case it was just unloaded.

I recommend you to use 2.6.30.10 or newer 2.6 kernels because nilfs in
the 2.6.30.5 is still buggy.

I think the following bugfix will resolve your problem.

 "nilfs2: fix preempt count underflow in nilfs_btnode_prepare_change_key"

But this patch is not included in 2.6.30.5.

Although the -rtai kernel patch is made against 2.6.30.5, maybe newer
stable kernels (i.e. 2.6.30.y) can be used in place of it.

This is because the stable trees are provided for critical bug fixes
and usually do not include functional changes.


Cheers,
Ryusuke Konishi

> Regards,
> 
> Jan de Kruyf.
> 
> 
> here are the log traces
> 
> Apr 10 00:09:16 debianLenny ntpd[2887]: synchronized to 196.25.1.9, stratum 2
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584373] ------------[ cut
> here ]------------
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584384] WARNING: at
> kernel/sched.c:4917 sub_preempt_count+0x8a/0x90()
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584386] Hardware name: OEM
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584387] Modules linked in:
> i915 drm i2c_algo_bit video output nfsd lockd nfs_acl auth_rpcgss
> sunrpc autofs4 dm_crypt irtty_sir sir_dev irda crc_ccitt
> snd_hda_codec_realtek processor i2c_i801 snd_hda_intel snd_hda_codec
> snd_pcm snd_seq snd_timer snd_seq_device snd intel_agp soundcore
> agpgart snd_page_alloc usbhid r8169 mii floppy thermal [last unloaded:
> scsi_wait_scan]
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584423] Pid: 1661, comm:
> segctord Not tainted 2.6.30.5-rtai #1
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584425] Call Trace:
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584429]  [<c0524dba>] ?
> sub_preempt_count+0x8a/0x90
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584432]  [<c0524dba>] ?
> sub_preempt_count+0x8a/0x90
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584436]  [<c01311bc>]
> warn_slowpath_common+0x6c/0xc0
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584439]  [<c0524dba>] ?
> sub_preempt_count+0x8a/0x90
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584442]  [<c0131225>]
> warn_slowpath_null+0x15/0x20
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584444]  [<c0524dba>]
> sub_preempt_count+0x8a/0x90
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584448]  [<c028ac4d>]
> nilfs_btnode_prepare_change_key+0x12d/0x1a0
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584452]  [<c028c66d>] ?
> nilfs_btree_do_lookup+0x5d/0x210
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584455]  [<c028eba1>]
> nilfs_btree_assign_p+0xc1/0x180
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584458]  [<c028c9e7>]
> nilfs_btree_assign+0xb7/0x110
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584461]  [<c028b1dd>]
> nilfs_bmap_assign+0x3d/0x60
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584465]  [<c02959d4>]
> nilfs_segctor_do_construct+0x6a4/0x2180
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584470]  [<c012638d>] ?
> pick_next_task_fair+0xbd/0xd0
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584474]  [<c051fbae>] ?
> __schedule+0x32e/0x910
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584477]  [<c028b122>] ?
> nilfs_bmap_test_and_clear_dirty+0x32/0x50
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584480]  [<c0289fad>] ?
> nilfs_mdt_fetch_dirty+0x1d/0x60
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584483]  [<c02976c9>]
> nilfs_segctor_construct+0x69/0xa0
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584486]  [<c0298158>]
> nilfs_segctor_thread+0xf8/0x2e0
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584489]  [<c0297d50>] ?
> nilfs_construction_timeout+0x0/0x10
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584493]  [<c0298060>] ?
> nilfs_segctor_thread+0x0/0x2e0
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584496]  [<c01464d6>]
> kthread+0x46/0x80
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584499]  [<c0146490>] ?
> kthread+0x0/0x80
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584502]  [<c0103c0b>]
> kernel_thread_helper+0x7/0x1c
> Apr 10 00:11:54 debianLenny kernel: [ 3889.584504] ---[ end trace
> 5837807bf5f5cca4 ]---
> 
> 
> 
> Apr 13 19:53:42 debianLenny ntpd[2910]: time reset +0.187399 s
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846719] ------------[ cut
> here ]------------
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846729] WARNING: at
> kernel/sched.c:4917 sub_preempt_count+0x8a/0x90()
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846732] Hardware name: OEM
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846733] Modules linked in:
> i915 drm i2c_algo_bit video output nfsd lockd nfs_acl auth_rpcgss
> sunrpc autofs4 dm_crypt irtty_sir sir_dev irda crc_ccitt processor
> snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_seq
> snd_timer snd_seq_device intel_agp agpgart i2c_i801 snd soundcore
> snd_page_alloc usbhid r8169 mii floppy thermal [last unloaded:
> rtai_hal]
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846769] Pid: 1766, comm:
> segctord Not tainted 2.6.30.5-rtai #1
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846771] Call Trace:
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846774]  [<c0524dba>] ?
> sub_preempt_count+0x8a/0x90
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846777]  [<c0524dba>] ?
> sub_preempt_count+0x8a/0x90
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846782]  [<c01311bc>]
> warn_slowpath_common+0x6c/0xc0
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846784]  [<c0524dba>] ?
> sub_preempt_count+0x8a/0x90
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846787]  [<c0131225>]
> warn_slowpath_null+0x15/0x20
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846790]  [<c0524dba>]
> sub_preempt_count+0x8a/0x90
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846794]  [<c028ac4d>]
> nilfs_btnode_prepare_change_key+0x12d/0x1a0
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846798]  [<c028c7bd>] ?
> nilfs_btree_do_lookup+0x1ad/0x210
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846801]  [<c028eba1>]
> nilfs_btree_assign_p+0xc1/0x180
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846804]  [<c028c9e7>]
> nilfs_btree_assign+0xb7/0x110
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846807]  [<c028b1dd>]
> nilfs_bmap_assign+0x3d/0x60
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846811]  [<c02959d4>]
> nilfs_segctor_do_construct+0x6a4/0x2180
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846816]  [<c012638d>] ?
> pick_next_task_fair+0xbd/0xd0
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846819]  [<c051fbae>] ?
> __schedule+0x32e/0x910
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846822]  [<c028b122>] ?
> nilfs_bmap_test_and_clear_dirty+0x32/0x50
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846825]  [<c0289fad>] ?
> nilfs_mdt_fetch_dirty+0x1d/0x60
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846828]  [<c02976c9>]
> nilfs_segctor_construct+0x69/0xa0
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846832]  [<c0298158>]
> nilfs_segctor_thread+0xf8/0x2e0
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846835]  [<c0297d50>] ?
> nilfs_construction_timeout+0x0/0x10
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846838]  [<c0298060>] ?
> nilfs_segctor_thread+0x0/0x2e0
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846842]  [<c01464d6>]
> kthread+0x46/0x80
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846844]  [<c0146490>] ?
> kthread+0x0/0x80
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846848]  [<c0103c0b>]
> kernel_thread_helper+0x7/0x1c
> Apr 13 19:54:09 debianLenny kernel: [ 3842.846850] ---[ end trace
> 5c57d787d4d12946 ]---
> Apr 13 19:54:14 debianLenny ntpd[2910]: synchronized to 67.159.5.90, stratum 2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
