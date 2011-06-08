From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Split some metadata onto separate device?
Date: Wed, 08 Jun 2011 21:58:03 +0900 (JST)
Message-ID: <20110608.215803.224753719.ryusuke@osrg.net>
References: <20110604.022621.01482278.ryusuke@osrg.net>
	<201106031942.29133.dexen.devries@gmail.com>
	<20110608.214852.237935973.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110608.214852.237935973.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 08 Jun 2011 21:48:52 +0900 (JST), Ryusuke Konishi wrote:
> On Fri, 3 Jun 2011 19:42:28 +0200, dexen deVries wrote:
> > By the way, it seems to me that the in-kernel GC does not attempt to
> > de- fragment files. Is that the case? If so, would probably mean
> > extents would not help very much for fragmented files. Also, on
> > magnetic media, a lot of seeking happens in case of fragmented
> > files.
> 
> Yes, but extents will decrease the amount of metadata, and this has
> potential for speed up.
> 
> NILFS2 uses 32 bytes metadata per disk block at present.  I guess you
> know that the number of DAT blocks are actually indispensable through
> analysis using the dumpseg tool.

Oh, looks confusing.  I meant the amount of DAT blocks is not
negligible.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
