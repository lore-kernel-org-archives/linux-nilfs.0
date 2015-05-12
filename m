From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 8/9] nilfs2: correct live block tracking for GC protection
 period
Date: Tue, 12 May 2015 17:37:27 +0200
Message-ID: <55521E37.7040805@gmx.net>
References: <1430647522-14304-9-git-send-email-andreas.rohner@gmx.net>	<20150511.031512.1036934606749624197.konishi.ryusuke@lab.ntt.co.jp>	<5550A7FC.4050709@gmx.net> <20150512.233126.2206330706583570566.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150512.233126.2206330706583570566.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2015-05-12 16:31, Ryusuke Konishi wrote:
> On Mon, 11 May 2015 15:00:44 +0200, Andreas Rohner wrote:
>> On 2015-05-10 20:15, Ryusuke Konishi wrote:
>>> On Sun,  3 May 2015 12:05:21 +0200, Andreas Rohner wrote:
>>>  - The logic of isreclaimable is counterintuitive.  
>>>
>>>> +	bool isreclaimable = buffer_nilfs_period_protected(bh) ||
>>>> +				nilfs_dat_is_live(dat, bh->b_blocknr) <= 0;
>>>
>>>    It looks like buffer_nilfs_period_protected(bh) here implies that
>>>    the block is deleted.  But it's independent from the buffer is
>>>    protected by protection_period or not.
>>
>> It is not independent. buffer_nilfs_period_protected() is only set for
>> deleted/reclaimable blocks that have to be copied because of the
>> protection period. So if the flag is set, then the block is always
>> reclaimable.
> 
> That is why it's confusing.
> Recall that we do not reclaim both deleted blocks and alive blocks 
> if they are protected by protection_period.
> 
> This naming and logic, by contries, treats period_protected blocks are
> "reclaimable".  That's the principal cause of this confusion.
> 
>>
>>>    Why not just adding "still alive" or "deleted" flag and its
>>>    corresponding vdesc flag instead of adding the period protected
>>>    flag ?
>>>
>>>    If we add the "still alive" flag, which means that the block is
>>>    not yet deleted from the latest checkpoint, then this function
>>>    can be simplified as follows:
>>
>> I think buffer_nilfs_period_protected(bh) is a better name.
>>
>> It does not mark all blocks within the protection period. Live blocks
>> within the protection period do not have this flag set.
> 
> I know.  That is my discussion point.
> 
>> It marks exactly
>> those blocks that are dead and reclaimable but protected from being
>> discarded by the protection period.
>> The protection period is key.
>> Without the protection period those blocks would not have been copied.
>> That is the exact meaning of the flag, and I think the name fits quite well.
> 
> I say that the flagging is confusing.  It's not simple (nor clear) at
> all.
> 
> Copied blocks by GC can have some properties.  For instance,
> 
>  1. snapshot protected  (guarded by one or more snapshots)
>  2. period protected  (guarded by protection_period)
>  3. deleted  (protected but isn't surviving on the latest checkpoint)
> 
> Among these, the property 2 does not relate to your live block
> counting algorithm; your live block counting algorithm uses
> property 1 and property 3 in reality.
> 
> If the algorithm counts the buffer marked "period protected" as alive
> and prevents nlive_blks count from being decremented, then I agree it
> "uses" the property 2.  But this patch doesn't
> 
> You are giving the property 2 to the period protection flag, and
> making it imply the property 3, which is intrinsically independent of
> the property 2.  And, are using the implication (property 3) instead
> of the title property 2.
> 
> Please think about it once again.

Thank you for the detailed explanation of your reasoning. I can see now
that it could be confusing. Maybe I have just gotten used to calling it
"period_protected". I will change the name to "deleted" in the next
version of the patch.

Regards,
Andreas Rohner

> Regards,
> Ryusuke Konishi
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
