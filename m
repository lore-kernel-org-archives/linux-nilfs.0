From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v2 9/9] nilfs2: prevent starvation of segments protected
 by snapshots
Date: Sun, 31 May 2015 20:13:44 +0200
Message-ID: <556B4F58.9080801@gmx.net>
References: <1430647522-14304-10-git-send-email-andreas.rohner@gmx.net>	<20150520.234335.542615158366069430.konishi.ryusuke@lab.ntt.co.jp>	<555F70FD.6090500@gmx.net> <20150601.014550.269184778137708369.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150601.014550.269184778137708369.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2015-05-31 18:45, Ryusuke Konishi wrote:
> On Fri, 22 May 2015 20:10:05 +0200, Andreas Rohner wrote:
>> On 2015-05-20 16:43, Ryusuke Konishi wrote:
>>> On Sun,  3 May 2015 12:05:22 +0200, Andreas Rohner wrote:
>>>> It doesn't really matter if the number of reclaimable blocks for a
>>>> segment is inaccurate, as long as the overall performance is better than
>>>> the simple timestamp algorithm and starvation is prevented.
>>>>
>>>> The following steps will lead to starvation of a segment:
>>>>
>>>> 1. The segment is written
>>>> 2. A snapshot is created
>>>> 3. The files in the segment are deleted and the number of live
>>>>    blocks for the segment is decremented to a very low value
>>>> 4. The GC tries to free the segment, but there are no reclaimable
>>>>    blocks, because they are all protected by the snapshot. To prevent an
>>>>    infinite loop the GC has to adjust the number of live blocks to the
>>>>    correct value.
>>>> 5. The snapshot is converted to a checkpoint and the blocks in the
>>>>    segment are now reclaimable.
>>>> 6. The GC will never attempt to clean the segment again, because it
>>>>    looks as if it had a high number of live blocks.
>>>>
>>>> To prevent this, the already existing padding field of the SUFILE entry
>>>> is used to track the number of snapshot blocks in the segment. This
>>>> number is only set by the GC, since it collects the necessary
>>>> information anyway. So there is no need, to track which block belongs to
>>>> which segment. In step 4 of the list above the GC will set the new field
>>>> su_nsnapshot_blks. In step 5 all entries in the SUFILE are checked and
>>>> entries with a big su_nsnapshot_blks field get their su_nlive_blks field
>>>> reduced.
>>>>
>>>> Signed-off-by: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
>>>
>>> I still don't know whether this workaround is the way we should take
>>> or not.  This patch has several drawbacks:
>>>
>>>  1. It introduces overheads to every "chcp cp" operation
>>>     due to traversal rewrite of sufile.
>>>     If the ratio of snapshot protected blocks is high, then
>>>     this overheads will be big.
>>>
>>>  2. The traversal rewrite of sufile will causes many sufile blocks will be
>>>     written out.   If most blocks are protected by a snapshot,
>>>     more than 4MB of sufile blocks will be written per 1TB capacity.
>>>
>>>     Even though this rewrite may not happen for contiguous "chcp cp"
>>>     operations, it still has potential for creating sufile write blocks
>>>     if the application of nilfs manipulates snapshots frequently.
>>
>> I could also implement this functionality in nilfs_cleanerd in
>> userspace. Every time a "chcp cp" happens some kind of permanent flag
>> like "snapshot_was_recently_deleted" is set at an appropriate location.
>> The flag could be returned with GET_SUSTAT ioctl(). Then nilfs_cleanerd
>> would, at certain intervals and if the flag is set, check all segments
>> with GET_SUINFO ioctl() and set the ones that have potentially invalid
>> values with SET_SUINFO ioctl(). After that it would clear the
>> "snapshot_was_recently_deleted" flag. What do you think about this idea?
> 
> Sorry for my late reply.

No problem. I was also very busy last week.

> I think moving the functionality to cleanerd and notifying some sort
> of information to userland through ioctl for that, is a good idea
> except that I feel the ioctl should be GET_CPSTAT instead of
> GET_SUINFO because it's checkpoint/snapshot related information.

Ok good idea.

> I think the parameter that should be added is a set of statistics
> information including the number of deleted snapshots since the file
> system was mounted last (1).  The counter (1) can serve as the
> "snapshot_was_recently_deleted" flag if it monotonically increases.
> Although we can use timestamp of when a snapshot was deleted last
> time, it's not preferable than the counter (1) because the system
> clock may be rewinded and it also has an issue related to precision.

I agree, a counter is better than a simple flag.

> Note that we must add GET_CPSTAT_V2 (or GET_SUSTAT_V2) and the
> corresponding structure (i.e. nilfs_cpstat_v2, or so) since ioctl
> codes depend on the size of argument data and it will be changed in
> both ioctls; unfortunately, neither GET_CPSTAT nor GET_SUSTAT ioctl is
> expandable.  Some ioctls like EVIOCGKEYCODE_V2 will be a reference for
> this issue.
> 
>>
>> If the policy is "timestamp" the GC would of course skip this scan,
>> because it is unnecessary.
>>
>>>  3. The ratio of the threshold "max_segblks" is hard coded to 50%
>>>     of blocks_per_segment.  It is not clear if the ratio is good
>>>     (versatile).
>>
>> The interval and percentage could be set in /etc/nilfs_cleanerd.conf.
>>
>> I chose 50% kind of arbitrarily. My intent was to encourage the GC to
>> check the segment again in the future. I guess anything between 25% and
>> 75% would also work.
> 
> Sound reasonable.
> 
> By the way, I am thinking we should move cleanerd into kernel as soon
> as we can.  It's not only inefficient due to a large amount of data
> exchange between kernel and user-land, but also is hindering changes
> like we are trying.  We have to care compatibility unnecessarily due
> to the early design mistake (i.e. the separation of gc to user-land).

I am a bit confused. Is it OK if I implement this functionality in
nilfs_cleanerd for this patch set, or would it be better to implement it
with a workqueue in the kernel, like you've suggested before?

If you intend to move nilfs_cleanerd into the kernel anyway, then the
latter would make more sense to me. Which implementation do you prefer
for this patch set?

Regards,
Andreas Rohner

> Regards,
> Ryusuke Konishi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
