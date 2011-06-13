From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Cleancache
Date: Mon, 13 Jun 2011 23:40:48 +0900 (JST)
Message-ID: <20110613.234048.21322431.ryusuke@osrg.net>
References: <20110608.230231.65968027.ryusuke@osrg.net>
	<20110613.221503.212701772.ryusuke@osrg.net>
	<201106131521.15372.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201106131521.15372.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 13 Jun 2011 15:21:15 +0200, dexen deVries wrote:
> Hi Ryusuke,
> 
> 
> On Monday 13 of June 2011 15:15:03 you wrote:
> > I couldn't reproduce this problem.
> > Could you tell me more about how you did it.
> > 
> > May I reproduce the oops on native machines ? (I mean non-virtual
> > machine environment).
> 
> I'll try to re-create the condition today; been busy through last weekend, 
> sorry~

Ok, thanks.

> It was on an 2-CPU SMP + SMT machine, raw hardware, if that makes any 
> difference; I'll see also if it gets triggered on VirtualBox.

So, you hit the bug on a raw hadrware.
In my hardware, /sys/kernel/mm/cleancache/* didn't change.

Is it reproducible without zcache?

If not, we should share the steps with zcache.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
