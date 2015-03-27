From: Benixon Dhas <Benixon.Dhas-Sjgp3cTcYWE@public.gmane.org>
Subject: RE: Making Nilfs ZAC Compliant
Date: Fri, 27 Mar 2015 22:35:09 +0000
Message-ID: <3764420FCC841C4DAE85E3B76FC61A773BF2B225@wdscexmb03>
References: <3764420FCC841C4DAE85E3B76FC61A773BF05FB6@wdscexmb03>
 <20150228.035028.199686803538457302.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150228.035028.199686803538457302.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: 'Ryusuke Konishi' <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: "'linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Ryusuke,

We have made some progress with the problem we were facing. 
Please see the comment below inline.

Thanks,
Benixon

> -----Original Message-----
> From: Ryusuke Konishi [mailto:konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] On Behalf Of
> Ryusuke Konishi
> Sent: Friday, February 27, 2015 10:50 AM
> To: Benixon Dhas
> Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: Making Nilfs ZAC Compliant
> 
> Hi,
> On Thu, 26 Feb 2015 19:54:48 +0000, Benixon Dhas wrote:
> > Hi All,
> >
> > We are trying to make Nilfs work with a SMR Device which adheres to
> > Zoned ATA Commands(ZAC) Specification.  One of the restrictions in the
> > specification is reading an unwritten part of the Zone(Segment in
> > Nilfs) will cause a read error.
> >
> > We observe that Nilfs does not write a complete physical segment(we
> > use 256MB segment) always. After digging in the source a while we
> > figured that this is due to the fact that Nilfs requires a certain
> > number of minimum blocks for constructing a partial segment
> > (NILFS_PSEG_MIN_BLOCKS), which currently is 2.  So we see some
> > segments where the last block (in our case a block is 4k) is not being
> > written to.
> 
> For recovery and GC, NILFS needs to insert one or more header blocks before
> writing payload blocks.  Inevitably, the minimum size of a partial segment
> becomes 2.
> 

Yeah that's what we thought too.


> > When some utilities like garbage collector and dump segment reads (May
> > not be an exhaustive list) a segment it tries to read the entire
> > physical segment. This causes read errors in the kernel and hence
> > retries for the last unwritten block in certain segments.
> 
> The recovery function of NILFS also needs to read entire physical segment.  It
> never reads unwritten blocks if the file system was cleanly unmounted,
> however, this is not the case for unclean shutdown or panic.
> 
> Worse yet, if it gets an EIO from the underlying block layer, the recovery will
> fail and the mount system call will abort.
> 

Thanks for thinking of the  corner cases for unclean mount. But right now we don't unmount  the partition at all. Once mounted our script continues to repeatedly overwrite a set of files which triggers garbage collector when the space needs to be reclaimed. We a running in a totally optimistic scenario to begin with. Even in this case we see that unwritten part of the segments are being read.

> > In an attempt to solve this problem we were trying to figure out if we
> > can write some dummy data to the remaining unutilized blocks in the
> > segment. But we are not sure what would be the best way to do this.
> >
> > Another solution we had in mind was to figure out all places where
> > segments are read, and modify it to prevent it from reading unwritten
> > blocks. But we feel this might be more complex solution and might
> > impact performance more.
> 
> Looks like sufile is available for this purpose.  It is maintaining how many
> blocks are written for each segment.  You can see it in the NBLOCKS field of
> the output of lssu command.
> 
> One restriction is that this metadata file (sufile) is unavailable until mount
> system call succeeds.  The recovery code cannot use it.
> 

Yes this is a good user utility to find the segment usage. However we are trying to write the dummy data when the segment is actually built without modifying any accounting information.

> > Please advise us on the best way to solve the problem. Also what would
> > be architecturally a best place to fix the problem.
> 
> Writing dummy data to the dead space for SMR devices looks better to me
> because it's simpler and the performance penalty seems not so high.
> 

Thanks for your input. We were able to patch nilfs2 to write dummy data whenever we encounter a segment which cannot be filled physically to its end. We did this by checking if the next arriving write for segment buffer (nilfs_segbuf_write ) would be able to continue with the current segment. If there are blocks remaining in segment which cannot be used for a new segment buffer write dummy writes are issued to the blocks.

> But,
> What will happen if an unexpected power failure hits the device ?
> Does that cause the file system to read unwritten blocks ?
> 

We haven't really tested this. But on power failure the current state of the write pointers are maintained. 
So on reboot if the file system tries to read a full segment which is partially filled then it would cause read errors the way it is now.

> If so, it seems that we need translation layer to hide these issues, or a new
> error code or a new mechanism to make it possible for file systems to
> know/handle them.
> 

There is some work going on to make a translation layer. Also there are new SCSI/ATA commands being added to support SMR to the kernel.
The patches are not yet in mainline kernel but should be submitted once SMR devices go into production. 
There was also proposal to propagate these errors to higher layers in Vault '15. Not sure if this will materialize any time soon. 
But it is a path that can be taken if needed.

Also, there are documents for the ZAC standards for SMR available in the T13 website.
Starting with the document  " Example ZAC Implementation"  with doc. number f15114r0 should be a good start for getting more details on behavior of SMR disk.
 
> Regards, 
> Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
