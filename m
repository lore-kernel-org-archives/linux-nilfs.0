From: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [static superblock discussion] Does nilfs2 do any in-place writes?
Date: Thu, 30 Jan 2014 14:09:07 +0100
Message-ID: <CAFvQSYQGDXmUit1zFZ9_LAjdLjxM-i_yR2L6pwFDX_BEdjdXxQ@mail.gmail.com>
References: <1389787304.3913.28.camel@slavad-ubuntu>
	<20140116.002353.94325733.konishi.ryusuke@lab.ntt.co.jp>
	<1389866912.2565.44.camel@slavad-ubuntu>
	<20140118.090008.194171715.konishi.ryusuke@lab.ntt.co.jp>
	<1390901114.2942.11.camel@slavad-ubuntu-12.04>
	<CAFvQSYSu5CGxs+K6bZUCtq17PrS_paX3bXBuLBRTba_XWYGgAg@mail.gmail.com>
	<71B2806D-7CF2-4992-A588-EB73EADFFF9F@dubeyko.com>
	<CAFvQSYQ84_BsqVC_ZM77P92jkP+1dh7NexvZWg4mFE7B3wSK0A@mail.gmail.com>
	<AE0F313D-5934-452B-80AB-5D691AF8A4BE@dubeyko.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=gNBHIYlAarGvGYrKdKl29HygVbzuL+8glAktHV/1GXM=;
        b=xvm/GTbJ84XKuVcTCfyDCfg8snetINqYVGCVK307wGEVfKA7NGxO/hZwA5ahCB4hmo
         GVyI969E9/g7np0iqmfqeacfsOnOd8CHFGD4GcPcqJDHTKQPeiIMmCjPuNH+LoTNi0vt
         GmDKCu+yJiq3TA83YOI++pjbMFTKZLKAcbQXHwVabI5g82Qt4NTim6jl5h3t9hfBxDmF
         erqAUKfaNhze5gh0TvzHn62tZbgxu/m2WkdSeswbqmBmdZ63qKguQ4LSb8q4Y6aSdAr6
         MtTrf9m7GmwadDkDKRm5YocCaP5t3RZpMhbmaGYD+LC9MvsKh1ASaQ40LGF4u3cHdFgb
         xdbQ==
In-Reply-To: <AE0F313D-5934-452B-80AB-5D691AF8A4BE-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,


> I suppose that current implementation is not bad. And it is possible
> to give what you want by simple management of superblock's
> update timeout. Because and now superblock is updated on mount/umount
> and with frequency is defined by some timeout.

What would happen in case of an unclean shutdown and a very large
superblock update intervall (several hours)?
As far as I understood, this is where Andreas' patch would come into play?

> Ok. But I can't see anything bad for my approach. Because primary reserved
> area will be 8MB. So, if super root (and all other info) is 4KB, for example, then
> we can do 2048 write operations without any erase operations.

The problem with this approach is, that there is a minimal write unit
which size is dependant on the FTL - explained in the linaro wiki:

> The smallest write unit is significantly larger than a page.
> Reading or writing less than one of these units causes a full unit to be accessed.
> Trying to do streaming write in smaller units causes the medium to do multiple
> read-modify-write cycles on the same write unit, which in turn causes multiple
> garbage collection cycles for writing a single allocation group from start to end.

So updating 4kb pages in a linear fashion would cause
read-modify-write cycles on most devices, with blocks as large as the
mapping unit (for SD cards this often means a full erase block of
several MBs).
The chapter "FAT optimization" lists several of those caveats, I found
it a very intersting and worthwhile reading.


Regards, Clemens
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
