From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [static superblock discussion] Does nilfs2 do any in-place
 writes?
Date: Thu, 30 Jan 2014 17:32:39 +0400
Message-ID: <1391088759.2637.13.camel@ubuntu>
References: <1389787304.3913.28.camel@slavad-ubuntu>
	 <20140116.002353.94325733.konishi.ryusuke@lab.ntt.co.jp>
	 <1389866912.2565.44.camel@slavad-ubuntu>
	 <20140118.090008.194171715.konishi.ryusuke@lab.ntt.co.jp>
	 <1390901114.2942.11.camel@slavad-ubuntu-12.04>
	 <CAFvQSYSu5CGxs+K6bZUCtq17PrS_paX3bXBuLBRTba_XWYGgAg@mail.gmail.com>
	 <71B2806D-7CF2-4992-A588-EB73EADFFF9F@dubeyko.com>
	 <CAFvQSYQ84_BsqVC_ZM77P92jkP+1dh7NexvZWg4mFE7B3wSK0A@mail.gmail.com>
	 <AE0F313D-5934-452B-80AB-5D691AF8A4BE@dubeyko.com>
	 <CAFvQSYQGDXmUit1zFZ9_LAjdLjxM-i_yR2L6pwFDX_BEdjdXxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=fRoVvOPJo/oSwpf746nTTHXtD+rjQHrjEs6TUZ8WmJQ=;
	b=iIZJW6RHCzneSXPPksoMXfqAbkdm+VEAYXpZWcP6XWeWzY+FZcOQw+cisIy6Dsm0N4AULtzfGjDvu/jq+Rq+RtKthPkqs8sA8T/enj758HT4ZgrMmfuXkKyoGyGN7Qq8;
In-Reply-To: <CAFvQSYQGDXmUit1zFZ9_LAjdLjxM-i_yR2L6pwFDX_BEdjdXxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Clemens,

On Thu, 2014-01-30 at 14:09 +0100, Clemens Eisserer wrote:
> Hi Vyacheslav,
> 
> 
> > I suppose that current implementation is not bad. And it is possible
> > to give what you want by simple management of superblock's
> > update timeout. Because and now superblock is updated on mount/umount
> > and with frequency is defined by some timeout.
> 
> What would happen in case of an unclean shutdown and a very large
> superblock update intervall (several hours)?
> As far as I understood, this is where Andreas' patch would come into play?
> 

The result of unclean shutdown and big update timeout will be a long
mount. And such issue was reported earlier and it was fixed. I don't
think that Andreas's patch can resolve long mount principally. Maybe
this approach can slightly reduce mount time in such situation.

> > Ok. But I can't see anything bad for my approach. Because primary reserved
> > area will be 8MB. So, if super root (and all other info) is 4KB, for example, then
> > we can do 2048 write operations without any erase operations.
> 
> The problem with this approach is, that there is a minimal write unit
> which size is dependant on the FTL - explained in the linaro wiki:
> 
> > The smallest write unit is significantly larger than a page.
> > Reading or writing less than one of these units causes a full unit to be accessed.
> > Trying to do streaming write in smaller units causes the medium to do multiple
> > read-modify-write cycles on the same write unit, which in turn causes multiple
> > garbage collection cycles for writing a single allocation group from start to end.
> 
> So updating 4kb pages in a linear fashion would cause
> read-modify-write cycles on most devices, with blocks as large as the
> mapping unit (for SD cards this often means a full erase block of
> several MBs).
> The chapter "FAT optimization" lists several of those caveats, I found
> it a very intersting and worthwhile reading.
> 

In such case NILFS2 at whole is in trouble. Because partial segments can
have different size. And these sizes doesn't correlate with sizes of
physical erase block or physical writing units. And the whole COW
approach is useless. Maybe some NAND chips have writing units larger
than page size. But in such case play on the on FTL side anyway.
Otherwise, it needs operate with pure NAND for the best efficiency. And
it is out of the NILFS2's scope.

With the best regards,
Vyacheslav Dubeyko.

> 
> Regards, Clemens
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
