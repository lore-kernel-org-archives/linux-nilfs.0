From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Problem report: cannot run nilfs_cleanerd on full filesystem
Date: Mon, 21 Mar 2011 20:07:06 +0900 (JST)
Message-ID: <20110321.200706.260176646.ryusuke@osrg.net>
References: <20110319220157.GA681@heethoofdje.13thmonkey.org>
	<201103192312.38046.dexen.devries@gmail.com>
	<20110320125040.GA735@heethoofdje.13thmonkey.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110320125040.GA735-bVHBekiX4bNgoMqBc1r0ESegHCQxtGRMHZ5vskTnxNA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org, dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Sun, 20 Mar 2011 13:50:40 +0100, Reinoud Zandijk wrote:
> On Sat, Mar 19, 2011 at 11:12:37PM +0100, dexen deVries wrote:
> > And so is delete-proofing the on-disk `.nilfs' file. But perhaps the
> > `.nilfs' could be made a virtual file, maintained by the NILFS2 driver
> > rather than a plain on-disk object?  You are right about the `.nilfs'.
> 
> The problem with looking up /mnt/ is that it (might) return the node /mnt on
> the root FS and not the NiLFS root `/mnt/.' . I don't know how linux handles
> such cases but if `/mnt/.' does return the NiLFS root node then why not let
> NiLFS use that node instead of the /mnt/.nilfs node?
> 
> So IMHO the .nilfs file is a hack in itself :-D

The ".nilfs" file is used for two purposes:

 1) As the file on which the nilfs library issues ioctls.

 2) For advisory locks (i.e. fcntl(F_GETLK/F_SETLK/FSETLKW)).  This
    works as a mutex between the cleaner and other nilfs-tools.

Note that the nilfs2 kernel code never uses the .nilfs file; it's just
a regular file for nilfs2.

As for the item (1), we can use the root directory of each filesystem
instead.  And for (2), a Posix semaphore or other lock primitives may
be available.

In Linux, the advisory lock may be applicable against directories
though I haven't tried yet.  If so, we can simply use the filesystem
root directory for both purposes.

IMHO, the .nilfs file should be displaced sooner or later.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
