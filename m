From: ales-76-9Vj9tDbzfuSlVyrhU4qvOw@public.gmane.org
Subject: =?us-ascii?Q?Re=3A=20NILFS=20information=20request?=
Date: Thu, 15 Apr 2010 04:04:46 +0200 (CEST)
Message-ID: <4295.961.1861-15983-889932823-1271297086@seznam.cz>
References: <0580A275-B1BA-47D3-9650-486339F8A12D@xs4all.nl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0580A275-B1BA-47D3-9650-486339F8A12D-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; delsp="yes"; format="flowed"
To: =?us-ascii?Q?Vincent=20Diepeveen?= <diep-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vincent,


> Same stability problems with ext3 and software raid-0 in linux  
> kernel. Always problems.

That is suprising, I do use software RAID in Linux (RAID-5) with Ext4 and it works without a hiccup. I must admit the system is very lightly loaded. Rebuilt times are terrible though. Harvard uni. have their Lustre OSD nodes with Linux software RAID, so I guess if it is stable enough for them...

> However according to logical thinking you first say that i should  
> consider Reiser-FS for doing a lot of low latency reads and now  
> suddenly must consider NILFS for exactly the same thing?
> 
> I'm not following that logics. Can you explain?

Well, NILFS (as any other log-structured file system) is by design optimized for writes. Random reads from a magnetic disk would be rather slow (that holds for any file system of course). But with SSD it is a different story. Because the penalty for rotational latency and seeks disappears reads are fast and thanks to continuous nature of all writes in log-structured file system the write performance is excellent. So generaly the log-structured file systems are very well suited for flash devices. Google some benchmarks with NILFS on SSD. Personaly on SSDs I wouldn't use anything but NILFS. As soon as it is marked stable, that is.

> > or keep the whole working set in memory (which is usually  
> > prohibitive in terms of price).
> 
Chaining really happens a lot  
> there; a core that is doing a read now
> has a high chance of doing a read next time also. In fact odds are  
> good it is a read to a position closeby a previous done read, which  
> is why i cache it in the RAM with some small
> buffer.
> 
> Say a gigabyte of RAM or so in total for all caches of all cores  
> together.

By keeping whole set in memory I ment to avoid IO completely - like in-memory databases. In common PC server you can use around 192GB max. today. So, even if you could afford so much RAM your working set wouldn't probably fit in.

> Yeah so they say Amazon personnel living in the clouds (computing)  
> might have plenty of time right now spamming the net...
> 
> Let's hope discussion is about NILFS here :)

Yes, sure. My point was just that there are differrent horses for differrent courses.

Have a nice day

Ales Blaha
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
