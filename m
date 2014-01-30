From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v3 2/3] nilfs2: add nilfs_sufile_set_suinfo to update
 segment usage
Date: Thu, 30 Jan 2014 16:57:34 +0900 (JST)
Message-ID: <20140130.165734.221580541.konishi.ryusuke@lab.ntt.co.jp>
References: <20140128.100304.163656186.konishi.ryusuke@lab.ntt.co.jp>
	<52E7315D.4040909@gmx.net>
	<20140128.163924.157483560.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140128.163924.157483560.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andreas,
On Tue, 28 Jan 2014 16:39:24 +0900 (JST), Ryusuke Konishi wrote:
> On Tue, 28 Jan 2014 05:26:05 +0100, Andreas Rohner wrote:
>> On 2014-01-28 02:03, Ryusuke Konishi wrote:
>>> On Tue, 28 Jan 2014 00:42:35 +0100, Andreas Rohner wrote:
>>>> On 2014-01-27 20:07, Ryusuke Konishi wrote:
>>>>> On Mon, 27 Jan 2014 10:59:27 +0100, Andreas Rohner wrote:
>>>>>> +			|| (nilfs_suinfo_update_flags(sup) &&
>>>>>> +				(sup->sup_sui.sui_flags &
>>>>>> +				(~0UL << (NILFS_SEGMENT_USAGE_ERROR + 1)))))
>>>>>
>>>>> Ditto. We need to add a definition to nilfs2_fs.h.
>>>>>
>>>>> enum {
>>>>>         NILFS_SEGMENT_USAGE_ACTIVE,
>>>>>         NILFS_SEGMENT_USAGE_DIRTY,
>>>>>         NILFS_SEGMENT_USAGE_ERROR,
>>>>> 	__NR_NILFS_SEGMENT_USAGE_FLAGS
>>>>> };
>>>>>
>>>>> 		    (nilfs_suinfo_update_flags(sup) &&
>>>>> 		     (sup->sup_sui.sui_flags &
>>>>> 		      (~0UL << __NR_NILFS_SEGMENT_USAGE_FLAGS))))
>>>>>
>>>>> By the way, this will dismiss the capability that userland cleaner
>>>>> programs uses the rest of su_flags for their own purpose such as GC
>>>>> optimization.  I think this (rejecting or utilizing it) should be
>>>>> carefully determined.
>>>>>
>>>>> Any comments on this?
>>>>
>>>> Hmm, I think it can't hurt to let the userland cleaner use the su_flags.
>>>> As far as I can tell, it shouldn't affect the kernel side.
>>>> nilfs_segment_usage_set_clean() would still work and
>>>> nilfs_sufile_do_scrap() overwrites the whole su_flags as well.
>>> 
>>> Well, actually the current definition of
>>> nilfs_segment_usage_set_clean() and also nilfs_segment_usage_clean()
>>> are written without compatibility consideration.
>> 
>> I actually thought it would be a good idea to wipe the custom flags if a
>> segment is cleaned, which the current implementation does. So the custom
>> flags are only valid for dirty segments and a segment is only considered
>> to be clean with nilfs_segment_usage_clean if there are no custom flags.
>> I don't think that would be unreasonable, because the GC has no use for
>> flags on clean segments anyway.
> 
> I looked over functions manipulating su_flags again, and came to the
> same conclusion.  We can keep consistency even if userland gc programs
> utilize the remaining flags for their own purpose.  There are no
> compatibility issues at least if we manipulate su_flags of dirty
> segments.  In this regard, the current implementation, which wipes the
> custom flags when it cleans segment, is not bad, yes.
> 
>>> It looks to be a separate change if we allow to use the upper bits.
>>> In that case, a bunch of changes and a new feature_compat_ro flag to
>>> deal it as a disk format change, would be needed.
>> 
>> I think we would only have to define, which flags are reserved for
>> future use and which are available for the userspace GC. Everything else
>> would just work.
> 
> Right.  My above comment is completely wrong.  We don't have to add a
> new feature-compat flag to use custom flags unless we want to use them
> for free segments (in this case, we need to change definition of
> nilfs_segment_usage_clean() and nilfs_segment_usage_set_clean())
> 
>>> Ok, let's take the above one which protects the upper bits for now.
>> 
>> Ok. It is certainly cleaner that way.
> 
> Let me recant my comment.  Let's change the patch to allow custom
> flags.

By the way, can you post the revised version of this series 
(kernel patches) before it gets late ?

I'd like to send these 3 patches to upstream so that they will
be merged into the mainline in the next merge window.

Userland changes can be merged and released early once we finished
review-and-fix process, but it take longer time until kernel patches
are merged and released.

Thanks,
Ryusuke Konishi


>>>>>> +			nilfs_sufile_mod_counter(header_bh, ncleansegs,
>>>>>> +					ndirtysegs);
>>>>>
>>>>> Does it work for a negative value without cast of (u64) ?
>>>>> Please confirm that these counters are updated as you expected.
>>>>>
>>>>>> +			NILFS_SUI(sufile)->ncleansegs += ncleansegs;
>>>>>
>>>>> Ditto.  
>>>>
>>>> I have tested it and it works. At least on my 64 bit architecture. It is
>>>> probably still a good idea to do an explicit cast.
>>>>
>>>> How about I use s64 for ncleaned and ndirtied and move
>>>> nilfs_sufile_mod_counter outside the loop?
>>> 
>>> Yes, this one looks better.  In that case, the u64 cast seems
>>> unnecessary.
>>> 
>>>> 	s64 ncleaned = 0, ndirtied = 0;
>>>>
>>>> 	...
>>>>
>>>> 	for (;;) {
>>>> 		...
>>>> 	}
>>>> 	mark_buffer_dirty(bh);
>>>> 	brelse(bh);
>>>>
>>>>  out_mark:
>>>> 	if (ncleaned || ndirtied) {
>>>> 		nilfs_sufile_mod_counter(header_bh, (u64)ncleaned,
>>>> 				(u64)ndirtied);
>>> 
>>>> 		NILFS_SUI(sufile)->ncleansegs += ncleaned;
>>> 
>>> This one looks unclear.
>>> 
>>> How about defining ncleaned and ndirtied with unsigned long type and
>>> cast them to (u64) for the arguments of nilfs_sufile_mod_counter() ?
>> 
>> Ok I agree ncleansegs could be 32 bit on 32 bit systems. But why
>> "unsigned long" and not just "long"? It seems a bit strange to use an
>> unsigned type for possible negative values and I don't see the problem
>> of adding a negative number to an unsigned type of the same size.
>> 
>> Additionally if we use "unsigned long" wouldn't a typecast to (u64)
>> result in a number like 4294967295 rather than 18446744073709551615,
>> which is equivalent to -1, on a 32 bit system?
> 
> Yes, sorry, I said wrong thing here too.  If we define ncleaned with
> unsigned long type, it must be arithmetically extended when we convert
> it to 64 bit size.  So, casting with "signed long" is needed like
> "(long)ncleaned" before converting it to u64.
> 
>>>> 		NILFS_SUI(sufile)->ncleansegs += ncleaned;
> 
> would be calculated as "unsigned long" even if the type of ncleaned is
> "long" according to the usual arithmetic conversion rule of C99
> (6.3.1.8).  And, in this case, we can omit the above typecast
> "(long)".
> 
> Regards,
> Ryusuke Konishi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
