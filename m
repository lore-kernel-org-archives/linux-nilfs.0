From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Recommended partition scheme for nilfs2
Date: Thu, 07 Jul 2011 13:04:23 +0900 (JST)
Message-ID: <20110707.130423.56377867.ryusuke@osrg.net>
References: <a6cda77328d5712a296a687a0e05e298.squirrel@linuxbsdos.com>
	<201107061919.38253.dexen.devries@gmail.com>
	<20110707.122142.41457972.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110707.122142.41457972.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: finid-aEpbUQpJQqXlKS8GlytQkw@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 07 Jul 2011 12:21:42 +0900 (JST), Ryusuke Konishi wrote:
> On Wed, 6 Jul 2011 19:19:37 +0200, dexen deVries wrote:
> > On Wednesday 06 July 2011 18:05:29 you wrote:
> > and also I'm using lilo, which is not supported by NILFS2 yet --
> > lack of fibmap syscall.
> 
> This topic was once discussed with the title of "FIBMAP ioctl
> missing".
> 
> fibmap internally uses bmap vfs method.  Adding the feature is not so
> difficult, but it must not be used for overwriting data blocks because
> nilfs everytime changes allocation of file blocks due to its COW
> nature.  Garbage collection also blows up safety of such operation.
> Unfortunately, swap file is actually doing it.
> 
> Does LILO use fibmap for read-only purpose ?
> 
> If so, we only need a method to deny direct block write by the swap
> file.

That was not enough.  I guess LILO uses block mapping assuming it's
pinned to the place.  It's not easy to implement within nilfs.

Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
