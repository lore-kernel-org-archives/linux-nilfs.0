From: Paul Fertser <fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: New experience with the odd problem starting nilfs_cleanerd
	due to an eMMC misbehaviour
Date: Thu, 10 Jan 2013 17:49:07 +0400
Message-ID: <20130110134907.GB29689@home.lan>
References: <20130110131659.GA29689@home.lan> <1357824862.2050.48.camel@slavad-ubuntu>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=IAO9bnV/lf3ChOSWpB0gqhMv4Lsm++E0DMsnxgUFdnc=;
        b=C20+bJaF3AfTMk5Gvs1aFCjLTaswYUGcr2y6RwyE7R9C7SGVE+sRQ4AQf4qXDjERNF
         9hRuzhddTkbHfDpjtmNlzmJCqjrLpqP2yT/CnR/42njvkNXzxaZ1J2+M00PNJr0OfZ8o
         GtMFJLyWfBZXERvF89ooBoT4kqWsiC8zG2Q+eQzvF8BjZq+A6wqy57GR+IwgmbgbzoCV
         LmvcIuhby8EU6vQ97ecVbvm4Dk6MWT/j0Lipd0fW97vu9J++YnW3WoJW76ZtycOeNt7f
         4fK1iXgyl0GnIdLKpEaTyGkpTrQ+IifJ/KqQPfurLHAVbwYWX3XYIMbisTXsh76icFuw
         F+Qg==
Content-Disposition: inline
In-Reply-To: <1357824862.2050.48.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Thu, Jan 10, 2013 at 05:34:22PM +0400, Vyacheslav Dubeyko wrote:
> On Thu, 2013-01-10 at 17:16 +0400, Paul Fertser wrote:
> > I've reported this issue earlier and back then it "resolved itself"
> > after a power-cycle. The hardware in question is the same ac100
> > netbook with an internal 32GB eMMC.
> > 
> > On nilfs_cleanerd start i was consistently getting these messages:
> > [   46.122096] mmcblk0: error -110 transferring data, sector 26671630, nr 10, card status 0x200900
> > [   48.934623] mmcblk0: error -110 transferring data, sector 26671631, nr 9, card status 0x200900
> > (and similar output for two other sectors)
> > 
> > However, this time was different, several full power cycles didn't
> > help and the read was still failing and cleanerd refused to start.
> > 
> 
> Could you share system log content and strace of nilfs_cleanerd's trying
> to start in the case of the issue? It needs for the beginning of the
> issue understanding. Please, set in the nilfs_cleanerd.conf debug level.

Eh, sorry, i was too involved in thinking about how to fix the issue
and so haven't saved any extra logs :(

> Could you made raw dump of bad sectors? Could you share dumpseg output
> for segments which contains the bad sectors?

The bad sectors in question were unreadable with dd, it just hanged
for a moment and an additional error -110 was output to dmesg.

> So, I need to think how to investigate your issue without availability
> of eMMC. :-)

I think you can reproduce something similar with loopback mounting if
you modify the driver to return read error for some particular sectors
that cleanerd wants to access when it starts cleaning.

Sorry again for not having saved enough details.

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
