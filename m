From: Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>
Subject: RE: mount & fsck of nilfs partition fail.
Date: Wed, 13 Jul 2011 17:54:54 -0700
Message-ID: <053D39D3D76C474EB2D2A284AA6BA3181B05F390D2@COLOSSEXCH01.starsolutions.com>
References: <053D39D3D76C474EB2D2A284AA6BA3181B05E9A356@COLOSSEXCH01.starsolutions.com>
	<20110625.012634.121140098.ryusuke@osrg.net>
	<053D39D3D76C474EB2D2A284AA6BA3181B05EE2ED0@COLOSSEXCH01.starsolutions.com>
 <20110706.111615.163244275.ryusuke@osrg.net>
 <053D39D3D76C474EB2D2A284AA6BA3181B05F38A67@COLOSSEXCH01.starsolutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <053D39D3D76C474EB2D2A284AA6BA3181B05F38A67-ZjuI7xOJlFPnaE3xbIMyWkCiaQ3SRT3KFkJ40O1dFu8@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello Ryusuke,
  Under a 4 day test with power cycles in there we encountered a similar problem after a complete backup & restore of the filesystem (used gnu tar). The error codes are similar - I tried adding some of the debug options under /proc, no relevant extra information exists. I also tried upgrading to a newer nilfs-utils (2.0.23 vs. the 2.0.22 that I ran with up till now) - no change in the error messages. The fsck0.nilfs2 does not fix this error. though it states things are okay:

fsck0.nilfs2 /dev/sda2
Super-block:
    revision = 2.0
    blocksize = 4096
    write time = 2011-07-13 17:36:01
    indicated log: blocknr = 2165165
        segnum = 1057, seq = 299785, cno=2206916

Clean FS.
A valid log is pointed to by superblock (No change needed): blocknr = 2165165
    segnum = 1057, seq = 299785, cno=2206916
    creation time = 2011-07-13 17:24:31

the mount gives the following error under 2.0.23:

kernel: segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
kernel: NILFS warning: mounting fs with errors
nilfs_cleanerd[2970]: start
kernel:  [<c04c2fbc>] nilfs_btree_do_lookup+0xa9/0x234
kernel:  [<c04c2fdf>] nilfs_btree_do_lookup+0xcc/0x234
kernel:  [<c04c438c>] nilfs_btree_lookup+0x42/0x7f
kernel:  [<c04c2aa2>] nilfs_bmap_lookup_at_level+0x2b/0x81
kernel:  [<c04c2b11>] nilfs_bmap_lookup+0x19/0x2d
kernel:  [<c04c156a>] nilfs_mdt_submit_block+0x9a/0x131
kernel:  [<c04c163d>] nilfs_mdt_read_block+0x3c/0x1b1
kernel:  [<c04c193a>] nilfs_mdt_get_block+0x2c/0x277
kernel:  [<c04059d7>] apic_timer_interrupt+0x1f/0x24
kernel:  [<c04d1316>] nilfs_palloc_get_entry_block+0x45/0x4c
kernel:  [<c04d13aa>] nilfs_palloc_block_get_entry+0x12/0x41
kernel:  [<c04c69db>] nilfs_dat_get_vinfo+0x46/0x1bf
kernel:  [<c04d2da1>] nilfs_ioctl_do_get_vinfo+0x51/0x60
kernel:  [<c04d20e9>] nilfs_ioctl_wrap_copy+0xdd/0x16b
kernel:  [<c04d21c7>] nilfs_ioctl_get_info+0x50/0x7a
kernel:  [<c04d2d50>] nilfs_ioctl_do_get_vinfo+0x0/0x60
kernel:  [<c04d24d6>] nilfs_ioctl+0x238/0x57d
kernel:  [<c04d2d50>] nilfs_ioctl_do_get_vinfo+0x0/0x60
kernel:  [<c045194a>] delayacct_end+0x58/0x7a
kernel:  [<c045cf86>] get_page_from_freelist+0x96/0x370
kernel:  [<c045d1af>] get_page_from_freelist+0x2bf/0x370
kernel:  [<c045d2c9>] __alloc_pages+0x69/0x2cf
kernel:  [<c0464e3f>] __handle_mm_fault+0x690/0xaac
kernel:  [<c04d229e>] nilfs_ioctl+0x0/0x57d
kernel:  [<c048620d>] do_ioctl+0x1c/0x5d
kernel:  [<c04867a1>] vfs_ioctl+0x47b/0x4d3
kernel:  [<c0637748>] do_page_fault+0x2a4/0x52d
kernel:  [<c0486841>] sys_ioctl+0x48/0x5f
kernel:  [<c0404f17>] syscall_call+0x7/0xb
kernel:  =======================
kernel: NILFS: btree level mismatch: 84 != 1
nilfs_cleanerd[2970]: shutdown

