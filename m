From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: FIBMAP ioctl missing
Date: Fri, 25 Feb 2011 20:34:23 +0900 (JST)
Message-ID: <20110225.203423.220041947.ryusuke@osrg.net>
References: <201102242334.38044.dexen.devries@gmail.com>
	<-2895307820866716365@unknownmsgid>
	<201102250902.46443.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201102250902.46443.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Fri, 25 Feb 2011 09:02:46 +0100, dexen deVries wrote:
> On Friday 25 of February 2011 01:21:53 you wrote:
> > Just thinking about it fast, NILFS2 is a filesystem that wraps around
> > the disk forever and LILO writes a bitmap of where the kernel image
> > is. So if NILFS moves the image then LILO is at lost and will load
> > some data which is not the kernel instead. A fast guess I would say
> > using LILO on NILFS is impossible by design.
> 
> That's a good point, thanks.
> 
> A dirty hack comes to my mind, back from the days of DOS: files marked with 
> `system' attribute were not moved during defrag (important for io.sys & 
> msdos.sys). Perhaps using some sensible attribute (i? t? a new one?) would 
> prevent nilfs_cleanerd from moving the file?
>
> Would require implementing attributes on NILFS, thou.

I guess pinning files on the device is possible in some way.  But
Supporting FIBMAP, which internally means supporting iops->bmap vfs
interface, sounds more delicate than FIEMAP because it is actually
used to determine block location for raw-write access.  The swapfile
is an example of that.

Strictly, FIEMAP has the same risk, but in practice, we are using it
for more harmless purposes such like analyzing fragmentation or giving
hint to read-ahead tools.

If we can safely disable a swapfile on filesystem and we can widely
share the basic premise that "writing to the block location acquired
by FIBMAP is a very dangerous thing for log-structured filesystems or
COW filesystems", we could add it.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
