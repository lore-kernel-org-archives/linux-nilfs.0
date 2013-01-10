From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: New experience with the odd problem starting nilfs_cleanerd due
 to an eMMC misbehaviour
Date: Thu, 10 Jan 2013 18:00:59 +0400
Message-ID: <1357826459.2050.52.camel@slavad-ubuntu>
References: <20130110131659.GA29689@home.lan>
	 <1357824862.2050.48.camel@slavad-ubuntu> <20130110134907.GB29689@home.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=+EmhUxXTCeXs4s7KKlxAI6Pr+6YkAHdMmzquy3YwR7Q=;
	b=lWaJu7NveycJH/UWVfH8xIRgJKzaApttULJSLeJnms60QXN3G0h68aoW2jkokAFxMtPRdFh6eNh5IP+/D8ZsFmZqFAsaLhyLgnN9WfxLCZ6K6x81aaBjEz5YIF61Oo3P;
In-Reply-To: <20130110134907.GB29689-0MSThuzptbI@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paul Fertser <fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 2013-01-10 at 17:49 +0400, Paul Fertser wrote:
> Hi,
> 
> On Thu, Jan 10, 2013 at 05:34:22PM +0400, Vyacheslav Dubeyko wrote:
> > On Thu, 2013-01-10 at 17:16 +0400, Paul Fertser wrote:
> > > I've reported this issue earlier and back then it "resolved itself"
> > > after a power-cycle. The hardware in question is the same ac100
> > > netbook with an internal 32GB eMMC.
> > > 
> > > On nilfs_cleanerd start i was consistently getting these messages:
> > > [   46.122096] mmcblk0: error -110 transferring data, sector 26671630, nr 10, card status 0x200900
> > > [   48.934623] mmcblk0: error -110 transferring data, sector 26671631, nr 9, card status 0x200900
> > > (and similar output for two other sectors)
> > > 
> > > However, this time was different, several full power cycles didn't
> > > help and the read was still failing and cleanerd refused to start.
> > > 
> > 
> > Could you share system log content and strace of nilfs_cleanerd's trying
> > to start in the case of the issue? It needs for the beginning of the
> > issue understanding. Please, set in the nilfs_cleanerd.conf debug level.
> 
> Eh, sorry, i was too involved in thinking about how to fix the issue
> and so haven't saved any extra logs :(
> 

Anyway, thank you for the report.

> > Could you made raw dump of bad sectors? Could you share dumpseg output
> > for segments which contains the bad sectors?
> 
> The bad sectors in question were unreadable with dd, it just hanged
> for a moment and an additional error -110 was output to dmesg.
> 
> > So, I need to think how to investigate your issue without availability
> > of eMMC. :-)
> 
> I think you can reproduce something similar with loopback mounting if
> you modify the driver to return read error for some particular sectors
> that cleanerd wants to access when it starts cleaning.
> 

Yes, it is a good idea. I'll try it. But I worry only that it is
possible to investigate not the issue that was reported by you.

Thanks,
Vyacheslav Dubeyko.

> Sorry again for not having saved enough details.
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