I can mount the filesystem without the cleanerd (-n) as writable, but we do need the gc daemon to clear space on a writable filesystem. Please let me know if there is an easy fix to this problem, otherwise, I guess a backup/restore would let me continue, correct? Also, let me know if you need any more information. Thanks.

Zahid

-----Original Message-----
From: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Zahid Chowdhury
Sent: Friday, July 08, 2011 4:53 PM
To: Ryusuke Konishi
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: mount & fsck of nilfs partition fail.

Hello Ryusuke,
  I have done a backup/restore of the whole nilfs partition. I will let the mailing-list know if we have any more problems on a longrun use test with the new kernel module. Thanks.

Zahid

-----Original Message-----
From: Ryusuke Konishi [mailto:konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org]
Sent: Tuesday, July 05, 2011 7:16 PM
To: Zahid Chowdhury
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: mount & fsck of nilfs partition fail.

Hi Zahid,
On Mon, 4 Jul 2011 17:29:01 -0700, Zahid Chowdhury wrote:
> Hello Ryusuke,
>   On a relatively quiescent system I still encountered a mount failure on a power cycle. The messages in /var/log/messages were:
>
>   kernel: NILFS warning: mounting unchecked fs
>   kernel: NILFS: recovery complete.
>   kernel: segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
>   kernel:  [<c04c2fbc>] nilfs_btree_do_lookup+0xa9/0x234
>   kernel:  [<c04c2fdf>] nilfs_btree_do_lookup+0xcc/0x234
>   kernel:  [<c04c438c>] nilfs_btree_lookup+0x42/0x7f
>   kernel:  [<c04c2aa2>] nilfs_bmap_lookup_at_level+0x2b/0x81
>   kernel:  [<c04c2b11>] nilfs_bmap_lookup+0x19/0x2d
>   kernel:  [<c04c156a>] nilfs_mdt_submit_block+0x9a/0x131
>   kernel:  [<c04c163d>] nilfs_mdt_read_block+0x3c/0x1b1
>   kernel:  [<c04c193a>] nilfs_mdt_get_block+0x2c/0x277
>   kernel:  [<c0477b75>] alloc_page_buffers+0x74/0xba
>   kernel:  [<c04d1316>] nilfs_palloc_get_entry_block+0x45/0x4c
>   kernel:  [<c04c7125>] nilfs_dat_translate+0x3c/0x137
>   kernel:  [<c04c2032>] nilfs_btnode_submit_block+0x1a3/0x29e
>   kernel:  [<c04c2144>] nilfs_btnode_get+0x17/0x5f
>   kernel:  [<c04c2f0f>] nilfs_btree_get_block+0x12/0x16
>   kernel:  [<c04c2fbc>] nilfs_btree_do_lookup+0xa9/0x234
>   kernel:  [<c04c438c>] nilfs_btree_lookup+0x42/0x7f
>   kernel:  [<c04c2aa2>] nilfs_bmap_lookup_at_level+0x2b/0x81
>   kernel:  [<c04c2b11>] nilfs_bmap_lookup+0x19/0x2d
>   kernel:  [<c04c156a>] nilfs_mdt_submit_block+0x9a/0x131
>   kernel:  [<c04c163d>] nilfs_mdt_read_block+0x3c/0x1b1
>   kernel:  [<c04c193a>] nilfs_mdt_get_block+0x2c/0x277
>   kernel:  [<c04d1316>] nilfs_palloc_get_entry_block+0x45/0x4c
>   kernel:  [<c04d0ff3>] nilfs_ifile_get_inode_block+0x57/0x94
>   kernel:  [<c04bcdee>] nilfs_read_inode+0x6a/0x1a6
>   kernel:  [<c04bf7a0>] nilfs_get_sb+0x40f/0x65e
>   kernel:  [<c045d2c9>] __alloc_pages+0x69/0x2cf
>   kernel:  [<c047c152>] vfs_kern_mount+0x7d/0xf2
>   kernel:  [<c047c1f9>] do_kern_mount+0x25/0x36
>   kernel:  [<c048fbee>] do_mount+0x5fb/0x66b
>   kernel:  [<c04589df>] find_get_page+0x18/0x3f
>   kernel:  [<c045b50a>] filemap_nopage+0x19f/0x349
>   kernel:  [<c0464e3f>] __handle_mm_fault+0x690/0xaac
>   kernel:  [<c0484323>] __link_path_walk+0xd29/0xd4b
>   kernel:  [<c045b50a>] filemap_nopage+0x19f/0x349
>   kernel:  [<c06376de>] do_page_fault+0x23a/0x52d
>   kernel:  [<c0637748>] do_page_fault+0x2a4/0x52d
>   kernel:  [<c06374a4>] do_page_fault+0x0/0x52d
>   kernel:  [<c048eb45>] copy_mount_options+0x90/0x109
>   kernel:  [<c048fccb>] sys_mount+0x6d/0xa5
>   kernel:  [<c0404f17>] syscall_call+0x7/0xb
>   kernel:  =======================
>   kernel: NILFS: btree level mismatch: 114 != 1
>   kernel: NILFS error (device sda2): nilfs_ifile_get_inode_block: ifile is broken
>   kernel: Remounting filesystem read-only
>   kernel: NILFS: get root inode failed
>
>
> I ran fsck0.nilfs2:
>   /sbin/fsck0.nilfs2 -v -f /dev/sda2
>   Super-block:
>       revision = 2.0
>       blocksize = 4096
>       write time = 2011-07-02 06:09:20
>       indicated log: blocknr = 2097786
>           segnum = 1024, seq = 2055540, cno=1775795
>
>   Clean FS.
>   The latest log is lost. Trying rollback recovery..
>   .......
>   Selected log: blocknr = 2097655
>       segnum = 1024, seq = 2055540, cno=1775793
>       creation time = 2011-07-02 06:08:13
>   Do you wish to overwrite super block (y/N)? y
>   Recovery will complete on mount.
>
> From then on the mount has worked always, but I get the following error in /var/log/messages always on the mount:
>
>   kernel: segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
>   kernel: NILFS warning: mounting fs with errors
>
> Also:
>   dmesg | grep -i nilfs
>       NILFS nilfs_fill_super: start(silent=0)
>       NILFS(recovery) nilfs_search_super_root: found super root: segnum=251, seq=2062534, pseg_start=514624, pseg_offset=621
>       NILFS warning: mounting fs with errors
>       NILFS nilfs_fill_super: mounted filesystem
>
>   nilfs-tune -l /dev/sda2
>
>      Filesystem state:         invalid or mounted,error
>
> All of the daemons on our system run with no problems with the existing nilfs partition, but the warnings make us wonder. Can we continue using this nilfs2 partition or might we have issues in the future. Thanks for any help.
>
> Zahid

