From: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Subject: Re: Garbage Collection Method
Date: Fri, 27 Jan 2012 19:28:29 +0000
Message-ID: <4F22FADD.40809@bobich.net>
References: <4F215039.4000904@bobich.net>	<20120127160004.GK750@csmith-bm.vm.bytemark.co.uk>	<4F22D02F.1060208@bobich.net> <20120127184759.GM750@csmith-bm.vm.bytemark.co.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120127184759.GM750-Ng8wz+J301SNY5Lh21HnMTHS2PGA244I9dF7HbQ/qKg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 01/27/2012 06:47 PM, Christian Smith wrote:
> On Fri, Jan 27, 2012 at 04:26:23PM +0000, Gordan Bobic wrote:
>> Christian,
>>
>> Many thanks for your reply.
>>
>>>> 1) Does it scan blocks from the tail of the file system forward
>>>> sequentially?
>>>
>>> Yes
>>>
>>>> 2) Does it reclaim blocks regardless of how dirty they are? Or does
>>>> it  execute reclaiming on order of maximum dirtyness first in order
>>>> to  reduce churn (and flash wear when used on flash media)?
>>>
>>> The former.
>>>
>>>> 3) What happens when it encounters a block that isn't dirty? Does it
>>>> skip it and reclaim the next dirty block, leaving a "hole"? Or does
>>>> it  reclaim everything up to a reclaimable block to make the free
>>>> space  contiguous?
>>>
>>> It is cleaned regardless. Free space appears to always be contiguous.
>>
>> Hmm, so the GC causes completely unnecessary flash wear. That's really
>> bad for the most advantageous use-case of nilfs2. :(
>
>
> I work round it by setting my protection period to about 1 day, so
> I know that the whole device will not be written more than once per
> day. Even with 3000 p/e cycle FLASH, that's eight years of use.

Hmm... So the GC is smart enough to stop reclaiming if the next block to 
be checked has a time stamp that is recent enough?

> I find the biggest advantage of NILFS is avoiding the random
> small writes that so quickly wear cheap flash out. Even with the
> GC, I'd wager NILFS still beats ext3 (say) at avoiding write amp
> due to it's more sequential write nature. Not to mention the
> performance gains as a result. Random writes are so slow because
> each random write might be doing a full block erase, which is
> also why their write amp is so bad in the first place. But hey,
> they're cheap and designed for camera like write patterns (
> writing big files in long contiguous chunks.)

Except they are also the main envisaged storage medium for things like 
ARM machines, most of which are capable of replacing an average desktop 
box if only they didn't lack SATA for a proper SSD.

>>>> 4) Assuming this isn't already how it works, how difficult would it
>>>> be  to modify the reclaim policy (along with associated book-keeping
>>>> requirements) to reclaim blocks in the order of dirtiest-block-first?
>>>>
>>>> 5) If a suitable book-keeping bitmap was in place for 4), could this
>>>> not  be used for accurate df reporting?
>>>
>>>
>>> Not being a NILFS developer, I can't answer either of these in detail.
>>>
>>> However, as I understand it, the filesystem driver does not depend on the
>>> current cleaning policy, and can skip cleaning specific blocks should those
>>> blocks be sufficiently clean. Segments need not be written sequentially,
>>> as each segment contains a pointer to the next segment that will be written
>>> and hence why lssu always lists two segments as active (the current segment
>>> and the next segment to be written).
>>>
>>> It's just that the current GC just cleans all segments sequentially. It's
>>> easier to just cycle through the segments in a circular fashion.
>>
>> I see, so the sub-optimal reclaim and unnecessary churn are purely down
>> to the userspace GC daemon?
>>
>> Is there scope for having a bitmap or a counter in each allocation unit
>> to show how many dirty blocks there are in it? Such a bitmap would
>> require 1MB of space for every 32GB of storage (assuming 1 bit per 4KB
>> block). This would allow for being able to tell at a glance which block
>> is dirties and thus should be reclaimed next, while at the same time
>> stopping unnecessary churn.
>
>
> Is 1 bit enough? At what point do you turn the bit on? Half dead segment?
> I can't see 1 bit being useful enough to make the overhead worthwhile.
> Also, we're not just talking about live current data. There is also
> snapshot and checkpoint visible data to consider. Not easy to represent
> with a bitmap.

