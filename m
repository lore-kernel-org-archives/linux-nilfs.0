From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Problem report: cannot run nilfs_cleanerd on full filesystem
Date: Tue, 22 Mar 2011 00:17:41 +0900 (JST)
Message-ID: <20110322.001741.242727489.ryusuke@osrg.net>
References: <20110320125040.GA735@heethoofdje.13thmonkey.org>
	<20110321.200706.260176646.ryusuke@osrg.net>
	<201103211305.48353.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201103211305.48353.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 21 Mar 2011 13:05:48 +0100, dexen deVries wrote:
> Hi again,
> 
> 
> On Monday 21 of March 2011 12:07:06 you wrote:
> > The ".nilfs" file is used for two purposes:
> > 
> >  1) As the file on which the nilfs library issues ioctls.
> > 
> >  2) For advisory locks (i.e. fcntl(F_GETLK/F_SETLK/FSETLKW)).  This
> >     works as a mutex between the cleaner and other nilfs-tools.
> 
> 
> Regarding 2), it seems multiple instances of nilfs_cleanerd can be started for 
> one filesystem (which leads to metadata corruption, as per my earlier 
> ``Regarding problem with nilfs_cleanerd - part 2 and Nilfs_cleanerd err=-17'' 
> mail).
> 
> Is that intentional? Should we guard on nilfs_cleanerd level, or on kernel 
> level?

Even if multiple nilfs_cleanerd were invoked on a nilfs volume, they
work exclusively and corruption will not occur.  Of course,
mount.nilfs2 does not invoke multiple cleaners unless user
intentionally do so.

I guess the corruption problem is caused by some sort of
difficult-to-find bug at this time.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
