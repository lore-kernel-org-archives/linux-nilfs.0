From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 9/9] nilfs2: prevent starvation of segments protected
 by snapshots
Date: Mon, 01 Jun 2015 16:45:39 +0200
Message-ID: <556C7013.3050702@gmx.net>
References: <555F70FD.6090500@gmx.net>	<20150601.014550.269184778137708369.konishi.ryusuke@lab.ntt.co.jp>	<556B4F58.9080801@gmx.net> <20150601.094441.24658496988941562.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150601.094441.24658496988941562.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2015-06-01 02:44, Ryusuke Konishi wrote:
> On Sun, 31 May 2015 20:13:44 +0200, Andreas Rohner wrote:
>> On 2015-05-31 18:45, Ryusuke Konishi wrote:
>>> On Fri, 22 May 2015 20:10:05 +0200, Andreas Rohner wrote:
>>>> On 2015-05-20 16:43, Ryusuke Konishi wrote:
>>>>> On Sun,  3 May 2015 12:05:22 +0200, Andreas Rohner wrote:
> [...]
>>>>>  3. The ratio of the threshold "max_segblks" is hard coded to 50%
>>>>>     of blocks_per_segment.  It is not clear if the ratio is good
>>>>>     (versatile).
>>>>
>>>> The interval and percentage could be set in /etc/nilfs_cleanerd.conf.
>>>>
>>>> I chose 50% kind of arbitrarily. My intent was to encourage the GC to
>>>> check the segment again in the future. I guess anything between 25% and
>>>> 75% would also work.
>>>
>>> Sound reasonable.
>>>
>>> By the way, I am thinking we should move cleanerd into kernel as soon
>>> as we can.  It's not only inefficient due to a large amount of data
>>> exchange between kernel and user-land, but also is hindering changes
>>> like we are trying.  We have to care compatibility unnecessarily due
>>> to the early design mistake (i.e. the separation of gc to user-land).
>>
>> I am a bit confused. Is it OK if I implement this functionality in
>> nilfs_cleanerd for this patch set, or would it be better to implement it
>> with a workqueue in the kernel, like you've suggested before?
>>
>> If you intend to move nilfs_cleanerd into the kernel anyway, then the
>> latter would make more sense to me. Which implementation do you prefer
>> for this patch set?
> 
> If nilfs_cleanerd will remain in userland, then the userland
> implementation looks better.  But, yes, if we will move the cleaner
> into kernel, then the kernel implementation looks better because we
> may be able to avoid unnecessary API change.  It's a dilemma.
> 
> Do you have any good idea to reduce or hide overhead of the
> calibration (i.e. traversal rewrite of sufile) in regard to the kernel
> implementation ?
> I'm inclined to leave that in kernel for now.

I haven't looked into that yet, so I don't have a good idea right now. I
will do some experiments. The good thing is, that the calibration does
not have to happen all at once and we do not have to do it all in one
iteration. The only question is how to best split up the work and keep
track of the progress.

If it turns out to be too complicated to do it in the kernel, I will go
for the userspace solution.

Regards,
Andreas Rohner

> Regards,
> Ryusuke Konishi
> 
>>
>> Regards,
>> Andreas Rohner
>>
>>> Regards,
>>> Ryusuke Konishi
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
