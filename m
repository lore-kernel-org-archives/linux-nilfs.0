From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Checking actually used space on NILFS
Date: Thu, 10 Feb 2011 00:13:03 +0900 (JST)
Message-ID: <20110210.001303.24922676.ryusuke@osrg.net>
References: <201102091333.39072.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201102091333.39072.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Wed, 9 Feb 2011 13:33:38 +0100, dexen deVries wrote:
> Hello list,
> 
> 
> it's my first day with NILFS, and one issue bothers me:
> 
> is there a reasonably easy way to check the size of the current (most recent) 
> content of the NILFS filesystem?

The current nilfs doesn't have an effiecient way to do that.
So, the easy way is using 'du -s':

 # du -s /nilfs-mount-point

We need adding API (ioctl) to get extended space information and may
need minor disk format change for that.

Regards,
Ryusuke Konishi

> As in, how much space would remain used if I decided to purge all old 
> checkpoints and only keep the current one.
>
> Regards,
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
