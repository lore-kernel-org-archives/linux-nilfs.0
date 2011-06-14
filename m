From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Split some metadata onto separate device?
Date: Tue, 14 Jun 2011 22:18:43 +0900 (JST)
Message-ID: <20110614.221843.86482881.ryusuke@osrg.net>
References: <201106081508.39345.dexen.devries@gmail.com>
	<20110608.224906.85409768.ryusuke@osrg.net>
	<20110614111852.GA1263@heethoofdje.13thmonkey.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110614111852.GA1263-bVHBekiX4bNgoMqBc1r0ESegHCQxtGRMHZ5vskTnxNA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org
Cc: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Reinoud,
On Tue, 14 Jun 2011 13:18:52 +0200, Reinoud Zandijk wrote:
> Hi Dexen, hi Ryusuke,
> 
> been a while since i was active on the list or active with NiLFS in general
> but the last vacation did remind me why i started working on NiLFS for NetBSD
> again! Using FFS, even with logging, UDF or msdosfs just doesn't work well on
> Flash media ;)
> 
> On Wed, Jun 08, 2011 at 10:49:06PM +0900, Ryusuke Konishi wrote:
> > > > > Yes, but extents will decrease the amount of metadata, and this has
> > > > > potential for speed up.
> > > > > 
> > > > > NILFS2 uses 32 bytes metadata per disk block at present.  I guess you
> > > > > know that the number of DAT blocks are actually indispensable through
> > > > > analysis using the dumpseg tool.
> > > > 
> > > > Oh, looks confusing.  I meant the amount of DAT blocks is not
> > > > negligible.
> > > 
> > > Understood ;-)
> > > 
> > > Anyway, isn't some fragmentation avoidance necessary to profit from extents 
> > > (that we hope we'll use at some point)?
> > 
> > I guess it doesn't become a big issue unless we do many small random
> > writes like database.
> > 
> > > AFAIK, an extent is only good to describe file blocks if they are laid out 
> > > continuous on the block device.
> > 
> > Yep.  And, we know files are enough continuous in most cases.
> > 
> > We use at least 16 bytes per 4 kiro-bytes disk block to point the
> > block (16KB for 8MB segment); btrees of nilfs2 use an 8 bytes key and
> > an 8 bytes pointer for a disk block.
> > 
> > In typical case, this can be reduced to 16 bytes per file (16 bytes
> > for 8MB segment) with the extents.
> > 
> > IMO, 64-bit filesystems have a reasonable reason to adopt extents
> > though nilfs2 did not apply it.
> > 
> > I guess applying extents to the DAT file is especially effective.

> I've used extents a lot in UDF since its all-extent based, and yes,
> it CAN be a lot smaller indeed :) BUT only when files are NOT sparse
> and NOT fragmented.
> 
> Anyway, my sugestion is an intermediate one since it doesn't change
> the disc format: on garbage collection, make an extra pass to seek
> (very) fragmented extents in the DAT, how much might be a parameter,
> read it all in and then relocate/write out a whole (or partial)
> segment with it. This could also be done with the CP and SU files
> although those files are relatively tiny. This will leave the DAT
> file in just a few segments when the filesystem has been garbage
> collected and (hopefully) most references only within the segment
> also easing cachability.
> 
> Other files could also be un-sparsified this way but i think the DAT
> will have the most benefit and it's relatively easy to do this way.

That's a good point.  Defragmetation on GC is a known technique for
LFS, but defragmentation focusing on the DAT file sounds more
meaningful.

We already have components for that:

One-shot GC routine is now separated as a library from nilfs_cleanerd
(i.e. libnilfsgc), and we can call it even while the cleaner is
running.

Also, we have an ioctl command to get location of disk blocks
composing the DAT file.  (i.e. NILFS_IOCTL_GET_BDESCS).

With these setups, making a defrag tool for DAT seems possible.

The bad news is that the current GC routine cannot leave other blocks
in the same segment untouched; they will be moved along with blocks of
the DAT file.


By the way, I am considering to propose a disk format change to
implement feaures like checkpoint diff, revert without file
duplication, and extended attributes.  (We once posted a patchset on
the checkpoint diff with title "[PATCH 0/9] exprimental API to extract
changes between two checkpoints").

We may enlarge the size of disk inode to 256 bytes from the current
128 byte size in order to store information needed for those
enhancements.

If you have an opinion (or objection) for this, please let me know.


Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
