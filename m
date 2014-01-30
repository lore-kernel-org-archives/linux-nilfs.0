From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [static superblock discussion] Does nilfs2 do any in-place writes?
Date: Thu, 30 Jan 2014 18:27:17 +0300
Message-ID: <720AFF13-6203-4A28-9850-3C2CAFF3B7BF@dubeyko.com>
References: <1389787304.3913.28.camel@slavad-ubuntu> <20140116.002353.94325733.konishi.ryusuke@lab.ntt.co.jp> <1389866912.2565.44.camel@slavad-ubuntu> <20140118.090008.194171715.konishi.ryusuke@lab.ntt.co.jp> <1390901114.2942.11.camel@slavad-ubuntu-12.04> <CAFvQSYSu5CGxs+K6bZUCtq17PrS_paX3bXBuLBRTba_XWYGgAg@mail.gmail.com> <71B2806D-7CF2-4992-A588-EB73EADFFF9F@dubeyko.com> <CAFvQSYQ84_BsqVC_ZM77P92jkP+1dh7NexvZWg4mFE7B3wSK0A@mail.gmail.com> <AE0F313D-5934-452B-80AB-5D691AF8A4BE@dubeyko.com> <CAFvQSYQGDXmUit1zFZ9_LAjdLjxM-i_yR2L6pwFDX_BEdjdXxQ@mail.gmail.com> <1391088759.2637.13.camel@ubuntu> <CAFvQSYQ-qkXz677-obgHVN5fLQiF10-A=T2yNNAHKRcOGm_Pqw@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=br69ZkJ8/cXA9Sl9L5DwPTZVeMlGtT+whfGyiFiHsM4=;
	b=IF37yq6EAQpCz37t9CU6vOPnJrfjtudO5OWQch1ZMnHYsvzBbng4tCxedBBHaGfRj/dHVnBepEYo5na6i+FTCoODZur7OXTvlJW2nDka5IQ1z0kqte/YyzbzYeYxOXn+;
In-Reply-To: <CAFvQSYQ-qkXz677-obgHVN5fLQiF10-A=T2yNNAHKRcOGm_Pqw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Clemens Eisserer <linuxhippy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Clemens,

On Jan 30, 2014, at 5:03 PM, Clemens Eisserer wrote:

> Hi Vyacheslav,
> 
>> The result of unclean shutdown and big update timeout will be a long
>> mount. And such issue was reported earlier and it was fixed. I don't
>> think that Andreas's patch can resolve long mount principally. Maybe
>> this approach can slightly reduce mount time in such situation.
> 
> So even without Andreas' patch there is no risk for data loss with a
> very outdated superblock - but recovery would be slower?
> 

Yes, recovery will be really slower. And recovery mechanisms defend from
data loss in reasonable way. I mean that some data can be lost during
unsuccessful flushes. But I am afraid that current state of Andreas's patch
breaks some recovery mechanisms (but maybe I am wrong).

>> In such case NILFS2 at whole is in trouble. Because partial segments can
>> have different size. And these sizes doesn't correlate with sizes of
>> physical erase block or physical writing units. And the whole COW
>> approach is useless.
> 
> Sure, NILFS won't cure the horrible write-amplification of those
> devices, but it will spread the wear evenly over the whole device
> thanks to COW.
> So it won`t wear out the meadia faster where it`s metadata is stored
> (with exception of the superblock) like ext4 does.
> Btw. isn't nilfs's minimal writing size 128kb (I remember I read it in
> a paper somewhere)?

But, anyway, how 128 KB correlates with physical erase blocks or
physical writing units size? :) Physical sizes can be much more and 128 KB
unable to defend from all possible situations. Sure, there isn't good
approach for all cases of real life. Moreover, if you have FTL then you
expect that block layer will operate with 4 KB block sizes. Otherwise,
it means that you sell bad storage devices.

Thanks,
Vyacheslav Dubeyko.

> 
> Regards, Clemens

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
