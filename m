From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Wed, 28 Nov 2012 18:39:20 +0400
Message-ID: <1354113560.2017.11.camel@slavad-ubuntu>
References: <50A5737C.2040805@li.ru>
	 <201211160313.AA04185@capsicum.lab.ntt.co.jp> <50A65588.3000205@li.ru>
	 <CAKFNMomO6ebYkXk=A9H2Wieswvogt6dj16Otj0u74M4aHOOPBg@mail.gmail.com>
	 <20121127151924.GW4028@wloczykij>
	 <295B3FE7-A44E-4D57-9A6A-B725EF1BA9EB@dubeyko.com>
	 <20121128142116.GY4028@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=XUE/pNcWTn3JWB2odtAhfKkcKsMVyMHw4V27fIUaokI=;
	b=DHjTRhWW0BOkSJNNyoplb7I1Xtx6H7Gwi9CpXyTbMmBalwC+h2rzOGutmT4IlCovXGE9o7ckmAvYLMl/9TiXuzjSdWoIWeDMsCeb+1QcBnMc2/mx1PcfuBx5eP5E6Pmt;
In-Reply-To: <20121128142116.GY4028@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, fwdnilfsml.to.11df-2pMamKoQTv4@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 2012-11-28 at 15:21 +0100, Piotr Szymaniak wrote:
> On Tue, Nov 27, 2012 at 08:43:01PM +0300, Vyacheslav Dubeyko wrote:
> > Could you describe the path of issue reproducing? What filesystem
> > operations took place near before the issue?
> 
> Reproduce: Use a computer with nilfs2? No idea... I notice this issue
> from time to time. I suppose it's more visible when the system is idle
> and then I notice a lot of CPU load without any reason (also as I wrote
> before - it stops immediately after runnig sync).
> 

Ok. Could you share output of "top" and "ps ax" for the case of issue
reproducing? These outputs can be helpful for beginning of analysis.

With the best regards,
Vyacheslav Dubeyko.

> 
> Piotr Szymaniak.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
