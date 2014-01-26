From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 0/5] nilfs-utils: skip inefficient gc operations
Date: Sun, 26 Jan 2014 11:36:25 +0100
Message-ID: <52E4E529.3090803@gmx.net>
References: <FC7F25C5-1E72-4DF5-B860-FBCE36E91EAB@dubeyko.com>	<52E27651.6070207@gmx.net>	<82ACC3FC-BE83-483F-99D8-D13F4D02C58F@dubeyko.com> <20140126.155740.56352351.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140126.155740.56352351.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-01-26 07:57, Ryusuke Konishi wrote:
> On Sat, 25 Jan 2014 19:33:42 +0300, Vyacheslav Dubeyko wrote:
>>
>> On Jan 24, 2014, at 5:18 PM, Andreas Rohner wrote:
>>
>>>>> You have to move the live blocks to a new segment, so you gain only (8
>>>>> MB - live_blocks) of free space.
>>>>
>>>> You always will have 8 MB after cleaning (garbage collection).  So, all segments
>>>> are identical from the free space point of view. What does GC check? And how
>>>> can GC distinguish segments on the basis of free space? All cleaned segments
>>>> return 8 MB free space for further allocation. So, all used segments will be over
>>>> any threshold.
>>>
>>> I am sorry if I wasn't clear enough. The invalidated blocks in a segment
>>> are basically unusable free space, that needs to be garbage collected.
>>> If you clean a segment you only gain the space of the invalidated
>>> blocks, from the perspective of the whole file system. Of course the
>>> whole segment is free after cleaning, but the live blocks were moved
>>> somewhere else and occupy space there. So from the perspective of the
>>> whole file system you only really gained the amount of space occupied by
>>> the invalidated blocks.
>>>
>>
>> I suggest not to use "free blocks" term for the case of invalidated blocks.
>> Because it is really confusing way. I suppose that we can use term
>> "invalid blocks" or "dead blocks". But I think that "dead blocks" is not
>> good way too. Because, from my point of view, invalidated blocks are
>> blocks that keep previous state of actual blocks. Dead block sounds for
>> me likewise unusable or bad block.
> 
> "free blocks" term sounds confusing.  We often use terms
> "live" and "dead" for garbage collection, but "dead blocks" also
> sounds unfit to me as Vyacheslav pointed out.
> 
> How about "min reclaimable blocks" or "min collectable blocks" ?

Ok I will also change the config options accordingly. I like the term
"reclaimable blocks".

Regards,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
