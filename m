From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: FIBMAP ioctl missing
Date: Fri, 25 Feb 2011 23:30:06 +0900 (JST)
Message-ID: <20110225.233006.99027840.ryusuke@osrg.net>
References: <201102250902.46443.dexen.devries@gmail.com>
	<20110225.203423.220041947.ryusuke@osrg.net>
	<201102251244.06554.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201102251244.06554.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(Cc'ed to linux-nilfs)
On Fri, 25 Feb 2011 12:44:06 +0100, dexen deVries wrote:
> On Friday 25 of February 2011 12:34:23 you wrote:
> > I guess pinning files on the device is possible in some way.  But
> > Supporting FIBMAP, which internally means supporting iops->bmap vfs
> > interface, sounds more delicate than FIEMAP because it is actually
> > used to determine block location for raw-write access.  The swapfile
> > is an example of that.
> > 
> > Strictly, FIEMAP has the same risk, but in practice, we are using it
> > for more harmless purposes such like analyzing fragmentation or giving
> > hint to read-ahead tools.
> 
> As a sidenote, it seems hdparm has that `--fibmap' subcommand, but it actually 
> issues FIEMAP rather than FIBMAP ioctl. 

Thanks for the information.  This actually worked on nilfs.

> > If we can safely disable a swapfile on filesystem and we can widely
> > share the basic premise that "writing to the block location acquired
> > by FIBMAP is a very dangerous thing for log-structured filesystems or
> > COW filesystems", we could add it.
> 
> Perhaps it would be enough if FIBMAP implementation for NILFS checked if the 
> file has a `pin-it-down' attribute and only then returned anything other than 
> EINVAL.

Sounds a good idea.
 
> Regarding pinning a file to physical location on a device: if a file is part of 
> a snapshot, does its data or metadata ever get moved?

Only GC routine can move data and metadata, and only nilfs_cleanerd
triggers the routine.  Nilfs freezes past data and namespace into
snapshot without copying or moving blocks.

nilfs_cleanerd (NILFS GC) moves blocks per segment not per file, so
pinning files would be achieved by skipping reclamation of segments
recording the pinned files.

Thanks,
Ryusuke Konishi

> -- 
> dexen deVries
> 
> [[[↓][→]]]
> 
> > how does a C compiler get to be that big? what is all that code doing?
> 
> iterators, string objects, and a full set of C macros that ensure
> boundary conditions and improve interfaces.
> 
> ron minnich, in response to Charles Forsyth
> 
> http://9fans.net/archive/2011/02/90
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
