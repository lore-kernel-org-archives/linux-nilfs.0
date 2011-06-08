From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Split some metadata onto separate device?
Date: Wed, 08 Jun 2011 21:48:52 +0900 (JST)
Message-ID: <20110608.214852.237935973.ryusuke@osrg.net>
References: <201106031229.38758.dexen.devries@gmail.com>
	<20110604.022621.01482278.ryusuke@osrg.net>
	<201106031942.29133.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201106031942.29133.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 3 Jun 2011 19:42:28 +0200, dexen deVries wrote:
> Hi Ryusuke,
> 
> 
> On Friday 03 June 2011 19:26:21 you wrote:
> > (...) 
> > NILFS2 is a log-structured filesystem and that means the filesystem
> > itself is a big journal.  My understanding is using separate journal
> > device has no merit of performance.
> > 
> > On the other hand, We may be able to speed up the filesystem by
> > putting DAT (disk address translation) metadata to a separate device.
> > I mean putting a full copy of the DAT metadata on the sperate device
> > instead of journal of it.
> 
> *nods* sounds interesting. Of course changing on-disk format would hurt ;-)
> 
> 
> > But, I think we have other approaches to think about before that with
> > regard to performance improvement.  For example, applying "extent" to
> > DAT seems much more effective.
> 
> Currently every block of file gets own entry in DAT, right?

Exactly.

> By the way, it seems to me that the in-kernel GC does not attempt to
> de- fragment files. Is that the case? If so, would probably mean
> extents would not help very much for fragmented files. Also, on
> magnetic media, a lot of seeking happens in case of fragmented
> files.

Yes, but extents will decrease the amount of metadata, and this has
potential for speed up.

NILFS2 uses 32 bytes metadata per disk block at present.  I guess you
know that the number of DAT blocks are actually indispensable through
analysis using the dumpseg tool.

Regards,
Ryusuke Konishi


> Regards,
> -- 
> dexen deVries
> 
> ``One can't proceed from the informal to the formal by formal means.''
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
