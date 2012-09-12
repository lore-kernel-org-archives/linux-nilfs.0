From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Corruption in many files/directories in a nilfs partition on
 nilfs-kmod-2.0.21-4 builtin on a Centos 5.5 kernel.
Date: Wed, 12 Sep 2012 09:57:23 +0400
Message-ID: <1347429443.1915.15.camel@slavad-ubuntu-11>
References: <053D39D3D76C474EB2D2A284AA6BA3182F977A73B0@COLOSSEXCH01.starsolutions.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:References:In-Reply-To:Cc:To:From:Subject; bh=byGdqsiZaAu1Vbxj1UIoh42LFofZdoHr5CixOyq61Cg=;
	b=nsOtCzMXvNhoUNq95zMX8OaaGSTOKoCPGCOqMIDGG3CwGCUZKcIbLjsYRkbbw4m2vW8mYIo28Y9DvQC1sNJtT0pEJsCQMNNTBzrMUQNod/blyu4pwd5/6Z5GVpv3gCwI;
In-Reply-To: <053D39D3D76C474EB2D2A284AA6BA3182F977A73B0-ZjuI7xOJlFPnaE3xbIMyWkCiaQ3SRT3KFkJ40O1dFu8@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

On Tue, 2012-09-11 at 16:07 -0700, Zahid Chowdhury wrote:
> Hello,
>   We recently changed our SSD and on a power cycle under load we encountered
> file corruption in many files on the nilfs partition. Some i/o processing
> was occurring when we encountered the file corruption (possibly on a power cycle). I did check the SSD with smart tools and no errors seem to have been logged.
> 
>   Here is the output of dmesg(1) on a mount and a read access of one of the affected files:
> 
>   NILFS nilfs_fill_super: start(silent=0)
>   NILFS warning: mounting unchecked fs
>   NILFS(recovery) nilfs_search_super_root: found super root: segnum=1824, 
>     seq=2164205, pseg_start=3737132, pseg_offset=1613
>   NILFS: recovery complete.
>   segctord starting. Construction interval = 5 seconds, CP frequency < 30 
>     seconds
>   NILFS warning: mounting fs with errors
>   NILFS nilfs_fill_super: mounted filesystem
>   attempt to access beyond end of device
>   sda3: rw=0, want=9331952664445036944, limit=49930020
>   attempt to access beyond end of device
>   sda3: rw=0, want=8178943302301875000, limit=49930020
>   attempt to access beyond end of device
>   sda3: rw=0, want=11216631730677685184, limit=49930020
>   attempt to access beyond end of device
>   sda3: rw=0, want=7566444304283562424, limit=49930020
>   attempt to access beyond end of device
>   sda3: rw=0, want=7161651204113109256, limit=49930020
>   attempt to access beyond end of device
>   sda3: rw=0, want=5463845364605981576, limit=49930020
>   attempt to access beyond end of device
>   sda3: rw=0, want=8888728157704767904, limit=49930020
>   attempt to access beyond end of device
>   sda3: rw=0, want=9331952664445036944, limit=49930020
> 
> The output of nilfs-tune is:
> nilfs-tune -l /dev/sda3
> nilfs-tune 2.1.0
> Filesystem volume name:   /writable
> Filesystem UUID:          11d71018-2c18-42ad-a842-f475e6b1c449
> Filesystem magic number:  0x3434
> Filesystem revision #:    2.0
> Filesystem features:      (none)
> Filesystem state:         invalid or mounted,error
> Filesystem OS type:       Linux
> Block size:               4096
> Filesystem created:       Mon Jul 11 17:21:39 2011
> Last mount time:          Tue Sep 11 10:41:22 2012
> Last write time:          Tue Sep 11 10:41:22 2012

I think that reported issue is a SSD issue. As I can see the NILFS
filesystem was created more than a year ago and was working without any
issues before SSD change. I had similar issue with Samsung HDD. I tried
to use several filesystems (ext4, xfs) under it but have different
filesystems errors and lost many files with important information. I
also checked my disk with smart tools but haven't any reports about some
error, the disk had excellent working state (if it trusts to S.M.A.R.T
report).

An issue with SSD or HDD can generate very different filesystem errors.
So, I am afraid you need to change SSD. Could you try to use SSD of
another vendor?

By the way, do you use NILFS as root filesystem?
What model of SSD do you use?

With the best regards,
Vyacheslav Dubeyko.


