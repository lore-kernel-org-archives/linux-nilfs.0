From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: resizing file system
Date: Sun, 12 Sep 2010 11:26:50 +0900 (JST)
Message-ID: <20100912.112650.179928857.ryusuke@osrg.net>
References: <87iq2cr4sq.fsf_-_@fftw.org>
	<20100912.033432.247181057.ryusuke@osrg.net>
	<87zkvnoo1l.fsf@fftw.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87zkvnoo1l.fsf-/JWCw35jmeM@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: athena-/JWCw35jmeM@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 11 Sep 2010 19:31:18 -0400, Matteo Frigo wrote:
> Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> writes:
> 
> > To be precise, you also have to move the secondary superblock, and
> > s_dev_size should be changed, too.  Anyway, all that's required for
> > the off-line expansion are these modifications.
> 
> Ok, I hacked nilfs-tune to change s_dev_size, s_nsegments, and update
> both superblocks.  I ``resized'' a 1GB file system into a 2GB file
> system.  The file system mounts correctly, it has no apparent
> corruption, and lssu shows all the new segments.  Moreover, the cleaner
> recognizes and cycles through the full 2GB of segments.
> 
> However, the free space (as shown by df) is still 1GB, and the file
> system runs out of space after storing 1GB of data, even though the
> other 1GB of segments is shown to be empty by lssu.
> 
> I also tried updating s_free_blocks_count in the superblock,
> but this quantity is apparently overwritten by the kernel after
> mounting the file system.
> 
> My analysis of the situation is that the kernel still uses
> NILFS_SUI(sufile)->ncleansegs from the sufile header, which I am not
> changing.  How do I do that?

Ahh, sorry.  ncleansegs was written in the header block of sufile, and
we had to change it, too.

It's not difficult to change ncleansegs during mount if we tweaks the
kernel code, but I feel it's no longer the best.

Let me think if we can do it straight from userland.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
