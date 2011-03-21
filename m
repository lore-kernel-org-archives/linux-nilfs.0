From: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Subject: Re: Problem report: cannot run nilfs_cleanerd on full filesystem
Date: Mon, 21 Mar 2011 14:01:51 +0100
Message-ID: <20110321130151.GA29111@heethoofdje.13thmonkey.org>
References: <20110319220157.GA681@heethoofdje.13thmonkey.org> <201103192312.38046.dexen.devries@gmail.com> <20110320125040.GA735@heethoofdje.13thmonkey.org> <20110321.200706.260176646.ryusuke@osrg.net>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110321.200706.260176646.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Mar 21, 2011 at 08:07:06PM +0900, Ryusuke Konishi wrote:
> > So IMHO the .nilfs file is a hack in itself :-D
> 
> The ".nilfs" file is used for two purposes:
> 
>  1) As the file on which the nilfs library issues ioctls.
> 
>  2) For advisory locks (i.e. fcntl(F_GETLK/F_SETLK/FSETLKW)).  This
>     works as a mutex between the cleaner and other nilfs-tools.
> 
> Note that the nilfs2 kernel code never uses the .nilfs file; it's just
> a regular file for nilfs2.
> 
> As for the item (1), we can use the root directory of each filesystem
> instead.  And for (2), a Posix semaphore or other lock primitives may
> be available.

In NetBSD this is normally resolved by looking up the device the directory is
residing and then opening/locking the device file etc. I think this is a
better way of operating!

It also doesn't allow two cleanerds to be started on one device; otherwise one
could be started on the head and the other on a snapshot, or not?

With regards,
Reinoud

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
