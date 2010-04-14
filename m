From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Response to a Write Error
Date: Thu, 15 Apr 2010 01:51:06 +0900 (JST)
Message-ID: <20100415.015106.58888665.ryusuke@osrg.net>
References: <t2kf2d3ba1f1004131638nb61e68cek1ecb43a86c316d35@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <t2kf2d3ba1f1004131638nb61e68cek1ecb43a86c316d35-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: third07-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Tue, 13 Apr 2010 19:38:30 -0400, "Ed F." <third07-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> For several years I have been using rsync with the --link-dest option
> in scripts to make incremental backups using hard links.  I have been
> testing NILFS2 snapshots as an alternative way to do equivalent
> backups.  Some of my experiments have involved writing to a DVD-RAM. I
> am reporting what happened when a DVD-RAM had non-recoverable write
> errors in case that information is of interest to the developers.
> 
> My DVD-RAM was written on a 64-bit Ubuntu Karmic system with a 2.6.31
> kernel.  The NILFS2 module came with that kernel; the NILFS2 utilities
> were built from the head of NILFS2 git repository on April 8, 2010.
> Here are the first syslog messages associated with the write errors:

Thank you for the detail report.

According to the syslog messages, btree of a file or a directory broke
for some reason.  The difference of behavior between nilfs2-module and
the 2.6.31-20 Ubuntu kernel is not a bug.

It's because the latest nilfs2 standalone module includes a backported
patch to handle btree corruption as an error instead of triggering a
kernel BUG.

I have no idea why the corruption occured since the 2.6.31-20 Ubuntu
kernel is almost the same with the 2.6.31.y stable kernel.

I'd appreciate it if you could help to test whether the same problem
arises with nilfs in 2.6.32.y or 2.6.33.y.

The following are the steps to make&install a newer nilfs in the
2.6.31 kernel.

  $ sudo apt-get install linux-headers-`uname -r`
  $ cd /usr/src
  $ wget http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.32.11.tar.bz2
  $ tar jxf linux-2.6.32.11.tar.bz2
  $ cd linux-2.6.32.11/fs/nilfs2
  $ make -C /lib/modules/`uname -r`/build SUBDIRS=$PWD BUILD_DIR=$PWD modules
  $ su
  # rmmod nilfs2
  # mv /lib/modules/`uname -r`/kernel/fs/nilfs2/nilfs2.ko{,.bak}
  # install -m 644 -c nilfs2.ko /lib/modules/`uname -r`/kernel/fs/nilfs2/
  # /sbin/depmod -A
  # mount -t nilfs2 <device> <mount-dir>


As for the write errors, the following two patches may work:

"nilfs2: use GFP_NOIO for bio_alloc instead of GFP_NOWAIT" (merged to v2.6.32)
"nilfs2: do not return io error for bio allocation failure" (merged to v2.6.33)

It's hard to track the cause from the raw block data, so you don't
have to keep the DVD-RAM data.  (dumpseg log for in-use segments is
enough to me)

Thanks,
Ryusuke Konishi 

