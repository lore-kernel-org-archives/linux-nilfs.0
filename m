From: =?ISO-8859-15?Q?Niccol=F2_Belli?= <darkbasic-DEeHIYRtcplPMsqi6aon0Q@public.gmane.org>
Subject: Re: nilfs2 per directory quota
Date: Sun, 26 Jun 2011 13:58:45 +0200
Message-ID: <4E071EF5.1070301@linuxsystems.it>
References: <4E070070.1060502@linuxsystems.it> <201106261346.31869.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=linuxsystems.it;
	s=linuxsystems.it; t=1309089686;
	bh=9aGOoTGDrv+1UgnARHEzEThX6fhNakT9jzzpiYfJy9M=;
	h=Message-ID:Date:From:MIME-Version:To:CC:Subject:References:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=IAjf/mPyOtI7EIczqeUEqQxfUR7ysVH/50SIgA2TLjQ8QueYiKqyxOHQ46tn750FY
	 Cuy3tEKJLdO20XhWtrHo5xbRtqqLQSpBW8XGWREmKJ15OPEg/AkWNCTYGcWPJApRgm
	 jgyI5H0BBOzm2OO/LjcNlFsNiUTyRe9m5/saW+l4=
In-Reply-To: <201106261346.31869.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jonathan-kE54VaY6i3AJ3nxcUk3PyQ@public.gmane.org

Hi,

Il 26/06/2011 13:46, dexen deVries ha scritto:
> casually looking through NILFS2 sources, I don't see quota support, but I may 
> be wrong there.

I read about per directory quotas in slashdot:
http://linux.slashdot.org/comments.pl?sid=1287319&cid=28536529


> Why isn't XFS a viable option for you, if I may?

XFS *is* a viable option, but it was a chance to test a new fs ;)


Cheers,
Darkbasic
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
