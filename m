From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 0/4] nilfs-utils: new feature to skip inefficient gc
Date: Mon, 20 Jan 2014 11:37:21 +0100
Message-ID: <52DCFC61.7050608@gmx.net>
References: <cover.1390139797.git.andreas.rohner@gmx.net> <1390211015.3034.54.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1390211015.3034.54.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,

On 2014-01-20 10:43, Vyacheslav Dubeyko wrote:
> Hi Andreas,
> 
> On Sun, 2014-01-19 at 15:01 +0100, Andreas Rohner wrote:
>> Hi,
>>
>> This patch set implements a small new feature and there shouldn't be
>> any compatibility issues. It enables the GC to check how much free
>> space can be gained from cleaning a segment and if it is less than a
>> certain threshold it will abort the operation and try a different
>> segment. Although no blocks need to be moved, the SUFILE entry of the
>> corresponding segment needs to be updated to avoid an infinite loop.
>>
> 
> Thank you for this patchset. Your efforts in GC direction is very
> important for NILFS2 users.
> 
> Anyway, I worried about compatibility. I think that it needs to analyze
> more deeply how NILFS2 file system driver is ready for this change. I
> think that it needs to describe briefly and in more details your
> approach in patchset description. Do you try to analyze what potential
> side effects can add your pathset? Could you describe your vision of
> this patchset sanity?

Ok I will try to go into more detail in version 2. It is just a simple
threshold to avoid the worst case behaviour of the timestamp policy. I
don't think, that there should be any compatibility issues, aside from
those pointed out by Ryusuke, which I am going to fix. The only side
effect I can think of is, if the threshold is set too high, and a lot of
segments don't get cleaned.

>> Admittedly the benchmark is a bit biased to highlight the problem. On a
>> real system the static data won't be so completely static and so the
>> performance improvements are probably not so extreme.
>>
> 
> I think that it really needs to test this patchset by xfstests and
> fsstress (part of LTP test suite) tools. What do you think?
> 
> Moreover, I think that it makes sense to use well-known benchmark suite
> (or several) for testing and estimation.

Yes you are right. I will try to use another benchmark. But it is hard
to use well-known benchmarks to test the GC, because they are designed
to test different things. Either not enough data is written and the GC
never starts or too much and the benchmark crashes with a "not enough
space left on the device" error. I don't know if xfstests or fsstress
can be tuned for my purposes, but I will look into it.

>> This is my first patch set to this mailing list. I hope 
>> everything is formally correct.
>>
>> Best regards,
>> Andreas Rohner
>>
> 
> Usually, here it is used special delimiter ("--") here. But I don't
> think that it is critical.

Thanks

> 
> And it is expected branch version here, usually. :)
> 

Thanks again

Best regards,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
