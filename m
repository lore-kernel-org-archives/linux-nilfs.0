From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [static superblock discussion] Does nilfs2 do any in-place
 writes?
Date: Fri, 07 Feb 2014 10:43:14 +0400
Message-ID: <1391755394.15555.67.camel@ubuntu>
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
	 <1391088759.2637.13.camel@ubuntu>
	 <CAFvQSYQ-qkXz677-obgHVN5fLQiF10-A=T2yNNAHKRcOGm_Pqw@mail.gmail.com>
	 <720AFF13-6203-4A28-9850-3C2CAFF3B7BF@dubeyko.com>
	 <CAFvQSYStT4uwxqtxATLbPOvHYjww=sw=C=f3vBi_qdu6MXAn5A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=YevXAQRdsDpJ+iM8gN04xM1mxj2Th2n5GzphGzbqOHQ=;
	b=p7lzp8KRpenZkCi79UvgP+cIDkqJ8puqjmSpp3zeFJyJXz2U6upxTbfFBp7dE6AGinw32BtSw2ok4k5qabDjECWTnMAS+Ylq7ERoajnF6zV2goP0Z04A9SlXN9qQWpES;
In-Reply-To: <CAFvQSYStT4uwxqtxATLbPOvHYjww=sw=C=f3vBi_qdu6MXAn5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Clemens,

On Wed, 2014-02-05 at 21:47 +0100, Clemens Eisserer wrote:

> > Moreover, if you have FTL then you
> > expect that block layer will operate with 4 KB block sizes. Otherwise,
> > it means that you sell bad storage devices.
> 
> Efficient block sizes as small as 4K are only doable with a (DRAM)
> cache, which isn't a viable solution for small/cheap devices - even
> the best SD cards can't handle that efficiently. So those "bad storage
> devices" are unfortunately a common reality (sd/mmc cards, usb pen
> drives, ...).
> 
> When looking through the raspberry pi forums, you'll find a lot
> reports about dead SD cards, worn out where the ext4 journal or
> metadata was placed. I admit this is a very specific example, but
> quite a lot of embedded linux-powered solutions exist - and all of
> them I know boot from (micro-)SD cards. So an improvement in this
> situation (such as the mount option proposed by Andreas) could lower
> the pain for this quite wide-spread use-case, without altering the
> experience for present use-cases where nilfs2 does fine.

Ok. I think that one of the possible another approach can be such.

[1] We can place static superblock information (it is small size info)
at the begin of every segment. It will be more FTL-friendly than static
superblock at the begin and at the end of a volume.

[2] We can use delayed mount. I mean that it is possible to make
preliminary mount immediately without long searching or recovering. And
to start recovering thread in the background for the search of latest
log. Of course, in such way we haven't enough knowledge about whole
volume state immediately and we need some time for searching last log in
background. But, theoretically, we can access to information in RO mode
on reliable portion of volume before ending of recovering process in
background. But I understand that delayed mount is really arguable
suggestion. :) 

[3] We can divide NILFS2 volume on allocation groups that it will
contain several segments. And we can make searching of latest log on the
basis of such allocation group, firstly. Then it will be used usual way
of searching latest log inside a latest allocation group.

[4] We can have special area, in likewise way as I suggested previously,
that it can store special structures for more efficient search. This
area(s) will store information about allocation groups. It will be
recorded only on umount. This area information will be modified only in
memory between mount and umount. And this area can be divided and saved
by means of portions with size adequate to physical erase block size. I
think it is possible to have configuration parameter of such portion
size that can be used by user for tuning on mkfs or tunefs phases.

Of course, it is really raw considerations.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