> Mount count:              972
> Maximum mount count:      50
> Reserve blocks uid:       0 (user root)
> Reserve blocks gid:       0 (group root)
> First inode:              11
> Inode size:               128
> DAT entry size:           32
> Checkpoint size:          192
> Segment usage size:       16
> Number of segments:       3047
> Device size:              25564170240
> First data block:         1
> # of blocks per segment:  2048
> Reserved segments %:      5
> Last checkpoint #:        2555913
> Last block address:       3737132
> Last sequence #:          2164205
> Free blocks count:        5777408
> Commit interval:          0
> # of blks to create seg:  0
> CRC seed:                 0xb9934a73
> CRC check sum:            0x1f5cb561
> CRC check data size:      0x00000118
> 
> The problem initially appeared a few days ago possibly on the power cycle and it seems as if has been growing. The first error in /var/log/messages (btw, even the messages.1 file was corrupted in the middle) was in this directory which gives I/O error on any readdir of the directory:
> 
>   NILFS error (device sda3): nilfs_check_page: bad entry in directory
>     #10778: rec_len is smaller than minimal - offset=0,
>     inode=733085696, rec_len=0, name_len=193
>   NILFS error (device sda3): nilfs_readdir: bad page in #10778
> 
> Then this same directory later gave the same error and this also later on:
> 
>   NILFS error (device sda3): nilfs_check_page: bad entry in directory
>     #10778: directory entry across blocks - offset=0, inode=1346725220,
>     rec_len=24320, name_len=90
>   NILFS error (device sda3): nilfs_readdir: bad page in #10778
>  [<c04c2fbc>] nilfs_btree_do_lookup+0xa9/0x234
>  [<c04c2fdf>] nilfs_btree_do_lookup+0xcc/0x234
>  [<c04c441d>] nilfs_btree_lookup_contig+0x54/0x349
>  [<f88634d8>] scsi_done+0x0/0x16 [scsi_mod]
>  [<f88df964>] ata_scsi_translate+0x107/0x12c [libata]
>  [<f88634d8>] scsi_done+0x0/0x16 [scsi_mod]
>  [<f88e20ae>] ata_scsi_queuecmd+0x18f/0x1ac [libata]
>  [<f88e20c3>] ata_scsi_queuecmd+0x1a4/0x1ac [libata]
>  [<c04f6ca4>] elv_next_request+0x127/0x134
>  [<c04c29a3>] nilfs_bmap_lookup_contig+0x31/0x43
>  [<c04bd214>] nilfs_get_block+0xb9/0x227
>  [<c04f6d78>] elv_insert+0xc7/0x160
>  [<c0495970>] do_mpage_readpage+0x2a4/0x5fd
>  [<c04bd15b>] nilfs_get_block+0x0/0x227
>  [<c0458ba8>] find_lock_page+0x1a/0x7e
>  [<c045b314>] find_or_create_page+0x31/0x88
>  [<c04c0a62>] __nilfs_get_page_block+0x70/0x8a
>  [<c04c1171>] nilfs_grab_buffer+0x53/0x11a
>  [<c0458d64>] add_to_page_cache+0x91/0xa2
>  [<c0495da9>] mpage_readpages+0x82/0xb6
>  [<c04bd15b>] nilfs_get_block+0x0/0x227
>  [<c045d2c9>] __alloc_pages+0x69/0x2cf
>  [<c04bc651>] nilfs_readpages+0x0/0x15
>  [<c045e800>] __do_page_cache_readahead+0x11d/0x183
>  [<c04bd15b>] nilfs_get_block+0x0/0x227
>  [<c045e8ac>] blockable_page_cache_readahead+0x46/0x99
>  [<c045ea3f>] page_cache_readahead+0xb3/0x178
>  [<c0459270>] do_generic_mapping_read+0xb8/0x380
>  [<c0459daa>] __generic_file_aio_read+0x16a/0x1a3
>  [<c045887d>] file_read_actor+0x0/0xd5
>  [<c0459e1e>] generic_file_aio_read+0x3b/0x42
>  [<c0475b83>] do_sync_read+0xb6/0xf1
>  [<c0476cbb>] file_move+0x27/0x32
>  [<c043607b>] autoremove_wake_function+0x0/0x2d
>  [<c0475acd>] do_sync_read+0x0/0xf1
>  [<c047645c>] vfs_read+0x9f/0x141
>  [<c04768aa>] sys_read+0x3c/0x63
>  [<c0404f17>] syscall_call+0x7/0xb
>  =======================
>   NILFS: btree level mismatch: 36 != 1
> 
> Later we get corruption in many more files and directories on the nilfs partition, many with different errors & stack traces.
> 
> Has anybody seen these errors and then worked around them? If so, can you please let me know how. Any thoughts on whether this is an SSD issue or is this is a nilfs bug? If it is a nilfs bug, have things been fixed in the newer kernel module. Thanks a lot.
> 
> Zahid
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
