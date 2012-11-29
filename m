From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Thu, 29 Nov 2012 11:00:59 +0400
Message-ID: <1354172459.2077.11.camel@slavad-ubuntu>
References: <50A5737C.2040805@li.ru>
	 <201211160313.AA04185@capsicum.lab.ntt.co.jp> <50A65588.3000205@li.ru>
	 <CAKFNMomO6ebYkXk=A9H2Wieswvogt6dj16Otj0u74M4aHOOPBg@mail.gmail.com>
	 <20121127151924.GW4028@wloczykij>
	 <295B3FE7-A44E-4D57-9A6A-B725EF1BA9EB@dubeyko.com>
	 <20121128142116.GY4028@wloczykij> <1354113560.2017.11.camel@slavad-ubuntu>
	 <20121128205943.GZ4028@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=dqqeT0JTR6eo9mpcCigAN0oG6g8s93O+/rfMeVcCB2w=;
	b=BeUGjDo41+qxU/XAE8qHjd4OQd+3H7JcjZ4MrHtNmwMP3+IOOoI3yptPZS4t+qzIvUgXKnMwBdHUhRRq1r1ijsvGs+dWXLMYu9FMqArySjaSk+RVvYYQClmWW9vl2nvY;
In-Reply-To: <20121128205943.GZ4028@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 2012-11-28 at 21:59 +0100, Piotr Szymaniak wrote:
> On Wed, Nov 28, 2012 at 06:39:20PM +0400, Vyacheslav Dubeyko wrote:
> > On Wed, 2012-11-28 at 15:21 +0100, Piotr Szymaniak wrote:
> > > On Tue, Nov 27, 2012 at 08:43:01PM +0300, Vyacheslav Dubeyko wrote:
> > > > Could you describe the path of issue reproducing? What filesystem
> > > > operations took place near before the issue?
> > > 
> > > Reproduce: Use a computer with nilfs2? No idea... I notice this issue
> > > from time to time. I suppose it's more visible when the system is idle
> > > and then I notice a lot of CPU load without any reason (also as I wrote
> > > before - it stops immediately after runnig sync).
> > > 
> > 
> > Ok. Could you share output of "top" and "ps ax" for the case of issue
> > reproducing? These outputs can be helpful for beginning of analysis.
> 
> Already attached [1] "ps ax" output before. Don't know if top can get
> something usefull here, but I can try to "catch" it.
> 
> [1] http://www.spinics.net/lists/linux-nilfs/msg01481.html
> 

Thank you.

I think that it needs to use such tools for the issue investigation:
1. echo t > /proc/sysrq-trigger should tell us what the flusher is doing.
2. The /proc/meminfo and /proc/sys/vm/dirty_ratio output for the issue time can be also helpful.
3. It makes sense to use blktrace for getting I/O traces during flushing during sync command execution and near before issue was occurred. I/O traces can be useful for analysis but this output can contain huge info amount. So, I think first of all it needs to get info about what flusher doing during eating CPU time.

With the best regards,
Vyacheslav Dubeyko.


> Piotr Szymaniak.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
