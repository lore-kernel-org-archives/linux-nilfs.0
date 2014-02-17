From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 1/2] nilfs2: add nilfs_sufile_trim_fs to trim clean segs
Date: Mon, 17 Feb 2014 14:51:28 +0100
Message-ID: <530213E0.9020002@gmx.net>
References: <5301E5A8.3080701@gmx.net>	<20140217.202143.05344630.konishi.ryusuke@lab.ntt.co.jp>	<5301F852.8010105@gmx.net> <20140217.222811.27809410.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140217.222811.27809410.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-02-17 14:28, Ryusuke Konishi wrote:
> On Mon, 17 Feb 2014 12:53:54 +0100, Andreas Rohner wrote:
>> On 2014-02-17 12:21, Ryusuke Konishi wrote:
>>> On Mon, 17 Feb 2014 11:34:16 +0100, Andreas Rohner wrote:
>>>> On 2014-02-17 11:06, Ryusuke Konishi wrote:
>>>>> On Mon, 17 Feb 2014 10:17:57 +0100, Andreas Rohner wrote:
>>>>>> On 2014-02-17 04:00, Ryusuke Konishi wrote:
>>>>>>>> +	if (end > nilfs->ns_nsegments)
>>>>>>>> +		end = nilfs->ns_nsegments;
>>>>>>>
>>>>>>> Yes, this adjustment is what we should do here, but 'end' segnum was
>>>>>>> rounded down to segment alighment before.  So, it should be:
>>>>>>>
>>>>>>>   if (end >= nilfs->ns_nsegments)
>>>>>>> 	end = nilfs->ns_nsegments - 1;
>>>>>>>
>>>>>>>> +	if (end == segnum)
>>>>>>>> +		goto out;
>>>>>>>
>>>>>>> and
>>>>>>>
>>>>>>>   if (end < segnum)
>>>>>>> 	goto out;
>>>>>>>
>>>>>>>> +
>>>>>>>> +	down_read(&NILFS_MDT(sufile)->mi_sem);
>>>>>>>> +
>>>>>>>> +	while (segnum < end) {
>>>>>>>
>>>>>>> and
>>>>>>>
>>>>>>>   while (segnum <= end) {
>>>>>>>
>>>>>>>> +		n = min_t(unsigned long,
>>>>>>>> +			  segusages_per_block -
>>>>>>>> +				  nilfs_sufile_get_offset(sufile, segnum),
>>>>>>>> +			  end - segnum);
>>>>>>>
>>>>>>> Then, we can reuse nilfs_sufile_segment_usages_in_block() to calculate
>>>>>>> 'n'.
>>>>>>
>>>>>> Actually I don't think that is correct. What if range->start = 0 and
>>>>>> range->end = 8MB. Then segnum = 0 and end = 1. Your code would discard
>>>>>> segment 0 and segment 1, whereas my version would discard only segment
>>>>>> 0, which seems to be more reasonable.
>>>>>
>>>>> The problem seems that 'end' is not calculated properly.
>>>>> I think it should be
>>>>>
>>>>> end = nilfs_get_segnum_of_block(
>>>>> 		nilfs,
>>>>> 		(range->start + range->len + <segment-size-in-bytes> - 1)
>>>>> 		  >> nilfs->ns_blocksize_bits) - 1;
>>>>>
>>>>>  or can be simplified to
>>>>>
>>>>> end = nilfs_get_segnum_of_block(
>>>>> 		nilfs,
>>>>> 		(range->start + range->len - 1) >> nilfs->ns_blocksize_bits);
>>>>>
>>>>>  if range->len > 0 is guaranteed.
>>>>>
>>>>>
>>>>> The calculation of segnum extends the range to be discarded since it
>>>>> is rounded down to segment alignment, but that of the current
>>>>> implementation for 'end' truncates the range.  Both should be
>>>>> extended.
>>>>
>>>> Then shouldn't both be truncated? The user expects that less bytes than
>>>> range->len are discarded but not more. Maybe I am wrong and it is
>>>> defined somewhere...
>>>
>>> Uum, xfs looks to be truncating both.  This seems to be authentic
>>> when we think the original meaning of the fitrim range.
>>>
>>> I first thought truncating the range can generate gaps between
>>> consecutive calls of FITRIM (if we use FITRIM like that).
>>
>> Hmm good point I didn't think of that. Then by extending both sides the
>> overlapping segments would get discarded twice with consecutive calls,
>> which shouldn't be a problem.
>>
>>> But now I'm
>>> tempted to take the xfs approach.  Let's take this semantics.
>>>
>>> So, we now have to round up range->start to calculate (start) segnum.
>>
>> Ok. I think in the end it doesn't really matter, because most users will
>> use the default values:
>>
>> range->start = 0
>> range->minlen = 0
>> range->len = ULLONG_MAX
> 
> Or, we have the third option to avoid this issue.  It's simply
> truncating both to sector boundary.  In this case, the gap problem
> will not arise since userland programs usually separate the range
> considering sector boundary or file system block size boundary.  I
> think this is more preferable than truncating it to segment size.
> 
> How do you think of this ?

Yes I think that is a good idea. It shouldn't be hard to implement
either. I will try it and then send you a new version of the patch.

Regards,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
