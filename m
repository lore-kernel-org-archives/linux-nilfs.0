From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Recommended partition scheme for nilfs2
Date: Fri, 08 Jul 2011 01:31:14 +0900 (JST)
Message-ID: <20110708.013114.99894120.ryusuke@osrg.net>
References: <20110707.122142.41457972.ryusuke@osrg.net>
	<20110707.130423.56377867.ryusuke@osrg.net>
	<201107071113.49938.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201107071113.49938.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Thu, 7 Jul 2011 11:13:48 +0200, dexen deVries wrote:
> On Thursday 07 of July 2011 06:04:23 you wrote: 
> > > This topic was once discussed with the title of "FIBMAP ioctl
> > > missing".
> > > 
> > > fibmap internally uses bmap vfs method.  Adding the feature is not so
> > > difficult, but it must not be used for overwriting data blocks because
> > > nilfs everytime changes allocation of file blocks due to its COW
> > > nature.  Garbage collection also blows up safety of such operation.
> > > Unfortunately, swap file is actually doing it.
> > > 
> > > Does LILO use fibmap for read-only purpose ?
> > > 
> > > If so, we only need a method to deny direct block write by the swap
> > > file.
> > 
> > That was not enough.  I guess LILO uses block mapping assuming it's
> > pinned to the place.  It's not easy to implement within nilfs.
> 
> That's my understanding as well. LILO, upon `installation' (the
> `lilo' command) creates a static map of which blocks make up kernel
> file (and optionally initial ramdisk). Basically we'd have to ensure
> the kernel file blocks are never moved around, which'd increase
> complexity of NILFS2. Leaving 128MB /boot partition gets the job
> done at benign cost.
> 
> FWIW, I got fingers burned by grub's complexity a few times, so I
> stick to the simple LILO.
> 
> Btw., Ryusuke, you've mentioned that blocks being part of a snapshot
> are never moved around, right? If that's the case, keeping kernel
> files on snapshot would be enough, but snapshots can be deleted (and
> subsequently GC'd) at any time.

No, blocks held by snapshots are moved by GC.  Recall how GC reclaims
segments (watch output of lssu command continually).

To pin specified data blocks, we need to introduce "immutable segment"
which is never selected for garbage collection, or need to add
"imovable flag" for such files.  Both are not present in the current
nilfs.

> We could hack around that in a somewhat standard way with `chattr +i
> /boot/vmlinuz-xxx', provided NILFS2 supported the `i' (immutable)
> attribute (as discussed in man chattr(1)), but again that's some
> complexity. Or +t which was meant to secure against tail-merging for
> use with LILO.

The current nilfs supports the immutable flag, but yes, the immutable
attribute does not imply the file is immovable on disk.  We need a new
flag for that.. though I don't like adding such own attribute.


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
