From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 0/5] nilfs-utils: skip inefficient gc operations
Date: Sat, 25 Jan 2014 19:33:42 +0300
Message-ID: <82ACC3FC-BE83-483F-99D8-D13F4D02C58F@dubeyko.com>
References: <cover.1390310509.git.andreas.rohner@gmx.net> <85EBEC6B-CA69-472A-8DDD-8E056F809EC4@dubeyko.com> <52E15B9E.6040307@gmx.net> <FC7F25C5-1E72-4DF5-B860-FBCE36E91EAB@dubeyko.com> <52E27651.6070207@gmx.net>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=UlGMn6R5E2l3GTlle6vPr71/y4XABz6VbG+Z0TO/0go=;
	b=Bt/Flmi/GD/bCgfbc8aRWjXfIoXc0ioXdKPbEe9Mq/fAyVqpEyBsdwdlnBXFfOXYlycYYjbHUn8OOSlUyKGBRjX4e1NU5cPbxqf3rd8nZqbIq0fS7nz7O/ziChfXW85P;
In-Reply-To: <52E27651.6070207-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


On Jan 24, 2014, at 5:18 PM, Andreas Rohner wrote:

>>> You have to move the live blocks to a new segment, so you gain only (8
>>> MB - live_blocks) of free space.
>> 
>> You always will have 8 MB after cleaning (garbage collection).  So, all segments
>> are identical from the free space point of view. What does GC check? And how
>> can GC distinguish segments on the basis of free space? All cleaned segments
>> return 8 MB free space for further allocation. So, all used segments will be over
>> any threshold.
> 
> I am sorry if I wasn't clear enough. The invalidated blocks in a segment
> are basically unusable free space, that needs to be garbage collected.
> If you clean a segment you only gain the space of the invalidated
> blocks, from the perspective of the whole file system. Of course the
> whole segment is free after cleaning, but the live blocks were moved
> somewhere else and occupy space there. So from the perspective of the
> whole file system you only really gained the amount of space occupied by
> the invalidated blocks.
> 

I suggest not to use "free blocks" term for the case of invalidated blocks.
Because it is really confusing way. I suppose that we can use term
"invalid blocks" or "dead blocks". But I think that "dead blocks" is not
good way too. Because, from my point of view, invalidated blocks are
blocks that keep previous state of actual blocks. Dead block sounds for
me likewise unusable or bad block.

>>>>> Although no blocks need to be moved, the SUFILE entry of the
>>>>> corresponding segment needs to be updated to avoid an infinite loop.
>>>>> 
>>>>> This is potentially useful for all gc policies, but it is especially
>>>>> beneficial for the timestamp policy.
>>>> 
>>>> I completely misunderstand this statement. What do you mean?
>>> 
>>> Well the timestamp policy always selects the oldest segment. If the
>>> oldest segment is below the threshold it won't be cleaned. If we don't
>>> change the timestamp it will be immediately selected again and it
>>> probably will still be below the threshold and so on in an infinite loop.
>> 
>> I understand your approach. But I misunderstand about what usefulness
>> you are talking. What is it?
>> 
> 
> It helps to avoid unnecessary copy operations of data.

Ok. But how your implementation and approach can be used for timestamp
policy implementation? Is it possible to combine GC policies into hybrid one?

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
