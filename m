From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: nilfs2-utils ver 2.0.21?
Date: Thu, 20 Jan 2011 15:49:49 +0900 (JST)
Message-ID: <20110120.154949.93449454.ryusuke@osrg.net>
References: <87mxmwxgkf.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87mxmwxgkf.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Thu, 20 Jan 2011 14:57:52 +0900, Jiro SEKIBA wrote:
> Hi,
> 
> Is there any plan to release nilfs2-utils v2.0.21 ?
> 
> It has been 4 months since v2.0.20 released.
> 
> The license of the library is properly changed to LGPL.
> So wouldn't it be a good reason to release the newer version?

Right, and looking back it should have been released last year after
the license migration was done.

> By the way, if I remember correctly, disk format won't change without
> breaking compatibility.  If it's the case, the warning when mounting
> nilfs2 partition may not need anymore?  It's scary anyway..
> http://www.spinics.net/lists/linux-nilfs/msg00595.html
> 
> thanks

The warning message is already taken away from the latest tree on
nilfs-utils.git, but we haven't yet made a release of it.

Okay, I will do a 2.0.21 later this week.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