> Apr 11 20:46:28 x2 kernel: [496491.160053] usb 1-8: reset high speed
> USB device using ehci_hcd and address 5
> Apr 11 20:46:35 x2 kernel: [496497.963699] sr 7:0:0:0: [sr1] Unhandled
> sense code
> Apr 11 20:46:35 x2 kernel: [496497.963708] sr 7:0:0:0: [sr1] Result:
> hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Apr 11 20:46:35 x2 kernel: [496497.963716] sr 7:0:0:0: [sr1] Sense Key
> : Medium Error [current]
> Apr 11 20:46:35 x2 kernel: [496497.963725] sr 7:0:0:0: [sr1] Add.
> Sense: Incomplete block read
> Apr 11 20:46:35 x2 kernel: [496497.963735] end_request: I/O error, dev
> sr1, sector 8778160
> Apr 11 20:46:54 x2 kernel: [496516.494583] sr 7:0:0:0: [sr1] Unhandled
> sense code
> Apr 11 20:46:54 x2 kernel: [496516.494592] sr 7:0:0:0: [sr1] Result:
> hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Apr 11 20:46:54 x2 kernel: [496516.494600] sr 7:0:0:0: [sr1] Sense Key
> : Medium Error [current]
> Apr 11 20:46:54 x2 kernel: [496516.494608] sr 7:0:0:0: [sr1] Add.
> Sense: No defect spare location available
> Apr 11 20:46:54 x2 kernel: [496516.494621] end_request: I/O error, dev
> sr1, sector 8781280
> Apr 11 20:46:54 x2 kernel: [496516.502194] NILFS: IO error writing segment
> Apr 11 20:46:54 x2 kernel: [496516.511162] NILFS warning (device sr1):
> nilfs_clean_segments: segment construction failed. (err=-5)
> 
> When I detected the errors, I shut down the system and waited until
> the following morning to investigate.  When I tried to examine the
> files on the DVD-RAM to see which ones were corrupted, the following
> error was generated:
> 
> Apr 12 10:50:42 x2 kernel: [507977.110489] ------------[ cut here ]------------
> Apr 12 10:50:42 x2 kernel: [507977.110502] kernel BUG at
> /build/buildd/linux-2.6.31/fs/nilfs2/btree.c:514!
> Apr 12 10:50:42 x2 kernel: [507977.110509] invalid opcode: 0000 [#1] SMP
> Apr 12 10:50:42 x2 kernel: [507977.110516] last sysfs file:
> /sys/devices/pci0000:00/0000:00:02.1/usb1/1-1/idVendor
> Apr 12 10:50:42 x2 kernel: [507977.110521] CPU 1
> Apr 12 10:50:42 x2 kernel: [507977.110526] Modules linked in:
> usb_storage udf crc_itu_t nilfs2 binfmt_misc snd_hda_codec_idt ppdev
> snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss
> snd_pcm iptable_filter snd_seq_dummy ip_tables x_tables snd_seq_oss
> snd_seq_midi parport_pc nvidia(P) psmouse serio_raw snd_rawmidi
> snd_seq_midi_event snd_seq snd_timer snd_seq_device snd amd64_edac_mod
> i2c_nforce2 edac_core soundcore snd_page_alloc k8temp lp parport
> floppy 8139too mii
> Apr 12 10:50:42 x2 kernel: [507977.110589] Pid: 24330, comm: rsync
> Tainted: P        W  2.6.31-20-generic #57-Ubuntu NFORCE6M-A
> Apr 12 10:50:42 x2 kernel: [507977.110595] RIP:
> 0010:[<ffffffffa0b8d6a1>]  [<ffffffffa0b8d6a1>]
> nilfs_btree_do_lookup+0x291/0x2a0 [nilfs2]
> Apr 12 10:50:42 x2 kernel: [507977.110631] RSP: 0018:ffff88008900f748
> EFLAGS: 00010293
> Apr 12 10:50:42 x2 kernel: [507977.110635] RAX: 000000000000003d RBX:
> ffff880086949c80 RCX: 0000000000000000
> Apr 12 10:50:42 x2 kernel: [507977.110641] RDX: 0000000000000000 RSI:
> ffff88008900f6a8 RDI: ffff88002800cb20
> Apr 12 10:50:42 x2 kernel: [507977.110646] RBP: ffff88008900f7b8 R08:
> 0000000000000001 R09: 0001ce00a2bfa0a0
> Apr 12 10:50:42 x2 kernel: [507977.110651] R10: 00000000ffffffff R11:
> 0000000000000000 R12: ffff8800731ff000
> Apr 12 10:50:42 x2 kernel: [507977.110656] R13: 0000000000000001 R14:
> ffff8800ba8ace98 R15: 0000000000000000
> Apr 12 10:50:42 x2 kernel: [507977.110663] FS:  00007f82523ed6f0(0000)
> GS:ffff88002803d000(0000) knlGS:0000000000000000
> Apr 12 10:50:42 x2 kernel: [507977.110668] CS:  0010 DS: 0000 ES: 0000
> CR0: 0000000080050033
> Apr 12 10:50:42 x2 kernel: [507977.110673] CR2: 0000000001ab6ff0 CR3:
> 00000000196c1000 CR4: 00000000000006e0
> Apr 12 10:50:42 x2 kernel: [507977.110679] DR0: 0000000000000000 DR1:
> 0000000000000000 DR2: 0000000000000000
> Apr 12 10:50:42 x2 kernel: [507977.110684] DR3: 0000000000000000 DR6:
> 00000000ffff0ff0 DR7: 0000000000000400
> Apr 12 10:50:42 x2 kernel: [507977.110690] Process rsync (pid: 24330,
> threadinfo ffff88008900e000, task ffff88010d82c410)
> Apr 12 10:50:42 x2 kernel: [507977.110695] Stack:
> Apr 12 10:50:42 x2 kernel: [507977.110697]  ffff880000000001
> 0000000100000001 ffff880086949c00 000000018900f830
> Apr 12 10:50:42 x2 kernel: [507977.110705] <0> ffff88008900f810
> 0000000000000000 ffff88008900f7a8 00000000a0b8dd90
> Apr 12 10:50:42 x2 kernel: [507977.110714] <0> 0000000000000001
> ffff8800ba8ace98 ffff880086949c00 0000000000000000
> Apr 12 10:50:42 x2 kernel: [507977.110724] Call Trace:
> Apr 12 10:50:42 x2 kernel: [507977.110746]  [<ffffffffa0b8ddc5>]
> nilfs_btree_lookup_contig+0x65/0x330 [nilfs2]
> Apr 12 10:50:42 x2 kernel: [507977.110760]  [<ffffffff8152cea0>] ?
> _spin_lock_irq+0x10/0x20
> Apr 12 10:50:42 x2 kernel: [507977.110778]  [<ffffffffa0b8b6a8>]
> nilfs_bmap_lookup_contig+0x48/0x70 [nilfs2]
> Apr 12 10:50:42 x2 kernel: [507977.110795]  [<ffffffffa0b83ff0>]
> nilfs_get_block+0xb0/0x250 [nilfs2]
> Apr 12 10:50:42 x2 kernel: [507977.110803]  [<ffffffff8152cf59>] ?
> _spin_lock+0x9/0x10
> Apr 12 10:50:42 x2 kernel: [507977.110814]  [<ffffffff8114f088>]
> do_mpage_readpage+0x148/0x600
> Apr 12 10:50:42 x2 kernel: [507977.110830]  [<ffffffffa0b83200>] ?
> nilfs_readpage+0x0/0x20 [nilfs2]
> Apr 12 10:50:42 x2 kernel: [507977.110837]  [<ffffffff8114f58a>]
> mpage_readpage+0x4a/0x60
> Apr 12 10:50:42 x2 kernel: [507977.110853]  [<ffffffffa0b83f40>] ?
> nilfs_get_block+0x0/0x250 [nilfs2]
> Apr 12 10:50:42 x2 kernel: [507977.110864]  [<ffffffff810f1b65>] ?
> __inc_zone_page_state+0x25/0x30
> Apr 12 10:50:42 x2 kernel: [507977.110872]  [<ffffffff810daa51>] ?
> add_to_page_cache_locked+0xd1/0x130
> Apr 12 10:50:42 x2 kernel: [507977.110888]  [<ffffffffa0b83200>] ?
> nilfs_readpage+0x0/0x20 [nilfs2]
> Apr 12 10:50:42 x2 kernel: [507977.110894]  [<ffffffff810daaf6>] ?
> add_to_page_cache_lru+0x46/0x70
> Apr 12 10:50:42 x2 kernel: [507977.110910]  [<ffffffffa0b83213>]
> nilfs_readpage+0x13/0x20 [nilfs2]
> Apr 12 10:50:42 x2 kernel: [507977.110917]  [<ffffffff810dab99>]
> __read_cache_page+0x79/0xe0
> Apr 12 10:50:42 x2 kernel: [507977.110932]  [<ffffffffa0b83200>] ?
> nilfs_readpage+0x0/0x20 [nilfs2]
> Apr 12 10:50:42 x2 kernel: [507977.110940]  [<ffffffff810dc071>]
> read_cache_page_async+0x31/0xe0
> Apr 12 10:50:42 x2 kernel: [507977.110946]  [<ffffffff810dc12d>]
> read_cache_page+0xd/0x60
> Apr 12 10:50:42 x2 kernel: [507977.110967]  [<ffffffffa0b9c786>] ?
> nilfs_palloc_block_get_entry+0x26/0x60 [nilfs2]
> Apr 12 10:50:42 x2 kernel: [507977.110983]  [<ffffffffa0b84a3f>]
> nilfs_get_page+0x1f/0x80 [nilfs2]
> Apr 12 10:50:42 x2 kernel: [507977.111000]  [<ffffffffa0b85388>]
> nilfs_find_entry+0x78/0x220 [nilfs2]
> Apr 12 10:50:42 x2 kernel: [507977.111017]  [<ffffffffa0b85544>]
> nilfs_inode_by_name+0x14/0x30 [nilfs2]
> Apr 12 10:50:42 x2 kernel: [507977.111034]  [<ffffffffa0b8761d>]
> nilfs_lookup+0x3d/0x70 [nilfs2]
> Apr 12 10:50:42 x2 kernel: [507977.111043]  [<ffffffff81128b0a>]
> real_lookup+0xda/0x150
> Apr 12 10:50:42 x2 kernel: [507977.111052]  [<ffffffff8112a700>]
> do_lookup+0xb0/0xe0
> Apr 12 10:50:42 x2 kernel: [507977.111059]  [<ffffffff8112b2ad>]
> __link_path_walk+0x6ad/0xdc0
> Apr 12 10:50:42 x2 kernel: [507977.111067]  [<ffffffff8112bba7>]
> path_walk+0x57/0xb0
> Apr 12 10:50:42 x2 kernel: [507977.111075]  [<ffffffff8112bc53>]
> do_path_lookup+0x53/0xa0
> Apr 12 10:50:42 x2 kernel: [507977.111083]  [<ffffffff8112c8f2>]
> user_path_at+0x52/0xa0
> Apr 12 10:50:42 x2 kernel: [507977.111091]  [<ffffffff8152cf59>] ?
> _spin_lock+0x9/0x10
> Apr 12 10:50:42 x2 kernel: [507977.111100]  [<ffffffff81276e35>] ?
> _atomic_dec_and_lock+0x55/0x80
> Apr 12 10:50:42 x2 kernel: [507977.111108]  [<ffffffff811238bf>] ?
> cp_new_stat+0xdf/0xf0
> Apr 12 10:50:42 x2 kernel: [507977.111114]  [<ffffffff81123ac7>]
> vfs_fstatat+0x37/0x70
> Apr 12 10:50:42 x2 kernel: [507977.111121]  [<ffffffff81123b69>]
> vfs_lstat+0x19/0x20
> Apr 12 10:50:42 x2 kernel: [507977.111127]  [<ffffffff81123b8f>]
> sys_newlstat+0x1f/0x50
> Apr 12 10:50:42 x2 kernel: [507977.111138]  [<ffffffff81012042>]
> system_call_fastpath+0x16/0x1b
> Apr 12 10:50:42 x2 kernel: [507977.111142] Code: 40 00 48 8b 4b 50 be
> 01 00 00 00 48 8d 53 10 8b 89 a8 00 00 00 d3 e6 48 63 f6 48 83 ee 10
> 48 c1 fe 04 48 c1 e6 03 e9 02 fe ff ff <0f> 0b eb fe 66 66 2e 0f 1f 84
> 00 00 00 00 00 55 48 89 e5 48 83
> Apr 12 10:50:42 x2 kernel: [507977.111204] RIP  [<ffffffffa0b8d6a1>]
> nilfs_btree_do_lookup+0x291/0x2a0 [nilfs2]
> Apr 12 10:50:42 x2 kernel: [507977.111223]  RSP <ffff88008900f748>
> Apr 12 10:50:42 x2 kernel: [507977.111230] ---[ end trace c49a62030f4c2c2c ]---
> 
> Since I could not determine how to build the latest version of the
> kernel module for the 2.6.31 kernel, I rebooted on a 64-bit Ubuntu
> Hardy system with a 2.6.24 kernel and installed the latest NILFS2
> kernel module and utilities from git repository.  When I accessed the
> DVD-RAM with rsync to see which files were in error, I got the
> following messages in syslog:
> 
> Apr 12 17:15:37 x2 kernel: [  829.444875] Pid: 18374, comm: rsync Not
> tainted 2.6.24-27-generic #1
> Apr 12 17:15:37 x2 kernel: [  829.444879]
> Apr 12 17:15:37 x2 kernel: [  829.444880] Call Trace:
> Apr 12 17:15:37 x2 kernel: [  829.444913]  [<ffffffff8844218f>]
> :nilfs2:nilfs_btree_do_lookup+0x28f/0x2b0
> Apr 12 17:15:37 x2 kernel: [  829.444935]  [<ffffffff88443a57>]
> :nilfs2:nilfs_btree_lookup_contig+0x67/0x330
> Apr 12 17:15:37 x2 kernel: [  829.444946]  [__down_read+0x12/0xb1]
> __down_read+0x12/0xb1
> Apr 12 17:15:37 x2 kernel: [  829.444961]  [<ffffffff884417f7>]
> :nilfs2:nilfs_bmap_lookup_contig+0x47/0x70
> Apr 12 17:15:37 x2 kernel: [  829.444974]  [<ffffffff8843b354>]
> :nilfs2:nilfs_get_block+0xb4/0x250
> Apr 12 17:15:37 x2 kernel: [  829.444990]
> [do_mpage_readpage+0x40b/0x540] do_mpage_readpage+0x40b/0x540
> Apr 12 17:15:37 x2 kernel: [  829.445000]  [<ffffffff8843b2a0>]
> :nilfs2:nilfs_get_block+0x0/0x250
> Apr 12 17:15:37 x2 kernel: [  829.445026]  [<ffffffff8843a1c0>]
> :nilfs2:nilfs_readpage+0x0/0x10
> Apr 12 17:15:37 x2 kernel: [  829.445029]
> [ext3:mpage_readpage+0x4e/0x150] mpage_readpage+0x4e/0x70
> Apr 12 17:15:37 x2 kernel: [  829.445037]  [<ffffffff8843b2a0>]
> :nilfs2:nilfs_get_block+0x0/0x250
> Apr 12 17:15:37 x2 kernel: [  829.445041]  [__alloc_pages+0xaa/0x3f0]
> __alloc_pages+0xaa/0x3f0
> Apr 12 17:15:37 x2 kernel: [  829.445054]  [<ffffffff8843a1c0>]
> :nilfs2:nilfs_readpage+0x0/0x10
> Apr 12 17:15:37 x2 kernel: [  829.445057]
> [add_to_page_cache+0xb9/0xd0] add_to_page_cache+0xb9/0xd0
> Apr 12 17:15:37 x2 kernel: [  829.445063]
> [add_to_page_cache_lru+0x24/0x40] add_to_page_cache_lru+0x24/0x40
> Apr 12 17:15:37 x2 kernel: [  829.445068]
> [read_cache_page_async+0x96/0x150] read_cache_page_async+0x96/0x150
> Apr 12 17:15:37 x2 kernel: [  829.445077]  [read_cache_page+0x6/0x40]
> read_cache_page+0x6/0x40
> Apr 12 17:15:37 x2 kernel: [  829.445086]  [<ffffffff8843b7b8>]
> :nilfs2:nilfs_get_page+0x38/0x270
> Apr 12 17:15:37 x2 kernel: [  829.445091]  [__slab_alloc+0x1bd/0x410]
> __slab_alloc+0x1bd/0x410
> Apr 12 17:15:37 x2 kernel: [  829.445100]  [<ffffffff8843cd72>]
> :nilfs2:nilfs_alloc_inode_common+0x22/0x70
> Apr 12 17:15:37 x2 kernel: [  829.445115]  [<ffffffff8843bd64>]
> :nilfs2:nilfs_find_entry+0x84/0x1c0
> Apr 12 17:15:37 x2 kernel: [  829.445134]  [<ffffffff8843beb1>]
> :nilfs2:nilfs_inode_by_name+0x11/0x30
> Apr 12 17:15:37 x2 kernel: [  829.445146]  [<ffffffff8843ec55>]
> :nilfs2:nilfs_lookup+0x45/0xc0
> Apr 12 17:15:37 x2 kernel: [  829.445153]  [do_lookup+0x1b6/0x250]
> do_lookup+0x1b6/0x250
> Apr 12 17:15:37 x2 kernel: [  829.445165]
> [__link_path_walk+0x74c/0xe90] __link_path_walk+0x74c/0xe90
> Apr 12 17:15:37 x2 kernel: [  829.445180]  [link_path_walk+0x5b/0x100]
> link_path_walk+0x5b/0x100
> Apr 12 17:15:37 x2 kernel: [  829.445202]  [do_path_lookup+0x8a/0x250]
> do_path_lookup+0x8a/0x250
> Apr 12 17:15:37 x2 kernel: [  829.445206]  [getname+0x1a9/0x220]
> getname+0x1a9/0x220
> Apr 12 17:15:37 x2 kernel: [  829.445213]  [__user_walk_fd+0x4b/0x80]
> __user_walk_fd+0x4b/0x80
> Apr 12 17:15:37 x2 kernel: [  829.445220]  [vfs_lstat_fd+0x2c/0x70]
> vfs_lstat_fd+0x2c/0x70
> Apr 12 17:15:37 x2 kernel: [  829.445239]  [sys_newlstat+0x27/0x50]
> sys_newlstat+0x27/0x50
> Apr 12 17:15:37 x2 kernel: [  829.445256]  [system_call+0x7e/0x83]
> system_call+0x7e/0x83
> Apr 12 17:15:37 x2 kernel: [  829.445270]
> Apr 12 17:15:37 x2 kernel: [  829.445271] NILFS: btree level mismatch: 61 != 1
> 
> The utility lssu reported the following segment structure:
> 
>               SEGNUM        DATE     TIME STAT     NBLOCKS
>                    0  ---------- --:--:--  ---           0
>               ...
>                   20  ---------- --:--:--  ---           0
>                   21  2010-04-11 23:23:21  ad-         268
>                   22  ---------- --:--:--  ad-           0
>                   23  ---------- --:--:--  ---           0
>               ...
>                  191  ---------- --:--:--  ---           0
>                  192  2010-04-11 17:18:46  -d-        2048
>                  193  2010-04-11 17:18:47  -d-        2048
>                  194  2010-04-11 17:18:58  -d-        2048
>               ...
>                  533  2010-04-11 20:42:02  -d-        2048
>                  534  2010-04-11 20:42:54  -d-        2048
>                  535  2010-04-11 22:13:18  -d-        2047
>                  536  ---------- --:--:--  ---           0
>                  537  ---------- --:--:--  ---           0
>                  538  ---------- --:--:--  ---           0
>                  539  ---------- --:--:--  ---           0
>                  540  ---------- --:--:--  ---           0
>                  541  ---------- --:--:--  ---           0
>                  542  ---------- --:--:--  ---           0
>                  543  ---------- --:--:--  ---           0
>                  544  ---------- --:--:--  ---           0
>                  545  ---------- --:--:--  ---           0
> 
> The checkpoints on the DVD-RAM included 4 snapshots, each of which was
> associated with a distinct backup that I had copied to build the
> DVD-RAM.  I compared those snapshots with the sample backups from
> which they were constructed and found that a single directory was
> missing from each of the snapshots.  That directory was an old one
> that was unmodified during the period from which I selected the sample
> backups.  I assume that the cleaner was copying that directory when
> the write errors began and that a shared copy of that directory was
> lost in all of snapshots.
> 
> In summary, it appears that the write errors were isolated to a single
> directory.  The errors resulted in a file system that was unusable
> with the NILFS2 kernel module in 2.6.31 but was accessible with the
> latest version of the kernel module when installed in a older kernel
> (2.6.24).  (Is there some way to install a version of the NILFS2
> kernel module from the NILFS2 git repository on a kernel newer than
> 2.6.29?)
> 
> I have not yet reformatted the DVD-RAM.  I will perform additional
> experiments with it if they would be helpful.
> 
> Ed
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
