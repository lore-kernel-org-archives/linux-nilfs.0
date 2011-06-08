From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Split some metadata onto separate device?
Date: Wed, 08 Jun 2011 22:49:06 +0900 (JST)
Message-ID: <20110608.224906.85409768.ryusuke@osrg.net>
References: <20110608.214852.237935973.ryusuke@osrg.net>
	<20110608.215803.224753719.ryusuke@osrg.net>
	<201106081508.39345.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201106081508.39345.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 8 Jun 2011 15:08:37 +0200, dexen deVries wrote:
> Hi again,
> 
> 
> On Wednesday 08 of June 2011 14:58:03 you wrote:
> > On Wed, 08 Jun 2011 21:48:52 +0900 (JST), Ryusuke Konishi wrote:
> > > On Fri, 3 Jun 2011 19:42:28 +0200, dexen deVries wrote:
> > > > By the way, it seems to me that the in-kernel GC does not attempt to
> > > > de- fragment files. Is that the case? If so, would probably mean
> > > > extents would not help very much for fragmented files. Also, on
> > > > magnetic media, a lot of seeking happens in case of fragmented
> > > > files.
> > > 
> > > Yes, but extents will decrease the amount of metadata, and this has
> > > potential for speed up.
> > > 
> > > NILFS2 uses 32 bytes metadata per disk block at present.  I guess you
> > > know that the number of DAT blocks are actually indispensable through
> > > analysis using the dumpseg tool.
> > 
> > Oh, looks confusing.  I meant the amount of DAT blocks is not
> > negligible.
> 
> Understood ;-)
> 
> Anyway, isn't some fragmentation avoidance necessary to profit from extents 
> (that we hope we'll use at some point)?

I guess it doesn't become a big issue unless we do many small random
writes like database.

> AFAIK, an extent is only good to describe file blocks if they are laid out 
> continuous on the block device.

Yep.  And, we know files are enough continuous in most cases.

We use at least 16 bytes per 4 kiro-bytes disk block to point the
block (16KB for 8MB segment); btrees of nilfs2 use an 8 bytes key and
an 8 bytes pointer for a disk block.

In typical case, this can be reduced to 16 bytes per file (16 bytes
for 8MB segment) with the extents.

IMO, 64-bit filesystems have a reasonable reason to adopt extents
though nilfs2 did not apply it.

I guess applying extents to the DAT file is especially effective.


Regards,
Ryusuke Konishi

> Cheers,
> -- 
> dexen deVries
> 
> [[[↓][→]]]
> 
> For example, if the first thing in the file is:
>    <?kzy irefvba="1.0" rapbqvat="ebg13"?>
> an XML parser will recognize that the document is stored in the traditional 
> ROT13 encoding.
> 
> (( Joe English, http://www.flightlab.com/~joe/sgml/faq-not.txt ))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
