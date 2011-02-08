From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] nilfs2_ss_manager: fix TypeError at exit
Date: Tue, 08 Feb 2011 19:52:56 +0900 (JST)
Message-ID: <20110208.195256.133422088.ryusuke@osrg.net>
References: <87mxm8a4hg.wl%jir@sekiba.com>
	<20110207.131318.212382134.ryusuke@osrg.net>
	<87aai6533k.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87aai6533k.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 08 Feb 2011 17:42:55 +0900, Jiro SEKIBA wrote:
> At Mon, 07 Feb 2011 13:13:18 +0900 (JST),
> Ryusuke Konishi wrote:
> > 
> > On Mon, 07 Feb 2011 12:49:31 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> > > 
> > > At Sun, 06 Feb 2011 21:34:53 +0900 (JST),
> > > Ryusuke Konishi wrote:
> > > > 
> > > > On Sun,  6 Feb 2011 21:24:17 +0900, Ryusuke Konishi wrote:
> > > > > Fixes the following error on shutdown:
> > > > > 
> > > > > Traceback (most recent call last):
> > > > >   File "./nilfs2_ss_manager", line 211, in <module>
> > > > >     mainloop.run()
> > > > > TypeError: __exit__() takes exactly 1 argument (4 given)
> > > > > 
> > > > > Signed-off-by: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
> > > > 
> > > > There is a typo on the previous patch.
> > > > 
> > > > Please apply the following one instead.
> > > 
> > > Did you mean "follwoing" as "will send a new mail followed by this"
> > > or as "new patch contained in bottom of this mail" ?
> > 
> > I mean "new patch contained in bottom of this mail."
> > 
> > The second patch just fixes a typo "execinfo" -> "excinfo", where
> > "exc" is abbreviation of "exception" (not "execution").
> 
> Ah, I got it.
> 
> I applied this one and former series patches.
> 
> Thank you!
> 
> regards,

Thanks.

How about replacing the v0.1 package with v0.1.1 before moving on ?

Cheers,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