The current nilfs sets an error flag on super blocks once it detected
inconsistency in the filesystem.

The error flag will not be cleared even after fsck0.nilfs2 or
mount-time rollback succeeded.  This is a limitation of the
fsck0.nilfs2 program, so the warning remains irrelevantly with whether
the filesystem has an actual defect. (sorry)

If you can back up the filesystem and restore it for a new nilfs
partition, I would like to ask you to do so.

This is because there was a crucial btree bug in nilfs modules older
than version 2.0.22.  It can be the cause of the above error (even if
you are now using 2.0.22).

To narrow down whether the error came from older nilfs modules or the
2.0.22 module still has a crucial bug, we need longrun use test with a
nilfs partition which has been never mounted by older modules.

Regards,
Ryusuke Konishi

>
> -----Original Message-----
> From: Ryusuke Konishi [mailto:konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org]
> Sent: Friday, June 24, 2011 9:27 AM
> To: Zahid Chowdhury
> Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: mount & fsck of nilfs partition fail.
>
> On Thu, 23 Jun 2011 11:21:03 -0700, Zahid Chowdhury wrote:
> > Hello Ryusuke,
> >   After the new kernel module (2.0.22) the nilfs partition mounted
> >   with no problems. I have encountered no problems since then. Doing
> >   a lssu(1) does not show segment 759 to be on the list of used
> >   segments any further:
> >
> > lssu -a /dev/sda2
> >               SEGNUM        DATE     TIME STAT     NBLOCKS
> >                    0  2011-06-23 10:56:42  -d-        2047
> >                    1  2011-06-23 10:56:42  -d-        2048
> >                    2  2011-06-23 10:56:42  -d-        2048
> >                    3  2011-06-23 10:56:42  -d-        2048
> >                    4  2011-06-23 10:56:44  -d-        2048
> >                    5  2011-06-23 10:56:46  -d-        2048
> >                    7  2011-06-23 10:56:46  -d-        2048
> >                    8  2011-06-23 10:56:47  -d-        2048
> >                    9  2011-06-23 10:56:47  -d-        2048
> >                   10  2011-06-23 10:56:47  -d-        2048
> >                   11  2011-06-23 10:56:47  -d-        2048
> >                   12  2011-06-23 10:56:47  -d-        2048
> >                   13  2011-06-23 10:56:52  -d-        2048
> >                   14  2011-06-23 10:56:52  -d-        2048
> >                   16  2011-06-23 10:56:52  -d-        2048
> >                   17  2011-06-23 10:56:52  -d-        2048
> >                   18  2011-06-23 10:56:52  -d-        2048
> >                   19  2011-06-23 10:56:53  -d-        2048
> p>                   20  2011-06-23 10:56:54  ad-        1273
> >                   21  ---------- --:--:--  ad-           0
> >                  946  2011-06-23 10:52:27  -d-        2048
> >                  947  2011-06-23 10:52:28  -d-        2048
> >                  948  2011-06-23 10:52:28  -d-        2048
> >                  949  2011-06-23 10:52:28  -d-        2048
> >                     .
> >                     .
> >                     .
> > Though dumpseg 759 does not show anything untoward (I don't think its used any further, correct?):
> >
> > dumpseg /dev/sda2 759
> > segment: segnum = 759
> >   sequence number = 608068, next segnum = 760
> >   partial segment: blocknr = 1554432, nblocks = 2048
> >     creation time = 2011-06-23 10:48:02
> >     nfinfo = 652
> >     finfo
> >       ino = 7984, cno = 13, nblocks = 756, ndatblk = 756
> >         vblocknr = 146359, blkoff = 30686, blocknr = 1554444
> >         vblocknr = 146360, blkoff = 30687, blocknr = 1554445
> >             .
> >             .
> >             .
> >     finfo
> >       ino = 16619, cno = 3763620, nblocks = 2, ndatblk = 2
> >         vblocknr = 224656, blkoff = 304, blocknr = 1555200
> >         vblocknr = 224635, blkoff = 305, blocknr = 1555201
> >     finfo
> >       ino = 16619, cno = 3763616, nblocks = 1, ndatblk = 1
> >         vblocknr = 224551, blkoff = 303, blocknr = 1555202
> >             .
> >             .
> >             .
>
> Hmm, the segment looks to be overwritten with new data after the
> partition was successfully mounted.  I don't know if it's certainly
> safe now, but It might be needless fear.
>
> > One other question I have for anybody on the list or Ryusuke, on a
> > corruption of nilfs on older kernels (pre 2.6.30) should I leave
> > fsck0.nilfs2 to run on the initscripts besides the new 2.0.22 kernel
> > module or is this really redundant? Thanks for any
> > help/comments. All, as far as I can see, this is a pretty cool
> > filesystem.
>
> For now, fsck0.nilfs2 is just a manual rollback tool.  There is no
> merit to run it from initscripts since it doesn't verify filesystem
> consistency.  ( Clearly, making a true fsck is one of TODO items. )
>
> As for fsck0.nilfs2, you only have to use it when you couldn't mount
> the partition.  I hope this never happens for the 2.0.22 module.
>
> Thanks for your interest and help.
>
> Regards,
> Ryusuke Konishi
>
>
> > Zahid
> >
> > -----Original Message-----
> > From: Ryusuke Konishi [mailto:konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org]
> > Sent: Thursday, June 23, 2011 4:25 AM
> > To: Zahid Chowdhury
> > Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: mount & fsck of nilfs partition fail.
> >
> > On Mon, 20 Jun 2011 11:27:49 -0700, Zahid Chowdhury wrote:
> > > Hello Ryusuke,
> > >
> > >   Sorry, I was away on the w/e. I've attached the console trace and
> > >   the out file again for posterity. I will be upgrading to the
> > >   recently released 2.0.22 version, and will try to mount the
> > >   corrupted filesystem with it - unlikely, it will work, though it
> > >   should help on future filesystems based on nilfs2? Thanks for the
> > >   fsck help and the new release for older kernels. Please let me
> > >   know if you need anything further, such that I can recover the
> > >   corrupted filesystem.
> > >
> > > Zahid
> > >
> > > The console trace:
> > > /sbin/fsck0.nilfs2 -f -v /dev/sda2
> > > Super-block:
> > >     revision = 2.0
> > >     blocksize = 4096
> > >     write time = 2011-06-11 23:22:03
> > >     indicated log: blocknr = 1648528
> > >         segnum = 804, seq = 401758, cno=3250953
> > >
> > > Unclean FS.
> > > The latest log is lost. Trying rollback recovery..
> > > ......
> > > Searching the latest checkpoint.
> > > get_latest_cno: log_start=1556429 (segnum=759): nfinfo=6, fblocknr=1556430
> > > get_latest_cno: finfo: ino=17874, sum-blocknr=1556429, offset=80, nblocks=2, ndatablk=1, fblocknr=1556430
> > > get_latest_cno: finfo: ino=17875, sum-blocknr=1556429, offset=128, nblocks=1, ndatablk=1, fblocknr=1556432
> > > get_latest_cno: finfo: ino=6, sum-blocknr=1556429, offset=168, nblocks=2, ndatablk=1, fblocknr=1556433
> > > get_latest_cno: finfo: ino=4, sum-blocknr=1556429, offset=216, nblocks=3, ndatablk=2, fblocknr=1556435
> > > get_latest_cno: finfo: ino=4499, sum-blocknr=1556429, offset=280, nblocks=1306282328, ndatablk=0, fblocknr=1556438
> >
> > According to this log, the summary information of segment #759 looks
> > broken.  This may cause future GC failure or filesystem corruption.
> >
> > Could you confirm whether the segment summary is actually broken or
> > not ?  This can be done with dumpseg tool:
> >
> >  # dumpseg /dev/sda2 759
> >
> > If it looks actually broken, I recommend you to back up all data as
> > soon as possible.
> >
> > Regards,
> > Ryusuke Konishi
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
