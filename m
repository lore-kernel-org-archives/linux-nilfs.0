From: =?ISO-8859-15?Q?Niccol=F2_Belli?= <darkbasic-DEeHIYRtcplPMsqi6aon0Q@public.gmane.org>
Subject: Re: nilfs2 per directory quota
Date: Sun, 26 Jun 2011 15:01:45 +0200
Message-ID: <4E072DB9.10704@linuxsystems.it>
References: <4E070070.1060502@linuxsystems.it> <201106261346.31869.dexen.devries@gmail.com> <4E071EF5.1070301@linuxsystems.it> <201106261448.30236.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=linuxsystems.it;
	s=linuxsystems.it; t=1309093467;
	bh=pXAA6WCyhmHE9eEaMrVQZlRK8pjvDCQzWZPyt7up/Jk=;
	h=Message-ID:Date:From:MIME-Version:To:CC:Subject:References:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=QOHouuzS928WMW9mfbKHABuD4PAIaUYMTKJ7KHNOraS5AVGa7opZjbHGmw5RBp4Mh
	 IjWXQXBQmV0XtryO90gb+/1LuWqMIpe0bWXsThE7KbUa/vICsXbBj3HIb380fH2ufR
	 pmrA3IW0gCmxJyClkzj3vlvtYNGdZPhc55IKrrUA=
In-Reply-To: <201106261448.30236.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jonathan-kE54VaY6i3AJ3nxcUk3PyQ@public.gmane.org, augsdo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Il 26/06/2011 14:48, dexen deVries ha scritto:
> I'm affraid the meaning of the post is ``I wish NILFS provided those:'' (the 
> ``but how about having some real features'' bit).

You're right, the expectations were so high that I assumed it was an
implemented featured :(

> You may also want to check out
> http://en.wikipedia.org/wiki/Fossil_(file_system)
> http://en.wikipedia.org/wiki/Venti
> which are available on any POSIX  environment via 
> http://en.wikipedia.org/wiki/Plan_9_port
> 
> I don't think Fossil provides any quota support, but when coupled with Venti, 
> it pretty much removes the need for it :P

I also read about fusequota (http://code.google.com/p/fusequota/) but it
seems more like a personal experiment rather then something you can use
in a production environment (and it seems no longer developed too).

Cheers,
Darkbasic
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
