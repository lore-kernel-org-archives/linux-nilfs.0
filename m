From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs_cleanerd for the root filesystem
Date: Sat, 12 Feb 2011 02:10:48 +0900 (JST)
Message-ID: <20110212.021048.103837316.ryusuke@osrg.net>
References: <201102111429.41478.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201102111429.41478.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Fri, 11 Feb 2011 14:29:41 +0100, dexen deVries wrote:
> Hello,
> 
> It seems mounting NILFS as root filesystem does not cause nilfs_cleanerd to be 
> started. I'm not using initrd; just indicated the root partition in kernel's 
> command line, so it gets mounted directly.
> 
> Is there a way to fix that?

No, the cleaner daemon cannot be started if the device gets mounted
directly since the daemon is invoked by the mount.nilfs2 helper
program which is called through the common mount program.

If you want to invoke cleanerd later, try remount:

 # mount -t nilfs2 -o remount /dev/xxx /mount-point


We can also shutdown the cleanerd manually by "nogc" option.

 # mount -t nilfs2 -o remount,nogc /dev/xxx /mount-point


Thanks,
Ryusuke Konishi

> -- 
> dexen deVries
> 
> [[[↓][→]]]
> 
> > how does a C compiler get to be that big? what is all that code doing?
> 
> iterators, string objects, and a full set of C macros that ensure
> boundary conditions and improve interfaces.
> 
> ron minnich, in response to Charles Forsyth
> 
> http://9fans.net/archive/2011/02/90
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
