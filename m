From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] lscp: support opening mounted filesystem by directory
 pathname
Date: Wed, 02 Mar 2011 20:23:45 +0900 (JST)
Message-ID: <20110302.202345.74569955.ryusuke@osrg.net>
References: <201103021113.32637.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201103021113.32637.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Wed, 2 Mar 2011 11:13:32 +0100, dexen deVries wrote:
> The patch I've submited may be a wrong solution; perhaps instead the algorithm 
> of nilfs_find_fs() (around lib/nilfs.c:179,211) should be improved.
> 
> Regards,

Well, allowing directory pathname for nilfs commands seems a good idea
to me.  Why not apply it to other commands except nilfs_cleanerd ?

I think you can simply the callsite of nilfs_open() just like follows:

  char *dev = NULL, *dir = NULL;

  ...
  stat(pathname, &statbuf);
  if (S_ISDIR(statbuf.st_mode))
        dir = pathname;
  else
        dev = pathname;

  nilfs = nilfs_open(dev, dir, NILFS_OPEN_RDONLY);
  ...


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
