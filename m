From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 2/2] nilfs2: add a print message after loading nilfs2
Date: Thu, 08 Apr 2010 16:21:41 +0900 (JST)
Message-ID: <20100408.162141.218082254.ryusuke@osrg.net>
References: <20100407142058.GA27224@xhl>
	<20100408.113405.221629738.ryusuke@osrg.net>
	<u2p3a3680031004072245t5ea476a5xbd6cbe6d3302de00@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <u2p3a3680031004072245t5ea476a5xbd6cbe6d3302de00-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 8 Apr 2010 13:45:05 +0800, Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 2010/4/8 Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>:
> > On Wed, 7 Apr 2010 22:20:58 +0800, Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> Hi KONISHI Ryusuke,
> >>
> >> Any feedbacks on these patches?
> >>
> >> Thanks,
> >> Li Hong
> >
> > Well, adding a load message is ok, but it should be more moderate like
> > "nilfs2 file system loaded\n".
> Yes. I just thought that printing a message after loading a file
> system is a practice.
> You may choose any string that you think is suitable :)

How about "NILFS version 2 loaded\n" ?

Seems that most messages have prefix "NILFS: ..." or "NILFS (device
%s):".
 
> > I think this sort of change should be discussed in the sub topic
> > mailing list (i.e. linux-nilfs).  You don't have to cc every patch to
> > linux-kernel.
> Ok. No problem.
> 
> > And, please include some explanation in the change log to clarify the
> > aim or motivation.
> I took it as a very simple patch and thought a header was enough. I can add more
> explanations if here has a demand.

You thought "printing a message after loading a file system is a
practice.", so it is the reason :)

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
