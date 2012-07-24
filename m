From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: read error on superblock
Date: Tue, 24 Jul 2012 09:06:04 +0900 (JST)
Message-ID: <20120724.090604.40913934.konishi.ryusuke@lab.ntt.co.jp>
References: <2948186.vfdzh15lNi@coil>
	<20120723.201918.94868195.konishi.ryusuke@lab.ntt.co.jp>
	<8066200.UhSxO3eimj@blitz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8066200.UhSxO3eimj@blitz>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 23 Jul 2012 20:24:10 +0200, dexen deVries wrote:
> Hi again,
> 
> 
> I've copied the whole filesystem elsewhere (to a file) with `ddrescue'. It found 
> one damaged area on the drive, but apparently neither at start nor at the end 
> of partition.
> 
> The FS on the drive was marked as `dirty' (requiring recovery upon mount). My 
> guess is that kernel attempted recovery, and gave up upon read error.
> 
> Unfortunately, the `norecovery' option did not help with the drive; it only 
> helped once i've moved whole FS to file.
> 
> 
> Log from ddrescue:
> 
> 
> # Rescue Logfile. Created by GNU ddrescue version 1.14
> # Command line: ddrescue /dev/sdc3 sda3 sda3.log
> # current_pos  current_status
> 0x149E0CCC00     +
> #      pos        size  status
> 0x00000000  0x149E0CC000  +
> 0x149E0CC000  0x00001000  -
> 0x149E0CD000  0x11220D3000  +
> 
> 
> my understanding is, the following line describes the damaged area, format: 
> start length status-marker (`-' for error)
> 0x149E0CC000  0x00001000  -
> 
> 
> Once the FS was copied to a file, it mounted correctly:
> # mount -o ro,loop,norecovery ./sda3.img ./some-mountpoint 
> 
> 
> My gripe with current (linux-3.5.0) NILFS2 driver is that I couldn't tell it 
> to ignore read errors and thus force it to mount the filesystem.

Good point.  The current recovery logic is intentionally implemented
so that it aborts when having met an I/O error.

This treatment should not be applied at least if the norecovery option
is specified.

Thanks,
Ryusuke Konishi

> Ony after I've 
> moved some 160GB of FS to a file (that's a bit tedious :P) it opened the FS 
> just fine.
> 
> 
> Cheers,
> -- 
> dexen deVries
> 
> 1972 - Dennis Ritchie invents a powerful gun that shoots both forward and 
> backward simultaneously. Not satisfied with the number of deaths and permanent 
> maimings from that invention he invents C and Unix.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
