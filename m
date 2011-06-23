From: Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>
Subject: RE: mount & fsck of nilfs partition fail.
Date: Thu, 23 Jun 2011 11:21:03 -0700
Message-ID: <053D39D3D76C474EB2D2A284AA6BA3181B05E9A356@COLOSSEXCH01.starsolutions.com>
References: <053D39D3D76C474EB2D2A284AA6BA3181B05E99A12@COLOSSEXCH01.starsolutions.com>
	<20110618.135312.64853996.ryusuke@osrg.net>
	<053D39D3D76C474EB2D2A284AA6BA3181B05E99CC6@COLOSSEXCH01.starsolutions.com>
 <20110623.202505.27804490.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110623.202505.27804490.ryusuke-sG5X7nlA6pw@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello Ryusuke,
  After the new kernel module (2.0.22) the nilfs partition mounted with no problems. I have encountered no problems since then. Doing a lssu(1) does not show segment 759 to be on the list of used segments any further:

lssu -a /dev/sda2
              SEGNUM        DATE     TIME STAT     NBLOCKS
                   0  2011-06-23 10:56:42  -d-        2047
                   1  2011-06-23 10:56:42  -d-        2048
                   2  2011-06-23 10:56:42  -d-        2048
                   3  2011-06-23 10:56:42  -d-        2048
                   4  2011-06-23 10:56:44  -d-        2048
                   5  2011-06-23 10:56:46  -d-        2048
                   7  2011-06-23 10:56:46  -d-        2048
                   8  2011-06-23 10:56:47  -d-        2048
                   9  2011-06-23 10:56:47  -d-        2048
                  10  2011-06-23 10:56:47  -d-        2048
                  11  2011-06-23 10:56:47  -d-        2048
                  12  2011-06-23 10:56:47  -d-        2048
                  13  2011-06-23 10:56:52  -d-        2048
                  14  2011-06-23 10:56:52  -d-        2048
                  16  2011-06-23 10:56:52  -d-        2048
                  17  2011-06-23 10:56:52  -d-        2048
                  18  2011-06-23 10:56:52  -d-        2048
                  19  2011-06-23 10:56:53  -d-        2048
                  20  2011-06-23 10:56:54  ad-        1273
                  21  ---------- --:--:--  ad-           0
                 946  2011-06-23 10:52:27  -d-        2048
                 947  2011-06-23 10:52:28  -d-        2048
                 948  2011-06-23 10:52:28  -d-        2048
                 949  2011-06-23 10:52:28  -d-        2048
			.
			.
			.
Though dumpseg 759 does not show anything untoward (I don't think its used any further, correct?):

dumpseg /dev/sda2 759
segment: segnum = 759
  sequence number = 608068, next segnum = 760
  partial segment: blocknr = 1554432, nblocks = 2048
    creation time = 2011-06-23 10:48:02
    nfinfo = 652
    finfo
      ino = 7984, cno = 13, nblocks = 756, ndatblk = 756
        vblocknr = 146359, blkoff = 30686, blocknr = 1554444
        vblocknr = 146360, blkoff = 30687, blocknr = 1554445
		.
		.
		.
    finfo
      ino = 16619, cno = 3763620, nblocks = 2, ndatblk = 2
        vblocknr = 224656, blkoff = 304, blocknr = 1555200
        vblocknr = 224635, blkoff = 305, blocknr = 1555201
    finfo
      ino = 16619, cno = 3763616, nblocks = 1, ndatblk = 1
        vblocknr = 224551, blkoff = 303, blocknr = 1555202
		.
		.
		.

One other question I have for anybody on the list or Ryusuke, on a corruption of nilfs on older kernels (pre 2.6.30) should I leave fsck0.nilfs2 to run on the initscripts besides the new 2.0.22 kernel module or is this really redundant? Thanks for any help/comments. All, as far as I can see, this is a pretty cool filesystem.

Zahid 

-----Original Message-----
From: Ryusuke Konishi [mailto:konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org] 
Sent: Thursday, June 23, 2011 4:25 AM
To: Zahid Chowdhury
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: mount & fsck of nilfs partition fail.

On Mon, 20 Jun 2011 11:27:49 -0700, Zahid Chowdhury wrote:
> Hello Ryusuke,
>
>   Sorry, I was away on the w/e. I've attached the console trace and
>   the out file again for posterity. I will be upgrading to the
>   recently released 2.0.22 version, and will try to mount the
>   corrupted filesystem with it - unlikely, it will work, though it
>   should help on future filesystems based on nilfs2? Thanks for the
>   fsck help and the new release for older kernels. Please let me
>   know if you need anything further, such that I can recover the
>   corrupted filesystem.
>
> Zahid
> 
> The console trace:
> /sbin/fsck0.nilfs2 -f -v /dev/sda2
> Super-block:
>     revision = 2.0
>     blocksize = 4096
>     write time = 2011-06-11 23:22:03
>     indicated log: blocknr = 1648528
>         segnum = 804, seq = 401758, cno=3250953
> 
> Unclean FS.
> The latest log is lost. Trying rollback recovery..
> ......
> Searching the latest checkpoint.
> get_latest_cno: log_start=1556429 (segnum=759): nfinfo=6, fblocknr=1556430
> get_latest_cno: finfo: ino=17874, sum-blocknr=1556429, offset=80, nblocks=2, ndatablk=1, fblocknr=1556430
> get_latest_cno: finfo: ino=17875, sum-blocknr=1556429, offset=128, nblocks=1, ndatablk=1, fblocknr=1556432
> get_latest_cno: finfo: ino=6, sum-blocknr=1556429, offset=168, nblocks=2, ndatablk=1, fblocknr=1556433
> get_latest_cno: finfo: ino=4, sum-blocknr=1556429, offset=216, nblocks=3, ndatablk=2, fblocknr=1556435
> get_latest_cno: finfo: ino=4499, sum-blocknr=1556429, offset=280, nblocks=1306282328, ndatablk=0, fblocknr=1556438

According to this log, the summary information of segment #759 looks
broken.  This may cause future GC failure or filesystem corruption.

Could you confirm whether the segment summary is actually broken or
not ?  This can be done with dumpseg tool:

 # dumpseg /dev/sda2 759

If it looks actually broken, I recommend you to back up all data as
soon as possible.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
