From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] lscp: support opening mounted filesystem by directory
 pathname
Date: Wed, 02 Mar 2011 23:21:10 +0900 (JST)
Message-ID: <20110302.232110.169818198.ryusuke@osrg.net>
References: <201103021113.32637.dexen.devries@gmail.com>
	<20110302.202345.74569955.ryusuke@osrg.net>
	<201103021343.54036.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201103021343.54036.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 2 Mar 2011 13:43:53 +0100, dexen deVries wrote:
> On Wednesday 02 of March 2011 12:23:45 you wrote:
> > Hi,
> > 
> > On Wed, 2 Mar 2011 11:13:32 +0100, dexen deVries wrote:
> > > The patch I've submited may be a wrong solution; perhaps instead the
> > > algorithm of nilfs_find_fs() (around lib/nilfs.c:179,211) should be
> > > improved.
> > > 
> > > Regards,
> > 
> > Well, allowing directory pathname for nilfs commands seems a good idea
> > to me.  Why not apply it to other commands except nilfs_cleanerd ?
> > 
> 
> Goot point, I'm on it right now.
> 
> Reading through sbin/cleanerd/cleanerd.c, it seems it doesn't make any 
> distinction between dev and dir, just supplies program's argument as both dev 
> and dir arguments to nilfs_open(). In my understanding, that'd be the cleanest 
> way of using it. 
> 
> However, the current behavior of nilfs_open() (or more exactly, of 
> nilfs_find_fs()) doesn't support that semantics -- if dev is passed, it kind of 
> ignores the dir argument.

No, nilfs_find_fs() compares both dev and dir arguments if both are
given.  Actually nilfs_cleanerd needs the dir argument because two
writable mounts can coexist on the same device when bind mounts are
used, and cleanerd has to be attached on exactly the same mount point.

> Perhaps I should try to fix nilfs_find_fs() rather 
> than put stat() and S_ISDIR() in every program?

I'd like to avoid changing interface of nilfs_open.  You can add a
wrapper function to libnilfs if you don't prefer to insert stat() and
S_ISDIR() in every program.

Thanks,
Ryusuke Konishi
 
> --
> dexen deVries
> 
> [[[↓][→]]]
> 
> 47. As Will Rogers would have said, "There is no such thing as a free 
> variable."
> 
> (Alan Perlis, `Epigrams on Programming')
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
