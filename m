From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCHv2 0/3] nilfs2 add feature flags
Date: Fri, 23 Jul 2010 22:28:59 +0900 (JST)
Message-ID: <20100723.222859.67889800.ryusuke@osrg.net>
References: <1279736540-21556-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<87tynq95wy.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87tynq95wy.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 23 Jul 2010 13:30:05 +0900, Jiro SEKIBA wrote:
> Hi, 
> 
> At Thu, 22 Jul 2010 03:22:17 +0900,
> Ryusuke Konishi wrote:
> > 
> > This is a revised patchset that introduces feature flags and makes
> > nilfs refuse to mount future incompatibile filesystems.
> > 
> > The first patch is just for improving readability of super block
> > format.  The second patch extends super block and adds three flags to
> > record feature sets (i.e. "compat features", "read-only compat
> > features", and "incompat features").  The semantics of these flags is
> > mimic of ext3.  At present, no feature flags are defined.
> > 
> > The third patch makes nilfs reject filesystems with unknown features.
> > This serves as a safety for future disk format change which is not
> > forward compatible.
> > 
> > * Change from the v1 patchset is as follows:
> > 
> >  - insert the same test of feature flags also before proceed with
> >    recovery for read-only mount.
> 
> This is, I think, one of the mandatory functionality to take
> "experimental flag" away.  Fixing disk format is important, 
> but any unexpected incompatible disk format change may happen in future.
>
> At least, nilfs can protect its filesystem from destructing by itself.

Yes, that's the reason why I push it now.
All right, I'll queue it for the next merge window as planned.

Thanks,
Ryusuke Konishi


 

 
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
