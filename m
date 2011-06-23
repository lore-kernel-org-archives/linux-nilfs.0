From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: mount & fsck of nilfs partition fail.
Date: Thu, 23 Jun 2011 20:25:05 +0900 (JST)
Message-ID: <20110623.202505.27804490.ryusuke@osrg.net>
References: <053D39D3D76C474EB2D2A284AA6BA3181B05E99A12@COLOSSEXCH01.starsolutions.com>
	<20110618.135312.64853996.ryusuke@osrg.net>
	<053D39D3D76C474EB2D2A284AA6BA3181B05E99CC6@COLOSSEXCH01.starsolutions.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <053D39D3D76C474EB2D2A284AA6BA3181B05E99CC6-ZjuI7xOJlFPnaE3xbIMyWkCiaQ3SRT3KFkJ40O1dFu8@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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
