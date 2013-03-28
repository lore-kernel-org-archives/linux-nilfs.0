From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Thu, 28 Mar 2013 22:22:52 +0300
Message-ID: <E24177B1-2EF0-4274-BD13-4642E3663D08@dubeyko.com>
References: <50A5737C.2040805@li.ru> <201211160313.AA04185@capsicum.lab.ntt.co.jp> <50A65588.3000205@li.ru> <CAKFNMomO6ebYkXk=A9H2Wieswvogt6dj16Otj0u74M4aHOOPBg@mail.gmail.com> <20121127151924.GW4028@wloczykij> <295B3FE7-A44E-4D57-9A6A-B725EF1BA9EB@dubeyko.com> <20121128142116.GY4028@wloczykij> <1354113560.2017.11.camel@slavad-ubuntu> <20121128205943.GZ4028@wloczykij> <1354172459.2077.11.camel@slavad-ubuntu> <20130328120700.GK1672@wloczykij>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=ohVxhliX9wyXna34Mxb0TDWnj9dHD0uiKYppwaXtGAg=;
	b=TXTUUoOFeszPQqF+xLC8vGWAMPtRVlRJeY4QMhi1MCAZSayAkJiHPyhXcYjBYESJGmtqi47M/DHsQWBm+dA2aszldV8YTx25vHbZxjSM/A/ZtI1RJ1rAjPwSWRmoBO51;
In-Reply-To: <20130328120700.GK1672@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Piotr,

On Mar 28, 2013, at 3:07 PM, Piotr Szymaniak wrote:

> On Thu, Nov 29, 2012 at 11:00:59AM +0400, Vyacheslav Dubeyko wrote:
>> Thank you.
> 
> Got this issue again (sincerely, I'm a bit lost and don't remember if
> there was a patch for this?)
> 
> 
>> I think that it needs to use such tools for the issue investigation:
>> 1. echo t > /proc/sysrq-trigger should tell us what the flusher is
>> doing.
> 
> Attached.
> 

Thank you for additional details. Unfortunately, your sysrq-trigger output is not complete. So, I can't make conclusion about what operation was a reason of issue on your side. Could you send to me the full log of sysrq-trigger output?

I can easily reproduce the issue by big file (100 - 500 GB) deletion or truncation. Please, find description in: http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01504.html.

This issue doesn't fixed yet. The issue has complex nature. I described the reason of the issue in e-mail: http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01547.html. I think that the issue requires long-term implementation efforts. First of all, it makes sense to implement extents support. If it doesn't resolve the issue completely then it needs to implement special technique of file deletion/truncation or to modify technique working with checkpoints.

Currently, I don't start this implementation because of investigation of the issue with "bad b-tree node" issue. I have reproduction path for the issue (http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01558.html) and I am trying to localize the reason of the issue. But I worry that I can reproduce this issue for 1 KB block size. So, it can be a 1 KB block size related issue.

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