I'm talking about 1 bit per 4KB block. Hence 1MB per 32GB. Since the 
smallest write size is always going to be 1 block (4KB), there is no 
need to track smaller units. And it also means that a single 4KB block 
is either clean or dirty, and nothing inbetween.

>>> What would be useful is to be able to select the write segment into
>>> which the cleaner will write live data. That way, the system could
>>> maintain two
>>> log "heads", one for active hot data, and one for inactive cold data. Then
>>> all cleaning would be done to the cold head, and all new writes to the hot
>>> head on the assumption that the new write will either be temporary (and
>>> hence discarded sooner rather than later) or not be updated for some time
>>> (and hence cleaned to a cold segment by the cleaner) with the hope that
>>> we'll have a bimodal distribution of clean and dirty data. Then the
>>> cleaner can concentrate on cleaning hot segments, with the occasional
>>> clean
>>> of cold segments.
>>
>> I don't think distinguishing between hot and cold data is all that
>> useful. Ultimately, the optimal solution would be to reclaim the AUs in
>> dirtiest-first order. The other throttling provisions (not reclaiming
>> until free space drops below a threshold) should do enough to stop
>> premature flash wear.
>
> Again, dirtiest first is complicated by the checkpoint/snapshots.

Checkpoinging shouldn't be a problem - you know at which point the data 
to be retained starts, so you you know blocks after that don't need to 
be reclaimed. due to retention policy.

Snapshots might complicate things a little, but no more than the fact 
that the data that is older than retention policy might still be current 
and still cannot be reclaimed. Since we can distinguish between data 
that needs to be retained and the data that can be reclaimed during a 
sequential scan, I don't see why it would be more difficult to make the 
same distinction with a different, more efficient GC scanning order.

>>> Accurate df reporting is more tricky, as checkpoints and snapshots make it
>>> decidedly not trivial to account for overwritten data. As such, the current
>>> df reporting is probably the best we can manage within the current
>>> constraints.
>>
>> With the bitmap solution as described above, would we not be able to
>> simply subtract the dirty blocks from the used space? Since the bitmap
>> always contains the dirtyness information on all the blocks in the FS,
>> this would make for a pretty simple solution, would it not?
>>
>> Is there anything in place that would prevent such a bitmap from being
>> kept in the file system headers? It could even be kept in RAM and
>> generated by the garbage collector for it's own use at run-time,
>> thinking about it, 1MB per 32GB is not a lot (32MB per TB), and it could
>> even be run-length encoded.
>>
>> Right now, even just preventing reallocation of allocation units that
>> are completely clean would be a big advantage in terms of performance
>> and flash wear.
>
>
> I can't see the bitmap being too useful. It can't convey how dirty a segment
> is without more bits, more bits means more data to track. If on disk, it has
> to be managed and itself cleaned. If in the cleaner, the cleaner would
> have to scan the FS quite regularly to build it up, taking up IO bandwidth.

Not at all - each bit refers to a 4KB block, not the 8MB (default size) 
allocation unit.

> However, another option would be to keep a list, in memory, of the dirtiest
> known segments. Whenever a block is rewritten, a count for the old segment is
> incremented, and when the cleaner runs, it can get a list of the dirtiest
> known segments and clean them first, and can decide to clean each segment
> in the list or not depending on the checkpoint protection period on a
> segment by segment basis. Once cleaned, the segment is removed from this
> internal list. The list could be limited in size to perhaps the 128 know
> dirtiest segments, which would provide 1GB worth of cheaply cleaned segments
> for a trivial amount of memory and overhead.

That's an even cheaper heuristic solution, but I doing think bitmaps 
would be a problem if the bits refer to blocks rather than allocation units.

> While such a list would not be persistent across mounts, for a long
> running system it could be big enough to allow the cleaner to pick
> the low hanging fruit without resorting to sequential timestamp
> based clean too often.

Indeed, I was thinking about the same thing for bitmaps. Since reads are 
so close to free that it doesn't matter, you could have a low-priority 
scanning job that kicks assembles the dirtyness data at run time.

Gordan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
