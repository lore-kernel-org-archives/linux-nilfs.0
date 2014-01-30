From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [static superblock discussion] Does nilfs2 do any in-place writes?
Date: Thu, 30 Jan 2014 15:42:24 +0300
Message-ID: <AE0F313D-5934-452B-80AB-5D691AF8A4BE@dubeyko.com>
References: <1389787304.3913.28.camel@slavad-ubuntu> <20140116.002353.94325733.konishi.ryusuke@lab.ntt.co.jp> <1389866912.2565.44.camel@slavad-ubuntu> <20140118.090008.194171715.konishi.ryusuke@lab.ntt.co.jp> <1390901114.2942.11.camel@slavad-ubuntu-12.04> <CAFvQSYSu5CGxs+K6bZUCtq17PrS_paX3bXBuLBRTba_XWYGgAg@mail.gmail.com> <71B2806D-7CF2-4992-A588-EB73EADFFF9F@dubeyko.com> <CAFvQSYQ84_BsqVC_ZM77P92jkP+1dh7NexvZWg4mFE7B3wSK0A@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=vdW9WfME7Yl4G6yy+YvftiIJijL7CLRchr/1uio4qnU=;
	b=KY48s0/Eu7wZIgutZGI6Vv1DxCleHFNjdlpoB10/dnKAQ+eh6abNffDSxnqmRurRGiysprsTnOHvylhnfKGrAHMfWFlDvC3oQqQXzXvgQlcoaNE+v6MVdnNmH3GlvcTe;
In-Reply-To: <CAFvQSYQ84_BsqVC_ZM77P92jkP+1dh7NexvZWg4mFE7B3wSK0A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Clemens,

On Jan 30, 2014, at 1:09 PM, Clemens Eisserer wrote:

> Hi Vyacheslav,
> 
>> So, as a result, when you are talking about logical block placement
>> then it doesn't mean that you are talking about writes in few physical
>> erase blocks. Because only mapping table of FTL knows what physical
>> erase blocks are changed really.
> ntly).
> 
> For powerful FTL/controllers it almost doesn't make a difference
> whether you write in-place or in the "almost random" style you
> propose.
> Those FTLs usually have a fully associative fine-grained
> physical-to-logical mapping, so they also can distribute the wear
> evenly across the entire NAND.
> 

I suppose that current implementation is not bad. And it is possible
to give what you want by simple management of superblock's
update timeout. Because and now superblock is updated on mount/umount
and with frequency is defined by some timeout.

> However there are also FTLs (SD cards, managed NAND, ...) arround
> which do only mapping on erase-block level, with limited associativity
> - often lacking a random write unit.
> So each logical block is mapped to one of n possible physical erase
> blocks (for SD cards 4MB erase blocks are quite common) and for each
> single write a full erase block has to be erased. And as there are
> only n physcial blocks which can be mapped to this logical block, the
> card pretty soon starts to develop bad sectors (even worse, these days
> often cheap TLC flash is used limited to < 500 erase cycles).
> 

Ok. But I can't see anything bad for my approach. Because primary reserved
area will be 8MB. So, if super root (and all other info) is 4KB, for example, then
we can do 2048 write operations without any erase operations. It means that
if you will save super root for every full segment then you need to fill 16 GB of
volume by data. I think that if reserved area will be fully filled with one iteration
of whole volume filling then it will good policy for any FTL. As a result, if you will
save super root after 10 segments construction then it will be 160 GB volume;
to save super root for 100 segments construction -> 1 TB volume. Moreover,
it is possible to distribute load between two areas (primary and secondary) and
to increase size of reservation. And it gives opportunity to decrease count
of segments between super roots saving in reserved areas.

> The linaro guys did a survey on this some time ago:
> https://wiki.linaro.org/WorkingGroups/KernelArchived/Projects/FlashCardSurvey
> Very interesting is the paragraph about "Access modes", there are
> still a lot of controllers which don't feature a random write unit.
> 

Thank you for the link.

Thanks,
Vyacheslav Dubeyko.

>> We know about clean (or unclean) umount from the superblock.
>> So, you should update superblock for keeping such knowledge.
>> Otherwise, you will need to perform linear scan always.
>> I don't quite follow your thought. If we will not update superblock then
>> how we can save any changes in superblock?
> 
> Only update the superblock at mount/unmount time, and do a linear scan
> in the case of an unclean shutdown.
> 
> Thanks, Clemens

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
